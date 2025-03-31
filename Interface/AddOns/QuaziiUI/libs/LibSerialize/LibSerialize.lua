--[[
Copyright (c) 2020 Ross Nichols

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

Credits:
The following projects served as inspiration for aspects of this project:

1. LibDeflate, by Haoqian He. https://github.com/SafeteeWoW/LibDeflate
    For the CreateReader/CreateWriter functions.
2. lua-MessagePack, by François Perrad. https://framagit.org/fperrad/lua-MessagePack
    For the mechanism for packing/unpacking floats and ints.
3. LibQuestieSerializer, by aero. https://github.com/AeroScripts/LibQuestieSerializer
    For the basis of the implementation, and initial inspiration.
]]


-- Latest version can be found at https://github.com/rossnichols/LibSerialize.


local MAJOR, MINOR = "LibSerialize", 5
local LibSerialize
if LibStub then
    LibSerialize = LibStub:NewLibrary(MAJOR, MINOR)
    if not LibSerialize then return end -- This version is already loaded.
else
    LibSerialize = {}
end

-- Rev the serialization version when making a breaking change.
-- Make sure to handle older versions properly within LibSerialize:DeserializeValue.
-- NOTE: these normally can be idential, but due to a bug when revving MINOR to 2,
-- we need to support both 1 and 2 as v1 serialization versions.
local DESERIALIZATION_VERSION = 2


--[[---------------------------------------------------------------------------
    Local overrides of otherwise global library functions
--]]---------------------------------------------------------------------------

local assert = assert
local coroutine_create = coroutine.create
local coroutine_resume = coroutine.resume
local coroutine_status = coroutine.status
local coroutine_yield = coroutine.yield
local error = error
local getmetatable = getmetatable
local ipairs = ipairs
local math_floor = math.floor
local math_huge = math.huge
local math_max = math.max
local math_modf = math.modf
local pairs = pairs
local pcall = pcall
local print = print
local select = select
local setmetatable = setmetatable
local string_byte = string.byte
local string_char = string.char
local string_sub = string.sub
local table_concat = table.concat
local table_insert = table.insert
local table_sort = table.sort
local tonumber = tonumber
local tostring = tostring
local type = type

-- Compatibility shim to allow the library to work on Lua 5.4
local unpack = unpack or table.unpack
local frexp = math.frexp or function(num)
    if num == math_huge then return num end
    local fraction, exponent = num, 0
    if fraction ~= 0 then
        while fraction >= 1 do
            fraction = fraction / 2
            exponent = exponent + 1
        end
        while fraction < 0.5 do
            fraction = fraction * 2
            exponent = exponent - 1
        end
    end
    return fraction, exponent
end
local ldexp = math.ldexp or function(m, e)
    return m * 2 ^ e
end

-- If in an environment that supports `require` and `_ENV` (note: WoW does not),
-- then block reading/writing of globals. All needed globals should have been
-- converted to upvalues above.
if require and _ENV then
    _ENV = setmetatable({}, {
        __newindex = function(t, k, v)
            assert(false, "Attempt to write to global variable: " .. k)
        end,
        __index = function(t, k)
            assert(false, "Attempt to read global variable: " .. k)
        end
    })
end


--[[---------------------------------------------------------------------------
    Library defaults.
--]]---------------------------------------------------------------------------

local defaultYieldCheck = function(self)
    self._currentObjectCount = self._currentObjectCount or 0
    if self._currentObjectCount > 4096 then
        self._currentObjectCount = 0
        return true
    end
    self._currentObjectCount = self._currentObjectCount + 1
end
local defaultSerializeOptions = {
    errorOnUnserializableType = true,
    stable = false,
    filter = nil,
    writer = nil,
    async = false,
    yieldCheck = defaultYieldCheck,
}
local defaultAsyncOptions = {
    async = true,
}
local defaultDeserializeOptions = {
    async = false,
    yieldCheck = defaultYieldCheck,
}

local canSerializeFnOptions = {
    errorOnUnserializableType = false
}


--[[---------------------------------------------------------------------------
    Helper functions.
--]]---------------------------------------------------------------------------

-- Returns the number of bytes required to store the value,
-- up to a maximum of three. Errors if three bytes is insufficient.
local function GetRequiredBytes(value)
    if value < 256 then return 1 end
    if value < 65536 then return 2 end
    if value < 16777216 then return 3 end
    error("Object limit exceeded")
end

-- Returns the number of bytes required to store the value,
-- though always returning seven if four bytes is insufficient.
-- Doubles have room for 53bit numbers, so seven bits max.
local function GetRequiredBytesNumber(value)
    if value < 256 then return 1 end
    if value < 65536 then return 2 end
    if value < 16777216 then return 3 end
    if value < 4294967296 then return 4 end
    return 7
end

-- Queries a given object for the value assigned to a specific key.
--
-- If the given object cannot be indexed, an error may be raised by the Lua
-- implementation.
local function GetValueByKey(object, key)
    return object[key]
end

-- Queries a given object for the value assigned to a specific key, returning
-- it if non-nil or giving back a default.
--
-- If the given object cannot be indexed, the default will be returned and
-- no error raised.
local function GetValueByKeyOrDefault(object, key, default)
    local ok, value = pcall(GetValueByKey, object, key)

    if not ok or value == nil then
        return default
    else
        return value
    end
end

-- Returns whether the value (a number) is NaN.
local function IsNaN(value)
    -- With floating point optimizations enabled all comparisons involving
    -- NaNs will return true. Without them, these will both return false.
    return (value < 0) == (value >= 0)
end

-- Returns whether the value (a number) is finite, as opposed to being a
-- NaN or infinity.
local function IsFinite(value)
    return value > -math_huge and value < math_huge and not IsNaN(value)
end

-- Returns whether the value (a number) is fractional,
-- as opposed to a whole number.
local function IsFractional(value)
    local _, fract = math_modf(value)
    return fract ~= 0
end

-- Returns whether the value (a number) needs to be represented as a floating
-- point number due to either being fractional or non-finite.
local function IsFloatingPoint(value)
    return IsFractional(value) or not IsFinite(value)
end

-- Returns true if the given table key is an integer that can reside in the
-- array section of a table (keys 1 through arrayCount).
local function IsArrayKey(k, arrayCount)
    return type(k) == "number" and k >= 1 and k <= arrayCount and not IsFloatingPoint(k)
end

-- Portable no-op function that does absolutely nothing, and pushes no returns
-- onto the stack.
local function Noop()
end

-- Sort compare function which is used to sort table keys to ensure that the
-- serialization of maps is stable. We arbitrarily put strings first, then
-- numbers, and finally booleans.
local function StableKeySort(a, b)
    local aType = type(a)
    local bType = type(b)
    -- Put strings first
    if aType == "string" and bType == "string" then
        return a < b
    elseif aType == "string" then
        return true
    elseif bType == "string" then
        return false
    end
    -- Put numbers next
    if aType == "number" and bType == "number" then
        return a < b
    elseif aType == "number" then
        return true
    elseif bType == "number" then
        return false
    end
    -- Put booleans last
    if aType == "boolean" and bType == "boolean" then
        return (a and 1 or 0) < (b and 1 or 0)
    else
        error(("Unhandled sort type(s): %s, %s"):format(aType, bType))
    end
end

-- Prints args to the chat window. To enable debug statements,
-- do a find/replace in this file with "-- DebugPrint(" for "DebugPrint(",
-- or the reverse to disable them again.
local DebugPrint = function(...)
    print(...)
end


--[[---------------------------------------------------------------------------
    Helpers for reading/writing streams of bytes from/to a string
--]]---------------------------------------------------------------------------

-- Generic writer functions that defer their work to previously defined helpers.
local function Writer_WriteString(self, str)
    if self.opts.async and self.opts.yieldCheck(self.asyncScratch) then
        coroutine_yield()
    end

    self.writeString(self.writer, str)
end

local function Writer_FlushWriter(self)
    return self.flushWriter(self.writer)
end

-- Functions for a writer that will lazily construct a string over multiple writes.
local function BufferedWriter_WriteString(self, str)
    self.bufferSize = self.bufferSize + 1
    self.buffer[self.bufferSize] = str
end

local function BufferedWriter_FlushBuffer(self)
    local flushed = table_concat(self.buffer, "", 1, self.bufferSize)
    self.bufferSize = 0
    return flushed
end

-- Creates a writer object that will be called to write the serialized output.
-- Return values:
-- 1. Writer object
-- 2. WriteString(obj, str)
-- 3. FlushWriter(obj)
local function CreateWriter(opts)
    -- If the supplied object implements the required functions to satisfy
    -- the Writer interface, it will be used exclusively. Otherwise if any
    -- of those are missing, the object is entirely ignored and we'll use
    -- the original buffer-of-strings approach.

    local object = {
        opts = opts,
        asyncScratch = opts.async and {} or nil,
    }

    local writeString = GetValueByKeyOrDefault(opts.writer, "WriteString", nil)

    if writeString == nil then
        -- Configure the object for the BufferedWriter approach.
        object.writer = object
        object.buffer = {}
        object.bufferSize = 0
        object.writeString = BufferedWriter_WriteString
        object.flushWriter = BufferedWriter_FlushBuffer
    else
        -- Note that for custom writers if no Flush implementation is given the
        -- default is a no-op; this means that no values will be returned to the
        -- caller of Serialize/SerializeEx. It's expected in such a case that
        -- you will have written the strings elsewhere yourself; perhaps having
        -- already submitted them for transmission via a comms API for example.

        object.writer = opts.writer
        object.writeString = writeString
        object.flushWriter = GetValueByKeyOrDefault(opts.writer, "Flush", Noop)
    end

    return object, Writer_WriteString, Writer_FlushWriter
end

-- Generic reader functions that defer their work to previously defined helpers.
local function Reader_ReadBytes(self, bytelen)
    if self.opts.async and self.opts.yieldCheck(self.asyncScratch) then
        coroutine_yield()
    end

    local result = self.readBytes(self.input, self.nextPos, self.nextPos + bytelen - 1)
    self.nextPos = self.nextPos + bytelen
    return result
end

local function Reader_AtEnd(self)
    return self.atEnd(self.input, self.nextPos)
end

-- Implements the default end-of-stream check for a reader. This requires
-- that the supplied input object supports the length operator.
local function GenericReader_AtEnd(input, offset)
    return offset > #input
end

-- Creates a reader object that will be called to read the to-be-deserialized input.
-- Return values:
-- 1. Reader object
-- 2. ReadBytes(bytelen)
-- 3. ReaderAtEnd()
local function CreateReader(input, opts)
    -- We allow any type of input to be given and queried for the custom
    -- reader interface; any errors that arise when attempting to index these
    -- fields are swallowed silently with fallbacks to suitable defaults.

    local object = {
        input = input,
        nextPos = 1,
        opts = opts,
        asyncScratch = opts.async and {} or nil,
        readBytes = GetValueByKeyOrDefault(input, "ReadBytes", string_sub),
        atEnd = GetValueByKeyOrDefault(input, "AtEnd", GenericReader_AtEnd),
    }

    return object, Reader_ReadBytes, Reader_AtEnd
end


--[[---------------------------------------------------------------------------
    Helpers for serializing/deserializing numbers (ints and floats)
--]]---------------------------------------------------------------------------

local function FloatToString(n)
    if IsNaN(n) then -- nan
        return string_char(0xFF, 0xF8, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00)
    end

    local sign = 0
    if n < 0.0 then
        sign = 0x80
        n = -n
    end
    local mant, expo = frexp(n)

    -- If n is infinity, mant will be infinity inside WoW, but NaN elsewhere.
    if (mant == math_huge or IsNaN(mant)) or expo > 0x400 then
        if sign == 0 then -- inf
            return string_char(0x7F, 0xF0, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00)
        else -- -inf
            return string_char(0xFF, 0xF0, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00)
        end
    elseif (mant == 0.0 and expo == 0) or expo < -0x3FE then -- zero
        return string_char(sign, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00)
    else
        expo = expo + 0x3FE
        mant = math_floor((mant * 2.0 - 1.0) * ldexp(0.5, 53))
        return string_char(sign + math_floor(expo / 0x10),
                           (expo % 0x10) * 0x10 + math_floor(mant / 281474976710656),
                           math_floor(mant / 1099511627776) % 256,
                           math_floor(mant / 4294967296) % 256,
                           math_floor(mant / 16777216) % 256,
                           math_floor(mant / 65536) % 256,
                           math_floor(mant / 256) % 256,
                           mant % 256)
    end
end

local function StringToFloat(str)
    local b1, b2, b3, b4, b5, b6, b7, b8 = string_byte(str, 1, 8)
    local sign = b1 > 0x7F
    local expo = (b1 % 0x80) * 0x10 + math_floor(b2 / 0x10)
    local mant = ((((((b2 % 0x10) * 256 + b3) * 256 + b4) * 256 + b5) * 256 + b6) * 256 + b7) * 256 + b8
    if sign then
        sign = -1
    else
        sign = 1
    end
    local n
    if mant == 0 and expo == 0 then
        n = sign * 0.0
    elseif expo == 0x7FF then
        if mant == 0 then
            n = sign * math_huge
        else
            n = 0.0/0.0
        end
    else
        n = sign * ldexp(1.0 + mant / 4503599627370496.0, expo - 0x3FF)
    end
    return n
end

local function IntToString(n, required)
    if required == 1 then
        return string_char(n)
    elseif required == 2 then
        return string_char(math_floor(n / 256),
                           n % 256)
    elseif required == 3 then
        return string_char(math_floor(n / 65536),
                           math_floor(n / 256) % 256,
                           n % 256)
    elseif required == 4 then
        return string_char(math_floor(n / 16777216),
                           math_floor(n / 65536) % 256,
                           math_floor(n / 256) % 256,
                           n % 256)
    elseif required == 7 then
        return string_char(math_floor(n / 281474976710656) % 256,
                           math_floor(n / 1099511627776) % 256,
                           math_floor(n / 4294967296) % 256,
                           math_floor(n / 16777216) % 256,
                           math_floor(n / 65536) % 256,
                           math_floor(n / 256) % 256,
                           n % 256)
    end

    error("Invalid required bytes: " .. required)
end

local function StringToInt(str, required)
    if required == 1 then
        return string_byte(str)
    elseif required == 2 then
        local b1, b2 = string_byte(str, 1, 2)
        return b1 * 256 + b2
    elseif required == 3 then
        local b1, b2, b3 = string_byte(str, 1, 3)
        return (b1 * 256 + b2) * 256 + b3
    elseif required == 4 then
        local b1, b2, b3, b4 = string_byte(str, 1, 4)
        return ((b1 * 256 + b2) * 256 + b3) * 256 + b4
    elseif required == 7 then
        local b1, b2, b3, b4, b5, b6, b7, b8 = 0, string_byte(str, 1, 7)
        return ((((((b1 * 256 + b2) * 256 + b3) * 256 + b4) * 256 + b5) * 256 + b6) * 256 + b7) * 256 + b8
    end

    error("Invalid required bytes: " .. required)
end


--[[---------------------------------------------------------------------------
    Internal functionality:
    The `LibSerializeInt` table contains internal, immutable state (functions, tables)
    that is copied to a new table each time serialization/deserialization is
    invoked, so that each invocation has its own state encapsulated. Copying the
    state is preferred to a metatable, since we don't want to pay the cost of the
    indirection overhead every time we access one of the copied keys.
--]]---------------------------------------------------------------------------

local LibSerializeInt = {}


local function CreateDeserializer(input, opts)
    local deser = {}

    -- Copy the state from LibSerializeInt.
    for k, v in pairs(LibSerializeInt) do
        deser[k] = v
    end

    -- Initialize string/table reference storage.
    deser._stringRefs = {}
    deser._tableRefs = {}

    -- Create a combined options table, starting with the defaults
    -- and then overwriting any user-supplied keys.
    deser._opts = {}
    for k, v in pairs(defaultDeserializeOptions) do
        deser._opts[k] = v
    end
    for k, v in pairs(opts) do
        deser._opts[k] = v
    end

    -- Create the reader.
    deser._reader, deser._readBytes, deser._readerAtEnd = CreateReader(input, deser._opts)

    return deser
end

local function Deserialize(deser)
    -- Since there's only one compression version currently,
    -- no extra work needs to be done to decode the data.
    local version = deser:_ReadByte()
    assert(version <= DESERIALIZATION_VERSION, "Unknown serialization version!")

    -- Since the objects we read may be nil, we need to explicitly
    -- track the number of results and assign by index so that we
    -- can call unpack() successfully at the end.
    local output = {}
    local outputSize = 0

    while not deser._readerAtEnd(deser._reader) do
        outputSize = outputSize + 1
        output[outputSize] = deser:_ReadObject()
    end

    return unpack(output, 1, outputSize)
end

local function CheckDeserializationProgress(thread, co_success, ...)
    if not co_success then
        return true, false, ...
    elseif coroutine_status(thread) ~= "dead" then
        return false
    else
        return true, true, ...
    end
end


--[[---------------------------------------------------------------------------
    Object reuse:
    As strings/tables are serialized or deserialized, they are stored in a lookup
    table in case they're encountered again, at which point they can be referenced
    by their index into their table rather than repeating the string contents.
--]]---------------------------------------------------------------------------

function LibSerializeInt:_AddReference(refs, value)
    local ref = #refs + 1
    refs[ref] = value
    refs[value] = ref
end


--[[---------------------------------------------------------------------------
    Read (deserialization) support.
--]]---------------------------------------------------------------------------

function LibSerializeInt:_ReadObject()
    local value = self:_ReadByte()

    if value % 2 == 1 then
        -- Number embedded in the top 7 bits.
        local num = (value - 1) / 2
        -- DebugPrint("Found embedded number (1byte):", value, num)
        return num
    end

    if value % 4 == 2 then
        -- Type with embedded count. Extract both.
        -- The type is in bits 3-4, count in 5-8.
        local typ = (value - 2) / 4
        local count = (typ - typ % 4) / 4
        typ = typ % 4
        -- DebugPrint("Found type with embedded count:", value, typ, count)
        return self._EmbeddedReaderTable[typ](self, count)
    end

    if value % 8 == 4 then
        -- Number embedded in the top 4 bits, plus an additional byte's worth (so 12 bits).
        -- If bit 4 is set, the number is negative.
        local packed = self:_ReadByte() * 256 + value
        local num
        if value % 16 == 12 then
            num = -(packed - 12) / 16
        else
            num = (packed - 4) / 16
        end
        -- DebugPrint("Found embedded number (2bytes):", value, packed, num)
        return num
    end

    -- Otherwise, the type index is embedded in the upper 5 bits.
    local typ = value / 8
    -- DebugPrint("Found type:", value, typ)
    return self._ReaderTable[typ](self)
end

function LibSerializeInt:_ReadTable(entryCount, value)
    -- DebugPrint("Extracting keys/values for table:", entryCount)

    if value == nil then
        value = {}
        self:_AddReference(self._tableRefs, value)
    end

    for _ = 1, entryCount do
        local k, v = self:_ReadPair(self._ReadObject)
        value[k] = v
    end

    return value
end

function LibSerializeInt:_ReadArray(entryCount, value)
    -- DebugPrint("Extracting values for array:", entryCount)

    if value == nil then
        value = {}
        self:_AddReference(self._tableRefs, value)
    end

    for i = 1, entryCount do
        value[i] = self:_ReadObject()
    end

    return value
end

function LibSerializeInt:_ReadMixed(arrayCount, mapCount)
    -- DebugPrint("Extracting values for mixed table:", arrayCount, mapCount)

    local value = {}
    self:_AddReference(self._tableRefs, value)

    self:_ReadArray(arrayCount, value)
    self:_ReadTable(mapCount, value)

    return value
end

function LibSerializeInt:_ReadString(len)
    -- DebugPrint("Reading string,", len)

    local value = self._readBytes(self._reader, len)
    if len > 2 then
        self:_AddReference(self._stringRefs, value)
    end
    return value
end

function LibSerializeInt:_ReadByte()
    -- DebugPrint("Reading byte")

    return self:_ReadInt(1)
end

function LibSerializeInt:_ReadInt(required)
    -- DebugPrint("Reading int", required)

    return StringToInt(self._readBytes(self._reader, required), required)
end

function LibSerializeInt:_ReadPair(fn, ...)
    local first = fn(self, ...)
    local second = fn(self, ...)
    return first, second
end

local embeddedIndexShift = 4
local embeddedCountShift = 16
LibSerializeInt._EmbeddedIndex = {
    STRING = 0,
    TABLE = 1,
    ARRAY = 2,
    MIXED = 3,
}
LibSerializeInt._EmbeddedReaderTable = {
    [LibSerializeInt._EmbeddedIndex.STRING] = function(self, c) return self:_ReadString(c) end,
    [LibSerializeInt._EmbeddedIndex.TABLE] =  function(self, c) return self:_ReadTable(c) end,
    [LibSerializeInt._EmbeddedIndex.ARRAY] =  function(self, c) return self:_ReadArray(c) end,
    -- For MIXED, the 4-bit count contains two 2-bit counts that are one less than the true count.
    [LibSerializeInt._EmbeddedIndex.MIXED] =  function(self, c) return self:_ReadMixed((c % 4) + 1, math_floor(c / 4) + 1) end,
}

local readerIndexShift = 8
LibSerializeInt._ReaderIndex = {
    NIL = 0,

    NUM_16_POS = 1,
    NUM_16_NEG = 2,
    NUM_24_POS = 3,
    NUM_24_NEG = 4,
    NUM_32_POS = 5,
    NUM_32_NEG = 6,
    NUM_64_POS = 7,
    NUM_64_NEG = 8,
    NUM_FLOAT = 9,
    NUM_FLOATSTR_POS = 10,
    NUM_FLOATSTR_NEG = 11,

    BOOL_T = 12,
    BOOL_F = 13,

    STR_8 = 14,
    STR_16 = 15,
    STR_24 = 16,

    TABLE_8 = 17,
    TABLE_16 = 18,
    TABLE_24 = 19,

    ARRAY_8 = 20,
    ARRAY_16 = 21,
    ARRAY_24 = 22,

    MIXED_8 = 23,
    MIXED_16 = 24,
    MIXED_24 = 25,

    STRINGREF_8 = 26,
    STRINGREF_16 = 27,
    STRINGREF_24 = 28,

    TABLEREF_8 = 29,
    TABLEREF_16 = 30,
    TABLEREF_24 = 31,
}
LibSerializeInt._ReaderTable = {
    -- Nil
    [LibSerializeInt._ReaderIndex.NIL]  = function(self) return nil end,

    -- Numbers (ones requiring <=12 bits are handled separately)
    [LibSerializeInt._ReaderIndex.NUM_16_POS] = function(self) return self:_ReadInt(2) end,
    [LibSerializeInt._ReaderIndex.NUM_16_NEG] = function(self) return -self:_ReadInt(2) end,
    [LibSerializeInt._ReaderIndex.NUM_24_POS] = function(self) return self:_ReadInt(3) end,
    [LibSerializeInt._ReaderIndex.NUM_24_NEG] = function(self) return -self:_ReadInt(3) end,
    [LibSerializeInt._ReaderIndex.NUM_32_POS] = function(self) return self:_ReadInt(4) end,
    [LibSerializeInt._ReaderIndex.NUM_32_NEG] = function(self) return -self:_ReadInt(4) end,
    [LibSerializeInt._ReaderIndex.NUM_64_POS] = function(self) return self:_ReadInt(7) end,
    [LibSerializeInt._ReaderIndex.NUM_64_NEG] = function(self) return -self:_ReadInt(7) end,
    [LibSerializeInt._ReaderIndex.NUM_FLOAT]  = function(self) return StringToFloat(self._readBytes(self._reader, 8)) end,
    [LibSerializeInt._ReaderIndex.NUM_FLOATSTR_POS]  = function(self) return tonumber(self._readBytes(self._reader, self:_ReadByte())) end,
    [LibSerializeInt._ReaderIndex.NUM_FLOATSTR_NEG]  = function(self) return -tonumber(self._readBytes(self._reader, self:_ReadByte())) end,

    -- Booleans
    [LibSerializeInt._ReaderIndex.BOOL_T] = function(self) return true end,
    [LibSerializeInt._ReaderIndex.BOOL_F] = function(self) return false end,

    -- Strings (encoded as size + buffer)
    [LibSerializeInt._ReaderIndex.STR_8]  = function(self) return self:_ReadString(self:_ReadByte()) end,
    [LibSerializeInt._ReaderIndex.STR_16] = function(self) return self:_ReadString(self:_ReadInt(2)) end,
    [LibSerializeInt._ReaderIndex.STR_24] = function(self) return self:_ReadString(self:_ReadInt(3)) end,

    -- Tables (encoded as count + key/value pairs)
    [LibSerializeInt._ReaderIndex.TABLE_8]  = function(self) return self:_ReadTable(self:_ReadByte()) end,
    [LibSerializeInt._ReaderIndex.TABLE_16] = function(self) return self:_ReadTable(self:_ReadInt(2)) end,
    [LibSerializeInt._ReaderIndex.TABLE_24] = function(self) return self:_ReadTable(self:_ReadInt(3)) end,

    -- Arrays (encoded as count + values)
    [LibSerializeInt._ReaderIndex.ARRAY_8]  = function(self) return self:_ReadArray(self:_ReadByte()) end,
    [LibSerializeInt._ReaderIndex.ARRAY_16] = function(self) return self:_ReadArray(self:_ReadInt(2)) end,
    [LibSerializeInt._ReaderIndex.ARRAY_24] = function(self) return self:_ReadArray(self:_ReadInt(3)) end,

    -- Mixed arrays/maps (encoded as arrayCount + mapCount + arrayValues + key/value pairs)
    [LibSerializeInt._ReaderIndex.MIXED_8]  = function(self) return self:_ReadMixed(self:_ReadPair(self._ReadByte)) end,
    [LibSerializeInt._ReaderIndex.MIXED_16] = function(self) return self:_ReadMixed(self:_ReadPair(self._ReadInt, 2)) end,
    [LibSerializeInt._ReaderIndex.MIXED_24] = function(self) return self:_ReadMixed(self:_ReadPair(self._ReadInt, 3)) end,

    -- Previously referenced strings
    [LibSerializeInt._ReaderIndex.STRINGREF_8]  = function(self) return self._stringRefs[self:_ReadByte()] end,
    [LibSerializeInt._ReaderIndex.STRINGREF_16] = function(self) return self._stringRefs[self:_ReadInt(2)] end,
    [LibSerializeInt._ReaderIndex.STRINGREF_24] = function(self) return self._stringRefs[self:_ReadInt(3)] end,

    -- Previously referenced tables
    [LibSerializeInt._ReaderIndex.TABLEREF_8]  = function(self) return self._tableRefs[self:_ReadByte()] end,
    [LibSerializeInt._ReaderIndex.TABLEREF_16] = function(self) return self._tableRefs[self:_ReadInt(2)] end,
    [LibSerializeInt._ReaderIndex.TABLEREF_24] = function(self) return self._tableRefs[self:_ReadInt(3)] end,
}

--[[---------------------------------------------------------------------------
    API support.
--]]---------------------------------------------------------------------------

function LibSerialize:DeserializeValue(input, opts)
    opts = opts or defaultDeserializeOptions
    local deser = CreateDeserializer(input, opts)

    if opts.async then
        local thread = coroutine_create(Deserialize)
        return function()
            return CheckDeserializationProgress(thread, coroutine_resume(thread, deser))
        end
    else
        return Deserialize(deser)
    end
end

function LibSerialize:Deserialize(input)
    return pcall(self.DeserializeValue, self, input)
end

function LibSerialize:DeserializeAsync(input, opts)
    opts = opts or defaultAsyncOptions
    opts.async = true
    return self:DeserializeValue(input, opts)
end

return LibSerialize

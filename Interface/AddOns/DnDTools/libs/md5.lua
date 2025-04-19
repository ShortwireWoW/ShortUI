-- From: https://gist.github.com/catwell/cb9e6d9652c4b383a140 (public domain)

-- MD5 implementation in pure Lua
-- WoW safe

local md5 = {}

local floor = math.floor
local char, byte = string.char, string.byte
local band, bor, bxor, bnot, rshift, lshift = bit.band, bit.bor, bit.bxor, bit.bnot, bit.rshift, bit.lshift

local function str2blks_md5(str)
    local nblk = floor((#str + 8) / 64) + 1
    local blks = {}
    for i = 1, nblk * 16 do blks[i] = 0 end
    for i = 1, #str do
        local idx = floor((i - 1) / 4) + 1
        blks[idx] = blks[idx] + lshift(byte(str, i), ((i - 1) % 4) * 8)
    end
    blks[floor(#str / 4) + 1] = blks[floor(#str / 4) + 1] + lshift(0x80, ((#str % 4)) * 8)
    blks[nblk * 16 - 1] = #str * 8
    return blks
end

local function cmn(q, a, b, x, s, t)
    return bor(lshift((a + q + x + t) % 0x100000000, s), rshift((a + q + x + t) % 0x100000000, 32 - s)) + b
end

local function ff(a, b, c, d, x, s, t)
    return cmn(bxor(band(b, c), band(bnot(b), d)), a, b, x, s, t)
end

local function gg(a, b, c, d, x, s, t)
    return cmn(bxor(band(b, d), band(c, bnot(d))), a, b, x, s, t)
end

local function hh(a, b, c, d, x, s, t)
    return cmn(bxor(b, c, d), a, b, x, s, t)
end

local function ii(a, b, c, d, x, s, t)
    return cmn(bxor(c, bor(b, bnot(d))), a, b, x, s, t)
end

function md5.sumhexa(str)
    local x = str2blks_md5(str)
    local a, b, c, d = 0x67452301, 0xefcdab89, 0x98badcfe, 0x10325476

    for i = 1, #x, 16 do
        local olda, oldb, oldc, oldd = a, b, c, d

        a = ff(a, b, c, d, x[i + 0], 7, 0xd76aa478)
        d = ff(d, a, b, c, x[i + 1], 12, 0xe8c7b756)
        c = ff(c, d, a, b, x[i + 2], 17, 0x242070db)
        b = ff(b, c, d, a, x[i + 3], 22, 0xc1bdceee)
        a = ff(a, b, c, d, x[i + 4], 7, 0xf57c0faf)
        d = ff(d, a, b, c, x[i + 5], 12, 0x4787c62a)
        c = ff(c, d, a, b, x[i + 6], 17, 0xa8304613)
        b = ff(b, c, d, a, x[i + 7], 22, 0xfd469501)
        a = ff(a, b, c, d, x[i + 8], 7, 0x698098d8)
        d = ff(d, a, b, c, x[i + 9], 12, 0x8b44f7af)
        c = ff(c, d, a, b, x[i + 10], 17, 0xffff5bb1)
        b = ff(b, c, d, a, x[i + 11], 22, 0x895cd7be)
        a = ff(a, b, c, d, x[i + 12], 7, 0x6b901122)
        d = ff(d, a, b, c, x[i + 13], 12, 0xfd987193)
        c = ff(c, d, a, b, x[i + 14], 17, 0xa679438e)
        b = ff(b, c, d, a, x[i + 15], 22, 0x49b40821)

        a = gg(a, b, c, d, x[i + 1], 5, 0xf61e2562)
        d = gg(d, a, b, c, x[i + 6], 9, 0xc040b340)
        c = gg(c, d, a, b, x[i + 11], 14, 0x265e5a51)
        b = gg(b, c, d, a, x[i + 0], 20, 0xe9b6c7aa)
        a = gg(a, b, c, d, x[i + 5], 5, 0xd62f105d)
        d = gg(d, a, b, c, x[i + 10], 9, 0x02441453)
        c = gg(c, d, a, b, x[i + 15], 14, 0xd8a1e681)
        b = gg(b, c, d, a, x[i + 4], 20, 0xe7d3fbc8)
        a = gg(a, b, c, d, x[i + 9], 5, 0x21e1cde6)
        d = gg(d, a, b, c, x[i + 14], 9, 0xc33707d6)
        c = gg(c, d, a, b, x[i + 3], 14, 0xf4d50d87)
        b = gg(b, c, d, a, x[i + 8], 20, 0x455a14ed)
        a = gg(a, b, c, d, x[i + 13], 5, 0xa9e3e905)
        d = gg(d, a, b, c, x[i + 2], 9, 0xfcefa3f8)
        c = gg(c, d, a, b, x[i + 7], 14, 0x676f02d9)
        b = gg(b, c, d, a, x[i + 12], 20, 0x8d2a4c8a)

        a = hh(a, b, c, d, x[i + 5], 4, 0xfffa3942)
        d = hh(d, a, b, c, x[i + 8], 11, 0x8771f681)
        c = hh(c, d, a, b, x[i + 11], 16, 0x6d9d6122)
        b = hh(b, c, d, a, x[i + 14], 23, 0xfde5380c)
        a = hh(a, b, c, d, x[i + 1], 4, 0xa4beea44)
        d = hh(d, a, b, c, x[i + 4], 11, 0x4bdecfa9)
        c = hh(c, d, a, b, x[i + 7], 16, 0xf6bb4b60)
        b = hh(b, c, d, a, x[i + 10], 23, 0xbebfbc70)
        a = hh(a, b, c, d, x[i + 13], 4, 0x289b7ec6)
        d = hh(d, a, b, c, x[i + 0], 11, 0xeaa127fa)
        c = hh(c, d, a, b, x[i + 3], 16, 0xd4ef3085)
        b = hh(b, c, d, a, x[i + 6], 23, 0x04881d05)
        a = hh(a, b, c, d, x[i + 9], 4, 0xd9d4d039)
        d = hh(d, a, b, c, x[i + 12], 11, 0xe6db99e5)
        c = hh(c, d, a, b, x[i + 15], 16, 0x1fa27cf8)
        b = hh(b, c, d, a, x[i + 2], 23, 0xc4ac5665)

        a = ii(a, b, c, d, x[i + 0], 6, 0xf4292244)
        d = ii(d, a, b, c, x[i + 7], 10, 0x432aff97)
        c = ii(c, d, a, b, x[i + 14], 15, 0xab9423a7)
        b = ii(b, c, d, a, x[i + 5], 21, 0xfc93a039)
        a = ii(a, b, c, d, x[i + 12], 6, 0x655b59c3)
        d = ii(d, a, b, c, x[i + 3], 10, 0x8f0ccc92)
        c = ii(c, d, a, b, x[i + 10], 15, 0xffeff47d)
        b = ii(b, c, d, a, x[i + 1], 21, 0x85845dd1)
        a = ii(a, b, c, d, x[i + 8], 6, 0x6fa87e4f)
        d = ii(d, a, b, c, x[i + 15], 10, 0xfe2ce6e0)
        c = ii(c, d, a, b, x[i + 6], 15, 0xa3014314)
        b = ii(b, c, d, a, x[i + 13], 21, 0x4e0811a1)
        a = ii(a, b, c, d, x[i + 4], 6, 0xf7537e82)
        d = ii(d, a, b, c, x[i + 11], 10, 0xbd3af235)
        c = ii(c, d, a, b, x[i + 2], 15, 0x2ad7d2bb)
        b = ii(b, c, d, a, x[i + 9], 21, 0xeb86d391)

        a = (a + olda) % 0x100000000
        b = (b + oldb) % 0x100000000
        c = (c + oldc) % 0x100000000
        d = (d + oldd) % 0x100000000
    end

    return string.format("%08x%08x%08x%08x", a, b, c, d)
end

_G.md5 = md5
return md5

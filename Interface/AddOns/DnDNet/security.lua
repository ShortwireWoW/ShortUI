DnDNetSecurity = DnDNetSecurity or {}

local allowedLeaders = {
  ["ChugMonk#1359"] = true,
}

local expectedHash = "34fb733e2d22b74c3afa59177d551a09"

function DnDNetSecurity:ValidateLeader()
  local btag = select(2, BNGetInfo())

  if not btag then
    print("[DnDNet Debug] No BTag found from BNGetInfo()")
    return false
  end

  print("[DnDNet Debug] BTag found:", btag)

  if not allowedLeaders[btag] then
    print("[DnDNet Debug] BTag not in allowedLeaders:", btag)
    return false
  end

  -- Anti-tamper hash check
  local keys = {}
  for k in pairs(allowedLeaders) do
    table.insert(keys, k)
  end
  table.sort(keys)

  if #keys == 0 then
    print("[DnDNet Debug] allowedLeaders is empty!")
    return false
  end

  local concat = table.concat(keys, "|")

  print("[DnDNet Debug] Concat string:", concat)
  print("[DnDNet Debug] MD5 of concat:", md5.sumhexa(concat))
  print("[DnDNet Debug] Expected hash:", expectedHash)

  local actual = md5.sumhexa(concat)
  if actual ~= expectedHash then
    print("[DnDNet] Leader hash mismatch. Bricking...")
    wipe(allowedLeaders)
    return false
  end

  print("[DnDNet] Leader hash validated.")
  return true
end

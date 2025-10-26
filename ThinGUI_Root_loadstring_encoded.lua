-- Encoded ThinGUI_Root (XOR key = 42) - loadstring compatible
local key = 42
local data = {32,7,7,10,126,66,67,68,109,127,99,117,120,69,69,94,10,79,82,75,71,90,70,79,10,89,66,69,88,94,10,76,69,88,10,79,68,73,69,78,67,68,77,10,78,79,71,69,32,90,88,67,68,94,2,8,126,66,67,68,109,127,99,117,120,69,69,94,10,109,127,99,10,70,69,75,78,79,78,10,89,95,73,73,79,89,89,76,95,70,70,83,8,3,32}

local function decode(t)
  local r = {}
  for i=1,#t do
    r[i] = string.char(t[i] ~ key)
  end
  return table.concat(r)
end

local src = decode(data)
local f,err = loadstring(src)
if not f then error(err) end
f()

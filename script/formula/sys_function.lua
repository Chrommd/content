------------------------------------------------------------------------------------------------------------------------
-- utility functions
------------------------------------------------------------------------------------------------------------------------

-- ÃâÃ³: http://lua-users.org/wiki/SplitJoin 
string.split = function(str, pattern)
  pattern = pattern or "[^%s]+"
  if pattern:len() == 0 then pattern = "[^%s]+" end
  local parts = {__index = table.insert}
  setmetatable(parts, parts)
  str:gsub(pattern, parts)
  setmetatable(parts, nil)
  parts.__index = nil
  return parts
end

math.round_half_up = function(v)
   local sign_multiplier = 1
   if v < 0 then
      sign_multiplier = -1
   end

   return sign_multiplier * math.floor(math.abs(v) + 0.5)
end
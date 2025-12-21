--[[--------------------------------------------------------------------------------------------------------------------
                                                             /   |
                                                            / /| |
                                                           / ___ |
                                            P R O J E C T /_/  |_| L I C E
                                        Copyright (C) 2005-2009 NTREEV SOFT Inc.
--------------------------------------------------------------------------------------------------------------------]]--

--[[
   me             플레이어 객체
   map_id         맵 번호
   time_limit_sec 시간 제한 (단위: 초)
]]--

function map_mastery_impl(me, map_id, time_limit_sec)
   if me:get("MapId") ~= map_id then
      return false
   end
   
   if me:get("TimeRecord") == 0 or me:get("TimeRecord") > time_limit_sec then
      -- 낙오하거나 (time_limit_sec)값 보다 늦게 들어오면 달성 실패!
      return false
   end
   
   return true
end


--[[
   me             플레이어 객체
   mission_id     미션 번호
   target_rest_time  골인 시에 남은 제한 시간 (단위: 초)
]]--

function mission_mastery_impl(me, mission_id, target_rest_time)

   local restTime = me:get("Mission_RestTime")
   local mid = me:get("Mission_Id")
   
   if mid ~= mission_id then
      return false
   end
   
   if restTime < target_rest_time then
      return false
   end

   return true

end

-- 유틸리티 함수

function getTableSize(t)
    local size = 0
    for index, value in pairs(t) do
        size = size + 1
    end
    return size
end

math.round_half_up = function(v)
   local sign_multiplier = 1
   if v < 0 then
      sign_multiplier = -1
   end

   return sign_multiplier * math.floor(math.abs(v) + 0.5)
end

--[[--------------------------------------------------------------------------------------------------------------------

-- boolean/number에 대해서 c++ 비교 구문과 같은 동작을 하는 비교 함수.
function isTrue(v)
   assert(type(v) == "boolean" or type(v) == "number", "not a boolean or number: type="..type(v))

   local num = tonumber(v)
   if num then
      return num ~= 0;
   end
   
   return v;
end

function isFalse(v)
   return isTrue(v) == false
end
--------------------------------------------------------------------------------------------------------------------]]--


--[[--------------------------------------------------------------------------------------------------------------------
                                               P R O J E C T - A L I C E                                                
--------------------------------------------------------------------------------------------------------------------]]--

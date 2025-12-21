-----------------------------------------------------------------------------------------------------------------------
-- Mount 테이블 구현부
------------------------------------------------------------------------------------------------------------------------

Mount =
{
   -- 레이스 한 판 끝날 때 감소하는 체력(Stamina) 수치 구하기
   --
   -- @param   csvMountStatus 스탯 포인트 목록(Comma Seperated Value 형태)
   -- @param   statusPoint    아직 투자하지 않은 포인트
   --
   GetConsumedStamina = function (csvMountStatus, statusPoint, isHeavyInjury, staminaDecRatio)

      local baseConsumed = 100
      local totalStatus = statusPoint

      mountStatus = csvMountStatus:split("[^, ]+")
      for k,v in pairs(mountStatus) do
         totalStatus = totalStatus + v
      end
	  local injuryConsumed = isHeavyInjury and 200 or 0
      local totalConsumed = baseConsumed + totalStatus + injuryConsumed

      if staminaDecRatio ~= 100 then
          totalConsumed = totalConsumed * staminaDecRatio / 100
      end

      return totalConsumed
   end,

   -- 관리 스킬의 말 등급별 가격    -- 폐기 함수. 정리해야함.
   --
   -- @param mountGrade 말 등급
   -- @param basePrice 기본 가격(등급1 기준)
   --
   GetCareSkillPrice = function (mountGrade, basePrice)
       return basePrice;
   end,
   
    -- 관리: 음식 선호 타입 점검
    --
    -- @param FoodType      음식 타입(enum 조합)
    -- @param PreferType    말의 선호 타입
    --
    IsPreferFood = function (FoodType, PreferType)
        return BitAnd(FoodType, PreferType);            -- return FoodType & PreferType;
    end,
    
    -- 관리: 먹이주기에 따른 친밀도 상승 수치 계산
    --
    -- @param defaultAddPoint    기본 상승 수치
    -- @param isPrefered         선호 여부
    --
    FriendlyPointByFeeding = function (defaultAddPoint, isPrefered)
         if isPrefered == false then
            return defaultAddPoint
         end
         
         return math.round_half_up(defaultAddPoint * 1.5)
    end,
}

--[[--------------------------------------------------------------------------------------------------------------------
                                                             /   |
                                                            / /| |
                                                           / ___ |
                                            P R O J E C T /_/  |_| L I C E
                                        Copyright (C) 2005-2009 NTREEV SOFT Inc.
--------------------------------------------------------------------------------------------------------------------]]--

local kMAX_SPUR_COUNT = 5

--[[--------------------------------------------------------------------------------------------------------------------
 
--------------------------------------------------------------------------------------------------------------------]]--

-- 리비안 마을 마스터
function RiLand03Mastery(me)
   -- 내가
   -- 3번 맵을
   -- 150초 안에 통과했으면
   
   -- 성공(true), 아니면 실패(false)
   return map_mastery_impl(me, 3, 150)
end

-- 그랜토 협곡 마스터
function RiFore02Mastery(me)
   return map_mastery_impl(me, 8, 160)
end

-- 붉은 도르프 상회
function RiDorf04Mastery(me)
   return map_mastery_impl(me, 32, 150)
end

-- 실프 언덕
function RiLand04Mastery(me)
   return map_mastery_impl(me, 7, 130)
end

-- 스타토 목장
function RiLand01Mastery(me)
   return map_mastery_impl(me, 1, 140)
end

-- 울렌 숲  마스터
function RiFore01Mastery(me)
   return map_mastery_impl(me, 57, 140)
end

-- 포베아 들판 마스터
function RiLand02Mastery(me)
   return map_mastery_impl(me, 2, 140)
end

-- 첫 승리
function MyFirstWin(me)
   return me:get("Rank") == 1
end

-- 패배의 아픔
function PainOfLosses(me)
   if me:get("LastRank") == 0 or me:get("Rank") == 0 then
      -- 골인 정보가 없거나, 낙오하면 Rank가 0이 될 겁니다(아마).
      return false
   end

   -- 둘 다 승리하지 못했다면 true
   return me:get("LastRank") > 1 and me:get("Rank") > 1
end

-- 완벽한 승리
function PerfectWin(me)
   if me:get("Rank") ~= 1 then
      -- 1등이 아니면 실패
      return false
   end

   -- 낙오자가 1명 이상이면 true
   return me:get("RetireCount") > 0
end

-- 플레이 판 수 20회
function Playing20Races(me)
   if me:get("RaceCount") < 20 then
      return false
   end
   
   return true
end

-- 연속 1등 01
function SerialWin(me)
   if me:get("LastPlayerCount") ~= 8 then
      return false
   end

   if me:get("LastRank") ~= 1 then
      return false
   end
   
   if me:get("PlayerCount") ~=  8 then
      return false
   end
   
   if me:get("Rank") ~= 1 then
      return false
   end

   return true
end

-- 글라이딩을 사용하여 50m 이동하기
function Gliding50M(me)

   local glidingDist = me:get("GlidingDistance")

   if glidingDist < 50 then
      return false
   end
   
   return true
   
end

-- 슬라이딩 한번도 사용하지 않고 게임에서 승리하기
function NoSlidingWin(me)

   local slidingCount = me:get("SlidingCount")
   local rank         = me:get("Rank")

   if rank ~= 1 then
      return false
   end  
      
   if slidingCount ~= 0 then
      return false
   end      
         
   return true
   
end

-- 슬라이딩 20회 사용하고 게임 승리하기
function Sliding20(me)
   
   local slidingCount = me:get("SlidingCount")
   local rank         = me:get("Rank")

   if rank ~= 1 then
      return false
   end
      
   if slidingCount < 20 then
      return false
   end 
   
   return true
     
end

-- 스피드모드 한 게임에서 박차 40회 사용하기
function UseSpur40(me)

   local numSpurUsed = me:get("SpurUseCount")
   local rank        = me:get("Rank")

   if rank == 0 then
      -- 낙오자이면 달성 실패
      return false
   end   

   if numSpurUsed < 40 then
      return false
   end
   
   return true

end

-- 한 게임에서 점프를 한 번도 사용하지 않고 게임에서 승리하기
function NoJumpWin(me)

   local jumpCount = me:get("JumpCount")
   local rank      = me:get("Rank")

   if rank == 0 then
      -- 낙오자이면 달성 실패
      return false
   end

   if jumpCount ~= 0 then
      return false
   end
   
   return true

end


-- 스피드 모드 팀전에서 팀원이 1,2,3,4등 모두 차지하기
function TeamPerfectWin(me)

   local topRankerCount = me:get("TopRankerCount") -- 상위 랭커 카운트 (1~4등까지)

   -- 내가 속한 팀이 4등안에 몇명이 인는가
   if topRankerCount < 4 then
      return false
   end

   
   
   return true
      
end


-- 마법모드 개인전 풀방에서 3연속 1등하기

function Magic_TripleWin(me)

   local rank    = me:get("Rank")
   local wasFull = me:get("PlayerCount") == 8

   local count   = me:get("Magic_SerialWinCount")
   me:set("Magic_SerialWinCount", 0)

   if rank ~= 1 then
      return false
   end

   if wasFull == false then
      return false
   end

   count = count + 1
   me:set("Magic_SerialWinCount", count)

   if count < 3 then
      return false
   end

   return true

end


-- 마법모드에서 한개의 지옥꽃으로 7명 중독시키기

function Magic_NiceFlower(me)

   local poisonCount = me:get("PoisonCount")

   -- 가장많이 감염을 시킨 지옥꽃
   if poisonCount == 7 then
      return true
   end

   return false

end


--마법모드에서 얼음화살 2단계를 사용하여 한번에 3명 공격 성공하기
 
function Magic_NiceRange(me)

   local victimCount = me:get("VictimCount")

   -- 1단계,2단계 얼음화살 같은 카운드 사용
   
   if victimCount >= 3 then
      return true
   end      

   return false

end


--마법모드에서 박쥐 피해를 당하고 있는 아군을 근접공격을 통해 풀어주기
 
function TeamHelp_Bat(me)

   local DelBat_Team = me:get("DelBat_Team")  
   local game_mode   = me:get("GameMode")
   
   -- 1: speed / 2: magic
   if game_mode ~= 2 then
      return false
   end
   
   if DelBat_Team >= 1 then
      return true
   end      

   return false

end
   

--마법모드에서 폭주를 사용하고 달리는 플레이어를 얼음화살을 통해 공격하기
 
function Magic_CutHotRodding(me)

   local isTargetHotRodding = me:get_bool("IsTargetHotRodding")
   local victimCount        = me:get("VictimCount")

   if isTargetHotRodding == false then
      return false
   end
   
   if victimCount > 0 then
      return true
   end

   return false

end


--[[마법모드에서 한 게임에 폭주마법을 2회 획득

function MagicGetCount_temsion(me)

   local MagicGetCount_temsion = me:get("MagicGetCount_temsion")
   
   if MagicGetCount_temsion == 2 then
      return true
   end
   
end 
   ]]

--미션모드 움직이는 다리 1단 점프 넘기 3초 남기고 골인

function Mission_Movejump01_01(me)

   return mission_mastery_impl(me, 4, 3)
   
end


--미션모드 움직이는 다리 2단 점프 넘기 3초 남기고 골인

function Mission_Movejump01_02(me)

   return mission_mastery_impl(me, 5, 3)

end


--미션모드 움직이는 다리 글라이딩 3초 남기고 골인

function Mission_Moveglide01_01(me)

   return mission_mastery_impl(me, 6, 3)

end

-- for game action

function ConsumeSpur(me)
   local spurCount = me:get("SpurCount")
   local lastTime = me:get("SpurStartTime")
   local currTime = os.time()

   local wasFirstSpur = false
   if spurCount == (kMAX_SPUR_COUNT - 1) then
      wasFirstSpur = true
   end

   if wasFirstSpur == true then
      -- 박차 충전 후 첫 박차이면, 시작 시각을 기록하고 종료.
      update_property(me.user_uid, "SpurStartTime", currTime)
      return false
   end
   
   if spurCount > 0 then
      -- 아직 박차가 남았으면 실패.
      return false
   end

   local deltaTime = os.difftime(currTime, lastTime)
   if deltaTime > 5 then
      return false
   end

   return true
end

function OneJump(me)
   local numJumps = me:get("JumpSuccessCount")

   return numJumps > 0
end

function LearnDash(me)
   local numDashes = me:get("DashCount")
   
   return numDashes > 0
end

function FloatInTheAir(me)
   local  glidingTime = me:get("GlidingRecordTimeDetail")
   
   return glidingTime > 5000
end

------------------------------------------------------------------------------------------------------------
--
--                                            NEW Condition (2010-07-27)
--
------------------------------------------------------------------------------------------------------------

-- 일정 거리 글라이딩 달성 여부
function GlidingDistance(me, value)
    local num = me:get("GlidingDistance")
    
    return num >= 50
end
-- 토탈 박차 사용 횟수 
function SpurTotalUseCount(me, value)  
   return true
end

-- 글라이딩중 박차 사용 (총 횟수)
function GlidingSpur(me, value)
   local num = me:get("GlidingSpurCount")

   return num > 0
end

-- 아이템 사용 금액 (**** 각 등급 마다 관련된 정보가 있어야 할듯 ****)
function BuyItem(me, value)
   local num = me:get("BuyItemTotalMoney")

   return num
end

-- 퍼펙트 스타트 (총 횟수) 
function PerfectStart(me, value)
   return true
end

-- 퍼펙트 점프 (총 횟수) 
function PerfectJump(me, value)
   return true
end

-- 연속 게임, 한 번 접속해서 연속 게임 (총 횟수)
function GoalIn(me, value)
   local time = me:get("TimeRecord")

   return time > 0
end

-- 오전 8시부터 오후 1시 사이에 xx완주 (총 횟수)
function GoalIn_8h_13h(me, value)
   if GoalIn(me) == false then
      return false
   end

   local datetime = os.date("*t")
   if datetime.hour >= 8 and datetime.hour < 13 then
         return true
   end
   
   return false
end

-- 오후 4시부터 오후 6시 사이에 xx완주 (총 횟수)
function GoalIn_16h_18h(me, value)
   if GoalIn(me) == false then
      return false
   end

   local datetime = os.date("*t")
   if datetime.hour >= 16 and datetime.hour < 18 then
      return true
   end
   
   return false
end

-- 오후 7시부터 오후 10시 사이에 xx완주 (총 횟수)
function GoalIn_19h_22h(me, value)
   if GoalIn(me) == false then
      return false
   end

   local datetime = os.date("*t")
   if datetime.hour >= 19 and datetime.hour < 22 then
      return true
   end
   
   return false
end

-- 4가지 숙련도 모두 달성하기 (총 횟수)
function Mastery(me, value)
    local num = me:get("MasteryCount")
    
    return num > 0
end

-- 갈기 닦기 (총 횟수)
function ManeWash(me, value)
    local num = me:get("ManeWashCount")
    
    return num > 0
end
    
-- 몸통 닦기 (총 횟수)
function BodyWash(me, value)
    local num = me:get("BodyWashCount")
    
    return num > 0
end
    
--꼬리 닦기 (총 횟수)
function TailWash(me, value)
    local num = me:get("TailWashCount")
    
    return num > 0
end
    
--싫어하는 먹이 먹이기 (총 횟수)
function ForciblyFeeding(me, value)
    local num = me:get("IsPreferFood")
    
    return num == 0
end


-- 좋아하는 먹이 먹이기 (총 횟수)
function FavoriteFoodsFeeding(me, value)
    local num = me:get("IsPreferFood")
    
    return num ~= 0
end

-- 말을 배부르게 만들기 (총 횟수)
function Stuffed(me, value)
    local num = me:get("Plenitude")
    local max = me:get("MaxPlenitude")

    return num == max
end

-- 자연으로 보내기 (총 횟수)
function BackToNature(me, value)
    local num = me:get("BackToNatureCount")
    
    return num > 0
end

-- 경상 당하기 (총 횟수)
function SightlyInjury(me, value)
    local num = me:get("SightlyInjuryCount")
    
    return num > 0
end

-- 자연치료하기 (총 횟수)
function NatureCure(me, value)
    local num = me:get("NatureCureCount")
    
    return num > 0
end

-- 반짝이게 만들기 (총 횟수)
function PolishUp(me, value)
    local num = me:get("IsPolishEnabled")
    
    return num > 0
end

-- 놀아주기 성공 (총 횟수)
function TraningSuccess(me, value)
    local num = me:get("PlaySuccessLevel") -- 0:실패, 1:성공, 2:퍼펙

    return num > 0
end

-- 교배 시도 (총 횟수)
function BreedingTry(me, value)
    local num = me:get("BreedingTryCount")
    
    return num > 0
end

-- 교배 성공 (총 횟수)
function BreedingSuccess(me, value)
    local num = me:get("BreedingSuccessCount")
    
    return num > 0
end

-- 교배 실패 (총 횟수)
function BreedingFail(me, value)
    local num = me:get("BreedingFailCount")
    
    return num > 0
end

-- 씨수마 등록 (총 횟수)
function MaleHorseRegistration(me, value)
    local num = me:get("MaleHorseRegistrationCount")
    
    return num > 0
end

-- 잠재능력 얻기 (총 횟수)
function PotentialCapacities(me, value)                                     
    local num = me:get("ChildPotentialType") -- 0:잠재 능력 없음, 1이상:잠재 능력 있음
    
    return num > 0
end

-- 교배 3연속 성공 (총 횟수)
function BreedingSuccessCombo(me, value)
    local num = me:get("MareSerialSuccessCount")
    
    return num >= value
end

-- 교배소 입장에서 xx회 시도 (총 횟수)
function BreedingComboTry(me, value)
    local num = me:get("BreedingTryCount")
    
    return num >= value -- value가 아니라 다른 값이 되어야 한다
end

-- 한 번 등록한 씨수마가 xx회 이상 교배 되기 (총 횟수)
function MaleHorseCombo(me, value)
    local num = me:get("MaleHorseComboCount")
    
    return num >= value -- value가 아니라 다른 값이 되어야 한다
end

-- 잠재능력 전부 성장시키기 (총 횟수)
function PotentialCapacitiesGrow(me, value)
    local num = me:get("PotentialLevel")
    
    return num >= 11
end

-- 자식마가 씨암마보다 낮은 등급 나오기 (총 횟수)
function GradeCompare(me, value)
    local mareMountGrade = me:get("MareMountGrade")
    local childGrade = me:get("ChildGrade")
    
    if mareMountGrade - childGrade >= 2 then
        return true
    end    
    
    return false
end

-- 리타이어 당하지 않고 8등으로 골인
function GoalInRanking(me, value)
   local time = me:get("TimeRecord")
   local rank = me:get("Rank")
   
   return time > 0 and rank == value
end

-- 마법전에서 3종류 이상 마법 사용하기 (총 횟수)
-- 1회를 체크하는 경우 (value 가 1인 경우) 제대로 동작하지 않는다.
-- -> 이 경우 외부에서 LastUseMagicTypeCount 를 0으로 초기화 해 줄 필요가 있다.
function UseAllMagic(me, value)
    local count     = me:get("UseMagicTypeCount")
    local lastCount = me:get("LastUseMagicTypeCount")

    if count ~= lastCount then
        me:set("LastUseMagicTypeCount", count)

        return count == value
    end

    return false
end

-- 낭떠러지 떨어지기 (총 횟수)
function Cliff(me, value)
   local num = me:get("CourseOut")

   return num > 0
end

-- 라스트스퍼트 후 역전하여 1등하기 (총 횟수)
function ReversalWinner(me, value)
   local num = me:get("ReversalWinner")

   return num == 1
end

-- 축제 참가 성공하기 (총 횟수)
function CarnivalSuccess(me, value)
   local num = me:get("CarnivalInvitation")

   if num == 1 then
      return true
   end
    
   return false
end

-- 점프 마비 마법으로 상대방 3명 이상 공격하기 (총 횟수)
--[[ 마법 종류

    MagicSlot_Fireball   
    MagicSlot_WaterShield
    MagicSlot_Booster    
    MagicSlot_HotRodding 
    MagicSlot_IceWall    
    MagicSlot_JumpStun   
    MagicSlot_Darkfire   
    MagicSlot_Summon     
    MagicSlot_Lightning  
    MagicSlot_BufPower   
    MagicSlot_BufGauge   
    MagicSlot_BufSpeed   
]]
function JumpParalysis(me, value)
   local magicSlotType = me:get("MagicSlotType")
   local numVictims = me:get("VictimCount")
   
   if magicSlotType == MagicSlot_JumpStun and numVictims >= value then
        return true
   end
   
   return false
end

-- 폭주마법 사용중에 xx명 앞지르기 (총 횟수)
function HotRoddingReversalCount(me, value)
   local num = me:get("HotRoddingReversalCount")

   return num >= value
end

-- 골인할 때 박차 쓰고 들어오기 (총 횟수)
function SpurGoalin(me, value)
   local num = me:get("Rank")
   local flag = me:get("SpurState")
   
   if num >= 1 and 8 >= num then
		if flag == true then
			return true
		end
	end
   
   return false
end

-- 골인할 때 슬라이딩하면서 들어오기 (총 횟수)
function SlidingGoalin(me, value)
   local num = me:get("Rank")
   local flag = me:get("SlidingState")
   
   if num >= 1 and 8 >= num then
		if flag == true then
			return true
		end
	end
   
   return false
end

-- 골인할 때 글라이딩하면서 들어오기 (총 횟수)
function GlidingGoalin(me, value)
   local num = me:get("Rank")
   local flag = me:get("GlidingState")
   
   if num >= 1 and 8 >= num then
		if flag == true then
			return true
		end
	end
   
   return false
end

-- 스크린샷 찍기
function ScreenShot(me, vlaue)
	local num = me:get("ScreenShotCount")
	
	return num >= 0
end

-- 팀이 이기고, 나는 꼴지 했을 때
function TeamWinTheLast(me, value)
	local teamrank = me:get("TeamRank")
	local myrank = me:get("Rank")
	
	if teamrank == 1 and myrank == 8 then
		return true
	end
end	

-- 라스트 스퍼트 구간에서 역전당하기
function LastSpurtTurned(me, value)
	local lastspurtrank = me:get("LastSpurtRanking")
	local goalinrank = me:get("Rank")

	if goalinrank - lastspurtrank >= 1 then
		return true
	end
	
	return false
end
		
-- 라스트 스퍼트 구간에서 역전하기
function LastSpurtTurnTheTable(me, value)
	local lastspurtrank = me:get("LastSpurtRanking")
	local goalinrank = me:get("Rank")

	if lastspurtrank - goalinrank >= 1 then
		return true
	end
	
	return false
end

-- 글라이딩으로 편자먹기
function GlidingHorseshoe(me, value)
	local glidingstate = me:get("GlidingState")
	local horseshoe = me:get("Horseshoe")
	
	if glidingstate == true and horseshoe >= 1 then
		return true
	end
end

-- 부상치료하기 (총 횟수)
function Cure(me, value)
	local num = me:get("CureCount")
	
	return num >= 0
end

-- 400kg 이하인 말 얻기 (총 횟수)
function PoorHorse(me, value)
	local num = me:get("ChildWeight")
	
	return num <= value
end

-- 500kg 이상인 말 얻기 (총 횟수)
function GoodHorse(me, value)
	local num = me:get("ChildWeight")
	
	return num >= value
end

-- 기세 종류 경험
function Force(me, value)
	local num = me:get("ForceUseCount")
	
	return num >= value -- 등급마다 Function value 값을 다르게 적용
end

-- 화염 정령을 다른 사람에게 옮기기 (총 횟수)
function DamageShift(me, value)
	local num = me:get("DamageShiftCount")
	
	return num >= 0
end

-- 크리티컬 공격 성공시키기 (총 횟수)
function CriticalFireballAttack(me, value)
	local isCritical = me:get("CriticalAttack")
	local victimCount = me:get("VictimCount")
    local magicSlotType = me:get("MagicSlotType")
	
	if isCritical == 1 and victimCount > 0 and magicSlotType == MagicSlot_Fireball then
    return true
  end
	
	return false 
end

-- 복수 대상에게 공격 성공하기, 1등 마법, 화염의 정령, 타겟팅 공격으로 인정 (총 횟수)
-- Fireball 만 공격 체크 하도록 변경
function RevengeAttackWithFireball(me, value)
	local num = me:get("RevengeTargetAttacked")
    local magicSlotType = me:get("MagicSlotType")

    if num > 0 and magicSlotType == MagicSlot_Fireball then
        return true
    end

    return false
end

-- 한 게임에서 같은 사람에게 3회 공격 성공 xx 회 하기 (총 횟수) 
-- 
-- MagicSlot_Fireball : 화염
-- MagicSlot_Summon   : 용
-- MagicSlot_Lightning : 1등마법
-- MagicSlot_IceWall
--     
-- 2010.10.26 by bezz <> 이제 Fireball 만 체크하도록 변경, MaxAttackedCount 가 Fireball 만 카운트 함
function ComboAttackSuccessWithFireball(me, value)
	local num = me:get("MaxAttackedCount")

  return num >= value
end

-- 물 보호막이 끝난 상대에게 3초 이내에 공격(총 횟수)
-- Fireball 만 공격 체크하도록 변경
function ShieldEndAttackWithFireball(me, value)
	local num = me:get("ShortestUnshieldTime")
    local magicSlotType = me:get("MagicSlotType")

    if num <= value and magicSlotType == MagicSlot_Fireball then
        return true
    end
	
	return false
end

-- 글라이딩 중인 상대에게 공격하기
function OnGlidingAttack(me,value)
	local num = me:get("OnGlidingAttackCount")
	
	return num >= 0
end

-- 복수 성공 (총 횟수)
function Revenge(me, value)
	local num = me:get("RevengeSuccess")
	
	return num > 0
end

-- 1등에게 화염구 마법으로 공격 성공 (총 횟수)
function FireBallSuccess(me, value)
  local magicSlotType = me:get("MagicSlotType")
	local rank = me:get("VictimBestRank")
	
	if magicSlotType == MagicSlot_Fireball and rank == 1 then
    return true
  end  
	
	return false
end

-- 어둠의 마법으로 상대방 리셋시키기 (총 횟수)
function DarknessBall(me, value)
	local num = me:get("DarknessBall")
	
	return num >= 0
end
	
-- AI와의 전에서 승리하기 (총 횟수)
function WinAI(me, value)
	local hasAI = me:get("FillAIPlayer")
	local rank = me:get("RankAI")

	if hasAI == 0 then
    return false
	end

  return rank == 1
end

-- 자식마가 씨암마보다 2등급 이상 나오기 (총 횟수)
function GoodChild(me, value)
	local mareGrade = me:get("MareMountGrade")
	local childGrade = me:get("ChildGrade")
	me:LOG(string.format("ChildGrade(%d),MareGrade(%d)", childGrade, mareGrade))
	
	if childGrade - mareGrade >= 2 then
		return true
	end

	return false
end
	
-- 칭호 모으기 (총 횟수)
function TitleCollect(me, value)
	local num = me:get("TitleCollectCount")
	
	return num >= 0
end

-- 4단 박차 이상에서 퍼펙트박차 성공하기 (총 횟수)
function PerfectSpurMaster(me, value)
	local spurLevel = me:get("SpurLevel")
	local num = me:get("PerfectSpurCombo")
	
	if spurLevel >= 4 and num >= 1 then
		return true
	end
	
	return false
end

-- 말 관리에 들어가서 한 번에 놀아주기 3연속 성공 XX회 하기
function TrainingCombo(me, value)
	local num = me:get("PlaySuccessCombo")
	
	return num >= value 
end

-- 팀전 퍼펙트 승리 (총 횟수) (길드전도 포함)
function TeamPerfectWinNew(me, value)
	local numRanker = me:get("TopRankerCount")
	local numPlayer = me:get("PlayerCount")

  if numPlayer <= 2 and numRanker == 1 then
    return true
  end
  
  if numPlayer <= 4 and numRanker == 2 then
    return true
  end

  if numPlayer <= 6 and numRanker == 3 then
    return true
  end

  if numPlayer <= 8 and numRanker == 4 then
    return true
  end

	return false
end

-- 퍼펙트 박차 3회 이상 연속 성공하기 (총 횟수) 리셋하는 시점을 3회마다 리셋
function PerfectSpurCombo(me, value)
	local combo = me:get("PerfectSpurCombo")

	return combo % value == 0
end	

-- 놀아주기에서 크리티컬 터지기 (총 횟수), boolean타입이기 때문에 true이면 1을 리턴 (2011/04/27일 수정 by 주한진)
function TrainingCritical(me, value)
	local num = me:get("PlayCritical")
	
	return num > 0
end

-- 스피드 개인전 1위하기 (총 횟수) 2인 이상
function Win(me, value)
	local rank = me:get("Rank")
	
	return rank == 1
end

-- 마법 개인전 1위 하기 (총 횟수) 2인 이상

-- 스피드 팀전 1위하기 (총 횟수) 4인 이상
function TeamWin(me, value)
   local rank = me:get("TeamRank")

   return rank == 1
end

-- 마법 팀전 1위하기 (총 횟수) 4인 이상

-- 퍼펙트 점프 10연속 성공하기 (총 횟수) 리셋하는 시점을 10연속 마다 리셋
function MaxPerfectJumpCombo(me, value)
   local perfectJumpCount = me:get("PerfectJumpCount")
   local lastPerfectJumps = me:get("LastPerfectJumpCount")
   
   if perfectJumpCount ~= lastPerfectJumps then
      me:set("LastPerfectJumpCount", perfectJumpCount)

      local goodJumpsCount = me:get("GoodJumpCount")
      local failJumpsCount = me:get("JumpFailCount")

      local lastGoodJumps = me:get("LastGoodJumpCount")
      local lastFailJumps = me:get("LastJumpFailCount")

      me:set("LastGoodJumpCount", goodJumpsCount)
      me:set("LastJumpFailCount", failJumpsCount)

      if goodJumpsCount ~= lastGoodJumps or failJumpsCount ~= lastFailJumps then
         me:set("PerfectJumpCombo", 0)
         return false
      end

      local perfectJumpCombo = me:get("PerfectJumpCombo") + 1

      me:set("PerfectJumpCombo", perfectJumpCombo)
   end

   local perfectJumpCombo = me:get("PerfectJumpCombo")

   return perfectJumpCombo % value == 0
end

-- 슬라이딩 2초유지하기 (총 횟수)
function SlidingTime(me, value)
	local num = me:get("MaxSlidingTime")
	
	return num >= value
end

-- 중첩 박차 하기 (한 게임에서 총 몇단까지, 등급마다 중첩박차의 수는 달라진다)
function MaxSpurCount(me, value)
	local num = me:get("SpurLevel")
	
	--return num >= value	-- function value 값이 등급 마다 달라져야 한다
    return num
end

-- 최고속도 달성하기
function GetMaxSpeed(me, value)
  local num = me:get("MaxVelocity")
  local speed = math.round_half_up(num * 3.6)

  return speed
end

-- 풍선 터트리기
function BalloonLapTime(me, value)
   local time = me:get("BalloonLapTime") -- 소수점 포함한 값
   local fraction = time % 1 
   local decimal  = time - fraction

   if fraction > 0 then
      return decimal + 1
   end

   return decimal
end


-- 연승 저지하기
function MaxWinStop(me, value)
	local straightWin    = me:get("StraightWin")
	local oldStraightWin = me:get("OldStraightWin")
	
  if straightWin == 1 and oldStraightWin >= 2 then
     return true
  end
    
	return false
end

-- 퍼펙트 박차 xx회 성공하기를 총 xx회
function PerfectSpur(me, value)
	local num = me:get("PerfectSpurCombo")
	
	return num > 0
end


-- MagicSlot_Fireball : 화염
-- MagicSlot_Summon   : 용
-- MagicSlot_Lightning : 1등마법

-- 고추가루 (라스트 스퍼트 구간에서 1등 공격하기, 마법구만(MagicSlot_Fireball))
function LastSpurtAttack(me, value)
    local isLastSpurt = me:get("IsLastSpurt")
	local magicSlotType = me:get("MagicSlotType")
	local rank = me:get("VictimBestRank")

	if isLastSpurt == 1 then
		if magicSlotType == MagicSlot_Fireball then
			if rank == 1 then
				return true
			end
		end  
	end
	
	return false
end

-- 어쩌다 보니 (가속 마법으로 골인하기)
function BoosterWin(me, value)
	local time = me:get("TimeRecord")
	local magicSlotType = me:get("MagicSlotType")
	
	if time > 0 and magicSlotType == MagicSlot_Booster then
		return true
	end 
  
	return false
end

-- 내말은 추입마 (3단 박차 이상 상태로 골인하기)
function Spur3thGoalIn(me, value)
	local spurLevel = me:get("SpurLevel")

	if spurLevel > 2 then
		return true
	end
	
	return false
end


-- 레벨 업 체크하는 함수
function LevelCheck(me, value)
    local level = me:get("Level")

    if level == value then
        return true
    end

    return false
end

-- NPC 대화 체크 함수
function DialogLevelCheck(me, value)
    local level = me:get("Level")
    local dialogLevel = me:get("NPCDialogLevel")

    if value == dialogLevel and dialogLevel <= level then
        return true
    end

    return false
end


------------------------------------------------------------------------------------------------------------
--
--                                            Quest 추가
--
------------------------------------------------------------------------------------------------------------

-- 마법구 명중
function FireballAttack(me, value)
    local magicSlotType = me:get("MagicSlotType")
	local isTargetUser = me:get("IsTargetUser")

    if isTargetUser == 1 and magicSlotType == MagicSlot_Fireball then
        return true
    end

    return false
end

-- 개인전 입상
function PrizeWinner(me, value)
    local rank      = me:get("Rank")
    local numPlayer = me:get("PlayerCount")

    if numPlayer >= 3 and rank <= 3 then
        return true
    end

    return false
end

-- 개인전 입상(저레벨)
function PrizeWinnerForLowLevel(me, value)
    local rank      = me:get("Rank")
    local numPlayer = me:get("PlayerCount")

    if numPlayer >= 1 and rank <= 3 then
        return true
    end

    return false
end

-- 글라이딩한 거리
function GlidingDistanceValue(me, value)
    local num = me:get("GlidingDistance")

    return num
end

-- 특정 맵 완주
function RunMap(me, value)
    local mapId = me:get("MapId")

    --me:LOG(string.format("★★★RunMap: mapId(%d),value(%d)", mapId, value))

    return mapId == value
end

-- 드롭 아이템 수집
function CollectDropItem(me, value)
    local itemTid = me:get("DropItemTid")

    return itemTid == value
end

-- 특정 맵에서 입상
function PrizeWinnerInMap(me, value)
    local rank      = me:get("Rank")
    local numPlayer = me:get("PlayerCount")
	local mapId	    = me:get("MapId")

    if numPlayer >= 3 and rank <= 3 and mapId == value then
        return true
    end

    return false
end

-- 특정 맵에서 입상(저레벨)
function PrizeWinnerInMapForLowLevel(me, value)
    local rank      = me:get("Rank")
    local numPlayer = me:get("PlayerCount")
	local mapId	    = me:get("MapId")

    if numPlayer >= 1 and rank <= 3 and mapId == value then
        return true
    end

    return false
end

-- 튜토리얼 완료
function ClearMission(me, value)
    local missionID = me:get("MissionID")

    return missionID == value
end


------------------------------------------------------------------------------------------------------------
--
--                                            OLD Condition (1&2 CBT)
--
------------------------------------------------------------------------------------------------------------


function OneSpur(me, value)
   local num = me:get("SpurUseCount")

   return num > 0
end

function OneSliding(me, value)
   local num = me:get("SlidingCount")

   return num > 0
end

function OneGliding(me, value)
   local num = me:get("GlidingCount")

   return num > 0
end

function Retire(me, value)
   local num = me:get("TimeRecord")

   return num == 0
end

function BuyItemCount(me, value)
   local num = me:get("BuyItemCount")

   return num >= value
end

function Level(me, value)
   local num = me:get("Level")

   return num >= value
end

function Kicked(me, value)
   local num = me:get("Kicked")

   return num > 0
end

function OneGlidingSpur(me, value)
   local num = me:get("GlidingSpurCount")

   return num > 0
end

--function MaxPerfectJumpCombo(me, value)
   --local perfectJumpCount = me:get("PerfectJumpCount")
   --local lastPerfectJumps = me:get("LastPerfectJumpCount")
   
   --if perfectJumpCount ~= lastPerfectJumps then
      --me:set("LastPerfectJumpCount", perfectJumpCount)

      --local goodJumpsCount = me:get("GoodJumpCount")
      --local failJumpsCount = me:get("JumpFailCount")

      --local lastGoodJumps = me:get("LastGoodJumpCount")
      --local lastFailJumps = me:get("LastJumpFailCount")

      --me:set("LastGoodJumpCount", goodJumpsCount)
      --me:set("LastJumpFailCount", failJumpsCount)

      --if goodJumpsCount ~= lastGoodJumps or failJumpsCount ~= lastFailJumps then
         --me:set("PerfectJumpCombo", 0)
         --return false
      --end

      --local perfectJumpCombo = me:get("PerfectJumpCombo") + 1

      --me:set("PerfectJumpCombo", perfectJumpCombo)
   --end

   --local perfectJumpCombo = me:get("PerfectJumpCombo")

   --return perfectJumpCombo >= value
--end

function MaxSlidingTime(me, value)
   local num = me:get("MaxSlidingTime")

   return num >= value
end


-- 중복 함수
--function HotRoddingReversalCount(me, value)
  -- local num = me:get("HotRoddingReversalCount")

   --return num >= value
--end

function HorseLevel(me, value)
   local num = me:get("MountLevel")

   return num >= value
end

-- 중복 함수
--function Win(me, value)
  -- local rank = me:get("Rank")
   --local time = me:get("TimeRecord")
   
   --return time > 0 and rank == 1
--end

function NotWin(me, value)
   local rank = me:get("Rank")
   
   return rank ~= 1
end

function Lose(me, value)
   return NotWin(me, value)
end


-- 중복 함수
--function TeamWin(me, value)
  -- local rank = me:get("TeamRank")

   --return rank == 1
--end

function TeamNotWin(me, value)
   local rank = me:get("TeamRank")

   return rank ~= 1
end

function TeamLose(me, value)
   return TeamNotWin(me, value)
end


-- 중복 함수
--function GoalInRanking(me, value)
  -- local time = me:get("TimeRecord")
   --local rank = me:get("Rank")
   
   --return time > 0 and rank == value
--end

--function UseAllMagic(me, value)
   --local num = me:get("UseMagicTypeCount")

   --return num >= value
--end

-- 중복 함수
--function ReversalWinner(me, value)
  -- local num = me:get("ReversalWinner")

   --return num == 1
--end

function GoalInComboCount(me, value)
   local time = me:get("GoalInComboCount")

   return time >= value
end

function GoalIn_14h_16h(me, value)
   if GoalIn(me) == false then
      return false
   end

   local datetime = os.date("*t")
   if datetime.hour >= 14 and datetime.hour < 16 then
      return true
   end
   
   return false
end

-- 중복 함수
--function GoalIn_16h_18h(me, value)
  -- if GoalIn(me) == false then
    --  return false
   --end

   --local datetime = os.date("*t")
   --if datetime.hour >= 16 and datetime.hour < 18 then
     -- return true
   --end
   
   --return false
--end

-- 중복 함수
--function GoalIn_19h_22h(me, value)
  -- if GoalIn(me) == false then
    --  return false
   --end

   --local datetime = os.date("*t")
   --if datetime.hour >= 19 and datetime.hour < 22 then
     -- return true
   --end
   
   --return false
--end

-- 항상 true 리턴하는 함수. 로그인 시에 리셋하는 도전과제에 사용.
function True(me, value)
   return true
end

function False(me, value)
   return false
end

function TRUE(me, value)
   return true
end

function FALSE(me, value)
   return false
end

--[[--------------------------------------------------------------------------------------------------------------------
                                               P R O J E C T - A L I C E                                                
--------------------------------------------------------------------------------------------------------------------]]--

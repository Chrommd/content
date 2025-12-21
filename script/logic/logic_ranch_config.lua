require('logichelper')

--
-- Ranch Config용
--


RANCH_PORTAL_POS = v3(-11.8, 0, 27)

-- 말의 기분 상태
FEELING_VERY_BAD	= 1
FEELING_BAD			= 2
FEELING_NORMAL		= 3
FEELING_GOOD		= 4
FEELING_VERY_GOOD	= 5

FeelingLevels =
{
	[FEELING_VERY_BAD]	= { 0, 3 },
	[FEELING_BAD]		= { 4, 6 },
	[FEELING_NORMAL]	= { 7, 9 },
	[FEELING_GOOD]		= { 10, 12 },
	[FEELING_VERY_GOOD]	= { 13, 1000 },
}

-- MountCondition 단계별 포인트
ConditionPoints =
{
    [MountCondition_Plenitude]		= { 0, 2, 3 },	-- 만복도
    [MountCondition_FriendlyPoint]	= { 0, 1, 2 },	-- 친밀도
	[MountCondition_Stamina]		= { 0, 3, 4 },	-- 체력
	[MountCondition_BodyDirtiness]	= { 2, 1, 0 },	-- 얼룩(몸통)
    [MountCondition_ManeTwisted]	= { 2, 1, 0 },	-- 갈기 뭉침
    [MountCondition_TailTwisted]	= { 2, 1, 0 },	-- 꼬리 뭉침
    [MountCondition_InjuryPoint]	= { 0, -20 },   -- 부상
}

function GetFeelingLevelByPoint(point)
	for level, points in pairs(FeelingLevels) do
		if point>=points[1] and point<=points[2] then
			return level
		end
	end	
	return 1
end

--function __DEBUG(...)
	--print(...)
--end

-- 방목된 말에 대한 정보
RanchHorseConfig =
{
	CallDistance	= 40,		-- 호출 시 거리
	CallPostfixRatio = 20,		-- 20% 확률로 ~아,~야
	
	-- 말의 기분 상태 합산점수
	GetFeelingPoint = function (mountInfo)
	
		if mountInfo == nil then
			return FEELING_BAD
		end
		
		local totalPoint = 0
		for cond,points in pairs(ConditionPoints) do
			local curValue	= mountInfo:GetMountConditions(cond)		
			local curStep	= 1
			
			local stepCount = table.getn(points)
			for step=stepCount,1,-1 do
				local divideValue = mountInfo:GetMountConditionDivideValue(cond, step-1)
				--__DEBUG('MountCondition('..cond..')='..curValue..', divideCheck='..divideValue..'\n')			
				if curValue >= divideValue then
					local curPoint = points[step]
					totalPoint = totalPoint + curPoint
					--__DEBUG('MountCondition('..cond..')='..curValue..' --> '..curPoint..'\n')
					break
				end
			end		
		end
		
		-- 관리 정지가 되면 전체 관리포인트에서 마이너스
		local stopAmends = (mountInfo:GetMountConditions(MountCondition_StopAmendsPoint) == kMAX_NORMAL_MANAGE_POINT)
		if stopAmends then
			totalPoint = totalPoint - 10
		end
		
		return totalPoint
	end,
	
	-- 말의 기분 상태 단계
	GetFeelingLevel = function (mountInfo)
		if mountInfo.mountState == MountState_Foal then
			return FEELING_GOOD
		end

		local totalPoint = RanchHorseConfig.GetFeelingPoint(mountInfo)
		local feelingLevel = GetFeelingLevelByPoint(totalPoint)
	    
		--__DEBUG('--> TotalPoint('..totalPoint..'), FeelingLevel = '..feelingLevel..'\n')

		return feelingLevel
	end,
}

-- 바라볼때 이펙트 설정
Effect_GazeAt =
{
	Incident	= INCIDENT_RANCH_HORSE_GAZING,
	FirstDelay	= function() return math.random(10,20)*0.1 end,		-- 처음 나타날때의 딜레이
    ShowDelay	= function() return math.random(40,60)*0.1 end,		-- 그 이후부터 출력 딜레이
}

-- 따라다닐때 이펙트 설정
Effect_Follow =
{
	Incident	= INCIDENT_RANCH_HORSE_FOLLOWING,
	FirstDelay	= function() return math.random(30,40)*0.1 end,		-- 처음 나타날때의 딜레이
    ShowDelay	= function() return math.random(40,60)*0.1 end,		-- 그 이후부터 출력 딜레이
}
require('logichelper')

--
-- 마법전 로직스크립트
--

function MakeImpactVector(len)
	local impactVec = v3(len, len, len)		-- 튀는 방향(x,위,z)
		
	-- 카메라 튀는 방향 랜덤
	if math.random(1, 2.5) == 1 then impactVec.x = -impactVec.x end
	if math.random(1, 2.5) == 1 then impactVec.y = -impactVec.y end
	if math.random(1, 2.5) == 1 then impactVec.z = -impactVec.z end
	
	return impactVec
end

-- 데미지 효과
DamageModify = 
{
	-- 슬라이딩으로 줄어드는 데미지시간: 1이면 원래 그대로.. 0이면 전혀 안받는 경우
	ReduceTimeBySliding = function (slidingType, slidingTime)
		
		-- 0.1초 이상 슬라이딩 했으면 80%만 시간을 적용한다.
		if slidingTime >= 0.1 then
			return 0.8
		end
		
		return 1
	end,
}


-- Fireball(회전하면서 날아가는 미사일)
AttackFireball =
{
	StartAttach			= false,								-- 사용하자마자 이펙트를 붙이는가? true=발사, false=캐스팅시
	StartGap			= function(mat)	return v3(0,0,0) end,  	-- 시작 위치 보정값
	CastingTime			= 0.45,									-- 발사 후 캐스팅 동작 딜레이
	StartHeight			= 2.2,									-- 미사일 바닥에서부터의 높이 
	StartSpeed			= 80,									-- 미사일 최초 발사 속도
	SpeedAccel			= 90,									-- 미사일 초당 가속도
	MaxSpeed			= 150,									-- 미사일 최대 속도
	HitTargetDistance	= 0.2,									-- 미사일 hit거리
	CurveWidth			= function(ratio)	return (0-ratio)*0 end,		-- 미사일 커브 넓이(ratio=0(시작)~1(도착))
	CurveHeight			= function(ratio)	return (0-ratio)*0 end,		-- 미사일 커브 높이(ratio=0(시작)~1(도착))

	-- 실패 시 미사일 위치 결정
	MissPos				= function(mat, vel)		return mat.pos end,		-- dummy function

	-- 미사일 최종 위치 결정
	MovePos = function(curPos, matMove, ratio, totalLen, remainLen)

		local waveCount = math.floor(totalLen/20)
		waveCount = math.max(1, waveCount)
		
		local sinValue  = math.sin(waveCount*ratio * 2*math.pi)
		local cosValue  = math.cos(waveCount*ratio * 2*math.pi)
		
		local focusDist = 5		-- 가운데로 몰리는 거리
		local focusRatio = 1
		if remainLen-AttackFireball.HitTargetDistance <= focusDist then
			focusRatio = (remainLen-AttackFireball.HitTargetDistance)/focusDist
			focusRatio = focusRatio>0 and focusRatio or 0
		end

		local widthGap = matMove.right * sinValue * AttackFireball.CurveWidth(ratio) * focusRatio
		local heightGap = matMove.up * cosValue * AttackFireball.CurveHeight(ratio) * focusRatio

		local movePos = curPos + widthGap + heightGap
		
		return movePos
	end,
}

-- Fireball 실패
MissFireball =
{
	StartAttach			= false,								-- 사용하자마자 이펙트를 붙이는가? true=발사, false=캐스팅시
	StartGap			= function(mat)	return v3(0,0,0) end,  	-- 시작 위치 보정값
	CastingTime			= 0.45,									-- 발사 후 캐스팅 동작 딜레이
	StartHeight			= 2.2,									-- 미사일 바닥에서부터의 높이 
	StartSpeed			= 80,									-- 미사일 최초 발사 속도
	SpeedAccel			= 90,									-- 미사일 초당 가속도
	MaxSpeed			= 150,									-- 미사일 최대 속도
	HitTargetDistance	= 0.2,									-- 미사일 hit거리
	CurveWidth			= function(ratio)	return (1-ratio)*2 end,		-- 미사일 커브 넓이(ratio=0(시작)~1(도착))
	CurveHeight			= function(ratio)	return (0-ratio)*0 end,		-- 미사일 커브 높이(ratio=0(시작)~1(도착))

	-- 실패 시 미사일 위치 결정
	MissPos				= function(mat, vel)		
		local flyingDist = 30+vel
		local frontGap	= mat.at * flyingDist
		local sideGap	= mat.right * (math.random(1,100) < 50 and 1 or -1) * math.random(3,6)
		local heightGap = mat.up * math.random(3,7)
		
		local targetPos = mat.pos + frontGap + sideGap + heightGap
		return targetPos
	end,
	
	-- 미사일 최종 위치 결정
	MovePos = function(curPos, matMove, ratio, totalLen, remainLen)

		local waveCount = math.floor(totalLen/40)
		waveCount = math.max(1, waveCount)
		
		local sinValue  = math.sin(waveCount*ratio * 2*math.pi)
		local cosValue  = math.cos(waveCount*ratio * 2*math.pi)
		
		local focusDist = 5		-- 가운데로 몰리는 거리
		local focusRatio = 1
		if remainLen-MissFireball.HitTargetDistance <= focusDist then
			focusRatio = (remainLen-MissFireball.HitTargetDistance)/focusDist
			focusRatio = focusRatio>0 and focusRatio or 0
		end

		local widthGap = matMove.right * sinValue * MissFireball.CurveWidth(ratio) * focusRatio
		local heightGap = matMove.up * cosValue * MissFireball.CurveHeight(ratio) * focusRatio

		local movePos = curPos + widthGap + heightGap
		
		return movePos
	end,
}

-- Darkfire( 카메라 방해 미사일 )
AttackDarkfire =
{
	StartAttach			= false,								-- 사용하자마자 이펙트를 붙이는가? true=발사, false=캐스팅시
	StartGap			= function(mat)	return v3(0,0,0) end,  	-- 시작 위치 보정값
	CastingTime			= 0.2,									-- 발사 후 캐스팅 동작 딜레이
	StartHeight			= 2.7,									-- 미사일 바닥에서부터의 높이 
	StartSpeed			= 80,									-- 미사일 최초 발사 속도
	SpeedAccel			= 40,									-- 미사일 초당 가속도
	MaxSpeed			= 180,									-- 미사일 최대 속도
	HitTargetDistance	= 0.2,									-- 미사일 hit거리
	CurveWidth			= function(ratio)	return (1-ratio)*2 end,		-- 미사일 커브 넓이(ratio=0(시작)~1(도착))
	CurveHeight			= function(ratio)	return (1-ratio)*-1 end,		-- 미사일 커브 높이(ratio=0(시작)~1(도착))

	-- 실패 시 미사일 위치 결정
	MissPos				= function(mat, vel)		return mat.pos end,		-- dummy function

	-- 미사일 최종 위치 결정
	MovePos = function(curPos, matMove, ratio, totalLen, remainLen)

		local waveCount = math.floor(totalLen/70)
		waveCount = math.max(1, waveCount)
		
		local sinValue  = math.sin(waveCount*ratio * 2*math.pi)
		local cosValue  = math.cos(waveCount*ratio * 2*math.pi)
		
		local focusDist = 5		-- 가운데로 몰리는 거리
		local focusRatio = 1
		if remainLen-AttackDarkfire.HitTargetDistance <= focusDist then
			focusRatio = (remainLen-AttackDarkfire.HitTargetDistance)/focusDist
			focusRatio = focusRatio>0 and focusRatio or 0
		end

		local widthGap = matMove.right * sinValue * AttackDarkfire.CurveWidth(ratio) * focusRatio
		local heightGap = matMove.up * cosValue * AttackDarkfire.CurveHeight(ratio) * focusRatio

		local movePos = curPos + widthGap + heightGap
		
		return movePos
	end,
}

-- Darkfire실패
MissDarkfire =
{
	StartAttach			= false,								-- 사용하자마자 이펙트를 붙이는가? true=발사, false=캐스팅시
	StartGap			= function(mat)	return v3(0,0,0) end,  	-- 시작 위치 보정값
	CastingTime			= 0.2,									-- 발사 후 캐스팅 동작 딜레이
	StartHeight			= 2.7,									-- 미사일 바닥에서부터의 높이 
	StartSpeed			= 80,									-- 미사일 최초 발사 속도
	SpeedAccel			= 40,									-- 미사일 초당 가속도
	MaxSpeed			= 120,									-- 미사일 최대 속도
	HitTargetDistance	= 0.2,									-- 미사일 hit거리
	CurveWidth			= function(ratio)	return (1-ratio)*2 end,		-- 미사일 커브 넓이(ratio=0(시작)~1(도착))
	CurveHeight			= function(ratio)	return (1-ratio)*-1 end,		-- 미사일 커브 높이(ratio=0(시작)~1(도착))

	-- 실패 시 미사일 위치 결정
	MissPos				= function(mat, vel)		
		local flyingDist = 30+vel*1.5
		local frontGap	= mat.at * flyingDist
		local sideGap	= mat.right * math.random(-8,8)
		local heightGap = mat.up * math.random(-1,5)
		
		local targetPos = mat.pos + frontGap + sideGap + heightGap
		return targetPos
	end,

	-- 미사일 최종 위치 결정
	MovePos = function(curPos, matMove, ratio, totalLen, remainLen)

		local waveCount = math.floor(totalLen/70)
		waveCount = math.max(1, waveCount)
		
		local sinValue  = math.sin(waveCount*ratio * 2*math.pi)
		local cosValue  = math.cos(waveCount*ratio * 2*math.pi)
		
		local focusDist = 5		-- 가운데로 몰리는 거리
		local focusRatio = 1
		if remainLen-MissDarkfire.HitTargetDistance <= focusDist then
			focusRatio = (remainLen-MissDarkfire.HitTargetDistance)/focusDist
			focusRatio = focusRatio>0 and focusRatio or 0
		end

		local widthGap = matMove.right * sinValue * MissDarkfire.CurveWidth(ratio) * focusRatio
		local heightGap = matMove.up * cosValue * MissDarkfire.CurveHeight(ratio) * focusRatio

		local movePos = curPos + widthGap + heightGap
		
		return movePos
	end,
}


-- 직선으로 날아가는 반사되는 미사일
AttackDirect =
{
	StartAttach			= true,									-- 사용하자마자 이펙트를 붙이는가? true=발사, false=캐스팅시
	StartGap			= function(mat)	return v3(0,0,0) end,  	-- 시작 위치 보정값
	CastingTime			= 0.45,											-- 발사 후 캐스팅 동작 딜레이
	StartHeight			= 2.5,											-- 미사일 바닥에서부터의 높이 
	StartSpeed			= 100,											-- 미사일 최초 발사 속도
	SpeedAccel			= 40,											-- 미사일 초당 가속도
	MaxSpeed			= 130,											-- 미사일 최대 속도
}

-- 자동 앞사람 공격 날아가는 부분만
AttackSummonFly =
{
	StartAttach			= false,								-- 사용하자마자 이펙트를 붙이는가? true=발사, false=캐스팅시
	StartGap			= function(mat)	return v3(0,0,0) end,  	-- 시작 위치 보정값
	CastingTime			= 0.45,									-- 발사 후 캐스팅 동작 딜레이
	StartHeight			= 2.2,									-- 미사일 바닥에서부터의 높이 
	StartSpeed			= 80,									-- 미사일 최초 발사 속도
	SpeedAccel			= 90,									-- 미사일 초당 가속도
	MaxSpeed			= 100,									-- 미사일 최대 속도
	HitTargetDistance	= 0.2,									-- 미사일 hit거리
	CurveWidth			= function(ratio)	return (ratio<0.5 and ratio or 1-ratio)*5 end,		-- 미사일 커브 넓이(ratio=0(시작)~1(도착))
	CurveHeight			= function(ratio)	return (ratio<0.5 and ratio or 1-ratio)*5 end,		-- 미사일 커브 높이(ratio=0(시작)~1(도착))

	-- 미사일 최종 위치 결정
	MovePos = function(curPos, matMove, ratio, totalLen, remainLen)

		local waveCount = math.floor(totalLen/40)
		waveCount = math.max(1, waveCount)
		
		local sinValue  = math.sin(waveCount*ratio * 2*math.pi)
		local sinValue2  = math.cos(ratio * math.pi)
		
		local focusDist = 5		-- 가운데로 몰리는 거리
		local focusRatio = 1
		if remainLen-AttackSummonFly.HitTargetDistance <= focusDist then
			focusRatio = (remainLen-AttackSummonFly.HitTargetDistance)/focusDist
			focusRatio = focusRatio>0 and focusRatio or 0
		end

		local widthGap = matMove.right * sinValue * AttackSummonFly.CurveWidth(ratio) * focusRatio
		local heightGap = matMove.up * sinValue2 * AttackSummonFly.CurveHeight(ratio) * focusRatio

		local movePos = curPos + widthGap + heightGap
		
		return movePos
	end,
}


-- 자동 앞사람 공격
AttackSummon =
{
	StartAttach			= false,										-- 사용하자마자 이펙트를 붙이는가? true=발사, false=캐스팅시
	StartGap			= function(mat)								-- 시작 위치 보정값
		return mat.at*AttackSummon.FrontDist + v3(0,1,0)*AttackSummon.FrontHeight
	end,  	
	
	FrontDist			= 1,											-- 보는 방향 앞쪽 거리
	FrontHeight			= 3.1,											-- 보는 방향 위쪽 거리
		
	TargetChangeDelay	= 1,											-- 대상에게 옮긴후, 다시 옮겨질때까지의 딜레이(초)
	TargetChangeMoveDelay = 0.5,										-- 대상까지 이동하는 시간(초)
	ChangeTargetByDistance = false,										-- 대상 옮기기를 거리(TargetSelectDistance)로 하는가? true면 아래값, false면 충돌로.
	TargetSelectDistance = 5,											-- ChangeTargetByDistance=true인 경우 옮기기 판정하는 거리

	CastingTime			= 0.7,											-- 발사 후 캐스팅 동작 딜레이
	EffectShowTime		= 1.9,											-- 이펙트 보여지는 시간(용이 불 뿜기 전까지 시간)
	FireShowTime		= 0.15,											-- 미사일 날아가는 것처럼 보여지는 시간
	HitShowTime			= 0.45,											-- 미사일 맞고 나서 이펙트 더 보여주는 시간
	StartHeight			= 0,											-- 미사일 바닥에서부터의 높이 
	StartSpeed			= 45,											-- 미사일 최초 발사 속도
	SpeedAccel			= 100,											-- 미사일 초당 가속도
	MaxSpeed			= 180,											-- 미사일 최대 속도
	
	-- 캐스팅 전의 이동
	CastingMovePos = function (curPos, targetPos, targetDir, ratio)
		
		local waveCount	 = 1
		local waveCountY = 1
		local waveWidth  = 0.2
		local waveHeight = 0.2
		local sinValue  = math.sin(waveCount*ratio * 2*math.pi)
		local cosValue  = math.cos(waveCount*ratio * 2*math.pi)
		local sinValueY = math.sin(waveCountY*ratio * 2*math.pi)
		local waveY		= waveHeight * sinValueY
		
		local gapX = waveWidth * cosValue
		local gapZ = waveWidth * sinValue
		
		--local newPos = curPos + v3(gapX, 0, gapZ)
		local newPos = targetPos + targetDir*AttackSummon.FrontDist + v3(0,1,0)*AttackSummon.FrontHeight + v3(gapX, 0, gapZ)
		
		return newPos
	end,
}

-- 1등 번개 공격
AttackLightning =
{
	StartAttach			= true,									-- 사용하자마자 이펙트를 붙이는가? true=발사, false=캐스팅시
	StartGap			= function(mat)	return v3(0,0,0) end,  	-- 시작 위치 보정값
	CastingTime			= 0.75,											-- 발사 후 캐스팅 동작 딜레이	
	WaitHitTime			= 1.5,											-- 잠시후에 타격
	SplashHitDelay			= 0.2,									-- 타격 후에 스플래쉬 데미지 체크 딜레이 시간(초)
	ScreenDamageTime 	= 1.49,								-- 번개 떨어진후에 화면 전체 ScreenDamage출력 시작 시간(WaitHitTime보다 짧아야함)
	MassDamageRadius	= 10,									-- 광역 범위 : 반지름
	MassDamageHeight	= 4,									-- 광역 범위 : 높이/2
	SplashDecalFadeOutTime = 0.2,                               -- 범위 출력 데칼 fade-out시간
}

-- 점프마비 전체 공격
AttackJumpStun =
{
	AssetName			= "magic_upice_trace01",						-- asset 이름(없으면 안됨)
	FXInterval			= 1,											-- 꼬리 생성 주기(초)
	Scale				= 0.1,											-- 크기 스케일
	CastingTime			= 0.45,											-- 발사 후 캐스팅 동작 딜레이
	BaseHeight			= 2.2,											-- 바닥에서부터 높이 보정
	DirectMoveRoadCount = 3,											-- 직선으로 다다갈 남은 길 개수(개당 대략 5미터?)
	ArriveDist			= 0.1,											-- 도착 판정 거리
	
	-- 이동 속도
	Speed	= function(moveTime, remainRoadCount)			-- (moveTime=이동한시간, remainRoadCount=남은 길 수)	
	
		local basicSpeed	= 150				-- 출발 속도
		local accelSpeed	= 400				-- 초당 가속도
		local maxSpeed		= 1000				-- 최대 속도								
		
		local speed = math.min( basicSpeed + moveTime*accelSpeed , maxSpeed )
		return speed
	end,
	
	-- 이건 아래의 ModifyPos()에서만 호출된다.
	BasicModifyPos		= function(moveTime, index, maxIndex, matMove, speed)
		-- 기본 위치 잡기
		local waveRatio = index/math.max(1,maxIndex)
		
		local curveWidth = 1 * 1/AttackJumpStun.Scale
		local curveHeight = 1 * 1/AttackJumpStun.Scale
		
		local sinValue  = math.sin(waveRatio * 2*math.pi)
		local cosValue  = math.cos(waveRatio * 2*math.pi)

		local widthGap	= matMove.right*AttackJumpStun.Scale * sinValue * curveWidth							
		local heightGap = matMove.up*AttackJumpStun.Scale * cosValue * curveHeight

		local basicModifyPos = widthGap + heightGap
		
		return basicModifyPos
	end,
	
	-- 이동 위치 보정					
	ModifyPos			= function(moveTime, index, maxIndex, matMove, speed, remainDist)		-- (moveTime=이동한시간, index=동시 발사한 것 중 몇번째것, matMove=현재matrix, speed=현재속도, remainDist=남은 거리)
	
		-- 자체 회전
		local focusDist = 20		-- 가운데로 몰리는 거리
		local indexRatio = index/math.max(1,maxIndex)
		local waveTime	= 0.4					-- waveTime시간 당 한바퀴
		waveTime = waveTime + indexRatio*0.2
		local waveRatio = moveTime/waveTime + indexRatio
		
		local curveWidth = 2 * 1/AttackJumpStun.Scale
		local curveHeight = 1.5 * 1/AttackJumpStun.Scale
		
		local focusRatio = 1
		if remainDist-AttackJumpStun.ArriveDist <= focusDist then
			focusRatio = (remainDist-AttackJumpStun.ArriveDist)/focusDist
			focusRatio = focusRatio>0 and focusRatio or 0
			curveWidth = curveWidth * focusRatio
			curveHeight = curveHeight * focusRatio
		end
		
		
		local sinValue  = math.sin(waveRatio * 2*math.pi)
		local cosValue  = math.cos(waveRatio * 2*math.pi)

		local widthGap	= matMove.right*AttackJumpStun.Scale * sinValue * curveWidth							
		local heightGap = matMove.up*AttackJumpStun.Scale * cosValue * curveHeight

		local basicModifyPos	= AttackJumpStun.BasicModifyPos(moveTime, index, maxIndex, matMove, speed)
		local modifyPos			= basicModifyPos*focusRatio + widthGap + heightGap
		
		return modifyPos
	end,
}

-- 장애물 2단계 생성 정보
ObstacleCritical =
{
	RemainTime	= 10,												-- 지속 시간(초)
	FadeInTime  = 0.5,												-- 서서히 나타나는 시간(초)
	AlphaStart  = 90,												-- 시작 알파값(0~255)
	AlphaMax	= 170,												-- 최대 알파값(0~255)
}

----------------------------------------------------------------------------------------------------------------
--
--									아래는 맞거나 사용했을 때 효과
--
----------------------------------------------------------------------------------------------------------------
-- [효과] 기본 맞음 효과
DefaultBeaten =
{
	ClientResetByState = false,											-- client에서 데미지모션이 끝나면 reset해버리는가?(서버에서 reset하지 않는 경우)
	CanActionOnDamage = false,											-- 공격 받는 모션 출력 중에 마법을 사용할 수 있는가?
	TotalEffectTime	= 0,												-- default 0 : 바꾸지 말것
	DamageState		= "ITEM_NORMAL_DMG",								-- 공격 상태
	DamageStateSpeed = 1,												-- 기본 ani속도(1배)
	DamageLayer		= "",												-- 공격 받았을때 layer motion
	
	LimitMaxVelocity = -1,												-- 최대 속도 제한(0 이상인 경우 적용)
	LimitVelocity	= 0,												-- 속도 제한(데미지 모션 동안, 무조건 이 속도)
	LimitTime		= 0,												-- 속도 제한 시간(초). 서버에서 정해주는 시간보다 크다면 서버시간까지만 적용됨
	
	RotateTime		= 0,												-- 강제 회전 시간. 0이면 서버에서 주는대로.. 아니면 지정된 시간(초)만큼
	RotateVelocity	= 0,												-- 초당 회전 각속도(360도=한바퀴)
	
	KeyBlock		= false,											-- 효과 적용 시 key가 막히는가?
	JumpBlock		= false,											-- 효과 적용 시 jump가 막히는가?
	JumpDecision	= false,											-- 점프 판정을 해주는가?
	
	CameraImpact	= true,												-- 카메라 충격 주는가?
	CameraImpactTime = 0.5,												-- 카메라 충격 시간
	CameraImpactVector = function () return MakeImpactVector(0.3) end,	-- 카메라 충격 방향
	CameraRotate	= false,											-- 카메라 회전 하는가?
	
	FogEffect		= false,											-- 포그 효과
	FogEffectTime	= 0,												-- 포그 효과 시간(초)
	FogFadeInTime = 0,												-- 포그 시작시 fadeIn시간(초)
	FogFadeOutTime = 0,											-- 포그 종료시 fadeOut시간(초)
	FogEffectColor	= v3(5, 5, 35),										-- 포그 색깔(R, G, B) - 각각 0~255
	
	BalanceBoostAcc		= 30,											-- 피해 후, 초당 가속도
	BalanceBoostAccTime	= 1,											-- 피해 후, 초당 가속도 적용 시간
	
	AngularSpeedRatio	= 1,											-- 마법으로 조향력 추가 적용((몇배인가?: 기본값 1 = 100%)
	ForceKeyEnable		= false,										-- 강제 키 눌림 적용하는가?
	ForceKeyPeriodTime	= 0,											-- 강제 키 눌림 적용시, 키 변경 주기(초)
}

-- [효과] 미사일 맞았을때
FireballDamage =
{
	TotalEffectTime	= 0,												-- default 0 : 바꾸지 말것
	DamageState		= "ITEM_NORMAL_DMG",									-- 공격 상태

	LimitVelocity	= 40,												-- 속도 제한	
	LimitTime		= 2,												-- 속도 제한 시간(초). 서버에서 정해주는 시간보다 크다면 서버시간까지만 적용됨
	
	KeyBlock		= true,												-- 효과 적용 시 key가 막히는가?
	
	CameraImpactTime = 0.5,												-- 카메라 충격 시간
	CameraImpactVector = function () return MakeImpactVector(0.3) end,	-- 카메라 충격 방향
}

-- [효과] 미사일 맞았을때(Critical)
FireballDamageCritical =
{
	--DamageStateSpeed = 0.5,												-- ani속도
	DamageState		= "ITEM_CRITICAL_DMG",								-- 공격 상태

	LimitVelocity	= 30,												-- 속도 제한	
	LimitTime		= 3,												-- 속도 제한 시간(초). 서버에서 정해주는 시간보다 크다면 서버시간까지만 적용됨

	CameraImpactTime = 0.7,												-- 카메라 충격 시간
	CameraImpactVector = function () return MakeImpactVector(0.7) end,	-- 카메라 충격 방향
}

-- [효과] 점프 불가
JumpStunDamage =
{
	DamageState		= "ITEM_JUMPSTUN_DMG",									-- 공격 상태
	CanActionOnDamage = true,											-- 공격 받는 모션 출력 중에 마법을 사용할 수 있는가?

	LimitMaxVelocity = 80,												-- 최대 속도 제한(0 이상인 경우 적용)
	LimitTime		= 0,												-- 속도 제한 시간(초). 서버에서 정해주는 시간보다 크다면 서버시간까지만 적용됨
	
	KeyBlock		= false,											-- 효과 적용 시 key가 막히는가?
	JumpBlock		= true,											-- 효과 적용 시 jump가 막히는가?
	
	CameraImpactTime = 2.5,												-- 카메라 충격 시간
	CameraImpactVector = function () return MakeImpactVector(0.6) end,	-- 카메라 충격 방향	
}

-- [효과] 점프 불가 (크리티컬)
JumpStunDamageCritical =
{
	LimitMaxVelocity = 80,												--최대 속도 제한 (0 이상인 경우 적용)
}

-- [효과] 카메라 방해 미사일
DarkfireDamage =
{
	DamageState		= "ITEM_DARKFIRE_DMG",									-- 공격 상태
	DamageLayer		= "LAYER_DAMAGE",									-- 공격 받았을때 layer motion
	CanActionOnDamage = true,											-- 공격 받는 모션 출력 중에 마법을 사용할 수 있는가?

	JumpDecision 		= true, 	
	CameraImpactTime = 5,												-- 카메라 충격 시간
	CameraImpactVector = function () return MakeImpactVector(0.6) end,	-- 카메라 충격 방향
	
	--CameraRotate		= true,												-- 카메라 회전 하는가?
	--CameraRotateTime	= 2,												-- 카메라 회전 시간
	--CameraRotateAngle	= 360/2,											-- 카메라 회전 각도(1초 동안 도는 각도)	
	
	FogEffect		= true,												-- 포그 효과
	FogEffectTime	= 6,												-- 포그 효과 시간(초)
	FogFadeInTime = 1,												-- 포그 시작시 fadeIn시간(초)
	FogFadeOutTime = 0,											-- 포그 종료시 fadeOut시간(초)
	FogEffectColor	= v3(5, 5, 35),										-- 포그 색깔(R, G, B) - 각각 0~255

	ForceKeyEnable		= true,										-- 강제 키 눌림 적용하는가?
	ForceKeyPeriodTime	= 0.3,											-- 강제 키 눌림 적용시, 키 변경 주기(초)
}

-- [효과] 카메라 방해 미사일(크리티컬)
DarkfireDamageCritical =
{
	DamageState		= "ITEM_DARKFIRE_CRITICAL_DMG",									-- 공격 상태
	FogEffectTime	= 7,												-- 포그 효과 시간(초)

	CameraImpactVector = function () return MakeImpactVector(2.0) end,	-- 카메라 충격 방향
	CameraImpactTime = 6,												-- 카메라 충격 시간
}

-- [효과] 자동 공격되는 미사일
SummonDamage =
{
	DamageState		= "ITEM_NORMAL_DMG",									-- 공격 상태

	LimitVelocity	= 20,												-- 속도 제한	
	LimitTime		= 2,												-- 속도 제한 시간(초). 서버에서 정해주는 시간보다 크다면 서버시간까지만 적용됨
	
	KeyBlock		= true,												-- 효과 적용 시 key가 막히는가?

	CameraImpactTime = 1,												-- 카메라 충격 시간
	CameraImpactVector = function () return MakeImpactVector(0.3) end,	-- 카메라 충격 방향
}

-- [효과] 자동 공격되는 미사일(크리티컬)
SummonDamageCritical =
{
	--DamageStateSpeed = 0.5,												-- ani속도
	DamageState		= "ITEM_CRITICAL_DMG",								-- 공격 상태
	
	LimitVelocity	= 20,												-- 속도 제한	
	LimitTime		= 4,												-- 속도 제한 시간(초). 서버에서 정해주는 시간보다 크다면 서버시간까지만 적용됨
	
}

-- [효과] 1등 번개 공격
LightningDamage =
{
	TotalEffectTime	= 3.0,												-- 강제로 전체 효과가 끝나는 시간(필수 지정)
	DamageState		= "ITEM_THUNDER_DMG",								-- 공격 상태
	
	LimitVelocity	= 0,												-- 속도 제한	
	LimitTime		= 3,												-- 속도 제한 시간(초). 서버에서 정해주는 시간보다 크다면 서버시간까지만 적용됨
	
	KeyBlock		= true,											-- 효과 적용 시 key가 막히는가?
	
	CameraImpactTime = 1,												-- 카메라 충격 시간
	CameraImpactVector = function () return MakeImpactVector(0.5) end,	-- 카메라 충격 방향	
}

-- [효과] 1등 번개 공격(Critical)
LightningDamageCritical =
{
	--DamageStateSpeed = 0.5,												-- ani속도
	DamageState		= "ITEM_THUNDER_CRITICAL_DMG",							-- 공격 상태
	
	LimitVelocity	= 0,												-- 속도 제한	
	LimitTime		= 3,												-- 속도 제한 시간(초). 서버에서 정해주는 시간보다 크다면 서버시간까지만 적용됨

}

-- [효과] 드래곤한테 맞았을때
DragonBeaten =
{
	TotalEffectTime	= 1.6,												-- 강제로 전체 효과가 끝나는 시간(필수 지정)
	DamageState		= "ITEM_CRITICAL_DMG",								-- 공격 상태
	
	LimitVelocity	= 0,												-- 속도 제한	
	LimitTime		= 3,												-- 속도 제한 시간(초). 서버에서 정해주는 시간보다 크다면 서버시간까지만 적용됨
	
	KeyBlock		= true,											-- 효과 적용 시 key가 막히는가?
	JumpBlock		= false,											-- 효과 적용 시 jump가 막히는가?
	JumpDecision	= false,											-- 점프 판정을 해주는가?
	
	CameraImpact	= false,											-- 카메라 충격 주는가?
	CameraRotate	= false,											-- 카메라 회전 하는가?	
}

-- [효과] 드래곤한테 맞았을때(Critical)
DragonBeatenCritical =
{
}

-- 전투 테스트용
MeleeBeaten =
{
	ClientResetByState = true,											-- client에서 데미지모션이 끝나면 reset해버리는가?(서버에서 reset하지 않는 경우)
	TotalEffectTime	= 2,												-- 강제로 전체 효과가 끝나는 시간(필수 지정)
	DamageState		= "ITEM_NORMAL_DMG",								-- 공격 상태

	LimitVelocity	= 20,												-- 속도 제한	
	LimitTime		= 2,												-- 속도 제한 시간(초). 서버에서 정해주는 시간보다 크다면 서버시간까지만 적용됨
	
	KeyBlock		= true,												-- 효과 적용 시 key가 막히는가?
}

-- 기본 Speeding효과(이건 기본값)
DefaultSpeeding =
{
	MoveLoopState	= "",												-- 이동 반복 동작
	SpeedingEffectName	= "",											-- 붙일 이펙트 이름	
	StartDelay      = 0,                                                -- 시작시 딜레이 시간(초)
	MaxVelocity		= 0,												-- 최대 속도
	FinalMaxVelocity = 0,												-- 최대 속도(진행율 후반)
	OverlapBonusVelocity = 0,										-- 중첩시 추가 보너스 속도
	Accelration		= 0,												-- 초당 가속도
	IgnoreCollision = false,											-- 충돌 무시(true면 폭주)
	AngularSpeedRatio	= 1,											-- 마법으로 조향력 추가 적용(1배)
	SpurCameraLevel = 0,												-- 박차 카메라 효과(박차 레벨)
	CrashIncidentDelay = 0,												-- 폭주 충돌 사운드 딜레이 시간(초)
}

-- 박차 효과
BoosterEffect =
{
	MoveLoopState		= "",								-- 이동 반복 동작
	SpeedingEffectName	= "hr_speed_03",								-- 붙일 이펙트 이름
	MaxVelocity		= 110,												-- 최대 속도
	Accelration		= 100,												-- 초당 가속도
	OverlapBonusVelocity = 5,										-- 중첩시 추가 보너스 속도
	IgnoreCollision = false,											-- 충돌 무시(true면 폭주)
	SpurCameraLevel = 2,												-- 박차 카메라 효과(박차 레벨)
}

-- 박차 효과(Critical)
BoosterEffectCritical =
{
	MaxVelocity		= 120,												-- 최대 속도
	Accelration		= 100,												-- 초당 가속도
	IgnoreCollision = false,											-- 충돌 무시(true면 폭주)
}

-- 불박차 효과
HotRoddingEffect =
{
	MoveLoopState	= "",												-- 이동 반복 동작
	SpeedingEffectName	= "",										-- 붙일 이펙트 이름
	MaxVelocity		= 110,												-- 최대 속도
	FinalMaxVelocity = 95,												-- 최대 속도(진행율 후반)
	OverlapBonusVelocity = 5,										-- 중첩시 추가 보너스 속도
	Accelration		= 100,												-- 초당 가속도
	IgnoreCollision = true,												-- 충돌 무시(true면 폭주)
	AngularSpeedRatio	= 1,											-- 마법으로 조향력 추가 적용(몇배)
	SpurCameraLevel = 5,												-- 박차 카메라 효과(박차 레벨)
	CrashIncidentDelay = 1,												-- 폭주 충돌 사운드 딜레이 시간(초)
}

-- 불박차 효과(Critical)
HotRoddingEffectCritical =
{
	MaxVelocity		= 120,												-- 최대 속도
	FinalMaxVelocity = 105,												-- 최대 속도(진행율 후반)
	Accelration		= 100,												-- 초당 가속도
	IgnoreCollision = true,												-- 충돌 무시(true면 폭주)
}

-- 팀 박차 효과
BufSpeedEffect =
{
	StartDelay      = 0.8,                                                -- 시작시 딜레이 시간(초)
	MaxVelocity		= 95,												-- 최대 속도
	OverlapBonusVelocity = 10,										-- 중첩시 추가 보너스 속도
	Accelration		= 100,												-- 초당 가속도
	IgnoreCollision = false,											-- 충돌 무시(true면 폭주)
}

-- 팀 박차 효과(크리티컬)
BufSpeedEffectCritical =
{
	MaxVelocity		= 95,												-- 최대 속도
	Accelration		= 50,												-- 초당 가속도
	IgnoreCollision = false,											-- 충돌 무시(true면 폭주)
}

-- 공격 버프 마법 효과
BufPowerEffect =
{
}

-- 공격 버프 마법 효과
BufPowerEffectCritical =
{
}

-- 게이지 버프 마법 효과
BufGaugeEffect =
{
}

-- 게이지 버프 마법 효과
BufGaugeEffectCritical =
{
}

-- 장애물
IceWallDamage =
{
	ReduceVelocity	= 60,													-- 속도 감속량
	
	--BalanceBoostAcc		= 10,											-- 피해 후, 초당 가속도
	--BalanceBoostAccTime	= 1,											-- 피해 후, 초당 가속도 적용 시간
}

-- 장애물(크리티컬)
IceWallDamageCritical =
{
	ReduceVelocity	= 60,													-- 속도 감속량
	
	--BalanceBoostAcc		= 10,											-- 피해 후, 초당 가속도
	--BalanceBoostAccTime	= 1,											-- 피해 후, 초당 가속도 적용 시간
}

----------------------------------------------------------------------------------------------------------------
--
--					기본값 설정( source  -->  target )
-- target쪽에 설정안된 값은 source를 참고한다.
--
----------------------------------------------------------------------------------------------------------------
-- 기본 효과 설정
SET_DEFAULT( DefaultBeaten, FireballDamage )
SET_DEFAULT( DefaultBeaten, JumpStunDamage )
SET_DEFAULT( DefaultBeaten, SummonDamage )
SET_DEFAULT( DefaultBeaten, DarkfireDamage )
SET_DEFAULT( DefaultBeaten, LightningDamage )
SET_DEFAULT( DefaultBeaten, DragonBeaten )
SET_DEFAULT( DefaultBeaten, MeleeBeaten )

-- 기본 speeding 설정
SET_DEFAULT( DefaultSpeeding, BoosterEffect )
SET_DEFAULT( DefaultSpeeding, HotRoddingEffect )
SET_DEFAULT( DefaultSpeeding, BufSpeedEffect )


-- 크리티컬 효과 설정
SET_DEFAULT( FireballDamage, FireballDamageCritical )
SET_DEFAULT( JumpStunDamage, JumpStunDamageCritical )
SET_DEFAULT( SummonDamage, SummonDamageCritical )
SET_DEFAULT( DarkfireDamage, DarkfireDamageCritical )
SET_DEFAULT( LightningDamage, LightningDamageCritical )
SET_DEFAULT( DragonBeaten, DragonBeatenCritical )

SET_DEFAULT( BoosterEffect, BoosterEffectCritical )
SET_DEFAULT( HotRoddingEffect, HotRoddingEffectCritical )
SET_DEFAULT( BufSpeedEffect, BufSpeedEffectCritical )
SET_DEFAULT( BufPowerEffect, BufPowerEffectCritical )
SET_DEFAULT( BufGaugeEffect, BufGaugeEffectCritical )
SET_DEFAULT( IceWallDamage, IceWallDamageCritical )

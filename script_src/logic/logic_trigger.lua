require('logichelper')

--
-- 트리거 로직스크립트
--

-- Fire
TriggerFire =
{
	FXName				= "ob_rcslink01_ball_003",				-- 날아가는 이펙트 몸체 
    FXTailName			= "ob_rcslink01_ball_004",				-- 날아가는 이펙트 꼬리
	FXInterval			= 1,									-- 이펙트 업데이트 거리

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
		if remainLen-TriggerFire.HitTargetDistance <= focusDist then
			focusRatio = (remainLen-TriggerFire.HitTargetDistance)/focusDist
			focusRatio = focusRatio>0 and focusRatio or 0
		end

		local widthGap = matMove.right * sinValue * TriggerFire.CurveWidth(ratio) * focusRatio
		local heightGap = matMove.up * cosValue * TriggerFire.CurveHeight(ratio) * focusRatio

		local movePos = curPos + widthGap + heightGap
		
		return movePos
	end,
}

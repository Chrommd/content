require('logichelper')

local CONDITION = 0
local ACTION = 1
local BASE = 2


--[[
	-- 조건 종류
0    MagicUseCondition_Delay( 최소시간, 미사용, 미사용 )            -- 닥치고 대기.	
0    MagicUseCondition_RandomDelay( 최소시간, 랜덤 범위, 미사용 )            -- 닥치고 랜덤하게 대기.
0    MagicUseCondition_CheckPCinDist( 시간, PARAM_거리, PARAM_미사용 ) -- 일정 거리 내에 플레이어 캐릭터가 있는지 체크 (1:거리)
0    MagicUseCondition_CheckPCinSight(시간, PARAM_거리, PARAM_시야각 ) -- 시야 내에 플레이어 캐릭터가 있는지 체크 (1:거리, 2:각도)
0    MagicUseCondition_AimTarget,            // 타겟팅
	MagicUseCondition_AimTargetFront,       // 타겟팅 실패하고, 앞순위로 타겟 설정.
    MagicUseCondition_TargetIsAI,           // 타겟이 AI인가?
0    MagicUseCondition_KeepAim,              // 타겟 유지
0    MagicUseCondition_IsFirst,              // 1등인가?
    MagicUseCondition_NextPlayerHasMagic,   // 내 다음 플레이어가 마법을 갖고 있는가?
    MagicUseCondition_CheckCorner( 시간, VALUE_(미설정:나, 1:타겟), 미사용 ) -- 코너 체크
    MagicUseCondition_CheckCliff( 시간, VALUE_(미설정:나, 1:타겟), 미사용 )           // 절벽 체크
    MagicUseCondition_CheckLastSpurt( 시간, VALUE_(미설정:나, 1:타겟), 미사용 )       // 라스트 스퍼트 체크
    MagicUseCondition_CheckJumpObstacle( 시간, VALUE_(미설정:나, 1:타겟), 미사용 )    // 점프대 체크
	
	-- 액션 종류
	MagicUseAction_UseMagic,
    MagicUseAction_Breaking,
]]--
	
AIMagicUse = 
{
	MagicSlot_Fireball = function ()
		AI_MagicUse_StartLevel(0,-1,1)
        AI_MagicUse_Add( CONDITION,  MagicUseCondition_IsFirst )
		AI_MagicUse_EndLevel()

		AI_MagicUse_StartLevel(1,2,2)
        AI_MagicUse_Add( CONDITION,  MagicUseCondition_CheckPCinDist, 0, "MAGICITEM_CHECK_MIN_DIST" )
        AI_MagicUse_Add( ACTION,  MagicUseAction_Breaking, 2 )
		AI_MagicUse_EndLevel()
        
		AI_MagicUse_StartLevel(2,3,-1)
        AI_MagicUse_Add( CONDITION,  MagicUseCondition_AimTarget, 10 )
		AI_MagicUse_EndLevel()
        
		AI_MagicUse_StartLevel(3,4,5)
        AI_MagicUse_Add( CONDITION,  MagicUseCondition_TargetIsAI  )
		AI_MagicUse_EndLevel()
        
		AI_MagicUse_StartLevel(4,-1,-1)
        AI_MagicUse_Add( CONDITION,  MagicUseCondition_KeepAim, 1 )
        AI_MagicUse_Add( ACTION,  MagicUseAction_UseMagic, 0 )
		AI_MagicUse_EndLevel()

		AI_MagicUse_StartLevel(5,-1,-1)
        AI_MagicUse_Add( CONDITION,  MagicUseCondition_KeepAim, 3 )
        AI_MagicUse_Add( ACTION,  MagicUseAction_UseMagic, 0 )
        AI_MagicUse_EndLevel()

		return true
	end,
	
	
	MagicSlot_WaterShield = function ()
		AI_MagicUse_Add( BASE, MagicUseCondition_IsFirst )

        AI_MagicUse_StartLevel(0,1,2)
        AI_MagicUse_Add( CONDITION,  MagicUseCondition_NextPlayerHasMagic, 0 )
        AI_MagicUse_EndLevel()

        AI_MagicUse_StartLevel(1,-1,-1)
        AI_MagicUse_Add( CONDITION,  MagicUseCondition_Delay, 1, "MAGIC_USEDELAY_RAND_WARTERSHIELD" )
        AI_MagicUse_EndLevel()

        AI_MagicUse_StartLevel(2,-1,-1)
        AI_MagicUse_Add( CONDITION,  MagicUseCondition_Delay, 10 )
        AI_MagicUse_EndLevel()

		return true
	end,

	MagicSlot_Booster = function ()
		return false
	end,

	MagicSlot_HotRodding = function ()
		return false
	end,

	MagicSlot_IceWall = function ()
		AI_MagicUse_StartLevel(0,-1,-1, 1)
        AI_MagicUse_Add( CONDITION,  MagicUseCondition_CheckCorner, 10 )
        AI_MagicUse_Add( CONDITION,  MagicUseCondition_CheckJumpObstacle, 10 )
        AI_MagicUse_EndLevel()

		return true
	end,

	MagicSlot_JumpStun = function ()
		AI_MagicUse_StartLevel(0,-1,-1, 1)
        AI_MagicUse_Add( CONDITION,  MagicUseCondition_CheckCorner, 10 )
        AI_MagicUse_Add( CONDITION,  MagicUseCondition_CheckCliff, 10 )
        AI_MagicUse_Add( CONDITION,  MagicUseCondition_CheckLastSpurt, 10 )
        AI_MagicUse_EndLevel()

		return true
	end,

	MagicSlot_Darkfire = function ()
		AI_MagicUse_StartLevel(0,1,2)
        AI_MagicUse_Add( CONDITION,  MagicUseCondition_AimTarget, 10 )
        AI_MagicUse_EndLevel()

		-- 코너 체크. 코너이면 계속 반복 체크. 코너가 아닐경우 발사.
        AI_MagicUse_StartLevel(1,1,-1)
        AI_MagicUse_Add( CONDITION,  MagicUseCondition_CheckCorner, 0 )
        AI_MagicUse_EndLevel()

        AI_MagicUse_StartLevel(2,3,-1)
        AI_MagicUse_Add( CONDITION,  MagicUseCondition_AimTargetFront )
		AI_MagicUse_Add( CONDITION,  MagicUseCondition_TargetIsAI )
        AI_MagicUse_EndLevel()
		
		AI_MagicUse_StartLevel(3,-1,-1)
        AI_MagicUse_Add( CONDITION,  MagicUseCondition_CheckCorner, 10 )
        AI_MagicUse_EndLevel()
		
		return true
	end,

	MagicSlot_Summon = function ()
		AI_MagicUse_StartLevel(0,2,1)
        AI_MagicUse_Add( CONDITION,  MagicUseCondition_AimTarget, 10 )
        AI_MagicUse_EndLevel()
		
		AI_MagicUse_StartLevel(1,2,-1)
        AI_MagicUse_Add( CONDITION,  MagicUseCondition_AimTargetFront, 0 )
        AI_MagicUse_EndLevel()
		
		AI_MagicUse_StartLevel(2,-1,3)
        AI_MagicUse_Add( CONDITION,  MagicUseCondition_TargetIsAI )
        AI_MagicUse_EndLevel()
		
		AI_MagicUse_StartLevel(3,-1,-1)
        AI_MagicUse_Add( CONDITION,  MagicUseCondition_Delay, 2 )
        AI_MagicUse_EndLevel()

		return true
	end,

	MagicSlot_Lightning = function ()
		AI_MagicUse_StartLevel(0,-1,-1)
        AI_MagicUse_Add( CONDITION,  MagicUseCondition_Delay, 0, "MAGIC_USEDELAY_LIGHTNING" )
        AI_MagicUse_EndLevel()
		return true
	end,

	MagicSlot_BufPower = function ()
		return false
	end,

	MagicSlot_BufGauge = function ()
		return false
	end,

	MagicSlot_BufSpeed = function ()
		return false
	end,

}

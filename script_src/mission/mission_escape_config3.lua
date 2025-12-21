MISSION_TRY_TIME	= 10*60*60
ALL_DEAD_WAIT_TIME	= 10

OPENING_WAITING_TIME = 20
BATTLE_ENTER_EVENT_TIME = 10	-- 분지 전투 시작 이벤트
SEALING_HEAL_EVENT_TIME	= 22	-- 힐링 이벤트 시간
CASTLE_SUMMON_EVENT_TIME = 6	-- 성 소환시 이벤트 시간
BOSS_DEAD_EVENT_TIME	= 10	-- 죽을때 보여주는 시간

END_WAIT_TIME			= BOSS_DEAD_EVENT_TIME+20		-- 초

playerResurrectCount= 2
playerHPMax			= 200000
playerMPMax			= 500
basilBaseHP			= 10000
hyenaHP				= 350
eagleHP				= 360

resetBossToPlayerDist = 300		-- 멀리 떨어지면 소환되는 거리

resetStartPoint		= false
resetToBossPosition	= false		-- 보스와 멀어지면 강제 워프하는가?

playerStartPos		= v3(-254.29, -51.78, -13.56)
--playerStartPos		= v3(-243.90, -57.57, -54.82)
--playerStartPos		= v3(-408.49, -45.57, 847.61)
playerStartAt		= v3(-0.5, 0, 0.5)

basilPathName		= "basil_path"				

basilStartPosName		= "basil_start_point"
basilJumpPosName		= "basil_jump_point"

statoStartPosName		= "stato_start_point"

sealingPosName1 = "sealing_point_1"
sealingPosName2 = "sealing_point_2"
sealingPosName3 = "sealing_point_3"
sealingPosName4 = "sealing_point_4"
sealingPosName5 = "sealing_point_5"

ROAD_LIMIT			= false
CAMERA_TEST			= true
BOSS_STOP			= true
EFFECT_TEST			= true
NO_MONSTER			= false


-- basil config
bossWeakDelayTime			= 30
firstPhaseHPLimitPercent	= 70		-- 체력 % 이거 이하면 다음 단계
summonHPLimitPercent		= 30		-- 바실리스크가 소환하는 체력%
sealingActivateDelay		= 1		-- 두번째 단계에서 봉인 시작 딜레이
basilDefaultVelocity		= 12
basilPatrolVelocity			= 17    -- 길따라 갈때 속도


-- castle summon
castleSummonGatePosName		= "summon_gate_point"
castleSummonPosName			= "summon_point"
castleSummonHPPercent		= 99		-- 성이 소환하는 때의 바실리스크의 체력 %
castleSummonDelay			= 20		-- 성이 소환하는 딜레이(초)
castleSummonList =
{
	{ "hyena", "hyena2", v3(0,0,0) },
	{ "hyena", "hyena2", v3(0,0,0) },
	{ "eagle", "eagle", v3(0,10,0) },
}

bossHP = 1000

-- 분지이벤트1 테스트용
--forcePatrolIndex = 145


require('MissionTypes')
require('AIState')

OPENING_WAITING_TIME = 6.5
MISSION_TRY_TIME	= 10*60*60
ALL_DEAD_WAIT_TIME	= 10

BOSS_RUNAWAY_TIME	= 11

END_WAIT_TIME		= 20		-- 초

ITEM_DROP_DIST		= 50
ITEM_REMOVE_TIME	= 10

resetType			= RESET_1ST
topExtraRange		= 20
roadRange			= 100
resetRange			= 50
roadVelocity		= 28		-- player 기본 속도(95?)
dragonVelocity		= 28
reflectBreathCount  = 5
reflectionChargeDist	= 6		-- 차지 반사 판정거리
reflectionDist			= 4		-- 일반 반사 판정거리
reflectionChargeAngle	= 180	-- 차지 반사 판정각도
reflectionAngle			= 90	-- 일반 반사 판정각도

moveFrontRoadDistanceDash		= 15	-- 대쉬때 몇칸(reset point)이나 앞으로 가는가
moveFrontRoadDistanceBreathDash = 30  	-- FireBreath때 몇칸(reset point)이나 앞으로 가는가
moveFrontRoadDistanceBreath		= 10  	-- FireBreath때 몇칸(reset point)이나 앞으로 가는가

fireBreathCount		= 3
tailSplashAttackWidth = 10		-- TailSplash 공격 반경

playerResurrectCount= 10
playerHPMax			= 5000000
playerMPMax			= 500
dragonBaseHP		= 2000
hyenaHP				= 250
eagleHP				= 120

summonHyenaDelay	= 17
hyenaSideAttackTime = 20000

itemHealHP			= 50
itemBoosterMP		= 30

resetStartPoint		= false
playerStartPos		= v3(24.08, -11.08, -145.60)
playerStartAt		= v3(1, 0, 0)

bossPathName		= "boss_path"				

bossStartPosName	= "start_point"

NO_MONSTER			= false
SKIP_OPENING		= true
EFFECT_TEST			= true
BOSS_STOP			= true


dragonAttackPhase =
{
	--                    {전체딜레이, 스킬이름, 세트개수, 세부개수, 세트delay, 세부delay}
	{ hp={75,100},	skill={{10, "TAIL_SPLASH", 2, 5, 3, 1}, {10, "TAIL_SPLASH", 3, 5, 3, 1}},									summon={200, 2}, dashDamage=400 },
	{ hp={50,75},	skill={{15, "TAIL_SPLASH", 2, 5, 3, 1 }, {10, "TAIL_SPLASH2", 3, 5, 3, 1}},									summon={200, 4}, dashDamage=400 },
	{ hp={25,50},	skill={{10, "TAIL_SPLASH2", 3, 5, 3, 1 },	{10, "TAIL_SPLASH", 2, 5, 3, 1},	{15, "FIRE_SMASH", 1, 3, 3, 1}},	summon={300, 2}, breathDamage=350  },
	{ hp={0,25},	skill={{10, "TAIL_SPLASH2", 4, 5, 3, 1 },	{7, "TAIL_SPLASH", 2, 5, 3, 1},		{5, "FIRE_SMASH", 2, 3, 3, 1}},		summon={200, 4}, breathDamage=150  },
}

hyenaItemTable = 
{
	{ 10, ITEM_HP },
	{ 10, ITEM_MP }, 
	{ 10, ITEM_SPECIAL },
}

require('MissionTypes')
require('AIState')

OPENING_WAITING_TIME = 6.5
MISSION_TRY_TIME	= 10*60*60
ALL_DEAD_WAIT_TIME	= 10

BOSS_RUNAWAY_TIME	= 11

END_WAIT_TIME		= 20		-- 초

ITEM_DROP_DIST		= 120		-- 아이템 드랍되는 거리(미터)
ITEM_REMOVE_TIME	= 10		-- 아이템 드랍 후 사라지는 시간(초)

resetType			= RESET_1ST
topExtraRange		= 20
roadRange			= 150		-- 용과의 최대거리(길 길이)
resetRange			= 50
roadVelocity		= 30		-- player 기본 속도(95?)
dragonVelocity		= 26		-- 드래곤 속도
reflectBreathCount  = 20		-- 반사 몇대 맞아야 드래곤이 대쉬를 하는가
reflectionChargeDist	= 6		-- 차지 반사 판정거리
reflectionDist			= 4		-- 일반 반사 판정거리
reflectionChargeAngle	= 180	-- 차지 반사 판정각도
reflectionAngle			= 90	-- 일반 반사 판정각도
							
moveFrontRoadDistanceDash		= 12	-- 대쉬때 몇칸(reset point)이나 앞으로 가는가
moveFrontRoadDistanceBreathDash = 20  	-- FireBreath때 몇칸(reset point)이나 앞으로 가는가
moveFrontRoadDistanceBreath		= 10  	-- FireBreath때 몇칸(reset point)이나 앞으로 가는가
fireBreathCount				= 3		-- FireBreath 한번에 몇방 쏘는가?
tailSplashAttackWidth		= 20	-- TailSplash 공격 반경

playerResurrectCount= 10
playerHPMax			= 7000		-- 플레이어 체력
playerMPMax			= 500
dragonBaseHP		= 2000
hyenaHP				= 37		-- 하이에나 체력
eagleHP				= 120

summonHyenaDelay	= 17		-- 하이에나 소환 주기(초)
hyenaSideAttackTime = 25		-- 하이에나 달라붙어서 공격하는 시간(초)

itemHealHP			= 50		-- HP아이템 회복량
itemBoosterMP		= 40		-- MP아이템 박차게이지 증가량

resetStartPoint		= false
playerStartPos		= v3(24.08, -11.08, -145.60)
playerStartAt		= v3(1, 0, 0)

bossPathName		= "boss_path"				

bossStartPosName	= "start_point"

NO_MONSTER			= false
SKIP_OPENING		= false


dragonAttackPhase =
{
	--                    {전체딜레이, 스킬이름, 세트개수, 세부개수, 세트delay, 세부delay, 패턴(S,V,A,R)}
	{ hp={75,100},	skill={{10, "TAIL_SPLASH", 1, 20, 3, 0.5, "S"},		{13, "TAIL_SPLASH", 3, 20, 3, 0.5, "S"}},										summon={200, 2}, dashDamage=400 },
	{ hp={50,75},	skill={{15, "TAIL_SPLASH", 1, 20, 3, 0.5, "S"},	{10, "TAIL_SPLASH", 3, 20, 3, 0.5, "S"},	{15, "FIRE_SMASH", 1, 1, 3, 1}},	 						summon={200, 4}, dashDamage=350 },
	{ hp={25,50},	skill={{10, "TAIL_SPLASH2", 3, 5, 3, 1, "R"},	{15, "TAIL_SPLASH", 2, 5, 3, 1, "R"},	{10, "FIRE_SMASH", 1, 3, 3, 1}},							summon={300, 2}, dashDamage=300  },
	{ hp={0,25},	skill={{10, "TAIL_SPLASH2", 4, 5, 3, 1, "R"},	{7, "TAIL_SPLASH", 2, 5, 3, 1, "R"},		{5, "FIRE_SMASH", 2, 3, 3, 1}},						summon={200, 4}, breathDamage=1000  },
}

hyenaItemTable = 
{
	{ 10, ITEM_HP },
	{ 53, ITEM_MP }, 
	{ 37, ITEM_SPECIAL },
}

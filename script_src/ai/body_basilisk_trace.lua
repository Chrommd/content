-- module setup
require ('BodyHelper')

--module(..., package.seeall)

-- 몬스터 모양 설정
g_body['basilisk_trace'] = 
{

-- dff file
file  = "npc_bosstest",		

-- link
--[[	
link = 
{
	{ id=1, class="RcSimpleAsset", file="cone_blue", link="WP_1" },
	{ id=2, class="RcSimpleAsset", file="cone_blue", link="WP_2" },
	{ id=3, class="RcSimpleAsset", file="cone_blue", link="WP_3" },
	{ id=4, class="RcSimpleAsset", file="cone_red", link="WP_4" },
	{ id=5, class="RcSimpleAsset", file="cone_red", link="WP_5" },
	{ id=6, class="RcSimpleAsset", file="cone_purple", link="WP_6" },
	{ id=7, class="RcSimpleAsset", file="cone_purple", link="WP_7" },
	{ id=8, class="RcSimpleAsset", file="cone_black", link="WP_8" },
	{ id=9, class="RcSimpleAsset", file="cone_black", link="WP_9" },
	{ id=10, class="RcSimpleAsset", file="cone_black", link="WP_10" },
	{ id=11, class="RcSimpleAsset", file="cone_blue", link="WP_11" },
	{ id=12, class="RcSimpleAsset", file="cone_blue", link="WP_12" },
	{ id=13, class="RcSimpleAsset", file="cone_blue", link="WP_13" },
	{ id=14, class="RcSimpleAsset", file="cone_red", link="WP_14" },
	{ id=15, class="RcSimpleAsset", file="cone_red", link="WP_15" },
	{ id=16, class="RcSimpleAsset", file="cone_purple", link="WP_16" },
	{ id=17, class="RcSimpleAsset", file="cone_purple", link="WP_17" },
	{ id=18, class="RcSimpleAsset", file="cone_black", link="WP_18" },
	{ id=19, class="RcSimpleAsset", file="cone_black", link="WP_19" },
	{ id=20, class="RcSimpleAsset", file="cone_black", link="WP_20" },
	{ id=21, class="RcSimpleAsset", file="cone_blue", link="WP_21" },
	{ id=22, class="RcSimpleAsset", file="cone_blue", link="WP_22" },
	{ id=23, class="RcSimpleAsset", file="cone_blue", link="WP_23" },
	{ id=24, class="RcSimpleAsset", file="cone_red", link="WP_24" },
	{ id=25, class="RcSimpleAsset", file="cone_red", link="WP_25" },
	{ id=26, class="RcSimpleAsset", file="cone_purple", link="WP_26" },		
},
]]--

-- 타겟팅 dummy name
target = 
{
	"WP_1", "WP_2", "WP_3", "WP_4", "WP_5", "WP_6", "WP_7", "WP_8", "WP_9", "WP_10", 
	"WP_11", "WP_12", "WP_13", "WP_14", "WP_15", "WP_16", "WP_17", "WP_18", "WP_19", "WP_20", 
	"WP_21", "WP_22", "WP_23", "WP_24", "WP_25", "WP_26",
},

-- 추가 argument
args  = "-nostartmotion -collattack -nohp -shadow 9",

-- logic link
logic = 
{ 
	"RcLogicMobBody",
	"RcLogicBerserk",
},

-- 제일 앞에게 default state다. ani가 특별히 없으면 default가 된다.
states = 
{ 
	"G_IDLE", 
	"MONANI_DEFAULTMOVE", 
	"MONANI_ENTRANCE", 
	"MONANI_ATTACK_01",		-- 얼굴+꼬리치기 공격
	"MONANI_ATTACK_02",		-- 몸통 회전 공격
	"MONANI_ATTACK_03",		-- 몸통 drop
	"MONANI_ATTACKED_01",	-- 얼굴 아파하는 데미지 모션
	"MONANI_ATTACKED_02",	-- 다리 아파하다가 쓰러지는 데미지 모션 
	"MONANI_04", 
	"MONANI_05", 
	"MONANI_06", 
	"ATTACK", 
	"MONANI_ENDSUCCESS" 
},

-- skill
skill = 
{ 
	{ name="BREATH",	target=SKILL_TARGET_POSITION, state="ATTACK", timing=0.5, id=SKILLID_BREATH },
	{ name="ATTACK_SOUL",	target=SKILL_TARGET_POSITION, state="ATTACK", timing=2, id=SKILLID_ATTACK_SOUL },	
	{ name="VOLCANO",	target=SKILL_TARGET_POSITION, state="ATTACK", timing=2, id=SKILLID_VOLCANO },		
	{ name="VOLCANO_MOVING",	target=SKILL_TARGET_POSITION, state="G_IDLE", timing=0, id=SKILLID_VOLCANO_MOVING },		
	{ name="FIREWAVE",	target=SKILL_TARGET_POSITION, state="MONANI_06", timing=1.6, id=SKILLID_FIREWAVE },		
	{ name="SOULTOUCH",	target=SKILL_TARGET_POSITION, state="ATTACK", timing=2, id=SKILLID_SOULTOUCH },		
	{ name="PETRIFY",	target=SKILL_TARGET_OBJECT, state="MONANI_06", timing=1.6, id=SKILLID_PETRIFY },		
	{ name="SOULLINK",	target=SKILL_TARGET_OBJECT, state="ATTACK", timing=2, id=SKILLID_SOULLINK },		
	{ name="SUMMON",target=SKILL_TARGET_POSITION, state="ATTACK", timing=2, id=SKILLID_SUMMON },
	{ name="GAZE_BEAM",	target=SKILL_TARGET_OBJECT, state="MONANI_06", timing=1.6, id=SKILLID_GAZE_BEAM },		
	{ name="BODY_ATTACK",	target=SKILL_TARGET_POSITION, state="MONANI_ATTACK_01", timing=1.4, id=SKILLID_BODY_ATTACK },		
	{ name="BODY_HURRICANE",target=SKILL_TARGET_POSITION, state="MONANI_ATTACK_02", timing=1.3, id=SKILLID_BODY_HURRICANE },		
	{ name="BODY_PRESS",	target=SKILL_TARGET_POSITION, state="MONANI_ATTACK_03", timing=3, id=SKILLID_BODY_PRESS },			
},

-- 이동속도M
velocity = 35,

-- 접근거리
approach_dist = 2.5,

-- 리딩 거리
lead_dist = 40,

}
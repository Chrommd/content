-- module setup
require ('BodyHelper')

-- 몬스터 모양 설정
g_body['dragon_battle'] = 
{

-- dff file
file  = "m_oquilraconbig",

-- logic link
logic = { 
	"RcLogicEventKey", 
	"RcLogicMobBody", 
	"RcLogicMobGliding", 
	"RcLogicMobGlidingDead",
	"RcLogicBerserk",
},

-- 타겟팅 dummy name
target = 
{
	"AP_1", "AP_2", "AP_3", "AP_4", "AP_5", "AP_6", "AP_7",
},
	
-- 추가 argument
args  = "-nostartmotion -collattack -nohp -shadow 9 -displayAlways", -- -interpolater 

-- 제일 앞에게 default state다. ani가 특별히 없으면 default가 된다.
states = 
{ 
	"G_IDLE", "MOVE_1ST", "GLIDE", "DEAD", "MONANI_DEAD_START", "MONANI_ATTACK_01", "MONANI_ATTACK_02", "MONANI_ATTACK_03", "MONANI_ATTACK_04", 
	"MONANI_01", "MONANI_02", "MONANI_03", "MONANI_04", "MONANI_05", 
},

state_move = "MOVE_1ST",

-- skill
skill = 
{ 
	{ name="FIREBALL",	target=SKILL_TARGET_POSITION, state="D_FLY", timing=1.2, id=SKILLID_FIREBALL },
	{ name="BREATH",	target=SKILL_TARGET_OBJECT, state="D_FLY", timing=1.2, id=SKILLID_BREATH },
	{ name="FIRE_SMASH",target=SKILL_TARGET_POSITION, state="MONANI_ATTACK_01", timing=0.6, id=SKILLID_FIRE_SMASH},
	{ name="TAIL_SPLASH",target=SKILL_TARGET_POSITION, state="MONANI_ATTACK_03", timing=1.9, id=SKILLID_TAIL_SPLASH},	
	{ name="TAIL_SPLASH2",target=SKILL_TARGET_POSITION, state="MONANI_ATTACK_03", timing=1.9, id=SKILLID_TAIL_SPLASH2},	
	{ name="FIRE_BREATH",target=SKILL_TARGET_POSITION, state="MONANI_ATTACK_04", timing=0.35, id=SKILLID_FIRE_BREATH},
	{ name="DRAGON_SLIDING",target=SKILL_TARGET_POSITION, state="GLIDE", timing=0.1, id=SKILLID_DRAGON_SLIDING},
},

-- 이동속도M
velocity = 24,

--skipAdjustVelocity = 1,

approach_dist = 10,

}

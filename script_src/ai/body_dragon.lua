-- module setup
require ('BodyHelper')

-- 몬스터 모양 설정
g_body['dragon'] = 
{

-- dff file
file  = "npc_dragon",

-- 제일 앞에게 default state다. ani가 특별히 없으면 default가 된다.
states = { "D_FLY", "D_GLIDER", "D_ROARING", "D_HOVERING", "D_FIRE", "G_IDLE" },

-- skill
skill = 
{ 
	{ name="FIREBALL",	target=SKILL_TARGET_POSITION, state="D_FIRE", timing=1.2, id=SKILLID_FIREBALL },
	{ name="BREATH",	target=SKILL_TARGET_OBJECT, state="D_FIRE", timing=1.2, id=SKILLID_BREATH },
},

-- 이동속도M
velocity = 30,

approach_dist = 10,

}

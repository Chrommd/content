-- module setup
require ('BodyHelper')

-- 몬스터 모양 설정
g_body['tower'] = 
{

-- dff file
file  = "m_ent01",

-- logic link
logic = 
{ 
	"RcLogicEventKey",
},

-- 제일 앞에게 default state다. ani가 특별히 없으면 default가 된다.
states = { "G_IDLE", "ATTACK" },

-- skill
skill = 
{ 
	{ name="ARROW",	target=SKILL_TARGET_POSITION, state="ATTACK", timing=1.1, id=SKILLID_TOWER_ARROW },
},

-- 이동속도M
velocity = 10,

approach_dist = 10,

}

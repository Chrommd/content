-- module setup
require ('BodyHelper')

--module(..., package.seeall)

-- 몬스터 모양 설정
g_body['hyena'] = 
{

-- dff file
file  = "m_hyena",		

-- 추가 argument
args  = "-damageknockback",

-- logic link
logic = 
{ 
	"RcLogicMobBody",
},

-- 제일 앞에게 default state다. ani가 특별히 없으면 default가 된다.
states = { "IDLE", "MOVE_1ST", "ATTACK", "ATTACK_L", "ATTACK_R", "DAMAGE", "DAMAGE_MOVE", "DEAD", "DEAD_MOVE",  },

-- skill
skill = 
{ 
	{ name="ARROW",	target=SKILL_TARGET_POSITION, state="ATTACK", timing=0.5, id=SKILLID_MONSTER_ARROW },
},

-- 이동속도M
velocity = 40,

-- 접근거리
approach_dist = 4,

-- 리딩 거리
lead_dist = 40,

}
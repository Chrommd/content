-- module setup
require ('BodyHelper')

--module(..., package.seeall)

-- 몬스터 모양 설정
g_body['hyena_alpha'] = 
{

-- dff file
file  = "m_hyena",		

-- logic link
logic = 
{ 
	"RcLogicMobBody",
},

-- 제일 앞에게 default state다. ani가 특별히 없으면 default가 된다.
states = { "IDLE", "MOVE_1ST", "ATTACK", "DAMAGE", "DEAD" },

-- skill
skill = 
{ 
	{ name="ARROW",	target=SKILL_TARGET_POSITION, state="ATTACK", timing=0.5, id=SKILLID_ARROW_POSITION },
	{ name="SUMMON",target=SKILL_TARGET_POSITION, state="ATTACK", timing=0.5, id=SKILLID_SUMMON },
},

-- 이동속도M
velocity = 40,

-- 접근거리
approach_dist = 2.5,

}
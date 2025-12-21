-- module setup
require ('BodyHelper')

--module(..., package.seeall)

-- 몬스터 모양 설정
g_body['raptor'] = 
{

-- dff file
file  = "m_rapter",		

-- link
link = 
{
	{ id=1, class="RcSimpleAsset", file="npc_stato_horse", link="sit" },
},

-- 추가 argument
--args  = "-nodefault -keymapper",

-- logic link
logic = 
{ 
	--"RcLogicMobMove", 
	"RcLogicMobBody",
},

-- 제일 앞에게 default state다. ani가 특별히 없으면 default가 된다.
states = { "IDLE", "MOVE_1ST", "ATTACK", "DAMAGE", "DEAD" },

-- skill
skill = 
{ 
	{ name="ARROW",	target=SKILL_TARGET_POSITION, state="ATTACK", timing=0.5, id=SKILLID_MONSTER_ARROW },
},

-- 이동속도M
velocity = 25,

-- 접근거리
approach_dist = 2.5,

-- 리딩 거리
lead_dist = 40,

}
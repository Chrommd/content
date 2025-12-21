-- module setup
require ('BodyHelper')

-- 몬스터 모양 설정
g_body['wagon'] = 
{

-- dff file
file  = "npc_bull",

-- logic link
logic = 
{ 
	"RcLogicEventKey",
	"RcLogicMobBody",
},

-- 제일 앞에게 default state다. ani가 특별히 없으면 default가 된다.
states = { "G_IDLE", "MOVE_1ST" },

-- skill

-- 이동속도M
velocity = 10,

approach_dist = 10,

}

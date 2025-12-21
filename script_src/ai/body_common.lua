-- module setup
require ('BodyHelper')

--module(..., package.seeall)

-- 몬스터 모양 설정
g_body['common'] = 
{

-- dff file
file  = "NPC_ELEPHANT",

-- 제일 앞에게 default state다. ani가 특별히 없으면 default가 된다.
states = 
{
	"G_IDLE",
},

-- 이동속도M
velocity = 3,

approach_dist = 2.5,

}

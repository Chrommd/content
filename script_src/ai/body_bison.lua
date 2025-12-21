-- module setup
require ('BodyHelper')

--module(..., package.seeall)

-- 몬스터 모양 설정
g_body['bison'] = 
{

-- dff file
file  = "npc_bison",		

-- 추가 argument
args  = "-nohp -simpleShadow 5 -bboxscale 100",

-- logic link
logic = 
{ 
	--"RcLogicMobMove", 
	"RcLogicMobBody",
},

-- 제일 앞에게 default state다. ani가 특별히 없으면 default가 된다.
states = { "IDLE", "MOVE_1ST" },

state_move = "MOVE_1ST",

-- skill
skill = 
{ 
},

-- 이동속도M
velocity = 37,

-- 접근거리
approach_dist = 1.5,

-- 리딩 거리
lead_dist = 5,

}
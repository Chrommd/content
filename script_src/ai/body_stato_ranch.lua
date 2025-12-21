-- module setup
require ('BodyHelper')

--module(..., package.seeall)

-- 몬스터 모양 설정
g_body['stato_ranch'] = 
{

-- dff file
--file  = "n_f[land][]stato00",
bodyset = "stato_ranch",

-- 추가 argument
args  = "-nohp -bboxscale 100 -shadow 156", -- -shadow 199",


-- logic link
logic = 
{ 
	"RcLogicMobBody",
	"RcLogicNpcMark",
},

-- 제일 앞에게 default state다. ani가 특별히 없으면 default가 된다.
states = { "G_IDLE", "GREETING" },

-- 이동속도M
velocity = 10,

-- turn speed
turn_speed = 10,

approach_dist = 2.5,

-- 리딩 거리
lead_dist = 5,

-- npc정보
npc_id		= 2,		-- NpcID
npc_height	= 2.0,		-- 머리 위 정보창 뜨는 높이


}

-- module setup
require ('BodyHelper')

--module(..., package.seeall)

-- 몬스터 모양 설정
g_body['pig'] = 
{

-- dff file
file  = "NPC_PIG01",

-- 추가 argument
args  = "-nohp -damageknockback -simpleShadow 1.5 -bboxscale 100", -- -shadow 199",


-- logic link
logic = 
{ 
	"RcLogicMobBody",
},


-- 제일 앞에게 default state다. ani가 특별히 없으면 default가 된다.
states = { "IDLE", "MOVE_1ST", "MOVE_2ND", "MOVE_3RD", "JUMP" },

state_move = "MOVE_1ST",

-- skill
skill = 
{ 
},

-- 이동속도M
velocity = 6,

approach_dist = 2.5,

-- 리딩 거리
lead_dist = 5,

-- 속도변화 안함
--skipAdjustVelocity = 1,

}

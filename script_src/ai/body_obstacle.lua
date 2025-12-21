-- module setup
require ('BodyHelper')

--module(..., package.seeall)

-- 몬스터 모양 설정
g_body['obstacle'] = 
{

-- dff file
file  = "npc_pig01",

-- 추가 argument
args  = "-nohp -damageknockback -simpleShadow 2 -bboxscale 100", -- -shadow 199",


-- logic link
logic = 
{ 
	"RcLogicMobBody",
},


-- 제일 앞에게 default state다. ani가 특별히 없으면 default가 된다.
states = { "IDLE", "JUMP" },

state_move = "JUMP",

-- skill
skill = 
{ 
},

-- 이동속도M
velocity = 1,

approach_dist = 2.5,

-- 리딩 거리
lead_dist = 5,

-- 속도변화 안함
--skipAdjustVelocity = 1,

}

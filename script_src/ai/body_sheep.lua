-- module setup
require ('BodyHelper')

--module(..., package.seeall)

-- 몬스터 모양 설정
g_body['sheep'] = 
{

-- dff file
file  = "n_f[land][st]sheep02",

-- 추가 argument
args  = "-nohp -damageknockback -simpleShadow 2.4 -bboxscale 100 -funknockback -coltype[sheep]", -- -shadow 199",


-- logic link
logic = 
{ 
	"RcLogicMobBody",
	{ "RcLogicMobDropMoney", "-ranchOnly" },		-- 부딪힐때 동전 떨어뜨리는 것 : args의 "-funknockback"이랑 같이 있어야 적용됨
},


-- 제일 앞에게 default state다. ani가 특별히 없으면 default가 된다.
states = { "IDLE", "MOVE_ZERO", "MOVE_1ST", "MOVE_2ND", "MOVE_3RD", "MOVE_4TH", "JUMP", "G_COLLISION", "G_COLLISION_END" },

state_move = "MOVE_1ST",

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

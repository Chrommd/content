-- module setup
require ('BodyHelper')

--module(..., package.seeall)

-- 몬스터 모양 설정
g_body['cat'] = 
{

-- dff file
file  = "n_f[land][st]cat",

-- 추가 argument
args  = "-nohp -damageknockback -simpleShadow 0.6 -simpleShadowY 1.2 -bboxscale 500", -- -shadow 199",


-- logic link
logic = 
{ 
	{ "RcLogicMobBody", "-radius 0.2 -weight 4 -noCol" },
},


-- 제일 앞에게 default state다. ani가 특별히 없으면 default가 된다.
states = { "IDLE", "MOVE_1ST", "MOVE_2ND", "MOVE_3RD", "JUMP", "MONANI_01", "G_COLLISION", "G_COLLISION_END", },

state_move = "MOVE_1ST",

-- skill
skill = 
{ 
},

-- 이동속도M
velocity = 3,

approach_dist = 2.5,

-- 리딩 거리
lead_dist = 5,

-- 몸체 크기: 길찾기 충돌체크용
body_size = 0.5,

-- 속도변화 안함
--skipAdjustVelocity = 1,

}

-- module setup
require ('BodyHelper')

--module(..., package.seeall)

-- 몬스터 모양 설정
g_body['eagle'] = 
{

-- dff file
file  = "n_g[][f]eagle00",		

-- 추가 argument
args  = "-roamingFlying -simpleShadow 0.4",

-- logic link
logic = 
{ 
	--{ "RcLogicMobBody",	"-noCol" },
	--"RcLogicMobFlyingDown",
},

-- 제일 앞에게 default state다. ani가 특별히 없으면 default가 된다.
states = { "IDLE", "MOVE_1ST", "FLY" },

state_move = "MOVE_1ST",

-- 이동속도M
velocity = 50,

-- 접근거리
approach_dist = 2.5,

-- 리딩 거리
lead_dist = 10,

}
-- module setup
require ('BodyHelper')

--module(..., package.seeall)

-- 몬스터 모양 설정
g_body['ranch_horse'] = 
{

-- dff file
file  = "h000",

-- 추가 argument
args  = "-aim[h000_ranch] -nodefault -nohp -damageknockback -simpleShadow 1.6 -simpleShadowY 3.3", -- -shadow 199", -mountTID 20036 -multiParts -skin[h000_skin017_dif.dds] 


-- logic link
logic = 
{ 
	{ "RcLogicMobBody",	"-noCol -upvector 0.3 0.7" },
	"RcLogicMountName",
	"RcLogicCareAmends",
	{ "RcLogicMobRanchHorseMove", "-move0 10 -move1 15 -move2 40" },
	"RcLogicMobRanchHorseEffect",
	"RcLogicModelScale",	-- 마지막에 붙여야 된답니다.
},


-- 제일 앞에게 default state다. ani가 특별히 없으면 default가 된다.
states = 
{ 
	"GRAZE_IDLE", "MOVE_ZERO", "MOVE_1ST", "MOVE_2ND", "MOVE_3RD", "JUMP", "ROTATE_L", "ROTATE_R",
	"WAY_LOST", "SYMPATHIZE", "LOOK_HEAD", "EAT_FOOD", "EAT_FOOD_END", "COURBETTE",
	"DISPLEASED", "MOVE_INJURY"
},

state_move = "MOVE_ZERO",

-- skill
skill = 
{ 
},

-- 이동속도M
velocity = 1,

approach_dist = 2.5,

-- 리딩 거리
lead_dist = 5,

-- 몸체 크기: 길찾기 충돌체크용
body_size = 2,

-- 이동중 각도 틀어질때 추가 딜레이를 주는가(서버용)
apply_turn_delay = true,
move_turn_speed = 2,		-- 딜레이 줄 때 기본 회전 속도

-- 속도변화 안함
--skipAdjustVelocity = 1,

}

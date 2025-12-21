-- module setup
require ('BodyHelper')

--module(..., package.seeall)

-- 몬스터 모양 설정
g_body['ranch_foal'] = 
{

-- dff file
file  = "h001",

-- 추가 argument
args  = "-prefix[h001] -nodefault -nohp -damageknockback -simpleShadow 1.0 -simpleShadowY 1.6", -- -shadow 199", -mountTID 20036 -multiParts -skin[h000_skin017_dif.dds] 


-- logic link
logic = 
{ 
	{ "RcLogicMobBody",	"-noCol -upvector 0.3 0.7" },
	"RcLogicMountName",
	{ "RcLogicMobRanchHorseMove", "-move0 5 -move1 7 -move2 20" },
	"RcLogicMobRanchHorseEffect",
	"RcLogicModelScale",	-- 마지막에 붙여야 된답니다.
},


-- 제일 앞에게 default state다. ani가 특별히 없으면 default가 된다.
states = 
{ 
	"GRAZE_IDLE", "MOVE_ZERO", "MOVE_1ST", "MOVE_2ND", "MOVE_3RD", "JUMP", "CARE_FEED_LV0", "CARE_CLEAN_COMPLETE", "COURBETTE", --"ROTATE_L", "ROTATE_R",
	"ITEM_NORMAL_DMG", "COMMUNION_UP", "GOAL_MOTION1", "ITEM_THUNDER_DMG", "LOOK_HEAD"
},

state_move = "MOVE_ZERO",

-- skill
skill = 
{ 
},

-- 이동속도M
velocity = 4,

approach_dist = 2.5,

-- 리딩 거리
lead_dist = 5,

-- 몸체 크기: 길찾기 충돌체크용
body_size = 3,

-- 이동중 각도 틀어질때 추가 딜레이를 주는가(서버용)
apply_turn_delay = true,
move_turn_speed = 2,		-- 딜레이 줄 때 기본 회전 속도

-- 속도변화 안함
--skipAdjustVelocity = 1,

}

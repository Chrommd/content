-- module setup
require ('BodyHelper')

--module(..., package.seeall)

-- 몬스터 모양 설정
g_body['balloon'] = 
{

-- dff file
file  = "a_item_balloon01",

-- 추가 argument
args  = "-nohp -bboxscale 100 -flying -shadow 155", -- -shadow 199",


-- logic link
logic = 
{ 
	"RcLogicRegisterObstacle",
	"RcLogicMobCollision",
},

-- 제일 앞에게 default state다. ani가 특별히 없으면 default가 된다.
states = { "G_IDLE", "BROKEN" },

collision_gap_x = 0.7,
collision_predict_dist = 0.11,

}

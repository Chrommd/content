-- module setup
require ('BodyHelper')

--module(..., package.seeall)

-- 몬스터 모양 설정
g_body['target'] = 
{

-- dff file
file  = "npc_goblin",

-- 추가 argument
args  = "-usedefaultheight -notarget -bboxscale 30",  -- -collattack

-- 제일 앞에게 default state다. ani가 특별히 없으면 default가 된다.
states = { "G_IDLE", "BROKEN" },

-- skill
skill = 
{ 
	{ name="ARROW",	target=SKILL_TARGET_OBJECT, state="ATTACK", timing=0, id=SKILLID_FIREBOLT},
},

-- 이동속도M
velocity = 30,

approach_dist = 5,

-- 리딩 거리
lead_dist = 5,

-- 속도변화 안함
--skipAdjustVelocity = 1,

}

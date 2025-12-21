-- module setup
require ('BodyHelper')

--module(..., package.seeall)

-- 몬스터 모양 설정
g_body['stato_basilisk'] = 
{

-- dff file
file  = "NPC_STATO_HORSE",

-- 추가 argument
args  = "-nohp -notarget -bboxscale 100",

-- 제일 앞에게 default state다. ani가 특별히 없으면 default가 된다.
states = { "G_IDLE", "MOVE_1ST", "ATTACK" },

-- skill
skill = 
{ 
	{ name="ARROW",	target=SKILL_TARGET_POSITION, state="ATTACK", timing=0.5, id=SKILLID_MONSTER_ARROW },
},

-- 이동속도M
velocity = 35,

approach_dist = 2.5,

-- 리딩 거리
lead_dist = 5,

}

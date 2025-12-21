-- module setup
require ('BodyHelper')

--module(..., package.seeall)

-- 몬스터 모양 설정
g_body['teambase_blue'] = 
{

-- dff file
file  = "ri_finish_column04",

-- 추가 argument
args  = "-usedefaultheight -collattack -nohp -notarget -bboxscale 100",

-- 제일 앞에게 default state다. ani가 특별히 없으면 default가 된다.
states = { "G_IDLE", "DEAD" },

-- skill
skill = 
{ 
	{ name="SOULLINK",	target=SKILL_TARGET_OBJECT, state="G_IDLE", timing=0, id=SKILLID_SOULLINK },		
},

}

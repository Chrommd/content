require('RanchHelper')

-- 일반적인 목장 접속자 스크립트

ENABLE_DEBUG = 1

if IS_SERVER then
	-- 서버는 필요없다.
else

-- test
OPENING_RANCH =
{	
	--[ SCENE1 ]----------------------------------------------------------
	-- NPC생성
	--
	SCENE_INIT = DEFAULT_SCENE.CreateRanchNPC("SCENE_INIT2"),		-- ranchhelper.lua

	--[ SCENE1 ]----------------------------------------------------------
	--
	SCENE_INIT2 = 
	{ 		
		-- action : 조건에 따라서 하나씩 순차적으로 실행
		action =
		{
			-- condition, action			
			{},						{ ChatEnable, true },
			{},						{ NextScene, "SCENE_NORMAL" },				
		},		
	},
}

RegisterExerciseScene(OPENING_RANCH, "SCENE_NORMAL")

OPENING = OPENING_RANCH
startScene = "SCENE_INIT"

end	--IS_SERVER

require('RanchHelper')

-- 처음 접속자를 위한 INTRO scene

ENABLE_DEBUG = 1

function OnFirstSceneEnd()
	util:IncidentSelf(INCIDENT_PLAYERFOCUS)
end

if IS_SERVER then
	-- 서버는 필요없다.
else

function StartOldmanChat()
	util:StartChat(1)
end

function SetChatEvent()
	util:SetChatEvent(2, 0, 0)
end


-- test
OPENING_START =
{	
	--[ SCENE1 ]----------------------------------------------------------
	-- 카메라 1번
	--
	SCENE1 = DEFAULT_SCENE.CreateRanchNPC("SCENE2"),			-- ranchhelper.lua

	--[ SCENE1 ]----------------------------------------------------------
	-- 카메라 1번
	--
	SCENE2 = 
	{ 		
		-- action : 조건에 따라서 하나씩 순차적으로 실행
		action =
		{
			-- condition, action			
			--{ GameTime, 0 },		{ ResetPos, "$Player", riderStartPos, riderStartDir },						-- 플레이어 reset
			{},						{ InputBlock, true },														-- 플레이어 입력 막음
			{},						{ CameraMacro, "$Player", "ranch_opening_new" },										-- 카메라
			
		},
		
		-- event : 특정한 event가 발생하면 지정된 것 실행
		event = 
		{ 
			-- event, action
			{ Event, EVENT_CAMERA_STOP }, { {OnFirstSceneEnd}, {NextScene, "SCENE_MANUAL1"} },				-- (매크로)카메라가 멈췄으면 플레이어에게 카메라 전환
			
		},
	},	

	--[ SCENE_MANUAL1 ]----------------------------------------------------------
	-- 매뉴얼1
	--
	SCENE_MANUAL1 = 
	{ 		
		-- action : 조건에 따라서 하나씩 순차적으로 실행
		action =
		{
			{},										{ ShowManual, true, 1, "btn_next" },	-- 매뉴얼 출력			
		},
		
		-- event : 특정한 event가 발생하면 지정된 것 실행
		event = 
		{ 
			{ Event, EVENT_UI_CLOSE, "ManualForm", 1 }, { NextScene, "SCENE_MANUAL2" },	-- 다음 매뉴얼
			
		},
	},
	
	--[ SCENE_MANUAL1 ]----------------------------------------------------------
	-- 매뉴얼2
	--
	SCENE_MANUAL2 = 
	{ 		
		-- action : 조건에 따라서 하나씩 순차적으로 실행
		action =
		{
			{},										{ ShowManual, true, 2, "btn_next" },	-- 매뉴얼 출력			
		},
		
		-- event : 특정한 event가 발생하면 지정된 것 실행
		event = 
		{ 
			{ Event, EVENT_UI_CLOSE, "ManualForm", 2 }, { NextScene, "SCENE_MANUAL3" },	-- 다음 매뉴얼
			
		},
	},
	
	--[ SCENE_MANUAL1 ]----------------------------------------------------------
	-- 매뉴얼3
	--
	SCENE_MANUAL3 = 
	{ 		
		-- action : 조건에 따라서 하나씩 순차적으로 실행
		action =
		{
			{},										{ ShowManual, true, 3, "btn_exit" },	-- 매뉴얼 출력			
		},
		
		-- event : 특정한 event가 발생하면 지정된 것 실행
		event = 
		{ 
			{ Event, EVENT_UI_CLOSE, "ManualForm", 3 }, { NextScene, "SCENE_CHAT_INIT" },	-- 다음 씬
			
		},
	},

	--[ SCENE_CHAT_INIT ]----------------------------------------------------------
	-- 채팅 가능 씬 준비
	--
	SCENE_CHAT_INIT =
	{
		action =
		{
			{ ElapseTime,0 },						{ CameraPlayer },				-- 플레이어 따라다니기
			--{},										{ RFClose, "IntroTitle" },		-- 닫기
			{},										{ InputBlock, false },			-- 플레이어 입력 막음 해제						
			{},										{ NextScene, "SCENE_CHAT_WAIT" },	-- 입력 기다리는 씬으로
		},
	},
	
	--[ SCENE_CHAT_WAIT ]----------------------------------------------------------
	-- 채팅 기다림
	--
	SCENE_CHAT_WAIT =
	{
		action =
		{
			{},										{ ChatEnable, true },
			{},										{ StartOldmanChat },				-- 할아버지 채팅 강제 시작
		},
		
		-- event : 특정한 event가 발생하면 지정된 것 실행
		event = 
		{ 
			-- event, action
			{ Event, EVENT_NPC_CHAT, "chat_start", 1 }, { InputBlock, true },					-- 할아버지NPC 채팅 시작시 입력 막음
			{ Event, EVENT_NPC_CHAT, "chat_close", 1 }, { InputBlock, false },					-- 할아버지NPC 채팅 끝날때 입력 해제
			{ Event, EVENT_NPC_CHAT, "intro_end" },		{ NextScene, "SCENE_INTRO_FINAL" },		-- 인트로는 이제 끝
			
			{ Event, EVENT_NPC_CHAT, "ranch_exercise" }, { NextScene, "SCENE_CHAT_EXERCISE_PREPARE" },	-- 주행연습
		},
	},
	
	--[ SCENE_NORMAL ]----------------------------------------------------------
	-- normal
	--
	SCENE_CHAT_EXERCISE_PREPARE = DEFAULT_SCENE.CreateSceneExercisePrepare("SCENE_CHAT_EXERCISE_INIT", "SCENE_CHAT_WAIT"),
	SCENE_CHAT_EXERCISE_INIT = DEFAULT_SCENE.CreateSceneExerciseInit("SCENE_CHAT_EXERCISE_WAIT"),
	SCENE_CHAT_EXERCISE_WAIT = DEFAULT_SCENE.CreateSceneExerciseWait("SCENE_CHAT_EXERCISE_END"),
	SCENE_CHAT_EXERCISE_END = DEFAULT_SCENE.CreateSceneExerciseEnd("SCENE_CHAT_WAIT"),	
	
	--[ SCENE_INTRO_CLOSE ]----------------------------------------------------------
	-- 인트로 정리
	--
	SCENE_INTRO_FINAL = 
	{
		action = 
		{
		
			{},										{ InputBlock, true },				-- 플레이어 입력 막음 해제
			{},										{ SetChatEvent},	 --채팅연결
		},
		event =
		{
			{ Event, EVENT_NPC_CHAT, "intro_close" },		{ NextScene, "SCENE_INTRO_CLOSE" },		-- 인트로는 이제 끝
		},
		
	},

	SCENE_INTRO_CLOSE =
	{
		action = 
		{
			{},										{ InputBlock, false },				-- 플레이어 입력 막음 해제
			{},										{ FinishIntro },					-- Intro끝
			{},										{ SendAchvComplete, "IntroEnd" },	-- intro도전과제 완료
			{},										{ ShowManual, true, 4, "btn_exit" },		-- 끝날때 나오는 매뉴얼 하나
			{},										{ NextScene, "SCENE_NORMAL"},	-- 끝날때 나오는 매뉴얼 하나
		},
	},	
}

RegisterExerciseScene(OPENING_START, "SCENE_NORMAL")

OPENING = OPENING_START
startScene = "SCENE1"

end	--IS_SERVER

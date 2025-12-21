require('SceneHelper')
require('SceneDefault')

riderStartPosName	= 'start_point'
statoStartPosName	= 'stato_start_point'

ENABLE_DEBUG = 1

statoCount	= 1			-- 생성할 스타토 숫자
statoOID	= 29500		-- client OBJ_ID
dragonOID	= 29600		-- client OBJ_ID

-- test node list
move_node1 =
{
	v3(-0.6, -28, -47),
	v3(8.3, -28, -54),
	v3(17.9, -28, -52),
	v3(19, -28, -41),
	v3(9.4, -29, -33),
}

riderStartPos = v3(26, -19, 51)
riderStartDir = v3(0.5, 0, 0.08 )

dragonStartPos = v3(26, -26+5, 51)



amurtareStartPos = v3(-28, -28, -7970) --범근 테스트용 드래곤 시작 좌표
attackPos = v3(-13, -28, -7989) --범근 테스트용 드래곤 시작 좌표

riderMoveNode =
{
	v3(26, -19, 51),
	v3(72, -25, 17),
	v3(88, -21, -4),
	v3(62, -12, -52),
	v3(17, -11, -71),
	v3(1, -10, -81),
	v3(-43, -9, -63),
	v3(-14, -26, 45),
	v3(-14, -26, 45),
	v3(19, -26, 55),
}

dragonMoveNode =
{
	v3(26, -26+5, 51),
	v3(72, -25+5, 17),
	v3(88, -21+5, -4),
	v3(62, -12+5, -52),
	v3(17, -11+5, -71),
	v3(1, -10+5, -81),
	v3(-43, -9+5, -63),
	v3(-42, -26+5, -17),
}


UIConfig =
{
	IntroFrame = 
	{
		{ ALIGN_CENTER, 0, 0 },
		
		NoticeImage = { UI_OVERLAY, "boss_warning", ALIGN_CENTER, 0, 0 },
		NoticeFont	= { UI_FONT, "font28[22_29]_s", -50, 60 },
	}
}

-- 플레이어

OPENING_DRAGON =
{
	--[ SCENE1 ]----------------------------------------------------------
	-- 스타토가 길 한바퀴 돈다 
	-- 카메라는 계속 스타토 비춘다.
	--
	SCENE1 = 
	{ 		
		-- action : 조건에 따라서 하나씩 순차적으로 실행sdfsdf
		action =
		{
			-- condition, action			
			{ GameTime, 0 },		{ ResetPos, "$Player", riderStartPos, riderStartDir },							-- 플레이어 reset
			{},						{ CreateUI, UIConfig },															-- UI create
			{},						{ SetForceDisplay, "$Player", true },
			{},						{ InputBlock, false },															-- 플레이어 입력 막음
			{},						{ CreateNPC, "dragon", "dragon_intro", "dragon_intro", 'start_point', dragonOID },	-- dragon 플레이어 근처에 셋팅
			
			{},						{ RFCreateWnd, "IntroTitle", "intro_desktop.xml", 0, 0, false },				-- [ IntroTitle ] - frame없는 refresh form생성
			{},						{ RFAnimation, "IntroTitle", "intro" },											-- "intro" animation 플레이
			{},						{ StartTimer, "IntroTitle_CLOSE", 3 },											-- 3초후에 닫기 이벤트 발생해서 닫도록 함
			
			--{},						{ RFCreateForm, "TestForm", "visitor_window.xml", 500, 400, false },			-- [ TestForm ] - frame있는(!) refresh form생성
			--{},						{ RFButtonClicked, "TestForm", "btn_close_box", RFEVENT_SCRIPT },				-- btn_close_box버튼을 누를때 이벤트 발생
			
			--{},						{ RFButtonClicked, "IntroTitle", "btn_close_box", RFEVENT_CLOSE },
			
			--{ ElapseTime,1 },		{ Patrol, "$Player", riderMoveNode },											-- player move			
			
			--{ ElapseTime,2 },		{ Patrol, "dragon", dragonMoveNode },											-- stato를 지정된 node를 따라서 이동
			--{},						{ CameraMacro, "dragon", "start_rolling" },									-- 매크로카메라 dragon에 맞춰 실행
			
			
			{ ElapseTime,2 },		{ PlayMotion, "dragon", MOTION_ATTACK1 },				-- 특정 모션 플레이
			{},						{ UseSkillPos, "dragon", "FIRE_SMASH", "$PlayerPos" },	-- 특정 Skill
			
			{ ElapseTime,3 },		{ PlayMotion, "dragon", MOTION_ATTACK1 },				-- 특정 모션 플레이
			{},						{ UseSkillPos, "dragon", "FIRE_SMASH", "$PlayerPos" },	-- 특정 Skill			
			--{},						{ HorseAction, "$Player", ACTIONSTATE_SPUR },			-- 플레이어 말 액션
			
		},
		
		-- process : 순서없이 모두 체크해서 조건에 맞으면 항상 실행
		process =
		{
		},
		
		-- event : 특정한 event가 발생하면 지정된 것 실행
		event = 
		{ 
			-- event, action
			{ Event, EVENT_CAMERA_STOP },					{ CameraPlayer },				-- (매크로)카메라가 멈췄으면 플레이어에게 카메라 전환
			{ Event, EVENT_PATROL_NEXT, "", "$Player", 5 }, { {HorseAction, "$Player", ACTIONSTATE_JUMP2ND}, {StartSlowMode, 0.4}, {StartTimer, "END_SLOW_MODE", 3}, { UIShowFrame, "IntroFrame" }, },
			{ Event, EVENT_TIMER, "END_SLOW_MODE" },		{ EndSlowMode },
			{ Event, EVENT_PATROL_NEXT, "", "$Player", 8 }, { {HorseAction, "$Player", ACTIONSTATE_GLIDING}, { UIHideFrame, "IntroFrame" }, },
			{ Event, EVENT_PATROL_END, "", "$Player" },		{ NextScene, "SCENE2" },		-- 길따라가던게 끝났으면 다음 Scene으로 전환
			
			
			{ Event, EVENT_TIMER, "IntroTitle_CLOSE" },		{ RFClose, "IntroTitle" },		-- 닫기
			{ Event, EVENT_UI, "TestForm" },				{ RFClose, "TestForm" },		-- 닫기
			
		},
	},
	
	SCENE2 =
	{
		action =
		{
			{ ElapseTime,0 },		{ CameraMacro, "$Player", "start_standing" },
			{},						{ InputBlock, false },									-- 플레이어 입력 막음 해제
			{},						{ SetForceDisplay, "$Player", false },
		},
		
		event = 
		{ 
			{ Event, EVENT_CAMERA_STOP },					{ CameraPlayer },				-- (매크로)카메라가 멈췄으면 플레이어에게 카메라 전환						
		}
	},
}

-- test
OPENING_STATO =
{	
	--[ SCENE1 ]----------------------------------------------------------
	-- 스타토가 길 한바퀴 돈다 
	-- 카메라는 계속 스타토 비춘다.
	--
	SCENE1 = 
	{ 		
		-- action : 조건에 따라서 하나씩 순차적으로 실행
		action =
		{
			-- condition, action			
			{ GameTime, 0 },		{ ResetPos, "$Player", riderStartPos, riderStartDir },							-- 플레이어 reset
			{},						{ CreateNPC, "stato", "stato_intro", "stato_intro", "$PlayerPos", statoOID },	-- 스타토를 플레이어 근처에 셋팅			
			
			{ ElapseTime,1 },		{ Patrol, "stato", move_node1 },												-- stato를 지정된 node를 따라서 이동
			{ ElapseTime,0.5 },		{ CameraMacro, "stato", "start_standing" },										-- 매크로카메라 stato에 맞춰 실행
			
			{ ElapseTime,1.5 },		{ PlayMotion, "stato", MOTION_ATTACK },		-- 특정 모션 플레이
			{ ElapseTime,1.5 },		{ PlayMotion, "stato", MOTION_ATTACK },		-- 특정 모션 플레이
			{ ElapseTime,1.5 },		{ PlayMotion, "stato", MOTION_ATTACK },		-- 특정 모션 플레이
		},
		
		-- process : 순서없이 모두 체크해서 조건에 맞으면 항상 실행
		process =
		{
			--{ IsPatrolEnd, "stato" },	{ NextScene, "SCENE2" },		-- 길따라가던게 끝났으면 다음 Scene으로 전환
		},
		
		-- event : 특정한 event가 발생하면 지정된 것 실행
		event = 
		{ 
			-- event, action
			{ Event, EVENT_CAMERA_STOP }, { CameraPlayer },				-- (매크로)카메라가 멈췄으면 플레이어에게 카메라 전환
			
		},
	},

	--[ SCENE2 ]----------------------------------------------------------
	-- 스타토가 플레이어 근처를 돌아다닌다
	--
	SCENE2 =
	{
		action =
		{
			{},						{ Follow, "stato", "$Player" },				-- 플레이어 따라다니기
		},
	},
}



OPENING_INTRO =
{
	--[ SCENE1 ]----------------------------------------------------------
	-- 
	-- 
	--
	SCENE1 = 
	{ 		
		-- action : 조건에 따라서 하나씩 순차적으로 실행
		action =
		{
			-- condition, action			
			{ GameTime, 0 },		{ CreateNPC, "dragon", "dragon_intro", "dragon_intro", "dragon_start_point", dragonOID },	-- dragon 플레이어 근처에 셋팅
			--{},						{ CreateNPC, "stato", "stato_intro", "stato_intro", "start_point", statoOID },
			
			{ ElapseTime,1 },		{  PlayMotion, "dragon", MOTION_ATTACK1 },											-- stato를 지정된 node를 따라서 이동
			{},							{ UseSkillPos, "dragon", "FIRE_SMASH", "dragon_start_point" },
			{},							{ StartTimer, "DragonAttack_END", 3 },
		},
		
		-- process : 순서없이 모두 체크해서 조건에 맞으면 항상 실행
		process =
		{

		},
		
		-- event : 특정한 event가 발생하면 지정된 것 실행
		event = 
		{ 
			-- event, action
			{ Event, EVENT_AREA_ENTER, "tuto1" },			{ Patrol,  "dragon", "move_path" },
			{ Event, EVENT_AREA_LEAVE, "portal1" },			{{  PlayMotion, "dragon", MOTION_ATTACK1 }, { UseSkillPos, "dragon", "FIRE_SMASH", "$PlayerPos" },	},
			{ Event, EVENT_AREA_ENTER, "portal2" },			{ print, "enter portal2\n" },
			{ Event, EVENT_AREA_LEAVE, "portal2" },			{ print, "leave portal2\n" },
			{ Event, EVENT_PATROL_END, "", "dragon" },		{ {print, "patrol end\n"}, {Patrol, "dragon", "move_path"} },
			{ Event, EVENT_TIMER, "DragonAttack_END" },		{{  PlayMotion, "dragon", MOTION_ATTACK1 }, { UseSkillPos, "dragon", "FIRE_SMASH", attackPos },{ StartTimer, "DragonAttack_END", 3 }, },
		},
	},
	
}


OPENING = OPENING_DRAGON

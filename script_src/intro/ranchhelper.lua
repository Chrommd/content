require('SceneHelper')
require('SceneDefault')

-----------------------------------------------------------------
-- 목장용 설정
--
npcPos		= "n_f[land][]tomas"	--v3(15.43, 0.07, -5.63)
npcOID		= 29801		-- client OBJ_ID
			
statoPos	= "n_f[land][]stato00"	--v3(45.77, -0.46, 18.53)
statoOID	= 29802

pigPos		= "n_f[land][]april"	--v3(45.77, -0.46, 18.53)
pigOID		= 29803

junaPos		= "n_f[land][]juna"	--v3(45.77, -0.46, 18.53)
junaOID		= 29804

xmasTreePos		= "ran_w_xmas_tree01"
xmasTreePosOID	= 29805

balloonOID	= 29810
animalOID	= 29900
setRunawayType = false

MAX_BALLOON = 10
BALLOON_HIT_NICE_COUNT = 7
BALLOON_HEIGHT = 0
BALLOON_SCALE = 1
BALLOON3_RATIO = 15			-- 3개짜리 풍선 나올 확률
BALLOON_LIMIT_TIME = 5*60	-- 풍선 제한 시간(초)

BALLOON_WARNING_TIME	= BALLOON_LIMIT_TIME - 10	-- 종료 10초전에
BALLOON_WARNING_DELAY	= 1							-- 1초마다 알려준다.


-- 그룹 액션
GroupForceName =
{
	[MountGroupForce_Normal] = '기세 없음',
    [MountGroupForce_Greed1] = '풀 다 먹을 기세',
    [MountGroupForce_Greed2] = '쇠도 씹어먹을 기세',
    [MountGroupForce_Play1] = '맹렬하게 놀 기세',
    [MountGroupForce_Play2] = '밤새워 놀 기세',
    [MountGroupForce_Haste] = '1위할 기세',
    [MountGroupForce_Solo] = '혼자서도 잘 할 기세',
    [MountGroupForce_Rest] = '잠입액션 찍을 기세',
}


-----------------------------------------------------------------

RANCHSTUFF_BALLOON = 1

g_AngrySheepCoinDropCount = RAND(8, 12)		-- 몇번 양치면 분노하는가?

function IS_SHEEP_HIT_MONEY_DROP()
	return g_SheepCoinDropCount < g_AngrySheepCoinDropCount
end

function ResetSheepCoinDropCount()
	g_SheepCoinDropCount = 0
	g_AngrySheepCoinDropCount = RAND(8, 12)
end

function GetSheepAngryDelay()
	return RAND(50, 60)
end

function ChatEnable(enable)
	g_ChatEnable = enable
end

function ResetPlayer(posName)
	local playerMat = util:GetRanchNodePos(posName)				
	util:SetMyPos( playerMat.pos, playerMat.at, true )
end

function Setup()
	ResetPlayer("balloon_start_point")				
	util:BlockRanchSync(false)	-- 다른 용무중 표시, 동기화 막음
end

function Cleanup()

	ResetPlayer("balloon_end")
	util:BlockRanchSync(false)

	-- stato가 player 바라보기
	local mat = util:GetRanchNodePos("balloon_end")
	local stato = GetMobByName("stato")
	if stato ~= nil then
		stato:LookAt(mat.pos)
	end
	
	PlayBGMEvent("RANCH_ENTER")

	mgr:SendEventToClient(EVENT_ACTIVE_CONTENT, CONTENT_EXERCISE, 0)			
	
	ChatEnable(true)
end

function BalloonInit()
	g_BalloonCount = 0
	g_BalloonMoney = 0
	g_BalloonList  = {}
	g_BalloonTime  = 0	
	g_BalloonResultTime = -1
	g_balloonStartTime = 0
	
	PlayBGMEvent("EXERCISE_BALLOON")
	
	RFClose("BalloonResult")
end

function OnBalloonStartSceneEnd()
	util:IncidentSelf(INCIDENT_PLAYERFOCUS)
end

function BalloonStart()	
	util:IncidentSelf(INCIDENT_BALLOON_START)
	util:SendBalloonStart()
	g_balloonStartTime = GetGameTime()
end

function CreateBalloons()
	
	util:CreateDirectionArrow()

	local balloonPos = util:GetRanchNodeList("balloon")
	MAX_BALLOON = table.getn(balloonPos)
	BALLOON_HIT_NICE_COUNT = math.floor(MAX_BALLOON*0.7)

	if MAX_BALLOON > 0 then
		local prevPos = balloonPos[MAX_BALLOON]

		for i=1,MAX_BALLOON do				
			local pos = balloonPos[i]
			pos.y = pos.y + BALLOON_HEIGHT
			local balloonName = (RAND(1,100)<=BALLOON3_RATIO and "balloon3" or "balloon")
			local oid = balloonOID+i
			local npc = mgr:CreateMob( balloonName, "balloon", pos, MONSTER_TYPE_FRIENDLY, oid )

			util:AddDirectionArrow(oid)

			local at = GetDir(pos, prevPos)

			local lookPos = GetFrontPos(pos, at, 10)		
			npc:LookAt(lookPos)					
			npc:Scale(BALLOON_SCALE, BALLOON_SCALE, BALLOON_SCALE)

			prevPos = pos
		end	
	end
end

function IsTimeOver(delay)
	if g_balloonStartTime~=0 and GetGameTime() >= g_balloonStartTime+delay then
		return true
	end
	
	return false
end

function BalloonHit(balloonOID, playerOID)
	
	__DEBUG('Hit!!\n')
	
	if playerOID==util:GetMyOID() then
	
		local balloon = mgr:GetMob(balloonOID)
		if balloon ~= nil and (balloon:GetMobName()=="balloon3" or balloon:GetMobName()=="balloon") then
			local info = GET_MOB_INFO(balloon)
			if info ~= nil then
				balloon:SetHP(0)
				NEXT_STATE( info, STATE_DEAD )					
				
				util:RemoveDirectionArrow(balloonOID)
						
				-- 먹었다고 서버로 보낸다.
				local type = (balloon:GetMobName()=="balloon3" and BALLOONTYPE_3 or BALLOONTYPE_1)
				util:SendRanchStuff( RANCHSTUFF_BALLOON, type )

				StartTimer("BALLOON_HIT", 0.2)
			end
		end
	end
end

function BalloonHitEffect()
	util:IncidentSelf(INCIDENT_BALLOON_HIT)
	
	if g_BalloonCount==BALLOON_HIT_NICE_COUNT or g_BalloonCount==0 then
		util:IncidentSelf(INCIDENT_BALLOON_HITNICE)
	end
		
end

function EventRanchStuffFromServer(increaseMoney, totalMoney)
	g_BalloonCount = g_BalloonCount - 1
	__DEBUG('remain Balloon = '..g_BalloonCount..'\n')

	g_BalloonMoney = g_BalloonMoney + increaseMoney
	__DEBUG('Balloon Money = '..g_BalloonMoney..'\n')
	
	util:IncidentImageText(INCIDENT_BALLOON_GETMONEY, "img_carrotcount_10", tostring(increaseMoney), "race_font[50_68]_l", 0xFFFDCD02)
	
	if g_BalloonCount <= 0 then
		local info = GetMobInfo("stato")
		if info ~= nil and info.eventActivated then
			
			info.eventActivated = false
			util:ShowNavigationBar(true)
			NPCState("stato", STATE_EVENT2)
		end
	end
end

function ResetBalloonWarning()
	-- 타이머 다시 설정
	util:IncidentSelf(INCIDENT_BALLOON_COUNTDOWN)
	
	if not IsTimeOver(BALLOON_LIMIT_TIME - BALLOON_WARNING_DELAY) then
		StartTimer("BALLOON_WARNING", BALLOON_WARNING_DELAY)
	end
end

function RemoveAllBalloons()

	util:DeleteDirectionArrow()

	for i,objID in pairs(g_BalloonList) do
		local balloon = mgr:GetMob(objID)
		if balloon ~= nil then
			local info = GET_MOB_INFO(balloon)
			if info ~= nil then
				info.active = true
				balloon:SetHP(0)
				NEXT_STATE( info, STATE_DEAD )
			end
		end
	end

	g_BalloonList  = {}
end

function BalloonHitComplete()
	__DEBUG('Balloon Hit Complete!\n')
		
	util:IncidentSelf(INCIDENT_BALLOON_COMPLETE)
	RemoveAllBalloons()
	
	SendAchvComplete("BalloonComplete", g_BalloonTime)
	util:SendBalloonEnd(true)
	g_BalloonResultTime = g_BalloonTime
end

function BalloonGiveup(giveupCode)
	__DEBUG('Balloon Giveup!\n')
	
	if giveupCode == -1 then	
		util:IncidentSelf(INCIDENT_BALLOON_GIVEUP)

		NPCState("stato", STATE_EVENT3)

	else -- -2
		util:IncidentSelf(INCIDENT_BALLOON_TIMEOVER)
	end
	
	RemoveAllBalloons()
	
	local info = GetMobInfo("stato")
	if info ~= nil and info.eventActivated then		
		info.eventActivated = false
		util:ShowNavigationBar(true)
	end		
	
	util:SendBalloonEnd(false)
	g_BalloonResultTime = giveupCode
end

function ShowResultDialog()

	if g_BalloonCount <= 0 then
		local timerText = GET_TIMER_STRING(g_BalloonTime)
		
		RFCreateForm("BalloonResult", "Intro_exercise_result_dialog.xml", -1, -1, true)				-- [ IntroTitle ] - frame없는 refresh form생성
		RFSetLabel("BalloonResult", "txt_intro_record", timerText)
		RFSetLabel("BalloonResult", "txt_intro_getcarrot", tostring(g_BalloonMoney))
		RFButtonClicked("BalloonResult", "btn_ok", RFEVENT_SCRIPT)
		RFButtonClicked("BalloonResult", "btn_close", RFEVENT_SCRIPT)
		RFKeyDown("BalloonResult", VK_ESCAPE, RFEVENT_SCRIPT)
		RFKeyDown("BalloonResult", VK_RETURN, RFEVENT_SCRIPT)
	else
		OnEvent(EVENT_UI, "BalloonResult")
	end
end

function PopupChatResult()
	util:SetChatEvent(NPCCHATEVENT_BALLOONRESULT, g_BalloonResultTime)
	
	NPCState("stato", STATE_IDLE)
end
				
function EventCalledNPC(npcOID, callerOID)
	util:CallingRanchHorse(npcOID, callerOID)
end

function EventEndFollowingNPC(npcOID, callerOID)
	util:EndRanchHorseFollowing(npcOID, callerOID)
end 

function EventStartFollowingNPC(npcOID, callerOID)
	util:StartRanchHorseFollowing(npcOID, callerOID)
end 

function EventDevSetGroupForce(npcOID, groupForce)
	print('EventDevSetGroupForce oid='..npcOID..', groupForce='..groupForce..'\n')
	if GroupForceName ~= nil then

		util:InsertNoticeMsg('oid['..npcOID..'] => '..GroupForceName[groupForce]);
	else
		print('GroupForceName is nil\n')
	end
end

function EventCommonEvent(eventType, value)
	if eventType==SC_EVENT_HORSE_LEAVE_RANCH then
		local oid = value
		util:IncidentOther(INCIDENT_RANCH_HORSE_LEAVE, oid)
	end
end

DEFAULT_SCENE =
{
	CreateRanchNPC = function (nextSceneName)

		local SCENE_CREATE_NPC =
		{
			action =
			{
				-- condition, action			
				{},	{ CreateNPC, "introNPC", "oldman", "oldman", npcPos, npcOID },				-- NPC생성 : 할아버지
				{},	{ CreateNPC, "stato", "stato_ranch", "stato_ranch", statoPos, statoOID },	-- NPC생성 : 스타토
				{},	{ CreateNPC, "pig", "npc_pig", "npc_pig", pigPos, pigOID },					-- NPC생성 : 돼지
				{},	{ CreateNPC, "juna", "npc_juna", "npc_juna", junaPos, junaOID },			-- NPC생성 : 주나
				--{},	{ CreateNPC, "xmasTree", "npc_xmas_tree", "npc_xmas_tree", xmasTreePos, xmasTreePosOID },			-- NPC생성 : 주나

				{},	{ NextScene, nextSceneName },				
			},
		}

		return SCENE_CREATE_NPC	
	end,


	CreateSceneNormal = function (prepareSceneName)
		local SCENE_NORMAL = 
		{ 		
			-- action : 조건에 따라서 하나씩 순차적으로 실행
			action =
			{
			},		
			
			-- event : 특정한 event가 발생하면 지정된 것 실행
			event = 
			{ 
				-- event, action
				{ Event, EVENT_NPC_CHAT, "ranch_exercise" },	{ {ChatEnable, false}, {NextScene, prepareSceneName} },				-- 주행연습
				{ Event, EVENT_CALLED_NPC, "", "->"  },			{ EventCalledNPC }, 												-- 말 호출 표시 출력
				{ Event, EVENT_NPC_FOLLOW_START, "", "->"  },	{ EventStartFollowingNPC }, 										-- 말 따라다니기 표시 출력
				{ Event, EVENT_NPC_FOLLOWING_END, "", "->"  },	{ EventEndFollowingNPC }, 											-- 말 호출 표시 출력끝
				{ Event, EVENT_DEV_SET_GROUP_FORCE, "", "->" },{ EventDevSetGroupForce },											-- 개발 테스트용 말group 기세 설정
				{ Event, EVENT_SCRIPT, "", "->" },              { EventCommonEvent },
			},
		}
		return SCENE_NORMAL
	end,
	
	--[ SCENE_EXERCISE_PREPARE ]----------------------------------------------------------
	-- 주행연습 시작 창 확인하기
	--
	CreateSceneExercisePrepare = function (initSceneName, cancelSceneName)
		local SCENE_EXERCISE_PREPARE = 
		{ 		
			-- action : 조건에 따라서 하나씩 순차적으로 실행
			action =
			{
				{},						{ InputBlock, true },								-- 플레이어 입력 막음				
				{},						{ RFCreateForm, "ExerciseForm", "Intro_exercise_dialog.xml", -1, -1, true },		-- 연습시작
				{},						{ RFAddTextAreaString, "ExerciseForm", "ta_intro_exc_talkbox", "Balloon_StartComment" },		-- 연습시작
				{},						{ RFButtonClicked, "ExerciseForm", "btn_intro_exercise", RFEVENT_SCRIPT, 1 },				-- btn_intro_exercise버튼을 누를때 이벤트 발생
				{},						{ RFButtonClicked, "ExerciseForm", "btn_close", RFEVENT_SCRIPT, 2 },						-- btn_close버튼을 누를때 이벤트 발생
				{},						{ RFKeyDown, "ExerciseForm", VK_RETURN, RFEVENT_SCRIPT, 1 },								-- VK_RETURN를 누를때 이벤트 발생
				{},						{ RFKeyDown, "ExerciseForm", VK_ESCAPE, RFEVENT_SCRIPT, 2 },								-- VK_ESCAPE를 누를때 이벤트 발생
			},		
			
			-- event : 특정한 event가 발생하면 지정된 것 실행
			event = 
			{ 
				-- event, action
				{ Event, EVENT_UI, "ExerciseForm", 1 },				{ {RFClose, "ExerciseForm"}, {NextScene, initSceneName} },		-- 시작으로
				{ Event, EVENT_UI, "ExerciseForm", 2 },				{ {RFClose, "ExerciseForm"}, {InputBlock, false}, {ChatEnable, true}, {NextScene, cancelSceneName} },		-- 시작으로
			},
		}
		return SCENE_EXERCISE_PREPARE
	end,
	
	--[ SCENE_EXERCISE_INIT ]----------------------------------------------------------
	-- 주행연습 exercise
	--
	CreateSceneExerciseInit = function (waitSceneName)
		local SCENE_EXERCISE_INIT = 
		{ 		
			-- action : 조건에 따라서 하나씩 순차적으로 실행
			action =
			{
				-- condition, action	
				{},						{ FadeOut, 0.5 },									-- fade out		
				{ElapseTime,0.5},       { BalloonInit },									-- 초기화
				{},						{ Setup	},											-- 초기화
				{},						{ ShowNavigationBar, false },						-- 네비바 숨긴다
				{},						{ NPCState, "stato", STATE_EVENT },					-- stato activate
				{ElapseTime,0.1},		{ FadeIn, 0.5 },									-- fade in		
				{},						{ CameraMacro, "$Player", "Balloon_Start" },		-- 카메라				
			},		
			
			-- event : 특정한 event가 발생하면 지정된 것 실행
			event = 
			{ 
				{ Event, EVENT_CAMERA_STOP }, { {OnBalloonStartSceneEnd}, {NextScene, waitSceneName} },				-- (매크로)카메라가 멈췄으면 플레이어에게 카메라 전환
			},
		}
		
		return SCENE_EXERCISE_INIT
	end,
		
	
	--[ SCENE_EXERCISE_WAIT ]----------------------------------------------------------
	-- 주행연습 exercise
	--
	CreateSceneExerciseWait = function (endSceneName)
		local SCENE_EXERCISE_WAIT = 
		{ 		
			-- action : 조건에 따라서 하나씩 순차적으로 실행
			action =
			{
				{},						{ RFCreateForm, "BalloonStatus", "Intro_exercise_balloonscore_dialog.xml", -1, -1, false },		-- exit버튼
				{},						{ RFButtonClicked, "BalloonStatus", "btn_quit", RFEVENT_SCRIPT },			-- button
				{},						{ InputBlock, false },								-- 플레이어 입력 on
				{},						{ BalloonStart },									-- 시작
				{},						{ NPCState, "stato", STATE_EVENT1 },				-- stato activate
				{},						{ StartTimer, "BALLOON_WARNING", BALLOON_WARNING_TIME },	-- 종료 경고
			},		
			
			process =
			{				
				{ IsTimeOver, BALLOON_LIMIT_TIME },			{ {RFClose, "BalloonStatus"}, {BalloonGiveup,-2}, {NextScene, endSceneName} },		-- 시작으로
			},
			
			-- event : 특정한 event가 발생하면 지정된 것 실행
			event = 
			{ 
				-- event, action
				{ Event, EVENT_PLAYER_COLLISION, "", "->" },							{ BalloonHit },				-- Balloon Hit!
				{ Event, EVENT_PLAYER_ACTION, "RanchStuffFromServer", "->"  },			{ EventRanchStuffFromServer }, 
				{ Event, EVENT_TIMER, "BALLOON_HIT" },									{ BalloonHitEffect },
				{ Event, EVENT_TIMER, "BALLOON_WARNING" },								{ ResetBalloonWarning },
				{ Event, EVENT_PLAYER_ACTION, "", PLAYER_ACTION_HIT_BALLOON_COMPLETE }, { {BalloonHitComplete}, {NextScene, endSceneName} },				-- Balloon Hit!			
				{ Event, EVENT_UI, "BalloonStatus" },									{ {RFClose, "BalloonStatus"}, {BalloonGiveup,-1}, {NextScene, endSceneName} },		-- 시작으로
			},
		}
		
		return SCENE_EXERCISE_WAIT
	end,
	
	
	--[ SCENE_EXERCISE_END ]----------------------------------------------------------
	-- 주행연습 exercise
	--
	CreateSceneExerciseEnd = function (completeSceneName)
		local SCENE_EXERCISE_END = 
		{ 		
			-- action : 조건에 따라서 하나씩 순차적으로 실행
			action =
			{
				{ElapseTime,2},			{ FadeOut, 0.5 },									-- fade out		
				{},						{ InputBlock, true },								
				{ElapseTime,0.5},		{ Cleanup },										-- 복구
				{},						{ ShowNavigationBar, true },						-- 네비바 보인다
				{},						{ FadeIn, 0.5 },									-- fade in
				{},						{ ShowResultDialog },								-- 결과창				
			},		
			
			process =
			{				
			},
			
			-- event : 특정한 event가 발생하면 지정된 것 실행
			event = 
			{ 			
				{ Event, EVENT_TIMER, "BALLOON_HIT" },				{ BalloonHitEffect },
				{ Event, EVENT_UI, "BalloonResult" },				{ {RFClose, "BalloonResult"}, { InputBlock, false }, {PopupChatResult}, {NextScene, completeSceneName} },		-- 끝~
			},
		}
		
		return SCENE_EXERCISE_END
	end,
}


function RegisterExerciseScene(sceneScript, beginSceneName)
	sceneScript[beginSceneName] = DEFAULT_SCENE.CreateSceneNormal("SCENE_EXERCISE_PREPARE")
	sceneScript["SCENE_EXERCISE_PREPARE"] = DEFAULT_SCENE.CreateSceneExercisePrepare("SCENE_EXERCISE_INIT", beginSceneName)
	sceneScript["SCENE_EXERCISE_INIT"] = DEFAULT_SCENE.CreateSceneExerciseInit("SCENE_EXERCISE_WAIT")
	sceneScript["SCENE_EXERCISE_WAIT"] = DEFAULT_SCENE.CreateSceneExerciseWait("SCENE_EXERCISE_END")
	sceneScript["SCENE_EXERCISE_END"] = DEFAULT_SCENE.CreateSceneExerciseEnd(beginSceneName)
end

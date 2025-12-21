require('AIState')
require('AIHelper')
require('AIDefault')
require('MissionTypes')
require('GameHelper')
require('UITypes')
require('EffectTypes')
require('NetTypes')

DIALOG_ASK_JUMP		= 1
DIALOG_JUMP_FAIL	= 2
DIALOG_GOOD_JOB		= 3

PLAYING				= 1
FAIL_TIME			= 2
FAIL_FALL			= 3

g_Game = CREATE_GAME()

local UI_FRAME_READY	= "MISSION_COMMON"
local UI_READY_IMAGE	= "READY_IMAGE"

function CreateGameState()
	local stateList = 
	{	
		--WAIT = g_DefaultClientGameState.CreateWaitStartState( "INIT" ),
		
		INIT = 
		{	
			enter = function (state, game) 
			
				util:InputBlock(true)
				local startMat = mgr:GetNodePos(riderStartPosName)
				util:SetMyPos( startMat.pos, startMat.at )
				
				local statoMat = mgr:GetNodePos(statoStartPosName)				
				
				-- client only mob
				local stato = mgr:CreateMob( "stato", "stato", statoMat.pos, MONSTER_TYPE_FRIENDLY )
				stato:LookAt( v3(statoMat.pos.x + statoMat.at.x, statoMat.pos.y + statoMat.at.y, statoMat.pos.z + statoMat.at.z) )
				game.statoID = stato:GetObjID()				
				
				-- SetCameraFocus( objectID, distance, cameraHeight, targetHeight )
				print('game.statoID = '..game.statoID..'\n')
				util:SetCameraFocus(game.statoID, 3.5, -1.7, 2)
				util:ShowRaceString(jumpStartString, DIALOG_ASK_JUMP, UIFORM_INFO, '$1['..MISSION_TRY_TIME..']')
				
				-- UI
				util:UICreateFrame(UI_FRAME_READY, ALIGN_CENTER, 0, 0)
				util:UICreateOverlay(UI_FRAME_READY, UI_READY_IMAGE, "text_ready", ALIGN_CENTER, 0, -50)
				
				state.procDelay = 0.1
			end,			
			
			event = function( state, game, event, strValue, intValue1, intValue2 )
				if event==EVENT_UI_CLOSE then
					if strValue=="MissionInfo" and intValue1==DIALOG_ASK_JUMP then						
						NEXT_STATE( game, "WAIT_START" )
					end
				end
			end,
		},
		
		WAIT_START =
		{
			enter = function (state, game) 
				
				util:UIFrameEvent(UI_FRAME_READY, "Show", 0.3)
				
				util:SetCameraPlayer()
				
				util:ShowTimer(START_DELAY_TIME)
				SET_TIMER(game, "START_DELAY_TIME", START_DELAY_TIME)
				SET_TIMER(game, "READY_BLINK", 0.9)
				util:IncidentSelf(INCIDENT_COUNTDOWN)
			end,
			
			leave = function (state, game) 
				util:UIFrameEvent(UI_FRAME_READY, "Hide", 0.3)
				CLEAR_TIMER(game, "START_DELAY_TIME")
			end,
			
			event = function( state, game, event, strValue, intValue1, intValue2 )
				if event==EVENT_TIMER then
					if strValue=="START_DELAY_TIME" then
						NEXT_STATE( game, "PLAY" )						
					elseif strValue=="READY_BLINK" then
						SET_TIMER(game, "READY_BLINK", 0.9)
						
						util:UIFrameEvent(UI_FRAME_READY, "Hide")
						util:UIFrameEvent(UI_FRAME_READY, "Show", 0.5)
						util:IncidentSelf(INCIDENT_COUNTDOWN)
					end
				end
			end
		},
		
		PLAY =
		{
			enter = function (state, game) 
				
				if not state.isInit then
					-- first try
					util:StartGame()					
				else
					util:RestartGame()
				end
				
				local pos = util:GetMyPos()
				
				util:InputBlock(false)
				util:SendStartingRate(STARTING_PERFECT)
				
				util:ShowTimer(MISSION_TRY_TIME)
				util:StartTimeRecord(MISSION_TRY_TIME)
				SET_TIMER(game, "JUMP_TIME_OVER", MISSION_TRY_TIME)
				
				--util:UIFrameEvent("MINIMAP", "Hide", 0)
				
				game.result = PLAYING
				game.jumpCount = 0
				state.procDelay = 0.1				
			
				state.prevPos = v3(pos.x, pos.y, pos.z)
				state.isInit = true
				
				game.startTime = game.curTime
			end,
			
			process = function (state, game)
				local pos = util:GetMyPos()
			
				--if util:IsCrossLine( state.prevPos, pos, goalLine1, goalLine2 ) then
				--	NEXT_STATE( game, "SUCCESS" )					
				--end
				
				state.prevPos = v3(pos.x, pos.y, pos.z)
			end,
			
			leave = function (state, game) 
				CLEAR_TIMER(game, "JUMP_TIME_OVER")
			end,
			
			event = function( state, game, event, strValue, intValue1, intValue2 )
				if event==EVENT_TIMER then
					if strValue=="JUMP_TIME_OVER" then
						game.result = FAIL_TIME
						NEXT_STATE( game, "FAIL_RETRY" )						
					end
				elseif event==EVENT_TRIGGER then
					if strValue=="goalin" then
						--print('goalin\n')
						NEXT_STATE( game, "SUCCESS" )
					elseif strValue=="falling" then
						--print('falling event\n')
						game.result = FAIL_FALL
						NEXT_STATE( game, "FAIL_RETRY" )
					end
				end
			end
		},
		
		SUCCESS =
		{
			enter = function (state, game)
				local stato = mgr:GetMob(game.statoID)
				if stato ~= nil then
					-- 결승점 근처
					local endMat = mgr:GetNodePos(statoEndPosName)					
					stato:ResetPos( endMat.pos.x, endMat.pos.y, endMat.pos.z )
					stato:LookAt( v3(endMat.pos.x + endMat.at.x, endMat.pos.y + endMat.at.y, endMat.pos.z + endMat.at.z) )
					
					stato:LookAt( util:GetMyPos() )
				end
				
				util:InputBlock(true)
				util:SetCameraFocus(game.statoID, 3.5, -1.7, 2)
				util:HideTimer()
				util:StopTimeRecord()
				
				util:ShowRaceString("Jump_GoodJob", DIALOG_GOOD_JOB)				
				
				--local lapTime = math.floor( (game.curTime - game.startTime) * 1000 )
				local lapTime = util:GetTimeRecord()
                mgr:SendEventToServer( EVENT_RECORD, MISSIONRECORD_MINTIME, lapTime )
				mgr:SendEventToServer( EVENT_SCRIPT, CS_EVENT_MISSION_RESULT, lapTime )
				game.active = false
			end,
			
			event = function( state, game, event, strValue, intValue1, intValue2 )
				if event==EVENT_UI_CLOSE then
					if strValue=="MissionInfo" and intValue1==DIALOG_GOOD_JOB then						
						util:SetCameraPlayer()
					end
				end
			end,
		},		
		
		-- 요건 완전 종료인데 지금은 안씀!
		FAIL_OVER =
		{
			enter = function (state, game)
				util:InputBlock(true)
				util:SetCameraFocus(game.statoID, 3.5, -1.7, 2)
				util:HideTimer()
				util:StopTimeRecord()
				
				util:ShowRaceString("Jump_Failed", DIALOG_JUMP_FAIL, UIFORM_INFO, '$1['..MISSION_TRY_TIME..']')
				mgr:SendEventToServer( EVENT_SCRIPT, CS_EVENT_MISSION_RESULT, -1 )
				game.active = false
			end,
			
			event = function( state, game, event, strValue, intValue1, intValue2 )
				if event==EVENT_UI_CLOSE then
					if strValue=="MissionInfo" and intValue1==DIALOG_JUMP_FAIL then						
						util:SetCameraPlayer()
					end
				end
			end,
		},		
		
		FAIL_RETRY =
		{
			enter = function (state, game)
				local startMat = mgr:GetNodePos(riderStartPosName)
				util:SetMyPos( startMat.pos, startMat.at )
				
				util:InputBlock(true)
				util:SetCameraFocus(game.statoID, 3.5, -1.7, 2)
				util:HideTimer()
				util:StopTimeRecord()
				
				if game.result == FAIL_TIME then				
					util:ShowRaceString("Jump_Failed", DIALOG_JUMP_FAIL, UIFORM_YESNO, '$1['..MISSION_TRY_TIME..']')					
				else 
					util:ShowRaceString("Jump_Failed_Fall", DIALOG_JUMP_FAIL, UIFORM_YESNO)
				end
				
				--mgr:SendEventToServer( EVENT_SCRIPT, CS_EVENT_MISSION_RESULT, 0 )
				--game.active = false				
			end,
			
			event = function( state, game, event, strValue, intValue1, intValue2 )
				if event==EVENT_UI_CLOSE then
					if strValue=="MissionInfo" and intValue1==DIALOG_JUMP_FAIL then						
						local button = intValue2
						print('button = '..button..'\n')
						if button==RFYES then
							--util:SetCameraPlayer()
							-- retry						
							--util:ScreenEffect("BeginSceneEffect")
							NEXT_STATE( game, "WAIT_START" )
						elseif button==RFNO then
							mgr:SendEventToServer( EVENT_SCRIPT, CS_EVENT_MISSION_RESULT, -1 )
							game.active = false				
						end
					end
				end
			end,
		},		
	}

	return stateList
end

-- 초기화
function OnInit()
	
	g_Game.state = CreateGameState()
	NEXT_STATE( g_Game, "INIT" )
	
	print('--- client Init OK\n')
end

-- process때마다 호출
function OnProcess( deltaTime )

	if g_Game.active then
		PROCESS_GAME( g_Game, deltaTime )		
	end
end

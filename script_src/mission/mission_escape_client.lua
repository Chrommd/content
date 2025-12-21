require('AIState')
require('AIHelper')
require('AIDefault')
require('MissionTypes')
require('GameHelper')
require('UITypes')
require('EffectTypes')

local DIALOG_ASK_START = 1
local DIALOG_ASK_RESURRECT = 2

local resurrectString = "AskResurrect"

g_Game = CREATE_GAME()

local UI_FRAME_SCREEN	= "MISSION_SCREEN"
local UI_WARNING		= "MISSION_WARNING"

local minPosY = -100
local maxPosY = 100
local maxDist = 150
local warningDist = 70

local castleSummonPos --= v3(269.15, -105.47, 258.93)				
local castleSummonGatePos

function CreateGameState()
	local stateList = 
	{	
		WAIT =
		{
			enter = function (state, game) 
			
				castleSummonPos = mgr:GetNodePos(castleSummonPosName).pos
				castleSummonGatePos = mgr:GetNodePos(castleSummonGatePosName).pos
				
				util:InputBlock(true)
				util:UICreateFrame(UI_FRAME_SCREEN, ALIGN_CENTER, 0, 0)
				
				util:UICreateOverlay(UI_FRAME_SCREEN, UI_WARNING, "boss_warning", ALIGN_CENTER)
				util:UIEvent(UI_FRAME_SCREEN, UI_WARNING, "SetData", "-size "..util:GetScreenWidth().." "..util:GetScreenHeight())
								
				if resetStartPoint and mgr:GetPlayerCount() <= 1 then
					--local startMat = mgr:GetNodePos("start_point")
					--util:SetMyPos( startMat.pos, startMat.at )			
					util:SetMyPos( playerStartPos, playerStartAt )								
				end
				
				mgr:SendEventToServer( EVENT_WAIT, CS_EVENT_LOAD_COMPLETE )
				
				state.procDelay = 0.1
				
				game.displayWarning = false
			end,			
			
			event = function( state, game, event, strValue, intValue1, intValue2 )
				if event==EVENT_SCRIPT then
					if strValue=="server" then
						if intValue1==SC_EVENT_ADD_NPC then						
							game.statoID = intValue2							
						elseif intValue1==SC_EVENT_ADD_BOSS then						
							game.bossID = intValue2							
						end
						
						if game.statoID~=nil and game.bossID~=nil then
						
							if SKIP_OPENING then
								SET_GAME_STATE( game, "WAIT_SERVER_OPENING" )
								mgr:SendEventToServer( EVENT_WAIT, CS_EVENT_OPENING_COMPLETE )
							else
								SET_GAME_STATE( game, "CLIENT_OPENING" )
							end
						end
					end
				end
			end,
		},
		
		CLIENT_OPENING =
		{
			enter = function (state, game) 
				util:SetCameraFocus(game.statoID, 9, -1, 5)
				util:ShowRaceString( "Boss_StartComment", DIALOG_ASK_START )
				
				state.procDelay = 0.1
			end,
			
			event = function( state, game, event, strValue, intValue1, intValue2 )
				if event==EVENT_UI_CLOSE then
					if strValue=="MissionInfo" and intValue1==DIALOG_ASK_START then
						mgr:SendEventToServer( EVENT_WAIT, CS_EVENT_OPENING_COMPLETE )
						util:UIFrameEvent("WAITING", "Show", 0.3)
					end
				end
				
				if event==EVENT_WAIT then
					if strValue=="server" and intValue1==SC_EVENT_OPENING_COMPLETE then			
						SET_GAME_STATE( game, "WAIT_SERVER_OPENING" )						
					end
				end
			end
		},	
		
		WAIT_SERVER_OPENING =
		{
			enter = function (state, game) 
				if SKIP_OPENING then
				else
					util:SetCameraFocus(game.statoID, 15, -1, 5)
				end
			end,
			
			event = function( state, game, event, strValue, intValue1, intValue2 )
				if event==EVENT_WAIT then
					if strValue=="server" and intValue1==SC_EVENT_MISSION_START then			
						SET_GAME_STATE( game, "INIT" )						
					end
				end
			end,
		},		
		
		INIT = 
		{	
			enter = function (state, game) 
				-- SetCameraFocus( objectID, distance, cameraHeight, targetHeight )
				
				if CAMERA_TEST or SKIP_OPENING then
					-- skip focus
					SET_TIMER(game, "WAIT_BOSS_ENTERANCE", 1)
				else	
					util:SetCameraFocus(game.bossID, 40, 5, 10)
					util:SetCameraFocusRotateMode(1, 20, v3(0,1,0))

					SET_TIMER(game, "WAIT_BOSS_ENTERANCE", OPENING_WAITING_TIME)
				end				
				
				state.procDelay = 0.1
			end,			
			
			event = function( state, game, event, strValue, intValue1, intValue2 )
				if event==EVENT_TIMER then
					if strValue=="WAIT_BOSS_ENTERANCE" then
						SET_GAME_STATE( game, "PLAY" )
					end
				elseif event==EVENT_SCRIPT then
					if strValue=="server" then
						if intValue1==SC_EVENT_MISSION_PLAY_TIMER then
							--util:UIEvent("MISSION", "TIMEOUT_COUNT", "SetPos", "-pos 100 -100");
							--util:ShowTimer(intValue2)
							SET_TIMER(game, "TIME_OVER", intValue2)							
						end
					end
				end
			end,
		},
	
		PLAY =
		{
			enter = function (state, game) 
			
				util:UIFrameEvent("WAITING", "Hide", 0.3)
				
				util:StartGame()
				
				--util:PlayBGM( "bgm_race07" )
				
				util:UIFrameEvent(UI_FRAME_SCREEN, "Show", 0.5)
				--util:UIFrameEvent("MINIMAP", "Hide", 0)				
				util:UIHide(UI_FRAME_SCREEN, UI_WARNING, 0)				
						
				if ROAD_LIMIT then
					util:SetCameraPlayer()
				else
					util:SetCameraPlayerLookAt(game.bossID)
				end
				
				util:InputBlock(false)
				
				util:ShowTargetHP(game.bossID)
				
				if CAMERA_TEST then
					SET_TIMER(game, "CAMERA_LOOKAT", 0.1)
				else
					SET_TIMER(game, "CAMERA_LOOKAT", 10)
				end
				
				if ROAD_LIMIT then
					--util:EnableRoadLimiter(true)
					--util:SetRoadLimiterConfig( 100, 10 )
				end
				
				--util:ShowTimer(MISSION_TRY_TIME)
					
				game.warning = false			-- now displaying?
				game.checkWarning = true		-- check warning show/hide
				state.procDelay = 0.1	
				game.resurrectCount = playerResurrectCount
				game.popupResurrectTime = game.curTime + 5
				game.asking = false
			end,
			
			process = function (state, game)	
				local dist = util:GetDist( util:GetMyOID(), game.bossID )
				local ratio = RANGE( 0, (dist-5)/maxDist, 1 )
				local y = math.floor(ratio * (maxPosY - minPosY))
				
				if game.displayWarning and dist < warningDist then
					if game.checkWarning then
						local fadetime = RANGE( 0.2, dist * 0.01, 0.7 )
						if not game.warning then
							--util:UIShow(UI_FRAME_SCREEN, UI_WARNING, fadetime)
							--util:IncidentSelf(INCIDENT_BOSSWARNING)						
						else
							util:UIHide(UI_FRAME_SCREEN, UI_WARNING, fadetime)
						end	
						SET_TIMER(game, "TOGGLE_WARNING", fadetime)				
						game.checkWarning = false
					end
				else
					if game.warning then
						util:UIHide(UI_FRAME_SCREEN, UI_WARNING, 0.5)
						game.warning = false						
					end										
				end
				
				if ROAD_LIMIT then
					--local bossPos = util:GetAssetPos(game.bossID)
					--util:SetRoadLimiterTop( bossPos )
				end
				
				-- 거리멀면 땡기기
				if resetToBossPosition then
					local dist = util:GetDist( util:GetMyOID(), game.bossID )
					if dist > resetBossToPlayerDist then
						local bossMat = util:GetDummyMatrix(game.bossID)
						util:ResetMyPos( bossMat, 0 )			
					end
				end
				
				if game.resurrectCount>0 and not game.asking and game.curTime >= game.popupResurrectTime and util:HasStatus( util:GetMyOID(), PLAYERSTATUS_FAINT ) then
					util:ShowRaceString(resurrectString, DIALOG_ASK_RESURRECT, UIFORM_YESNO, '$1['..game.resurrectCount..']')
					game.resurrectCount = game.resurrectCount - 1
					game.asking = true
				end
			end,
			
			leave = function (state, game) 
				CLEAR_TIMER(game, "WAIT_END_TIME")
				CLEAR_TIMER(game, "TOGGLE_WARNING")
			end,
			
			event = function( state, game, event, strValue, intValue1, intValue2 )
				if event==EVENT_TIMER then
					if strValue=="TOGGLE_WARNING" then
						game.warning = not game.warning
						game.checkWarning = true
					elseif strValue=="CAMERA_LOOKAT" then
						if not ROAD_LIMIT then
							util:SetCameraPlayerLookAt(game.bossID)
						end
					elseif strValue=="WAIT_END_TIME" then
						SET_GAME_STATE( game, "END" )						
					end				
			
				elseif event==EVENT_UI_CLOSE then
					if strValue=="MissionInfo" and intValue1==DIALOG_ASK_RESURRECT then						
						local button = intValue2
						if button==RFYES then
							mgr:SendEventToServer( EVENT_SCRIPT, CS_EVENT_MISSION_RESURRECT, util:GetMyOID() )
							game.asking = false
							game.popupResurrectTime = game.curTime + 5
						elseif button==RFNO then
							-- 
						end						
					end
					
				elseif event==EVENT_TRIGGER then
					print('TriggerEvent : '..strValue..', v1='..intValue1..', v2='..intValue2..'\n')
					
				elseif event==EVENT_SCRIPT then
					if strValue=="server" then
						if intValue1==SC_EVENT_BEGIN_TRACE_PLAYER then							
							if intValue2==util:GetMyOID() then
								-- 나를 쫓아오는 경우
								game.displayWarning = true
								--print('begin trace\n')
							end
						elseif intValue1==SC_EVENT_END_TRACE_PLAYER then
							if intValue2==util:GetMyOID() then
								-- 나를 그만 쫓아오는 경우
								game.displayWarning = false
								--print('end trace\n')							
							end
						elseif intValue1==SC_EVENT_INCIDENT then
							if intValue2==INCIDENT_SUMMONED then								
								util:IncidentPos(INCIDENT_SUMMONED, castleSummonPos)									
							end
							
						elseif intValue1==SC_EVENT_SCENE_START then
							print('client event start\n')
							if intValue2==EVENT_SCENE1 then
								-- 분지 도착
								ROAD_LIMIT = false
								--util:EnableRoadLimiter(false)
								util:SetCameraPlayerLookAt(game.bossID)
					
								util:SetCameraFocus(game.bossID, 40, 5, 10)
								util:SetCameraFocusRotateMode(1, 25, v3(0,1.5,0.5))
							elseif intValue2==EVENT_SCENE2 then
								-- 첫번째 약화 상태
								util:SetCameraFocus(game.bossID, 40, 5, 20)
								util:SetCameraFocusRotateMode(1, 25, v3(0,0.5,0.5))
							elseif intValue2==EVENT_SCENE3 then
								-- 소환
								local targetPos = castleSummonPos
								targetPos.y = castleSummonGatePos.y
								local frontDir = GetDir(castleSummonGatePos, targetPos);
								util:SetCameraFocusPos(castleSummonPos, frontDir, 50, 0, -6)
								util:IncidentPos(INCIDENT_CASTLESUMMON, castleSummonGatePos)
							elseif intValue2==EVENT_SCENE4 then
								-- 죽을때
								util:SetCameraFocus(game.bossID, 50, 5, 10)
								util:SetCameraFocusRotateMode(1, 15, v3(0.5,0,0.5))
							end
							
							util:InputBlock(true)
							util:UIFrameEvent("WAITING", "Show", 0.3)
						elseif intValue1==SC_EVENT_SCENE_END then
							print('client event end\n')
							if not ROAD_LIMIT then
								util:SetCameraPlayerLookAt(game.bossID)
							end
							util:InputBlock(false)
							util:UIFrameEvent("WAITING", "Hide", 0.3)
						elseif intValue1==SC_EVENT_MISSION_END_WAIT then
							-- 게임 끝날때 waiting
							local waitTime = intValue2
							util:SetWaitEnd(waitTime)
							SET_TIMER(game, "WAIT_END_TIME", waitTime)
						elseif intValue1==SC_EVENT_MISSION_DEAD_WAIT then
							local waitTime = intValue2
							util:ShowTimer(waitTime, util:GetScreenWidth()/2-100, 0)
							print('DEAD WAIT TIME = '..waitTime..'\n')
						elseif intValue1==SC_EVENT_MISSION_DEAD_WAIT_CANCEL then
							util:HideTimer()
							print('CANCEL DEAD WAIT TIME\n')
						elseif intValue==SC_EVENT_MISSION_RESULT then
							-- 게임 결과
							if intValue==1 then
								util:ShowRaceString( "Boss_EndComment", DIALOG_GOOD_JOB, UIFORM_INFO )
							else
								util:ShowRaceString( "Boss_EndComment_Failed", DIALOG_GOOD_JOB, UIFORM_INFO )
							end
						end
					end
				end
			end
		},
		
		END =
		{
			enter = function (state, game)
				util:InputBlock(false)				
				game.active = false
			end,
			
			event = function( state, game, event, strValue, intValue1, intValue2 )				
			end,
		},		
		
	}

	return stateList
end

-- 초기화
function OnInit()
	
	g_Game.state = CreateGameState()
	SET_GAME_STATE( g_Game, "WAIT" )
	
	print('--- client Init OK\n')
end

-- process때마다 호출
function OnProcess( deltaTime )

	if g_Game.active then
		PROCESS_GAME( g_Game, deltaTime )		
	end
end

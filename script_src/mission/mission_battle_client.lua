require('AIState')
require('AIHelper')
require('AIDefault')
require('MissionTypes')
require('GameHelper')
require('UITypes')
require('EffectTypes')
require('SkillTypes')

local DIALOG_ASK_START = 1
local DIALOG_ASK_RESURRECT = 2

local resurrectString = "AskResurrect"

g_Game = CREATE_GAME()

local UI_FRAME_SCREEN	= "MISSION_SCREEN"
local UI_WARNING		= "MISSION_WARNING"

local UI_FRAME_RIGHTUP	= "MISSION_RIGHTUP"
local UI_DISTANCE		= "MISSION_BOSS_DIST"

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
				
				util:UICreateFrame(UI_FRAME_RIGHTUP, ALIGN_RIGHT_TOP, 0, 0)
				util:UICreateImageFont(UI_FRAME_RIGHTUP, UI_DISTANCE, "font28[22_29]_s", -50, 60)
								
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
						if intValue1==SC_EVENT_ADD_BOSS then						
							game.bossID = intValue2							
						end
						
						if game.bossID~=nil then
						
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
				state.procDelay = 0.1
				
				mgr:SendEventToServer( EVENT_WAIT, CS_EVENT_OPENING_COMPLETE )
				util:UIFrameEvent("WAITING", "Show", 0.3)
			end,
			
			event = function( state, game, event, strValue, intValue1, intValue2 )				
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
					--util:SetCameraFocus(game.bossID, 30, -5, 10, "cam_focus")
					--util:SetCameraFocusRotateMode(1, 20, v3(0,1,0))
					
					util:SetCameraPlayerLookAt(game.bossID, 1)

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
				
				util:UIFrameEvent(UI_FRAME_SCREEN, "Show", 0.5)
				util:UIFrameEvent(UI_FRAME_RIGHTUP, "Show", 0.5)
				
				--util:UIFrameEvent("MINIMAP", "Hide", 0)				
				util:UIHide(UI_FRAME_SCREEN, UI_WARNING, 0)				
				
				util:UIEvent(UI_FRAME_RIGHTUP, UI_DISTANCE, "SetText", tostring(0))
						
				if true then --ROAD_LIMIT then
					if not SKIP_OPENING then
						util:SetCameraPlayer()
					end
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
				
				
				util:SetRoadLimiterConfig( roadRange, roadVelocity, resetRange )
				local bossPos = util:GetAssetPos(game.bossID)
				util:SetRoadLimiterTop( bossPos, topExtraRange )				
				util:SetRoadLimiterResetType(resetType)
				
				--util:ShowTimer(MISSION_TRY_TIME)
					
				state.procDelay = 0.1	
				game.resurrectCount = playerResurrectCount
				game.popupResurrectTime = game.curTime + 5
				game.asking = false
			end,
			
			process = function (state, game)	
				
				local bossPos = util:GetAssetPos(game.bossID)
				util:SetRoadLimiterTop( bossPos, topExtraRange )
				
				if game.resurrectCount>0 and not game.asking and game.curTime >= game.popupResurrectTime and util:HasStatus( util:GetMyOID(), PLAYERSTATUS_FAINT ) then
					util:ShowRaceString(resurrectString, DIALOG_ASK_RESURRECT, UIFORM_YESNO, '$1['..game.resurrectCount..']')
					game.resurrectCount = game.resurrectCount - 1
					game.asking = true
				end
				
				local roadGap	= util:GetRoadGap( util:GetMyOID() )
				local dist		= math.floor(roadRange - roadGap.z)
				util:UIEvent(UI_FRAME_RIGHTUP, UI_DISTANCE, "SetText", tostring(dist))
			end,
			
			leave = function (state, game) 
				CLEAR_TIMER(game, "WAIT_END_TIME")				
			end,
			
			event = function( state, game, event, strValue, intValue1, intValue2 )
			
				if event==EVENT_GAME then
					if strValue=="FirstPlayerIn" then
						mgr:SendEventToServer( EVENT_SCRIPT, CS_EVENT_FIRST_PLAYER_IN, intValue1 )
					elseif strValue=="FirstPlayerOut" then
						if not EFFECT_TEST then
							mgr:SendEventToServer( EVENT_SCRIPT, CS_EVENT_FIRST_PLAYER_OUT, intValue1 )
						end
					end
				elseif event==EVENT_TIMER then
					if strValue=="CAMERA_LOOKAT" then
						--if not ROAD_LIMIT then
						--	util:SetCameraPlayerLookAt(game.bossID)
						--end
					elseif strValue=="WAIT_END_TIME" then
						SET_GAME_STATE( game, "END" )						
					end				
				elseif event==EVENT_GET_ITEM then
					if strValue=="client" then
						local itemType = intValue1
						local itemOID = intValue2
						
						if itemType==ITEM_CARROT then
							--print('client-CARROT!\n')
						elseif itemType==ITEM_APPLE then
							--print('client-APPLE!\n')
						end
						
					end
				elseif event==EVENT_PLAYER_ACTION then
					if strValue=="client" then
						local actionID = intValue1
						local attackCharge = intValue2
						
						-- reflection
						if actionID==PLAYER_ACTION_REFLECTION then
							--mgr:SendEventToServer( EVENT_SCRIPT, CS_EVENT_PLAYER_REFLECTION, util:GetMyOID() )
							local dist = (attackCharge and reflectionChargeDist or reflectionDist)	-- 차지가 범위가 크다.
							local angle = (attackCharge and reflectionChargeAngle or reflectionAngle)
							util:ReflectSkills(SKILLID_TAIL_SPLASH, dist, angle)
							util:ReflectSkills(SKILLID_TAIL_SPLASH2, dist, angle)
						end
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
						if intValue1==SC_EVENT_ADD_BOSS then						
							game.bossID = intValue2
						elseif intValue1==SC_EVENT_ACQUIRE_ITEM then
							local itemType = intValue2
							if itemType == ITEM_MP then
								util:AddBoosterGauge( itemBoosterMP )
							end							
						elseif intValue1==SC_EVENT_FIRST_PLAYER_IN then
							-- 1등 영역 안으로							
							local firstID = intValue2						
							util:SetBossRunawayWarning(false, BOSS_RUNAWAY_TIME)
						elseif intValue1==SC_EVENT_FIRST_PLAYER_OUT then
							-- 1등 영역 밖으로
							local firstID = intValue2
							util:SetBossRunawayWarning(true, BOSS_RUNAWAY_TIME)
						elseif intValue1==SC_EVENT_BOSS_RUNAWAY then
							SET_GAME_STATE( game, "END" )
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
				util:InputBlock(true)				
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

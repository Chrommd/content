require('AIState')
require('AIHelper')
require('AIDefault')
require('MissionTypes')
require('GameHelper')
require('UITypes')
require('EffectTypes')
require('NetTypes')

DIALOG_ASK_START	= 1
DIALOG_FAIL	= 2
DIALOG_GOOD_JOB		= 3

local UI_FRAME_COMMON	= "MISSION_COMMON"
local UI_TARGET_IMAGE	= "TARGET_IMAGE"
local UI_ATTACK_COUNT	= "ATTACK_COUNT"
--local UI_HP				= "HP"


g_Game = CREATE_GAME()

function CreateGameState()
	local stateList = 
	{	
		WAIT = g_DefaultClientGameState.CreateWaitStartState( "INIT" ),
		
		INIT = 
		{	
			enter = function (state, game) 
			
				util:UICreateFrame(UI_FRAME_COMMON, ALIGN_RIGHT_TOP, 0, 0)
				util:UICreateImageFont(UI_FRAME_COMMON, UI_ATTACK_COUNT, "font54[39_49]_s", -150, 200)
				--util:UICreateImageFont(UI_FRAME_COMMON, UI_HP, "font54[39_49]_s", -400, 500)
				util:UICreateOverlay(UI_FRAME_COMMON, UI_TARGET_IMAGE, "icon_deadline", ALIGN_CENTER, -200, 200)
				util:UIEvent(UI_FRAME_COMMON, UI_TARGET_IMAGE, "Scale", "-ratio 1.5 -align 34")
				
				util:InputBlock(true)
				local startMat = mgr:GetNodePos(riderStartPosName)
				util:SetMyPos( startMat.pos, startMat.at )
				
				local statoMat = mgr:GetNodePos(statoStartPosName)
				
				-- client only mob
				local stato = mgr:CreateMob( "stato", "stato", statoMat.pos, MONSTER_TYPE_FRIENDLY, 28999 )
				stato:LookAt( v3(statoMat.pos.x + statoMat.at.x, statoMat.pos.y + statoMat.at.y, statoMat.pos.z + statoMat.at.z) )
				game.statoID = stato:GetObjID()		
				
				-- SetCameraFocus( objectID, distance, cameraHeight, targetHeight )
				print('game.statoID = '..game.statoID..'\n')
				util:SetCameraFocus(game.statoID, 3.5, -1.7, 2)
				util:ShowRaceString(startString, DIALOG_ASK_START, UIFORM_INFO, '$1['..MISSION_TRY_TIME..']')
				
				state.procDelay = 0.1
			end,			
			
			event = function( state, game, event, strValue, intValue1, intValue2 )
				if event==EVENT_UI_CLOSE then
					if strValue=="MissionInfo" and intValue1==DIALOG_ASK_START then						
						NEXT_STATE( game, "PLAY" )
					end
				end
			end,
		},
	
		PLAY =
		{
			enter = function (state, game) 
				
				mgr:SendEventToServer( EVENT_WAIT, CS_EVENT_MISSION_START )
				
				if not state.isInit then
					-- first try
					util:StartGame()					
				end
				
				local pos = util:GetMyPos()
				
				util:InputBlock(false)
				util:SetCameraPlayer()
				util:SendStartingRate(STARTING_PERFECT)
				
				util:UIFrameEvent(UI_FRAME_COMMON, "Show", 0.5)
				--util:UIFrameEvent("MINIMAP", "Hide", 0)				
				util:UIEvent(UI_FRAME_COMMON, UI_ATTACK_COUNT, "SetText", tostring(0))
				--util:UIEvent(UI_FRAME_COMMON, UI_HP, "SetText", tostring( util:GetHP(util:GetMyOID()) ))
				
				if MISSION_TRY_TIME > 0 then
					util:ShowTimer(MISSION_TRY_TIME)
					SET_TIMER(game, "GAME_TIME_OVER", MISSION_TRY_TIME)
				end
				
				--util:UIFrameEvent("MINIMAP", "Hide", 0)
				
				game.attackCount = 0
				game.remainCount = -1
				state.procDelay = 0.1				
			
				state.prevPos = v3(pos.x, pos.y, pos.z)
				state.isInit = true
			end,
			
			process = function (state, game)
				local pos = util:GetMyPos()
			
				--if util:IsCrossLine( state.prevPos, pos, goalLine1, goalLine2 ) then
				--	NEXT_STATE( game, "SUCCESS" )					
				--end
				
				--util:UIEvent(UI_FRAME_COMMON, UI_HP, "SetText", tostring( util:GetHP(util:GetMyOID()) ))
				
				state.prevPos = v3(pos.x, pos.y, pos.z)
			end,
			
			leave = function (state, game) 
				CLEAR_TIMER(game, "GAME_TIME_OVER")
			end,
			
			event = function( state, game, event, strValue, intValue1, intValue2 )
				if event==EVENT_TIMER then
					if strValue=="GAME_TIME_OVER" then
						NEXT_STATE( game, "FAIL_TIME" )						
					end
				elseif event==EVENT_SCRIPT then
					if strValue=="server" then
						if intValue1==SC_EVENT_ATTACK_OBJECT then
							game.attackCount = game.attackCount + 1
							game.remainCount = intValue2
							util:UIEvent(UI_FRAME_COMMON, UI_ATTACK_COUNT, "SetText", tostring(game.attackCount))
							util:UIEvent(UI_FRAME_COMMON, UI_TARGET_IMAGE, "Scale", "-time 0.3 -initratio 3 -ratio 1.5 -align 34")				
						elseif intValue1==SC_EVENT_MISSION_RESULT then
							if intValue2==MISSIONRESULT_SUCCESS then
								NEXT_STATE( game, "SUCCESS" )
							else
								NEXT_STATE( game, "FAIL_DEAD" )
							end
						end
					end
				elseif event==EVENT_TRIGGER then
					if strValue=="goalin" then
						--print('goalin\n')
						NEXT_STATE( game, "SUCCESS" )
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
				
				util:ShowRaceString("Attack_GoodJob", DIALOG_GOOD_JOB)
				--mgr:SendEventToServer( EVENT_SCRIPT, CS_EVENT_MISSION_RESULT, MISSIONRESULT_SUCCESS )
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
		
		FAIL_TIME =
		{
			enter = function (state, game)
				util:InputBlock(true)
				util:SetCameraFocus(game.statoID, 3.5, -1.7, 2)
				util:HideTimer()
				
				local failedString 
				
				if game.remainCount < 0 then
					failedString = "Attack_FailedNothing"
				elseif game.remainCount <= failedLittleCount then
					failedString = "Attack_FailedLittle"
				else
					failedString = "Attack_Failed"
				end
				util:ShowRaceString(failedString, DIALOG_FAIL, UIFORM_INFO, '$1['..game.remainCount..']')
				mgr:SendEventToServer( EVENT_SCRIPT, CS_EVENT_MISSION_RESULT, MISSIONRESULT_FAILED )
				game.active = false
			end,
			
			event = function( state, game, event, strValue, intValue1, intValue2 )
				if event==EVENT_UI_CLOSE then
					if strValue=="MissionInfo" and intValue1==DIALOG_FAIL then						
						util:SetCameraPlayer()
					end
				end
			end,
		},	
		
		FAIL_DEAD =
		{		
			enter = function (state, game)
				util:InputBlock(true)
				util:SetCameraFocus(game.statoID, 3.5, -1.7, 2)
				util:HideTimer()
				
				--util:UIEvent(UI_FRAME_COMMON, UI_HP, "SetText", tostring(0) )
				
				local failedString = "Attack_FailedDead"
				
				util:ShowRaceString(failedString, DIALOG_FAIL, UIFORM_INFO, '$1['..game.remainCount..']')
				
				mgr:SendEventToServer( EVENT_SCRIPT, CS_EVENT_MISSION_RESULT, MISSIONRESULT_FAILED )
				game.active = false
			end,
			
			event = function( state, game, event, strValue, intValue1, intValue2 )
				if event==EVENT_UI_CLOSE then
					if strValue=="MissionInfo" and intValue1==DIALOG_FAIL then						
						util:SetCameraPlayer()
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
	NEXT_STATE( g_Game, "WAIT" )
	
	print('--- client Init OK\n')
end

-- process때마다 호출
function OnProcess( deltaTime )

	if g_Game.active then
		PROCESS_GAME( g_Game, deltaTime )		
	end
end

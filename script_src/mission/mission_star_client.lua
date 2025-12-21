require('AIState')
require('AIHelper')
require('AIDefault')
require('MissionTypes')
require('GameHelper')
require('UITypes')
require('EffectTypes')

local DIALOG_ASK_JUMP		= 1
local DIALOG_JUMP_FAIL	= 2
local DIALOG_GOOD_JOB		= 3

g_Game = CREATE_GAME()

local UI_FRAME_COMMON	= "MISSION_COMMON"
local UI_STAR_IMAGE		= "STAR_IMAGE"
local UI_STAR_COUNT		= "STAR_COUNT"

local UI_FRAME_MINIMAP	= "MISSION_MINIMAP"
local UI_MINIMAP_BG		= "MISSION_MINIMAP_BG"
local UI_MINIMAP_RIDER	= "MISSION_MINIMAP_RIDER"
local UI_MINIMAP_STATO	= "MISSION_MINIMAP_STATO"
local UI_MINIMAP_END	= "MISSION_MINIMAP_END"

local minPosY = -100
local maxPosY = 100
local resetDist = 150

function CreateGameState()
	local stateList = 
	{	
		WAIT =
		{
			enter = function (state, game) 
				util:InputBlock(true)
				util:UICreateFrame(UI_FRAME_COMMON, ALIGN_RIGHT_TOP, 0, 0)
				util:UICreateFrame(UI_FRAME_MINIMAP, ALIGN_RIGHT_CENTER, 50, 0)
				
				util:UICreateImageFont(UI_FRAME_COMMON, UI_STAR_COUNT, "font54[39_49]_s", -150, 200)
				util:UICreateOverlay(UI_FRAME_COMMON, UI_STAR_IMAGE, "icon_big_carrot", ALIGN_CENTER, -200, 200)
				
				util:UICreateOverlay(UI_FRAME_MINIMAP, UI_MINIMAP_BG, "mission_minimap", ALIGN_LEFT_TOP)
				util:UICreateOverlay(UI_FRAME_MINIMAP, UI_MINIMAP_END, "icon_deadline", ALIGN_LEFT_TOP, 0, maxPosY)
				util:UICreateOverlay(UI_FRAME_MINIMAP, UI_MINIMAP_STATO, "icon_rabbit", ALIGN_LEFT_TOP, 0, minPosY)
				util:UICreateOverlay(UI_FRAME_MINIMAP, UI_MINIMAP_RIDER, "icon_player", ALIGN_LEFT_TOP, 0, minPosY)			
				
				
				local startMat = mgr:GetNodePos("start_point")
				util:SetMyPos( startMat.pos, startMat.at )			
				
				mgr:SendEventToServer( EVENT_WAIT, CS_EVENT_LOAD_COMPLETE )
				
				game.starCount = 0
				
				state.procDelay = 0.1
			end,			
			
			event = function( state, game, event, strValue, intValue1, intValue2 )
				if event==EVENT_SCRIPT then
					if strValue=="server" and intValue1==SC_EVENT_ADD_NPC then						
						game.statoID = intValue2
						NEXT_STATE( game, "INIT" )
					end
				end
			end,
		},
		
		INIT = 
		{	
			enter = function (state, game) 
				-- SetCameraFocus( objectID, distance, cameraHeight, targetHeight )
				util:SetCameraFocus(game.statoID, 9, -1, 5)
				util:ShowRaceString( "Star_StartComment", DIALOG_ASK_JUMP )
				
				state.procDelay = 0.1
			end,			
			
			event = function( state, game, event, strValue, intValue1, intValue2 )
				if event==EVENT_UI_CLOSE then
					if strValue=="MissionInfo" and intValue1==DIALOG_ASK_JUMP then
						NEXT_STATE( game, "PLAY" )
					end
				end
			end,
		},
	
		PLAY =
		{
			enter = function (state, game) 
				util:StartGame()
				
				util:UIFrameEvent(UI_FRAME_COMMON, "Show", 0.5)
				util:UIFrameEvent(UI_FRAME_MINIMAP, "Show", 0.5)
				--util:UIFrameEvent("MINIMAP", "Hide", 0)				
				util:UIEvent(UI_FRAME_COMMON, UI_STAR_COUNT, "SetText", tostring(0))
						
				util:SetCameraPlayer()
				util:InputBlock(false)
				mgr:SendEventToServer( EVENT_WAIT, CS_EVENT_MISSION_START )
									
				--util:ShowTimer(MISSION_TRY_TIME)
					
				state.procDelay = 0.1								
			end,
			
			process = function (state, game)	
				local dist = util:GetDist( util:GetMyOID(), game.statoID )
				local ratio = RANGE( 0, dist/resetDist, 1 )
				local y = math.floor(ratio * (maxPosY - minPosY))
				util:UIEvent(UI_FRAME_MINIMAP, UI_MINIMAP_RIDER, "SetOffset", "-offset 0 "..y)
				if dist > resetDist then
					local statoMat = util:GetDummyMatrix(game.statoID)
					util:ResetMyPos( statoMat, 2 )			
				end
			end,
			
			leave = function (state, game) 
				CLEAR_TIMER(game, "WAIT_END_TIME")
			end,
			
			event = function( state, game, event, strValue, intValue1, intValue2 )
				if event==EVENT_TIMER then
					if strValue=="WAIT_END_TIME" then
						NEXT_STATE( game, "END" )						
					end
				elseif event==EVENT_GET_ITEM then
					if strValue=="server" then
						--local itemType = intValue2
						game.starCount = game.starCount + 1
						util:UIEvent(UI_FRAME_COMMON, UI_STAR_COUNT, "SetText", tostring(game.starCount))
						--print('get STAR #'..game.starCount..'\n')
					end
				elseif event==EVENT_TRIGGER then
					print('TriggerEvent : '..strValue..', v1='..intValue1..', v2='..intValue2..'\n')
				elseif event==EVENT_SCRIPT then
					if strValue=="server" then
						if intValue1==SC_EVENT_MISSION_END_WAIT then
							local waitTime = intValue2
							util:SetWaitEnd(waitTime)
							SET_TIMER(game, "WAIT_END_TIME", waitTime)
						end
					end
				end
			end
		},
		
		END =
		{
			enter = function (state, game)
				util:InputBlock(false)
				util:SetCameraFocus(game.statoID, 9, -1, 5)
				
				local result = MISSIONRESULT_SUCCESS
				local stringKey
				if game.starCount > starCountPerfect then
					stringKey = "Star_EndComment_Perfect"
				elseif game.starCount > starCountGood then 
					stringKey = "Star_EndComment_Good"
				elseif game.starCount > starCountNormal then
					stringKey = "Star_EndComment_Normal"
				else
					stringKey = "Star_EndComment_Bad"
					result = MISSIONRESULT_FAILED
				end
				util:ShowRaceString( stringKey, DIALOG_GOOD_JOB, UIFORM_INFO, '$1['..game.starCount..']' )
                mgr:SendEventToServer( EVENT_RECORD, MISSIONRECORD_GAINCOUNT, game.starCount )
				mgr:SendEventToServer( EVENT_SCRIPT, CS_EVENT_MISSION_RESULT, result )
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

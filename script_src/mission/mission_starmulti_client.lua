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

local UI_FRAME_NOTICE	= "MISSION_NOTICE"
local UI_NOTICE			= "MISSION_NOTICE_FONT"

function CreateGameState()
	local stateList = 
	{	
		WAIT =
		{
			enter = function (state, game) 
				print('enter WAIT - ')
				util:InputBlock(true)
				util:UICreateFrame(UI_FRAME_COMMON, ALIGN_RIGHT_TOP, 0, 0)
				util:UICreateImageFont(UI_FRAME_COMMON, UI_STAR_COUNT, "font54[39_49]_s", -150, 200)
				util:UICreateOverlay(UI_FRAME_COMMON, UI_STAR_IMAGE, "icon_big_spur", ALIGN_CENTER, -200, 200)
				
				util:UICreateFrame(UI_FRAME_NOTICE, ALIGN_CENTER, 0, -300)				
				util:UICreateText(UI_FRAME_NOTICE, UI_NOTICE, util:GetRaceString("StarMulti_StartComment"), 30, 0xff9f2fef, FT_STYLE_OUTLINE)
				
				util:CreateAllClientItem()
				
				local startMat = mgr:GetNodePos("start_point")
				util:SetMyPos( startMat.pos, startMat.at )			
				
				mgr:SendEventToServer( EVENT_WAIT, CS_EVENT_LOAD_COMPLETE )
				
				game.starCount = 0
				
				state.procDelay = 0.1
				print('OK\n')
			end,			
			
			event = function( state, game, event, strValue, intValue1, intValue2 )
				if event==EVENT_SCRIPT then
					if strValue=="server" and intValue1==SC_EVENT_MISSION_START then						
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
				util:UIFrameEvent(UI_FRAME_NOTICE, "Show", 0.5)
				SET_TIMER(game, "HIDE_NOTICE", 5)
												
				util:UIEvent(UI_FRAME_COMMON, UI_STAR_COUNT, "SetText", tostring(0))
						
				util:SetCameraPlayer()
				util:InputBlock(false)
				mgr:SendEventToServer( EVENT_SCRIPT, CS_EVENT_MISSION_START )
									
				util:ShowTimer(MISSION_TRY_TIME)
				SET_TIMER(game, "TIME_OVER", MISSION_TRY_TIME)
					
				state.procDelay = 0.1								
			end,
			
			process = function (state, game)	
				-- SC_EVENT_MISSION_GOALIN				
			end,
			
			leave = function (state, game) 
				CLEAR_TIMER(game, "TIME_OVER")
				CLEAR_TIMER(game, "HIDE_NOTICE")				
			end,
			
			event = function( state, game, event, strValue, intValue1, intValue2 )
				if event==EVENT_TIMER then
					if strValue=="TIME_OVER" then
						NEXT_STATE( game, "END" )						
					elseif strValue=="HIDE_NOTICE" then
						util:UIFrameEvent(UI_FRAME_NOTICE, "Hide", 0.5)
					end
				elseif event==EVENT_GET_ITEM then
					if strValue=="client" then
						local itemType = intValue1
						local itemOID = intValue2
						util:GetItem(itemType, itemOID)
						game.starCount = game.starCount + 1
						util:UIEvent(UI_FRAME_COMMON, UI_STAR_COUNT, "SetText", tostring(game.starCount))
						--print('get STAR #'..game.starCount..'\n')
					end
				elseif event==EVENT_TRIGGER then
					--print('TriggerEvent : '..strValue..', v1='..intValue1..', v2='..intValue2..'\n')
				end
			end
		},
		
		END =
		{
			enter = function (state, game)
				util:InputBlock(true)
				
				local stringKey
				if game.starCount > starCountPerfect then
					stringKey = "SM_EndComment_Perfect"
				elseif game.starCount > starCountGood then 
					stringKey = "SM_EndComment_Good"
				elseif game.starCount > starCountNormal then
					stringKey = "SM_EndComment_Normal"
				else
					stringKey = "SM_EndComment_Bad"
				end
				util:ShowRaceString( stringKey, DIALOG_GOOD_JOB, UIFORM_INFO, '$1['..game.starCount..']' )
                mgr:SendEventToServer( EVENT_RECORD, MISSIONRECORD_GAINCOUNT, game.starCount )
				mgr:SendEventToServer( EVENT_SCRIPT, CS_EVENT_MISSION_RESULT, MISSIONRESULT_SUCCESS )
				game.active = false
			end,
			
			event = function( state, game, event, strValue, intValue1, intValue2 )
				if event==EVENT_UI_CLOSE then
					if strValue=="MissionInfo" and intValue1==DIALOG_GOOD_JOB then
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

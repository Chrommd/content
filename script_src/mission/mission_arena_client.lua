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
local UI_RED_SCORE		= "RED_SCORE"
local UI_BLUE_SCORE		= "BLUE_SCORE"

g_Game = CREATE_GAME()

function CreateGameState()
	local stateList = 
	{	
		WAIT = g_DefaultClientGameState.CreateWaitStartState( "INIT" ),
		
		INIT = 
		{	
			enter = function (state, game) 
			
				util:UICreateFrame(UI_FRAME_COMMON, ALIGN_CENTER_TOP, 0, 0)
				util:UICreateImageFont(UI_FRAME_COMMON, UI_RED_SCORE, "font36[29_38]_s", 150, 40)
				util:UICreateImageFont(UI_FRAME_COMMON, UI_BLUE_SCORE, "font36[29_38]_heal", -150, 40)
												
				util:InputBlock(true)
				
				NEXT_STATE( game, "PLAY" )
				
				game.redScore = 0
				game.blueScore = 0
				state.procDelay = 0.1
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
				
				util:ShowTimer(MISSION_TRY_TIME, util:GetScreenWidth()*0.5-100, -50)
				SET_TIMER(game, "TIME_OVER", MISSION_TRY_TIME)
				
				util:UIEvent(UI_FRAME_COMMON, UI_RED_SCORE, "SetText", tostring(0))
				util:UIEvent(UI_FRAME_COMMON, UI_BLUE_SCORE, "SetText", tostring(0))
				
				
				local pos = util:GetMyPos()
				
				util:InputBlock(false)
				--util:SetCameraPlayer()
				util:SendStartingRate(STARTING_PERFECT)
				
				util:UIFrameEvent(UI_FRAME_COMMON, "Show", 0.5)
				--util:UIFrameEvent("MINIMAP", "Hide", 0)				
				
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
				CLEAR_TIMER(game, "TIME_OVER")			
			end,
			
			event = function( state, game, event, strValue, intValue1, intValue2 )
				if event==EVENT_TIMER then
					if strValue=="TIME_OVER" then
						NEXT_STATE( game, "END" )						
					end
				elseif event==EVENT_SCRIPT then
					if strValue=="server" then
						if intValue1==SC_EVENT_KILL_COUNT then
							local killCount = intValue2
						elseif intValue1==SC_EVENT_DEAD_COUNT then
							local deadCount = intValue2
						elseif intValue1==SC_EVENT_RESURRECT then
							-- my resurrection?
							if util:GetMyOID()==intValue2 then
								util:ResetMyPos( util:GetMyStartPosition(), 0 )
							end
						elseif intValue1==SC_EVENT_MISSION_RESULT then
							game.result = intValue2
							NEXT_STATE( game, "END" )	
						elseif intValue1==SC_EVENT_SCORE_RED then
							game.redScore = intValue2
							util:UIEvent(UI_FRAME_COMMON, UI_RED_SCORE, "SetText", tostring(game.redScore))
						elseif intValue1==SC_EVENT_SCORE_BLUE then
							game.blueScore = intValue2
							util:UIEvent(UI_FRAME_COMMON, UI_BLUE_SCORE, "SetText", tostring(game.blueScore))
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
		
		END =
		{
			enter = function (state, game)
				util:InputBlock(true)
				--util:HideTimer()
		
				mgr:SendEventToServer( EVENT_WAIT, CS_EVENT_MISSION_RESULT, MISSIONRESULT_SUCCESS )
				game.active = false
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

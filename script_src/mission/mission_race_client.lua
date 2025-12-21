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


g_Game = CREATE_GAME()

function CreateGameState()
	local stateList = 
	{	
		WAIT = g_DefaultClientGameState.CreateWaitStartState( "INIT" ),
		
		INIT = 
		{	
			enter = function (state, game) 
			
				util:UICreateFrame(UI_FRAME_COMMON, ALIGN_RIGHT_TOP, 0, 0)
				
				util:InputBlock(true)
				
				NEXT_STATE( game, "PLAY" )
				
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
			end,
			
			event = function( state, game, event, strValue, intValue1, intValue2 )
				if event==EVENT_TIMER then
					--
				elseif event==EVENT_SCRIPT then
					if strValue=="server" then
						if intValue1==SC_EVENT_MISSION_RESULT then
							if intValue2==1 then
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
				util:InputBlock(true)
				--util:HideTimer()
				
				--util:ShowRaceString("Attack_GoodJob", DIALOG_GOOD_JOB)
				--mgr:SendEventToServer( EVENT_SCRIPT, CS_EVENT_MISSION_RESULT, 1 )
				game.active = false
			end,			
		},		
		
		FAIL_TIME =
		{
			enter = function (state, game)
				util:InputBlock(true)
				--util:HideTimer()
				
				mgr:SendEventToServer( EVENT_SCRIPT, CS_EVENT_MISSION_RESULT, MISSIONRESULT_FAILED )
				game.active = false
			end,		
		},	
		
		FAIL_DEAD =
		{		
			enter = function (state, game)
				util:InputBlock(true)
				--util:HideTimer()
				
				--util:UIEvent(UI_FRAME_COMMON, UI_HP, "SetText", tostring(0) )
				
				mgr:SendEventToServer( EVENT_SCRIPT, CS_EVENT_MISSION_RESULT, MISSIONRESULT_FAILED )
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

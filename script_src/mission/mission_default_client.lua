require('AIState')
require('AIHelper')
require('AIDefault')
require('MissionTypes')
require('GameHelper')
require('UITypes')
require('EffectTypes')

g_Game = CREATE_GAME()

function CreateGameState()
	local stateList = 
	{	
		WAIT = g_DefaultClientGameState.CreateWaitStartState( "PLAY" ),
		
		PLAY = 
		{	
			enter = function (state, game) 
				util:StartGame()
				state.procDelay = 0.1
			end,			
			
			event = function( state, game, event, strValue, intValue1, intValue2 )
				if event==EVENT_TIMER then
					if strValue=="WAIT_END_TIME" then
						NEXT_STATE( game, "END" )						
					end
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

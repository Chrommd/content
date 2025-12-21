require('AIState')
require('AIHelper')
require('AIDefault')
require('MissionTypes')
require('GameHelper')

g_Game = CREATE_GAME()

function CreateGameState()
	local stateList = 
	{	
		WAIT =
		{
			event = function( state, game, event, strValue, intValue1, intValue2 )
			
				if event==EVENT_WAIT then
					if strValue=="client" and intValue1==CS_EVENT_LOAD_COMPLETE then						
						NEXT_STATE( game, "INIT" )
					end
				end
			end,
		},
			
		INIT = 
		{	
			enter = function (state, game) 
				-- Create Stato
				mgr:SendEventToClient( EVENT_SCRIPT, SC_EVENT_MISSION_START )
				
				state.procDelay = 0.1
			end,			
			
			event = function( state, game, event, strValue, intValue1, intValue2 )
			
				if event==EVENT_SCRIPT then
					if strValue=="client" and intValue1==CS_EVENT_MISSION_START then						
						NEXT_STATE( game, "PLAY" )
					end
				end
			end,
		},
		
		PLAY = 
		{	
			enter = function (state, game) 
				state.procDelay = 0.1
			end,			
			
			event = function( state, game, event, strValue, intValue1, intValue2 )
				if event==EVENT_SCRIPT then
					if strValue=="client" then
						if intValue1==CS_EVENT_MISSION_RESULT then
							NEXT_STATE( game, "END" )
						end
					end
				end
			end
		},		
		
		END = 
		{
			enter = function (state, game) 
				mgr:EndGame(MISSIONRESULT_SUCCESS)
				
				state.procDelay = 1
			end,
		},
	}

	return stateList
end
		
-- 초기화
function OnInit()	
	g_Game.state = CreateGameState()
	NEXT_STATE( g_Game, "WAIT" )
	
	print('--- server Init OK\n')
end

-- process때마다 호출
function OnProcess( deltaTime )

	if g_Game.active then
		PROCESS_GAME( g_Game, deltaTime )
	end
end


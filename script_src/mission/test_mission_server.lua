require('AIState')
require('AIHelper')
require('AIDefault')
require('MissionTypes')
require('GameHelper')

g_Game = CREATE_GAME()

function CreateGameState()
	local stateList = 
	{	
		INIT = 
		{	
			enter = function (state, game) 
				state.procDelay = 0.1
			end,			
			
			event = function( state, game, event, strValue, intValue1, intValue2 )
			
				if event==EVENT_SCRIPT then
					if strValue=="client" and intValue1==CS_EVENT_MISSION_RESULT then						
						--print('CS_EVENT_JUMP_SUCCESS received\n')
						mgr:EndGame(intValue2)						
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
	
	print('--- server Init OK\n')
end

-- process때마다 호출
function OnProcess( deltaTime )

	if g_Game.active then
		PROCESS_GAME( g_Game, deltaTime )
	end
end


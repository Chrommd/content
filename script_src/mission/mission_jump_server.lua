require('AIState')
require('AIHelper')
require('AIDefault')
require('MissionTypes')
require('GameHelper')

g_Game = CREATE_GAME()

function CreateGameState()
	local stateList = 
	{	
		--WAIT = g_DefaultServerGameState.CreateWaitLoadingState("INIT"),
		
		INIT = 
		{	
			enter = function (state, game) 				
				mgr:SendEventToClient( EVENT_SCRIPT, SC_EVENT_MISSION_START )
				state.procDelay = 0.1
			end,			
			
			event = function( state, game, event, strValue, intValue1, intValue2 )
			
				if event==EVENT_SCRIPT then
					if strValue=="client" and intValue1==CS_EVENT_MISSION_RESULT then						
						--print('CS_EVENT_JUMP_SUCCESS received\n')
						if intValue2 >= 0 then
							local lapTime = intValue2
							local timeLimit = MISSION_TRY_TIME * 1000
							mgr:SetLapTime(lapTime, timeLimit)
							mgr:EndGame(MISSIONRESULT_SUCCESS)
						else
							mgr:EndGame(MISSIONRESULT_FAILED)
						end
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


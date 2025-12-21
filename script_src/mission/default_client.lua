require('AIState')
require('AIHelper')
require('AIDefault')
require('MissionTypes')
require('GameHelper')
require('UITypes')
require('EffectTypes')
require('NetTypes')

g_defaultClient = CREATE_GAME()

function CreateGameState()
	local stateList = 
	{	
		INIT = 
		{	
			enter = function (state, game) 
				state.procDelay = 0.1
			end,			
			
			event = function( state, game, event, strValue, intValue1, intValue2 )
			end,
		},		
	}

	return stateList
end

-- 초기화
function OnInit()
	
	g_defaultClient.state = CreateGameState()
	g_defaultClient.defaultEvent = DefaultEvent
	NEXT_STATE( g_defaultClient, "INIT" )
	
	print('--- client Init OK\n')
end

-- process때마다 호출
function OnProcess( deltaTime )

	if g_defaultClient.active then
		PROCESS_GAME( g_defaultClient, deltaTime )		
	end
end

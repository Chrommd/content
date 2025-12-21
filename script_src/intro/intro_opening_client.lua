require('SceneHelper')
require('SceneDefault')

g_Opening			= CREATE_GAME()
g_ValueEvaluator	= CreateValueEvaluator(g_Opening)

-- 초기화
function OnInit()
	
	g_Opening.state = CREATE_EVENT_SCENARIO( OPENING )
	g_Opening.defaultEvent = DefaultEvent
	NEXT_STATE( g_Opening, "SCENE1" )
	
	print('--- client Init OK\n')
end

-- process때마다 호출
function OnProcess( deltaTime )

	if g_Opening.active then
		PROCESS_GAME( g_Opening, deltaTime )		
	end
end


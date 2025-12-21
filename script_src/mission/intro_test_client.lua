require('AIState')
require('AIHelper')
require('AIDefault')
require('MissionTypes')
require('GameHelper')
require('UITypes')
require('EffectTypes')
require('NetTypes')

g_IntroFirst = CREATE_GAME()

statoOID = 29500

function CreateGameState()
	local stateList = 
	{	
		INIT = 
		{	
			enter = function (state, game) 
			
				-- client only mob
				local initPos
				local player = mgr:GetPlayerByIndex(0)
				if player then
					initPos = player:GetPos()
					initPos = GetFrontPos(initPos, player:GetDir(), 10)		-- 앞쪽											
				else
					initPos = util:GetMyPos()
				end	
				
				for i=1,statoCount do
					local stato = mgr:CreateMob( "stato_intro_test", "stato_intro_test", initPos, MONSTER_TYPE_FRIENDLY, statoOID+i )
					game.statoID = stato:GetObjID()
				end
				--stato:LookAt( v3(statoMat.pos.x + statoMat.at.x, statoMat.pos.y + statoMat.at.y, statoMat.pos.z + statoMat.at.z) )				
				
				state.procDelay = 0.1
			end,			
			
			event = function( state, game, event, strValue, intValue1, intValue2 )
				if event==EVENT_UI_CLOSE then
				end
			end,
		},		
	}

	return stateList
end

-- 초기화
function OnInit()
	
	g_IntroFirst.state = CreateGameState()
	NEXT_STATE( g_IntroFirst, "INIT" )
	
	print('--- client Init OK\n')
end

-- process때마다 호출
function OnProcess( deltaTime )

	if g_IntroFirst.active then
		PROCESS_GAME( g_IntroFirst, deltaTime )		
	end
end

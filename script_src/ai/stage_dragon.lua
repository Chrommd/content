require('AIState')
require('AIHelper')
require('AIDefault')
require('GameHelper')

dragonStartPos	= v3(-564, 55, 66)
DRAGON_TRIGGER	= 999

g_Game = CREATE_GAME()

function CreateGameState()
	local stateList = 
	{	
		PLAY =
		{
		    enter = function (state, game)
				--print('dragon create\n')
				local dragon = mgr:CreateMob( "dragon_patrol", "dragon_patrol", dragonStartPos )	
				game.dragonID = dragon:GetObjID()
				--print('dragon create OK\n')
				
				-- 강제 AI 가동
				local info = GET_MOB_INFO(dragon)
				info.active = true
			end,
	
			event = function( state, game, event, strValue, intValue1, intValue2 )
				print('event = '..event..', v1='..intValue1..', v2='..intValue2..'\n')
				if event==EVENT_TRIGGER then
					if strValue=="client" and intValue1==DRAGON_TRIGGER then		
						local dragon = mgr:GetMob(game.dragonID)
						if dragon ~= nil then
							local info = GET_MOB_INFO(dragon)
							info.trace_id = intValue2				
							NEXT_MOB_STATE( game.dragonID, STATE_ATTACK )
						end
					end
				end
			end,
		}
	}
	
	return stateList
end

-- 초기화
function OnInit()
	g_Game.state = CreateGameState()
	NEXT_STATE( g_Game, "PLAY" )	
	
	print('--server Init OK\n')
end

-- process때마다 호출
function OnProcess( deltaTime )

	if g_Game.active then
		PROCESS_GAME( g_Game, deltaTime )
	end
end
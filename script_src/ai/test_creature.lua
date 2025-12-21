require('AIState')
require('AIHelper')
require('AIDefault')
require('MissionTypes')
require('GameHelper')

g_Game = CREATE_GAME()

-- 초기화
function CreateGameState()
	local stateList = 
	{	
		WAIT = g_DefaultServerGameState.CreateWaitLoadingState("PLAY"),		
		
		PLAY =
		{
			enter = function (state, game) 				
				
				--mgr:CreateMob( "basilisk", "basilisk", v3(-1520,34,4270) )	
				
				require('ar_test_mon01')
				ARRANGE_ALL_MOB(mgr, g_Arrange)	
				
				-- 호위 대상	
				local wagon1 = mgr:CreateMob( "wagon", "wagon", v3(-1513,34,4265), MONSTER_TYPE_FRIENDLY )	
				local wagon2 = mgr:CreateMob( "wagon", "wagon", v3(-1522,34,4276), MONSTER_TYPE_FRIENDLY )	
				local wagon3 = mgr:CreateMob( "wagon", "wagon", v3(-1529,34,4299), MONSTER_TYPE_FRIENDLY )	
				
				if wagon1 ~= nil then table.insert( g_Game.npclist, wagon1:GetObjID() ) end
				if wagon2 ~= nil then table.insert( g_Game.npclist, wagon2:GetObjID() ) end
				if wagon3 ~= nil then table.insert( g_Game.npclist, wagon3:GetObjID() ) end
				
				mgr:SendEventToClient( EVENT_SCRIPT, SC_EVENT_MISSION_START )
			end,
			
			process = function (state, game)
			
				-- 다 죽으면 끝나는 조건 추가
				if table.getn(game.npclist) > 0 then
					if game.npclist ~= nil then
						if IS_ALL_DEAD(game.npclist) then
							NEXT_STATE( game, "WAIT_END" )
						end
					end
				end				
			end,		
			
			event = function( state, game, event, strValue, intValue1, intValue2 )
				if event==EVENT_SCRIPT then
					if strValue=="server" then
						if intValue1==SC_EVENT_MISSION_END_WAIT then
							NEXT_STATE( game, "WAIT_END" )
						end
					end
				end
			end
		},
		
		WAIT_END = 
		{
			enter = function (state, game) 
				SET_TIMER(game, "WAIT_TIME_OVER", END_WAIT_TIME)
				--print(END_WAIT_TIME..' sec to end\n')
				mgr:SendEventToClient( EVENT_SCRIPT, SC_EVENT_MISSION_END_WAIT, END_WAIT_TIME )
			end,
			
			leave = function (state, game) 
				CLEAR_TIMER(game, "WAIT_TIME_OVER")
			end,
			
			event = function( state, game, event, strValue, intValue1, intValue2 )
				if event==EVENT_TIMER then
					if strValue=="WAIT_TIME_OVER" then	
						-- TODO:client에서 안 보내는 경우 알아서 처리해야한다									
					end
				elseif event==EVENT_SCRIPT then
					if strValue=="client" and intValue1==CS_EVENT_MISSION_RESULT then						
						--print('CS_EVENT_JUMP_SUCCESS received\n')
						mgr:EndGame(intValue2)
						NEXT_STATE( game, "END" )
					end
				end
			end			
		},
		
		END = 
		{
			enter = function (state, game) 
				state.procDelay = 1
			end,			
		},
	}
		
	print('Init OK\n')	
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


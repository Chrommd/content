require('AIState')
require('AIHelper')
require('AIDefault')
require('MissionTypes')
require('GameHelper')

g_Game = CREATE_GAME()

--useTarget = true

function CreateGameState()
	local stateList = 
	{	
		WAIT = g_DefaultServerGameState.CreateWaitLoadingState("INIT"),
		
		INIT =
		{
			enter = function (state, game) 				
				-- 표적				
				for i,pos in pairs(targetPosList) do
					--v3(-230.45, -48.82, 21.49),
					local newPos = v3(pos.x+RAND(-40,40)*0.1, pos.y-50, pos.z+RAND(-40,40)*0.1+220)
					
					if useTarget then					
						local mob = mgr:CreateMob( "target", "target", newPos )
					else
						local mob = mgr:CreateMob( "hyena", "hyena2", newPos )
						
						newPos = v3(pos.x+RAND(-120,120)*0.1, pos.y-50, pos.z+RAND(-120,120)*0.1+220)
						local mob2 = mgr:CreateMob( "hyena", "hyena2", newPos )
					end					
					
					
					--newPos = v3(pos.x+RAND(-120,120)*0.1, pos.y-50, pos.z+RAND(-140,140)*0.1+220)
					--local mob3 = mgr:CreateMob( "target", "target", newPos )
					
					--newPos = v3(pos.x+RAND(-240,240)*0.1, pos.y-50, pos.z+RAND(-240,240)*0.1+220)
					--local mob4 = mgr:CreateMob( "target", "target", newPos )
				end
				
				game.maxAttackCount = table.getn(targetPosList) * 2
				
				print('game.maxAttackCount = '..game.maxAttackCount..'\n')
				
				-- player setting
				local maxPlayerIndex = mgr:GetPlayerCount() - 1
				print('maxPlayerIndex = '..maxPlayerIndex..'\n')
				for i=0,maxPlayerIndex do
					local player = mgr:GetPlayerByIndex(i)
					
					if player ~= nil then
						player:SetHPMax(playerHPMax)
						player:SetMPMax(playerMPMax)						
						print('['..i..'] sethp\n')
					end
				end
				
				mgr:SendEventToClient( EVENT_SCRIPT, SC_EVENT_MISSION_START )
				state.procDelay = 0.1
				game.attackCount = 0
				game.active = false
			end,	
		
			event = function( state, game, event, strValue, intValue1, intValue2 )
							
				if event==EVENT_WAIT then
					if intValue1==CS_EVENT_MISSION_START then
						game.active = true				
						NEXT_STATE( game, "PLAY" )
					end
				end
			end
		},
			
		PLAY = 
		{	
			enter = function (state, game) 								
				state.procDelay = 0.1
			end,	
					
			process = function (state, game) 				
				local maxPlayerIndex = mgr:GetPlayerCount() - 1
				local deadCount = 0
				for i=0,maxPlayerIndex do
					local player = mgr:GetPlayerByIndex(i)					
					if player ~= nil then
						if player:GetHP()<=0 then
							deadCount = deadCount + 1							
						end
					end
				end
				
				-- 다 죽었으면
				if deadCount==mgr:GetPlayerCount() then
					mgr:EndGame(MISSIONRESULT_FAILED)
					mgr:SendEventToClient( EVENT_SCRIPT, SC_EVENT_MISSION_RESULT, MISSIONRESULT_FAILED )
					NEXT_STATE( game, "END" )
				end
			end,		
			
			event = function( state, game, event, strValue, intValue1, intValue2 )
			
				if event==EVENT_SCRIPT then
					if strValue=="server" and intValue1==SS_EVENT_ATTACK_OBJECT then
						
						game.attackCount = game.attackCount + 1
						
						local remainCount = game.maxAttackCount - game.attackCount
						mgr:SendEventToClient( EVENT_SCRIPT, SC_EVENT_ATTACK_OBJECT, remainCount )
						
						local mobID = intValue2
						local mob = mgr:GetMob(mobID)
						if mob ~= nil then
							mgr:SpawnItem( mob:GetPos(), ITEM_CARROT, mob:GetObjID(), ITEM_SPAWN_STYLE_POPUP )
						end
						
						--print('Attack Object: '..game.attackCount..'\n')
						if game.attackCount >= game.maxAttackCount then
							--print('END OK\n')
							mgr:EndGame(MISSIONRESULT_SUCCESS)
							mgr:SendEventToClient( EVENT_SCRIPT, SC_EVENT_MISSION_RESULT, MISSIONRESULT_SUCCESS )
							NEXT_STATE( game, "END" )
						end
					elseif strValue=="client" and intValue1==CS_EVENT_MISSION_RESULT then						
						--print('CS_EVENT_JUMP_SUCCESS received\n')
						mgr:EndGame(intValue2)						
					end
				end
			end,
		},
		
		END =
		{
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


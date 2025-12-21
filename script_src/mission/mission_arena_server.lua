require('AIState')
require('AIHelper')
require('AIDefault')
require('MissionTypes')
require('GameHelper')

g_Game = CREATE_GAME()

function CreateGameState()
	local stateList = 
	{	
		WAIT = g_DefaultServerGameState.CreateWaitLoadingState("INIT"),
		
		INIT =
		{
			enter = function (state, game) 				
			
				local matRed = mgr:GetNodePos(redTeamBasePosName)
				local matBlue = mgr:GetNodePos(blueTeamBasePosName)
				
				local redBase = mgr:CreateMob( "teambase_red", "teambase", matRed.pos )	
				local blueBase = mgr:CreateMob( "teambase_blue", "teambase", matBlue.pos )					
				
				--local dragon = mgr:CreateMob( "dragon", "dragon", v3(265.13, 15, 260.16) )
				
				--local dragon = mgr:CreateMob( "basilisk", "basilisk", v3(17.69, 28.77, 169.99) )
				
				-- 표적				
				for i,mobInfo in pairs(targetPosList) do
					
					local pos	= mobInfo[1]
					local range = mobInfo[2]
					
					local newPos = v3(pos.x+RAND(-40,40)*0.1, pos.y, pos.z+RAND(-40,40)*0.1)
					local mob = mgr:CreateMob( "hyena", "hyena2", newPos )
					
					local info = GET_MOB_INFO(mob)
					if info ~= nil then
						info.aiRange = range
					end
					
				end
				
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
				game.blueScore = 0
				game.redScore = 0
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
			end,		
			
			event = function( state, game, event, strValue, intValue1, intValue2 )
			
				if event==EVENT_SCRIPT then
					if strValue=="server" and intValue1==SS_EVENT_ATTACK_OBJECT then
						
						local mobID = intValue2
						local mob = mgr:GetMob(mobID)
						if mob ~= nil then
							mgr:SpawnItem( mob:GetPos(), ITEM_CARROT, mob:GetObjID(), ITEM_SPAWN_STYLE_POPUP )
						end	
					end					
				elseif event==EVENT_WAIT then		
					if strValue=="client" and intValue1==CS_EVENT_MISSION_RESULT then
						
						local result
						if game.blueScore > game.redScore then
							result = MISSIONRESULT_BLUEWIN
						elseif game.blueScore < game.redScore then
							result = MISSIONRESULT_REDWIN
						else
							result = MISSIONRESULT_DRAW
						end
						mgr:EndGame(result)
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
	
	g_Game.killCount = {}
	g_Game.deadCount = {}
	
	NEXT_STATE( g_Game, "WAIT" )
	
	print('--- server Init OK\n')
end

function AddKillCount(attackerID)
	if g_Game.killCount[attackerID] == nil then
		g_Game.killCount[attackerID] = 0
	end
	
	g_Game.killCount[attackerID] = g_Game.killCount[attackerID] + 1
	
	mgr:SendEventToClient( EVENT_SCRIPT, SC_EVENT_KILL_COUNT, g_Game.killCount[attackerID] )
end

function AddDeadCount(deadID)
	if g_Game.deadCount[deadID] == nil then
		g_Game.deadCount[deadID] = 0
	end
	
	g_Game.deadCount[deadID] = g_Game.deadCount[deadID] + 1
	
	mgr:SendEventToClient( EVENT_SCRIPT, SC_EVENT_DEAD_COUNT, g_Game.deadCount[deadID] )
end

function OnPlayerDie(player, attackerID, attackType)
	if not player:HasStatus(PLAYERSTATUS_FAINT) then
		local faintDelaySec = 6
		player:AddStatus(PLAYERSTATUS_FAINT, faintDelaySec);
		
		AddKillCount(attackerID)
		AddDeadCount(player:GetObjID())		
		
		if g_Game.deadPlayerList ~= nil then
			table.insert(g_Game.deadPlayerList, player:GetObjID())
			
			if player:GetTeam()==TEAM_A then
				g_Game.blueScore = g_Game.blueScore + 1
				mgr:SendEventToClient( EVENT_SCRIPT, SC_EVENT_SCORE_BLUE, g_Game.blueScore )
			elseif player:GetTeam()==TEAM_B then
				g_Game.redScore = g_Game.redScore + 1
				mgr:SendEventToClient( EVENT_SCRIPT, SC_EVENT_SCORE_RED, g_Game.redScore )
			end
		
			--if table.getn(g_Game.deadPlayerList) >= mgr:GetPlayerCount() then
			--	mgr:SendEventToClient( EVENT_SCRIPT, SC_EVENT_MISSION_DEAD_WAIT, ALL_DEAD_WAIT_TIME )
			--	SET_TIMER(game, "ALL_DEAD", ALL_DEAD_WAIT_TIME)
			--end
		end
	end
end

function OnPlayerResurrect(player)
	mgr:SendEventToClient( EVENT_SCRIPT, SC_EVENT_RESURRECT, player:GetObjID() )
	player:SetHPMax(-1, HP_HEAL, playerHPMax);
	
	player:AddStatus(PLAYERSTATUS_INVINCIBLE, INVINCIBLE_DELAY_SEC);
end

-- process때마다 호출
function OnProcess( deltaTime )

	if g_Game.active then
		PROCESS_GAME( g_Game, deltaTime )
	end
end


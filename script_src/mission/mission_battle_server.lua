require('AIState')
require('AIHelper')
require('AIDefault')
require('MissionTypes')
require('GameHelper')
require('EffectTypes')

g_Game = CREATE_GAME()

rewardCarrotCount = 30

function ConvertNodePos(nodeName)
	if nodeName ~= nil then
		local mat = mgr:GetNodePos(nodeName)
		--print('[Node] '..nodeName..'.pos('..mat.pos.x..', '..mat.pos.y..', '..mat.pos.z..')\n')
		if mat.pos.x==0 and mat.pos.y==0 and mat.pos.z==0 then
			alert('[Error] '..nodeName..'.pos(0,0,0)\n')
		end
		
		return mat.pos, mat.at
	else
		alert('[Error] '..nodeName..' is nil\n')
	end		
end
	
function ConvertAllNode()
	bossStartPos, bossStartDir	= ConvertNodePos(bossStartPosName)
end

function SelectItem(itemTable)

	if itemTable ~= nil then
		
		if itemTable.maxValue==nil then
			local maxValue = 0
			for k,v in pairs(itemTable) do
				maxValue = maxValue + v[1]
			end
			itemTable.maxValue = maxValue
		end
		
		if itemTable.maxValue > 0 then
			local dice = RAND(1,itemTable.maxValue)
			
			local accum = 0
			for k,v in pairs(itemTable) do
				accum = accum + v[1]
				
				if dice <= accum then
					return v[2]
				end
			end
		end
	end
	
	return nil
end

function CreateGameState()
	local stateList = 
	{	
		WAIT =
		{
			event = function( state, game, event, strValue, intValue1, intValue2 )
			
				if event==EVENT_WAIT then
					if strValue=="client" and intValue1==CS_EVENT_LOAD_COMPLETE then
						SET_GAME_STATE( game, "INIT" )
					end
				end
			end,
		},		
			
		INIT = 
		{	
			enter = function (state, game) 			
			
				ConvertAllNode()
				
				if not NO_MONSTER then
					mgr:CreateAllPreloadedMob()
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
				print('player init ok\n')
				
				-- Create boss
				local boss = mgr:CreateMob( "dragon_battle", "dragon_battle", bossStartPos )	
				game.bossID = boss:GetObjID()
				
				--mgr:CreateMob( "hyena", "hyena2", sealingPos1 )	
				--mgr:CreateMob( "eagle", "eagle", v3(sealingPos1.x,sealingPos1.y+10,sealingPos1.z) )	
				
				local path = {}
				if mgr:SetMobPath(boss, bossPathName, "patrol_path") then
					local info = GET_MOB_INFO(boss)
					if info ~= nil and info.patrol_path ~= nil then
						local pos = info.patrol_path[10]
						local pos2 = info.patrol_path[11]
						print('[boss_path] #count='..table.getn(info.patrol_path)..', startPos( '..pos.x..', '..pos.y..', '..pos.z..' )\n')						
						
						if EFFECT_TEST then
							boss:ResetPos(pos.x, pos.y+1.5, pos.z)
						else
							boss:ResetPos(pos.x, pos.y, pos.z)
						end
						
						if pos2 then
							boss:LookAt(pos2)
						end
						
						bossStartPos = pos
					end
				else
					print('no patrol_path\n')
				end

				FORCE_ACTIVE_MOB(boss)				
				
				mgr:SendEventToClient( EVENT_SCRIPT, SC_EVENT_ADD_BOSS, game.bossID )
				
				state.procDelay = 0.1
			end,			
			
			event = function( state, game, event, strValue, intValue1, intValue2 )
			
				if event==EVENT_WAIT then
					if strValue=="client" and intValue1==CS_EVENT_OPENING_COMPLETE then
						mgr:SendEventToClient( EVENT_WAIT, SC_EVENT_OPENING_COMPLETE )
						
						if SKIP_OPENING then
							mgr:SendEventToClient( EVENT_WAIT, SC_EVENT_MISSION_START )
							SET_GAME_STATE( game, "PLAY" )
						else
							SET_GAME_STATE( game, "SERVER_OPENING" )
						end
					end
				end
			end,
		},
		
		SERVER_OPENING =
		{	
			enter = function (state, game) 
				mgr:SendEventToClient( EVENT_WAIT, SC_EVENT_MISSION_START )
				
				NEXT_MOB_STATE( game.bossID, STATE_EVENT1 )								
			end,			
			
			event = function( state, game, event, strValue, intValue1, intValue2 )				
				if event==EVENT_SCRIPT then
					if strValue=="server" then
						if intValue1==SS_EVENT_ARRIVED then
							SET_GAME_STATE( game, "PLAY" )
						end
					end
				end
			end,
		},
		
		PLAY = 
		{	
			enter = function (state, game) 
			
				NEXT_MOB_STATE( game.bossID, STATE_PATROL )				
				
				state.procDelay = 0.1
				
				mgr:SendEventToClient( EVENT_SCRIPT, SC_EVENT_MISSION_PLAY_TIMER, MISSION_TRY_TIME )
				SET_TIMER(game, "TIME_OVER", MISSION_TRY_TIME)
				--print('set Play TIMER = '..MISSION_TRY_TIME..'\n')
				
				if EFFECT_TEST then
					print('test item\n')
					local mobID = game.bossID
					local boss = mgr:GetMob(mobID)
					local pos = boss:GetPos()
					pos.x = pos.x + 4
					pos.y = pos.y + 1
					pos.z = pos.z + 4
					if boss ~= nil then					
						mgr:SpawnItem( pos, ITEM_HP, mobID, ITEM_SPAWN_STYLE_NONE)
						
						pos.z = pos.z - 10
						mgr:SpawnItem( pos, ITEM_MP, mobID, ITEM_SPAWN_STYLE_NONE)
						
						pos.x = pos.x - 10
						mgr:SpawnItem( pos, ITEM_SPECIAL, mobID, ITEM_SPAWN_STYLE_NONE)
					end
				end
				
				state.spawnItems = {}
			end,		
			
			process = function(state, game)
				local boss = mgr:GetMob(game.bossID)
				
				if EFFECT_TEST then
					if boss == nil or boss:GetHP()<=0 then
						if not state.revival then
							SET_TIMER(game, "BOSS_REVIVAL", 10)
							state.revival = true
						end
					end				
				else				
					if boss == nil or boss:GetHP()<=0 then				
						KILL_ALL_MONSTER(game)					
						SET_GAME_STATE( game, "WAIT_END" )					
					end
				end
				
				-- process SpawnItem													
				if table.getn(state.spawnItems) > 0 then
					-- { info.curTime+delayTime, roadGap, itemType, mobID } )
					for k,v in pairs(state.spawnItems) do
						local time		= v[1]
						
						if game.curTime >= time then
							local roadGap	= v[2]
							local itemType	= v[3]
							local mobID		= v[4]
							mgr:SpawnItem( roadGap, itemType, mobID, ITEM_SPAWN_STYLE_ROAD, ITEM_REMOVE_TIME )
							
							table.remove(state.spawnItems, k)
						end
					end
				end
			end,	
			
			event = function( state, game, event, strValue, intValue1, intValue2 )
				if event==EVENT_TIMER then
					if strValue=="BOSS_RUNAWAY" then
						SET_GAME_STATE( game, "FAIL_RUNAWAY" )
					elseif strValue=="TIME_OVER" then
						print('TIME OVER!\n')
						--NEXT_MOB_STATE( game.bossID, STATE_ATTACK5 )
					elseif strValue=="ALL_DEAD" then
						if table.getn(game.deadPlayerList) >= mgr:GetPlayerCount() then
							game.result = MISSIONRESULT_FAILED
							mgr:SendEventToClient( EVENT_SCRIPT, SC_EVENT_MISSION_RESULT, game.result )
							mgr:EndGame(game.result)
							SET_GAME_STATE( game, "END" )						
						end
					elseif strValue=="BOSS_STOP" then
						BOSS_STOP = true
					elseif strValue=="BOSS_REVIVAL" then
						
						local boss = mgr:CreateMob( "dragon_battle", "dragon_battle", bossStartPos )	
						game.bossID = boss:GetObjID()
						
						local lookPos = GetFrontPos(bossStartPos, bossStartDir, 10);				
						boss:LookAt( lookPos )
						
						mgr:SendEventToClient( EVENT_SCRIPT, SC_EVENT_ADD_BOSS, game.bossID )
						
						state.revival = nil
					elseif strValue=="SPAWN_HP" then
						local player = mgr:GetPlayerByIndex(0)
						if player ~= nil then
							local itemType = SelectItem(hyenaItemTable) --( RAND(1,2)==1 and ITEM_HP or ITEM_SPECIAL )
							
							if itemType==ITEM_HP or itemType==ITEM_MP then
								local delayTime = 0
								for i=1,3 do
									local roadGap = v3(RAND(-10, 10), 0, ITEM_DROP_DIST+RAND(-10,15))
									table.insert( state.spawnItems, { game.curTime+delayTime, roadGap, itemType, player:GetObjID() } )
									delayTime = delayTime + RAND(2,4)*0.1
								end
							else
								mgr:SpawnItem( v3(0,0,50), itemType, player:GetObjID(), ITEM_SPAWN_STYLE_ROAD )
							end
							
						end
					end
				elseif event==EVENT_GET_ITEM then
					if strValue=="server" then
						local userID = intValue1
						local itemType = intValue2
						
						if itemType==ITEM_HP then
							--print('server-CARROT!\n')
							local player = mgr:GetPlayer(userID)
							if player ~= nil and player:IsAlive() then
								player:Heal( itemHealHP )
							end
						elseif itemType==ITEM_MP then
							--print('server-CARROT!\n')	
							-- 한명 먹으면 다 올라가게 된다.
							mgr:SendEventToClient( EVENT_SCRIPT, SC_EVENT_ACQUIRE_ITEM, itemType )
						elseif itemType==ITEM_APPLE then
							--print('server-APPLE!\n')
						else
							print('server-????!\n')
						end
					end
				elseif event==EVENT_SCRIPT then
					if strValue=="server" then
						if intValue1==SS_EVENT_MONSTER_DEAD then
							-- 몬스터 죽어서 아이템 떨어뜨리기
							local mobID = intValue2
							local itemType = SelectItem(hyenaItemTable)
							
							if itemType ~= nil then
								if itemType==ITEM_HP or itemType==ITEM_MP then
									local delayTime = 0
									for i=1,3 do
										local spawnTime = game.curTime+delayTime
										local roadGap = v3(RAND(-10, 10), 0, ITEM_DROP_DIST+RAND(-10,15))
										table.insert( state.spawnItems, { spawnTime, roadGap, itemType, mobID } )
										delayTime = delayTime + RAND(2,4)*0.1
									end
								else
									local roadGap = v3(0, 0, ITEM_DROP_DIST)
									mgr:SpawnItem( roadGap, itemType, mobID, ITEM_SPAWN_STYLE_ROAD, ITEM_REMOVE_TIME )
								end
							end
						end
					elseif strValue=="client" then
						if intValue1==CS_EVENT_FIRST_PLAYER_IN then
							local firstID = intValue2
							CLEAR_TIMER(game, "BOSS_RUNAWAY")
							mgr:SendEventToClient( EVENT_SCRIPT, SC_EVENT_FIRST_PLAYER_IN, firstID )
						elseif intValue1==CS_EVENT_FIRST_PLAYER_OUT then
							local firstID = intValue2
							SET_TIMER(game, "BOSS_RUNAWAY", 11)
							mgr:SendEventToClient( EVENT_SCRIPT, SC_EVENT_FIRST_PLAYER_OUT, firstID )
						elseif intValue1==CS_EVENT_PLAYER_REFLECTION then
							local playerID = intValue2
							local player = mgr:GetPlayer(playerID)
							if player~=nil then
								local reflectionDist = 8
								local reflectionAngle = 180
								mgr:ReflectSkills(player, SKILLID_TAIL_SPLASH, reflectionDist, reflectionAngle)
							end
						elseif intValue1==CS_EVENT_MISSION_RESURRECT then
							local playerID = intValue2
							local player = mgr:GetPlayer(playerID)
							if player~=nil then
								player:RemoveStatus(PLAYERSTATUS_FAINT)
								mgr:SendEventToClient( EVENT_SCRIPT, SC_EVENT_MISSION_DEAD_WAIT_CANCEL )
								CLEAR_TIMER(game, "ALL_DEAD")
							end
						end
					end
				elseif event==EVENT_TRIGGER then
					if strValue=="client" and intValue1==999 then
						if intValue2==999 then
							KILL_ALL_MONSTER(game)
						elseif intValue2==1000 then
							SET_TIMER(game, "SPAWN_HP", 1)							
						end
					end
					
					if EFFECT_TEST then
						local mob = mgr:GetMob(game.bossID)
						if mob ~= nil then
							local player = mgr:FindNearPlayer(mob)
							if player ~= nil and player:GetHP() > 0 then				
								local pos = player:GetPos()
						
								local info = GET_MOB_INFO(mob)
								
								local skillNum = intValue1
								
								-- 7 : 정면 달려오기?
								if skillNum==7 then
									local mobPos = mob:GetPos()
									
									mob:LookAt(pos)
									mob:ResetPos( mobPos.x, mobPos.y+12, mobPos.z )
									mob:Move( pos.x, pos.y-2, pos.z )
									
									mob:LookAt(pos)
									
									PLAY_MOTION( info, mob, MOTION_GLIDE )
									USE_SKILL_POS(info, mob, "DRAGON_SLIDING", mob:GetPos())							
									
									--skillNum = 1
								end
									
								-- 1 : Breath!
								if skillNum==1 then
									
									mob:LookAt(pos)								
								
									PLAY_MOTION( info, mob, MOTION_ATTACK2 )
									local pos = player:GetPos()
									local frontPos	= GetFrontPos(pos, mob:GetDir(), 5);
									local backPos	= GetBackPos(pos, mob:GetDir(), 5);
									local leftPos	= GetLeftPos(pos, mob:GetDir(), 5);
									local rightPos	= GetRightPos(pos, mob:GetDir(), 5);
									
									USE_SKILL_POS(info, mob, "FIRE_BREATH", frontPos)
									USE_SKILL_POS(info, mob, "FIRE_BREATH", backPos)
									USE_SKILL_POS(info, mob, "FIRE_BREATH", leftPos)
									USE_SKILL_POS(info, mob, "FIRE_BREATH", rightPos)							
								-- 2 : FIRE_SMASH
								elseif skillNum==2 then
								
									mob:LookAt(pos)							
								
									PLAY_MOTION( info, mob, MOTION_ATTACK1 )
									local frontPos = GetFrontPos(mob:GetPos(), mob:GetDir(), 20);
									for i=1,12 do
										local firePos = v3( frontPos.x+RAND(-100,100)*0.1, frontPos.y-3, frontPos.z+RAND(-200,200)*0.1 )									
										USE_SKILL_POS(info, mob, "FIRE_SMASH", firePos)
									end
								-- 3,4 : TAIL_SPLASH1-2
								elseif skillNum==3 or skillNum==4 then
									PLAY_MOTION( info, mob, MOTION_ATTACK3 )
									
									local singleShot = false
									
									local skillName = (skillNum==3 and "TAIL_SPLASH" or "TAIL_SPLASH2")
									
									if singleShot then
										local backPos = GetBackPos(mob:GetPos(), mob:GetDir(), 20);
										local firePos = v3( backPos.x, backPos.y-3, backPos.z )
										USE_SKILL_POS(info, mob, skillName, firePos)
									else
										for i=1,4 do
											local backPos = GetBackPos(mob:GetPos(), mob:GetDir(), 20);
											if backPos then
												--local firePos = v3( backPos.x+RAND(-150,150)*0.1, backPos.y-3, backPos.z+RAND(-150,150)*0.1 )
												local firePos = GetLeftPos(backPos, mob:GetDir(), i*2)
												USE_SKILL_POS(info, mob, skillName, firePos)
												
												firePos = GetRightPos(backPos, mob:GetDir(), i*2)
												USE_SKILL_POS(info, mob, skillName, firePos)
											end
										end
									end								
									
								-- 5 : dash!
								elseif skillNum==5 then
									info.reflectAttackCount = reflectBreathCount
									
								-- 6 : Breath!
								elseif skillNum==6 then
	
									local mobState = GET_MOB_STATE( info, STATE_PATROL )
									if mobState ~= nil then
										MOVE_FRONT_FAR( mobState, mob, info )
										mobState.nextBreathAttack = true
										
										BOSS_STOP = false
										
										SET_TIMER(game, "BOSS_STOP", 18)
									end
								end
								
							end
						end
					end									
								
				end
			end
		},
		
		FAIL_RUNAWAY =
		{
			enter = function (state, game) 
				mgr:SendEventToClient( EVENT_SCRIPT, SC_EVENT_BOSS_RUNAWAY )
				mgr:EndGame(MISSIONRESULT_FAILED)
			end,
			
			process = function(state, game)
				SET_GAME_STATE( game, "END" )
			end,
		},
		
		WAIT_END = 
		{
			enter = function (state, game) 
				SET_TIMER(game, "WAIT_TIME_OVER", END_WAIT_TIME)
				--print(END_WAIT_TIME..' sec to end\n')
				mgr:SendEventToClient( EVENT_SCRIPT, SC_EVENT_MISSION_END_WAIT, END_WAIT_TIME )
				
				local result = MISSIONRESULT_FAILED
				local boss = mgr:GetMob(game.bossID)
				if boss ~= nil and boss:GetHP()<=0 then
					result = MISSIONRESULT_SUCCESS
				end
				
				game.result = result				
				mgr:SendEventToClient( EVENT_SCRIPT, SC_EVENT_MISSION_RESULT, result )				
				
				state.carrotCount = rewardCarrotCount
				state.carrotPopupTime = game.curTime + 5
				
				state.procDelay = 0.1
			end,			
			
			process = function(state, game)
				local boss = mgr:GetMob(game.bossID)
				if boss ~= nil and boss:GetHP()<=0 then
					if state.carrotCount > 0 and game.curTime >= state.carrotPopupTime then 
						-- 한번에 떨어지는 개수 제한
						local curCount = state.carrotCount>5 and 5 or state.carrotCount
						for i=1,curCount do
							local pos = boss:GetPos()
							local x = pos.x + RAND(-400,400)*0.1
							local y = pos.y
							local z = pos.z + RAND(-400,400)*0.1
							mgr:SpawnItem( v3(x,y,z), ITEM_CARROT, boss:GetObjID(), ITEM_SPAWN_STYLE_POPUP )
						end	
						state.carrotCount = state.carrotCount - curCount
						state.carrotPopupTime = 0.3
					end
				end				
				
				--CHECK_END_EVENT(game)				
			end,
			
			leave = function (state, game) 
				CLEAR_TIMER(game, "WAIT_TIME_OVER")
				
				--CHECK_END_EVENT(game)
			end,
			
			event = function( state, game, event, strValue, intValue1, intValue2 )
				if event==EVENT_TIMER then
					if strValue=="WAIT_TIME_OVER" then	
						mgr:EndGame(game.result)
						SET_GAME_STATE( game, "END" )
					end
				end
			end			
		},
		
		END = 
		{
			enter = function (state, game) 
				game.active = false					
				state.procDelay = 1
			end,			
		},
	}

	return stateList
end
		
-- 초기화
function OnInit()		
	g_Game.state = CreateGameState()
	SET_GAME_STATE( g_Game, "WAIT" )
	
	print('--- server Init OK\n')
end


function OnPlayerDie(player, attackerID, attackType)
	if not player:HasStatus(PLAYERSTATUS_FAINT) then
		local faintDelaySec = 100000
		player:AddStatus(PLAYERSTATUS_FAINT, faintDelaySec);
		
		if g_Game.deadPlayerList ~= nil then
			table.insert(g_Game.deadPlayerList, player:GetObjID())
			
			if table.getn(g_Game.deadPlayerList) >= mgr:GetPlayerCount() then
				mgr:SendEventToClient( EVENT_SCRIPT, SC_EVENT_MISSION_DEAD_WAIT, ALL_DEAD_WAIT_TIME )
				SET_TIMER(game, "ALL_DEAD", ALL_DEAD_WAIT_TIME)
			end
		end
	end
end

function OnPlayerResurrect(player)
	player:SetHPMax(-1, HP_HEAL, playerHPMax);
end

-- process때마다 호출
function OnProcess( deltaTime )

	if g_Game.active then
		PROCESS_GAME( g_Game, deltaTime )
	end
end


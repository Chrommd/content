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
	basilStartPos, basilStartDir	= ConvertNodePos(basilStartPosName)
	basilJumpPos	= ConvertNodePos(basilJumpPosName)

	statoStartPos	= ConvertNodePos(statoStartPosName)

	sealingPos1		= ConvertNodePos(sealingPosName1)
	sealingPos2		= ConvertNodePos(sealingPosName2)
	sealingPos3		= ConvertNodePos(sealingPosName3)
	sealingPos4		= ConvertNodePos(sealingPosName4)
	sealingPos5		= ConvertNodePos(sealingPosName5)
	
	castleSummonPos	= ConvertNodePos(castleSummonPosName)
	--castleSummonPos	= v3(269.15, -105.47, 258.93)
end

function SUMMON_MONSTER_FROM_CASTLE(game)
	local playerCount = mgr:GetPlayerCount()-1
	local summonCount = 0
	for i=0,playerCount do
		local player = mgr:GetPlayerByIndex(i)
		if player ~= nil and player:GetHP()>0 then
			for k,info in pairs(castleSummonList) do
				local pos = v3(0,0,0)
				local posGap = info[3]
				pos.x = castleSummonPos.x + RAND(-25,25)*0.1 + posGap.x
				pos.y = castleSummonPos.y + posGap.y
				pos.z = castleSummonPos.z + RAND(-25,25)*0.1 + posGap.z
				local mob = mgr:CreateMob( info[1], info[2], pos )				
				local info = GET_MOB_INFO(mob)
				if info ~= nil then
					info.active = true
					info.ignore_dist = true
					info.trace_id = player:GetObjID()
				end
			end
			summonCount = summonCount + 1
		end
	end
	
	if summonCount > 0 then
		mgr:SendEventToClient( EVENT_SCRIPT, SC_EVENT_INCIDENT, INCIDENT_SUMMONED )
	end
end


function ADD_EVENT_ACTIVE_MOB( game, oid )
	if game.eventActiveMobs==nil then
		game.eventActiveMobs = {}
	end
	game.eventActiveMobs[oid] = oid
end

function SET_EVENT_DELAY_TO_MOB( game, deltaTime )
	SET_DELAY_ALL_MOB( deltaTime, game.eventActiveMobs )
end

function CHECK_END_EVENT(game)
	if game.eventEndTime~=nil and game.curTime >= game.eventEndTime then
		mgr:SendEventToClient( EVENT_SCRIPT, SC_EVENT_SCENE_END )
		game.eventEndTime = nil
	end
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
				
				game.checkHealEvent = true				
				game.eventActiveMobs = {}
				
				-- Create boss
				local boss = mgr:CreateMob( "basilisk_trace", "basilisk_trace", basilStartPos )	
				game.bossID = boss:GetObjID()
				
				--mgr:CreateMob( "hyena", "hyena2", sealingPos1 )	
				--mgr:CreateMob( "eagle", "eagle", v3(sealingPos1.x,sealingPos1.y+10,sealingPos1.z) )	
				
				ADD_EVENT_ACTIVE_MOB( game, game.bossID )
				
				local lookPos = GetFrontPos(basilStartPos, basilStartDir, 10);				
				boss:LookAt( lookPos )
				
				local path = {}
				if mgr:SetMobPath(boss, basilPathName, "patrol_path") then
					local info = GET_MOB_INFO(boss)
					if info ~= nil and info.patrol_path ~= nil then
						local pos = info.patrol_path[1]
						print('[basil_path] #count='..table.getn(info.patrol_path)..', startPos( '..pos.x..', '..pos.y..', '..pos.z..' )\n')
						boss:ResetPos(pos.x, pos.y, pos.z)
					end
				end
				
				local stato = mgr:CreateMob( "stato_basilisk", "stato_basilisk", statoStartPos )	
				game.statoID = stato:GetObjID()
				ADD_EVENT_ACTIVE_MOB( game, game.statoID )

				FORCE_ACTIVE_MOB(boss)				
				FORCE_ACTIVE_MOB(stato)
				
				local sealing1 = mgr:CreateMob( "sealing", "sealing", sealingPos1 )	
				local sealing2 = mgr:CreateMob( "sealing", "sealing", sealingPos2 )	
				local sealing3 = mgr:CreateMob( "sealing", "sealing", sealingPos3 )	
				local sealing4 = mgr:CreateMob( "sealing", "sealing", sealingPos4 )	
				local sealing5 = mgr:CreateMob( "sealing", "sealing", sealingPos5 )	
				
				game.sealingIDs = 
				{ 
					sealing1:GetObjID(), 
					sealing2:GetObjID(), 
					sealing3:GetObjID(), 
					sealing4:GetObjID(), 
					sealing5:GetObjID(),
				}
				
				for i,oid in pairs(game.sealingIDs) do
					ADD_EVENT_ACTIVE_MOB( game, oid )
				end
				
				mgr:SendEventToClient( EVENT_SCRIPT, SC_EVENT_ADD_BOSS, game.bossID )
				mgr:SendEventToClient( EVENT_SCRIPT, SC_EVENT_ADD_NPC, game.statoID )
				
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
				NEXT_MOB_STATE( game.statoID, STATE_PATROL )
			end,			
			
			event = function( state, game, event, strValue, intValue1, intValue2 )
				if event==EVENT_SCRIPT then
					-- 스타토 목표 지점 도착 확인
					if strValue=="server" and intValue1==SS_EVENT_ARRIVED then
						if intValue2==game.statoID then
							mgr:SendEventToClient( EVENT_WAIT, SC_EVENT_MISSION_START )
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
				print('set Play TIMER = '..MISSION_TRY_TIME..'\n')
			end,		
			
			process = function(state, game)						
				local boss = mgr:GetMob(game.bossID)
				if boss == nil or boss:GetHP()<=0 then
					KILL_ALL_MONSTER(game)
					SET_GAME_STATE( game, "WAIT_END" )
				elseif boss ~= nil then
					local info = GET_MOB_INFO(boss)
					
					if info ~= nil 
						and info.patrolDone 
						and boss:GetHP() <= info.battleStartHP*castleSummonHPPercent*0.01 then
						
						-- 처음 소환 시 이벤트씬 출력
						if game.summonTime == nil then
							mgr:SendEventToClient( EVENT_SCRIPT, SC_EVENT_SCENE_START, EVENT_SCENE3 )
							
							SET_EVENT_DELAY_TO_MOB( game, CASTLE_SUMMON_EVENT_TIME )
							-- 보스는 제외대상이라서 따로 추가
							SET_DELAY( info, CASTLE_SUMMON_EVENT_TIME )
							
							SET_TIMER(game, "SUMMON_EVENT_END", CASTLE_SUMMON_EVENT_TIME)
							
							-- 실제로 잠시 후에 소환
							game.summonTime = info.curTime + 2.5
						end
						
						if game.curTime >= game.summonTime then
							--print('summon castle\n')
							
							SUMMON_MONSTER_FROM_CASTLE(game)
							
							game.summonTime = info.curTime + castleSummonDelay
						end
					end
				end
			end,	
			
			event = function( state, game, event, strValue, intValue1, intValue2 )
				if event==EVENT_TIMER then
					if strValue=="TIME_OVER" then
						print('TIME OVER!\n')
						NEXT_MOB_STATE( game.bossID, STATE_ATTACK5 )
					elseif strValue=="SUMMON_EVENT_END" then
						mgr:SendEventToClient( EVENT_SCRIPT, SC_EVENT_SCENE_END )
					elseif strValue=="ALL_DEAD" then
						if table.getn(game.deadPlayerList) >= mgr:GetPlayerCount() then
							game.result = MISSIONRESULT_FAILED
							mgr:SendEventToClient( EVENT_SCRIPT, SC_EVENT_MISSION_RESULT, game.result )
							mgr:EndGame(game.result)
							SET_GAME_STATE( game, "END" )						
						end
					end
				elseif event==EVENT_SCRIPT then
					if strValue=="server" then
						if intValue1==SS_EVENT_ACTIVATE_OBJECT then
							local count = table.getn(game.sealingIDs)
							print('remain #sealing = '..count..'\n')
							if count > 0 then
								-- 봉인이 남아있으면 스타토가 깨러 간다
								NEXT_MOB_STATE( game.statoID, STATE_ATTACK )
							else
								-- 봉인이 더 없으면 보스 다음 단계
								NEXT_MOB_STATE( game.statoID, STATE_PATROL )
								NEXT_MOB_STATE( game.bossID, STATE_ATTACK4 )
							end
						end
					elseif strValue=="client" then
						if intValue1==CS_EVENT_MISSION_RESURRECT then
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
					if EFFECT_TEST then
						local mob = mgr:GetMob(game.bossID)
						if mob ~= nil then
							local player = mgr:FindNearPlayer(mob)
							if player ~= nil and player:GetHP() > 0 then				
								local pos = player:GetPos()
						
								local info = GET_MOB_INFO(mob)
								
								local skillNum = intValue1
								
								mob:LookAt(pos)
								
								-- 1 = VOLCANO
								if skillNum==1 then
									PLAY_MOTION( info, mob, MOTION_ATTACK )
									
									local skillName="VOLCANO"						
									local frontPos = GetFrontPos( pos, player:GetDir(), player:GetVelocity()*RAND(15,25)*0.1 )							
									USE_SKILL_POS(info, mob, skillName, frontPos)
								-- 2 = SOULTOUCH
								elseif skillNum==2 then
									
									PLAY_MOTION( info, mob, MOTION_ATTACK )
									local skillName="SOULTOUCH"
						
									local frontPos = GetFrontPos( pos, player:GetDir(), player:GetVelocity()*RAND(15,25)*0.1 )
									local x = frontPos.x
									local y = frontPos.y
									local z = frontPos.z
									
									USE_SKILL_POS(info, mob, skillName, v3(x,y,z))
									USE_SKILL_POS(info, mob, skillName, v3(x+15,y,z))
									USE_SKILL_POS(info, mob, skillName, v3(x,y,z+15))
									USE_SKILL_POS(info, mob, skillName, v3(x-15,y,z))
									USE_SKILL_POS(info, mob, skillName, v3(x,y,z-15))
								-- 3 = FIREWAVE
								elseif skillNum==3 then
								
									PLAY_MOTION( info, mob, MOTION_ATTACK2 )
									local x = pos.x
									local y = pos.y
									local z = pos.z
									USE_SKILL_POS(info, mob, "FIREWAVE", v3(x,y,z))
									USE_SKILL_POS(info, mob, "FIREWAVE", v3(x+15,y,z))
									USE_SKILL_POS(info, mob, "FIREWAVE", v3(x,y,z+15))
									USE_SKILL_POS(info, mob, "FIREWAVE", v3(x-15,y,z))
									USE_SKILL_POS(info, mob, "FIREWAVE", v3(x,y,z-15))
								-- 꼬리 치기
								elseif skillNum==4 then
									PLAY_MOTION( info, mob, MOTION_ATTACK3 )
									USE_SKILL_POS(info, mob, "BODY_ATTACK", mob:GetPos())
								-- 회오리
								elseif skillNum==5 then								
									PLAY_MOTION( info, mob, MOTION_ATTACK4 )
									USE_SKILL_POS(info, mob, "BODY_HURRICANE", mob:GetPos())
								-- 전체 공격
								elseif skillNum==6 then
									PLAY_MOTION( info, mob, MOTION_ATTACK5 )
									USE_SKILL_POS(info, mob, "BODY_PRESS", mob:GetPos())
								-- 석화
								elseif skillNum==7 then
									PLAY_MOTION( info, mob, MOTION_ATTACK2 )
									USE_SKILL(info, mob, "PETRIFY", player)
								-- 점프
								elseif skillNum==8 then
									JUMP_TO_POS( info, mob, pos )
								end
								
							end
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
				
				CHECK_END_EVENT(game)				
			end,
			
			leave = function (state, game) 
				CLEAR_TIMER(game, "WAIT_TIME_OVER")
				
				CHECK_END_EVENT(game)
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
				SET_TIMER(g_Game, "ALL_DEAD", ALL_DEAD_WAIT_TIME)
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


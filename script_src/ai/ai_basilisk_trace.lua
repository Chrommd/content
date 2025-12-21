-- module setup
require('aihelper')

-- 처음 그냥 공격 상태
-- 봉인석 깨기 모드
-- 3단계

function JUMP_TO_POS( info, mob, pos )	
	mob:LookAt(pos)
	PLAY_MOTION(info, mob, MOTION_JUMP)
	mob:Knockback( pos.x, pos.y, pos.z, 2, 0.5, KNOCKBACK_JUMP )	
end

function CHECK_COLLAPSE( info, mob )
	if info.collapsePercent ~= nil then
		local collapseHP = info.battleStartHP * info.collapsePercent * 0.01
			
		if info.hp <= collapseHP then
			mob:Stop()
			PLAY_MOTION( info, mob, MOTION_ATTACKED2 )
			
			-- 다음 쓰러지기 설정
			info.collapsePercent = info.collapsePercent * 0.5
			if info.collapsePercent < 25 then
				info.collapsePercent = nil
			end
			
			return true
		end
	end
	
	return false
end

function SET_BODY_PRESS_TIME( info, delay )
	info.bodyBodyPressUnableTime = info.curTime + delay
end

function CHECK_SKILL_BODY_PRESS( info, mob )
	if info.curTime >= info.bodyBodyPressUnableTime then
		
		PLAY_MOTION( info, mob, MOTION_ATTACK5 )
		USE_SKILL_POS(info, mob, "BODY_PRESS", mob:GetPos())
		
		SET_BODY_PRESS_TIME( info, 30 )
		return true
	end		
	
	return false
end

function SET_HURRICANE_TIME( info, delay )
	info.bodyHurricaneUnableTime = info.curTime + delay
end

function CHECK_SKILL_HURRICANE( info, mob, pos )

	if info.curTime >= info.bodyHurricaneUnableTime and not mob:IsNearPos(pos, 10) and mob:IsNearPos(pos, 23) then
		
		PLAY_MOTION( info, mob, MOTION_ATTACK4 )
		USE_SKILL_POS(info, mob, "BODY_HURRICANE", mob:GetPos())
		
		-- 쌩뚱맞은 하이에나 소환
		mgr:CreateMob( "hyena", "hyena2", mob:GetPos() )
		
		--PLAY_MOTION( info, mob, MOTION_ATTACK2 )
		--USE_SKILL(info, mob, "GAZE_BEAM", player)
		SET_HURRICANE_TIME( info, 15 )
		return true
	end		
	
	return false
end

function CHECK_DEFAULT_ATTACK( state, info, mob, pos )
	if CHECK_SKILL_HURRICANE( info, mob, pos ) then
		state.missileTime = info.curTime + 5	
		return true
	end
	
	if CHECK_SKILL_BODY_PRESS( info, mob ) then
		return true
	end
	
	return false
end

g_AIFactory['basilisk_trace'] = 
{ 

onInit = function (info, mob)	
	if bossHP ~= nil then
		info.hp_max = bossHP
	else
		local playerCount = mgr:GetPlayerCount()
		if playerCount <= 0 then playerCount = 1 end
		info.hp_max = basilBaseHP * playerCount 
	end
	print('set Basilisk HP ='..info.hp_max..'\n')
	info.hp		= info.hp_max
	
	info.attack_dist = 120
	info.petrify_dist = 15
	info.collapsePercent = 50
	info.entrance = false
	info.battleStartHP = info.hp_max
	info.patrolDone = true
	SET_HURRICANE_TIME( info, 10 )
	SET_BODY_PRESS_TIME( info, 30 )
end,

onAddAfter = function (info, mob)
	mob:SetMoveType( MOVE_TYPE_UNDERGROUND )
	mob:SetVelocity(basilDefaultVelocity)
	mob:Scale( 0.9, 0.9, 0.9 )
	--mob:Scale( 0.1, 0.1, 0.1 )
	--mob:Scale( 2.5, 2.5, 2.5 )
end,

onAttacked = function (info, mob, damage, attackerID)

	local ret = false
	local defaultHandler = g_AIDefaultHandler.onAttacked
	if defaultHandler ~= nil then
		ret = defaultHandler(info, mob, damage, attackerID)
	end
	
	--print('attack change target :'..info.trace_id..' --> '..attackerID..'\n')
	info.lastAttackerID = attackerID
	
	return ret
end,

onAdjustDamage = function (info, mob, skillID, damage)
	if damage >= 1 then		
		if mob:HasStatus(PLAYERSTATUS_RAGE) then
			return damage*0.5
		end
	end
		
	return damage
end,

onSkillAttacked = function (info, mob, skillID, skillOID, damage, attackerID)
	local ret = false
	local defaultHandler = g_AIDefaultHandler.onSkillAttacked
	if defaultHandler ~= nil then
		ret = defaultHandler(info, mob, skillID, skillOID, damage, attackerID)
	end
	
	--print('skill change target :'..info.trace_id..' --> '..attackerID..'\n')
	info.lastAttackerID = attackerID
	
	return ret
end,

createState = function ()
	local stateList = {}
	stateList.motion = {}
	local motion = stateList.motion

	--                        { Name,				StateName,					aniDelay }
	motion[MOTION_IDLE]		= { name='Idle',		state='G_IDLE',				aniDelay=1 }
	motion[MOTION_INIT]		= { name='Init',		state='MONANI_ENTRANCE',	aniDelay=11.5 }	
	motion[MOTION_ATTACK]	= { name='Attack',		state='ATTACK',				aniDelay=6 }
	motion[MOTION_ATTACK2]	= { name='Attack',		state='MONANI_06',			aniDelay=3 }
	motion[MOTION_ATTACK3]	= { name='BodyAttack',	state='MONANI_ATTACK_01',	aniDelay=4.3 }
	motion[MOTION_ATTACK4]	= { name='BodyHurricane',state='MONANI_ATTACK_02',	aniDelay=4.8 }
	motion[MOTION_ATTACK5]	= { name='BodyPress',	state='MONANI_ATTACK_03',	aniDelay=9 }	
	motion[MOTION_MOVE]		= { name='Move',		state='MONANI_DEFAULTMOVE',	aniDelay=0.5 }
	motion[MOTION_ATTACKED1]= { name='HeadDamage',	state='MONANI_ATTACKED_01',	aniDelay=3.5 }
	motion[MOTION_ATTACKED2]= { name='Collapse',	state='MONANI_ATTACKED_02',	aniDelay=10 }	
	motion[MOTION_JUMP]		= { name='Jump',		state='MONANI_04',			aniDelay=3.2 }
	motion[MOTION_ATTACKED]	= { name='Attacked',	state='MONANI_05',			aniDelay=0.2 }
	motion[MOTION_DEAD]		= { name='Dead',		state='MONANI_ENDSUCCESS',	aniDelay=8.5 }

	stateList[STATE_IDLE]	= { name='Idle',	procDelay=0.2}
	stateList[STATE_INIT]	= { name='Init',	procDelay=0.2}
	stateList[STATE_PATROL]	= { name='Patrol',	procDelay=0.1}
	stateList[STATE_EVENT1]	= { name='Event1',	procDelay=0.1}	
	stateList[STATE_ATTACK1]= { name='Attack1',	procDelay=0.1}		
	stateList[STATE_WEAK1]	= { name='Weak1',	procDelay=0.2}			
	stateList[STATE_ATTACK2]= { name='Attack2',	procDelay=0.1}		
	stateList[STATE_ATTACK3]= { name='Attack3',	procDelay=0.1}		
	stateList[STATE_ATTACK4]= { name='Attack4',	procDelay=0.1}		
	stateList[STATE_ATTACK5]= { name='Attack5',	procDelay=0.1}		
	stateList[STATE_FOLLOW]	= { name='Follow',	procDelay=0.3}	
	stateList[STATE_DEAD]	= { name='Dead',	procDelay=0.2}
	
	-- 초기화 부분. local procState = { enter, process, leave }
	local idleState = 
	{	
		process = function (state, mob, info)
			-- do nothing
		end,
	}
	
	local initState =
	{
		enter = function (state, mob, info) 
			PLAY_MOTION( info, mob, MOTION_INIT )
			USE_SKILL(info, mob, "BREATH", mob)
			SET_DELAY( info, 10 )
		end,
		
		process = function (state, mob, info)
			mob:SetMoveType( MOVE_TYPE_GROUND )
			NEXT_STATE( info, STATE_PATROL )
		end
	}
	
	local patrolState = 
	{
		enter = function (state, mob, info)
		
			if state.pathIndex == nil then
				state.pathIndex = 1
				
				if forcePatrolIndex ~= nil then
					state.pathIndex = forcePatrolIndex
					
					local pos = info.patrol_path[state.pathIndex]
					mob:ResetPos( pos.x, pos.y, pos.z )
				end
			end
			
			mob:SetVelocity(basilPatrolVelocity)
			mob:Stop()
			if not info.entrance then
				info.entrance = true
				NEXT_STATE( info, STATE_INIT )
				SET_DELAY( info, 0.5 )
				return
			else
				PLAY_MOTION( info, mob, MOTION_IDLE )
			end
			
			--local player = mgr:FindNearPlayer(mob)
			--if player ~= nil and player:GetHP() > 0 and mob:IsNearPos(player:GetPos(), info.attack_dist) then
			--	info.trace_id = player:GetObjID()
			--end
			
			if info.patrol_path ~= nil then
				PLAY_MOTION(info, mob, MOTION_MOVE)					
			else
				PLAY_MOTION(info, mob, MOTION_ATTACK2)					
			end
			
			state.missileTime = info.curTime + 1
			state.petrifyTime = info.curTime + 30
			
			info.patrolDone = false
		end,

		process = function (state, mob, info)
		
			-- effect test
			if EFFECT_TEST then
				if state.jumpedCenter == nil then
					JUMP_TO_POS( info, mob, basilJumpPos )	
					state.jumpedCenter = true
					info.patrolDone = true					
				end
				return
			end
		
			local path = info.patrol_path
			if path ~= nil then
			
				if not BOSS_STOP and mob:IsNearPos( mob:GetMovePos() ) then
				
					local maxIndex = table.getn(path)
					
					-- 한바퀴 다 돌았을 경우
					if state.pathIndex > maxIndex then
						NEXT_STATE( info, STATE_EVENT1 )
						return
					end
					
					if state.missileTime ~= nil and info.curTime >= state.missileTime then
					
						local playerCount = mgr:GetPlayerCount()
						
						if playerCount <= 0 then
							return
						end
						
						local selectIndex = RAND(1,playerCount)-1
						local player = mgr:GetPlayerByIndex(selectIndex)
						
						if player ~= nil and player:GetHP()>0 then
							-- 전방 10M 앞에 벗어난 경우
							local pos = player:GetPos()
							
							if info.curTime >= state.petrifyTime
								and not player:HasStatus(PLAYERSTATUS_PETRIFY) 
								and not mob:IsNearPos(pos, 10) 
								and mob:IsInFront(pos, 90) then								
									mob:Stop()
									mob:LookAt(pos)
									
									PLAY_MOTION( info, mob, MOTION_ATTACK2 )
									USE_SKILL(info, mob, "PETRIFY", player)
									
									SET_DELAY( info, 4 )
									
									state.petrifyTime = info.curTime + 10
							elseif mob:IsNearPos(pos, 180) then						
								--mob:Stop()
								--PLAY_MOTION( info, mob, MOTION_ATTACK )
								local attackPos								
								local attackStyle = RAND(1,3)								
								local skillName = "VOLCANO_MOVING"
								
								local mpos = mob:GetPos()
								
								if attackStyle==1 then 
									-- mob front
									local frontPos = GetFrontPos( mpos, mob:GetDir(), RAND(0,5) )
									frontPos.y = mpos.y
									attackPos = GetLeftPos( frontPos, mob:GetDir(), RAND(10,20) )
									USE_SKILL_POS(info, mob, skillName, attackPos)
									
									attackPos = GetRightPos( frontPos, mob:GetDir(), RAND(10,20) )								
									USE_SKILL_POS(info, mob, skillName, attackPos)
								elseif attackStyle==2 then								
									-- player front
									local frontPos = GetFrontPos( pos, player:GetDir(), RAND(25,35) )
									frontPos.y = mpos.y									
									attackPos = GetLeftPos( frontPos, mob:GetDir(), RAND(10,20) )
									USE_SKILL_POS(info, mob, skillName, attackPos)
									
									attackPos = GetRightPos( frontPos, mob:GetDir(), RAND(10,20) )								
									USE_SKILL_POS(info, mob, skillName, attackPos)
								else
									-- player front
									attackPos = GetFrontPos( pos, player:GetDir(), RAND(15,20) )
									attackPos.y = mpos.y
									USE_SKILL_POS(info, mob, skillName, attackPos)
								end
								
								state.missileTime = info.curTime + RAND(15, 30)*0.1
								state.lastAttacked = true
								return
							else
								--print('out of reach\n')
							end
						end						
					end
					
					local pos = path[state.pathIndex]
					
					if state.lastAttacked then
						PLAY_MOTION(info, mob, MOTION_MOVE)					
						state.lastAttacked = nil
					end
					
					mob:Move( pos.x, pos.y, pos.z )
					--print('[basil_path] move( '..pos.x..', '..pos.y..', '..pos.z..' )\n')
					
					state.pathIndex = state.pathIndex + 1
				end				
			else
				if not BOSS_STOP then				
					NEXT_STATE( info, STATE_EVENT1 )
				end
			end
		end,
		
		leave = function (state, mob, info)
			mob:SetVelocity(basilDefaultVelocity)
			info.patrolDone = true
		end
	}	
	
	-- 분지 도착 이벤트
	local event1State = 
	{
		enter = function (state, mob, info)			
			state.eventEndTime = info.curTime + BATTLE_ENTER_EVENT_TIME
			state.jumpTime = info.curTime + 0.5			
			mgr:SendEventToClient( EVENT_SCRIPT, SC_EVENT_SCENE_START, EVENT_SCENE1 )
			SET_EVENT_DELAY_TO_MOB( g_Game, BATTLE_ENTER_EVENT_TIME )
			SET_BODY_PRESS_TIME( info, 3 )
		end,
		
		process = function (state, mob, info)
			if info.curTime >= state.eventEndTime then
				NEXT_STATE( info, STATE_ATTACK1 )	
				return
			end
			
			-- Jump to center
			if state.jumpTime ~= nil and info.curTime >= state.jumpTime then
			
				JUMP_TO_POS( info, mob, basilJumpPos )
				
				state.jumpTime = nil
				return
			end
			
			if CHECK_SKILL_BODY_PRESS( info, mob ) then
				return true
			end
			
		end,		
		
		leave = function (state, mob, info)
			mgr:SendEventToClient( EVENT_SCRIPT, SC_EVENT_SCENE_END )
		end
	}
	
	-- 처음 상태	
	local attack1State = 
	{
		enter = function (state, mob, info)			
			info.battleStartHP = info.hp
			state.missileTime = info.curTime + 5
			state.skillIndex = 1
			state.limitHP = info.battleStartHP * firstPhaseHPLimitPercent * 0.01
			state.bodyAttack = false
			state.bodyAttackUnableTime = info.curTime + 15			
			SET_HURRICANE_TIME( info, 10 )
			SET_BODY_PRESS_TIME( info, 30 )
		end,

		process = function (state, mob, info)
		
			-- 체력 일정 % 이하면 다음 단계
			if info.hp <= state.limitHP then
				NEXT_STATE( info, STATE_WEAK1 )				
			end
			
			-- 50 ~ 100 미터 사이	
			if not state.bodyAttack and info.curTime >= state.bodyAttackUnableTime then
			
				local playerCount = mgr:GetPlayerCount()-1
				for i=0,playerCount do
					local player = mgr:GetPlayerByIndex(i)
					if player ~= nil and player:GetVelocity()<10 then
						local pos = player:GetPos()
						if not mob:IsNearPos(pos, 50) and mob:IsNearPos(pos, 150) then
							mob:LookAt(pos)
							PLAY_MOTION( info, mob, MOTION_ATTACK3 )
							USE_SKILL_POS(info, mob, "BODY_ATTACK", mob:GetPos())							
							--mob:Knockback( pos.x, pos.y, pos.z, 1, 0.5, KNOCKBACK_RUSH )	
							--USE_SKILL_POS(info, mob, "BODY_ATTACK", mob:GetPos())
							local mpos = mob:GetPos()						
							local dist = mob:GetDist( pos )
							local mdir = v3( (pos.x - mpos.x)/dist, (pos.y - mpos.y)/dist, (pos.z - mpos.z)/dist )
							
							local fdist = dist - 12.3
							local frontPos = v3( mpos.x + mdir.x*fdist, mpos.y + mdir.y*fdist, mpos.z + mdir.z*fdist )
							
							JUMP_TO_POS( info, mob, frontPos )
							--state.missileTime = info.curTime + 6
							state.bodyAttack = true
							return
						end	
					end
				end
			end	
			
			-- missile attack
			if state.missileTime ~= nil and info.curTime >= state.missileTime then
				
				local player = mgr:FindNearPlayer(mob)
				if player ~= nil and player:GetHP() > 0 then
				
					local pos = player:GetPos()
					
					mob:Stop()			
					
					
					if state.bodyAttack then						
						state.bodyAttack = false
						
						if mob:IsNearPos(pos, 25) then
							PLAY_MOTION( info, mob, MOTION_ATTACK3 )
							USE_SKILL_POS(info, mob, "BODY_ATTACK", mob:GetPos())
							
							--PLAY_MOTION( info, mob, MOTION_ATTACK2 )
							--USE_SKILL(info, mob, "GAZE_BEAM", player)
							state.missileTime = info.curTime + 5
							
							return
						end
					end
					
					if CHECK_DEFAULT_ATTACK( state, info, mob, pos ) then
						return
					end
					
					if state.bodyAttack then
						state.bodyAttackUnableTime = info.curTime + 30
						state.bodyAttack = false
					end	
					
					if not mob:IsNearPos(pos, 18) then
						mob:LookAt(pos)
					end
					
					local curSkillIndex = state.skillIndex % 2
					local skillName
					
					if curSkillIndex==0 then		skillName="VOLCANO"
					elseif curSkillIndex==1 then	skillName="SOULTOUCH"
					end
				
					local playerCount = mgr:GetPlayerCount()-1
					for i=0,playerCount do
						local player = mgr:GetPlayerByIndex(i)
						if player ~= nil then
							local pos = player:GetPos()												
						
							PLAY_MOTION( info, mob, MOTION_ATTACK )										
						
							if curSkillIndex==0 then 
								local frontPos = GetFrontPos( pos, player:GetDir(), player:GetVelocity()*RAND(15,25)*0.1 )
								
								USE_SKILL_POS(info, mob, skillName, frontPos)

							elseif curSkillIndex==1 then 
								
								local frontPos = GetFrontPos( pos, player:GetDir(), player:GetVelocity()*RAND(15,25)*0.1 )
								local x = frontPos.x
								local y = frontPos.y
								local z = frontPos.z
								
								USE_SKILL_POS(info, mob, skillName, v3(x,y,z))
								USE_SKILL_POS(info, mob, skillName, v3(x+15,y,z))
								USE_SKILL_POS(info, mob, skillName, v3(x,y,z+15))
								USE_SKILL_POS(info, mob, skillName, v3(x-15,y,z))
								USE_SKILL_POS(info, mob, skillName, v3(x,y,z-15))
								
							end
						end
					end
					
					state.skillIndex = state.skillIndex + 1
					state.missileTime = info.curTime + 8
				end
			end
						
		end,
	}
	
	-- 첫번째 약화 상태
	local weak1State = 
	{
		enter = function (state, mob, info)
			mob:Stop()
			PLAY_MOTION( info, mob, MOTION_ATTACKED1 )
			
			if g_Game.checkHealEvent then
				print('event2 start\n')
				info.eventEndTime = info.curTime + SEALING_HEAL_EVENT_TIME
				mgr:SendEventToClient( EVENT_SCRIPT, SC_EVENT_SCENE_START, EVENT_SCENE2 )
				SET_EVENT_DELAY_TO_MOB( g_Game, SEALING_HEAL_EVENT_TIME )
				g_Game.checkHealEvent = false
			end
		end,
		
		process = function (state, mob, info)
			NEXT_STATE( info, STATE_ATTACK2 )
		end,
	}
	
	-- 한명 쫓아가기 "대기" 상태
	local attack2State = 
	{
		enter = function (state, mob, info)
			state.jumpTime = info.curTime + 3			
			state.missileTime = info.curTime + 1
			state.sealingTime = info.curTime + sealingActivateDelay
			state.skillIndex = 1
			
			SET_HURRICANE_TIME( info, 10 )
			SET_BODY_PRESS_TIME( info, 20 )
			
			mgr:AddStatus(mob:GetObjID(), PLAYERSTATUS_RAGE, 100000);
			mob:Scale( 1, 1, 1 )		
		end,
		
		process = function (state, mob, info)
			if g_Game.aggrTargetID ~= nil then
				NEXT_STATE( info, STATE_ATTACK3 )
			else					
				
				if CHECK_COLLAPSE( info, mob ) then
					return
				end
			
				-- 봉인 해제 타이밍
				if state.sealingTime ~= nil and info.curTime >= state.sealingTime then
					OnEvent( EVENT_SCRIPT, "server", SS_EVENT_ACTIVATE_OBJECT )
					state.sealingTime = nil
				end
				
				-- 이벤트 중인가?
				if info.eventEndTime ~= nil then
					if info.curTime >= info.eventEndTime then
						print('event2 end\n')
						mgr:SendEventToClient( EVENT_SCRIPT, SC_EVENT_SCENE_END )
						info.eventEndTime = nil
					end
					
					return
				end

			
				-- 공격 타이밍
				if state.missileTime ~= nil and info.curTime >= state.missileTime then
				
					local player = mgr:FindNearPlayer(mob)
					if player ~= nil then 
					
						local pos = player:GetPos()
					
						if CHECK_DEFAULT_ATTACK( state, info, mob, pos ) then
							return
						end
					
						local curSkillIndex = state.skillIndex % 3
					
						mob:LookAt(pos)
						PLAY_MOTION( info, mob, MOTION_ATTACK2 )
										
						if false then --curSkillIndex==2 then
							USE_SKILL(info, mob, "BREATH", mob)
							
							state.missileTime = info.curTime + 6
						else
							local x = pos.x
							local y = pos.y
							local z = pos.z
							USE_SKILL_POS(info, mob, "FIREWAVE", v3(x,y,z))
							USE_SKILL_POS(info, mob, "FIREWAVE", v3(x+15,y,z))
							USE_SKILL_POS(info, mob, "FIREWAVE", v3(x,y,z+15))
							USE_SKILL_POS(info, mob, "FIREWAVE", v3(x-15,y,z))
							USE_SKILL_POS(info, mob, "FIREWAVE", v3(x,y,z-15))
							
							state.missileTime = info.curTime + 5
						end
					end
					
					state.skillIndex = state.skillIndex + 1					
				end
				
				-- Jump to player
				if state.jumpTime ~= nil and info.curTime >= state.jumpTime then
				
					local player = mgr:FindNearPlayer(mob)
					if player ~= nil and player:GetHP() > 0 then				
						--JUMP_TO_POS( info, mob, player:GetPos() )						
					end
					--state.jumpTime = info.curTime + 5
					state.jumpTime = info.curTime + 10
				end
			end
		end,
	}
	
	-- 한 명 쫓아가기
	local attack3State = 
	{
		enter = function (state, mob, info)
			mgr:RemoveStatus(mob:GetObjID(), PLAYERSTATUS_RAGE);
			mob:Scale( 0.9, 0.9, 0.9 )
			state.leaveTime = info.curTime + bossWeakDelayTime
			mgr:SendEventToClient( EVENT_SCRIPT, SC_EVENT_BEGIN_TRACE_PLAYER, g_Game.aggrTargetID )
			
			if g_Game.aggrTargetID ~= nil then
				mob:GazeAt(g_Game.aggrTargetID, GAZE_ATTACK)
			end					
		end,
		
		process = function (state, mob, info)
			if g_Game.aggrTargetID == nil or info.curTime>=state.leaveTime then
				NEXT_STATE( info, STATE_ATTACK2 )
			else
			
				if CHECK_COLLAPSE( info, mob ) then
					return
				end
				
				local player = mgr:GetPlayer(g_Game.aggrTargetID)
				if player ~= nil then 
				
					-- 이미 대상이 죽거나 석화됐으면 기본 상태로?
					if player:GetHP()<=0 or player:HasStatus(PLAYERSTATUS_PETRIFY) then												
						NEXT_STATE( info, STATE_ATTACK2 )
						return
					end
				
					-- 석화 거리 되면 석화시킨다.
					if mob:GetDist(player:GetPos()) <= info.petrify_dist then
						mob:Stop()
						mob:LookAt(player:GetPos())
						
						PLAY_MOTION( info, mob, MOTION_ATTACK2 )
						USE_SKILL(info, mob, "PETRIFY", player)
						
						SET_DELAY( info, 6 )
							
					-- 거리가 안되면 쫓아간다
					else
						PLAY_MOTION(info, mob, MOTION_MOVE)							
						local pos = player:GetPos()
						mob:Move(pos.x, pos.y, pos.z)						
					end
				end
			end
		end,
		
		leave = function (state, mob, info)
			mgr:AddStatus(mob:GetObjID(), PLAYERSTATUS_RAGE, 100000);
			mob:Scale( 1, 1, 1 )			
			JUMP_TO_POS( info, mob, basilJumpPos )		
			mgr:SendEventToClient( EVENT_SCRIPT, SC_EVENT_END_TRACE_PLAYER, g_Game.aggrTargetID )
			g_Game.aggrTargetID = nil		
			
			mob:GazeAt(0, GAZE_NONE)					
		end
	}
	
	-- 마지막 단계
	local attack4State = 
	{
		enter = function (state, mob, info)			
			mgr:RemoveStatus(mob:GetObjID(), PLAYERSTATUS_RAGE);
			mob:Scale( 0.9, 0.9, 0.9 )
			
			state.jumpTime = info.curTime + 0.5
			state.skillIndex = 1
			state.missileTime = info.curTime + 1			
			
			state.summon = false
			state.summonCasting = false		
			state.summonHP = info.battleStartHP * summonHPLimitPercent * 0.01
			
			SET_HURRICANE_TIME( info, 10 )
			SET_BODY_PRESS_TIME( info, 20 )
		end,

		process = function (state, mob, info)
		
			if CHECK_COLLAPSE( info, mob ) then
				return
			end
				
			-- Jump to center
			if state.jumpTime ~= nil and info.curTime >= state.jumpTime then
			
				JUMP_TO_POS( info, mob, basilJumpPos )
				
				state.jumpTime = nil
			end
			
			-- SUMMON : HP 30%
			if not info.summon and info.hp <= state.summonHP then
				if not state.summonCasting then
					PLAY_MOTION( info, mob, MOTION_ATTACK )
					USE_SKILL(info, mob, "SUMMON", mob)
					state.summonCasting = true
					return
				else
					print('summon!!\n')
					mgr:CreateMob( "hyena", "hyena2", mob:GetPos() )	
					mgr:CreateMob( "hyena", "hyena2", mob:GetPos() )	
					mgr:CreateMob( "hyena", "hyena2", mob:GetPos() )	
					
					info.summon = true
					SET_DELAY(info, 5)
					return
				end
			end
			
			local player = mgr:FindNearPlayer(mob)
			if player ~= nil then
				-- 시간 되면 공격
				if state.missileTime ~= nil and info.curTime >= state.missileTime then				
				
					local pos = player:GetPos()
				
					if CHECK_DEFAULT_ATTACK( state, info, mob, pos ) then
						return
					end
						
					mob:Stop()
					mob:LookAt(pos)
					
					local x = pos.x
					local y = pos.y
					local z = pos.z
					
					local curSkillIndex = state.skillIndex % 2
					local skillName
					
					if curSkillIndex==0 then skillName="VOLCANO"
					elseif curSkillIndex==1 then
						mgr:CreateRuntimeObstacle( mob:GetObjID(), v3(x+15,y,z) )
						mgr:CreateRuntimeObstacle( mob:GetObjID(), v3(x,y,z+15) )
						mgr:CreateRuntimeObstacle( mob:GetObjID(), v3(x-15,y,z) )
						mgr:CreateRuntimeObstacle( mob:GetObjID(), v3(x,y,z-15) )
					end
					
					PLAY_MOTION( info, mob, MOTION_ATTACK )
					
					if skillName ~= nil then
						USE_SKILL_POS(info, mob, skillName, v3(x,y,z))
						USE_SKILL_POS(info, mob, skillName, v3(x+15,y,z))
						USE_SKILL_POS(info, mob, skillName, v3(x,y,z+15))
						USE_SKILL_POS(info, mob, skillName, v3(x-15,y,z))
						USE_SKILL_POS(info, mob, skillName, v3(x,y,z-15))
					end
					
					state.skillIndex = state.skillIndex + 1
					state.missileTime = info.curTime + 10
				else
					PLAY_MOTION(info, mob, MOTION_MOVE)							
					local pos = player:GetPos()
					mob:Move(pos.x, pos.y, pos.z)						
				end					
			end						
		end,
	}

	-- 타임 오버 때 플레이어 다 잡기!
	local attack5State = 
	{
		enter = function (state, mob, info)
			state.attackPlayerIndex = 0
			state.attackPetrify = false
			state.sendEndEvent = false
		end,
		
		process = function (state, mob, info)
			-- 석화 공격 타이밍
			if state.attackPetrify then
				
				local player = mgr:GetPlayerByIndex(state.attackPlayerIndex)
				if player ~= nil and not player:HasStatus(PLAYERSTATUS_PETRIFY) then
					mob:Stop()
					mob:LookAt(player:GetPos())
						
					PLAY_MOTION( info, mob, MOTION_ATTACK2 )
					USE_SKILL(info, mob, "PETRIFY", player)
						
					SET_DELAY( info, 6 )
				end
				
				state.attackPetrify = false
				state.attackPlayerIndex = state.attackPlayerIndex + 1
			
			
			-- 순서대로 석화 안된 애한테 다가간다.
			elseif state.attackPlayerIndex < mgr:GetPlayerCount() then				
				local player = mgr:GetPlayerByIndex(state.attackPlayerIndex)
				if player ~= nil then
					local pos = player:GetPos()
					mob:Stop()
					
					local x = pos.x + RAND(-10,10)
					local y = pos.y - 5
					local z = pos.z + RAND(-10,10)
					
					JUMP_TO_POS( info, mob, v3(x,y,z) )
					
					state.attackPetrify = true
				end				
			elseif not state.sendEndEvent then
				-- game over!!
				print('GAME OVER - failed!\n')
				OnEvent( EVENT_SCRIPT, "server", SC_EVENT_MISSION_END_WAIT )
				state.sendEndEvent = true
			end
		end,
	}
	
	local deadState =
	{
		enter = function (state, mob, info)
			state.alive = true
			state.show = true
			SET_DELAY(info, 0.5)
			
			g_Game.eventEndTime = info.curTime + BOSS_DEAD_EVENT_TIME
			mgr:SendEventToClient( EVENT_SCRIPT, SC_EVENT_SCENE_START, EVENT_SCENE4 )
			SET_EVENT_DELAY_TO_MOB( g_Game, BOSS_DEAD_EVENT_TIME )
		end,
		
		process = function (state, mob, info)
			if state.alive then
				state.alive = false
				PLAY_MOTION( info, mob, MOTION_DEAD )				
			elseif state.show then
				state.show = false
				mob:Dead()
			end
			
		end,
	}
		
	SET_STATE_HANDLER( stateList[STATE_IDLE], idleState )
	SET_STATE_HANDLER( stateList[STATE_INIT], initState )
	SET_STATE_HANDLER( stateList[STATE_PATROL], patrolState )
	SET_STATE_HANDLER( stateList[STATE_EVENT1], event1State )	
	SET_STATE_HANDLER( stateList[STATE_ATTACK1], attack1State )
	SET_STATE_HANDLER( stateList[STATE_WEAK1], weak1State )	
	SET_STATE_HANDLER( stateList[STATE_ATTACK2], attack2State )
	SET_STATE_HANDLER( stateList[STATE_ATTACK3], attack3State )
	SET_STATE_HANDLER( stateList[STATE_ATTACK4], attack4State )
	SET_STATE_HANDLER( stateList[STATE_ATTACK5], attack5State )
	SET_STATE_HANDLER( stateList[STATE_DEAD], deadState )
	
	return stateList
end,
}

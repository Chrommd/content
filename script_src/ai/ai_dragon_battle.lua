-- module setup
require('aihelper')

TAIL_PATTERN_S	= 1
TAIL_PATTERN_V		= 2
TAIL_PATTERN_A		= 3
TAIL_PATTERN_R		= 4

function THRUST_PLAYER(mob, player, velocity, time)
	if player ~= nil then
		local moveVec = GetDir(mob:GetPos(), player:GetPos())
		moveVec.x = moveVec.x * velocity
		moveVec.y = moveVec.y * velocity
		moveVec.z = moveVec.z * velocity
		mob:Thrust(player:GetObjID(), moveVec, time)
	end
end

function THRUST_ALL_PLAYER(mob, minVelocity, maxVelocity, time, checkDist)
	local playerCount = mgr:GetPlayerCount()-1
	for i=0,playerCount do
		local player = mgr:GetPlayerByIndex(i)
		if player ~= nil then
			local playerDist = mob:GetDist(player:GetPos())
			if playerDist <= checkDist then
				local velocity = maxVelocity - (maxVelocity-minVelocity)*playerDist/checkDist
				--print('vel = '..velocity..'\n')
				THRUST_PLAYER(mob, player, velocity, time)
			end
		end
	end
end

function GET_ATTACK_INFO(mob, info, index)

	if index==nil then
		local hpPercent = info.hp * 100 / info.hp_max
		
		for k,info in pairs(dragonAttackPhase) do
			local minValue = info.hp[1]
			local maxValue = info.hp[2]
			
			if hpPercent >= minValue and hpPercent <= maxValue then
				return k, info
			end
		end
	else
		return index, dragonAttackPhase[index]
	end
	
	return nil
end


function ATTACK_FIRE_SMASH(state, mob, info)
	
	local path = info.patrol_path
	local maxIndex = table.getn(path)
	
	-- FIRE_SMASH
	local attackIndex = state.pathIndex + 8
	attackIndex = attackIndex<=maxIndex and attackIndex or attackIndex-maxIndex+1
	
	local frontPos = path[attackIndex]							
	--local frontPos = GetFrontPos(mob:GetPos(), mob:GetDir(), 100);
	PLAY_MOTION( info, mob, MOTION_ATTACK1 )
	
	for i=1,12 do
		local firePos = v3( frontPos.x+RAND(-100,100)*0.1, frontPos.y, frontPos.z+RAND(-200,200)*0.1 )									
		USE_SKILL_POS(info, mob, "FIRE_SMASH", firePos)
	end
									
	state.lastAttacked = true									
	state.restoreMoveDelay = info.curTime + info.delayAttack1
end

function ATTACK_TAIL_SPLASH(state, mob, info, skillName, maxCount, skillPattern)

	local curCount = state.attackSkillSubCount			
	
	local path = info.patrol_path
	local maxIndex = table.getn(path)
		
	local attackIndex = state.pathIndex - 5		
	
	-- 새로운 패턴 지정하기
	if curCount==0 and not state.attackPattern then
		--local dice = RAND(1,4)
		--state.attackPattern = (dice==1 and TAIL_PATTERN_S or dice==2 and TAIL_PATTERN_V or dice==3 and TAIL_PATTERN_A or TAIL_PATTERN_R)		
		--state.attackPattern = TAIL_PATTERN_V
		
		if skillPattern=="S" then
			state.attackPattern = TAIL_PATTERN_S
		elseif skillPattern=="A" then
			state.attackPattern = TAIL_PATTERN_A
		elseif skillPattern=="V" then
			state.attackPattern = TAIL_PATTERN_V
		else
			state.attackPattern = TAIL_PATTERN_R
		end
		
		PLAY_MOTION( info, mob, MOTION_ATTACK3 )	
	end
	
	-- 패턴에 따른 공격
	local index = attackIndex + 5
	local index2 = attackIndex + 6
	local backPos = path[index<=maxIndex and index or index-maxIndex+1]
	local backPos2 = path[index2<=maxIndex and index2 or index2-maxIndex+1]
	local dir = GetDir(backPos, backPos2)
		
	if state.attackPattern == TAIL_PATTERN_S then		
		if backPos and backPos2 then
			local side = math.sin( curCount/maxCount*math.pi*1.5 )
			local firePos = GetLeftPos(backPos, dir, side*tailSplashAttackWidth)
			USE_SKILL_POS(info, mob, skillName, firePos)
		end
	elseif state.attackPattern == TAIL_PATTERN_V then
		if backPos and backPos2 then
			local side = curCount/maxCount*tailSplashAttackWidth
			local firePos = GetLeftPos(backPos, dir, side)
			USE_SKILL_POS(info, mob, skillName, firePos)
			
			firePos = GetRightPos(backPos, dir, side)
			USE_SKILL_POS(info, mob, skillName, firePos)
		end
	elseif state.attackPattern == TAIL_PATTERN_A then
		if backPos and backPos2 then
			local side = (1-curCount/maxCount)*tailSplashAttackWidth
			local firePos = GetLeftPos(backPos, dir, side)
			USE_SKILL_POS(info, mob, skillName, firePos)
			
			firePos = GetRightPos(backPos, dir, side)
			USE_SKILL_POS(info, mob, skillName, firePos)
		end
	elseif state.attackPattern==TAIL_PATTERN_R then
		for i=1,3 do
			local index = attackIndex + RAND(5,15)
			local backPos = path[index<=maxIndex and index or index-maxIndex+1]
			if backPos then
				local firePos = v3( backPos.x+RAND(-150,150)*0.1, backPos.y, backPos.z+RAND(-150,150)*0.1 )										
				USE_SKILL_POS(info, mob, skillName, firePos)
			end
		end
	end
	
	state.lastAttacked = true
	state.restoreMoveDelay = info.curTime + info.delayAttack3
	
	-- 현재 패턴은 끝
	if curCount+1 >= maxCount then
		state.attackPattern = nil
	end
end

function PROCESS_ATTACK(state, mob, info)

	local checkIndex = state.lastAttackPhase
	
	if state.attackSkillCount==0 and state.attackSkillSubCount==0 then
		checkIndex = nil
	end
	
	local phase, attackInfo = GET_ATTACK_INFO(mob, info, checkIndex)
	
	if phase and checkIndex and phase ~= checkIndex then
		state.attackSkill = 1
	end
	
	if attackInfo ~= nil then
		local skillMax		= table.getn(attackInfo.skill)
		local skillIndex	= (state.attackSkill-1) % skillMax + 1
		local curSkill		= attackInfo.skill[ skillIndex ]
		
		print('phase = '..phase..', '..skillIndex..' - '..state.attackSkillCount..' - '..state.attackSkillSubCount..'\n')	
	
		
		if curSkill then		
			local skillDelay	= curSkill[1]
			local skillName		= curSkill[2]
			local skillCount	= curSkill[3]
			local skillSubCount	= curSkill[4]
			local skillGapDelay	= curSkill[5]
			local skillSubDelay	= curSkill[6]
			local skillPattern	= curSkill[7]
			
			local prevSubCount = state.attackSkillSubCount
			
			if skillName=="TAIL_SPLASH" or skillName=="TAIL_SPLASH2" then
				ATTACK_TAIL_SPLASH(state, mob, info, skillName, skillSubCount, skillPattern)
			elseif skillName=="FIRE_SMASH" then
				ATTACK_FIRE_SMASH(state, mob, info)
			end
			
			state.attackSkillSubCount = state.attackSkillSubCount + 1
			
			state.attackTime = info.curTime + skillSubDelay
			
			if state.attackSkillSubCount >= skillSubCount then
				state.attackSkillSubCount = 0
				state.attackSkillCount = state.attackSkillCount + 1
				
				state.attackTime = info.curTime + skillGapDelay
				
				if state.attackSkillCount >= skillCount then
					state.attackSkillCount = 0
					state.attackSkill = state.attackSkill + 1
					
					state.attackTime = info.curTime + skillDelay
				end
			end		
			
		end
		
		if phase==table.getn(dragonAttackPhase) and state.lastAttackPhase ~= phase then
			mgr:AddStatus(mob:GetObjID(), PLAYERSTATUS_RAGE, 100000);
		end
		
		state.lastAttackPhase = phase
	end
end

function MOVE_FRONT_FAR( state, mob, info )

	local path = info.patrol_path
	local maxIndex = table.getn(path)
	
	
	local moveDist
	
	if state.nextBreathAttack then
		moveDist = moveFrontRoadDistanceBreathDash
	elseif state.breathAttack then
		moveDist = moveFrontRoadDistanceBreath
	else
		moveDist = moveFrontRoadDistanceDash
	end
	
	state.pathIndex = state.pathIndex + moveDist
	state.lastAttackPathIndex = state.pathIndex
	
	if state.pathIndex > maxIndex then
		state.pathIndex = state.pathIndex - maxIndex
	end
	
	if state.breathAttack then
		-- 좀 천천히 가자				
		if dragonVelocity ~= nil then
			mob:SetVelocity( dragonVelocity*0.5 )
		end
		
		PLAY_MOTION(info, mob, MOTION_ANI1)
		SET_DEFAULT_MOTION(info, mob, MOTION_ANI2, MOTION_ANI2)		
	else
		-- 좀 빨리 가자				
		if dragonVelocity ~= nil then
			mob:SetVelocity( dragonVelocity*3 )
		end
		
		PLAY_MOTION(info, mob, MOTION_DASH)	
	end
	
	local pos = path[state.pathIndex]						
	mob:Move( pos.x, pos.y+3, pos.z, true )
	
	state.moveFar = true
end

function ATTACK_BREATH(state, mob, info, curCount)
	local player = mgr:FindNearPlayer(mob)
	if player ~= nil then
		
		local path = info.patrol_path
		local maxIndex = table.getn(path)
		
		---local index = state.pathIndex - RAND(7,12)+curCount*2
		local p = player:GetPos()	--GetPredictPos(2)			
		local playerDist = mob:GetDist( p )
		local indexGap = math.floor(playerDist / 10)	-- 대략 10미터당 1 index?
			
		local index = state.pathIndex - indexGap
		local index2 = index + 1		
		index = index>=1 and index or maxIndex - index
		index2 = index2>=1 and index2 or maxIndex - index2
		index = index % (maxIndex+1)
		index2 = index2 % (maxIndex+1)
		
		--print('index='..index..'\n')
		
		local pos = path[index]
		local pos2 = path[index2]
		
		if pos~=nil and pos2~=nil then --and movePos~=nil then
		
			--pos.x = pos.x + RAND(-5,5)*curCount*0.5
			--pos.z = pos.z + RAND(-5,5)*curCount*0.5
			
			
			local vel = player:GetVelocity()
			local dir = GetDir(pos, pos2) --player:GetDir()
			local castTime = 0.1
			
			local castPos = v3(p.x + dir.x*vel*castTime, pos.y, p.z + dir.z*vel*castTime)
			
			local maxDist = mob:GetDist( castPos )
			local skillVel = 90
			local flyTime = maxDist / skillVel
			
			pos = v3(castPos.x+dir.x*vel*flyTime, pos.y, castPos.z+dir.z*vel*flyTime)
		
			--mob:LookAt(pos)
			
			-- Breath!
			PLAY_MOTION( info, mob, MOTION_ATTACK4 )
			
			local frontPos	= GetFrontPos(pos, mob:GetDir(), 5);
			local backPos	= GetBackPos(pos, mob:GetDir(), 5);
			local leftPos	= GetLeftPos(pos, mob:GetDir(), 5);
			local rightPos	= GetRightPos(pos, mob:GetDir(), 5);
			
			USE_SKILL_POS(info, mob, "FIRE_BREATH", frontPos)
			USE_SKILL_POS(info, mob, "FIRE_BREATH", backPos)
			USE_SKILL_POS(info, mob, "FIRE_BREATH", leftPos)
			USE_SKILL_POS(info, mob, "FIRE_BREATH", rightPos)							
			
			state.thrustTime = info.curTime + 2
			
			state.lastAttacked = true									
			state.restoreMoveDelay = info.curTime + info.delayAttack2
			
			state.attackCount = state.attackCount + 1
			
			if curCount==1 then
				SET_DELAY( info, info.delayAttack2 + 1 )
			else
				SET_DELAY( info, 0.5 )
			end
		
			--print('BREATH SKILL USE\n')						
		end
	end	
end

function CHECK_FIRE_BREATH(state, mob, info) 

	if state.lastAttackPhase then
		
		local phase, attackInfo = GET_ATTACK_INFO(mob, info, state.lastAttackPhase)
		
		if attackInfo and attackInfo.breathDamage then
		
			if state.attackCheckHP - info.hp >= attackInfo.breathDamage then
				state.attackCheckHP = info.hp
				
				return true
			end
		end
	end
	
	return false
end

function CHECK_DASH(state, mob, info) 

	if state.lastAttackPhase then
		
		local phase, attackInfo = GET_ATTACK_INFO(mob, info, state.lastAttackPhase)
		
		if attackInfo and attackInfo.dashDamage then
		
			if state.attackCheckHP - info.hp >= attackInfo.dashDamage then
				state.attackCheckHP = info.hp
				
				return true
			end
		end
	end
	
	return false
end

function PROCESS_SUMMON(state, mob, info, pos, pos2)
	if not NO_MONSTER then
		local dir = GetDir(pos, pos2)
		local hyenaPos = GetLeftPos(pos, dir, 7) -- v3(195.27, -10, -100)
		local hyena = mgr:CreateMob( "hyena_battle", "hyena_battle", hyenaPos )	
		hyena:LookAt( v3(hyenaPos.x, hyenaPos.y, hyenaPos.z+20) )
		
		local hyenaInfo = GET_MOB_INFO(hyena)
		if hyenaInfo ~= nil then 
			hyenaInfo.nextRunGap = v3( -10, 0, 95 )
		end
	end
	
	if not NO_MONSTER then
		local dir = GetDir(pos, pos2)
		local hyenaPos = GetRightPos(pos, dir, 7) --v3(182.08, -11.14, -91.24)
		local hyena = mgr:CreateMob( "hyena_battle", "hyena_battle", hyenaPos )	
		hyena:LookAt( v3(hyenaPos.x, hyenaPos.y, hyenaPos.z+20) )

		local hyenaInfo = GET_MOB_INFO(hyena)
		if hyenaInfo ~= nil then 
			hyenaInfo.nextRunGap = v3( 10, 0, 95 )
		end
	end
	
end

				
g_AIFactory["dragon_battle"] = 
{ 

onInit = function (info, mob)

	local playerCount = mgr:GetPlayerCount()		
	local configHP = mob:GetConfigHP(playerCount)

	if configHP > 0 then
		info.hp_max = configHP
		print('dragon configHP = '..configHP..'\n')
	else
		info.hp_max = 2000
		
		if bossHP ~= nil then
			info.hp_max = bossHP
		else
			if playerCount <= 0 then playerCount = 1 end
			info.hp_max = dragonBaseHP * playerCount 
		end
	end	
	
	info.hp		= info.hp_max	
	
	info.reflectAttackCount = 0	
	
	print('OnInit-')
end,

onSkillAttacked = function (info, mob, skillID, skillOID, damage, attackerID)
	local ret = false
	local defaultHandler = g_AIDefaultHandler.onSkillAttacked
	if defaultHandler ~= nil then
		ret = defaultHandler(info, mob, skillID, skillOID, damage, attackerID)
		
		if ret then
			if skillID == SKILLID_TAIL_SPLASH_REFLECT then
				info.reflectAttackCount = info.reflectAttackCount + 1 
			end
		end
	end	
	
	return ret
end,

onAddAfter = function (info, mob)
	mob:SetMoveType( MOVE_TYPE_FLYING )
	
	local scale = 1
	mob:Scale( scale, scale, scale )
	
	if dragonVelocity ~= nil then
		mob:SetVelocity(dragonVelocity)
	end
	
	print('OnInitAfter-')
end,

createState = function ()
	local stateList = {}
	stateList.motion = {}
	local motion = stateList.motion
	
	--                        { Name,			StateName,		aniDelay }
	motion[MOTION_IDLE]		= { name="Idle",	state="G_IDLE",	aniDelay=1 }
	motion[MOTION_ATTACK1]	= { name="Attack1",	state="MONANI_ATTACK_01",	aniDelay=0 }
	motion[MOTION_ATTACK2]	= { name="Attack2",	state="MONANI_ATTACK_02",	aniDelay=0 }
	motion[MOTION_ATTACK3]	= { name="Attack3",	state="MONANI_ATTACK_03",	aniDelay=0 }
	motion[MOTION_ATTACK4]	= { name="Attack4",	state="MONANI_ATTACK_04",	aniDelay=0 }
	motion[MOTION_MOVE]		= { name="Move",	state="MOVE_1ST",	aniDelay=0.1 }
	motion[MOTION_GLIDE]	= { name="Glide",	state="GLIDE",		aniDelay=1.3+2.6 }
	motion[MOTION_DASH]		= { name="Dash",	state="MONANI_01",	aniDelay=2.6 }	
	motion[MOTION_DEAD_START]= { name="DeadStart",	state="MONANI_DEAD_START", aniDelay=1.3+2.6 }
	motion[MOTION_ANI1]		= { name="BreathStart",	state="MONANI_02",		aniDelay=3.96 }
	motion[MOTION_ANI2]		= { name="BreathLoop",	state="MONANI_03",		aniDelay=2.63 }
	motion[MOTION_ANI3]		= { name="BreathEnd",	state="MONANI_04",		aniDelay=2.66 }
	motion[MOTION_ANI4]		= { name="Appear",	state="MONANI_05",		aniDelay=6.66 }
	
	
	stateList[STATE_IDLE]	= { name="Idle",	procDelay=0.2 }
	stateList[STATE_EVENT1]	= { name="Event1",	procDelay=0.2 }
	stateList[STATE_PATROL]	= { name="Patrol",	procDelay=0.1 }
	stateList[STATE_ATTACK]	= { name="Attack",	procDelay=4 }
	stateList[STATE_DEAD]	= { name="Dead",	procDelay=0.5 }

	
	-- 초기화 부분. local procState = { enter, process, leave }
	local idleState = 
	{	
		enter = function (state, mob, info) 
			PLAY_MOTION( info, mob, MOTION_IDLE )
		end,
		
		process = function (state, mob, info)
			NEXT_STATE( info, STATE_PATROL )
		end,
	}
	
	local openingState = 
	{	
		enter = function (state, mob, info) 
			PLAY_MOTION( info, mob, MOTION_ANI4 )
			state.sentEvent = false
		end,
		
		process = function (state, mob, info)
			if not state.sentEvent then			
				OnEvent( EVENT_SCRIPT, "server", SS_EVENT_ARRIVED, mob:GetObjID() )
				state.sentEvent = true
			end
		end,
	}
	
	local patrolState = 
	{
		enter = function (state, mob, info)
			if state.pathIndex == nil then
				state.pathIndex = 10
				
				if forcePatrolIndex ~= nil then
					state.pathIndex = forcePatrolIndex
					
					local pos = info.patrol_path[state.pathIndex]
					mob:ResetPos( pos.x, pos.y, pos.z )
				end
			end
			
			info.patrolDone = false
			
			local networkDelay = 0.3
			info.delayAttack1 = 1.3  - networkDelay
			info.delayAttack2 = 2.63 - networkDelay
			info.delayAttack3 = 1.98 - networkDelay
	
	
			--state.restoreMoveDelay = nil
			
			if not state.attackCount then
				state.attackCount = 0
			end
			
			if not state.lastAttackPathIndex then
				state.lastAttackPathIndex = 0
			end
			
			-- 용이 뒤로 미는것 테스트
			--local player = mgr:FindNearPlayer(mob)
			--if player ~= nil then
				--local moveVec = GetDir(mob:GetPos(), player:GetPos())
				--local moveDist = 9
				--moveVec.x = moveVec.x * moveDist
				--moveVec.y = moveVec.y * moveDist
				--moveVec.z = moveVec.z * moveDist
				--mob:Thrust(player:GetObjID(), moveVec, 100)
			--end
			
			state.attackRoadGap = 18
			state.summonTime = info.curTime + summonHyenaDelay	
			
			state.moveFar = false		
			
			state.attackTime = info.curTime + 10
			
			state.lastAttackPhase		= nil
			state.attackSkill			= 1
			state.attackSkillCount		= 0
			state.attackSkillSubCount	= 0
	
			state.attackCheckHP = info.hp
		end,
		

		process = function (state, mob, info)		
		
			local path = info.patrol_path
			if path ~= nil then
			
				if state.thrustTime ~= nil and info.curTime >= state.thrustTime then
					local maxVelocity	= 24
					local minVelocity	= 12								
					local time			= 0.5
					local checkDist		= 60
					THRUST_ALL_PLAYER(mob, minVelocity, maxVelocity, time, checkDist)								
					
					state.thrustTime = nil
				end
			
				if not BOSS_STOP and mob:IsArrived() then
				
					local maxIndex = table.getn(path)
					
					-- 한바퀴 다 돌았을 경우
					if state.pathIndex > maxIndex then
						state.pathIndex = state.pathIndex - maxIndex
					end
					
					if state.moveFar then					
						-- breath가 아니면 원래 속도로 돌려준다.
						if state.breathAttack~=true then
							if dragonVelocity ~= nil then
								mob:SetVelocity( dragonVelocity )
							end
						end
						
						state.moveFar = false						
						info.reflectAttackCount = 0
						
						if state.nextBreathAttack then
							state.nextBreathAttack = nil
							state.breathAttackCount = fireBreathCount
							state.breathAttack = true						
						
							MOVE_FRONT_FAR( state, mob, info )
							return
						end
					end
					
					-- 앞쪽까지 날아가서 브레스 쓸려는 상태
					if state.breathAttack then
						--print('BREATH GOGO\n')
						
						if state.breathAttackCount <= 0 then
							
							-- End breath
							if dragonVelocity ~= nil then
								mob:SetVelocity( dragonVelocity )
							end
							
							SET_DEFAULT_MOTION(info, mob, MOTION_IDLE, MOTION_MOVE)
							PLAY_MOTION(info, mob, MOTION_ANI3)
							state.breathAttack = nil
							
							return
						end
						
						ATTACK_BREATH(state, mob, info, state.breathAttackCount)
						
						state.breathAttackCount = state.breathAttackCount - 1
						--return
					end						
					
					local pos = path[state.pathIndex]
					local pos2 = path[state.pathIndex<maxIndex and state.pathIndex+1 or 1]
					
					if state.breathAttack~=true and state.lastAttacked then
					
						if not state.restoreMoveDelay or state.restoreMoveDelay and info.curTime >= state.restoreMoveDelay then
							PLAY_MOTION(info, mob, MOTION_MOVE)					
							state.lastAttacked = nil
							state.restoreMoveDelay = nil
						end
					end
					
					mob:Move( pos.x, pos.y+3, pos.z, true )
					
					--print('[dragon_path] move['..state.pathIndex..']( '..pos.x..', '..pos.y..', '..pos.z..' )\n')
					
					--if math.abs(state.lastAttackPathIndex - state.pathIndex) >= state.attackRoadGap  then 					
					
					
					-- 하이에나 소환 체크
					if state.breathAttack~=true and info.curTime >= state.summonTime then					
					
						PROCESS_SUMMON(state, mob, info, pos, pos2)
						
						state.summonTime = info.curTime + summonHyenaDelay
					end
					
					-- 3칸씩 전진.. 너무 띄엄가면 동작이 끊겨서;;
					state.pathIndex = state.pathIndex + 3
				
				end -- mob:IsArrived() 
				
				-- 도착과 관계없이 늘 체크하는 것
				if not BOSS_STOP and not state.breathAttack and not state.nextBreathAttack and not state.moveFar then
				
					-- 앞으로 대쉬할 타이밍인가?
					--if info.reflectAttackCount >= reflectBreathCount then
					if CHECK_DASH(state, mob, info) then
						info.reflectAttackCount = 0						
						
						MOVE_FRONT_FAR( state, mob, info )					
						return
					end
					
					-- FireBreath 타이밍인가?
					if CHECK_FIRE_BREATH(state, mob, info) then
						state.nextBreathAttack = true
						MOVE_FRONT_FAR( state, mob, info )						
					
					-- 공격할 타이밍인가?
					elseif info.curTime >= state.attackTime then
						
						PROCESS_ATTACK(state, mob, info)						
						
						state.attackCount = state.attackCount + 1
						state.lastAttackPathIndex = state.pathIndex
					end
				end
			else
				if not BOSS_STOP then				
					--NEXT_STATE( info, STATE_EVENT1 )
				end
			end
		end,
		
		leave = function (state, mob, info)
			info.patrolDone = true
		end
	}	
		
	local attackState = 
	{
		enter = function (state, mob, info)
			mob:Stop()
			
			if info.trace_id ~= nil then
				--print('trace_id = '..info.trace_id..'\n')
				local player = mgr:GetPlayer(info.trace_id)
				if player ~= nil then
					mob:LookAt(player:GetPos())
					PLAY_MOTION( info, mob, MOTION_FIRE )
					USE_SKILL(info, mob, "FIREBALL", player)
				end
			end
		end,
		
		process = function (state, mob, info)
			info.trace_id = nil
			NEXT_STATE( info, STATE_PATROL )
		end,
	}		
	
	local deadState =
	{
		enter = function (state, mob, info)
			PLAY_MOTION( info, mob, MOTION_DEAD_START )
			SET_DELAY( info, 11 )		
			state.alive = true
		end,
		
		process = function (state, mob, info)
			if state.alive then
				state.alive = false
				mob:Dead()
			end
		end,
	}
	
	SET_STATE_HANDLER( stateList[STATE_IDLE], idleState )
	SET_STATE_HANDLER( stateList[STATE_EVENT1], openingState )
	SET_STATE_HANDLER( stateList[STATE_PATROL], patrolState )
	SET_STATE_HANDLER( stateList[STATE_ATTACK], attackState )
	SET_STATE_HANDLER( stateList[STATE_DEAD], deadState )
	
	return stateList
end,

}
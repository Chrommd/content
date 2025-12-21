-- module setup
require('aihelper')


-- 1. 앞에서 frontAttackTime만큼 대기
-- 2. 옆으로 오면서 sideAttackTime만큼 대기
-- 3. 사라짐

frontAttackTime = 10
sideAttackTime	= hyenaSideAttackTime or 20


function RUN_ROAD(info, mob)
	if info.nextRunGap ~= nil then
		local player = mgr:FindNearPlayer(mob)
		if player ~= nil then				
			PLAY_MOTION( info, mob, MOTION_MOVE )
			mob:Run(player:GetObjID(), info.nextRunGap, false, 1)
		end
		
		--info.nextRunGap = nil
	end			
end

g_AIFactory['hyena_battle'] = 
{ 

onInit = function (info, mob)	

	local playerCount = mgr:GetPlayerCount()		
	local configHP = mob:GetConfigHP(playerCount)

	if configHP > 0 then
		info.hp_max = configHP
		print('hyena configHP = '..configHP..'\n')
	else	
		info.hp_max = 60
		
		if hyenaHP ~= nil then
			info.hp_max = hyenaHP
		end
	end
	
	info.hp		= info.hp_max
	
	info.attack_dist = 80
	--info.aiRange = 80
	
	info.attackTime = info.curTime
	info.frontAttackTime = frontAttackTime
	info.sideAttackTime = sideAttackTime
	info.attackCancel = false
	info.hasItem = true
end,

onAddAfter = function (info, mob)
	mob:Scale( 1,1,1 )
end,


onAttacked = function (info, mob, damage, attackerID)
	--local hp_prev = info.hp
	local defaultHandler = g_AIDefaultHandler.onAttacked
	if defaultHandler ~= nil then
		defaultHandler(info, mob, damage)
	end
	
end,

onSkillAttacked = function (info, mob, skillID, skillOID, damage, attackerID)
	local ret = false
	local defaultHandler = g_AIDefaultHandler.onSkillAttacked
	if defaultHandler ~= nil then
		ret = defaultHandler(info, mob, skillID, skillOID, damage, attackerID)
		
		if ret then
			--if skillID==SKILLID_MELEEATTACK or skillID==SKILLID_FORCE_FIELD then
			if info.hp > 0 then
			
				if skillID==SKILLID_CHARGEJUMP then
					ADD_DELAY(info, 1)
				else
					ADD_DELAY(info, 0.5)
				end
				
				mob:SetDelay( 0.5 )
				mob:InterruptSkill()
				info.attackCancel = true
			elseif info.hasItem then
				print('dead spawn\n')
				OnEvent( EVENT_SCRIPT, "server", SS_EVENT_MONSTER_DEAD, mob:GetObjID() )
				info.hasItem = false
			end
			--end		
		end
	end	
	
	return ret
end,

createState = function ()
	local stateList = {}
	stateList.motion = {}
	local motion = stateList.motion

	
	--                        { Name,			StateName,			aniDelay }
	motion[MOTION_IDLE]		= { name='Idle',	state='IDLE',		aniDelay=1 }
	motion[MOTION_ATTACK]	= { name='Attack',	state='ATTACK',		aniDelay=1 }
	motion[MOTION_MOVE]		= { name='Move',	state='MOVE_1ST',	aniDelay=0.5 }
	motion[MOTION_ATTACKED]	= { name='Attacked',state='DAMAGE',		aniDelay=1 }
	motion[MOTION_DEAD]		= { name='Dead',	state='DEAD',		aniDelay=5 }

	stateList[STATE_IDLE]	= { name='Idle',	procDelay=0.01}
	stateList[STATE_ATTACK1]= { name='Attack1',	procDelay=0.2}
	stateList[STATE_ATTACK2]= { name='Attack2',	procDelay=0.2}
	stateList[STATE_HIDE]	= { name='Hide',	procDelay=0.2}
	stateList[STATE_DEAD]	= { name='Dead',	procDelay=0.2}
	
	-- 초기화 부분. local procState = { enter, process, leave }	
	local idleState =
	{
		enter = function (state, mob, info) 
			-- 일단 달려~
			-- 지정된 위치로 달려간다.
			RUN_ROAD(info, mob)			
		end,
		
		process = function (state, mob, info)
			--NEXT_STATE( info, STATE_ATTACK1 )
			NEXT_STATE( info, STATE_ATTACK2 )			
		end,
	}
	
	local frontAttackState =
	{
		enter = function (state, mob, info) 
			state.nextStateTime = info.curTime + info.frontAttackTime
			state.attackTime = info.curTime + 5
		end,
		
		process = function (state, mob, info)
		
			if info.curTime >= state.nextStateTime then
				NEXT_STATE( info, STATE_ATTACK2 )
			end
			
			-- 미사일 공격~			
			if info.curTime >= state.attackTime then
				local player = mgr:FindNearPlayer(mob)
				if player ~= nil then				 
					USE_SKILL(info, mob, "ARROW", player)
					PLAY_MOTION( info, mob, MOTION_ATTACK )
					SET_DELAY( info, 2 )
				end
				
				state.attackTime = info.curTime + 4
			end
			
		end,
	}	
	
	local sideAttackState =
	{
		enter = function (state, mob, info) 
			state.nextStateTime = info.curTime + info.sideAttackTime
			state.moveTime = info.curTime + 1
			state.attackTime = nil
		end,
		
		process = function (state, mob, info)
		
			if info.attackCancel and state.attackTime then
				state.attackTime = nil
				info.attackCancel = nil
			end
						
			-- 이동 시간
			if info.curTime >= state.moveTime then
			
				if state.attacked then
					--PLAY_MOTION( info, mob, MOTION_MOVE  )
					--RUN_ROAD(info, mob)
					state.attacked = false
					state.moveTime = info.curTime + 2
					return
				end			
			
				local player = mgr:FindNearPlayer(mob)
				if player ~= nil then		
					
					local gapPos
					if IsInLeft( player:GetPos(), player:GetDir(), mob:GetPos() ) then
						gapPos = v3(-3, 0, 2)
					else
						gapPos = v3(3, 0, 2)
					end
					
					PLAY_MOTION( info, mob, MOTION_MOVE )
					--mob:Run(player:GetObjID(), gapPos, true, 1)
					mob:Trace(player:GetObjID())
					info.trace_id = player:GetObjID()
					
					-- 잠시 후에 다가가서 때린다.
					state.attackTime = info.curTime + 3
					
					-- 3초당 한번씩 따라가기
					state.moveTime = info.curTime + 4					
				end
			elseif info.trace_id ~= nil and state.attackTime~=nil and info.curTime > state.attackTime then
				--print('attack\n')
				PLAY_MOTION( info, mob, MOTION_ATTACK )
				ATTACK(info, mob, info.trace_id)
				
				--local player = mgr:FindNearPlayer(mob)
				--if player ~= nil then		
				--	local movePos = v3(0,0,10)
				--	mob:MovingAttack(info.trace_id, movePos, 0.5, 0.6, 0)					
				--end
				
				SET_DELAY( info, 1.1 )
				
				state.attacked = true
				state.attackTime = nil
				info.trace_id = nil
			end
			
			if info.curTime >= state.nextStateTime then				
				NEXT_STATE( info, STATE_HIDE )				
			end
			
		end,
	}	
	
	local hideState =
	{
		enter = function (state, mob, info) 
			local player = mgr:FindNearPlayer(mob)
			if player ~= nil then				
				PLAY_MOTION( info, mob, MOTION_MOVE )
				mob:Run(player:GetObjID(), v3(0,0,0), false, 1)
			end
			
			SET_DELAY( info, 3 )
		end,
		
		process = function (state, mob, info)
			if not state.hiddden then
				mob:Dead()
				state.hiddden = true
			end
		end
	}
	
		
	SET_STATE_HANDLER( stateList[STATE_IDLE], idleState )
	SET_STATE_HANDLER( stateList[STATE_ATTACK1], frontAttackState )
	SET_STATE_HANDLER( stateList[STATE_ATTACK2], sideAttackState )
	SET_STATE_HANDLER( stateList[STATE_HIDE], hideState )
	SET_STATE_HANDLER( stateList[STATE_DEAD], g_AISample.deadStateMotionIm )
	
	return stateList
end,
}

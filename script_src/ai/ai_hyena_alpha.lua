-- module setup
require('aihelper')


g_AIFactory['hyena_alpha'] = 
{ 

onInit = function (info, mob)	
	info.hp_max = 200
	info.hp		= info.hp_max
	
	info.attack_dist = 50
end,

onAddAfter = function (info, mob)
	mob:Scale( 2,2,2 )
	info.summon = false
	info.summonCasting = false		
end,

onAttacked = function (info, mob, damage, attackerID)

	local defaultHandler = g_AIDefaultHandler.onAttacked
	if defaultHandler ~= nil then
		defaultHandler(info, mob, damage, attackerID)
	end
	
	--print('attack change target :'..info.trace_id..' --> '..attackerID..'\n')
	info.lastAttackerID = attackerID
end,

onSkillAttacked = function (info, mob, skillOID, damage, attackerID)
	local defaultHandler = g_AIDefaultHandler.onSkillAttacked
	if defaultHandler ~= nil then
		defaultHandler(info, mob, skillOID, damage, attackerID)
	end
	
	--print('skill change target :'..info.trace_id..' --> '..attackerID..'\n')
	info.lastAttackerID = attackerID
end,

createState = function ()
	local stateList = {}
	stateList.motion = {}
	local motion = stateList.motion

	
	--                        { Name,			StateName,			aniDelay }
	motion[MOTION_IDLE]		= { name='Idle',	state='IDLE',		aniDelay=1 }
	motion[MOTION_ATTACK]	= { name='Attack',	state='ATTACK',		aniDelay=2 }
	motion[MOTION_MOVE]		= { name='Move',	state='MOVE_1ST',	aniDelay=0.5 }
	motion[MOTION_ATTACKED]	= { name='Attacked',state='ATTACK',		aniDelay=0.2 }
	motion[MOTION_DEAD]		= { name='Dead',	state='DEAD',		aniDelay=5 }

	stateList[STATE_IDLE]	= { name='Idle',	procDelay=0.2}
	stateList[STATE_FOLLOW]	= { name='Follow',	procDelay=0.2}
	stateList[STATE_LEAD]	= { name='Lead',	procDelay=0.2}
	stateList[STATE_DEAD]	= { name='Dead',	procDelay=0.2}
	
	-- 초기화 부분. local procState = { enter, process, leave }
	local idleState = 
	{	
		enter = function (state, mob, info) 
			--mob:Move(mob:GetPos())
			PLAY_MOTION( info, mob, MOTION_IDLE )
		end,
		
		process = function (state, mob, info)
				
			local npc = FIND_NEAR_MOB( info, mob, g_Game.npclist )
			if npc ~= nil and npc:GetHP() > 0 then
				info.trace_id = npc:GetObjID()
				NEXT_STATE( info, STATE_FOLLOW )
				return
			end
		
			local player = mgr:FindNearPlayer(mob)
			if player ~= nil and player:GetHP() > 0 then
				info.trace_id = player:GetObjID()
				NEXT_STATE( info, STATE_FOLLOW )
			end
		end,
	}
	
	local followState =
	{
		enter = function (state, mob, info) 
			-- do nothing
		end,
		
		process = function (state, mob, info)
			if info.trace_id == nil then
				NEXT_STATE( info, STATE_IDLE )
			end
			
			local sameTarget = true
			if info.lastAttackerID ~= nil and info.lastAttackerID ~= info.trace_id then
				info.trace_id = info.lastAttackerID
				info.lastAttackerID = nil
				sameTarget = false
			end
			
			local npc = mgr:GetMob(info.trace_id)
			if npc ~= nil and npc:GetHP() > 0 then
				-- Attack NPC
				if sameTarget and mob:IsNearPos( npc:GetPos(), 5 ) then
					-- 한 대 때리고
					PLAY_MOTION( info, mob, MOTION_ATTACK )
					ATTACK(info, mob, info.trace_id)
				else
					mob:Trace(info.trace_id)
				end
			else			
				-- Attack PLAYER
				local player = mgr:GetPlayer(info.trace_id)
				if player ~= nil and player:GetHP() > 0 then
					if sameTarget and mob:IsNearPos( player:GetPos(), 5 )  then
					
						-- 한 대 때리고
						PLAY_MOTION( info, mob, MOTION_ATTACK )
						ATTACK(info, mob, info.trace_id)
						
						-- 앞서가는 상태로 변경
						NEXT_STATE( info, STATE_LEAD )
					else
						--PLAY_MOTION( info, mob, MOTION_MOVE  )
						mob:Trace(info.trace_id)
					end
				else
					info.trace_id = nil
				end
			end					
		end,
	}		
		
	
	local leadState =
	{
		enter = function (state, mob, info) 
			state.attackTime = info.curTime + 5
		end,
		
		process = function (state, mob, info)
			if info.trace_id == nil then
				NEXT_STATE( info, STATE_IDLE )
			end
			
			local sameTarget = true
			if info.lastAttackerID ~= nil and info.lastAttackerID ~= info.trace_id then
				info.trace_id = info.lastAttackerID
				info.lastAttackerID = nil
				sameTarget = false
			end
			
			-- SUMMON : HP 50%
			if not info.summon and info.hp*2 <= info.hp_max then
				if not state.summonCasting then
					PLAY_MOTION( info, mob, MOTION_ATTACK )
					USE_SKILL(info, mob, "SUMMON", mob)
					state.summonCasting = true
					return
				else
					print('summon!!\n')
					mgr:CreateMob( "hyena2", "hyena3", mob:GetPos() )	
					mgr:CreateMob( "hyena2", "hyena3", mob:GetPos() )	
					
					info.summon = true
					SET_DELAY(info, 2)
					return
				end
			end
			
			local player = mgr:GetPlayer(info.trace_id)
			if player ~= nil and player:GetHP() > 0 then				
				if sameTarget and mob:IsNearPos( player:GetPos(), 30 ) then
				
					if info.curTime >= state.attackTime then
						USE_SKILL(info, mob, "ARROW", player)
						PLAY_MOTION( info, mob, MOTION_ATTACK )
						
						state.attackTime = info.curTime + 5
					else
						-- 적당한 거리이면 앞서나간다.
						--PLAY_MOTION( info, mob, MOTION_MOVE  )
						mob:Lead(info.trace_id)
					end
				else
					-- 멀다면? 쫓아간다.
					NEXT_STATE( info, STATE_FOLLOW )
				end
			else
				info.trace_id = nil
			end
		end,
	}

		
	SET_STATE_HANDLER( stateList[STATE_IDLE], idleState )
	SET_STATE_HANDLER( stateList[STATE_LEAD], leadState )
	SET_STATE_HANDLER( stateList[STATE_FOLLOW], followState )
	SET_STATE_HANDLER( stateList[STATE_DEAD], g_AISample.deadState )
	
	return stateList
end,
}

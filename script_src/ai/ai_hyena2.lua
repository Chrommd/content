-- module setup
require('aihelper')


g_AIFactory['hyena2'] = 
{ 

onInit = function (info, mob)	
	info.hp_max = 60
	
	if hyenaHP ~= nil then
		info.hp_max = hyenaHP
	end
	
	info.hp		= info.hp_max
	
	info.attack_dist = 80
	--info.aiRange = 80
	
	info.attackReady = false
	info.attackTime = info.curTime
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
	--local hp_cur = info.hp
	--
	--if hp_prev > 50 and hp_cur <= 50 then
		--mob:DetachPart(5)
	--elseif hp_prev > 40 and hp_cur <= 40 then
		--mob:DetachPart(4)
	--elseif hp_prev > 30 and hp_cur <= 30 then
		--mob:DetachPart(3)
	--elseif hp_prev > 20 and hp_cur <= 20 then
		--mob:DetachPart(2)
	--elseif hp_prev > 10 and hp_cur <= 10 then
		--mob:DetachPart(1)
	--end
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
				info.attackReady = false
			elseif not info.attacked then
				OnEvent( EVENT_SCRIPT, "server", SS_EVENT_ATTACK_OBJECT, mob:GetObjID() )
				info.attacked = true
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
	motion[MOTION_ATTACK]	= { name='Attack',	state='ATTACK',		aniDelay=2 }
	motion[MOTION_MOVE]		= { name='Move',	state='MOVE_1ST',	aniDelay=0.5 }
	motion[MOTION_ATTACKED]	= { name='Attacked',state='DAMAGE',		aniDelay=1 }
	motion[MOTION_DEAD]		= { name='Dead',	state='DEAD',		aniDelay=5 }

	stateList[STATE_IDLE]	= { name='Idle',	procDelay=0.2}
	stateList[STATE_FOLLOW]	= { name='Follow',	procDelay=0.2}
	stateList[STATE_DEAD]	= { name='Dead',	procDelay=0.2}
	
	-- 초기화 부분. local procState = { enter, process, leave }	
	local followState =
	{
		enter = function (state, mob, info) 
			-- do nothing
			PLAY_MOTION( info, mob, MOTION_MOVE  )
			state.attacked = false			
		end,
		
		process = function (state, mob, info)
			if info.trace_id == nil then
				NEXT_STATE( info, STATE_IDLE )
			end
			
			local player = mgr:GetPlayer(info.trace_id)
			if player ~= nil and player:GetHP() > 0 and not player:HasStatus(PLAYERSTATUS_PETRIFY) then
				if info.ignore_dist or mob:IsNearPos(player:GetPos(), info.attack_dist) then
					if mob:IsNearPos( player:GetPos(), 5 ) then
					
						if info.attackReady and info.curTime >= info.attackTime then
							PLAY_MOTION( info, mob, MOTION_ATTACK )
							ATTACK(info, mob, info.trace_id)
							state.attacked = true
							info.attackReady = false
							
						elseif not info.attackReady then
							info.attackReady = true
							info.attackTime = info.curTime + 1							
						end
					else
						if state.attacked then
							PLAY_MOTION( info, mob, MOTION_MOVE  )
							state.attacked = false
						end
						mob:Trace(info.trace_id)
					end
				else
					info.trace_id = nil
				end
			else
				info.trace_id = nil
			end
		end,
	}		
		
	SET_STATE_HANDLER( stateList[STATE_IDLE], g_AIStateFactory.FindNearPlayer(MOTION_IDLE, STATE_FOLLOW) )
	SET_STATE_HANDLER( stateList[STATE_FOLLOW], followState )
	SET_STATE_HANDLER( stateList[STATE_DEAD], g_AISample.deadStateMotionIm )
	
	return stateList
end,
}

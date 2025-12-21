-- module setup
require('aihelper')

attackerSlowDelayTime = 30

g_AIFactory['teambase'] = 
{

onInit = function (info, mob)
	info.hp_max = 1000000
	info.hp		= info.hp_max	
	info.active = true
end,

onAddAfter = function (info, mob)
	--mob:Scale( 2, 2, 2 )	
end,

onAdjustDamage = function (info, mob, skillID, damage)
	if mob:HasStatus(PLAYERSTATUS_INVINCIBLE) then
		return 0
	end
	
	return damage
end,

onSkillAttacked = function (info, mob, skillID, skillOID, damage, attackerID)
	local ret = false
	
	if damage>0 then 
		if g_AIDefaultHandler.onSkillAttacked ~= nil then
			ret = g_AIDefaultHandler.onSkillAttacked(info, mob, skillID, skillOID, damage, attackerID)
		end	
	end
	
	return ret
end,

createState = function ()
	local stateList = {}
	stateList.motion = {}
	local motion = stateList.motion
	
	--                        { Name,			StateName,			aniDelay }
	motion[MOTION_IDLE]	= { name='Idle',	state='G_IDLE',	aniDelay=1 }
	motion[MOTION_DEAD]	= { name='Dead',	state='DEAD',	aniDelay=2.5 }
			
	stateList[STATE_IDLE]	= { name='Idle',	procDelay=0.2 }
	stateList[STATE_WAIT]	= { name='Wait',	procDelay=0.2 }
	stateList[STATE_ATTACK]	= { name='Attack',	procDelay=0.2 }
	stateList[STATE_DEAD]	= { name='Dead',	procDelay=0.2}
	
	-- 초기화 부분. local procState = { enter, process, leave }
	local idleState = 
	{	
		enter = function (state, mob, info) 
			PLAY_MOTION( info, mob, MOTION_IDLE )
		end,
		
		process = function (state, mob, info)			
			mgr:AddStatus(mob:GetObjID(), PLAYERSTATUS_INVINCIBLE, 100000);
			NEXT_STATE( info, STATE_WAIT )
		end,
	}
	
	local waitState = 
	{	
		enter = function (state, mob, info) 
			
		end,
		
		process = function (state, mob, info)			
		end,
	}
	
	local attackState = 
	{	
		enter = function (state, mob, info) 			
		end,
		
		process = function (state, mob, info)			
			--USE_SKILL(info, mob, "SOULLINK", boss)
		end,
		
	}

	SET_STATE_HANDLER( stateList[STATE_IDLE], idleState )
	SET_STATE_HANDLER( stateList[STATE_WAIT], waitState )
	SET_STATE_HANDLER( stateList[STATE_ATTACK], attackState )
	SET_STATE_HANDLER( stateList[STATE_DEAD], g_AISample.deadStateMotionIm )
	
	return stateList
end,
}


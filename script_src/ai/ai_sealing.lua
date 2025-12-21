-- module setup
require('aihelper')

attackerSlowDelayTime = 30

g_AIFactory['sealing'] = 
{

onInit = function (info, mob)
	info.hp_max = 30
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
	
	-- TODO: 일단 바실 스킬은 빼는데.. 공격자를 넘겨받아서 체크를 해야할듯
	if skillID==SKILLID_BODY_PRESS or skillID==SKILLID_FIREWAVE or skillID==SKILLID_VOLCANO or skillID==SKILLID_SOULTOUCH then
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
		
		-- 공격자는 SLOW
		local player = mgr:GetPlayer(attackerID)
		if player ~= nil and not player:HasStatus(PLAYERSTATUS_SLOW) then
			mgr:AddStatus(attackerID, PLAYERSTATUS_SLOW, attackerSlowDelayTime)
			g_Game.aggrTargetID = attackerID		
		end
		
		-- 무적 풀림 테스트
		--mgr:RemoveStatus(mob:GetObjID(), PLAYERSTATUS_INVINCIBLE);
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
			mgr:RemoveStatus(mob:GetObjID(), PLAYERSTATUS_INVINCIBLE);
			mob:Scale( 1.5, 1.5, 1.5 );
			
			SET_DELAY( info, 0.2 )
		end,
		
		process = function (state, mob, info)			
			if g_Game.bossID ~= nil then
				local boss = mgr:GetMob(g_Game.bossID)
				if boss ~= nil and boss:GetHP()>0 then 
					USE_SKILL(info, mob, "SOULLINK", boss)
					--SET_DELAY( info, 5 )
					NEXT_STATE( info, STATE_WAIT )
				end
			end	
		end,
		
		leave = function (state, mob, info)
			--mob:Scale( 1, 1, 1 )
		end,
	}

	SET_STATE_HANDLER( stateList[STATE_IDLE], idleState )
	SET_STATE_HANDLER( stateList[STATE_WAIT], waitState )
	SET_STATE_HANDLER( stateList[STATE_ATTACK], attackState )
	SET_STATE_HANDLER( stateList[STATE_DEAD], g_AISample.deadStateMotionIm )
	
	return stateList
end,
}


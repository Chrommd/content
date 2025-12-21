-- module setup
require('aihelper')


g_AIFactory['basilisk'] = 
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
	
	info.attack_dist = 100
	info.entrance = false
end,

onAddAfter = function (info, mob)
	mob:Scale( 0.2, 0.2, 0.2 )
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

onSkillAttacked = function (info, mob, skillID, skillOID, damage, attackerID)
	local defaultHandler = g_AIDefaultHandler.onSkillAttacked
	if defaultHandler ~= nil then
		defaultHandler(info, mob, skillID, skillOID, damage, attackerID)
	end
	
	--print('skill change target :'..info.trace_id..' --> '..attackerID..'\n')
	info.lastAttackerID = attackerID
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
	stateList[STATE_ATTACK1]= { name='Attack1',	procDelay=0.1}		
	stateList[STATE_DEAD]	= { name='Dead',	procDelay=0.2}
	
	-- 초기화 부분. local procState = { enter, process, leave }
	local idleState = 
	{	
		enter = function (state, mob, info) 
			mob:Stop()
			PLAY_MOTION( info, mob, MOTION_IDLE )
		end,
		
		process = function (state, mob, info)
			local player = mgr:FindNearPlayer(mob)
			if player ~= nil and mob:IsNearPos(player:GetPos(), info.attack_dist) then
				info.trace_id = player:GetObjID()
				NEXT_STATE( info, STATE_ATTACK1 )
			end
		end,
	}
	
	local attack1State =
	{
		enter = function (state, mob, info) 
			PLAY_MOTION( info, mob, MOTION_MOVE )
			state.lastMoved = true
		end,
		
		process = function (state, mob, info)
		
			if info.trace_id ~= nil then
				local player = mgr:GetPlayer(info.trace_id)
				if player ~= nil and mob:IsNearPos(player:GetPos(), info.attack_dist) then
					local pos = player:GetPos()
					
					if mob:IsNearPos(player:GetPos(), 5) then
						PLAY_MOTION( info, mob, MOTION_ATTACK4 )
						USE_SKILL_POS(info, mob, "BODY_HURRICANE", mob:GetPos())
						state.lastMoved = false
					else
						if not state.lastMoved then
							PLAY_MOTION( info, mob, MOTION_MOVE )
							state.lastMoved = true
						end
						mob:Move( pos.x, pos.y, pos.z )
						SET_DELAY( info, 0.5 )
					end
				else
					info.trace_id = nil
				end		
			else
				NEXT_STATE( info, STATE_IDLE )
			end
		end
	}
	
		
	SET_STATE_HANDLER( stateList[STATE_IDLE], idleState )
	SET_STATE_HANDLER( stateList[STATE_ATTACK1], attack1State )
	SET_STATE_HANDLER( stateList[STATE_DEAD], g_AISample.deadState )
	
	return stateList
end,
}

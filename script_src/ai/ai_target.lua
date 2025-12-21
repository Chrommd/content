-- module setup
require('aihelper')

g_AIFactory['target'] = 
{

onInit = function (info, mob)
	info.hp_max = 50
	info.hp		= info.hp_max	
	info.active = true
	info.attacked = false
	info.alive = true			
end,

onAddAfter = function (info, mob)
	mob:Scale( 4, 4, 4 )	
end,

onSkillAttacked = function (info, mob, skillID, skillOID, damage, attackerID)
	local ret = false
	
	if not info.attacked then --and skillID==SKILLID_MELEEATTACK then 
		--print('SKILLID_MELEEATTACK\n')
		if g_AIDefaultHandler.onSkillAttacked ~= nil then
			ret = g_AIDefaultHandler.onSkillAttacked(info, mob, skillID, skillOID, damage, attackerID)
			
			if info.hp <= 0 then	
				OnEvent( EVENT_SCRIPT, "server", SS_EVENT_ATTACK_OBJECT, mob:GetObjID() )
				info.attacked = true
				NEXT_STATE( info, STATE_DEAD )
			end
			
		end	
	else
		--print('not SKILLID_MELEEATTACK\n')
	end
	
	
	return ret
end,

createState = function ()
	local stateList = {}
	stateList.motion = {}
	local motion = stateList.motion
	
	--                        { Name,			StateName,			aniDelay }
	motion[MOTION_IDLE]	= { name='Idle',	state='G_IDLE',	aniDelay=1 }
	motion[MOTION_DEAD]	= { name='Dead',	state='BROKEN',	aniDelay=1.7 }
			
	stateList[STATE_IDLE]	= { name='Idle',	procDelay=0.2 }
	stateList[STATE_WAIT]	= { name='Wait',	procDelay=0.1 }
	stateList[STATE_DEAD]	= { name='Dead',	procDelay=0.2}
	
	-- 초기화 부분. local procState = { enter, process, leave }
	local idleState = 
	{	
		enter = function (state, mob, info) 
			PLAY_MOTION( info, mob, MOTION_IDLE )
		end,
		
		process = function (state, mob, info)			
			NEXT_STATE( info, STATE_WAIT )
		end,
	}
	
	local waitState = 
	{	
		enter = function (state, mob, info) 
			state.lookTime = info.curTime + 0.5
			state.moved = true --false			
			state.fired = false 
		end,
		
		process = function (state, mob, info)		
			
			if state.disappearTime ~= nil then
				if info.alive and info.curTime >= state.disappearTime then
					--info.alive = false
					--mob:Dead()	
					return
				end				

				-- 사라지기 2초 전에 미사일 발사
				--if not state.fired then					
					--if info.curTime+2.5 >= state.disappearTime then
						--local player = mgr:FindNearPlayer(mob)
						--if player ~= nil then	
							--mob:LookAt( player:GetPos() )									
							--USE_SKILL(info, mob, "ARROW", player)
							--state.fired = true
						--end
					--end
				--end
				
				return
			end
				
			if info.curTime >= state.lookTime then
			
				if not state.moved then
					local player = mgr:FindNearPlayer(mob)
					if player ~= nil and not mob:IsNearPos(player:GetPos(),5) and mob:IsNearPos(player:GetPos(),80) then
						mob:LookAt( player:GetPos() )					
						
						local pos = player:GetPos()
						pos.x = pos.x + RAND(-30,30)*0.1
						pos.z = pos.z + RAND(-30,30)*0.1
						mob:Move( pos.x, pos.y, pos.z )
						
						state.moved = true
					end
				else -- if state.moved then
					local player = mgr:FindNearPlayer(mob)
					if player ~= nil then
					
						if not mob:IsInFront(player:GetPos(), 180) then
							state.disappearTime = info.curTime + 3
						end					
						
					else
						state.disappearTime = info.curTime + 3						
					end
				end
				
				state.lookTime = info.curTime + 1				
			end				
		end,
	}	
	
	local deadState =
	{
		enter = function (state, mob, info)
			state.alive = true
			state.show = true
		end,
		
		process = function (state, mob, info)
			if info.alive then
				if state.alive then
					state.alive = false
					PLAY_MOTION( info, mob, MOTION_DEAD )				
				elseif state.show then
					state.show = false
					mob:Dead()
				end
			end
		end,
	}

	SET_STATE_HANDLER( stateList[STATE_IDLE], idleState )
	SET_STATE_HANDLER( stateList[STATE_WAIT], waitState )
	SET_STATE_HANDLER( stateList[STATE_DEAD], deadState )
	
	return stateList
end,
}


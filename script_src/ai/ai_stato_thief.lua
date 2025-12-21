-- module setup
require('aihelper')
require('missiontypes')

JUMP_DELAY		= 1
KNOCKBACK_DIST	= 8
PART_ID_CARROT	= 1

-- 당근 들고 튀는 스타토: 때리면 당근 뺏는다.
g_AIFactory['stato_thief'] = 
{

onInit = function (info, mob)
	info.hp_max = 100000
	info.hp		= info.hp_max	
end,

onAddAfter = function (info, mob)
	mob:SetMoveType( MOVE_TYPE_FLYING )
	mob:Scale( 5, 5, 5 )
end,

onSkillAttacked = function (info, mob, skillID, skillOID, damage, attackerID)
	local ret = false
	if g_Game.statoRunning then	
		if g_AIDefaultHandler.onSkillAttacked ~= nil then
			ret = g_AIDefaultHandler.onSkillAttacked(info, mob, skillID, skillOID, damage, attackerID)
		end	
	
		local info = GET_MOB_INFO(mob)
		if info ~= nil then
			local state = info.state[STATE_PATROL]
			--state.knockbackTime = info.curTime + 0.5
			
			local curVelocity = mob:GetVelocity()
			if mob ~= nil and mob:GetVelocity()>0 then 
				local newVelocity = RANGE( 10, curVelocity - 5, curVelocity )
				mob:SetVelocity( newVelocity )
				-- 2초간 속도 변환 안함
				g_Game.velocityLockTime = info.curTime + 2
			end
			
			if skillID==SKILLID_MELEEATTACK then
				--print('melee attacked!\n')
				mob:DetachPart(PART_ID_CARROT)
				OnEvent( EVENT_SCRIPT, "server", SC_EVENT_ACQUIRE_ITEM )
				if state.knockbackTime == nil then
					state.knockbackTime = info.curTime + 0.1
				end
			end
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
	motion[MOTION_MOVE]	= { name='Idle',	state='MOVE_1ST',	aniDelay=0.1 }
	motion[MOTION_ATTACK]	= { name='Idle',	state='ATTACK',	aniDelay=0 }
	
	stateList[STATE_IDLE]	= { name='Idle',	procDelay=0.2 }
	stateList[STATE_PATROL]	= { name='Patrol',	procDelay=0.1 }

	
	-- 초기화 부분. local procState = { enter, process, leave }
	local idleState = 
	{	
		enter = function (state, mob, info) 
			mob:Stop()
			PLAY_MOTION( info, mob, MOTION_IDLE )			
		end,
		
		process = function (state, mob, info)						
		end,
	}
		
	local patrolState = 
	{
		enter = function (state, mob, info)
		
			if state.pathIndex == nil then
				state.pathIndex = 1
				g_Game.statoRunning = true
				state.starCount = 0
			end
			
			state.statoJumpTime = info.curTime + JUMP_DELAY
			
		end,

		process = function (state, mob, info)
			local path = info.patrol_path
			local velocity = mob:GetDefaultVelocity()
			if path ~= nil and velocity > 0 then
			
				-- 맞아서 Knockback시 처리
				if state.knockbackTime ~= nil and info.curTime >= state.knockbackTime then
					local maxIndex = table.getn(path)				
					
					if state.pathIndex+3 <= maxIndex then
						state.pathIndex = state.pathIndex + KNOCKBACK_DIST
						local pos = path[state.pathIndex]
						
						--local player = mgr:GetPlayer(attackerID)
						--if player ~= nil then 
						--	mob:LookAt( player:GetPos() )
						--end
						mob:Knockback( pos.x, pos.y, pos.z, 1 )
						PLAY_MOTION(info, mob, MOTION_ATTACK)
						
						state.knockbackTime = nil
						state.carrotRegenTime = info.curTime + 1.5
						SET_DELAY( info, 0.5 )
					else
						state.knockbackTime = nil
					end
				
				-- Path 따라가기
				elseif mob:IsNearPos( mob:GetMovePos() ) then
				
					if not g_Game.statoRunning then					
						NEXT_STATE( info, STATE_IDLE )
						OnEvent( EVENT_SCRIPT, "server", SC_EVENT_MISSION_END_WAIT )
						return
					end
				
					local maxIndex = table.getn(path)
					
					-- 한바퀴 다 돌았을 경우
					if state.pathIndex > maxIndex then
						state.pathIndex = 1
						g_Game.statoRunning = false
						return
					end
					
					local pos = path[state.pathIndex]
					
					--PLAY_MOTION(info, mob, MOTION_MOVE)
					mob:Move( pos.x, pos.y, pos.z )
					
					state.pathIndex = state.pathIndex + 1
				end
				
				if state.carrotRegenTime ~= nil and info.curTime >= state.carrotRegenTime then
					mob:AttachPart(PART_ID_CARROT)
					state.carrotRegenTime = nil
				end
				
				if info.curTime >= state.statoJumpTime then
					state.starCount = state.starCount + 1
					
					PLAY_MOTION(info, mob, MOTION_ATTACK)
					state.obstacleCreateTime = info.curTime + 0.2
					state.attackTime = info.curTime + 0.5
					state.statoJumpTime = info.curTime + JUMP_DELAY
				end
				
				if state.obstacleCreateTime ~= nil and info.curTime >= state.obstacleCreateTime then				
					
					local x = mob:GetPos().x + RAND(-40,40)*0.1
					local y = mob:GetPos().y
					local z = mob:GetPos().z + RAND(-40,40)*0.1
					mgr:CreateRuntimeObstacle( mob:GetObjID(), v3(x,y,z) )
					state.obstacleCreateTime = nil
				end
				
				if state.attackTime ~= nil and info.curTime >= state.attackTime then				
				
					local player = mgr:FindNearPlayer(mob)
					if player ~= nil then
						--USE_SKILL(info, mob, "ARROW", player)							
					end
					state.attackTime = nil
				end				
				
			end			
		end,
	}	

	SET_STATE_HANDLER( stateList[STATE_IDLE], idleState )
	SET_STATE_HANDLER( stateList[STATE_PATROL], patrolState )
	
	return stateList
end,
}

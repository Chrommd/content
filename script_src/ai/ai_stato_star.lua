-- module setup
require('aihelper')
require('missiontypes')

ITEM_SPAWN_DELAY = 1

-- 별 뿌리는 스타토
g_AIFactory['stato_star'] = 
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
			state.knockbackTime = info.curTime + 0.5			
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
	motion[MOTION_MOVE]	= { name='Move',	state='MOVE_1ST',	aniDelay=0.1 }
	motion[MOTION_ATTACK]	= { name='Attack',	state='ATTACK',	aniDelay=0 }
	
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
				state.manyPopup = 0
			end
			
			state.statoJumpTime = info.curTime + ITEM_SPAWN_DELAY
		end,

		process = function (state, mob, info)
			local path = info.patrol_path
			if path ~= nil then
			
				-- 맞아서 Knockback시 처리
				if state.knockbackTime ~= nil and info.curTime >= state.knockbackTime then
					local maxIndex = table.getn(path)				
					
					if state.pathIndex+3 <= maxIndex then
						state.pathIndex = state.pathIndex + 3					
						local pos = path[state.pathIndex]
						
						--local player = mgr:GetPlayer(attackerID)
						--if player ~= nil then 
						--	mob:LookAt( player:GetPos() )
						--end
						mob:Knockback( pos.x, pos.y, pos.z, 0.5 )
						PLAY_MOTION(info, mob, MOTION_ATTACK)
						
						state.manyPopupTime = info.curTime + 0.5
						state.manyPopup = 5
						state.knockbackTime = nil
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
				
				-- 별 쏟아내기
				if state.manyPopup ~= nil and state.manyPopup > 0 and info.curTime >= state.manyPopupTime then
					for i=1,5 do
						mgr:SpawnItem( mob:GetPos(), ITEM_CARROT, mob:GetObjID(), ITEM_SPAWN_STYLE_POPUP )
					end	
					state.manyPopupTime = 0
					state.manyPopup = 0		
					state.statoJumpTime = state.statoJumpTime + 2
				end				
			
				if info.curTime >= state.statoJumpTime then
					state.starCount = state.starCount + 1
					
					PLAY_MOTION(info, mob, MOTION_ATTACK)
					state.itemCreateTime = info.curTime + 0.2
					state.statoJumpTime = info.curTime + ITEM_SPAWN_DELAY
				end
				
				if state.itemCreateTime ~= nil and info.curTime >= state.itemCreateTime then				
					
					local spawnStyle
					if state.starCount % 4 == 0 then
						spawnStyle = ITEM_SPAWN_STYLE_DANGLE
					else
						spawnStyle = ITEM_SPAWN_STYLE_POPUP
					end
					
					local itemType = ITEM_CARROT
					
					mgr:SpawnItem( mob:GetPos(), itemType, mob:GetObjID(), spawnStyle )
					if state.starCount % 5 == 0 then
						mgr:SpawnItem( mob:GetPos(), itemType, mob:GetObjID(), spawnStyle )
					end
					state.itemCreateTime = nil
				end
			end			
		end,
	}	

	SET_STATE_HANDLER( stateList[STATE_IDLE], idleState )
	SET_STATE_HANDLER( stateList[STATE_PATROL], patrolState )
	
	return stateList
end,
}

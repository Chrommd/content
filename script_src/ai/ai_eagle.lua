-- module setup
require('aihelper')


g_AIFactory['eagle'] = 
{ 

onInit = function (info, mob)		
	info.runawayDistance = 20
	info.pivotPos = mob:GetPos()
end,

onAddAfter = function (info, mob)
	mob:SetMoveType( MOVE_TYPE_FLYING )
	--mob:Scale( 5,5,5 )
end,

createState = function ()
	local stateList = {}
	stateList.motion = {}
	local motion = stateList.motion

	
	--                        { Name,			StateName,			aniDelay }
	motion[MOTION_IDLE]		= { name='Idle',	state='IDLE',		aniDelay=1 }
	motion[MOTION_MOVE]		= { name='Move',	state='MOVE_1ST',	aniDelay=0.5 }
	motion[MOTION_ATTACK]	= { name='FlyStop',	state='FLY',		aniDelay=2 }

	stateList[STATE_IDLE]		= { name='Idle',	procDelay=0.2}
	stateList[STATE_WEAK1]	= { name='RunAway',	procDelay=0.2}
	
	local idleState =
	{
		enter = function (state, mob, info) 
		end,
		
		process = function (state, mob, info)
			local player = mgr:FindNearPlayer(mob)
			if player then
				local playerDist = mob:GetDist(player:GetPos())
				if playerDist < info.runawayDistance then					
					NEXT_STATE( info, STATE_WEAK1 )
				end
			end
		end,
	}

	local runawayState =
	{
		enter = function (state, mob, info) 
		
			-- 제자리에서 떠 오르기
			state.needFlyUp = true
			
			state.needFlyStopMotion = true
			state.needFlyIdleMotion = false
			state.flyDownTime = nil
			SET_DELAY(info, RAND(0,20)*0.01)
		end,
		
		process = function (state, mob, info)
		
			if state.needFlyUp then
				local pos = mob:GetPos()
				pos.x = info.pivotPos.x + RAND(-100,100)*0.05
				pos.y = pos.y + 10
				pos.z = info.pivotPos.z + RAND(-100,100)*0.05
				PLAY_MOTION(info, mob, MOTION_MOVE)
				mob:Move( pos.x, pos.y, pos.z )
				
				state.needFlyUp = false				
				return
			end
			
			if mob:IsArrived() then
				if state.needFlyStopMotion then
					PLAY_MOTION(info, mob, MOTION_ATTACK)
					state.needFlyStopMotion = false
					state.flyDownTime = info.curTime + RAND(7,10)
				end
				
				if state.needFlyIdleMotion then
					--PLAY_MOTION(info, mob, MOTION_IDLE)
					NEXT_STATE( info, STATE_IDLE )
					return
				end
				
				if state.flyDownTime~=nil and info.curTime >= state.flyDownTime then
				
					-- 다시 내려가기
					local pos = mob:GetPos()
					pos.x = info.pivotPos.x + RAND(-100,100)*0.05
					--pos.y = pos.y - 12	-- 약간 더 내려가도 땅에 맞춰준다.
					pos.z = info.pivotPos.z + RAND(-100,100)*0.05
					PLAY_MOTION(info, mob, MOTION_MOVE)
					
					local gpos = util:GetGroundPos(pos)
					mob:Move( gpos.x, gpos.y, gpos.z )
			
					state.needFlyIdleMotion = true					
				end
			end
		end,
	}
		
	SET_STATE_HANDLER( stateList[STATE_IDLE], idleState )
	SET_STATE_HANDLER( stateList[STATE_WEAK1], runawayState )
	
	return stateList
end,
}

-- module setup
require('aihelper')

g_AIFactory['obstacle'] = 
{

onInit = function (info, mob)
	info.hp_max = 100000
	info.hp		= info.hp_max	
	info.pivotPos = mob:GetPos()
	
	info.defaultVelocity = 1
	info.avoidVelocity	= 10
end,

onAddAfter = function (info, mob)

	local s = 2
	mob:Scale( s, s, s )
	mob:SetVelocity( info.defaultVelocity  )

end,

createState = function ()
	local stateList = {}
	stateList.motion = {}
	local motion = stateList.motion
	
	--                        { Name,			StateName,			aniDelay }
	motion[MOTION_IDLE]		= { name='Idle',	state='IDLE',		aniDelay=0.5 }
	motion[MOTION_JUMP]		= { name='Jump',	state='JUMP',		aniDelay=0.5 }
	
	stateList[STATE_IDLE]	= { name='Idle',	procDelay=0.2 }
	stateList[STATE_WEAK1]	= { name='Weak1',	procDelay=0.2 }

	
	-- 최초 정지 상태
	local idleState = 
	{	
		enter = function (state, mob, info)
			PLAY_MOTION( info, mob, MOTION_IDLE )
		end,
		
		process = function (state, mob, info)		
			NEXT_STATE( info, STATE_WEAK1 )			
		end,
	}
	
	-- 도망가기 모드
	local runawayState = 
	{	
		enter = function (state, mob, info)			
			state.moved = false
		end,
		
		process = function (state, mob, info)
			if not state.moved then
				local player = mgr:FindNearPlayer(mob)
				if player and mob:GetDist( player:GetPos() ) < 15 then

					state.moved = true
				
					local pos

					local pos1 = GetLeftPos(mob:GetPos(), player:GetDir(), RAND(10,12))		-- 왼쪽
					local pos2 = GetRightPos(mob:GetPos(), player:GetDir(), RAND(10,12))		-- 오른쪽
						
					local nextPos = player:GetPredictPos(0.5)		-- 1초 후 위치
						
					local dist1 = GetDist(pos1, nextPos)
					local dist2 = GetDist(pos2, nextPos)
						
					if dist1 > dist2 then
						pos = pos1
					else
						pos = pos2
					end
				
					pos.x = pos.x + RAND(-20,20)*0.1
					pos.z = pos.z + RAND(-20,20)*0.1

					local newPos
					if util~=nil and util.GetRoadPosition ~= nil then
						newPos = util:GetRoadPosition( mob:GetPos(), pos, 0.1, 2 )
					end
					
					if newPos == nil then
						newPos = pos
					end
					
					-- 이동 ㄱㄱ!
					if newPos~=nil then
						--mob:Move(newPos.x, newPos.y, newPos.z)
						mob:LookAt( player:GetPos() )
						mob:Knockback(newPos.x, newPos.y, newPos.z, 0.6, 0.1, KNOCKBACK_UPPER);
						mob:SetVelocity( info.avoidVelocity  )	
						PLAY_MOTION( info, mob, MOTION_JUMP )
					end
				end
			
			-- 도착했으면 원래대로
			elseif mob:IsArrived() then
				NEXT_STATE( info, STATE_IDLE )				
			end
		end,
		
		leave = function (state, mob, info)
			mob:SetVelocity( info.defaultVelocity  )
		end,
	}

	SET_STATE_HANDLER( stateList[STATE_IDLE], idleState )
	SET_STATE_HANDLER( stateList[STATE_WEAK1], runawayState )
	
	return stateList
end,
}

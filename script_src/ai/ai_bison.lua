-- module setup
require('aihelper')


g_AIFactory['bison'] = 
{ 

onInit = function (info, mob)	
	info.hp_max = 60	
	info.hp		= info.hp_max
	
	info.attack_dist = 100
	info.hit_dist = 2.5
	--info.aiRange = 80
end,

onAddAfter = function (info, mob)
	mob:Scale( 1.2, 1.2, 1.2 )
end,

createState = function ()
	local stateList = {}
	stateList.motion = {}
	local motion = stateList.motion

	
	--                        { Name,			StateName,			aniDelay }
	motion[MOTION_IDLE]		= { name='Idle',	state='IDLE',		aniDelay=0.2 }
	motion[MOTION_MOVE]		= { name='Move',	state='MOVE_1ST',	aniDelay=0.1 }
	
	stateList[STATE_IDLE]	= { name='Idle',	procDelay=0.2}
	stateList[STATE_FOLLOW]	= { name='Follow',	procDelay=0.2}
	stateList[STATE_DEAD]	= { name='Dead',	procDelay=0.2}
	
	-- 초기화 부분. local procState = { enter, process, leave }	
	local followState =
	{
		enter = function (state, mob, info) 
			-- do nothing
			state.attacked = false
			state.restTime = nil
		end,
		
		process = function (state, mob, info)

			if state.restTime ~= nil and info.curTime >= state.restTime then
				NEXT_STATE( info, STATE_IDLE )
				return
			end

			if info.trace_id == nil then
				NEXT_STATE( info, STATE_IDLE )
			end

			info.trace_id = util:GetMyOID()
			
			if not state.attacked then
				local player = mgr:GetPlayer(info.trace_id)
				if player ~= nil then
					if info.ignore_dist or mob:IsNearPos(player:GetPos(), info.attack_dist) then
						PLAY_MOTION( info, mob, MOTION_MOVE  )
			
						state.attacked = true
							
						local p = player:GetPos()
						
						local dist = GetDist(mob:GetPos(), p)
						local pos = GetFrontPosTo(mob:GetPos(), p, dist+RAND(10,20))

						pos.x = pos.x + RAND(-50, 50) * 0.1
						pos.z = pos.z + RAND(-50, 50) * 0.1
						mob:Move(pos.x, pos.y, pos.z, true)
					else
						info.trace_id = nil
					end
				else
					info.trace_id = nil
				end

				return

			elseif mob:IsArrived() then
				
				state.attacked = false
				state.restTime = nil
				--PLAY_MOTION( info, mob, MOTION_IDLE )

				--state.restTime = info.curTime + RAND(1,3)*0.1
			end

			local player = mgr:GetPlayer(info.trace_id)
			if player ~= nil then
				local dist = mob:GetDist(player:GetPos())

				if dist <= info.hit_dist then
					ATTACK(info, mob, info.trace_id)
					util:IncidentOther(INCIDENT_BALLOON_HIT, info.trace_id)
					PLAY_MOTION( info, mob, MOTION_IDLE )
					state.restTime = info.curTime + RAND(0,1)*0.1
				elseif dist >= 5 and not IsInFront(mob:GetPos(), mob:GetDir(), player:GetPos(), 180) then
					-- 지나쳤을때
					PLAY_MOTION( info, mob, MOTION_IDLE )
					state.restTime = info.curTime	-- + RAND(1,2)
				end
			end

		end,
	}		
		
	SET_STATE_HANDLER( stateList[STATE_IDLE], g_AIStateFactory.FindNearPlayer(MOTION_IDLE, STATE_FOLLOW) )
	SET_STATE_HANDLER( stateList[STATE_FOLLOW], followState )
	SET_STATE_HANDLER( stateList[STATE_DEAD], g_AISample.deadStateMotionIm )
	
	return stateList
end,
}

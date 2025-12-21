-- module setup
require('aihelper')


g_AIFactory['stato_intro'] = 
{

onInit = function (info, mob)
	info.hp_max = 100000
	info.hp		= info.hp_max	
end,

onAddAfter = function (info, mob)
	mob:Scale( 2, 2, 2 )
end,

createState = function ()
	local stateList = {}
	stateList.motion = {}
	local motion = stateList.motion
	
	--                        { Name,			StateName,			aniDelay }
	motion[MOTION_IDLE]		= { name='Idle',	state='G_IDLE',		aniDelay=1 }
	motion[MOTION_MOVE]		= { name='Move',	state='MOVE_1ST',	aniDelay=0.1 }
	motion[MOTION_ATTACK]	= { name='Attack',	state='ATTACK',		aniDelay=0 }
	
	stateList[STATE_IDLE]	= { name='Idle',	procDelay=0.2 }
	stateList[STATE_FOLLOW]	= { name='Follow',	procDelay=0.2 }
	stateList[STATE_PATROL]	= { name='Patrol',	procDelay=0.2 }

	
	-- 최초 정지 상태
	local idleState = 
	{	
		enter = function (state, mob, info) 
			PLAY_MOTION( info, mob, MOTION_IDLE )
		end,
		
		process = function (state, mob, info)
		
			if info.patrol_path then
				NEXT_STATE( info, STATE_PATROL )
			else
				NEXT_STATE( info, STATE_FOLLOW )
			end
		end,
	}
	
	-- 플레이어 따라다니기 테스트
	local followState = 
	{	
		enter = function (state, mob, info) 
			state.moveTiming = info.curTime
		end,
		
		process = function (state, mob, info)
			if mob:IsArrived() then
			
				-- 이동하다가 멈춘 경우
				if state.moving then
					PLAY_MOTION( info, mob, MOTION_IDLE )
					state.moving = false
					
					-- 다음 이동할 시간을 정한다.
					state.moveTiming = info.curTime + RAND(1,3)						
					
					-- 목적지 도착했을때 플레이어 한번 쳐다보기
					local player = mgr:FindNearPlayer(mob)
					if player then
						mob:LookAt(player:GetPos())
					end
				end
			
				-- 이동 딜레이가 끝났으면 --> 이동한다
				if info.curTime >= state.moveTiming then
					local player = mgr:FindNearPlayer(mob)
					if player then
						PLAY_MOTION( info, mob, MOTION_MOVE  )
						
						local pos
						local moveType = RAND(1,3)
						
						-- 적당히 랜덤하게 플레이어 근처 위치를 계산						
						if moveType==1 then
							pos = GetFrontPos(player:GetPos(), player:GetDir(), RAND(5,20))		-- 앞쪽
						elseif moveType==2 then
							pos = GetLeftPos(player:GetPos(), player:GetDir(), RAND(5,15))		-- 왼쪽
						else
							pos = GetRightPos(player:GetPos(), player:GetDir(), RAND(5,15))		-- 오른쪽
						end
						
						pos.x = pos.x + RAND(-10,10)
						pos.z = pos.z + RAND(-10,10)
						
						-- 이동 ㄱㄱ!
						mob:Move(pos.x, pos.y, pos.z)
						
						state.moving = true
					end
				end
			end
		end,
	}

	SET_STATE_HANDLER( stateList[STATE_IDLE], idleState )
	SET_STATE_HANDLER( stateList[STATE_FOLLOW], followState )
	SET_STATE_HANDLER( stateList[STATE_PATROL], g_AIStateFactory.SimplePatrol(STATE_IDLE) )
	
	return stateList
end,
}

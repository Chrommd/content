-- module setup
require('aihelper')


--BUILD_CONDITION({
--	{ info.patrol_path },	{ NEXT_STATE( info, STATE_PATROL ) },
--	{},						{ NEXT_STATE( info, STATE_ATTACK1 ) },
--})

g_AIFactory['impala'] = 
{

onInit = function (info, mob)
	info.hp_max = 100000
	info.hp		= info.hp_max	
	info.pivotPos = mob:GetPos()
	
	if info.defaultVelocity == nil then
		info.defaultVelocity = 8
	end	
	
	info.avoidDistance = 15
end,

onAddAfter = function (info, mob)

	--mob:Scale( s, s, s )
	mob:SetVelocity( info.defaultVelocity  )
end,

createState = function ()
	local stateList = {}
	stateList.motion = {}
	local motion = stateList.motion
	
	--                        { Name,			StateName,			aniDelay }
	motion[MOTION_IDLE]		= { name='Idle',	state='MONANI_01',	aniDelay=0.5 }
	motion[MOTION_MOVE]		= { name='Move',	state='G_IDLE',	aniDelay=0.1 }
	
	stateList[STATE_IDLE]	= { name='Idle',	procDelay=0.2 }
	stateList[STATE_ATTACK1]= { name='Move',	procDelay=0.1 }
	stateList[STATE_WEAK1]  = { name='Runaway',	procDelay=0.1 }

	
	-- 최초 정지 상태
	local idleState = 
	{	
		enter = function (state, mob, info) 
			state.randomDelay = info.curTime + RAND(0, 1.5)
		end,
		
		process = function (state, mob, info)
		
			if info.curTime >= state.randomDelay then
				PLAY_MOTION( info, mob, MOTION_IDLE )			
				NEXT_STATE( info, STATE_ATTACK1 )
			end
		end,
	}
	
	-- 그냥 혼자 놀기 모드
	local playState = 
	{	
		enter = function (state, mob, info) 
			state.moveTiming = info.curTime
		end,
		
		process = function (state, mob, info)
		
			-- 플레이어 가까우면 도망가기
			local player = mgr:FindNearPlayer(mob)
			if player then
				local distance = (player:GetVelocity()>10 and info.avoidDistance or info.avoidDistance/3)
				if mob:GetDist(player:GetPos()) < distance then
					NEXT_STATE( info, STATE_WEAK1 )
					return
				end
			end
					
			if mob:IsArrived() then
			
				-- 이동하다가 멈춘 경우
				if state.moving then
					PLAY_MOTION( info, mob, MOTION_IDLE )
					state.moving = false
					
					-- 다음 이동할 시간을 정한다.
					state.moveTiming = info.curTime + RAND(5,15)					
				end
			
				-- 이동 딜레이가 끝났으면 --> 이동한다
				if info.curTime >= state.moveTiming then
					local player = mgr:FindNearPlayer(mob)
					if player then
						
						local pos
						local moveType = RAND(1,3)
						
						-- 적당히 랜덤하게 원래 있던 근처 위치를 계산						
						if moveType==1 then
							pos = GetFrontPos(info.pivotPos, mob:GetDir(), RAND(5,20))		-- 앞쪽
						elseif moveType==2 then
							pos = GetLeftPos(info.pivotPos, mob:GetDir(), RAND(5,15))		-- 왼쪽
						else
							pos = GetRightPos(info.pivotPos, mob:GetDir(), RAND(5,15))		-- 오른쪽
						end
						
						pos.x = pos.x + RAND(-10,10)
						pos.z = pos.z + RAND(-10,10)
						
						local newPos = util:GetRoadPosition( mob:GetPos(), pos, 0.1, 2 )
						
						-- 이동 ㄱㄱ!
						if mob:Move(newPos.x, newPos.y, newPos.z) then
							PLAY_MOTION( info, mob, MOTION_MOVE  )
						end
						
						state.moving = true
					end
				end
			end
		end,
	}
	

	SET_STATE_HANDLER( stateList[STATE_IDLE], idleState )
	SET_STATE_HANDLER( stateList[STATE_ATTACK1], playState )
	SET_STATE_HANDLER( stateList[STATE_WEAK1], g_AIStateFactory.RunawayFromPlayer(MOTION_NONE, STATE_ATTACK1) )
	
	return stateList
end,
}

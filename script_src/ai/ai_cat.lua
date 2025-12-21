-- module setup
require('aihelper')


--BUILD_CONDITION({
--	{ info.patrol_path },	{ NEXT_STATE( info, STATE_PATROL ) },
--	{},						{ NEXT_STATE( info, STATE_ATTACK1 ) },
--})

CatPathList =
{
	-- 방목말 입구쪽에서 언덕 꼭대기 돼지까지
	{
		v3(-11.40, -0.34, -24.18),
		v3(-1.15, 0.05, -3.38),
		v3(31.99, -0.43, 0.74),
		v3(39.48, 4.65, -36.47),
		v3(44.60, 14.19, -80.12),
		v3(15.64, 14.03, -92.65),
		v3(-5.03, 15.69, -87.14),
		v3(-18.81, 16.38, -75.03),
	},

	-- 방목말 쪽에서 언덕 중간
	{
		v3(10.35, -0.08, -35.95),
		v3(-6.60, -0.23, -33.44),
		v3(-4.98, -0.12, -13.31),
		v3(19.05, -0.27, -5.21),
		v3(40.30, 4.53, -34.54),
		v3(29.55, 6.52, -48.12),
	},
	
	-- 울타리 근처
	{
		v3(-5.58, -0.15, -18.30),
		v3(-9.20, -0.29, -5.94),
		v3(3.38, -0.07, 11.31),
		v3(21.53, -0.31, 22.84),
		v3(46.05, -0.24, 13.29),
	},
	 
	-- 울타리 쪽에서 언덕 중간까지
	{
		v3(56.06, 0.15, -4.15),
		v3(42.27, -0.07, -6.08),
		v3(37.27, 4.44, -33.49),
		v3(44.70, 6.54, -46.52),
	},

	-- 스타토 근처부터 오른쪽 언덕 꼭대기까지
	{
		v3(58.33, 0.34, -6.59),
		v3(81.33, 0.26, -13.54),
		v3(106.91, 4.18, -15.39),
		v3(101.34, 10.20, -43.28),
		v3(82.26, 13.92, -65.01),
		v3(85.86, 15.14, -81.35),
	},

}


function MoveCatAround(info, mob, minDist, maxDist)
	local moveType = RAND(1,3)						
	local dist = RAND(minDist,maxDist)
	if moveType==1 then
		pos = GetFrontPos(info.pivotPos, mob:GetDir(), dist)		-- 앞쪽
	elseif moveType==2 then
		pos = GetLeftPos(info.pivotPos, mob:GetDir(), dist)		-- 왼쪽
	else
		pos = GetRightPos(info.pivotPos, mob:GetDir(), dist)		-- 오른쪽
	end
	
	pos.x = pos.x + RAND(-10,10)
	pos.z = pos.z + RAND(-10,10)
	
	local newPos = pos	--util:GetRoadPosition( mob:GetPos(), pos, 0.1, 2 )	
	-- 이동 ㄱㄱ!
	return mob:Move(newPos.x, newPos.y, newPos.z, true)
end	
	
g_AIFactory['cat'] = 
{

onInit = function (info, mob)
	info.hp_max = 100000
	info.hp		= info.hp_max	
	info.pivotPos = mob:GetPos()
	
	info.avoidVelocity		= 10
	info.defaultVelocity	= 0.7
	info.collisionDistance  = 2.5
	info.avoidDistance		= 10
	info.warningDistance	= 20
	info.approachDistance	= 40
	
	-- 돌아다니기 시작하는 딜레이
	info.goUsualPathDelayMin	= 50
	info.goUsualPathDelayMax	= 90
	
	info.movePathLimitDist		= 50		-- 돌아다닐 길까지의 최대 거리

end,

onAddAfter = function (info, mob)

	--mob:Scale( s, s, s )	
	mob:Scale( 0.4, 0.4, 0.4 )
	mob:SetVelocity( info.defaultVelocity  )
end,

createState = function ()
	local stateList = {}
	stateList.motion = {}
	local motion = stateList.motion
	
	--                        { Name,			StateName,			aniDelay }
	motion[MOTION_IDLE]		= { name='Idle',	state='IDLE',		aniDelay=0.5 }
	motion[MOTION_MOVE]		= { name='Move',	state='MOVE_1ST',	aniDelay=0.1 }
	motion[MOTION_MOVE2]	= { name='Move2',	state='MOVE_3RD',	aniDelay=0.1 }
	motion[MOTION_JUMP]		= { name='Jump',	state='JUMP',		aniDelay=0.3 }
	motion[MOTION_ATTACK1]= { name='Attack1',	state='MONANI_01',		aniDelay=1 }	
	motion[MOTION_COLLISION]= { name='Collision',	state='G_COLLISION',		aniDelay=0.8 }
	motion[MOTION_COLLISION_END]= { name='CollisionEnd',	state='G_COLLISION_END',		aniDelay=0.5 }
	
	stateList[STATE_IDLE]	= { name='Idle',	procDelay=0.2 }
	stateList[STATE_PATROL]	= { name='Patrol',	procDelay=0.2 }
	stateList[STATE_ATTACK1]= { name='Attack1',	procDelay=0.1 }
	stateList[STATE_EVENT1]	= { name='MovePath',procDelay=0.2 }
	stateList[STATE_WEAK1]	= { name='RunAway',	procDelay=0.2 }
	stateList[STATE_WEAK2]	= { name='Warning',	procDelay=0.2 }

	
	-- 최초 정지 상태
	local idleState = 
	{	
		enter = function (state, mob, info) 
			mob:SetVelocity( info.defaultVelocity  )
			state.randomDelay = info.curTime + RAND(0, 1.5)
		end,
		
		process = function (state, mob, info)
		
			if info.curTime >= state.randomDelay then
				PLAY_MOTION( info, mob, MOTION_IDLE )
			
				if info.patrol_path then
					NEXT_STATE( info, STATE_PATROL )
				else
					NEXT_STATE( info, STATE_ATTACK1 )
				end
			end
		end,
	}

	-- 그냥 혼자 놀기 모드
	local playState = 
	{	
		enter = function (state, mob, info) 
			state.moveTiming = info.curTime
			state.approachTime = info.curTime + 10
			
			if info.followingMode == nil then
				info.followingMode = false
			end
			
			-- 혼자 놀다가 --> 따라오는 시간을 설정한다.
			if info.modeChangeTime == nil then
				--info.modeChangeTime = info.curTime + (info.followingMode and RAND(8,15) or RAND(30, 45))
			end
			
			if info.followingMode then
				--print('-> following\n')
				mob:SetVelocity( info.avoidVelocity  )
				PLAY_MOTION( info, mob, MOTION_MOVE2  )			
			else
				--print('-> no following\n')
			end
			
			state.warningLookTime = info.curTime
			state.attackTime = info.curTime + RAND(10,17)
			
			state.goUsualPathTime = info.curTime + RAND(info.goUsualPathDelayMin, info.goUsualPathDelayMax)
		end,
		
		process = function (state, mob, info)
		
			if info.modeChangeTime ~= nil and info.curTime >= info.modeChangeTime then
				info.modeChangeTime = nil
				if info.followingMode then 
					info.followingMode = false
				else
					info.followingMode = true
				end
				NEXT_STATE( info, STATE_IDLE )
			end
		
			-- 플레이어 가까우면 도망가기
			local player = mgr:FindNearPlayer(mob)
			if not info.followingMode and player then
				local playerDist = mob:GetDist(player:GetPos())
				if playerDist < info.warningDistance then
					if info.curTime >= state.warningLookTime then
						NEXT_STATE( info, STATE_WEAK2 )
						return
					end
				end
			end		
					
			if mob:IsArrived() then
			
				-- 다른 mob이 근처에 있으면 즉시 이동
				local checkDist = 10
				local nearMob = mgr:FindNearMob( mob:GetPos(), checkDist, mob:GetObjID() )
				if nearMob ~= nil then
					state.moveTiming = info.curTime
				end
				
				-- 이동하다가 멈춘 경우
				if state.moving then
					PLAY_MOTION( info, mob, MOTION_IDLE )
					state.moving = false
					
					-- 다음 이동할 시간을 정한다.
					if info.followingMode then
						state.moveTiming = info.curTime + RAND(2,4)
					else
						state.moveTiming = info.curTime + RAND(5,15)
					end
				end
				
				if info.curTime >= state.attackTime then
					PLAY_MOTION( info, mob, MOTION_ATTACK1 )
					state.attackTime = info.curTime + RAND(20,30)
					state.attackPlayTime = info.curTime + 12
				end
				
				if state.attackPlayTime~=nil and info.curTime <= state.attackPlayTime then
					return
				end
			
				-- 이동 딜레이가 끝났으면 --> 이동한다
				if info.curTime >= state.moveTiming then
					local player = mgr:FindNearPlayer(mob)
					if player then
						
						local pos
						local playerPos = player:GetPos()
												
						local approachToPlayer = state.approachTime ~= nil 
													and info.curTime >= state.approachTime 
													and mob:GetDist(playerPos) <= info.approachDistance 
													and RAND(1,2)==1
											
						-- for debug : 강제로 계속 따라오기
						if info.followingMode then
							approachToPlayer = true
						end
							
						local moving = false
						-- 가만 있으면 다가온다.
						if approachToPlayer then
							
							--local targetDir = GetDir(mob:GetPos(), playerPos)
							--pos = GetFrontPos(mob:GetPos(), targetDir, RAND(2,6))
							
							local apporachDist = 2	--1.5
							local checkCount = 500
							--mob:MovePath(playerPos.x, playerPos.y, playerPos.z, apporachDist, checkCount)
							moving = mob:MoveToPlayer(player, apporachDist, checkCount)
						else						
						
							-- 정해진 길을 따라 이동한다
							if info.curTime >= state.goUsualPathTime then
								NEXT_STATE( info, STATE_EVENT1 )
								return
							end
							
							-- 적당히 랜덤하게 원래 있던 근처 위치를 계산
							moving = MoveCatAround(info, mob, 5, 15)
						end
					
						if moving then
							if info.followingMode then
								PLAY_MOTION( info, mob, MOTION_MOVE2  )
							else
								PLAY_MOTION( info, mob, MOTION_MOVE  )
							end						
							state.moving = true
							state.warningLookTime = info.curTime + 1
						else
							state.moveTiming = info.curTime + RAND(3,5)
						end
					end
				end
			end
		end,
	}
	
	-- 경계 모드
	local warningState = 
	{	
		enter = function (state, mob, info)
			mob:Stop()
			PLAY_MOTION( info, mob, MOTION_IDLE )
			state.warningLookTime = info.curTime
			state.forceAvoidTime = info.curTime + RAND(8,20)
			state.attackTime = info.curTime + RAND(1,5)
			state.attackPlayTime = 0
			state.moving = false
		end,
		
		process = function (state, mob, info)
			-- 플레이어 가까우면 도망가기
			
			if mob:IsArrived() then
				if state.moving then
					PLAY_MOTION( info, mob, MOTION_IDLE )
					state.moving = false
				end
			end
			
			if info.curTime >= state.attackPlayTime and state.lookAtTime~=nil and info.curTime >= state.lookAtTime then
				if mob:IsArrived() then
					local player = mgr:FindNearPlayer(mob)
					if player ~= nil then
						--mob:LookAt(player:GetPos())
						-- 보는것 대신에 움직이자.
						if MoveCatAround(info, mob, 5, 15) then
							if info.followingMode then
								PLAY_MOTION( info, mob, MOTION_MOVE2  )
							else
								PLAY_MOTION( info, mob, MOTION_MOVE  )
							end
							state.moving = true
						end
					end
					state.lookAtTime = nil
				end
			end
			
			local player = mgr:FindNearPlayer(mob)
			if not info.followingMode and player then
				local playerActionState = (player:IsJump() or player:IsCourbette())
				local avoidDistance = ((player:GetVelocity()>10 or playerActionState) and info.avoidDistance or info.avoidDistance*0.2)
				local playerDist = mob:GetDist(player:GetPos())
				if info.curTime >= state.forceAvoidTime or playerDist < avoidDistance then
					
					info.showSurprise = playerActionState and playerDist <= info.collisionDistance
					NEXT_STATE( info, STATE_WEAK1 )
					return
				elseif playerDist < info.warningDistance then
					if info.curTime >= state.warningLookTime then
						
						if mob:IsArrived() then
							if info.curTime >= state.attackPlayTime and info.curTime >= state.attackTime then
								PLAY_MOTION( info, mob, MOTION_ATTACK1 )
								
								-- 그냥 휙~ 돌면서 바라보니까 이상해서 모션 후에 타이밍을 주고 턴
								state.lookAtTime = info.curTime + 3
							
								state.attackTime = info.curTime + RAND(20,40)
								state.attackPlayTime = info.curTime + 12
							end
							state.warningLookTime = info.curTime + 1						
						end
					end
				else
					NEXT_STATE( info, STATE_ATTACK1 )
				end
			end
		end,
	}

	
	-- 도망가기 모드
	local runawayState = 
	{	
		enter = function (state, mob, info)
			state.runaway = true
			
			if info.avoidCountPerSec==nil 
				or info.avoidCountResetTime~=nil and info.curTime >= info.avoidCountResetTime then
				-- 도망 카운트 초기화			
				info.avoidCountPerSec = 0
				info.avoidCountResetTime = info.curTime + 60
				--print('cat avoid reset\n')
			end
			
			-- 도망 회수 증가
			--print('cat avoid\n')
			info.avoidCountPerSec = info.avoidCountPerSec + 1
			state.avoidCountMax = RAND(4, 10)
			
			state.playMotion = true
		end,
		
		process = function (state, mob, info)
		
			-- 초당 일정 횟수 이상이면 멀리 도망간다
			if info.avoidCountPerSec >= state.avoidCountMax then
				--print('cat avoid path\n')
				NEXT_STATE( info, STATE_EVENT1 )
				return
			end
			
			-- motion
			if state.playMotion then
				state.playMotion = false

				if (info.showSurprise or RAND(1,100) <= 10) and (info.showSurpriseDelay==nil or info.curTime >= info.showSurpriseDelay) then
					info.showSurprise = nil
					info.showSurpriseDelay = info.curTime + 15		-- 한 동안은 다시 출력 안함
					local player = mgr:FindNearPlayer(mob)
					if player then
						mob:LookAt(player:GetPos())

						local pos = mob:GetPos()
						local otherPos = player:GetPos()
						local dir = GetDir(otherPos, pos)
						local colDir = pos - otherPos
						local knockbackDir = Normalize(colDir)
						local knockbackDist = 3
						local time = 0.6

						local kbPos = pos + knockbackDir * knockbackDist

						local adjustPos = mgr:GetNaviCellPos(mob:GetPos(), kbPos, 1)
						mob:Knockback(adjustPos.x, adjustPos.y, adjustPos.z, time, 0, KNOCKBACK_SURPRISE)
						PLAY_MOTION( info, mob, MOTION_COLLISION )
						SET_DELAY(info, 2.2)	-- end모션을 위해서
					end				
				else
					PLAY_MOTION( info, mob, MOTION_JUMP )
				end

				return
			end
			
		
			if state.runaway then
				state.runaway = false
				
				local player = mgr:FindNearPlayer(mob)
				if player then
					local pos
										
					local runawayType = (info.runawayType~=nil and info.runawayType or RUNAWAY_RANDOM)
					
					-- 적당히 랜덤하게 근처 위치를 계산
					if runawayType==RUNAWAY_RANDOM then
						local moveType = RAND(1,2)					
						if moveType==1 then
							pos = GetLeftPos(mob:GetPos(), player:GetDir(), RAND(10,12))		-- 왼쪽
						else
							pos = GetRightPos(mob:GetPos(), player:GetDir(), RAND(10,12))		-- 오른쪽
						end
					-- 좀 더 멀어지는 방향으로 도망가기						
					elseif runawayType==RUNAWAY_SIDE then
					
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
					-- 바라보는 방향으로 도망가기			
					elseif runawayType==RUNAWAY_FRONT then
						local lookDir = GetDir(player:GetPos(), mob:GetPos())
						--local newDir = GetDir(v3(0,0,0), player:GetDir()*2 + lookDir)
						
						pos = GetFrontPos(mob:GetPos(), lookDir, RAND(6,8))		-- 왼쪽
					else
						--print('Unknown runaway = '..info.runawayType..'\n')
					end
					
					pos.x = pos.x + RAND(-20,20)*0.1
					pos.z = pos.z + RAND(-20,20)*0.1
					
					local newPos = pos	--util:GetRoadPosition( mob:GetPos(), pos, 0.1, 2 )
					
					-- 이동 ㄱㄱ!
					if mob:Move(newPos.x, newPos.y, newPos.z) then
						mob:SetVelocity( info.avoidVelocity  )
						PLAY_MOTION( info, mob, MOTION_MOVE2  )
					end
				end
				
			-- 도착했으면 원래대로
			elseif mob:IsArrived() then
				NEXT_STATE( info, STATE_ATTACK1 )
			end
		end,
		
		leave = function (state, mob, info)
			PLAY_MOTION( info, mob, MOTION_IDLE )
			mob:SetVelocity( info.defaultVelocity  )
		end,
	}
	
	local movePathState =
	{
		enter = function (state, mob, info)
		
			info.avoidCountPerSec = nil

			state.forward = nil			
			state.curIndex = nil
			state.firstMove = true
			
			-- path중에서 가장 가까운 위치를 찾는다.
			local nearIndex = nil
			local curPos = mob:GetPos()
			local maxDist = 0
			
			state.movePath = CatPathList[ RAND(1, table.getn(CatPathList)) ]
				
			for i,pos in pairs(state.movePath) do
				local dist = GetDist(curPos, pos)
				if i==1 or dist<maxDist then
					nearIndex = i
					maxDist = dist
				end
			end
			
			-- 현재 위치에서 먼 지점으로 가도록 설정한다.
			if nearIndex ~= nil and maxDist < info.movePathLimitDist then
				
				state.curIndex = nearIndex
				
				local maxIndex = table.getn(state.movePath)
				if state.curIndex <= maxIndex/2 then
					state.forward = true
				else
					state.forward = false
				end
				--print('cat movepath!\n')
			else
				--print('no cat movepath\n')
			end
		end,
		
		process = function (state, mob, info)
			if state.forward ~= nil then			
			
				if mob:IsArrived() or mob:GetRemainDist() < 2 then
					-- 다음 위치
					if state.forward then
						state.curIndex = state.curIndex + 1
					else
						state.curIndex = state.curIndex - 1
					end
					
					if state.curIndex==0 or state.curIndex>table.getn(state.movePath) then
						-- arrived
						NEXT_STATE( info, STATE_IDLE )
						return
					end
					
					local pos = state.movePath[state.curIndex]					
				
					local apporachDist = 0	--1.5
					local checkCount = 500
					if mob:MovePath(pos.x, pos.y, pos.z, apporachDist, checkCount) then
					
						if state.firstMove then
							state.firstMove = false
							mob:SetVelocity( info.avoidVelocity  )
							PLAY_MOTION( info, mob, MOTION_MOVE2  )			
						end
					else
						-- 길찾기 실패한 경우
						NEXT_STATE( info, STATE_IDLE )
					end
				end				
				
			else
				NEXT_STATE( info, STATE_IDLE )
			end
		end,
		
		leave = function (state, mob, info)
			PLAY_MOTION( info, mob, MOTION_IDLE )
			mob:SetVelocity( info.defaultVelocity  )
			--print('cat movepath end!\n')
		end,
	}

	SET_STATE_HANDLER( stateList[STATE_IDLE], idleState )
	SET_STATE_HANDLER( stateList[STATE_ATTACK1], playState )
	SET_STATE_HANDLER( stateList[STATE_EVENT1], movePathState )
	SET_STATE_HANDLER( stateList[STATE_WEAK1], runawayState )
	SET_STATE_HANDLER( stateList[STATE_WEAK2], warningState )
	SET_STATE_HANDLER( stateList[STATE_PATROL], g_AIStateFactory.SimplePatrol(STATE_IDLE) )
	
	return stateList
end,
}

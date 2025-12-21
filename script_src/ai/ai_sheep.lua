-- module setup
require('aihelper')


--BUILD_CONDITION({
--	{ info.patrol_path },	{ NEXT_STATE( info, STATE_PATROL ) },
--	{},						{ NEXT_STATE( info, STATE_ATTACK1 ) },
--})


function ResetGoodMoveTime(info)
	info.goodMoveTime = info.curTime + RAND(40,70)
end

g_AIFactory['sheep'] = 
{

onInit = function (info, mob)
	info.hp_max = 100000
	info.hp		= info.hp_max	
	info.pivotPos = mob:GetPos()
	
	if info.defaultVelocity == nil then
		info.defaultVelocity = 1
	end
	
	if info.goodMoveVelocity == nil then
		info.goodMoveVelocity = 0.45
	end
	
	if info.avoidDistance == nil then
		info.avoidDistance = 20
	end
	
	if info.avoidVelocity == nil then
		info.avoidVelocity = 10
	end

	if info.angryVelocity == nil then
		info.angryVelocity = 15
	end
	
	info.slowAvoidDist			= 1				-- 도망갈때 속도가 느려지는 도착지점과의 거리
	info.avoidSlowVelocity		= 1				-- 느려질떄의 속도

	info.enableCollisionAvoid	= true			-- 이거 켜야지 플레이어와 충돌할때 피함(STATE_WEAK1, aidefault.lua에 DefaultEvent에 있음)

	mob:SetHPMax(info.hp_max)
	mob:SetHP(info.hp_max)
end,

onAddAfter = function (info, mob)

	--mob:Scale( s, s, s )
	mob:SetVelocity( info.defaultVelocity  )
	
	-- 기분 좋게 걷기 시작하는 시간
	ResetGoodMoveTime(info)	
end,

createState = function ()
	local stateList = {}
	stateList.motion = {}
	local motion = stateList.motion
	
	--                        { Name,			StateName,			aniDelay }
	motion[MOTION_IDLE]		= { name='Idle',	state='IDLE',		aniDelay=0.5 }
	motion[MOTION_MOVE5]	= { name='MoveGood',state='MOVE_ZERO',	aniDelay=0.1 }
	motion[MOTION_MOVE]		= { name='Move',	state='MOVE_1ST',	aniDelay=0.1 }
	motion[MOTION_MOVE2]	= { name='Move2',	state='MOVE_3RD',	aniDelay=0.1 }
	motion[MOTION_MOVE3]	= { name='MoveAngry',state='MOVE_4TH',	aniDelay=0.1 }
	motion[MOTION_JUMP]		= { name='Jump',	state='JUMP',		aniDelay=0.3 }
	motion[MOTION_COLLISION]= { name='Collision',	state='G_COLLISION',		aniDelay=1.8 }
	motion[MOTION_COLLISION_END]= { name='CollisionEnd',	state='G_COLLISION_END',		aniDelay=0.5 }
	
	stateList[STATE_IDLE]	= { name='Idle',	procDelay=0.2 }
	stateList[STATE_FOLLOW]	= { name='Follow',	procDelay=0.2 }
	stateList[STATE_PATROL]	= { name='Patrol',	procDelay=0.2 }
	stateList[STATE_ATTACK1]= { name='Attack1',	procDelay=0.1 }
	stateList[STATE_WEAK1]	= { name='Weak1',	procDelay=0.2 }
	stateList[STATE_WEAK2]	= { name='Weak2',	procDelay=0.1 }
	stateList[STATE_DEAD]	= { name='Dead',	procDelay=0.5 }

	
	-- 최초 정지 상태
	local idleState = 
	{	
		enter = function (state, mob, info) 
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
						
						pos.x = pos.x + RAND(-7,7)
						pos.z = pos.z + RAND(-7,7)

						local newPos
						if IS_SERVER then
							newPos = mgr:GetNaviCellPos(mob:GetPos(), pos, 2)
						elseif util~=nil and util.GetRoadPosition ~= nil then
							newPos = util:GetRoadPosition( mob:GetPos(), pos, 0.5, 2 )
						end
						
						if newPos == nil then
							newPos = pos
						end
						
						-- 이동 ㄱㄱ!
						if mob:Move(newPos.x, newPos.y, newPos.z) then
							PLAY_MOTION( info, mob, MOTION_MOVE2  )
							state.moving = true
						end
					end
				end
			end
		end,
	}

	-- 그냥 혼자 놀기 모드
	local playState = 
	{	
		enter = function (state, mob, info) 
			state.moveTiming = info.curTime
			state.goodMoveEndTime = nil
			state.goodMove = false				

			if info.angryTime~=nil then
				PLAY_MOTION( info, mob, MOTION_MOVE3  )
				mob:SetVelocity( info.angryVelocity  )
			end
		end,
		
		process = function (state, mob, info)

			-- 분노 상태 끝내기
			if info.angryTime~=nil and info.curTime >= info.angryTime then
				info.angryTime = nil

				ResetSheepCoinDropCount()				
				
				mob:SetVelocity( info.defaultVelocity  )
				NEXT_STATE( info, STATE_IDLE )
				return
			end

			-- 양을 너무 많이 치고 다니면.. 분노 상태로 변신
			if info.angryTime==nil 
				and g_SheepCoinDropCount~=nil 
				and g_AngrySheepCoinDropCount~=nil
				and g_SheepCoinDropCount >= g_AngrySheepCoinDropCount 
			then				
				info.angryTime = info.curTime + GetSheepAngryDelay()
				
				-- 속도 증가!
				mob:SetVelocity( info.angryVelocity  )
				PLAY_MOTION( info, mob, MOTION_MOVE3 )
			end
		
			-- 플레이어 가까우면 도망가기(분노 아닐때만)
			local isAngry = (info.angryTime ~= nil)
			local isNormal = not isAngry
			if isNormal then			
				local player = mgr:FindNearPlayer(mob)
				if player then
					local distance = (player:GetVelocity()>10 and info.avoidDistance or info.avoidDistance/3)
					if mob:GetDist(player:GetPos()) < distance then
						NEXT_STATE( info, STATE_WEAK1 )
						return
					end
				end
			end
			
			if isAngry then
				mob:SetVelocity( info.angryVelocity  )
			end
					
			if mob:IsArrived() then
			
				-- 이동하다가 멈춘 경우
				if state.moving then

					if isNormal then
						PLAY_MOTION( info, mob, MOTION_IDLE )
					end

					state.moving = false
					
					-- 다음 이동할 시간을 정한다.
					if isAngry then
						state.moveTiming = info.curTime + 0
					else
						state.moveTiming = info.curTime + RAND(5,15)
					end
				end
			
				-- 이동 딜레이가 끝났으면 --> 이동한다
				if info.curTime >= state.moveTiming then
					local player = mgr:FindNearPlayer(mob)
					if player then
					
						if state.goodMoveEndTime ~= nil and info.curTime >= state.goodMoveEndTime then
							ResetGoodMoveTime(info)
						end
					
						if isNormal and info.curTime >= info.goodMoveTime then
							PLAY_MOTION( info, mob, MOTION_MOVE5  )
							
							if not state.goodMove then
								state.goodMove = true
								-- good move 딜레이 설정
								state.goodMoveEndTime = info.curTime + RAND(10,20)
								mob:SetVelocity( info.goodMoveVelocity  )
							end
						else
						
							if state.goodMove then
								state.goodMove = false

								if isNormal then
									mob:SetVelocity( info.defaultVelocity  )
								end
							end

							if isAngry then
								--PLAY_MOTION( info, mob, MOTION_IDLE )
								--PLAY_MOTION( info, mob, MOTION_MOVE3  )
								mob:SetVelocity( info.angryVelocity  )
							else
								PLAY_MOTION( info, mob, MOTION_MOVE  )
							end							
						end
						
						local pos
						local moveType = RAND(1,3)
						local distModify = isAngry and 0.5 or 1
						local pivotPos = info.pivotPos

						-- 분노 상태는 플레이어 근처로..
						if isAngry then
							local player = mgr:FindNearPlayer(mob)
							if player then
								pivotPos = player:GetPos()
							end
						end

						-- 적당히 랜덤하게 원래 있던 근처 위치를 계산
						if moveType==1 then
							pos = GetFrontPos(pivotPos, mob:GetDir(), RAND(5,20)*distModify)		-- 앞쪽
						elseif moveType==2 then
							pos = GetLeftPos(pivotPos, mob:GetDir(), RAND(5,15)*distModify)		-- 왼쪽
						else
							pos = GetRightPos(pivotPos, mob:GetDir(), RAND(5,15)*distModify)		-- 오른쪽
						end
						
						pos.x = pos.x + RAND(-10,10)*distModify
						pos.z = pos.z + RAND(-10,10)*distModify

						-- 분노시 일정 거리만 이동
						if isAngry then
							pos = GetFrontPosTo(mob:GetPos(), pos, RAND(4,8))
						end						
						
						local newPos
						if IS_SERVER then
							newPos = mgr:GetNaviCellPos(mob:GetPos(), pos, 2)
						elseif util~=nil and util.GetRoadPosition ~= nil then
							newPos = util:GetRoadPosition( mob:GetPos(), pos, 0.5, 2 )
						end
						
						if newPos == nil then
							newPos = pos
						end
						
						-- 이동 ㄱㄱ!
						if newPos ~= nil then
							mob:Move(newPos.x, newPos.y, newPos.z)
							state.moving = true							
						end
					end
				end
			end
		end,
	}
	
	-- 도망가기 모드
	local runawayState = 
	{	
		enter = function (state, mob, info)
			PLAY_MOTION( info, mob, MOTION_JUMP )
			state.runaway = true
			state.fastMove = true
			info.counterDir = false
			ResetGoodMoveTime(info)	
		end,
		
		process = function (state, mob, info)
			if state.runaway then
				state.runaway = false
				
				local player = mgr:FindNearPlayer(mob)
				if player then
					local pos

					if info.runawayPos ~= nil then
						pos = info.runawayPos						
					else				
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
						
							if dist1 > dist2 and not info.counterDir 
								or dist1 <= dist2 and info.counterDir then
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
					end

					pos.x = pos.x + RAND(-20,20)*0.1
					pos.z = pos.z + RAND(-20,20)*0.1
					
					local curPos = mob:GetPos()
					local newPos
					if IS_SERVER then
						newPos = mgr:GetNaviCellPos(curPos, pos, 2)
					elseif util~=nil and util.GetRoadPosition ~= nil then
						newPos = util:GetRoadPosition( curPos, pos, 0.5, 2 )
					end
					
					if newPos == nil then
						newPos = pos
					end
					
					-- 이동 ㄱㄱ!
					if newPos~=nil then

						if newPos.x~=curPos.x and newPos.z~=curPos.z then
							mob:Move(newPos.x, newPos.y, newPos.z)
							mob:SetVelocity( info.avoidVelocity  )
							PLAY_MOTION( info, mob, MOTION_MOVE2  )
						else
							-- 벽에 막혀서 못가는 경우 --> 반대방향 체크 flag를 켜자.
							state.runaway = true
							info.counterDir = true
						end
					end	

					info.runawayPos = nil
				end
				
			-- 도착했으면 원래대로
			elseif mob:IsArrived() then
				NEXT_STATE( info, STATE_ATTACK1 )
				
			-- 거의 도착했으면 느리게 움직인다.
			else
				local remainDist = mob:GetRemainDist()
				if remainDist < info.slowAvoidDist then
					-- 가까우면 천천히 접근
					if state.fastMove then
						mob:SetVelocity( info.avoidSlowVelocity  )
						PLAY_MOTION( info, mob, MOTION_MOVE )
						state.fastMove = false
					end
				end
			end
		end,
		
		leave = function (state, mob, info)
			mob:SetVelocity( info.defaultVelocity  )
		end,
	}

	-- 부딪혀서 밀려서 날아갈때
	local knockbackState = 
	{	
		enter = function (state, mob, info)
			PLAY_MOTION( info, mob, MOTION_COLLISION, true )

			info.stateEndTime = info.curTime + 0.5		-- G_COLLISION_END 플레이 시간을 추가해준다.

			if info.knockbackTime ~= nil then
				info.stateEndTime = info.stateEndTime + info.knockbackTime
				info.knockbackTime = nil
			end			
		end,
		
		process = function (state, mob, info)
			if info.curTime >= info.stateEndTime then
				-- 충돌 후 도망가기로 설정
				NEXT_STATE(info, STATE_WEAK1)
			end
		end,

		leave = function (state, mob, info)
			--PLAY_MOTION( info, mob, MOTION_COLLISION_END )				
		end,
	}

	-- 죽는 경우
	local deadState = 
	{	
		enter = function (state, mob, info)
			PLAY_MOTION( info, mob, MOTION_COLLISION, true )

			info.stateEndTime = info.curTime + 0.5		-- G_COLLISION_END 플레이 시간을 추가해준다.

			if info.knockbackTime ~= nil then
				info.stateEndTime = info.stateEndTime + info.knockbackTime
				info.knockbackTime = nil
			end			
		end,
		
		process = function (state, mob, info)
			if info.curTime >= info.stateEndTime then
				-- 충돌 후 도망가기로 설정
				if mob:GetHP() > 0 then
					mob:Dead()
					mob:SetHP(0)
				end
			end
		end,

		leave = function (state, mob, info)
			--PLAY_MOTION( info, mob, MOTION_COLLISION_END )				
		end,
	}

	SET_STATE_HANDLER( stateList[STATE_IDLE], idleState )
	SET_STATE_HANDLER( stateList[STATE_FOLLOW], followState )
	SET_STATE_HANDLER( stateList[STATE_ATTACK1], playState )
	SET_STATE_HANDLER( stateList[STATE_WEAK1], runawayState )
	SET_STATE_HANDLER( stateList[STATE_WEAK2], knockbackState )
	SET_STATE_HANDLER( stateList[STATE_PATROL], g_AIStateFactory.SimplePatrol(STATE_IDLE) )

	SET_STATE_HANDLER( stateList[STATE_DEAD], deadState )		-- 게임 중에만 작동
	
	return stateList
end,
}

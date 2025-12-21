-- module setup
require('aihelper')
require('logic_ranch_config')

								
STAND_MODE = false

g_AIFactory['ranch_foal'] = 
{

onInit = function (info, mob)
	info.hp_max = 100000
	info.hp		= info.hp_max	
	info.pivotPos = mob:GetPos()
	
	info.firstIdleDelayTime		= 5	
	info.defaultVelocity		= 4				-- 1.5
	
	info.idleTimeMin			= 40
	info.idleTimeMax			= 55	
	
	info.avoidDistance			= 9				-- 플레이어가 이 거리 안쪽에서 위협적인 행동을 하면 도망간다
	info.avoidVelocity			= 4			    -- 도망갈때 속도 3
	info.slowAvoidDist			= 4				-- 도망갈때 속도가 느려지는 도착지점과의 거리
	info.avoidSlowVelocity		= 4				--1.5				-- 느려질떄의 속도
						
	info.lookPlayerDist			= 15
	
	info.traceHorseMinDist		= 12			-- 이 거리 이상 멀어져야 접근한다.
	info.runawayMaxDelay		= 0.3			-- 도망가기 직전의 랜덤딜레이
	
	info.feedMotionDelay		= 5	
	info.feedRatio				= 0		--30			-- 풀뜯기 확률(100%기준)
	info.feedCountMin			= 3				-- 풀뜯을 회수 최소값
	info.feedCountMax			= 5				-- 풀뜯을 회수 최대값
	info.lookPlayerRatio		= 50			-- 풀뜯기 안할때, 플레이어 바라볼 확률	
	
	info.freeVelocity			= 4		--3				-- 삭제시 포탈로 갈때 속도
	info.freeSlowVelocity		= 4		--1.5				-- 포탈 근처에서 천천히 걷기
	info.slowFreeApproachDist	= 4				-- 포탈 근처 느려지는 거리	
	
	info.callDistance	= RanchHorseConfig.CallDistance
end,

onAddAfter = function (info, mob)

	--mob:Scale( 0.6, 0.6, 0.6 )
	mob:SetVelocity( info.defaultVelocity  )
end,

createState = function ()
	local stateList = {}
	stateList.motion = {}
	local motion = stateList.motion
	
	--                        { Name,			StateName,			aniDelay }
	motion[MOTION_IDLE]		= { name='Idle',	state='GRAZE_IDLE',		aniDelay=0.5 }
	motion[MOTION_MOVE]		= { name='Move',	state='MOVE_ZERO',	aniDelay=0.1 }
	motion[MOTION_MOVE2]	= { name='Move2',	state='MOVE_2ND',	aniDelay=0.1 }
	motion[MOTION_MOVE3]	= { name='Move3',	state='MOVE_3RD',	aniDelay=0.1 }
	motion[MOTION_JUMP]		= { name='Jump',	state='JUMP',		aniDelay=0.5 }
	motion[MOTION_ANI1]		= { name='Feed',	state='WAY_LOST', aniDelay=0.3 }
	motion[MOTION_ANI2]		= { name='Called',	state='COURBETTE', aniDelay=1.5 }	
	motion[MOTION_ANI3]		= { name='Love',	state='WAY_LOST', aniDelay=5 }		
	motion[MOTION_ATTACKED1]= { name='PlayDead',state='WAY_LOST', aniDelay=3 }	
	motion[MOTION_ANI4]		= { name='CommUp',  state='COMMUNION_UP', aniDelay=3 }	
	motion[MOTION_ANI5]		= { name='TurnRound',state='WAY_LOST', aniDelay=3 }	
	motion[MOTION_ANI7]		= { name='ByePrepare',	state='COURBETTE', aniDelay=1.5 }	
	motion[MOTION_ANI8]		= { name='ByeLast',		state='WAY_LOST', aniDelay=2.5 }		-- 모션 시간을 약간 짧게 줘야 모션하면서 사라진다.
	
	stateList[STATE_IDLE]	= { name='Idle',	procDelay=0.2 }
	stateList[STATE_ATTACK1]= { name='Attack1',	procDelay=0.1 }
	stateList[STATE_WEAK1]	= { name='Weak1',	procDelay=0.2 }
	stateList[STATE_CALLED] = { name='Called',	procDelay=0.2 }
	stateList[STATE_DEAD]	= { name='GoodBye',	procDelay=0.1 }	
	stateList[STATE_DEAD_IM]	= { name='GoodByeIm',	procDelay=1 }	

	
	-- 최초 정지 상태
	local idleState = 
	{	
		enter = function (state, mob, info) 
			local pos = mob:GetPos()
			local lookPos = v3( pos.x + RAND(-10,10), pos.y, pos.z + RAND(-10,10) )
			mob:LookAt( lookPos )
			state.randomDelay = info.curTime + info.firstIdleDelayTime + RAND(0, 1.5)
		end,
		
		process = function (state, mob, info)
		
			if state.randomDelay~=nil and info.curTime >= state.randomDelay then
				PLAY_MOTION( info, mob, MOTION_IDLE )
                state.randomDelay = nil
                
                SET_DELAY( info, RAND(9, 10) )
			end

            if state.randomDelay==nil then
                -- 망아지는 이름이 지어지면 움직인다.
                if mob:GetMountName()~=nil and mob:GetMountName()~='' then
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
			info.traceHorseTime = info.curTime	
			state.restoreIdleMotion = false			
		end,
		
		process = function (state, mob, info)
		
			if state.restoreIdleMotion then
				PLAY_MOTION( info, mob, MOTION_IDLE )
				state.restoreIdleMotion = false
			end
			
			-- 타이밍 두고 도망가기
			if state.runawayTime ~= nil then
				if info.curTime >= state.runawayTime then
					NEXT_STATE( info, STATE_WEAK1 )
					state.runawayTime = nil
				end
				return
			end
		
			-- 플레이어 가까우면 도망가기
			local player = mgr:FindNearPlayer(mob)
			if player then
				local distance = ( (player:GetVelocity()>50 or player:IsJump() or player:IsCourbette()) and info.avoidDistance or 0)
				if mob:GetDist(player:GetPos()) < distance then
					
					local runawayTiming = RAND(0, info.runawayMaxDelay)
					
					if runawayTiming < 0.05 then
						NEXT_STATE( info, STATE_WEAK1 )
					else
						state.runawayTime = info.curTime + runawayTiming
					end
					return
				end
			end
					
			if mob:IsArrived() then
			
				if STAND_MODE then
					return
				end
			
				-- 풀 뜯기 진행 중
				if state.feedCount~=nil and state.feedCount > 0 then
					if info.curTime >= state.feedMotionTiming then
						-- motion replay
						PLAY_MOTION( info, mob, MOTION_ANI1 )
						
						state.feedMotionTiming = info.curTime + RAND(5,7)
						state.feedCount = state.feedCount - 1
						
						if state.feedCount<=0 then
							state.feedCount = nil
						end
					end
					
					return
				end				
							
				-- 이동하다가 멈춘 경우				
				if state.moving then
					state.moving = false
					
					-- 너무 가까워서 충돌하는 경우 처리
					local collisionDist = 4
					local collMob = mgr:FindNearMob( mob:GetPos(), collisionDist, mob:GetObjID() )
					local collPlayer = mgr:FindNearPlayer( mob )
					if collMob ~= nil or collPlayer ~= nil and mob:GetDist( collPlayer:GetPos() ) < collisionDist then
						state.moveTiming = info.curTime + 0.2
						
						--local targetOID = collMob~=nil and collMob:GetObjID() or collPlayer:GetObjID()
						--print('collision:'..mob:GetObjID()..' -> '..targetOID..'\n')
					else					
						local feedTiming = RAND(1,100) < info.feedRatio		-- 30%확률로 풀을 뜯자.
						
						if feedTiming then
							--mob:Stop()
					
							-- 풀 뜯기 ㄱㄱ
							-- 다음 이동할 시간
							state.feedCount = math.floor( RAND(info.feedCountMin, info.feedCountMax) )
							local startFeedDelay = RAND(1,2)
							state.feedMotionTiming = info.curTime + startFeedDelay
							state.moveTiming = info.curTime + startFeedDelay + state.feedCount*info.feedMotionDelay + RAND(1,5)	
						else
							-- 정지
							--mob:Stop()
							--PLAY_MOTION( info, mob, MOTION_IDLE )
							
							-- 가끔 플레이어를 보자
							local lookTiming = RAND(1,100) < info.lookPlayerRatio
							if lookTiming then
								local nearPlayer = mgr:FindNearPlayer(mob)
								if nearPlayer ~= nil and mob:GetDist(nearPlayer:GetPos()) <= info.lookPlayerDist then
									--PLAY_MOTION( info, mob, MOTION_TURN_L )
									--state.restoreIdleMotion = true
									mob:LookAt(nearPlayer:GetPos())
								end
							end
							
							-- 다음 이동할 시간을 정한다.
							state.moveTiming = info.curTime + RAND(info.idleTimeMin, info.idleTimeMax)
						end
					end
				end
			
				-- 이동 딜레이가 끝났으면 --> 이동한다
				if info.curTime >= state.moveTiming then
					local player = mgr:FindNearPlayer(mob)
					if player then
						--PLAY_MOTION( info, mob, MOTION_MOVE  )
						
						local pos
						local pivotPos = info.pivotPos
						local moveType = RAND(1,3)						
						
						-- 레벨 높은 말 따라가기						
						if info.traceHorseOID == nil and info.curTime >= info.traceHorseTime then
							local highMob = mgr:FindHighestLevelMob( mob:GetPos(), 50 )
							if highMob~=nil and highMob~=mob and mob:GetDist( highMob:GetPos() ) >= info.traceHorseMinDist then
								local highPos = highMob:GetPos()
								
								local apporachDist = RAND(4, 8)
								local checkCount = 200
								
								if mob:MovePath(highPos.x, highPos.y, highPos.z, apporachDist, checkCount) then
									info.pivotPos = highPos
									state.moving = true
									return
								end
							end
							
							info.traceHorseTime = info.curTime + 10
						end
						
						-- 적당히 랜덤하게 원래 있던 근처 위치를 계산
						-- 충돌 안하는 위치를 뽑기 위해서 몇번만 체크해보자
						local checkDist = 4
						for i=1,5 do						
							if moveType==1 then
								pos = GetFrontPos(pivotPos, mob:GetDir(), RAND(2,5))		-- 앞쪽
							elseif moveType==2 then
								pos = GetLeftPos(pivotPos, mob:GetDir(), RAND(2,5))		-- 왼쪽
							else
								pos = GetRightPos(pivotPos, mob:GetDir(), RAND(2,5))		-- 오른쪽
							end
							
							--pos.x = pos.x + RAND(-10,10)
							--pos.z = pos.z + RAND(-10,10)
							
							-- 목표 위치 주변이 비어있길 바라면서..
							local nearMob = mgr:FindNearMob(pos, checkDist, mob:GetObjID())
							if nearMob == nil then
								break
							end
						end
						
						-- 이동 ㄱㄱ!
						mob:Move(pos.x, pos.y, pos.z)
						
						state.moving = true
					end
				end
			end
		end,
	}	
	
	-- 플레이어가 호출한 경우
	local calledState = 
	{	
		enter = function (state, mob, info) 
			
			mgr:SendEventToClient( EVENT_CALLED_NPC, mob:GetObjID(), info.callerOID )
			
			-- 잠시 딜레이
			mob:GazeAt(info.callerOID, GAZE_FAVOR)
			SET_DELAY(info, RAND(3,4))
		end,
		
		process = function (state, mob, info)
		
			NEXT_STATE( info, STATE_ATTACK1 )
			
		end,
		
		leave = function (state, mob, info)
			mgr:SendEventToClient( EVENT_NPC_FOLLOWING_END, mob:GetObjID(), info.callerOID )
			if mob:GetGazeID() ~= 0 then
				mob:GazeAt(0, GAZE_NONE)
			end			
		end,
	}	
	
	-- 즉시 삭제
	local goodbyeState = 
	{	
		enter = function (state, mob, info)			
			mob:Dead()
		end,
		
		process = function (state, mob, info)
		end,
	}

	SET_STATE_HANDLER( stateList[STATE_IDLE], idleState )
	SET_STATE_HANDLER( stateList[STATE_ATTACK1], playState )
	SET_STATE_HANDLER( stateList[STATE_WEAK1], g_AIStateFactory.RunawayFromPlayer(MOTION_NONE, STATE_ATTACK1) )
	SET_STATE_HANDLER( stateList[STATE_CALLED], calledState )
	SET_STATE_HANDLER( stateList[STATE_DEAD], g_AIStateFactory.LeaveRanch(RANCH_PORTAL_POS, MOTION_NONE, MOTION_NONE) )	
	SET_STATE_HANDLER( stateList[STATE_DEAD_IM], goodbyeState )
	
	return stateList
end,
}

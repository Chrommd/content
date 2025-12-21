-- module setup
require('aihelper')
require('logic_ranch_config')

--BUILD_CONDITION({
--	{ info.patrol_path },	{ NEXT_STATE( info, STATE_PATROL ) },
--	{},						{ NEXT_STATE( info, STATE_ATTACK1 ) },
--})
				
STAND_MODE = false
ENABLE_FORCE_GAZE = false		-- 강제로 계속 쳐다보는 상태
CALL_CHECK_LIMIT = 500

-- 부산한 : 리더가 이동하는 좌표
--BUSY_LEADER_POS  = v3(92.50, 0.73, -16.37)

--EXCITED_POSITIONS = 
--{
--	v3(46.35, -0.24, 16.63),
--	v3(30.20, -0.38, 8.34),
--	v3(0.37, 0.03, 3.63),
--	v3(2.84, -0.39, 25.72),
--	v3(35.09, 0.15, 35.20),
--}

-- 퍼레이드 좌표
--PARADE_POSITIONS =
--{
--	v3(46.35, -0.24, 16.63),
--	v3(30.20, -0.38, 8.34),
--	v3(0.37, 0.03, 3.63),
--	v3(2.84, -0.39, 25.72),
--	v3(35.09, 0.15, 35.20),
--}

DEFAULT_HORSE_STAND_DIST = 4		-- 기본적으로 떨어져있는 거리


HORSE_INJURY_LIMIT_VELOCITY	= 5 / 3.6		-- 10Km/h

function SetHorseVelocity(mob, velocity)

	local mountInfo = mob:GetMountInfo()
	if mountInfo ~= nil then
		-- 어떤 부상이든지 있으면 속도 제한
		if mountInfo.injury ~= MountInjury_None then
			mob:SetVelocity( HORSE_INJURY_LIMIT_VELOCITY  )
			return
		end
	end

	mob:SetVelocity( velocity  )	
end

function GetGroupAction(mob)
	local mountInfo = mob:GetMountInfo()
	if mountInfo ~= nil then
		return mountInfo:GetGroupAction()
	end
	return MountGroupAction_Normal
end

function IsIndivisualMoving(mob)
	local groupAction = GetGroupAction(mob)
	if groupAction == MountGroupAction_Indivisual
		or groupAction == MountGroupAction_Gloomy
		or groupAction == MountGroupAction_Pairing 
		or groupAction == MountGroupAction_Excited
	then
		return true
	end

	return false
end

function IsGroupActionByLeader(groupAction)
	return groupAction==MountGroupAction_Busy
			or groupAction==MountGroupAction_Parade
end
		
function IsGroupActionNoIdleTime(groupAction)
	return groupAction==MountGroupAction_Excited
			or groupAction==MountGroupAction_Parade
end

function GetIndivisualDist(info, mob)
	local groupAction = GetGroupAction(mob)
	
	-- 정말 개인주의인 경우에만 거리 설정
	if groupAction == MountGroupAction_Indivisual then
		return info.groupIndivisualDist
	end

	return DEFAULT_HORSE_STAND_DIST
end

function ActivateHorseGroupAction(info, mob, groupAction)
	-- 새 groupForce에 따른 값을 설정
	if groupAction == MountGroupAction_Busy then
		info.avoidVelocity = info.avoidVelocity + info.groupBusyBonusVelocity
		info.defaultVelocity = info.defaultVelocity + info.groupBusyBonusVelocity 
		info.idleTimeMin = info.idleTimeMin * info.groupBusyIdleRatio
		info.idleTimeMax = info.idleTimeMax * info.groupBusyIdleRatio
		
		SetHorseVelocity( mob, info.defaultVelocity  )
		--print('activate busy\n')
	elseif groupAction == MountGroupAction_Excited then
		info.defaultVelocity = info.defaultVelocity + info.groupExcitedAddVelocity 

	elseif groupAction == MountGroupAction_Parade then
		info.groupBusyRatio = info.groupBusyRatio + info.groupParadeAddBusyRatio 
		info.defaultVelocity = info.defaultVelocity + info.groupParadeAddVelocity
		info.friendlyActionRatio = info.friendlyActionRatio + info.groupParadeAddFriendlyActionRatio

	elseif groupAction == MountGroupAction_Gloomy then
		info.randomMoveDist = info.randomMoveDist + info.groupGloomyDistChange
	elseif groupAction == MountGroupAction_Pairing then

		info.randomMoveDist = info.randomMoveDist + info.groupPairingDistChange

		local minDist = 0
		local findOID = 0
		local minInfo = nil
		for oid,otherInfo in pairs(g_MobList) do
			local otherMob = mgr:GetMob(oid)
			if otherMob~=nil and mob:GetObjID()~=oid then
				--print('['..otherMob:GetObjID()..'] '..otherMob:GetMobName()..'\n')
				local otherMountInfo = otherMob:GetMountInfo()
				if otherMountInfo ~= nil then					
					-- 짝이 없는 말인 경우
					if otherInfo ~= nil and otherInfo.groupPair==0 then

						-- 거리가 가장 가까운 애를 찾자.
						local dist = otherMob:GetDist(otherMob:GetPos())
						if findOID==0 or dist < minDist then
							minDist = dist
							minInfo = otherInfo
							findOID = oid
						end
					end
				end
			end
		end
				
		if findOID ~= 0 then
			info.groupPair = findOID
			minInfo.groupPair = mob:GetObjID()
			--print('[짝꿍 설정] '..mob:GetObjID()..' <--> '..findOID..'\n')
		end
	end

	info.prevGroupAction = groupAction
end

function DeactivateHorseGroupAction(info, mob)
	-- 원래 값으로 돌려줌
	if info.prevGroupAction == MountGroupAction_Busy then
		info.avoidVelocity = info.avoidVelocity - info.groupBusyBonusVelocity
		info.defaultVelocity = info.defaultVelocity - info.groupBusyBonusVelocity 

		info.idleTimeMin = info.idleTimeMin / info.groupBusyIdleRatio
		info.idleTimeMax = info.idleTimeMax / info.groupBusyIdleRatio

		SetHorseVelocity( mob, info.defaultVelocity  )
		--print('deactivate busy\n')
	elseif info.prevGroupAction == MountGroupAction_Excited then
		info.defaultVelocity = info.defaultVelocity - info.groupExcitedAddVelocity 
	elseif info.prevGroupAction == MountGroupAction_Parade then
		info.groupBusyRatio = info.groupBusyRatio - info.groupParadeAddBusyRatio 
		info.defaultVelocity = info.defaultVelocity - info.groupParadeAddVelocity
		info.friendlyActionRatio = info.friendlyActionRatio - info.groupParadeAddFriendlyActionRatio
	elseif info.prevGroupAction == MountGroupAction_Gloomy then
		info.randomMoveDist = info.randomMoveDist - info.groupGloomyDistChange
	elseif info.prevGroupAction == MountGroupAction_Pairing then
		info.randomMoveDist = info.randomMoveDist - info.groupPairingDistChange
		info.groupPair = 0
	end

	info.prevGroupAction = MountGroupAction_Normal
end

function SetHorseGroupForce(info, mob, groupForce)

	local mountInfo = mob:GetMountInfo()
	if mountInfo ~= nil and mountInfo.groupForce ~= groupForce then
		
		-- 원래 값으로 돌려줌
		DeactivateHorseGroupAction(info, mob)

		-- groupForce 변경
		mountInfo.groupForce = groupForce

		-- client에 알려줌 for debug
		mgr:SendEventToClient( EVENT_DEV_SET_GROUP_FORCE, mob:GetObjID(), groupForce )

		ActivateHorseGroupAction(info, mob, mountInfo:GetGroupAction())
	end
end

function GetFeelingLevel(mob)
	local mountInfo = mob:GetMountInfo()
	if mountInfo ~= nil then
		return RanchHorseConfig.GetFeelingLevel(mountInfo)	
	end
	return 0
end

--
-- 특정 MountCondition의 단계를 넘겨준다.
-- 0-----|-----|-----100   : value
--    1     2      3       : step
--
function GetMountConditionStep(mob, cond)

	local mountInfo = mob:GetMountInfo()
	if mountInfo ~= nil then
	
		-- 관리 정지가 되면..  1단계로 처리
		local stopAmends = (mountInfo:GetMountConditions(MountCondition_StopAmendsPoint) == kMAX_NORMAL_MANAGE_POINT)
		if stopAmends then
			return 1
		end
		
		local curValue = mountInfo:GetMountConditions(cond)
		local stepCount = table.getn(ConditionPoints[cond])
		for step=stepCount,1,-1 do
			local divideValue = mountInfo:GetMountConditionDivideValue(cond, step-1)
			if curValue >= divideValue then
				--__DEBUG('--> GetMountConditionStep('..cond..') = '..step..'\n')
				return step
			end
		end
	else
		__DEBUG('MountInfo is NULL\n')
	end
	
	--__DEBUG('--> GetMountConditionStep('..cond..') = 1 (not match)\n')
	return 1
end

g_AIFactory['ranch_horse'] = 
{

onInit = function (info, mob)
	info.hp_max = 100000
	info.hp		= info.hp_max	
	info.pivotPos = mob:GetPos()
	
	info.createIdleDelayTime	= 5	
	info.defaultVelocity		= 1.4
	
	info.firstIdleTimeMin		= 5				-- 최초로 이동한 후의 idle시간 랜덤 범위 min~max
	info.firstIdleTimeMax		= 25
	
	info.idleTimeMin			= 35			-- 한번 이동한 후의 idle시간 랜덤 범위 min~max
	info.idleTimeMax			= 55
	
	info.calledVelocity			= 6				-- 호출했을때 달려오는 속도
	info.calledSlowVelocity		= 4				-- 호출했을때 달려오다가 가까워지면 느려지는 속도
	info.calledSlowNearVelocity	= 2				-- 호출했을때 달려오다가 완전(!) 가까워지면 느려지는 속도
	
	info.calledSlowNearDist		= 5				-- 호출시 완전 느려지기 시작하는 플레이어와의 실제 거리 체크
	
	info.avoidDistance			= 9				-- 플레이어가 이 거리 안쪽에서 위협적인 행동을 하면 도망간다
	info.avoidVelocity			= 15			-- 도망갈때 속도
	info.slowAvoidDist			= 4				-- 도망갈때 속도가 느려지는 도착지점과의 거리
	info.avoidSlowVelocity		= 7				-- 느려질떄의 속도
						
	info.loveMotionDist			= 8				-- 애정표현 후 쫓아다닐때, 플레이어와이 거리 이하일때는 멈춰있는다.
	info.lookPlayerDist			= 15			-- 친밀도에 따라 바라볼 가능성이 있는 플레이어와의 최대거리
	info.lookHorseDist			= 10			-- 주변에 다른 말을 바라볼 가능성이 있는 다른 말과의 최대거리
	
	info.callSuccessRatio		= 100			-- 호출 성공 확률 100%
	info.callDistance			= RanchHorseConfig.CallDistance			-- 불렀을 때 반응하는 거리
	info.friendlyCheckDist		= RanchHorseConfig.CallDistance			-- 그냥 가끔 다가오는 거리
	info.friendlyCheckMinDelay	= 10			-- 이 시간(min~max)마다 한번씩 친밀도 표현여부를 체크한다.
	info.friendlyCheckMaxDelay	= 20			-- max값
	info.friendlyActionRatio	= 10			-- 확률(100%)
	info.friendlyAutoCallRatio	= 20			-- 가끔 다가올 확률
	
	info.traceHorseMinDist		= 12			-- 이 거리 이상 멀어져야 접근한다.
	info.runawayMaxDelay		= 0.3			-- 도망가기 직전의 랜덤딜레이
	
	info.feedMotionDelay		= 5				-- 풀뜯기 모션 한번의 플레이 시간
	info.slowApproachDist		= 5				-- 호출 시 가까우면 천천히 걷는 거리
	
	info.feedRatio				= 30			-- 풀뜯기 확률(100%기준)
	info.feedCountMin			= 3				-- 풀뜯을 회수 최소값
	info.feedCountMax			= 5				-- 풀뜯을 회수 최대값
	info.lookNearRatio			= 50			-- 풀뜯기 안할때, 주변의 대상을 바라볼 확률
	info.lookPlayerRatio		= 40			-- 대상을 바라볼때, 플레이어 바라볼 확률(아니면 다른 말을 본다)
	info.cautionRatio			= 25			-- 가만히 있는 경우, 경계 동작 플레이 확률(BAD)
	info.cautionRatioVeryBad	= 50			-- 가만히 있는 경우, 경계 동작 플레이 확률(VERY_BAD)
	
	info.freeVelocity			= 6				-- 삭제시 포탈로 갈때 속도
	info.freeSlowVelocity		= 2				-- 포탈 근처에서 천천히 걷기
	info.slowFreeApproachDist	= 5				-- 포탈 근처 느려지는 거리	
	
	-- 강제로 바라보기 테스트용
	if ENABLE_FORCE_GAZE then
		info.feedRatio			= 0
		info.lookPlayerRatio	= 100
		info.idleTimeMin		= 160
		info.idleTimeMax		= 170
	end
	
	info.firstIdle = true	-- 최초 idle 시간 셋팅용	
	info.angryPoint = 0		-- 성질내기 포인트
	info.angryResetTime = 0
	info.angryResetDelay = 60 -- 가만히 두면 60초마다 리셋

	info.randomMoveDist			= 10		-- pivot에서 랜덤으로 이동하는 거리
	
	-- 그룹 액션에 대한 확률
	info.groupFeedGreedyRatio		= 3		-- 그룹 풀뜯기 확률 2배 증가
	info.groupFeedCountGreedyRatio	= 3		-- 그룹 풀뜯기 횟수 2배 증가
	info.groupFeedBusyRatio			= 0.5	-- 그룹 풀뜯기 횟수 1/2 감소
	info.groupFeedCountBusyRatio	= 0.5	-- 그룹 풀뜯기 횟수 1/2 감소
	info.groupBusyIdleRatio			= 0.3	-- idle시간 감소
	info.groupBusyBonusVelocity		= 2		-- 그룹 부산할때 빨라지는 속도
	info.groupIndivisualDist		= 12	-- 그룹 개인주의때 떨어져 있을 거리
	info.groupBusyRatio			= 75	-- 20% 확률로 이동시에 지정된 위치로 달려감
	info.groupBusyVelocity		= 13	-- 그룹 정신없이 빠르게 다가가는 속도
	info.groupBusySlowDist		= 5		-- 가까이서 서서히 접근하는 거리
	info.groupBusySlowVelocity	= 7		-- 가까이 접근하는 속도

	info.groupExcitedPosIndex	= 0		-- 정신없는. 순환 좌표 
	info.groupExcitedAddVelocity = 2	-- 정신없을때 추가 속도

	info.groupGloomyDistChange	= -8			-- 음침한..이 될때 이동 범위 줄이기(info.randomMoveDist보다 적어야됨)
	info.groupPairingDistChange	= -7			-- 짝꿍될때 이동 범위 줄이기
	info.groupPairingOtherDist	= 12		-- 다른 pair와 멀어지기

	info.groupPair = 0					-- 짝꿍 OID

	info.groupParadeAddBusyRatio	= 100	-- 퍼레이드 시에 리더 이동 확률
	info.groupParadePosIndex		= 0
	info.groupParadeAddVelocity		= 5		-- 퍼레이드 시에 추가 속도
	info.groupParadeAddFriendlyActionRatio = -100	-- 퍼레이드 시 플레이어 따라가기 확률 없앰
	info.groupParadeMoveNextDist	= 3		-- 목표 지점 근처면 다음 좌표로 간다.
end,

onAddAfter = function (info, mob)

	--mob:Scale( s, s, s )
	SetHorseVelocity( mob, info.defaultVelocity  )
	
	info.prevGroupAction = MountGroupAction_Normal
	--print('['..mob:GetObjID()..'] '..mob:GetMobName()..'\n')
	local mountInfo = mob:GetMountInfo()
	if mountInfo ~= nil then
		ActivateHorseGroupAction(info, mob, mountInfo:GetGroupAction())		
	end
			
	-- 정신 없는 : 순환하는 좌표
	if EXCITED_POSITIONS==nil then
		mgr:SetMobPath(mob, 'horse_point_02', 'groupExcitedPos')
		EXCITED_POSITIONS = info.groupExcitedPos
	else
		info.groupExcitedPos = EXCITED_POSITIONS	
	end

	if PARADE_POSITIONS==nil then
		mgr:SetMobPath(mob, 'horse_point_08', 'groupParadePos')
		PARADE_POSITIONS = info.groupParadePos
	else
		info.groupParadePos	= PARADE_POSITIONS
	end
end,

createState = function ()
	local stateList = {}
	stateList.motion = {}
	local motion = stateList.motion
	
	--                        { Name,			StateName,			aniDelay }
	motion[MOTION_IDLE]		= { name='Idle',	state='GRAZE_IDLE',	aniDelay=0.5 }
	motion[MOTION_MOVE]		= { name='Move',	state='MOVE_ZERO',	aniDelay=0.1 }
	motion[MOTION_MOVE2]	= { name='Move2',	state='MOVE_2ND',	aniDelay=0.1 }
	motion[MOTION_MOVE3]	= { name='Move3',	state='MOVE_3RD',	aniDelay=0.1 }
	motion[MOTION_JUMP]		= { name='Jump',	state='JUMP',		aniDelay=0.5 }
	motion[MOTION_EAT_FOOD]		= { name='Feed',	state='EAT_FOOD', aniDelay=0.3 }
	motion[MOTION_EAT_FOOD_END]	= { name='FeedEnd',	state='EAT_FOOD_END', aniDelay=1.7 }
	motion[MOTION_ANI2]		= { name='Called',	state='COURBETTE', aniDelay=1.5 }	
	motion[MOTION_ANI3]		= { name='Love',	state='WAY_LOST', aniDelay=5 }			-- CARE_CLEAN_COMPLETE
	motion[MOTION_TURN_L]	= { name='TurnLeft',state='ROTATE_L', aniDelay=1 }
	motion[MOTION_TURN_R]	= { name='TurnRight',state='ROTATE_R', aniDelay=1 }
	motion[MOTION_ATTACKED1]= { name='PlayDead',state='WAY_LOST', aniDelay=3 }		-- ITEM_NORMAL_DMG
	motion[MOTION_ANI4]		= { name='CommUp',  state='WAY_LOST', aniDelay=3 }	-- COMMUNION_UP
	motion[MOTION_ANI5]		= { name='TurnRound',state='WAY_LOST', aniDelay=3 }		-- GOAL_MOTION1
	motion[MOTION_ANI6]		= { name='Caution', state='DISPLEASED', aniDelay=4.3 }		
	motion[MOTION_ANI7]		= { name='ByePrepare',	state='COURBETTE', aniDelay=1.5 }	
	motion[MOTION_ANI8]		= { name='ByeLast',		state='WAY_LOST', aniDelay=2.5 }		-- CARE_CLEAN_COMPLETE 모션 시간을 약간 짧게 줘야 모션하면서 사라진다.
	motion[MOTION_ANI9]		= { name='SearchFailed',state='WAY_LOST', aniDelay=2.83 }	
	motion[MOTION_ANI10]	= { name='Busy',	state='COURBETTE', aniDelay=1.5 }	
	
	stateList[STATE_IDLE]	= { name='Idle',	procDelay=0.2 }
	stateList[STATE_PATROL]	= { name='Patrol',	procDelay=0.2 }
	stateList[STATE_ATTACK1]= { name='Attack1',	procDelay=0.1 }
	stateList[STATE_WEAK1]	= { name='Weak1',	procDelay=0.2 }
	stateList[STATE_CALLED] = { name='Called',	procDelay=0.2 }
	stateList[STATE_DEAD]	= { name='GoodBye',	procDelay=0.1 }	

	
	-- 최초 정지 상태
	local idleState = 
	{	
		enter = function (state, mob, info) 
			local pos = mob:GetPos()
			local lookPos = v3( pos.x + RAND(-10,10), pos.y, pos.z + RAND(-10,10) )
			mob:LookAt( lookPos )
			state.randomDelay = info.curTime + info.createIdleDelayTime + RAND(0, 1.5)
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
			state.moving = true
			state.moveTiming = info.curTime		
			info.traceHorseTime = info.curTime	
			state.checkFriendlyTime = info.curTime + RAND(info.friendlyCheckMinDelay, info.friendlyCheckMaxDelay)
			state.cautionTime = nil
			state.gazeTime = nil
			state.forceNewMove = nil
			info.feelingLevel = GetFeelingLevel(mob)
			info.feelingLevelTime = info.curTime
		end,
		
		process = function (state, mob, info)
		
			if info.curTime >= info.angryResetTime then
				info.angryPoint = 0
				info.angryResetTime = info.curTime + info.angryResetDelay
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
				local playerDist = mob:GetDist(player:GetPos())
				if playerDist < distance then
					
					-- 도망가기전까지의 랜덤한 대기 딜레이
					local runawayTiming = RAND(0, info.runawayMaxDelay)
					
					if runawayTiming < 0.05 then
						-- 즉시 도망
						NEXT_STATE( info, STATE_WEAK1 )
					else
						-- 잠시 머뭇거리다 도망가는것처럼 보이게
						state.runawayTime = info.curTime + runawayTiming
					end
					return

				-- 플레이어랑 너무 가까우면 바로 다시 이동한다.
				elseif playerDist <= 2 and mob:IsArrived() then
					state.moveTiming = info.curTime
					state.forceNewMove = true
				end
			end
			
			-- 바라보고 있다가 시간이 다 됐으면 바라보기 종료
			if state.gazeTime ~= nil then
				if info.curTime >= state.gazeTime then
					mob:GazeAt(0, GAZE_NONE)
					--__DEBUG('gaze end(time)\n')
					state.gazeTime = nil
				end
			end

			-- busy
			if info.busyMove then
			
				info.busyMove = nil
					
				-- 부산한 상태! BUSY_LEADER_POS로 간다.
				SetHorseVelocity( mob, info.groupBusyVelocity )

				if BUSY_LEADER_POS==nil then
					mgr:SetMobPath(mob, 'horse_point_02', 'groupBusyLeaderPos')
					BUSY_LEADER_POS = info.groupBusyLeaderPos
				else
					info.groupBusyLeaderPos	= BUSY_LEADER_POS
				end				
				
				local targetPos = v3(46.35, -0.24, 16.63)

				if info.busyLeader then
					if info.groupBusyLeaderPos~=nil then
						local posCount = table.getn(info.groupBusyLeaderPos)
						if posCount > 0 then				
							local leaderPos = info.groupBusyLeaderPos[ RAND(1,posCount) ]
							targetPos = v3( leaderPos.x + RAND(-5,5), leaderPos.y, leaderPos.z + RAND(-5,5) )
						end
					end
				else
					targetPos = v3( info.busyLeaderPos.x + RAND(-5,5), info.busyLeaderPos.y, info.busyLeaderPos.z + RAND(-5,5) )
				end

				if mob:MovePath(targetPos.x, targetPos.y, targetPos.z, apporachDist, checkCount) then
					info.pivotPos = targetPos
					state.moving = true
					info.busyMoving = true
					info.busyNeedToSlow = true

					-- 다른 말들에게 알린다 --> intro_start_server.lua에서 처리됨
					if info.busyLeader then
						OnEvent(EVENT_SCRIPT, "", SS_EVENT_HORSE_LEADER_BUSY, mob:GetObjID())
						info.busyLeader = nil
					end
				else
					-- cancel velcity
					SetHorseVelocity( mob, info.defaultVelocity  )
				end
			end
			
			-- parade
			if info.paradeMoving and info.paradeLeader then
				
				local remainDist = mob:GetRemainDist()
				if remainDist < info.groupParadeMoveNextDist then
					--print('MOVE NEXT-----> '..remainDist..'\n')
					info.paradeMove = true
				end
			end

			if info.paradeMove then
				info.paradeMove = nil

				SetHorseVelocity( mob, info.defaultVelocity )

				if info.paradeLeader then
					local maxPosIndex = table.getn(info.groupParadePos)
					info.groupParadePosIndex = info.groupParadePosIndex + 1
					if info.groupParadePosIndex > maxPosIndex then
						info.groupParadePosIndex = 1
					end
					info.pivotPos = info.groupParadePos[info.groupParadePosIndex]
				end			
				
				local targetPos = v3( info.pivotPos.x + RAND(-2,2), info.pivotPos.y, info.pivotPos.z + RAND(-2,2) )

				if mob:MovePath(targetPos.x, targetPos.y, targetPos.z, apporachDist, checkCount) then
					info.paradeMoving = true
					state.moving = true
					
					-- 다른 말들에게 알린다 --> intro_start_server.lua에서 처리됨
					if info.paradeLeader then
						OnEvent(EVENT_SCRIPT, "", SS_EVENT_HORSE_LEADER_PARADE, mob:GetObjID())
						--info.paradeLeader = nil
						--print('notify parade\n')
					end
				end
			end

			-- 짝꿍 따라가기
			if info.pairTraceMove then
			
				info.pairTraceMove = nil
					
				-- 나보다 OID가 높으면 따라간다.
				if info.groupPair < mob:GetObjID() then
					local pairMob = mgr:GetMob(info.groupPair)
					if pairMob ~= nil then
						info.pivotPos = pairMob:GetMovePos()
						local targetPos = v3( info.pivotPos.x + RAND(-2,2), info.pivotPos.y, info.pivotPos.z + RAND(-2,2) )

						if mob:MovePath(targetPos.x, targetPos.y, targetPos.z, apporachDist, checkCount) then
							state.moving = true
							info.pairTraceMoving = true					
						end
					end
				end
			end
			
			-- 멈춰있는 상태		
			if mob:IsArrived() then
			
				if STAND_MODE then
					return
				end
			
				-- 강제 이동이 안 켜져 있는 경우에 [풀뜯기] or [경계 동작]
				if state.forceNewMove==nil then
				
					-- 풀 뜯기 진행 중
					if state.feedCount~=nil and state.feedCount > 0 then
						if info.curTime >= state.feedMotionTiming then
							
							-- 풀뜯기 동작 보여줌
							if mob:GetState() ~= MOTION_EAT_FOOD then
								PLAY_MOTION( info, mob, MOTION_EAT_FOOD )
							end
							
							state.feedMotionTiming = info.curTime + RAND(5,7)
							state.feedCount = state.feedCount - 1
							
							if state.feedCount<=0 then
								state.feedCount = nil
								
								-- 풀뜯기 도중이라면 끝나는 동작 출력
								if mob:GetState() == MOTION_EAT_FOOD then
									PLAY_MOTION( info, mob, MOTION_EAT_FOOD_END )
								end
							end
						end
						
						return
					end
					
					-- 실제 경계 동작 출력
					if state.cautionTime~=nil and info.curTime >= state.cautionTime then				
						PLAY_MOTION( info, mob, MOTION_ANI6 )
						state.cautionTime = nil
					end
				end
							
				-- 방금까지 이동하다가 멈춘 경우				
				if state.forceNewMove==nil and state.moving then
					state.moving = false

					-- 부산한: 빠르게 다가가다 멈춘경우
					if info.busyMoving then
						info.busyMoving = nil
						SetHorseVelocity( mob, info.defaultVelocity  )
					end
					
					-- 짝꿍 따라가다 멈춘 경우
					if info.pairTraceMoving then
						info.pairTraceMoving = nil						
					end
					
					-- 너무 가까워서 충돌하는 경우 처리
					local collisionDist = 4
					local collMob = info.paradeMoving and nil or mgr:FindNearMob( mob:GetPos(), collisionDist, mob:GetObjID() )
					local collPlayer = info.paradeMoving and nil or mgr:FindNearPlayer( mob )

					-- 퍼레이드 이동 초기화
					if info.paradeMoving then
						info.paradeMoving = nil
						SetHorseVelocity( mob, info.defaultVelocity  )
					end

					if collMob ~= nil or collPlayer ~= nil and mob:GetDist( collPlayer:GetPos() ) < collisionDist then
						state.moveTiming = info.curTime + 0.2
						
						--local targetOID = collMob~=nil and collMob:GetObjID() or collPlayer:GetObjID()
						--print('collision:'..mob:GetObjID()..' -> '..targetOID..'\n')
					else					

						-- 그룹 '먹자' 상태면 풀뜯을 확률 증가
						local feedBonusRatio = 1
						local feedCountBonusRatio = 1
						local enableLook = true
						local enableFeed = true
						local groupAction = GetGroupAction(mob)

						-- 그룹 행동이 변화된 경우 
						if groupAction ~= info.prevGroupAction then
							DeactivateHorseGroupAction(info, mob)
							ActivateHorseGroupAction(info, mob, groupAction)							
						end

						-- 정신 없는
						if groupAction==MountGroupAction_Excited 
							or groupAction==MountGroupAction_Parade then
							enableLook = false
							enableFeed = false

						-- 먹자
						elseif groupAction==MountGroupAction_Greedy then
							
							feedBonusRatio		= info.groupFeedGreedyRatio
							feedCountBonusRatio = info.groupFeedCountGreedyRatio

						-- 그룹 '부산한' 상태면 풀뜯기 확률 감소
						elseif groupAction==MountGroupAction_Busy then

							feedBonusRatio		= info.groupFeedBusyRatio
							feedCountBonusRatio = info.groupFeedCountBusyRatio

						end

						local feedRatio = info.feedRatio * feedBonusRatio
						local feedTiming = enableFeed and RAND(1,100) < feedRatio		-- 30%확률로 풀을 뜯자.
						
						if feedTiming then
							--mob:Stop()
					
							-- 풀 뜯기 ㄱㄱ
							-- 다음 이동할 시간
							state.feedCount = math.floor( RAND(info.feedCountMin, info.feedCountMax) * feedCountBonusRatio )
							local startFeedDelay = RAND(1,2)
							state.feedMotionTiming = info.curTime + startFeedDelay
							state.moveTiming = info.curTime + startFeedDelay + state.feedCount*info.feedMotionDelay + RAND(1,5)	
						else
							-- 정지
							--mob:Stop()
							--PLAY_MOTION( info, mob, MOTION_IDLE )
							
							-- 가끔 주변을 본다.
							local lookTiming = enableLook and RAND(1,100) < info.lookNearRatio
							if lookTiming then

								-- 가까운 플레이어를 바라보는 경우(친밀도 체크)
								local lookPlayerRatio = RAND(1,100) < info.lookPlayerRatio
								if lookPlayerRatio then
									local nearPlayer = mgr:FindNearPlayer(mob)
									if nearPlayer ~= nil and mob:GetDist(nearPlayer:GetPos()) <= info.lookPlayerDist then								
										local friendlyStep = GetMountConditionStep(mob, MountCondition_FriendlyPoint)
										
										if friendlyStep >= 2 then
											--PLAY_MOTION( info, mob, MOTION_TURN_L )
											mob:GazeAt(nearPlayer:GetObjID(), GAZE_FAVOR)
											state.gazeTime = info.curTime + RAND(5,15)
											--__DEBUG('gaze start\n')
										end
									end

								-- 주변에 다른 말을 바라본다.
								else
									local checkDist = info.lookHorseDist
									local nearMob = mgr:FindNearMob(mob:GetPos(), checkDist, mob:GetObjID())
									if nearMob ~= nil then
										mob:GazeAt(nearMob:GetObjID(), GAZE_FAVOR)
										state.gazeTime = info.curTime + RAND(10,20)	
									end
								end
							end

							local noIdleTime = IsGroupActionNoIdleTime(groupAction)
							
							-- 다음 이동할 시간을 정한다.
							if info.firstIdle then
								info.firstIdle = false
								state.moveTiming = info.curTime + RAND(info.firstIdleTimeMin, info.firstIdleTimeMax)
							else

								if noIdleTime then
									-- 정신없는 상태일때는 바로 이동
									state.moveTiming = info.curTime
								else
									state.moveTiming = info.curTime + RAND(info.idleTimeMin, info.idleTimeMax)
								end
	
							end
							
							-- 30초마다 한번씩 값 update  --> 말 갈아타기 때문에 무조건 계산
							--if info.curTime >= info.feelingLevelTime + 30 then
								info.feelingLevel = GetFeelingLevel(mob)
							--	info.feelingLevelTime = info.curTime
							--end
					
							-- 기분이 나쁘면 경계모션을 보여주도록 한다.
							if not noIdleTime and info.feelingLevel <= FEELING_BAD then				
								local cautionRatio = (info.feelingLevel==FEELING_BAD and info.cautionRatio or info.cautionRatioVeryBad)
								local cautionTiming = RAND(1,100) < cautionRatio		-- 일정 확률로 경계 동작
								if cautionTiming then
									state.cautionTime = info.curTime + RAND(3,8)
								end
							end
						end
					end
				end
				
				-- 멀어지는 경우 주시대상 제거
				local gazeID = mob:GetGazeID()
				if gazeID ~= 0 then
					local gazePlayer = mgr:GetPlayer(gazeID)
					if gazePlayer ~= nil and mob:GetDist(gazePlayer:GetPos()) > info.lookPlayerDist+5 then
						mob:GazeAt(0, GAZE_NONE)
						--__DEBUG('gaze end(far)\n')
					end
				end
			
				-- 이동 딜레이가 끝났으면 --> 이동한다
				if info.curTime >= state.moveTiming then
				
					-- 이동시작하는 경우 주시 대상 없애기
					if mob:GetGazeID() ~= 0 then
						mob:GazeAt(0, GAZE_NONE)
						--__DEBUG('gaze end(move)\n')
					end
				
					-- 따라가기 체크
					--PLAY_MOTION( info, mob, MOTION_MOVE  )
						
					local pos
					local pivotPos = info.pivotPos
					local moveType = RAND(1,3)

					-- 개인주의면 안 따라간다.
					local checkDist = DEFAULT_HORSE_STAND_DIST
						
					local enableFollowing = not IsIndivisualMoving(mob)
					if not enableFollowing then
						checkDist = GetIndivisualDist(info, mob)
					end
						
					-- 가끔 플레이어 따라가기
					if enableFollowing and state.forceNewMove==nil and state.checkFriendlyTime ~= nil 
						and info.curTime >= state.checkFriendlyTime 
						and RAND(1,100) <= info.friendlyActionRatio then
							
						local ranchOwnerOID = mgr:GetOwnerOID()
						local ranchOwner = mgr:GetPlayer( ranchOwnerOID )
						if ranchOwner ~= nil and mob:GetDist( ranchOwner:GetPos() ) <= info.friendlyCheckDist then
							-- 친밀도 체크해서 
							local friendlyStep = GetMountConditionStep(mob, MountCondition_FriendlyPoint)
							local autoCall = RAND(1,100) < info.friendlyAutoCallRatio

							-- 3단계 이상이면 다가가고
							if autoCall and friendlyStep >= 3 then
								info.callerOID = ranchOwnerOID
								NEXT_STATE( info, STATE_CALLED )
									
							-- 2단계 이상이면 바라본다.
							elseif friendlyStep >= 2 then
								mob:GazeAt(ranchOwnerOID, GAZE_FAVOR)
								state.gazeTime = info.curTime + RAND(5,15)									
							end
								
							return
						end
							
						state.checkFriendlyTime = info.curTime + RAND(info.friendlyCheckMinDelay, info.friendlyCheckMaxDelay)
					end
						
					-- 레벨 높은 말 따라가기						
					if enableFollowing and state.forceNewMove==nil and info.traceHorseOID == nil and info.curTime >= info.traceHorseTime then
						
						info.traceHorseTime = info.curTime + 10
							
						local highMob = mgr:FindHighestLevelMob( mob:GetPos(), 100 )

						local apporachDist = RAND(3, 5)
						local checkCount = 200

						-- 그룹 '정신없는' 상태에서 리더 말인 경우
						local groupAction = GetGroupAction(mob)
						if highMob~=nil and highMob:GetObjID()==mob:GetObjID() and IsGroupActionByLeader(groupAction) and RAND(1,100) <= info.groupBusyRatio then
								
							--print('busy\n')

							if groupAction==MountGroupAction_Busy then
								-- busy 동작 출력
								PLAY_MOTION( info, mob, MOTION_ANI9 )
								info.busyMove = true
								info.busyLeader = true
							elseif groupAction==MountGroupAction_Parade then 
								--print('parade\n')
								info.paradeMove = true
								info.paradeLeader = true
							end

							return
								
						elseif highMob~=nil and highMob:GetObjID()~=mob:GetObjID() and mob:GetDist( highMob:GetPos() ) >= info.traceHorseMinDist then
							local highPos = highMob:GetPos()
							highPos.x = highPos.x + RAND(-10, 10)
							highPos.z = highPos.z + RAND(-10, 10)
								
							if mob:MovePath(highPos.x, highPos.y, highPos.z, apporachDist, checkCount) then
								info.pivotPos = highPos
								state.moving = true
								return
							end
						end							
					end

					local pairOID = 0

					--  정신 없는 : 좌표 순환
					local isPairing = false
					local isPairTracer = false
					local isWideRandom = true
					local groupAction = GetGroupAction(mob)
					if groupAction==MountGroupAction_Excited then

						local maxPosIndex = table.getn(info.groupExcitedPos)
						info.groupExcitedPosIndex = info.groupExcitedPosIndex + 1
						if info.groupExcitedPosIndex > maxPosIndex then
							info.groupExcitedPosIndex = 1
						end

						info.pivotPos = info.groupExcitedPos[info.groupExcitedPosIndex]
					else
						-- 음침한이나 짝꿍은 지정 위치에서 많이 벗어나지 않는다.
						local isGloomy = (groupAction==MountGroupAction_Gloomy)
						isPairing = (groupAction==MountGroupAction_Pairing)
						
						-- 짝꿍이 있는 상태
						if isPairing and info.groupPair~=0 then
							-- 나보다 OID가 높으면 따라간다.
							if info.groupPair < mob:GetObjID() then
								local pairMob = mgr:GetMob(info.groupPair)
								if pairMob ~= nil then
									info.pivotPos = pairMob:GetMovePos()
									--print('[짝꿍] '..mob:GetObjID()..' --> '..pairMob:GetObjID()..'\n')
									
									pairOID = info.groupPair
									checkDist = info.groupPairingOtherDist
									isPairTracer = true
								end
							end
						end

						isWideRandom = (not isGloomy and not isPairing or isPairing and not isPairTracer)
						
					end

					-- 딱히 따라갈 대상이 없으면 주변으로 적당히 이동
					-- 적당히 랜덤하게 원래 있던 근처 위치를 계산
					-- 충돌 안하는 위치를 뽑기 위해서 몇번만 체크해보자
					for i=1,5 do				
					
						if isWideRandom	then
							if moveType==1 then
								pos = GetFrontPos(pivotPos, mob:GetDir(), RAND(5,20))		-- 앞쪽
							elseif moveType==2 then
								pos = GetLeftPos(pivotPos, mob:GetDir(), RAND(5,15))		-- 왼쪽
							else
								pos = GetRightPos(pivotPos, mob:GetDir(), RAND(5,15))		-- 오른쪽
							end
						else
							-- 음침한 경우 랜덤 좌표 없음
							pos = pivotPos
						end
							
						local dist = info.randomMoveDist
						pos.x = pos.x + RAND(-dist,dist)
						pos.z = pos.z + RAND(-dist,dist)
							
						-- 목표 위치 주변이 비어있길 바라면서..
						local nearMob = mgr:FindNearMob(pos, checkDist, mob:GetObjID(), pairOID)
						if nearMob == nil then
							break
						end
					end
						
					-- 이동 ㄱㄱ!
					mob:Move(pos.x, pos.y, pos.z)

					-- 짝꿍한테 이동 시작한다고 알린다.
					if isPairing and not isPairTracer and info.groupPair~=0 then
						--print('notice SS_EVENT_HORSE_PAIR_MOVE: '..mob:GetObjID()..'\n')
						OnEvent(EVENT_SCRIPT, "", SS_EVENT_HORSE_PAIR_MOVE, mob:GetObjID())
					end
						
					SET_DELAY(info, 1)	-- 이동 후 잠깐 이동하는 딜레이
					state.moving = true
					
					state.forceNewMove = nil
				end

			-- 계속 이동중인 상태  not mob:IsArrived() 
			else
				
				local checkFrontDist = 5
				local myPos = mob:GetPos()
				local frontMob = mgr:FindNearMob(myPos, checkFrontDist, mob:GetObjID())
				local frontAngle = 40

				-- 정신없이 다가가는 상태
				if info.busyMoving and info.busyNeedToSlow then
					info.busyNeedToSlow = false
					local remainDist = mob:GetRemainDist()
					if remainDist < info.groupBusySlowDist then
						SetHorseVelocity( mob, info.groupBusySlowVelocity  )
					end
				end
				
				-- 앞쪽에 다른 몹이 있다면 정지하자.
				if frontMob ~= nil and IsInFront(myPos, mob:GetDir(), frontMob:GetPos(), frontAngle) then
					
					-- 앞에 있는 애가 정지해있으면 나도 정지
					local needStop = false
					if frontMob:IsArrived() then
						needStop = true
						SET_DELAY(info, RAND(2,5))
						
					-- 앞에 있는 애가 내 방향으로 다가오거나 너무 딱 붙어있으면.. 새 길을 찾자.
					elseif IsInFront(frontMob:GetPos(), frontMob:GetDir(), myPos, frontAngle) or mob:GetDist(frontMob:GetPos()) < 2 then
						local myLevel = mob:GetLevel()
						local frontLevel = frontMob:GetLevel()
						
						-- 레벨에 따라서 렙낮은 쪽이 멈춰서 새로운 행동을 하게 한다.
						if myLevel < frontLevel or myLevel==frontLevel and mob:GetObjID() > frontMob:GetObjID() then
							needStop = true
							state.moveTiming = info.curTime
							state.forceNewMove = true							
						end
					end
					
					if needStop then
						mob:Stop()						
					end
				end
			end
		end,
		
		leave = function (state, mob, info) 
			-- 주시 대상 없애기
			if mob:GetGazeID() ~= 0 then
				mob:GazeAt(0, GAZE_NONE)
				--__DEBUG('gaze end(leave)\n')
			end
		end,
	}
		
	-- 플레이어가 호출한 경우
	local calledState = 
	{	
		enter = function (state, mob, info) 			
			--__DEBUG('[CALL_STATE] callerOID = '..info.callerOID..'\n')
			state.lookAt = false
			state.approachValueCheck = false
			state.callAction = false
			state.movePath = false
			state.retryToFindPath = true
			state.findPathCount = 0
			state.loveMotionTime = nil
			state.followTime = nil
			state.fastMove = true
			state.gazeTime = nil
			info.friendlyStep = GetMountConditionStep(mob, MountCondition_FriendlyPoint)
			--__DEBUG('info.friendlyStep = '..info.friendlyStep..'\n')
			
			mgr:SendEventToClient( EVENT_CALLED_NPC, mob:GetObjID(), info.callerOID )
			
			-- 약간의 바라보기 딜레이
			SET_DELAY(info, RAND(0, 1))
		end,
		
		process = function (state, mob, info)
		
		
			-- 다가가기 하는가 체크(한번만)
			if not state.approachValueCheck then
				state.approachValueCheck = true
				
				--  친밀도가 바라보기 수치보다 낮으면 끝
				if info.friendlyStep < 2 then
					-- 끝 : 무시한다.

					-- 성질내기 체크
					info.angryPoint = info.angryPoint + 10
					info.angryResetTime = info.curTime + info.angryResetDelay
					if info.angryPoint >= RAND(40,70) then
						PLAY_MOTION( info, mob, MOTION_ANI6 )
						info.angryPoint = 0
						
						-- 다른 말들에게 알린다 --> intro_start_server.lua에서 처리됨
						OnEvent(EVENT_SCRIPT, "", SS_EVENT_HORSE_ANGRY, mob:GetObjID())
					end
					
					-- 실패했다고 알려준다.
					mgr:SendEventToClient( EVENT_CALL_NPC_RESULT, info.callerOID, HorseCall_Ignored )

					NEXT_STATE( info, STATE_ATTACK1 )
					return
				end

				-- 성공이긴 한데.. 아직 종류가 뭔지는 모르는 상황?
				mgr:SendEventToClient( EVENT_CALL_NPC_RESULT, info.callerOID, HorseCall_NotIgnored )
			end
			
			-- 쫓아다니기 끝
			if state.followTime ~= nil then
				if info.curTime >= state.followTime then
					-- 끝 : 무시한다.
					NEXT_STATE( info, STATE_ATTACK1 )
				end
			end
			
			-- 바라보기만 하는 상태
			if state.gazeTime ~= nil then
				if info.curTime >= state.gazeTime then
					-- 끝 : 무시한다.
					NEXT_STATE( info, STATE_ATTACK1 )
				end
				return
			end
			
			-- 플레이어 바라보기
			if not state.lookAt then
				state.lookAt = true
				
				--  친밀도가 바라보기 수치보다 커야 바라본다.
				if info.friendlyStep >= 2 then				
					local player = mgr:GetPlayer(info.callerOID)
					if player ~= nil then
						-- 바라보기만 하는 상태
						if info.friendlyStep == 2 then
							
							if mob:GetState() == MOTION_EAT_FOOD then
								PLAY_MOTION( info, mob, MOTION_EAT_FOOD_END )
							else
								PLAY_MOTION( info, mob, MOTION_IDLE )
							end
							mob:GazeAt(player:GetObjID(), GAZE_FAVOR)
							state.gazeTime = info.curTime + RAND(5,15)
							--__DEBUG('gaze start\n')
						else
							mob:Stop()
							mob:LookAt(player:GetPos())
							
							mgr:SendEventToClient( EVENT_NPC_FOLLOW_START, mob:GetObjID(), info.callerOID )
						end						
						
						-- 약간의 액션 딜레이
						SET_DELAY(info, RAND(0, 0.5))					
					end
				else
					-- 끝 : 무시한다.
					NEXT_STATE( info, STATE_ATTACK1 )
				end
				
				return
			end
			
			-- 불렀을 때 액션 하기
			if not state.callAction then
				state.callAction = true
				
				-- 호출 성공한 경우
				local callSuccess = RAND(1,100) <= info.callSuccessRatio
				
				if callSuccess then
					mgr:SendEventToClient( EVENT_CALL_NPC_RESULT, info.callerOID, HorseCall_Following )				
					--PLAY_MOTION( info, mob, MOTION_ANI2 )
				else
					PLAY_MOTION( info, mob, MOTION_ANI6 )
					
					-- 끝
					NEXT_STATE( info, STATE_ATTACK1 )
				end
				
				return
			end
			
			-- 도착시 교감 모션
			if state.loveMotionTime ~= nil then
				if info.curTime >= state.loveMotionTime then
					-- 도착한 경우 : 친밀감 표현 --> 애정도에 따라 달라질 수 있다.
					
					-- 모션 없어서 잠시 빼둠
					--PLAY_MOTION( info, mob, MOTION_ANI3 )
					--__DEBUG('--> LoveMotion\n')
					
					-- normal state
					local friendlyPoint = mob:GetMountCondition(MountCondition_FriendlyPoint) * 0.1
					
					-- 친밀도가 높으면 일정 시간동안 쫓아다닌다.
					if friendlyPoint >= 60 then

						--print('['..mob:GetObjID()..'] 친밀도 = '..friendlyPoint..'\n')
					
						state.followTime = info.curTime + 3+(friendlyPoint-60)		-- 3~40초 정도 따라다닌다.
						
						mob:GazeAt(info.callerOID, GAZE_FAVOR)
						
						state.movePath = false
					else
						-- 호출 끝!
						NEXT_STATE( info, STATE_ATTACK1 )
					end
					state.loveMotionTime = nil				
				end
				return
			end
					
			-- 길찾기 정보가 없는 경우 --> 새 길찾기
			if not state.movePath then
				local player = mgr:GetPlayer(info.callerOID)
				if player ~= nil then
					
					SetHorseVelocity( mob, info.calledVelocity  )
					
					local apporachDist	= 3
					local checkCount	= CALL_CHECK_LIMIT
					
					state.findPathCount = state.findPathCount + 1
					
					-- 길찾기 이동!
					if state.findPathCount <= 5 
						and mob:MoveToPlayer(player, apporachDist, checkCount) then
						--PLAY_MOTION( info, mob, MOTION_MOVE2 )
						state.fastMove = true
					else
						state.retryToFindPath = false
					end
				end
				
				state.movePath = true
				
			-- 최근의 길찾기했던 플레이어 위치 근처까지 도달한 경우
			elseif mob:IsArrived() then
			
				if state.followTime~=nil then
					-- 이미 접근 후, 애정표현하고.. 이제 그냥 쫓아만 다니는 경우
					local player = mgr:GetPlayer(info.callerOID)
					if player ~= nil and mob:GetDist(player:GetPos()) <= info.loveMotionDist then
						-- 대기
					else
						-- 다시 길 찾기
						state.movePath = false
					end
					
					SET_DELAY(info, RAND(1,3))
				else
					-- 애정도 표현하기 위해 쫓아가는 경우
					local player = mgr:GetPlayer(info.callerOID)
					if player ~= nil and mob:GetDist(player:GetPos()) <= info.loveMotionDist then
						mob:LookAt( player:GetPos() )
						
						--PLAY_MOTION( info, mob, MOTION_TURN_L )
						state.loveMotionTime = info.curTime + 1
					
					else
						-- 멀어서 못 간 경우
						if state.retryToFindPath then
							-- continue search path
							state.movePath = false
						else				
							-- 길찾기 포기 동작
							PLAY_MOTION( info, mob, MOTION_ANI9 )
							
							-- normal state
							NEXT_STATE( info, STATE_ATTACK1 )
						end
					end
				end
			
			-- 길찾기 했던 길을 따라서 진행하는 중
			else
				local remainDist = mob:GetRemainDist()
				if remainDist < info.slowApproachDist then
					-- 가까우면 천천히 접근
					if state.fastMove then
					
						local player = mgr:GetPlayer(info.callerOID)
						if player ~= nil and mob:GetDist(player:GetPos()) <= info.calledSlowNearDist then
							SetHorseVelocity( mob, info.calledSlowNearVelocity  )
						else
							SetHorseVelocity( mob, info.calledSlowVelocity  )
						end
						state.fastMove = false
					end
				else
					-- 멀면 빠르게 접근
					if not state.fastMove then
						SetHorseVelocity( mob, info.calledVelocity  )
						state.fastMove = true
					end
				end
			end
		end,
		
		leave = function (state, mob, info)
		
			mgr:SendEventToClient( EVENT_NPC_FOLLOWING_END, mob:GetObjID(), info.callerOID )
		
			SetHorseVelocity( mob, info.defaultVelocity  )
			
			if mob:GetGazeID() ~= 0 then
				mob:GazeAt(0, GAZE_NONE)
				--__DEBUG('gaze end(call)\n')
			end
			--__DEBUG('CALL_STATE end\n')
		end,
	}
	
	SET_STATE_HANDLER( stateList[STATE_IDLE], idleState )
	SET_STATE_HANDLER( stateList[STATE_ATTACK1], playState )
	SET_STATE_HANDLER( stateList[STATE_WEAK1], g_AIStateFactory.RunawayFromPlayer(MOTION_NONE, STATE_ATTACK1) )
	SET_STATE_HANDLER( stateList[STATE_PATROL], g_AIStateFactory.SimplePatrol(STATE_IDLE) )
	SET_STATE_HANDLER( stateList[STATE_CALLED], calledState )
	SET_STATE_HANDLER( stateList[STATE_DEAD], g_AIStateFactory.LeaveRanch(RANCH_PORTAL_POS, MOTION_NONE, MOTION_ANI8) )	
	
	return stateList
end,
}


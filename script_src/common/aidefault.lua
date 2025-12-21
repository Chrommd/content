require('missiontypes')
require('aistate')

g_FunKnockbackTime = 1
g_FunKnockbackDist = 5

-- 양치기
g_SheepCoinDropCount = 0

--local STATE = GameStage.STATE
--
-- 모든 ai에 기본적으로 추가되는 handler function
--
g_AIDefaultHandler =
{
onInit = function (info, mob)
	info.hp_max = 100
	info.hp		= info.hp_max	
end,

onAttacked = function (info, mob, damage, attackerID)
	if info.hp > 0 then
		if not info.active then
			info.active = true
			info.activeTime = info.curTime
		end	
	
		info.hp = info.hp - damage
		if info.hp > info.hp_max then
			info.hp = info.hp_max 
		end
		
		if info.hp <= 0 then
			info.hp = 0
			info.activeTime = info.curTime
			NEXT_STATE( info, STATE_DEAD )		
		end
		mob:SetHP(info.hp)
		
		info.lastAttackerID = attackerID
		
		return true
	end
	
	return false
end,

onSkillAttacked = function (info, mob, skillID, skillOID, damage, attackerID)
	if info.hp > 0 then
		if not info.active then
			info.active = true
			info.activeTime = info.curTime
		end
		
		info.active = true
		info.hp = info.hp - damage
		if info.hp > info.hp_max then
			info.hp = info.hp_max 
		end
		
		if info.hp <= 0 then
			info.hp = 0
			info.activeTime = info.curTime
			NEXT_STATE( info, STATE_DEAD )		
		end
		mob:SetHPBySkill(info.hp, damage, skillOID)
		
		info.lastAttackerID = attackerID
		
		return true
	end
	
	return false
end,
}


--
-- AI sample: state or function
--
g_AISample = 
{
	patrolProcess = function (state, mob, info)
		if mob:IsNearPos( mob:GetMovePos() ) then
			local path = state.path
			local maxIndex = table.getn(path)
			
			if state.pathIndex > maxIndex then
				state.pathIndex = 1
			end
			
			local pos = path[state.pathIndex]
			
			mob:Move( pos[1], pos[2], pos[3] )
			PLAY_MOTION( info, mob, MOTION_MOVE )
			
			state.pathIndex = state.pathIndex + 1
		end
	end,	

	deadState =
	{
		enter = function (state, mob, info)
			state.alive = true
			state.show = true
			info.aiRange = 99999999
			SET_DELAY(info, 0.5)
		end,
		
		process = function (state, mob, info)
			if state.alive then
				state.alive = false
				PLAY_MOTION( info, mob, MOTION_DEAD )				
			elseif state.show then
				state.show = false
				mob:Dead()
			end
		end,
	},
	
	deadStateMotionIm =
	{
		enter = function (state, mob, info)
			PLAY_MOTION( info, mob, MOTION_DEAD )
			mob:Dead()
			info.aiRange = 99999999
		end,
		
		process = function (state, mob, info)			
		end,
	},
	
	deadStateIm =
	{
		enter = function (state, mob, info)
			mob:Dead()
			info.aiRange = 99999999
		end,
		
		process = function (state, mob, info)			
		end,
	},
}

g_AIStateFactory = 
{
	-- 근처(info.attack_dist)의 player를 찾으면 nextState로 변경한다.
	FindNearPlayer = function (enterMotion, nextState)
		local retState = 
		{
			enter = function (state, mob, info) 
				mob:Stop()
				PLAY_MOTION( info, mob, enterMotion )
			end,
			
			process = function (state, mob, info)
				
				if info.trace_id ~= nil then
					NEXT_STATE( info, nextState )
					return
				end
			
				local player = mgr:FindNearPlayer(mob)
				if player ~= nil and player:GetHP() > 0 and mob:IsNearPos(player:GetPos(), info.attack_dist) then
					info.trace_id = player:GetObjID()
					NEXT_STATE( info, nextState )
				end
			end,
		}
		return retState
	end,

	-- 근처(info.attack_dist)의 friendly NPC or player를 찾으면 nextState로 변경한다.
	FindNearNPCorPlayer = function (enterMotion, nextState)
		local retState = 
		{
			enter = function (state, mob, info) 
				mob:Stop()
				PLAY_MOTION( info, mob, enterMotion )
			end,
			
			process = function (state, mob, info)
			
				if info.trace_id ~= nil then
					NEXT_STATE( info, nextState )
					return
				end
				
				if g_Game ~= nil then
					local npc = FIND_NEAR_MOB( info, mob, g_Game.npclist )
					if npc ~= nil and npc:GetHP() > 0 and mob:IsNearPos(npc:GetPos(), info.attack_dist) then				
						info.trace_id = npc:GetObjID()
						NEXT_STATE( info, nextState )
						return
					end
				end
			
				local player = mgr:FindNearPlayer(mob)
				if player ~= nil and player:GetHP() > 0 and mob:IsNearPos(player:GetPos(), info.attack_dist) then
					info.trace_id = player:GetObjID()
					NEXT_STATE( info, nextState )
				end
			end,
		}		
		return retState
	end,
	
	SimplePatrol = function (patrolPathName, nextState)
		local retState = 
		{	
			enter = function (state, mob, info) 
				state.pathIndex = 1
			end,
			
			process = function (state, mob, info)
			
				if mob:IsArrived() then		
					if info.reset_patrol then 
						state.pathIndex = 1
						info.reset_patrol = nil
					end			
				
					local path = info.patrol_path
					if path ~= nil then
						local maxIndex = table.getn(path)
						
						-- 이동 끝이면 IDLE로
						if state.pathIndex > maxIndex then
							info.patrol_path = nil
							NEXT_STATE( info, nextState )
							OnEvent( EVENT_PATROL_END, "", info.oid )							
							return
						end
						
						-- 계속 이동하기
						local pos = path[state.pathIndex]
						if pos then
							mob:Move( pos.x, pos.y, pos.z )
							state.pathIndex = state.pathIndex + 1
						end
					end
				end
			end,
		}
		return retState
	end,

	PatrolForever = function (arriveDist)
		local retState = 
		{	
			enter = function (state, mob, info) 
				state.pathIndex = 1
			end,
			
			process = function (state, mob, info)
			
				if mob:IsArrived() or arriveDist~=nil and mob:GetRemainDist() <= arriveDist then
					
					if info.reset_patrol then 
						state.pathIndex = 1
						info.reset_patrol = nil
					end			
				
					local path = info.patrol_path
					if path ~= nil then
						local maxIndex = table.getn(path)
						
						-- 이동 끝이면 IDLE로
						if state.pathIndex > maxIndex then
							state.pathIndex = 1
						end
						
						-- 계속 이동하기
						local pos = path[state.pathIndex]
						if pos then
							mob:Move( pos.x, pos.y, pos.z, true )
							state.pathIndex = state.pathIndex + 1
						end
					end
				end
			end,
		}
		return retState
	end,
	
	FollowPlayer = function (idleState, moveState)		
	
		-- 플레이어 따라다니기
		local followState = 
		{	
			enter = function (state, mob, info) 
				state.moveTiming = info.curTime
			end,
			
			process = function (state, mob, info)
				if mob:IsArrived() then
				
					-- 이동하다가 멈춘 경우
					if state.moving then
						PLAY_MOTION( info, mob, idleState )
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
							
							pos.x = pos.x + RAND(-10,10)
							pos.z = pos.z + RAND(-10,10)
							
							-- 이동 ㄱㄱ!
							if mob:Move(pos.x, pos.y, pos.z) then
								PLAY_MOTION( info, mob, moveState  )
								state.moving = true
							end						
						end
					end
				end
			end,
		}
		return followState
	end,
	
	-- 근처 플레이어로부터 도망가기 모드
	RunawayFromPlayer = function (runawayMotion, endState)
	
		-- 도망가기 모드
		local runawayState = 
		{	
			enter = function (state, mob, info)
				if runawayMotion~=nil and runawayMotion~=MOTION_NONE then
					PLAY_MOTION( info, mob, runawayMotion )
				end
				state.runaway = true
				state.moved = false
				state.fastMove = true		
				
				local mountInfo = mob:GetMountInfo()
				if mountInfo ~= nil and mountInfo.injury ~= MountInjury_None then
					state.adjustVelocity = false	-- 말이고 부상 당했다면.. 속도 조절은 없다.
				else
					state.adjustVelocity = true
				end
				--print('-- BEGIN Runaway\n')
			end,
			
			process = function (state, mob, info)
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
						
						-- 이동 ㄱㄱ!
						if mob:Move(pos.x, pos.y, pos.z) then
							--print('Runaway OK\n')
							if state.adjustVelocity and info.avoidVelocity ~= nil then
								mob:SetVelocity( info.avoidVelocity  )
							end
							--PLAY_MOTION( info, mob, MOTION_MOVE3  )
							state.moved = true						
						else
							--print('Runaway Fail\n')
							SET_DELAY(info, 1)
						end
					end
					
				-- 도착했으면 원래대로
				elseif mob:IsArrived() then
					--PLAY_MOTION( info, mob, MOTION_IDLE )
					NEXT_STATE( info, endState )
				else
					local remainDist = mob:GetRemainDist()
					if info.slowAvoidDist~=nil and remainDist < info.slowAvoidDist then
						-- 가까우면 천천히 접근
						if state.fastMove then					
							if state.adjustVelocity and info.avoidSlowVelocity~=nil then
								mob:SetVelocity( info.avoidSlowVelocity  )
							end
							state.fastMove = false
						end
					end
				end
			end,
			
			leave = function (state, mob, info)
				if state.moved then
					if state.adjustVelocity and info.defaultVelocity~=nil then
						mob:SetVelocity( info.defaultVelocity  )
					end
				end
				--print('-- END Runaway\n')
			end,
		}
		
		return runawayState
	end,
	
	-- 방목말 입양보내기
	-- 말 삭제 : 포탈로 보내자
	-- 필요 info변수 : info.freeVelocity, info.slowFreeApproachDist, info.freeSlowVelocity
	LeaveRanch = function (portalPos, lookMotion, goodbyeMotion)
	
	    local goodbyeState = 
	    {	
		    enter = function (state, mob, info)
			    mob:LookAt( portalPos )
			    if lookMotion~=nil and lookMotion~=MOTION_NONE then
			        PLAY_MOTION( info, mob, lookMotion )
                end
			    state.fastMove = true
			    state.movePortal = false
			    state.byeMotion = false
			    state.arriveDelaying = false
		    end,
    		
		    process = function (state, mob, info)
    		
			    -- 포탈까지 길을 찾아가자
			    if not state.movePortal then
    				
				    state.movePortal = true
    				
				    local apporachDist = 0
				    local checkCount = 1000
    								
				    if mob:MovePath(portalPos.x, portalPos.y, portalPos.z, apporachDist, checkCount) then
					    -- 길찾기 성공
					    mob:SetVelocity( info.freeVelocity  )
					    return
				    else
					    -- 못찾았으면 그 자리에서 바로 제거					
				    end
			    end
    			
			    -- 포탈 도착 성공
			    if mob:IsArrived() then
    			
				    if not state.arriveDelaying then
					    state.arriveDelaying = true
					    SET_DELAY(info, 2)
					    return
				    end
    			
				    -- 안녕 모션 출력
				    if not state.byeMotion then
					    state.byeMotion = true
    					
					    local player = mgr:GetPlayer( mgr:GetOwnerOID() )
					    if player ~= nil then
						    mob:LookAt( player:GetPos() )
					    end
    					
    					if goodbyeMotion~=nil and goodbyeMotion~=MOTION_NONE then
					        PLAY_MOTION( info, mob, goodbyeMotion )
					    end
				    -- 제거
				    else	
						mgr:SendEventToClient( EVENT_SCRIPT, SC_EVENT_HORSE_LEAVE_RANCH, mob:GetObjID() )
					    mob:Dead()
				    end
			    else
				    local remainDist = mob:GetRemainDist()
				    if remainDist < info.slowFreeApproachDist and state.fastMove then
    					
					    --print('SLOW FREE VELOCITY: dist='..remainDist..'\n')
					    mob:SetVelocity( info.freeSlowVelocity  )
					    state.fastMove = false
				    end
			    end
    			
		    end,
	    }
	    
	    return goodbyeState
	end,
	
	
	-- 채팅하는 NPC
	ChattingNPC = function (defaultMotion, greetingMotion, greeingMotionDelay, chatVelocity, subProcFunc)
	
		local chatState =
		{	
			enter = function (state, mob, info) 
				if defaultMotion ~= nil then
					PLAY_MOTION( info, mob, defaultMotion )
				end
				info.chatting = false
				--info.talked = false
				state.enablePopup = true
				state.defaultLookPos = mob:GetPos() + mob:GetDir()
				--state.idleMotionTime = nil				
				info.enableGreetings = {}
			end,
			
			process = function (state, mob, info)
			
				if subProcFunc ~= nil then
					subProcFunc(state, mob, info)
				end
				
				-- 원래의 idle 모션으로 돌려준다.
				if state.idleMotionTime ~= nil and info.curTime >= state.idleMotionTime then
					PLAY_MOTION( info, mob, defaultMotion )
					state.idleMotionTime = nil
				end
				
			
				-- 모든 플레이어에 대해서 처리 : 반겨주는 모션 출력
				local playerCount = mgr:GetPlayerCount()
				local myOID = util:GetMyOID()
				for i=0,playerCount-1 do
					local player = mgr:GetPlayerByIndex(i)
					if player ~= nil then
						local playerOID = player:GetObjID()
						local dist = mob:GetDist( player:GetPos() )
						local innerChatDist	= (dist <= info.chatDist)
						local outOfChatDist	= (dist >= info.chatDist+2)
						
						if info.enableGreetings[playerOID]==nil then
							info.enableGreetings[playerOID] = true
						end
						
						if info.enableGreetings[playerOID] and innerChatDist then
							-- 반겨주는 모션 출력
							if greetingMotion ~= MOTION_NONE then
								mob:LookAt(player:GetPos())		-- 바라보자.
								PLAY_MOTION( info, mob, greetingMotion, true )
								--print('greeting\n')
								state.idleMotionTime = info.curTime + greeingMotionDelay
								info.enableGreetings[playerOID] = false
							end
						elseif outOfChatDist then
							info.enableGreetings[playerOID] = true
						end
					end
				end
			
				-- 나(!)에 대해서 처리
				local player = mgr:GetPlayer( myOID )
				if player ~= nil then
					local dist = mob:GetDist( player:GetPos() )
						
					-- 채팅창 출력
					if g_ChatEnable then
						local prevChatting	= info.chatting						
						local innerChatDist	= (dist <= info.chatDist)
						local outOfChatDist	= (dist >= info.chatDist+2)						
						
						if state.enablePopup and innerChatDist then
							if not info.chatting and player:GetVelocity()<=chatVelocity then
								if not util:IsShowChat() then
									util:StartChat(info.npcID)
									
									state.checkCloseChatTime = info.curTime + 7		-- 몇 초후에 창 닫는거 체크한다.
								end
								info.chatting = true
							end
						elseif outOfChatDist then
							if info.chatting and not util:IsInputBlock() then
								util:CloseChat()
								info.chatting = false
							end
							state.enablePopup = true
						end
						
						-- 속도가 빨라지면 닫자
						if info.chatting and util:IsShowChat() and player:GetVelocity() > chatVelocity then
							util:CloseChat()
							info.chatting = false
							state.enablePopup = false
						end
						
						-- 채팅창 시간 지나면 닫자 : 대화를 안한 상태여야 한다.
						if info.chatting and state.checkCloseChatTime~=nil and info.curTime >= state.checkCloseChatTime then
							if not util:IsOnChatting() and not util:IsInputBlock() then
								util:CloseChat()
								info.chatting = false
								state.checkCloseChatTime = nil
								state.enablePopup = false
							end
						end
						
						-- 방금 채팅창이 닫혔으면: 원래 바라보던 방향 보기
						--if greetingMotion ~= MOTION_NONE and prevChatting and info.chatting==false then
						--	mob:LookAt(state.defaultLookPos)
						--end
					end
					
					-- 보이스 출력
					--local extraDist = 2
					--if dist <= info.chatDist then
						--if not info.talked then						
							--util:PlayVoice(info.npcID)
							--info.talked = true
						--end
					--elseif dist >= info.chatDist+extraDist then
						--if info.talked then
							--info.talked = false
						--end
					--end					
				end			
			end,
		}	
		return chatState
	end,
}

-- release
function OnRelease()
end

-- process때마다 호출
function OnProcess( mob, deltaTime )

	for k,game in pairs(g_Games) do	
		if game.active then
			if game.IsEnd ~= nil and game:IsEnd() then
				mgr:EndGame(MISSIONRESULT_FAILED)
				game.active = false
			end
		end
	end
end

-- process mob
function OnProcessMob( mob, deltaTime )

	for k,game in pairs(g_Games) do
		if game.active then
			PROCESS_MOB( game, mob, deltaTime)
		end
	end
end

function OnAddMob( mob )
	-- mob이 추가됐을때
	
	CREATE_MOB_INFO( mob )
end	

function OnAddMobAfter( mob )
	-- mob이 추가됐을때	
	local info = GET_MOB_INFO(mob)
	
	if info ~= nil and info.onAddAfter ~= nil then
		info:onAddAfter(mob)
	end
end	

function OnCreateRanchHorse( oid )
	-- default : do nothing
end

function OnFreeRanchHorse( mob )
	-- default : do nothing
end

function OnAdjustDamage( mob, skillID, damage )
	-- mob이 damage만큼 공격받았을때
	local info = GET_MOB_INFO(mob)	
	
	if info ~= nil and info.onAdjustDamage ~= nil then
		return info:onAdjustDamage(mob, skillID, damage)
	end
	
	return damage
end

function OnAttacked( mob, damage, attackerID )
	-- mob이 damage만큼 공격받았을때
	local info = GET_MOB_INFO(mob)	
	
	if info ~= nil and info.onAttacked ~= nil then
		return info:onAttacked(mob, damage, attackerID)
	end
	
	return false
end

function OnSkillAttacked( mob, skillID, skillOID, damage, attackerID )
	-- mob이 damage만큼 공격받았을때
	local info = GET_MOB_INFO(mob)	
	
	if info ~= nil and info.onSkillAttacked ~= nil then
		return info:onSkillAttacked(mob, skillID, skillOID, damage, attackerID)
	end
	
	return false
end

function OnEvent( event, strValue, intValue1, intValue2 )
	--print('[OnEvent] #'..event..', "'..(strValue==nil and '' or strValue)..'", ('..(intValue1==nil and '_' or intValue1)..', '..(intValue2==nil and '_' or intValue2)..')\n')
	for k,game in pairs(g_Games) do	
		if game.curState ~= nil then
			local curState = game.state[game.curState]		
			if curState.event ~= nil then
				curState:event( game, event, strValue, intValue1, intValue2 )
			end
		end

		if game.defaultEvent ~= nil then
			game:defaultEvent( event, strValue, intValue1, intValue2 )
		end
	end
end

function OnPlayerDie(player, attackerID, attackType)
	if not player:HasStatus(PLAYERSTATUS_FAINT) then
		local faintDelaySec = 10
		player:AddStatus(PLAYERSTATUS_FAINT, faintDelaySec);
		
		for k,game in pairs(g_Games) do	
			if game.deadPlayerList ~= nil then
				table.insert(game.deadPlayerList, player:GetObjID())
			end
		end
	end
end

function OnPlayerResurrect(player)
	player:SetHPMax(-1, HP_HEAL, 500);
end

function OnSetMobInfo( mob, fieldName, value)
	local info = GET_MOB_INFO(mob)
	if info ~= nil then
		info[fieldName] = value
	end
	
	return false
end


-- 이건 클라이언트 전용
function DefaultEvent( game, event, strValue, intValue1, intValue2 )
	if event==EVENT_PLAYER_COLLISION then
		local npcOID = intValue1
		local horseOID = intValue2

		local mob = mgr:GetMob(npcOID)
		-- 이동 방향을 바꾼다. 일단 양만!
		if mob ~= nil then
			local info = GET_MOB_INFO(mob)

			if info ~= nil 
				and info.curState ~= STATE_WEAK2
				and info.enableCollisionAvoid 
				and (info.runawayDelay==nil or info.curTime >= info.runawayDelay) 
			then
				local player = mgr:GetPlayer(horseOID)
				if player~=nil then
					local dir = GetDir(player:GetPos(), mob:GetPos())
					local dist = RAND(6,12)

					info.runawayPos = GetFrontPos(mob:GetPos(), dir, dist)
					info.runawayDelay = info.curTime + 1
					RESET_DELAY(info)
					
					-- 이미 STATE_WEAK1이면 IDLE로 바꿨다가 변경시켜줘야함
					if info.curState==STATE_WEAK1 then
						SET_STATE( info, mob, STATE_IDLE )
					end

					NEXT_STATE( info, STATE_WEAK1 )
				end
			end
		end

	elseif event==EVENT_SHEEP_COIN_DROP then
		g_SheepCoinDropCount = g_SheepCoinDropCount + 1

	elseif event==EVENT_FUN_KNOCKBACK_INFO then
		-- 정보 설정
		g_FunKnockbackDist = intValue1 * 0.001
		g_FunKnockbackTime = intValue2 * 0.001
		
	elseif event==EVENT_FUN_KNOCKBACK then
		local myOID = intValue1
		local otherOID = intValue2
		
		local mob = mgr:GetMob(myOID)
		if mob ~= nil then
			local info = GET_MOB_INFO(mob)
			if info ~= nil then

				-- 동일 상태로 다시 변경하기 위해서
				if info.curState==STATE_WEAK2 then
					SET_STATE( info, mob, STATE_IDLE )
				end

				local myMat = util:GetDummyMatrix(myOID)
				local pos = myMat.pos
				local otherMat = util:GetDummyMatrix(otherOID)
				local dir = GetDir(otherMat.pos, pos)
				local colDir = otherMat.at + dir
				local knockbackDir = Normalize(colDir)
				local knockbackDist = g_FunKnockbackDist
				local time = g_FunKnockbackTime

				local kbPos = pos + knockbackDir * knockbackDist
				--kbPos = util:GetRoadPosition(pos, kbPos, 0.5, 2)

				mob:Knockback(kbPos.x, kbPos.y, kbPos.z, time, 0, KNOCKBACK_SLIDING)

				local lookDir = GetDir(otherMat.pos, kbPos)
                local lookPos = pos - lookDir * (knockbackDist + 10)
				mob:LookAt(lookPos)

				info.knockbackTime = time
				
				util:IncidentOther(SheepKnockback, myOID)

				NEXT_STATE( info, STATE_WEAK2 )		
				RESET_DELAY(info)		
			end
		end
	end
end

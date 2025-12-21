require('AIState')
require('AIHelper')
require('AIDefault')
require('MissionTypes')
require('GameHelper')

g_Game = CREATE_GAME()

MAX_CAT_COUNT = 1


HORSE_PIVOT = v3(-1.69, 0, -39.06)			-- 기본 위치

g_HorsePosName = 
{
	[MountGroupAction_Normal] = 'horse_point_00',		-- 보통 상태
	[MountGroupAction_Greedy] = 'horse_point_01',		-- 먹자
	[MountGroupAction_Busy] = 'horse_point_02',			-- 부산하다
	[MountGroupAction_Indivisual] = 'horse_point_03',	-- 개인주의
	[MountGroupAction_Excited] = 'horse_point_04',		-- 정신없는  
	[MountGroupAction_Gloomy] = 'horse_point_05',		-- 음침한
	[MountGroupAction_Pairing] = 'horse_point_06',		-- 짝꿍
	[MountGroupAction_Tired] = 'horse_point_07',		-- 나른한
	[MountGroupAction_Parade] = 'horse_point_08',		-- 퍼레이드
}

-- 집단행동별 좌표 리스트
g_HorsePosByMountGroupAction = {}

-- 개인주의/짝꿍 좌표 안 겹치게 초기좌표 설정하기 위해서
g_IndivisualHorsePosIndex = {}

g_NPCOrderMotions =
{
	[NPCORDER_PLAYDEAD] = MOTION_ATTACKED1,
	[NPCORDER_HAPPY]	= MOTION_ANI3,
	[NPCORDER_TURN]		= MOTION_ANI5,
	[NPCORDER_SIT]		= MOTION_ANI4,
}

function IsInPlayerDistance(playerOID, mob, distance)
	if distance~=nil then
		local player = mgr:GetPlayer(playerOID)
		if player~=nil and mob:GetDist(player:GetPos()) <= distance then
			return true
		end	
	end
	return false
end

function CreateGameState()
	local stateList = 
	{	
		INIT = 
		{	
			enter = function (state, game) 
				-- 고양이 한 마리
				for i=1,MAX_CAT_COUNT do
					local catPos = v3(-0.38, -0.04, -37.89)
					mgr:CreateMob( "cat", "cat", catPos, MONSTER_TYPE_FRIENDLY)					
				end
			
				mgr:CreateAllRanchHorseOnServer()
				
				NEXT_STATE( game, "PLAY" )
				state.procDelay = 0.1
			end,
		},
		
		PLAY = 
		{	
			enter = function (state, game) 			
				state.procDelay = 0.1
			end,			
			
			event = function( state, game, event, strValue, intValue1, intValue2 )
				-- NPC 호출하기
				if event==EVENT_CALL_NPC then
					local callerOID = intValue1
					local targetOID = intValue2
					
					-- 자기 목장에서만 호출 가능
					if callerOID==mgr:GetOwnerOID() then					
						local npc = mgr:GetMob(targetOID)
						if npc ~= nil then
							local info = GET_MOB_INFO(npc)
							if info ~= nil and info.curState~=STATE_DEAD then
							
								if info.curState==STATE_CALLED then
									-- 이미 호출 중인 상태 -> 성공으로 보내준다.
									mgr:SendEventToClient( EVENT_CALL_NPC_RESULT, callerOID, HorseCall_Following )
								elseif IsInPlayerDistance(callerOID, npc, info.callDistance) then	-- 호출 거리 체크
									-- 호출 시작
									if NEXT_STATE( info, STATE_CALLED ) then
										info.callerOID = callerOID
									end
								end
							end
						end
					end
				
				-- 말을 갈아탄 경우
				elseif event==EVENT_CHANGE_MOUNT then
					local ownerOID = intValue1
					local targetOID = intValue2
					
					-- 자기 목장에서만 호출 가능
					if callerOID==mgr:GetOwnerOID() then					
						local npc = mgr:GetMob(targetOID)
						if npc ~= nil then
							local info = GET_MOB_INFO(npc)
							if info ~= nil 
								and info.curState~=STATE_DEAD
								and info.curState~=STATE_IDLE then							
								
								-- IDLE상태로 바꿔줌
								NEXT_STATE( info, STATE_IDLE )
							end
						end
					end
					
				-- 다른 말이 호출이 잦아서 화난 경우
				elseif event==EVENT_SCRIPT then
					if intValue1==SS_EVENT_HORSE_ANGRY then
						local angryOID = intValue2
						
						local angryMob = mgr:GetMob(angryOID)
						
						if angryMob ~= nil then
							-- 다른 말들이 바라보게 한다.
							for oid, info in pairs(g_MobList) do
								if oid~=angryOID and info.curState==STATE_ATTACK1 then
									local mob = mgr:GetMob(oid)
									if mob~=nil and mob:GetAIName()=="ranch_horse" and mob:GetDist(angryMob:GetPos()) < 15 then
										mob:GazeAt(angryOID, GAZE_FAVOR)
										info.state[info.curState].gazeTime = info.curTime + RAND(5,8)
									end
								end
							end
						end

					-- 부산한 : 리더가 뛸때 같이 뛰도록 만든다.
					elseif intValue1==SS_EVENT_HORSE_LEADER_BUSY then
						local leaderOID = intValue2

						local leaderMob = mgr:GetMob(leaderOID)

						if leaderMob ~= nil then
							-- 다른 말들도 달리게 한다.
							for oid, info in pairs(g_MobList) do
								if oid~=leaderOID then
									local mob = mgr:GetMob(oid)
									if mob~=nil and mob:GetAIName()=="ranch_horse" and mob:GetDist(leaderMob:GetPos()) < 50 then
										info.busyMove = true
										info.busyLeaderPos = leaderMob:GetMovePos()
										SET_DELAY(info, RAND(10,30)*0.1)	-- 잠시 대기
									end
								end
							end
						end

					-- 퍼레이드 : 리더가 뛸때 같이 뛰도록 만든다.
					elseif intValue1==SS_EVENT_HORSE_LEADER_PARADE then
						local leaderOID = intValue2

						local leaderMob = mgr:GetMob(leaderOID)
						local leaderInfo = GET_MOB_INFO(leaderMob)

						if leaderMob ~= nil and leaderInfo ~= nil then
							-- 다른 말들도 달리게 한다.
							for oid, info in pairs(g_MobList) do
								if oid~=leaderOID then
									local mob = mgr:GetMob(oid)
									if mob~=nil and mob:GetAIName()=="ranch_horse" and mob:GetDist(leaderMob:GetPos()) < 50 then
										info.paradeMove = true
										info.paradeLeader = nil
										info.pivotPos = leaderInfo.pivotPos
										SET_DELAY(info, RAND(10,30)*0.1)	-- 잠시 대기

										--print('notify parade --> '..oid..'\n')
									end
								end
							end
						end

					-- 짝꿍이 움직일때 따라서 움직이도록 한다.
					elseif intValue1==SS_EVENT_HORSE_PAIR_MOVE then
						local pairOID = intValue2
						local pairMob = mgr:GetMob(pairOID)
						if pairMob ~= nil then
							
							for oid, info in pairs(g_MobList) do
								if info.groupPair==pairOID then
									local mob = mgr:GetMob(oid)
									if mob~=nil and mob:GetAIName()=="ranch_horse" and mob:GetDist(pairMob:GetPos()) < 50 then
										
										info.pairTraceMove = true
										SET_DELAY(info, RAND(10,30)*0.1)	-- 잠시 대기
										--print('SS_EVENT_HORSE_PAIR_MOVE: '..mob:GetObjID()..' --> '..pairOID..'\n')
										break
									end
								end
							end
						end
					end
					
				-- NPC에게 명령하기
				--
				--elseif event==EVENT_ORDER_NPC then
					--local targetOID = intValue1
					--local order = intValue2
					--
					--local npc = mgr:GetMob(targetOID)
					--if npc ~= nil then
						--local info = GET_MOB_INFO(npc)
						--if info ~= nil 
							--and info.state ~= nil and info.state[STATE_ATTACK1] ~= nil
							--and info.state ~= nil and info.state.motion ~= nil 
							--and info.curState~=STATE_DEAD
						--then							
							--local motion = g_NPCOrderMotions[order]
							--if motion ~= nil and info.state.motion[motion] ~= nil then
								--if not npc:IsArrived() then
									--npc:Stop()
								--end
								--
								--NEXT_STATE( info, STATE_ATTACK1 )
								--PLAY_MOTION( info, npc, motion )
							--end
						--end
					--end
				
				-- 개발용 기능
				elseif ENABLE_DEBUG then
					if event==EVENT_DEV_SET_MOUNT_CONDITION then
						local targetOID = intValue1 / 0x10000	-- 상위 16비트
						local cond		= intValue1 % 0x10000	-- 하위 16비트
						local value		= intValue2
					
						if cond >= MountCondition_Stamina and cond <= MountCondition_Boredom then
							local mob = mgr:GetMob(targetOID)
							if mob ~= nil then
								local mountInfo = mob:GetMountInfo()
								if mountInfo ~= nil then
									mountInfo:SetMountConditions(cond, value)
								end
							end
						end
					elseif event==EVENT_DEV_SET_GROUP_FORCE then
						local forceIndex = intValue1
						if forceIndex >= 1 and forceIndex < MountGroupForce_Max then

							print('[Server] SetGroupForceName = '..GroupForceName[forceIndex]..'\n')
							for oid, info in pairs(g_MobList) do
								local mob = mgr:GetMob(oid)									
								if mob~=nil and mob:GetMountInfo()~=nil  then
									SetHorseGroupForce(info, mob, forceIndex)
								end
							end
						end
					end
				end
			end
		},		
	}

	return stateList
end
		
-- 초기화
function OnInit()	
	g_Game.state = CreateGameState()
	NEXT_STATE( g_Game, "INIT" )
	
	print('--- server Intro Init OK\n')
end

-- process때마다 호출
function OnProcess( deltaTime )

	if g_Game.active then
		PROCESS_GAME( g_Game, deltaTime )
	end
end


function OnCreateRanchHorse( oid, mountState, pos )
	local horsePos = pos
	
	-- 정해진 좌표가 없다면 기본 좌표를 셋팅해준다.
	if pos.x==0 and pos.y==0 and pos.z==0 then
		local pivotPos = HORSE_PIVOT
		local checkPos = v3(pivotPos.x+RAND(-6, 6), pivotPos.y, pivotPos.z+RAND(-6, 6))
		horsePos = mgr:GetNaviCellPos(pivotPos, checkPos, 1)
	end	
	
	if mountState==MountState_Foal then
		mgr:CreateMob( "ranch_foal", "ranch_foal", horsePos, MONSTER_TYPE_FRIENDLY, oid)
	else --if mountState==MountState_Normal then
		
		local horse = mgr:CreateMob( "ranch_horse", "ranch_horse", horsePos, MONSTER_TYPE_FRIENDLY, oid)
		if horse ~= nil then
			local mountInfo = horse:GetMountInfo()
			if mountInfo ~= nil then
				local groupAction = mountInfo:GetGroupAction()

				local info = GET_MOB_INFO(horse)
				if info ~= nil then

					info.active = true

					if g_HorsePosName[groupAction] ~= nil then
						local posName = g_HorsePosName[groupAction]
						if info[posName] == nil and g_HorsePosByMountGroupAction[groupAction]==nil then						
							--print('< Set HorsePos > : '..groupAction..'\n')
							mgr:SetMobPath(horse, g_HorsePosName[groupAction], g_HorsePosName[groupAction])
							g_HorsePosByMountGroupAction[groupAction] = info[posName]
						end
					else
						alert('[Error] Not Exist HorsePosName['..groupAction..']')
					end

					local posList = g_HorsePosByMountGroupAction[groupAction]
					if posList ~= nil then
						
						local selectIndex

						if groupAction==MountGroupAction_Indivisual 
							or groupAction==MountGroupAction_Pairing then

							local posIndexes = g_IndivisualHorsePosIndex[groupAction]

							if posIndexes==nil then
								g_IndivisualHorsePosIndex[groupAction] = {}
								posIndexes = g_IndivisualHorsePosIndex[groupAction]
							end

							-- 전체 목록을 추가한다.
							if table.getn(posIndexes)==0 then
								local posCount = table.getn( posList )
								for i=1,posCount do
									table.insert(posIndexes, i)
								end
							end

							-- 개인주의에서는 초기좌표가 겹치지 않도록 한다.
							local posCount = table.getn(posIndexes)
							selectIndex = posIndexes[RAND(1, posCount)]

							-- 선택한건 빼준다.
							table.remove(posIndexes, selectIndex)
						else
							-- 일반적으로는 전체 랜덤
							local posCount = table.getn(posList)
							selectIndex = RAND(1, posCount)
						end

						local groupPos = posList[selectIndex]
						local dist = 6

						-- 짝꿍이면.. 짝을 찾자!
						if groupAction==MountGroupAction_Pairing 
							and info.groupPair~=0 
							and horse:GetObjID() > info.groupPair		-- 내 oid가 크면 내가 내 짝꿍 쪽으로 이동한다.
						then							
							local otherMob = mgr:GetMob(info.groupPair)
							if otherMob~=nil then
								-- 짝꿍 위치
								groupPos = otherMob:GetPos()
								dist = 3

								print('['..horse:GetObjID()..'] PAIR position : '..info.groupPair..'\n')
							end
						end

						if groupPos ~= nil then
							
							local pivotPos = groupPos
							local checkPos = v3(pivotPos.x+RAND(-dist, dist), pivotPos.y, pivotPos.z+RAND(-dist, dist))
							horsePos = mgr:GetNaviCellPos(pivotPos, checkPos, 1)
							horse:ResetPos(horsePos.x, horsePos.y, horsePos.z)
							local info = GET_MOB_INFO(horse)
							if info ~= nil then
								info.pivotPos = horsePos
							end

							--print('['..horse:GetMountName()..'] ('..groupPos.x..', '..groupPos.z..') -> ('..checkPos.x..', '..checkPos.z..') -> ('..horsePos.x..', '..horsePos.z..')\n')
						end
					end
				end
			end
		end
	end

end

function OnFreeRanchHorse( mob,  immediately )
	local info = GET_MOB_INFO(mob)
	
	if info~=nil
		and info.state~=nil then
		
		if immediately and info.state[STATE_DEAD_IM]~=nil then
			NEXT_STATE( info, STATE_DEAD_IM )
		elseif info.state[STATE_DEAD]~=nil then
			NEXT_STATE( info, STATE_DEAD )
		else
			alert('[Error] OnFreeRanchHorse('..mob:GetObjID()..' STATE_DEAD not exists\n')
		end
	else
		alert('[Error] OnFreeRanchHorse('..mob:GetObjID()..' info not exists\n')
	end
end

function OnResetRanchHorse( mob )
	local info = GET_MOB_INFO(mob)
	
	if info~=nil
		and info.state~=nil then
		
		if info.state[STATE_IDLE]~=nil then
			NEXT_STATE( info, STATE_IDLE )
		else
			alert('[Error] OnResetRanchHorse('..mob:GetObjID()..' STATE_IDLE not exists\n')
		end
	else
		alert('[Error] OnResetRanchHorse('..mob:GetObjID()..' info not exists\n')
	end
end

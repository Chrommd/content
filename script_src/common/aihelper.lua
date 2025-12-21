
g_AIFactory = {}
g_MobList = {}
g_skillOID = 0x8000

function NEW_SKILL_OID()
	g_skillOID = g_skillOID + 1
	if g_skillOID >= 0xFFFF then
		g_skillOID = 0x8000
	end	
	return g_skillOID
end

function SET_STATE_HANDLER( state, procState )
	state.onEnter = procState.enter
	state.onProcess = procState.process
	state.onLeave = procState.leave
end


-- SetState helper
-- lua에 정의된 STATE를 game에 정의된 RcState값으로 바꿔준다.
--function GET_STATE_BY_NAME( stateName )
	--local stateID	= g_States[stateName]	
	--return stateID
--end

--function GET_STATE( info, state )
	--local stateName = info.state[state].state
	--local stateID	= g_States[stateName]
	--
	--return stateID
--end

function SET_DELAY(info, delay)
	if info.activeTime < info.curTime + delay then
		info.activeTime = info.curTime + delay
	end
end

function ADD_DELAY(info, delay)
	info.activeTime = info.activeTime + delay
end

function RESET_DELAY(info)
	info.activeTime = info.curTime
end

function PLAY_MOTION( info, mob, motionState, forcePlay )	
	if info.state == nil then
		print('info.state is nil: '..mob:GetAIName()..', motion='..motionState..'\n')
		return
	end
	
	if info.state.motion == nil then
		print('info.state.motion is nil: '..mob:GetAIName()..', motion='..motionState..'\n')
		return
	end
	
	local motionInfo = info.state.motion[motionState]
	
	if motionInfo ~= nil then	
		local stateName = motionInfo.state
		local stateID	= motionInfo.stateID	--g_States[stateName]
		local aniDelay	= motionInfo.aniDelay		
		
		if stateID ~= nil then
			if forcePlay==nil then
				mob:SetState( stateID, false )
			else
				mob:SetState( stateID, forcePlay )
			end
		end
		
		-- state change aniDelay
		SET_DELAY( info, aniDelay )
	else
		print('motionState is nil: '..mob:GetAIName()..', motion='..motionState..'\n')
	end
end

function SET_DEFAULT_MOTION( info, mob, idleState, moveState )
	if info.state == nil then
		print('D-info.state is nil: '..mob:GetAIName()..', motion='..motionState..'\n')
		return
	end
	
	if info.state.motion == nil then
		print('D-info.state.motion is nil: '..mob:GetAIName()..', motion='..motionState..'\n')
		return
	end
	
	local idleInfo = info.state.motion[idleState]
	local moveInfo = info.state.motion[moveState]
	
	if idleInfo ~= nil and moveInfo ~= nil then	
		local idleStateID	= idleInfo.stateID
		local moveStateID	= moveInfo.stateID
		
		if idleStateID ~= nil and moveStateID ~= nil then
			mob:SetDefaultState( idleStateID, moveStateID )
		end
	else
		print('D-motionState is nil: '..mob:GetAIName()..', idle='..idleState..', move='..moveState..'\n')
	end
end

-- my객체에 lua에 정의된 STATE에 맞는 game의 RcState값을 설정한다.
function SET_STATE( info, mob, state )

	-- onLeave:	현재 상태를 종료한다
	local curState = info:GetState()
	if curState~=nil and curState.onLeave ~= nil then
		curState:onLeave( mob, info )
	end

	-- set newState
	info.curState = state
	local newState	= info:GetState()
	
	if newState~=nil then
		if newState.onEnter ~= nil then
			--if newState.name ~= nil then
			--	print('[SET_STATE] '..newState.name..'\n')
			--end
			newState:onEnter( mob, info )
		else		
			-- default enter proc?
		end
	end	
end

function NEXT_STATE( info, state )
	if info:FindState(state) ~= nil then
		info.nextState = state
		return true
	end
	return false
end

function NEXT_MOB_STATE( mobID, state )
	local mob = mgr:GetMob( mobID )
	if mob ~= nil then
		local info = GET_MOB_INFO( mob )
		if info ~= nil then
			NEXT_STATE( info, state )
		else
			--print('[Error] Mob info is NULL\n')
		end
	else
		--print('[Error] Mob is NULL\n')
	end
end		

function GET_MOB_STATE( info, state )
	if info ~= nil and info.state ~= nil then
		return info.state[state]
	end
	
	return nil
end

function MOB_INFO( oid )
	local info = {}
	info.active = false
	info.oid = oid
	info.curTime = 0
	info.activeTime = 0
	info.curState = STATE_NONE
	info.nextState = STATE_IDLE
	info.tactic = TACTIC_IDLE
	info.aiRange = 80
	info.hp = 1
	info.hp_max = 1
	info.state = {}
	info.GetState = function (info) return info.state[info.curState] end
	info.FindState = function (info, state) return info.state[state] end
	return info
end


function GET_TABLE_INDEX(table, value)
	for k,v in pairs(table) do
		if v == value then
			return k
		end
	end
	
	return 0
end

function CREATE_MOB( mobName, ainame, oid )
	--print('CREATE_MOB : '..mobName..', aiName='..ainame..', oid='..oid..'\n')

	local factory = g_AIFactory[ainame]

	-- AI factory
	if factory == nil then		
		require('ai_'..ainame)
		
		factory = g_AIFactory[ainame]
	end
	
	-- body factory
	if g_body==nil or g_body[mobName] == nil then
		require('body_'..mobName)	
	end

	if factory ~= nil then
		local info = MOB_INFO(oid)
		
		info.state = factory.createState()
		info.skillInfo = CREATE_BODY_SKILL_ID(mobName)	
		
		-- states별로 state index를 저장해둔다.
		local bodyStates = g_body[mobName].states
		local maxStateID = table.getn(bodyStates)
		for motion,info in pairs(info.state.motion) do
			local stateName = info.state
			local stateID	= GET_TABLE_INDEX(bodyStates, stateName)
			
			if stateID >= 1 and stateID<=maxStateID then			
				info.stateID = stateID
			else
				alert('[ERROR] not exist state['..stateName..']\n')
			end
		end
		
		for name, handler in pairs(factory) do
			if info[name] ~= 'createState' then
				info[name] = factory[name]
			end
		end
		return info
	else
		alert('[Error] CREATE_MOB No AIFactory: '..mobName..', aiName='..ainame..', oid='..oid..'\n')
	end
end

function GET_MOB_INFO( mob )
	local oid = mob:GetObjID()
	return  g_MobList[oid]
end

function GET_MOB_INFO_VALUE( mob, valueName )
	local info = GET_MOB_INFO(mob)
	if info ~= nil then
		return info[valueName]
	end
end

function CREATE_MOB_INFO( mob )
	-- mob이 추가됐을때
	local info = GET_MOB_INFO(mob)
	
	-- 없으면 추가한다.
	if info ~= nil then
		print('already exist mobInfo: '..info.oid..'\n')
	end
	
	-- 있어도 다시 추가해서 덮어쓰자
	local oid = mob:GetObjID()
	info = CREATE_MOB( mob:GetMobName(), mob:GetAIName(), oid)
	if info.onInit ~= nil then
		info:onInit(mob)
		-- apply config	
	end

	--APPLY_DEFAULT_HANDLER(info)
	for name, handler in pairs(g_AIDefaultHandler) do
		if info[name] == nil then
			info[name] = handler
		end
	end
	
	g_MobList[oid] = info
end	

function ATTACK(info, mob, trace_id)
	mob:Attack(trace_id)
end

function USE_SKILL(info, mob, skillname, targetObj)
	if info.skillInfo ~= nil then
		local skillInfo = info.skillInfo[skillname]
		if skillInfo ~= nil then
			local skillID = skillInfo.id
			local skillTarget = skillInfo.target
			if skillID ~= nil and skillTarget ~= nil then
				local skillOID = NEW_SKILL_OID()
				if skillTarget == SKILL_TARGET_POSITION then
					mob:UseSkillToGround(skillID, skillOID, targetObj:GetObjID(), targetObj:GetPos())
				elseif skillTarget == SKILL_TARGET_OBJECT then
					mob:UseSkillToObject(skillID, skillOID, targetObj:GetObjID())
				else
					print('Wrong skill target('..skillname..')\n')
				end
			else
				print('Wrong skill ID or target('..skillname..')\n')
			end
		else
			print('Wrong skill ID('..skillname..')\n')
		end
	end
end

function USE_SKILL_POS(info, mob, skillname, targetPos)
	if info.skillInfo ~= nil then
		local skillInfo = info.skillInfo[skillname]
		if skillInfo ~= nil then
			local skillID = skillInfo.id
			local skillTarget = skillInfo.target
			if skillID ~= nil and skillTarget ~= nil then
				local skillOID = NEW_SKILL_OID()
				if skillTarget == SKILL_TARGET_POSITION then
					mob:UseSkillToGround(skillID, skillOID, 0, targetPos)
				else
					print('Wrong skill target('..skillname..')\n')
				end
			else
				print('Wrong skill ID or target('..skillname..')\n')
			end
		else
			print('Wrong skill ID('..skillname..')\n')
		end
	end
end

function SET_DELAY_ALL_MOB( deltaTime, exceptList )
	
	for oid,info in pairs(g_MobList) do
		if exceptList==nil or exceptList[oid]==nil then
			ADD_DELAY( info, deltaTime )
			
			--local mob = mgr:GetMob(oid)
			--print('Delay('..oid..', '..mob:GetAIName()..')\n')
		end
	end
	--print('----------------------------------------\n')
end

function KILL_ALL_MONSTER(game)
	for oid,info in pairs(g_MobList) do
		if info.hp > 0 then
			local mob = mgr:GetMob(info.oid)
			if mob ~= nil then
				info:onAttacked(mob, info.hp, mob:GetObjID())
			end
		end
	end
end

-- process때마다 호출
function PROCESS_MOB( game, mob, deltaTime )

	local info = GET_MOB_INFO(mob)
	
	if info ~= nil then
	
		info.curTime = mgr:GetUpdateTime()

		if info.curTime >= info.activeTime then
			
			if info.active then			
		
				-- change state?
				if info.nextState ~= info.curState then
					SET_STATE( info, mob, info.nextState )
				end
				
				if info.curTime >= info.activeTime then
					local curState = info:GetState()
					if curState ~= nil then
						local onProcess = curState.onProcess
						
						if onProcess ~= nil then
							curState:onProcess( mob, info )
							SET_DELAY( info, curState.procDelay )
						end
					end
				end
			else
			
				-- active 안됐으면 aiRange 체크!
				local player = mgr:FindNearPlayer(mob)
				if player ~= nil and player:GetHP() > 0 then
					if mob:IsNearPos( player:GetPos(), info.aiRange ) then
						info.active = true
					else
						SET_DELAY( info, 1 )
					end
				end
				
				if not info.active then
					local npc = FIND_NEAR_MOB( info, mob, game.npclist )
					if npc ~= nil and npc:GetHP() > 0 then
						info.active = true
					else
						SET_DELAY( info, 1 )
					end
				end
			end					
		end
	end
end

function test()
	local mob = {
		GetObjID = function (self) return 10 end,
		GetAIName = function (self) return "dragon" end,
		IsNearPos = function (self, pos) return 1 end,
		GetMovePos = function (self) return {0,0,0} end,
		SetState = function (self, state) end,
		Move = function (self, x,y,z) end,
	}
	
	mgr = {
		GetUpdateTime = function (self) return 1 end,		
	}
	
	local info = GET_MOB_INFO(mob)
	
	OnProcess( mob, 5 )
	OnProcess( mob, 10 )
	OnProcess( mob, 15 )
	OnProcess( mob, 20 )
end


function FIND_NEAR_MOB( info, mob, moblist )
	if moblist ~= nil then
		for i,oid in pairs(moblist) do
			local checkmob = mgr:GetMob(oid)
			if checkmob ~= nil and checkmob:GetHP() > 0 then
				if mob:IsNearPos( checkmob:GetPos(), info.aiRange ) then
					return checkmob
				end
			end
		end
	end
	
	return nil
end

function SET_MOB_PATH(mob, luaPathName, pathList)

	local info = GET_MOB_INFO(mob)
	if info ~= nil then
		print('SET_MOB_PATH('..luaPathName..', #'..table.getn(pathList)..')\n')		
		info[luaPathName] = pathList
	end	
end

function FORCE_ACTIVE_MOB(mob)
	local info = GET_MOB_INFO(mob)
	if info ~= nil then
		info.active = true
	end
end

function IS_ALL_DEAD( moblist )
	for i,oid in pairs(moblist) do
		
		local npc = mgr:GetMob(oid)
		if npc ~= nil then
		
			local info = GET_MOB_INFO(npc)	
			if info ~= nil then
				if info.hp > 0 then
					return false
				end
			end
		end
	end
	
	return true
end

function ARRANGE_ALL_MOB(mgr, arrangeList)
	for i,info in pairs(arrangeList) do
		local bodyName	= info[1]
		local aiName	= info[2]
		local pos		= info[3]
		local lookPos	= info[4]
		local aiRange	= info[5]
		local aiConfig	= info[6]
		
		print('create mob['..bodyName..']')
		local mob = mgr:CreateMob( bodyName, aiName, pos )

		local info = GET_MOB_INFO( mob )
		
		if info ~= nil then
			info.aiRange = aiRange

			-- 그 외 config 설정			
			if aiConfig ~= nil then
				for k,v in pairs(aiConfig) do
					info[k] = v
					
					if k=="hp_max" then
						mob:SetHPMax(v)
						
					elseif k=="hp" then
						mob:SetHP(v)

					elseif k=="scale" then
						if table.getn(v) == 3 then
							mob:Scale( v[1], v[2], v[3] )
						end
					end
				end
			end
		else
			print('NOT EXIST info!')
		end		
		
		print(' - OK\n')
		mob:LookAt(lookPos)
	end
end

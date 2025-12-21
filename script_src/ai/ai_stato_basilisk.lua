-- module setup
require('aihelper')
require('missiontypes')

-- 보스 타는 스타토
g_AIFactory['stato_basilisk'] = 
{

onInit = function (info, mob)
	info.hp_max = 100000
	info.hp		= info.hp_max	
end,

onAddAfter = function (info, mob)
	mob:Scale( 5, 5, 5 )
end,

--onSkillAttacked = function (info, mob, skillID, skillOID, damage, attackerID)
	--if g_AIDefaultHandler.onSkillAttacked ~= nil then
		--ret = g_AIDefaultHandler.onSkillAttacked(info, mob, skillID, skillOID, damage, attackerID)
	--end	
	--
	--local player = mgr:GetPlayer(attackerID)
	--if player ~= nil then	
		--local pos = player:GetPos()
		--local mobPos = mob:GetPos()
		--local kbPos = v3( (mobPos.x-pos.x)*3, (mobPos.y-pos.y)*3, (mobPos.z-pos.z)*3 )
		--mob:Knockback( kbPos.x, kbPos.y, kbPos.z, 0.5 )
		--PLAY_MOTION(info, mob, MOTION_ATTACK)
	--end	
--end,

createState = function ()
	local stateList = {}
	stateList.motion = {}
	local motion = stateList.motion
	
	--                        { Name,			StateName,			aniDelay }
	motion[MOTION_IDLE]	= { name='Idle',	state='G_IDLE',	aniDelay=1 }
	motion[MOTION_MOVE]	= { name='Idle',	state='MOVE_1ST',	aniDelay=0.1 }
	motion[MOTION_ATTACK]	= { name='Idle',	state='ATTACK',	aniDelay=1 }
	
	stateList[STATE_IDLE]	= { name='Idle',	procDelay=0.2 }
	stateList[STATE_PATROL]	= { name='Patrol',	procDelay=0.2 }
	stateList[STATE_ATTACK]	= { name='Attack',	procDelay=0.2 }

	
	-- 초기화 부분. local procState = { enter, process, leave }
	local idleState = 
	{	
		enter = function (state, mob, info) 
			mob:Stop()
			mob:SetMoveType( MOVE_TYPE_FLYING )
			PLAY_MOTION( info, mob, MOTION_IDLE )				
		end,
		
		process = function (state, mob, info)						
		end,
	}		
	
	local patrolState = 
	{	
		enter = function (state, mob, info) 
			mob:SetMoveType( MOVE_TYPE_GROUND )
			PLAY_MOTION( info, mob, MOTION_MOVE )	
			
			local count = table.getn(g_Game.sealingIDs)
			if count > 0 then
				mob:Move(basilStartPos.x, basilStartPos.y, basilStartPos.z+10)
			else
				mob:Move(basilJumpPos.x, basilJumpPos.y, basilJumpPos.z+10)
			end
		end,
		
		process = function (state, mob, info)
			if state.linkTime ~= nil then
				if info.curTime >= state.linkTime then
					NEXT_STATE( info, STATE_IDLE )
					mob:LinkTo( g_Game.bossID, "sit" )					
				end			
			elseif state.rideTime ~= nil then
				if state.playIdle then
					mob:Stop()					
					PLAY_MOTION( info, mob, MOTION_IDLE )					
					state.playIdle = nil
				end
				
				if info.curTime >= state.rideTime then
					local pos = mob:GetPos()
					PLAY_MOTION( info, mob, MOTION_ATTACK )
					mob:Knockback(pos.x, pos.y+15, pos.z-10, 1, 0, KNOCKBACK_JUMP)
					state.linkTime = info.curTime + 1
				end				
			elseif mob:IsNearPos(basilStartPos, 15) then				
				OnEvent( EVENT_SCRIPT, "server", SS_EVENT_ARRIVED, mob:GetObjID() )				
				PLAY_MOTION( info, mob, MOTION_ATTACK )
				state.rideTime = info.curTime + 10
				state.playIdle = true
			end
		end,
	}		
	
	local attackState = 
	{
		enter = function (state, mob, info) 
			mob:Unlink()
			
			local count = table.getn(g_Game.sealingIDs)
			if count > 0 then
				local index = RAND(1,count)
				local sealingID = g_Game.sealingIDs[index]
				table.remove( g_Game.sealingIDs, index )
			
				state.selectSealingID = sealingID
				print('select Sealing ='..state.selectSealingID..'\n')
				
				local sealing = mgr:GetMob(state.selectSealingID)
				if sealing ~= nil then
					print('sealing OK\n')
					local pos = sealing:GetPos()
					mob:LookAt(pos)
					PLAY_MOTION( info, mob, MOTION_ATTACK )
					mob:Knockback(pos.x+1.5, pos.y+6, pos.z+1.5, 2, 0, KNOCKBACK_JUMP)
					
					SET_DELAY( info, 3 )
				end
			end			
		end,
		
		process = function (state, mob, info)
		
			if state.selectSealingID ~= nil then
				local sealing = mgr:GetMob(state.selectSealingID)
			
				if sealing ~= nil and sealing:GetHP()>0 then
					
					local boss = mgr:GetMob(g_Game.bossID)
					if boss ~= nil then
						mob:LookAt(boss:GetPos())
					end
					
					PLAY_MOTION( info, mob, MOTION_ATTACK )	
				
					NEXT_MOB_STATE( state.selectSealingID, STATE_ATTACK )					
					
					SET_DELAY( info, 5 )
				else		
					mob:SetMoveType( MOVE_TYPE_GROUND )
					PLAY_MOTION( info, mob, MOTION_ATTACK )
					local pos = mob:GetPos()
					mob:Knockback(pos.x+1, pos.y-6, pos.z+1, 1, 0, KNOCKBACK_JUMP)
					NEXT_STATE( info, STATE_IDLE )
				end
			end
		end, 
	}

	SET_STATE_HANDLER( stateList[STATE_IDLE], idleState )
	SET_STATE_HANDLER( stateList[STATE_PATROL], patrolState )
	SET_STATE_HANDLER( stateList[STATE_ATTACK], attackState )
	
	return stateList
end,
}

-- module setup
require('aihelper')

				
g_AIFactory["dragon_patrol"] = 
{ 

onInit = function (info, mob)
	info.hp_max = 2000
	info.hp		= info.hp_max	
	print('OnInit-')
end,

onAddAfter = function (info, mob)
	mob:SetMoveType( MOVE_TYPE_FLYING )
	print('OnInitAfter-')
end,

createState = function ()
	local stateList = {}
	stateList.motion = {}
	local motion = stateList.motion
	
	--                        { Name,			StateName,		aniDelay }
	motion[MOTION_IDLE]		= { name="Idle",	state="G_IDLE",	aniDelay=1 }
	motion[MOTION_FIRE]		= { name="Fire",	state="D_FIRE",	aniDelay=6 }
	motion[MOTION_MOVE]		= { name="Move",	state="D_FLY",	aniDelay=0.1 }
	
	
	stateList[STATE_IDLE]	= { name="Idle",	procDelay=0.2 }
	stateList[STATE_PATROL]	= { name="Patrol",	procDelay=0.1 }
	stateList[STATE_ATTACK]	= { name="Attack",	procDelay=4 }

	
	-- 초기화 부분. local procState = { enter, process, leave }
	local idleState = 
	{	
		enter = function (state, mob, info) 
			PLAY_MOTION( info, mob, MOTION_IDLE )
		end,
		
		process = function (state, mob, info)
			NEXT_STATE( info, STATE_PATROL )
		end,
	}
	
	local patrolState = 
	{
		enter = function (state, mob, info)
			if state.path == nil then
							
				if false then
					--require('resetpos_ri_land01')
					require('resetpos_test_mon01')
					--print('#resetpos = '..table.getn(g_ResetPos)..'\n')
					state.path = {}
					for i,pos in pairs(g_ResetPos) do
						table.insert( state.path, {pos[1], pos[2]+10, pos[3]} )
					end
				else
					state.path =
					{
						{ -564, 51, 66 }, 
						{ -544, 52, 94 },
						{ -488, 45, 71 },
						{ -482, 45, 0 },
					}
				end
				state.pathIndex = 1
			end
		end,

		process = function (state, mob, info)
			if mob:IsNearPos( mob:GetMovePos() )  then
			
				local path = state.path
				local maxIndex = table.getn(path)
				
				if state.pathIndex > maxIndex then
					state.pathIndex = 1					
				end
				
				local pos = path[state.pathIndex]				
				
				-- MOVE					
				mob:Move( pos[1], pos[2], pos[3] )
				PLAY_MOTION( info, mob, MOTION_MOVE )
				
				state.pathIndex = state.pathIndex + 1
			end
		end,
	}	
		
	local attackState = 
	{
		enter = function (state, mob, info)
			mob:Stop()
			
			if info.trace_id ~= nil then
				--print('trace_id = '..info.trace_id..'\n')
				local player = mgr:GetPlayer(info.trace_id)
				if player ~= nil then
					mob:LookAt(player:GetPos())
					PLAY_MOTION( info, mob, MOTION_FIRE )
					USE_SKILL(info, mob, "FIREBALL", player)
				end
			end
		end,
		
		process = function (state, mob, info)
			info.trace_id = nil
			NEXT_STATE( info, STATE_PATROL )
		end,
	}		
	
	SET_STATE_HANDLER( stateList[STATE_IDLE], idleState )
	SET_STATE_HANDLER( stateList[STATE_PATROL], patrolState )
	SET_STATE_HANDLER( stateList[STATE_ATTACK], attackState )
	
	return stateList
end,

}
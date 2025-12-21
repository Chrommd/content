-- module setup
require('aihelper')

				
g_AIFactory["wagon"] = 
{ 

onInit = function (info, mob)
	info.hp_max = 1000
	info.hp		= info.hp_max	
end,

onAddAfter = function (info, mob)
end,

createState = function ()
	local stateList = {}
	stateList.motion = {}
	local motion = stateList.motion
	
	--                        { Name,			StateName,		aniDelay }
	motion[MOTION_IDLE]		= { name="Idle",	state="G_IDLE",		aniDelay=1 }
	motion[MOTION_MOVE]		= { name="Move",	state="G_IDLE",		aniDelay=0.5 }
	motion[MOTION_DEAD]		= { name="Dead",	state="G_IDLE",		aniDelay=3 }
	
	stateList[STATE_IDLE]	= { name="Idle",	procDelay=0.2 }
	stateList[STATE_PATROL]	= { name="Patrol",	procDelay=0.1 }
	stateList[STATE_DEAD]	= { name='Dead',	procDelay=0.2 }

	
	-- 초기화 부분. local procState = { enter, process, leave }
	local idleState = 
	{	
		enter = function (state, mob, info) 
			PLAY_MOTION( info, mob, MOTION_IDLE )
		end,
		
		process = function (state, mob, info)
			if mob:IsNearPos( mob:GetMovePos() ) then
				NEXT_STATE( info, STATE_PATROL )
			end
		end,
	}
	
	local patrolState = 
	{
		enter = function (state, mob, info)
			if state.path == nil then
							
				--require('resetpos_ri_land01')
				require('resetpos_test_mon01')
				--print('#resetpos = '..table.getn(g_ResetPos)..'\n')
				state.path = {}
				for i,pos in pairs(g_ResetPos) do
					table.insert( state.path, {pos[1], pos[2]+10, pos[3]} )
				end
				
				state.pathIndex = 1
				state.lastRest = false
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
				
				if false then --state.pathIndex % 10 == 0 then
					-- FIRE
					local player = mgr:FindNearPlayer(mob)
					if player ~= nil then
						--mob:LookAt( player:GetPos() )
						--PLAY_MOTION( info, mob, MOTION_FIRE )
						--USE_SKILL(info, mob, "BREATH", player)						
						state.lastRest = true
						SET_DELAY( info, 1 )
					end
					
				else
					-- MOVE					
					mob:Move( pos[1], pos[2], pos[3] )
					if state.lastRest then
						PLAY_MOTION( info, mob, MOTION_MOVE )
					end
					state.lastRest = false
				end

				state.pathIndex = state.pathIndex + 1
			end
		end,
	}
	
	deadState =
	{
		enter = function (state, mob, info)
			state.alive = true
			PLAY_MOTION( info, mob, MOTION_DEAD )
			mob:SetMoveType( MOVE_TYPE_GROUND )
		end,
		
		process = function (state, mob, info)
			if state.alive then
				state.alive = false				
				mob:Dead()				
			end
		end,
	}
		
	
	SET_STATE_HANDLER( stateList[STATE_IDLE], idleState )
	SET_STATE_HANDLER( stateList[STATE_PATROL], patrolState )
	SET_STATE_HANDLER( stateList[STATE_DEAD], deadState )
	
	return stateList
end,

}
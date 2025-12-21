-- module setup
require('aihelper')

				
g_AIFactory["dragon"] = 
{ 

onInit = function (info, mob)
	info.hp_max = 200
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
	motion[MOTION_DEAD]		= { name="Dead",	state="D_ROARING",	aniDelay=5 }
	
	
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
							
				if true then
					if g_ResetPos == nil then
						--require('resetpos_ri_land01')
						require('resetpos_test_mon01')
					end
					--print('#resetpos = '..table.getn(g_ResetPos)..'\n')
					state.path = {}
					for i,pos in pairs(g_ResetPos) do
						table.insert( state.path, {pos[1], pos[2]+10, pos[3]} )
					end
				else
					state.path =
					{
						{ 0,10,100 },
						{ 100,10,0 },
						{ 0,10,-100 },
						{ -100,10,0 },
					}
				end
				state.pathIndex = 1
				state.lastFire = false
				state.loopCount = 0
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
				
				if maxIndex < 10 or state.pathIndex % 30 == 0 or state.loopCount>=6 then 
					-- FIRE					
					local player = mgr:FindNearPlayer(mob)
					if player ~= nil then
						mob:LookAt( player:GetPos() )
						PLAY_MOTION( info, mob, MOTION_FIRE )
						--USE_SKILL(info, mob, "BLACK", player)
						USE_SKILL(info, mob, "FIREBALL", player)
						--USE_SKILL(info, mob, "BREATH", player)						
						state.lastFire = true						
					end
					if state.loopCount == 0 then 
						state.pathIndex = state.pathIndex + 1
					end
					state.loopCount = 0
				else
				
					-- player가 멀다면?
					local player = mgr:FindNearPlayer(mob)
					if player ~= nil and not mob:IsNearPos(player:GetPos(), 80) then
						mob:LookAt(player:GetPos())
						SET_DELAY( info, 1 )
						state.loopCount = state.loopCount + 1
					else					
						-- MOVE					
						mob:Move( pos[1], pos[2], pos[3] )
						if state.lastFire then
							PLAY_MOTION( info, mob, MOTION_MOVE )
						end						
						
						state.loopCount = 0
						state.pathIndex = state.pathIndex + 1
					end
					
					state.lastFire = false
					
				end				
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
-- module setup
require('aihelper')



g_AIFactory['common'] = 
{

onInit = function (info, mob)
	info.hp_max = 10
	info.hp		= info.hp_max	
end,

createState = function ()
	local stateList = {}
	stateList.motion = {}
	local motion = stateList.motion
	
	--                        { Name,			StateName,			aniDelay }
	motion[MOTION_IDLE]	= { name='Idle',	state='G_IDLE',	aniDelay=1 }
	motion[MOTION_MOVE]	= { name='Move',	state='G_IDLE',	aniDelay=0.1 }
	
	stateList[STATE_IDLE]	= { name='Idle',	procDelay=0.2 }
	stateList[STATE_PATROL]	= { name='Patrol',	procDelay=0.2 }

	
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
				
				state.path = 
				{
					{ 0,0,15 },
					{ 15,0,0 },
					{ 0,0,-15 },
					{ -15,0,0 },					
				}
				state.pathIndex = 1
			end			
		end,

		process = g_AISample.patrolProcess
	}
	
	SET_STATE_HANDLER( stateList[STATE_IDLE], idleState )
	SET_STATE_HANDLER( stateList[STATE_PATROL], patrolState )
	
	return stateList
end,
}

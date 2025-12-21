-- module setup
require('aihelper')



g_AIFactory['horse'] = 
{

onInit = function (info, mob)
	info.hp_max = 100
	info.hp		= info.hp_max	
end,

onAddAfter = function (info, mob)
	mob:Scale( 1.5, 1.5, 1.5 )
end,

createState = function ()
	local stateList = {}
	stateList.motion = {}
	local motion = stateList.motion
	
	--                        { Name,			StateName,			aniDelay,		procDelay }
	motion[MOTION_IDLE]	= { name='Idle',	state='G_IDLE',		aniDelay=1 }
	motion[MOTION_MOVE]	= { name='Move',	state='MOVE_1ST',	aniDelay=0.1 }
	
	stateList[STATE_IDLE]	= { name='Idle',	procDelay=0.2 }
	
	-- 초기화 부분. local procState = { enter, process, leave }
	local idleState = 
	{	
		enter = function (state, mob, info)
			PLAY_MOTION( info, mob, MOTION_IDLE )
			mob:LookAt( v3(30, 0, 10) )
			mob:Move( 30, 0, 10 )
			mob:SetKey("THROTTLE", IT_PRESS)			
		end,
		
		process = function (state, mob, info)
			if mob:IsNearPos( mob:GetMovePos() ) then				
				--NEXT_STATE( info, STATE_PATROL )
				mob:ClearKey("THROTTLE")
			end
		end,
	}
	
	SET_STATE_HANDLER( stateList[STATE_IDLE], idleState )
	
	return stateList
end,
}

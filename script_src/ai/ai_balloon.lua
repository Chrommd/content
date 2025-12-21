-- module setup
require('aihelper')


g_AIFactory['balloon'] = 
{

onInit = function (info, mob)
	info.hp_max = 100000
	info.hp		= info.hp_max	
	
	info.hitDist	= 3	
end,

onAddAfter = function (info, mob)
	--mob:Scale( 2, 2, 2 )
end,

createState = function ()
	local stateList = {}
	stateList.motion = {}
	local motion = stateList.motion
	
	--                        { Name,			StateName,			aniDelay }
	motion[MOTION_IDLE]		= { name='Idle',	state='G_IDLE',		aniDelay=1 }
	motion[MOTION_DEAD]		= { name='Dead',	state='BROKEN',		aniDelay=1 }
	
	stateList[STATE_IDLE]	= { name='Idle',	procDelay=0.2 }
	stateList[STATE_DEAD]	= { name='Dead',	procDelay=0.2}
	
	-- 최초 정지 상태
	local idleState = 
	{	
		enter = function (state, mob, info) 
			PLAY_MOTION( info, mob, MOTION_IDLE )
		end,
		
		process = function (state, mob, info)			
		end,
	}	

	SET_STATE_HANDLER( stateList[STATE_IDLE], idleState )
	SET_STATE_HANDLER( stateList[STATE_DEAD], g_AISample.deadStateMotionIm )
	
	return stateList
end,
}

-- module setup
require('aihelper')



g_AIFactory['stato'] = 
{

onInit = function (info, mob)
	info.hp_max = 100
	info.hp		= info.hp_max	
end,

onAddAfter = function (info, mob)
	mob:SetMoveType( MOVE_TYPE_FLYING )
	mob:Scale( 2, 2, 2 )
end,

createState = function ()
	local stateList = {}
	stateList.motion = {}
	local motion = stateList.motion
	
	--                        { Name,			StateName,			aniDelay }
	motion[MOTION_IDLE]	= { name='Idle',	state='G_IDLE',	aniDelay=1 }
	
	stateList[STATE_IDLE]	= { name='Idle',	procDelay=0.2 }

	
	-- 초기화 부분. local procState = { enter, process, leave }
	local idleState = 
	{	
		enter = function (state, mob, info) 
			PLAY_MOTION( info, mob, MOTION_IDLE )
		end,
		
		process = function (state, mob, info)			
		end,
	}

	SET_STATE_HANDLER( stateList[STATE_IDLE], idleState )
	
	return stateList
end,
}

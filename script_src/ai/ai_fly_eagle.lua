-- module setup
require('aihelper')


g_AIFactory['fly_eagle'] = 
{ 

onInit = function (info, mob)		
	info.runawayDistance = 20
	info.pivotPos = mob:GetPos()

end,

onAddAfter = function (info, mob)
	mob:SetMoveType( MOVE_TYPE_FLYING )
	--mob:Scale( 5,5,5 )
end,

createState = function ()
	local stateList = {}
	stateList.motion = {}
	local motion = stateList.motion

	
	--                        { Name,			StateName,			aniDelay }
	motion[MOTION_IDLE]		= { name='Idle',	state='IDLE',		aniDelay=1 }
	motion[MOTION_MOVE]		= { name='Move',	state='MOVE_1ST',	aniDelay=0.5 }
	motion[MOTION_ATTACK]	= { name='FlyStop',	state='FLY',		aniDelay=2 }

	stateList[STATE_IDLE]		= { name='Idle',	procDelay=0.2}
	stateList[STATE_WEAK1]	= { name='RunAway',	procDelay=0.2}
	
	local idleState =
	{
		enter = function (state, mob, info) 
		end,
		
		process = function (state, mob, info)
			NEXT_STATE( info, STATE_WEAK1 )
		end,
	}
		
	local arriveDist = 4

	SET_STATE_HANDLER( stateList[STATE_IDLE], idleState )
	SET_STATE_HANDLER( stateList[STATE_WEAK1], g_AIStateFactory.PatrolForever(arriveDist) )
	
	return stateList
end,
}

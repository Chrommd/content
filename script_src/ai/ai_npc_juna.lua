-- module setup
require('aihelper')


g_AIFactory['npc_juna'] = 
{

onInit = function (info, mob)
	info.hp_max = 100000
	info.hp		= info.hp_max	
	
	info.chatDist	= 10
	info.npcID		= 4
end,

onAddAfter = function (info, mob)
	mob:Scale( 1, 1, 1 )
end,

createState = function ()
	local stateList = {}
	stateList.motion = {}
	local motion = stateList.motion
	
	--                        { Name,			StateName,			aniDelay }
	motion[MOTION_IDLE]		= { name='Idle',	state='G_IDLE',		aniDelay=1 }
	motion[MOTION_GREETING]	= { name='Greeting',state='GREETING',	aniDelay=0.1 }
	
	stateList[STATE_IDLE]	= { name='Idle',	procDelay=0.2 }
		

	SET_STATE_HANDLER( stateList[STATE_IDLE], g_AIStateFactory.ChattingNPC(MOTION_IDLE, MOTION_GREETING, 3, 50) )
	
	return stateList
end,
}

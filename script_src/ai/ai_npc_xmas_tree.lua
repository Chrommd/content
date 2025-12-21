-- module setup
require('aihelper')


g_AIFactory['npc_xmas_tree'] = 
{

onInit = function (info, mob)
	info.hp_max = 100000
	info.hp		= info.hp_max	
	
	info.chatDist	= 5
	info.npcID		= 5
end,

onAddAfter = function (info, mob)
	mob:Scale( 1.0, 1.0, 1.0 )
end,

createState = function ()
	local stateList = {}
	stateList.motion = {}
	local motion = stateList.motion
	
	--                        { Name,			StateName,			aniDelay }
	motion[MOTION_IDLE]		= { name='Idle',	state='IDLE',		aniDelay=1 }
	
	stateList[STATE_IDLE]	= { name='Idle',	procDelay=0.2 }
		

	SET_STATE_HANDLER( stateList[STATE_IDLE], g_AIStateFactory.ChattingNPC(MOTION_IDLE, MOTION_NONE, 0, 50) )
	
	return stateList
end,
}

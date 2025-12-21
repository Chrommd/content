-- module setup
require('aihelper')


g_AIFactory['oldman'] = 
{

onInit = function (info, mob)
	info.hp_max = 100000
	info.hp		= info.hp_max	
	
	info.chatDist	= 8
	info.npcID		= 1
end,

onAddAfter = function (info, mob)
	mob:Scale( 1.3, 1.3, 1.3 )
end,

createState = function ()
	local stateList = {}
	stateList.motion = {}
	local motion = stateList.motion
	
	--                        { Name,			StateName,			aniDelay }
	motion[MOTION_IDLE]		= { name='Idle',	state='G_IDLE',		aniDelay=0.1 }
	motion[MOTION_ANI1]		= { name='Dance',	state='MONANI_01',	aniDelay=0.1 }
	motion[MOTION_GREETING]	= { name='Greeting',state='GREETING',		aniDelay=0.1 }
	
	stateList[STATE_IDLE]	= { name='Idle',	procDelay=0.2 }
		
		
	local minDanceDelay = 5*60
	local maxDanceDelay = 10*60
	
	local motionChangeProc = function (state, mob, info)
		
		-- 최초 셋팅
		if state.curMotion==nil then
			state.curMotion = MOTION_IDLE
			state.nextMotionTime = info.curTime + RAND(minDanceDelay, maxDanceDelay)
		end
		
		-- 특정 시간마다 한번씩 dance출력
		if info.curTime >= state.nextMotionTime then
			
			PLAY_MOTION( info, mob, MOTION_ANI1 )
			state.nextMotionTime = info.curTime + RAND(minDanceDelay, maxDanceDelay)
		end
		
	end

	SET_STATE_HANDLER( stateList[STATE_IDLE], g_AIStateFactory.ChattingNPC(MOTION_IDLE, MOTION_GREETING, 5.4, 50, motionChangeProc) )
	
	return stateList
end,
}

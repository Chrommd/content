-- module setup
require('aihelper')

local BALLOON_TIMER_Y = 40

function GET_TIMER_STRING(elapsedTime)
	local min = math.floor(elapsedTime / 60)
	local sec = math.floor(elapsedTime - min*60)
	local msec = math.floor( (elapsedTime - math.floor(elapsedTime)) * 100 )
	
	local timerText = (min<10 and "0" or "")..min..":"..(sec<10 and "0" or "")..sec.."."..(msec<10 and "0" or "")..msec
	
	return timerText
end

g_AIFactory['stato_ranch'] = 
{

onInit = function (info, mob)
	info.hp_max = 100000
	info.hp		= info.hp_max	
	
	info.chatDist	= 10
	info.npcID		= 2
	
	info.eventActivated = false
end,

onAddAfter = function (info, mob)
	mob:Scale( 2, 2, 2 )
end,

createState = function ()
	local stateList = {}
	stateList.motion = {}
	local motion = stateList.motion
	
	--                        { Name,			StateName,			aniDelay }
	motion[MOTION_IDLE]		= { name='Idle',	state='G_IDLE',		aniDelay=1 }
	motion[MOTION_GREETING]	= { name='Greeting',state='GREETING',		aniDelay=0.1 }
	
	stateList[STATE_IDLE]	= { name='Idle',			procDelay=0.2 }
	stateList[STATE_EVENT]	= { name='BalloonInit',		procDelay=0.2 }
	stateList[STATE_EVENT1]	= { name='BalloonStart',	procDelay=0.01 }		
	stateList[STATE_EVENT2]	= { name='BalloonSuccess',	procDelay=0.2 }		
	stateList[STATE_EVENT3]	= { name='BalloonGiveUp',	procDelay=0.2 }			
			
	-- wait for all Balloon hit
	local eventState = 
	{	
		enter = function (state, mob, info) 			
			if not info.eventActivated then
				
				info.eventActivated = true
				mgr:SendEventToClient(EVENT_ACTIVE_CONTENT, CONTENT_EXERCISE, 1)
				
				--mgr:CreateAllPreloadedMob()
				CreateBalloons()
				
				-- my pos
				--local pos = v3(86.33, 0.54, -8.08)
				--local dir = v3(68.53, -0.62, 19.68) - pos				
			end
		end,
		
		process = function (state, mob, info)		
		end,
	}	
	
	-- start
	local event1State = 
	{	
		enter = function (state, mob, info)
			RFSetLabel("BalloonStatus", "txt_targetscore", tostring(MAX_BALLOON))
			
			util:ShowCommonTimer("00:00.00", -1, BALLOON_TIMER_Y)
			info.balloonStartTime = info.curTime
			state.balloonCount = MAX_BALLOON-g_BalloonCount
			state.updateBalloonCountTime = nil
		end,
		
		process = function (state, mob, info)	
			local elapsedTime = info.curTime - info.balloonStartTime
			
			if elapsedTime > BALLOON_LIMIT_TIME then
				elapsedTime = BALLOON_LIMIT_TIME
			end
			
			g_BalloonTime = elapsedTime
			local timerText = GET_TIMER_STRING(elapsedTime)
			
			-- 풍선 터지는 타이밍 때문에 슬슬 업데이트 해주기 위해서
			if state.updateBalloonCountTime ~= nil and info.curTime >= state.updateBalloonCountTime then
				state.balloonCount = MAX_BALLOON-g_BalloonCount 
				state.updateBalloonCountTime = nil				
			end			
			
			-- 실제 카운트 올라갈때까지 딜레이 설정
			if state.updateBalloonCountTime==nil and MAX_BALLOON-g_BalloonCount ~= state.balloonCount then
				state.updateBalloonCountTime = info.curTime + 0.4				
			end
		
			RFSetLabel("BalloonStatus", "txt_myscore", tostring(state.balloonCount))
						
			util:ShowCommonTimer(timerText, -1, BALLOON_TIMER_Y)
		end,	
		
		leave = function (state, mob, info)
			RFClose("BalloonStatus")	
			util:CloseCommonTimer()
		end,
	}	
	
	-- complete
	local event2State = 
	{	
		enter = function (state, mob, info) 			
			print('[Stato] Complete!!!\n')
			
			g_BalloonTime = info.curTime - info.balloonStartTime
			
			mgr:SendEventToClient( EVENT_PLAYER_ACTION, PLAYER_ACTION_HIT_BALLOON_COMPLETE )
		end,
		
		process = function (state, mob, info)
		end,
	}	
	
	-- give up
	local event3State = 
	{	
		enter = function (state, mob, info) 			
			print('[Stato] GiveUp!!!\n')
		end,
		
		process = function (state, mob, info)
		end,
	}	


	SET_STATE_HANDLER( stateList[STATE_IDLE], g_AIStateFactory.ChattingNPC(MOTION_IDLE, MOTION_GREETING, 4, 50) )
	SET_STATE_HANDLER( stateList[STATE_EVENT], eventState )
	SET_STATE_HANDLER( stateList[STATE_EVENT1], event1State )
	SET_STATE_HANDLER( stateList[STATE_EVENT2], event2State )
	SET_STATE_HANDLER( stateList[STATE_EVENT3], event3State )
	
	return stateList
end,
}

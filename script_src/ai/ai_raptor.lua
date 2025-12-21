-- module setup
require('aihelper')


g_AIFactory['raptor'] = 
{ 

onInit = function (info, mob)	
	info.hp_max = 60	
	info.hp		= info.hp_max
	
	info.attack_dist = 80
	--info.aiRange = 80
	
	info.attackReady = false
	info.attackTime = info.curTime
end,

onAddAfter = function (info, mob)
	mob:Scale( 1,1,1 )
end,

createState = function ()
	local stateList = {}
	stateList.motion = {}
	local motion = stateList.motion

	
	--                        { Name,			StateName,			aniDelay }
	motion[MOTION_IDLE]		= { name='Idle',	state='IDLE',		aniDelay=1 }
	motion[MOTION_ATTACK]	= { name='Attack',	state='ATTACK',		aniDelay=2 }
	motion[MOTION_MOVE]		= { name='Move',	state='MOVE_1ST',	aniDelay=0.5 }
	motion[MOTION_ATTACKED]	= { name='Attacked',state='DAMAGE',		aniDelay=1 }
	motion[MOTION_DEAD]		= { name='Dead',	state='DEAD',		aniDelay=5 }

	stateList[STATE_IDLE]	= { name='Idle',	procDelay=0.2}
	stateList[STATE_FOLLOW]	= { name='Follow',	procDelay=0.2}
	stateList[STATE_DEAD]	= { name='Dead',	procDelay=0.2}
	
	-- 초기화 부분. local procState = { enter, process, leave }	
	local followState =
	{
		enter = function (state, mob, info) 
			-- do nothing
			PLAY_MOTION( info, mob, MOTION_MOVE  )
			state.attacked = false			
		end,
		
		process = function (state, mob, info)
			if info.trace_id == nil then
				NEXT_STATE( info, STATE_IDLE )
			end
			
			local player = mgr:GetPlayer(info.trace_id)
			if player ~= nil and player:GetHP() > 0 and not player:HasStatus(PLAYERSTATUS_PETRIFY) then
				if info.ignore_dist or mob:IsNearPos(player:GetPos(), info.attack_dist) then
					if mob:IsNearPos( player:GetPos(), 5 ) then
					
						if info.attackReady and info.curTime >= info.attackTime then
							PLAY_MOTION( info, mob, MOTION_ATTACK )
							ATTACK(info, mob, info.trace_id)
							state.attacked = true
							info.attackReady = false
							
						elseif not info.attackReady then
							info.attackReady = true
							info.attackTime = info.curTime + 1							
						end
					else
						if state.attacked then
							PLAY_MOTION( info, mob, MOTION_MOVE  )
							state.attacked = false
						end
						mob:Trace(info.trace_id)
					end
				else
					info.trace_id = nil
				end
			else
				info.trace_id = nil
			end
		end,
	}		
		
	SET_STATE_HANDLER( stateList[STATE_IDLE], g_AIStateFactory.FindNearPlayer(MOTION_IDLE, STATE_FOLLOW) )
	SET_STATE_HANDLER( stateList[STATE_FOLLOW], followState )
	SET_STATE_HANDLER( stateList[STATE_DEAD], g_AISample.deadStateMotionIm )
	
	return stateList
end,
}

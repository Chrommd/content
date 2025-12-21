-- module setup
require('aihelper')


g_AIFactory['hyena2'] = 
{ 

onInit = function (info, mob)	
	info.hp_max = 60
	info.hp		= info.hp_max
end,

onAddAfter = function (info, mob)
	mob:Scale( 3,3,3 )
end,


onAttacked = function (info, mob, damage, attackerID)
	local hp_prev = info.hp
	local defaultHandler = g_AIDefaultHandler.onAttacked
	if defaultHandler ~= nil then
		defaultHandler(info, mob, damage)
	end
	local hp_cur = info.hp
	
	if hp_prev > 50 and hp_cur <= 50 then
		mob:DetachPart(5)
	elseif hp_prev > 40 and hp_cur <= 40 then
		mob:DetachPart(4)
	elseif hp_prev > 30 and hp_cur <= 30 then
		mob:DetachPart(3)
	elseif hp_prev > 20 and hp_cur <= 20 then
		mob:DetachPart(2)
	elseif hp_prev > 10 and hp_cur <= 10 then
		mob:DetachPart(1)
	end
end,


createState = function ()
	local stateList = {}
	stateList.motion = {}
	local motion = stateList.motion

	
	--                        { Name,			StateName,			aniDelay }
	motion[MOTION_IDLE]		= { name='Idle',	state='IDLE',		aniDelay=1 }
	motion[MOTION_ATTACK]	= { name='Attack',	state='ATTACK',		aniDelay=2 }
	motion[MOTION_MOVE]		= { name='Move',	state='MOVE_1ST',	aniDelay=0.5 }
	motion[MOTION_ATTACKED]	= { name='Attacked',state='ATTACK',		aniDelay=0.2 }
	motion[MOTION_DEAD]		= { name='Dead',	state='DEAD',		aniDelay=5 }

	stateList[STATE_IDLE]	= { name='Idle',	procDelay=0.2}
	stateList[STATE_FOLLOW]	= { name='Follow',	procDelay=0.2}
	stateList[STATE_DEAD]	= { name='Dead',	procDelay=0.2}
	
	-- 초기화 부분. local procState = { enter, process, leave }
	local idleState = 
	{	
		enter = function (state, mob, info) 
			PLAY_MOTION( info, mob, MOTION_IDLE )
		end,
		
		process = function (state, mob, info)
			local player = mgr:FindNearPlayer(mob)
			if player ~= nil then
				info.trace_id = player:GetObjID()
				NEXT_STATE( info, STATE_FOLLOW )
			end
		end,
	}

	local followState =
	{
		enter = function (state, mob, info) 
			-- do nothing
		end,
		
		process = function (state, mob, info)
			if info.trace_id == nil then
				NEXT_STATE( info, STATE_IDLE )
			end
			
			local player = mgr:GetPlayer(info.trace_id)
			if player ~= nil then
				if mob:IsNearPos( player:GetPos(), 5 ) then
					PLAY_MOTION( info, mob, MOTION_ATTACK )
					ATTACK(info, mob, info.trace_id)
				else
					--PLAY_MOTION( info, mob, MOTION_MOVE  )
					mob:Trace(info.trace_id)
				end
			end
		end,
	}		
		
	SET_STATE_HANDLER( stateList[STATE_IDLE], idleState )
	SET_STATE_HANDLER( stateList[STATE_FOLLOW], followState )
	SET_STATE_HANDLER( stateList[STATE_DEAD], g_AISample.deadState )
	
	return stateList
end,
}

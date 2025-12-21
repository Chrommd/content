-- module setup
require('aihelper')


g_AIFactory['tower'] = 
{ 

onInit = function (info, mob)	
	info.hp_max = 30
	info.hp		= info.hp_max
	
	info.attack_dist = 30
end,

onAddAfter = function (info, mob)
	mob:Scale( 3,3,3 )
end,

createState = function ()
	local stateList = {}
	stateList.motion = {}
	local motion = stateList.motion

	
	--                        { Name,			StateName,			aniDelay }
	motion[MOTION_IDLE]		= { name='Idle',	state='G_IDLE',		aniDelay=1 }
	motion[MOTION_ATTACK]	= { name='Attack',	state='ATTACK',		aniDelay=3 }
	motion[MOTION_DEAD]		= { name='Dead',	state='ATTACK',		aniDelay=1 }

	stateList[STATE_IDLE]	= { name='Idle',	procDelay=0.3}
	stateList[STATE_DEAD]	= { name='Dead',	procDelay=0.2}
	
	-- 초기화 부분. local procState = { enter, process, leave }
	local idleState = 
	{	
		enter = function (state, mob, info) 
			PLAY_MOTION( info, mob, MOTION_IDLE )
			state.attacked = false
		end,
		
		process = function (state, mob, info)
		
			if state.attacked then
				PLAY_MOTION( info, mob, MOTION_IDLE )
				state.attacked = false
			end
			
			local npc = FIND_NEAR_MOB( info, mob, g_Game.npclist )
			if npc ~= nil and npc:GetHP() > 0 and mob:IsNearPos(npc:GetPos(), info.attack_dist) then
				mob:LookAt(npc:GetPos())
				USE_SKILL_POS(info, mob, "ARROW", npc:GetPos())
				PLAY_MOTION( info, mob, MOTION_ATTACK )
				SET_DELAY(info, RAND(10,12))
				state.attacked = true
				return
			end
		
			local player = mgr:FindNearPlayer(mob)
			if player ~= nil and player:GetHP() > 0 and mob:IsNearPos(player:GetPos(), info.attack_dist) then
				mob:LookAt(player:GetPos())
				USE_SKILL_POS(info, mob, "ARROW", player:GetPos())
				PLAY_MOTION( info, mob, MOTION_ATTACK )
				SET_DELAY(info, RAND(10,12))
				state.attacked = true
			end
		end,
	}
	
	SET_STATE_HANDLER( stateList[STATE_IDLE], idleState )
	SET_STATE_HANDLER( stateList[STATE_DEAD], g_AISample.deadState )
	
	return stateList
end,
}

-- module setup
require('aihelper')
				
g_AIFactory["dragon_intro"] = 
{ 

onInit = function (info, mob)

	info.hp_max = 100000
	info.hp		= info.hp_max	
	
	print('OnInit-')
end,

onAddAfter = function (info, mob)
	mob:SetMoveType( MOVE_TYPE_FLYING )
	
	local scale = 1
	mob:Scale( scale, scale, scale )
	
	if dragonVelocity ~= nil then
		mob:SetVelocity(dragonVelocity)
	end
	
	print('OnInitAfter-')
end,

createState = function ()
	local stateList = {}
	stateList.motion = {}
	local motion = stateList.motion
	
	--                        { Name,			StateName,		aniDelay }
	motion[MOTION_IDLE]		= { name="Idle",	state="G_IDLE",	aniDelay=1 }
	motion[MOTION_ATTACK1]	= { name="Attack1",	state="MONANI_ATTACK_01",	aniDelay=0 }
	motion[MOTION_ATTACK2]	= { name="Attack2",	state="MONANI_ATTACK_02",	aniDelay=0 }
	motion[MOTION_ATTACK3]	= { name="Attack3",	state="MONANI_ATTACK_03",	aniDelay=0 }
	motion[MOTION_ATTACK4]	= { name="Attack4",	state="MONANI_ATTACK_04",	aniDelay=0 }
	motion[MOTION_MOVE]		= { name="Move",	state="MOVE_1ST",	aniDelay=0.1 }
	motion[MOTION_GLIDE]	= { name="Glide",	state="GLIDE",		aniDelay=1.3+2.6 }
	motion[MOTION_DASH]		= { name="Dash",	state="MONANI_01",	aniDelay=2.6 }	
	motion[MOTION_DEAD_START]= { name="DeadStart",	state="MONANI_DEAD_START", aniDelay=1.3+2.6 }
	motion[MOTION_ANI1]		= { name="BreathStart",	state="MONANI_02",		aniDelay=3.96 }
	motion[MOTION_ANI2]		= { name="BreathLoop",	state="MONANI_03",		aniDelay=2.63 }
	motion[MOTION_ANI3]		= { name="BreathEnd",	state="MONANI_04",		aniDelay=2.66 }
	motion[MOTION_ANI4]		= { name="Appear",	state="MONANI_05",		aniDelay=6.66 }
	
	
	stateList[STATE_IDLE]	= { name="Idle",	procDelay=0.2 }
	stateList[STATE_PATROL]	= { name="Patrol",	procDelay=0.1 }

	
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
	SET_STATE_HANDLER( stateList[STATE_PATROL], g_AIStateFactory.SimplePatrol(STATE_IDLE) )
	
	return stateList
end,

}
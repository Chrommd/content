require('SceneHelper')
require('SceneDefault')

g_Opening			= CREATE_GAME()
g_ValueEvaluator	= CreateValueEvaluator(g_Opening)

g_ChatEnable		= false

g_BalloonCount		= 0
g_BalloonMoney		= 0
g_BalloonList       = {}
g_BalloonTime		= 0
g_BalloonResultTime = -1	

ENABLE_RANCH_ANIMAL = false

sheepCount			= 8
impalaCount			= 3
eagleCount			= 1
obstacleCount		= 0
bisonCount			= 0
enableFlyEagle		= true

g_AnimalInitPos = v3(0,0,0)
g_AnimalOID		= animalOID

-- RcMissionScriptUtil::UpdateAnimal()에서 호출
function UPDATE_ANIMAL(bodyName, aiName, ranchScale, avoidVelocity, count)

	if not ENABLE_RANCH_ANIMAL then
		return
	end

	-- bodyName, aiName이 몇마리 있는지 일단 확인
	local curCount = 0
	local i = 0
	local oidList = {}
	for oid, info in pairs(g_MobList) do
		local mob = mgr:GetMob(oid)
		if mob ~= nil then
			if mob:GetAIName()==aiName and mob:GetMobName()==bodyName then
				curCount = curCount + 1
				table.insert(oidList, oid)
				--print('same!\n')
			end

			i = i + 1
			--print('['..i..'] AIName='..mob:GetAIName()..', BodyName='..mob:GetMobName()..'\n')
		end
	end

	if curCount > count then
		-- 몇 마리 제거
		for i=1, curCount-count do
			local removeOID = oidList[i]
			mgr:RemoveMob(removeOID)
			g_MobList[removeOID] = nil
		end
	elseif curCount < count then
		-- 몇 마리 추가
		for i=1, count-curCount do
			g_AnimalOID = g_AnimalOID + 1
			CreateAnimal(g_AnimalOID, bodyName, aiName, ranchScale, avoidVelocity, MONSTER_TYPE_FRIENDLY)
		end
	end
end

function CreateAnimal(oid, bodyName, aiName, scale, avoidVelocity, monsterType)
	local pos = v3(g_AnimalInitPos.x + RAND(-10,10), g_AnimalInitPos.y, g_AnimalInitPos.z + RAND(-10,10))
	local adjustPos = util:GetGroundPos(pos)
	local animal = mgr:CreateMob( bodyName, aiName, adjustPos, monsterType, oid )
		
	local info = GET_MOB_INFO(animal)
	if info then		
		if scale ~= 1 then
			animal:Scale( scale, scale, scale )
		end
			
		if avoidVelocity ~= 0 then
			info.avoidVelocity   = avoidVelocity
		end

		--info.defaultVelocity = 1
		--info.avoidDistance	= 20				
	end
end

function CreateAnimals()
	-- client only mob
	local mat = util:GetRanchNodePos('sheep_regen_point')
	g_AnimalInitPos = mat.pos
	
	if util:IsEnablePet() then
		--ENABLE_RANCH_ANIMAL = true
		--sheepCount			= 0
	end

	--initPos = GetFrontPos(initPos, player:GetDir(), 10)
	if ENABLE_RANCH_ANIMAL then
		print('=====--- Ranch Animals ---=====')
		local animalInfo = util:GetRanchAnimalInfo()
		if animalInfo ~= nil then
			for k,v in pairs(animalInfo) do			
				print('Body='..v.BodyName..', AI='..v.AIName..', Num='..v.Number..', Scale='..math.floor(v.Scale)..', Avoid='..math.floor(v.AvoidVelocity)..'\n')

				for i=1,v.Number do
					g_AnimalOID = g_AnimalOID + 1
					CreateAnimal(g_AnimalOID, v.BodyName, v.AIName, v.Scale, v.AvoidVelocity, MONSTER_TYPE_FRIENDLY)
				end
			end
		end
	end

	for i=1,sheepCount do

		g_AnimalOID = g_AnimalOID + 1
		local bodyName = 'sheep'
		local aiName = 'sheep'
		local scale = 2
		local avoidVelocity = 6

		CreateAnimal(g_AnimalOID, bodyName, aiName, scale, avoidVelocity, MONSTER_TYPE_FRIENDLY)
	end
	
	for i=1,impalaCount do
		g_AnimalOID = g_AnimalOID + 1
		CreateAnimal(g_AnimalOID, 'impala', 'impala', 1, 0, MONSTER_TYPE_FRIENDLY)	
	end
	
	for i=1,eagleCount do
		g_AnimalOID = g_AnimalOID + 1
		CreateAnimal(g_AnimalOID, 'eagle', 'eagle', 1, 0, MONSTER_TYPE_FRIENDLY)				
	end

	for i=1,obstacleCount do
		g_AnimalOID = g_AnimalOID + 1
		CreateAnimal(g_AnimalOID, 'obstacle', 'obstacle', 1, 0, MONSTER_TYPE_FRIENDLY)
	end
	
	for i=1,bisonCount do
		g_AnimalOID = g_AnimalOID + 1
		CreateAnimal(g_AnimalOID, 'bison', 'bison', 1, 0, MONSTER_TYPE_HOSTILE)
	end	

	if enableFlyEagle then
		local eaglePos = util:GetNodeList("eagle_path")

		if eaglePos~=nil and eaglePos[1]~=nil then
			local pos = eaglePos[1]
			print('eaglePos = ('..pos.x..', '..pos.y..', '..pos.z..')\n')

			local adjustPos = util:GetGroundPos(pos)
			local bodyName = 'eagle'
			g_AnimalOID = g_AnimalOID + 1
			local animal = mgr:CreateMob( bodyName, "fly_eagle", adjustPos, MONSTER_TYPE_FRIENDLY, g_AnimalOID )
		
			local info = GET_MOB_INFO(animal)
			if info then		
				info.patrol_path = eaglePos

				animal:Scale( 2, 2, 2 )
			
				--info.avoidVelocity   = 6
				--info.defaultVelocity = 1
				--info.avoidDistance	= 20				
			end					
		else
			print('eagle pos nil\n')
		end
	end

	-- 고양이 한 마리 --> 서버에서 생성하는 걸로 변경됨
	local catPos = v3(-0.38, -0.04, -37.89)
	local pos = v3(catPos.x + RAND(-5,5), catPos.y, catPos.z + RAND(-5,5))
	local adjustPos = util:GetGroundPos(pos)
	local cat = mgr:CreateMob( "cat", "cat", adjustPos, MONSTER_TYPE_FRIENDLY, animalOID+sheepCount+impalaCount+eagleCount+1 )
	--
	local info = GET_MOB_INFO(cat)
	if info then		
		cat:Scale( 0.5, 0.5, 0.5 )
		--
		info.avoidVelocity		= 15
		info.defaultVelocity	= 0.7
		info.avoidDistance		= 20
		info.approachDistance	= 40
		----info.runawayType	 = RUNAWAY_RANDOM
	end					
end

-- 초기화s
function OnInit()
	
	g_Opening.state = CREATE_EVENT_SCENARIO( OPENING )
	g_Opening.defaultEvent = DefaultEvent
	NEXT_STATE( g_Opening, startScene )
	
	CreateAnimals()
	print('--- create preloaded\n')

	mgr:CreateAllPreloadedMob()
	util:CreateAllRanchHorse()
	
	print('--- client Init OK\n')
end

function OnRelease()
	print('--- client Release\n')
	RFClose("ExerciseForm")
	RFClose("BalloonStatus")	
	ShowManual(false)
	InputBlock(false)
	
	local info = GetMobInfo("stato")
	if info ~= nil and info.eventActivated then			
		info.eventActivated = false
		ShowNavigationBar(true)
	end
	
end

-- process때마다 호출
function OnProcess( deltaTime )

	if g_Opening.active then
		PROCESS_GAME( g_Opening, deltaTime )		
	end
end

function OnAddMob( mob )
	-- mob이 추가됐을때
	
	CREATE_MOB_INFO( mob )
	
	if mob:GetAIName()=="balloon" then
		g_BalloonCount = g_BalloonCount + 1
		table.insert(g_BalloonList, mob:GetObjID())
		print('Balloon Added: total='..g_BalloonCount..'\n')
	end	
end	
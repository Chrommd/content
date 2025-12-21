require('GameHelper')
require('TutorialHelper')

START_DELAY_TIME		= 3			-- 시작 직전 딜레이(초)
USING_TIMER				= false		-- 시간 제한을 두는가?
MISSION_TRY_TIME		= 60		-- 초
MAX_SPUR_COUNT			= 1			-- 박차 사용 회수

if IS_SERVER then
	-- 서버는 필요없다.
else

riderStartPosName	= 'start_point2'
aiStartPosName      = 'start_point3_ai'
GOALIN_GATE			= 2
MAGIC_ITEM			= 2 --MagicSlot_Fireball



function AttackMagicMission()

	local m = SubMission( {AttackMagicItemEventCheck(), GoalInEventChecker()} )

	m.OnInit = function (self, game)
		local startMat = mgr:GetNodePos(riderStartPosName)
		local aiMat = mgr:GetNodePos(aiStartPosName)
		util:SetMyPos( startMat.pos, startMat.at )
        util:SetAssetPos(800, aiMat)
		util:SetForcedMagicItem( MAGIC_ITEM )
	end

	m.OnRelease = function (self, game)
		CloseGameTipWindow()
		--util:DeleteAIPlayer(800)
		util:SetVarValue("var_gaugeSpeed","1")
	end

	m.OnReady = function (self, game)
		print('On Ready ---- \n')
		local startMat = mgr:GetNodePos(aiStartPosName)
		util:SetAssetPos(800, startMat)
	end

    m.OnStart = function(self, game)
        PrepareGameTipWindow()
		util:SetVarValue("var_gaugeSpeed","10") 
    end

    m.OnRetry = function(self, game)
        CloseGameTipWindow()
	end

    m.OnCheckSuccess = function(self)
		
    end

	return m
end

g_subMission = AttackMagicMission()

end	-- NOT IS_SERVER
require('GameHelper')
require('TutorialHelper')

START_DELAY_TIME		= 3			-- 시작 직전 딜레이(초)
USING_TIMER				= false		-- 시간 제한을 두는가?
MISSION_TRY_TIME		= 60		-- 초
MAX_SPUR_COUNT			= 1			-- 박차 사용 회수
MAGIC_ITEM			= 16 --MagicSlot_Booster
AI_UID              = 800

if IS_SERVER then
	-- 서버는 필요없다.
else

riderStartPosName	= 'start_point2'
aiStartPosName = 'start_point2_ai'
GOALIN_GATE			= 2

function JumpMission()

	local m = SubMission( {RelayMagicItemEventCheck(), GoalInEventChecker()} )

	m.OnInit = function (self, game)
		local startMat = mgr:GetNodePos(riderStartPosName)
		util:SetMyPos( startMat.pos, startMat.at )
		local startAiMat = mgr:GetNodePos(aiStartPosName)	
		util:SetAssetPos(AI_UID, startAiMat)			
	end

	m.OnRelease = function (self, game)
		CloseGameTipWindow()
        util:SetVarFloat("const_stat_minVelocity", "5")
		--util:SetVarValue("var_gaugeSpeed","1")
	end

	m.OnReady = function (self, game)
		print('On Ready ---- \n')
        --local startMat = mgr:GetNodePos('start_ai_relay')
		local startAiMat = mgr:GetNodePos(aiStartPosName)
		util:SetAssetPos(AI_UID, startAiMat)		
	end

    m.OnStart = function(self, game)
        PrepareGameTipWindow()
		--util:SetVarValue("var_gaugeSpeed","0.1")
		util:UseAttackItem(util:GetMyOID(), MAGIC_ITEM)
    end

    m.OnEvent = function(self, game, strValue, intValue1, intValue2)
        if strValue == "ATTACK_MAGIC" and intValue1 == MAGIC_ITEM and intValue2 ~= AI_UID then
            NEXT_STATE( game, "FAIL_RETRY" )
        end
--        if strValue == "RELAY_MAGICITEM" and intValue1 == 1 then
--            util:SetVarFloat("const_stat_minVelocity", "80")
--        end
    end

    m.OnRetry = function(self, game)
        CloseGameTipWindow()
	end

    m.OnCheckSuccess = function(self)
    end

	return m
end

g_subMission = JumpMission()

end	-- NOT IS_SERVER
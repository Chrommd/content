require('GameHelper')
require('TutorialHelper')

START_DELAY_TIME		= 3			-- 시작 직전 딜레이(초)
USING_TIMER				= false		-- 시간 제한을 두는가?
MISSION_TRY_TIME		= 270		-- 초
MAX_CHASING_COUNT       = 3

if IS_SERVER then
	-- 서버는 필요없다.
else

USE_MAP_START_POS	= true
riderStartPosName	= 'start_point'
GOALIN_GATE			= 1

if ghostTickAdjusted==nil then
	ghostTickAdjusted = false
end

function OverallMission()
	local m = SubMission( { ChasingSuccessEventCheck(MAX_CHASING_COUNT),GoalInEventChecker() } )

	m.OnInit = function (self, game)
		local startMat = util:GetMyStartPosition()
		util:SetMyPos( startMat.pos, startMat.at )
		util:SetVarFloat("var_ss_beginProgressRatio", "-1")
		util:SetVarFloat("var_ss_remainTime", "2")
	end

	m.Ready = function (self, game)
		if not ghostTickAdjusted then
			util:StartGhost(-60)
			ghostTickAdjusted = true
		end
	end

	m.OnRelease = function (self, game)
        CloseGameTipWindow()
		util:SetVarValue("var_ss_beginProgressRatio", "0.4")
	end

    m.OnStart = function(self, game)
        PrepareGameTipWindow()
        util:SetVarFloat("var_ss_beginProgressRatio", "-1")
        util:SetVarFloat("var_ss_remainTime", "2")
    end

    m.OnRetry = function(self, game)
        CloseGameTipWindow()
	end

    m.OnCheckSuccess = function(self)
	end

	return m
end

g_subMission = OverallMission()

end -- NOT IS_SERVER

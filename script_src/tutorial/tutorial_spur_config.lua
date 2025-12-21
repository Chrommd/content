require('GameHelper')
require('TutorialHelper')

START_DELAY_TIME		= 3			-- 시작 직전 딜레이(초)
MISSION_TRY_TIME		= 65		-- 초
MAX_SPUR_COUNT			= 1			-- 최대 점프 횟수

if IS_SERVER then
	-- 서버는 필요없다.
else

riderStartPosName	= 'start_point3'
GOALIN_GATE			= 3


function SpurMission()
	local m = SubMission( {GetSpurEventChecker("Tutorial_GainSpur"), GoalInEventChecker()} )

	m.OnInit = function (self, game)
		local startMat = mgr:GetNodePos(riderStartPosName)
		util:SetMyPos( startMat.pos, startMat.at )
	end

	m.OnRelease = function (self, game)
		CloseGameTipWindow()
	end

    m.OnStart = function(self, game)
        PrepareGameTipWindow()
    end

    m.OnRetry = function(self, game)
        CloseGameTipWindow()
	end

    m.OnCheckSuccess = function(self)
    end

	return m
end

g_subMission = SpurMission()

end -- NOT IS_SERVER

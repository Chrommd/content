require('GameHelper')
require('TutorialHelper')

START_DELAY_TIME		= 3			-- 시작 직전 딜레이(초)
USING_TIMER				= false		-- 시간 제한을 두는가?
MISSION_TRY_TIME		= 60		-- 초
MAX_SPUR_COUNT			= 1			-- 박차 사용 회수

if IS_SERVER then
	-- 서버는 필요없다.
else

riderStartPosName	= 'start_point'
GOALIN_GATE			= 1

function JumpMission()

	local m = SubMission( {GetSpurEventChecker("Tutorial_JumpHurdle"), SpurEventChecker(MAX_SPUR_COUNT), GoalInEventChecker()} )

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

g_subMission = JumpMission()

end	-- NOT IS_SERVER
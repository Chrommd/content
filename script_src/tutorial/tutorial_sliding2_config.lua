require('GameHelper')
require('TutorialHelper')

START_DELAY_TIME		= 3			-- 시작 직전 딜레이(초)
USING_TIMER				= false		-- 시간 제한을 두는가?
MISSION_TRY_TIME		= 30		-- 초
MAX_SLIDING2_COUNT			= 3			-- 대쉬 사용 횟수

if IS_SERVER then
	-- 서버는 필요없다.
else

riderStartPosName	= 'start_point5'
GOALIN_GATE			= 5

function DashMission()

	local m = SubMission( {Sliding2SuccessEventCheck(MAX_SLIDING2_COUNT), GoalInEventChecker()} )

	m.OnInit = function (self, game)
		local startMat = mgr:GetNodePos(riderStartPosName)
		util:SetMyPos( startMat.pos, startMat.at )		
	end

	m.OnRelease = function(self)
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

g_subMission = DashMission()

end	-- NOT IS_SERVER
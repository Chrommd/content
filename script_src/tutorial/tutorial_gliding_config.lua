require('GameHelper')
require('TutorialHelper')

START_DELAY_TIME		= 3			-- 시작 직전 딜레이(초)
USING_TIMER				= false		-- 시간 제한을 두는가?
MISSION_TRY_TIME		= 75		-- 초
MAX_GLIDING_TIME		= 1			-- 초

if IS_SERVER then
	-- 서버는 필요없다.
else

riderStartPosName	= 'start_point4'
GOALIN_GATE			= 4

function GlidingMission()

	local m = SubMission( {GlidingEventChecker(MAX_GLIDING_TIME), GoalInEventChecker() } )

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

g_subMission = GlidingMission()

end

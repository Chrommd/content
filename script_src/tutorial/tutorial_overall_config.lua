require('GameHelper')
require('TutorialHelper')

START_DELAY_TIME		= 3			-- 시작 직전 딜레이(초)
USING_TIMER				= false		-- 시간 제한을 두는가?
MISSION_TRY_TIME		= 270		-- 초

if IS_SERVER then
	-- 서버는 필요없다.
else

USE_MAP_START_POS	= true
riderStartPosName	= 'start_point'
GOALIN_GATE			= 5

if ghostTickAdjusted==nil then
	ghostTickAdjusted = false
end

function OverallMission()
	local m = SubMission( { GoalInBeforeGhostEventChecker() } )

	m.OnInit = function (self, game)
		local startMat = util:GetMyStartPosition()
		util:SetMyPos( startMat.pos, startMat.at )
	end

	m.Ready = function (self, game)
		if not ghostTickAdjusted then
			--print('ghost adjust!\n')
			util:StartGhost(-60)
			ghostTickAdjusted = true
		end
	end

	m.CheckSuccess = function (self, game)
		return true
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

g_subMission = OverallMission()

end -- NOT IS_SERVER

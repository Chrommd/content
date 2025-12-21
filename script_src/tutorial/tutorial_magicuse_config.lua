require('GameHelper')
require('TutorialHelper')

START_DELAY_TIME		= 3			-- 시작 직전 딜레이(초)
USING_TIMER				= false		-- 시간 제한을 두는가?
MISSION_TRY_TIME		= 60		-- 초
MAX_SPUR_COUNT			= 1			-- 박차 사용 회수

if IS_SERVER then
	-- 서버는 필요없다.
else

riderStartPosName	= 'start_point3'
GOALIN_GATE			= 3
MAGIC_ITEM			= 10 --MagicSlot_IceWall

function UseMagicItemMission()

	local m = SubMission( {UseMagicItemEventCheck(), GoalInEventChecker()} )

	m.OnInit = function (self, game)
		local startMat = mgr:GetNodePos(riderStartPosName)
		util:SetMyPos( startMat.pos, startMat.at )
		util:SetForcedMagicItem( MAGIC_ITEM )
	end

	m.OnRelease = function (self, game)
		CloseGameTipWindow()
	end

    m.OnStart = function(self, game)
        PrepareGameTipWindow()
        util:CreateClientItem(402)
    end

    m.OnRetry = function(self, game)
        CloseGameTipWindow()
        util:RemoveAllClientItem()
	end

    m.OnCheckSuccess = function(self)
    end

	return m
end

g_subMission = UseMagicItemMission()

end	-- NOT IS_SERVER
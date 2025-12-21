require('GameHelper')
require('TutorialHelper')

START_DELAY_TIME		= 3			-- 시작 직전 딜레이(초)
USING_TIMER				= true		-- 시간 제한을 두는가?
MISSION_TRY_TIME		= 3		-- 초
MAX_COURBETTE_COUNT			= 1			-- 꾸르베트 사용 횟수

if IS_SERVER then
	-- 서버는 필요없다.
else

riderStartPosName	= 'start_point5'
GOALIN_GATE			= 5

function Mission()

	local m = SubMission( {CourBetteSuccessEventCheck(MAX_COURBETTE_COUNT)} )

	m.OnInit = function (self, game)
		local startMat = mgr:GetNodePos(riderStartPosName)
		util:SetMyPos( startMat.pos, startMat.at )
        util:SetVarBool( "dbg_courbetteUI", true)
	end

	m.OnRelease = function(self)
		CloseGameTipWindow()
        util:SetVarBool( "dbg_courbetteUI", false)
	end

    m.OnStart = function(self, game)
        PrepareGameTipWindow()
        util:SetVarBool( "dbg_courbetteUI", true)
    end

    m.OnReady = function(self, game)
    end

    m.OnRetry = function(self, game)
        CloseGameTipWindow()
	end

    m.OnEvent = function(self, game, strValue, intValue1, intValue2)
--        if strValue == "COURBETTE_FAILE" and intValue1 == util:GetMyOID() then
--            NEXT_STATE(game, "FAIL_RETRY")
--        end
    
        if g_subMission:CheckSuccess(game) then
            NEXT_STATE( game, "SUCCESS" )
        end
    end

    m.OnCheckSuccess = function(self)
    end

	return m
end

g_subMission = Mission()

end	-- NOT IS_SERVER
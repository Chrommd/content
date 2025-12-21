require('GameHelper')
require('aistate')
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
MAGIC_ITEM			= 4 --MagicSlot_WaterShield
TUTORIAL_SHILD_COUNT    = "Tutorial_Shild_Count"

function JumpMission()

	local m = SubMission( {MagicItemShildSuccessEventCheck()} )

	m.OnInit = function (self, game)
		local startMat = mgr:GetNodePos(riderStartPosName)
		util:SetMyPos( startMat.pos, startMat.at )
		util:SetForcedMagicItem( MAGIC_ITEM )
		startMat = mgr:GetNodePos('start_ai')
		util:SetAssetPos(800, startMat)
	end

	m.OnRelease = function (self, game)
		CloseGameTipWindow()
		util:SetVarValue("var_gaugeSpeed","1") 
        util:RFClose(TUTORIAL_SHILD_COUNT)
        util:ControllKeyFree(KEYMAPCODE_THROTTLE)
        util:ControllKeyFree(KEYMAPCODE_TURN_LEFT)
        util:ControllKeyFree(KEYMAPCODE_TURN_RIGHT)
        util:ControllKeyFree(KEYMAPCODE_BRAKE)
        util:ControllKeyFree(KEYMAPCODE_JUMP)

        
	end

    m.OnReady = function (self, game)
        local startMat = mgr:GetNodePos('start_ai')
        util:SetAssetPos(800, startMat)
		util:SetAssetCommend(800, "StopMove")
        util:ControllKeyBlock(KEYMAPCODE_THROTTLE)
        util:ControllKeyBlock(KEYMAPCODE_TURN_LEFT)
        util:ControllKeyBlock(KEYMAPCODE_TURN_RIGHT)
        util:ControllKeyBlock(KEYMAPCODE_BRAKE)
        util:ControllKeyBlock(KEYMAPCODE_JUMP)
    end

    m.OnStart = function(self, game)
        PrepareGameTipWindow()
        util:SetVarValue("var_gaugeSpeed","10") 
		--공격
		util:SetAssetCommend(800, "LookOn")
		util:SetAssetCommend(800, "Fireball", 6)
        util:RFCreateWnd(TUTORIAL_SHILD_COUNT, "tutorial_count.xml")
    end

    m.OnRetry = function(self, game)
        CloseGameTipWindow()
	end

    m.OnCheckSuccess = function(self)
    end

    m.OnEvent = function(self, game, strValue, intValue1, intValue2)
        if strValue == "SHILD_MAGICITEM" or strValue == "ATTACK_MAGICITEM" then
            if g_subMission:CheckSuccess(game) then
                NEXT_STATE( game, "SUCCESS" )
            else
                NEXT_STATE( game, "FAIL_RETRY" )
            end
        end
    end

	return m
end

g_subMission = JumpMission()

end	-- NOT IS_SERVER
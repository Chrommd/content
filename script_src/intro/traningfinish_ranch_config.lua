require('RanchHelper')

ENABLE_DEBUG = 1

if IS_SERVER then
    -- 서버는 필요없다.
else

function SetChatEvent()
	util:SetChatEvent(2, 1, 20)
end

-- test
OPENING_RANCH =
{	
    --[ SCENE1 ]----------------------------------------------------------
    --	NPC생성
    SCENE_INIT = DEFAULT_SCENE.CreateRanchNPC("SCENE_INIT2"),		-- ranchhelper.lua

	--[ SCENE2 ]----------------------------------------------------------
    --	
    SCENE_INIT2 = 
    { 		
        action =
        {
            -- condition, action			
            {},						{ ChatEnable, true },
            {},						{ NextScene, "SCENE_INTRO_FINAL" },				
        },		
    },	


    SCENE_INTRO_FINAL = 
    {
        action = 
        {
            {},										{ InputBlock, true },				-- 플레이어 입력 막음 해제
            {},										{ SetChatEvent},	 --채팅연결
        },

        event =
        {
            { Event, EVENT_NPC_CHAT, "intro_close" },		{ NextScene, "SCENE_INTRO_CLOSE" },		-- 인트로는 이제 끝
        },
    },

    SCENE_INTRO_CLOSE =
    {
        action = 
        {
            {},										{ InputBlock, false },				-- 플레이어 입력 막음 해제
            {},										{ FinishIntro },					-- Intro끝
            {},										{ SendAchvComplete, "IntroEnd" },	-- intro도전과제 완료
            {},										{ ShowManual, true, 4, "btn_exit" },		-- 끝날때 나오는 매뉴얼 하나
            {},										{ NextScene, "SCENE_NORMAL"},	-- 끝날때 나오는 매뉴얼 하나
        },
    },	
}

RegisterExerciseScene(OPENING_RANCH, "SCENE_NORMAL")

OPENING = OPENING_RANCH
startScene = "SCENE_INIT"

end	--IS_SERVER

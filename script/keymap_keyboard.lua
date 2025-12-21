--[[----------------------------------------------------------___-------------------------------------------------------
                                                             /   |
                                                            / /| |
                                                           / ___ |
                                            P R O J E C T /_/  |_| L I C E
                                        Copyright (C) 2005-2009 NTREEV SOFT Inc.
--------------------------------------------------------------------------------------------------------------------]]--

    --[[<KEYBOARD> -------------------------------------------------------------------------------------
    <NULL>
    <ESCAPE> <F1> <F2> <F3> <F4> <F5> <F6> <F7> <F8> <F9> <F10> <F11> <F12> <BACKSPACE> <TAB> 
    <CAPSLOCK> <LSHIFT> <RSHIFT> <LALT> <RALT> <LCONTROL> <RCONTROL> <RETURN>
    <PRINTSCREEN> <SCROLL> <PAUSE>
    <INSERT> <DELETE> <HOME> <END> <PGUP> <PGDN>
    <0 ~ 9> <`> <-> <=> <\\> <[> <]> <> <'> <,> <.> </> <SPACE> <A ~ Z>
    <LEFT> <UP> <RIGHT> <DOWN>
    <NUMLOCK> <NUMPADSLASH> <NUMPADSTAR> <NUMPADMINUS> <NUMPADPLUS> <NUMPADENTER> <NUMPADPERIOD> 
    <NUMPAD0> <NUMPAD1> <NUMPAD2> <NUMPAD3> <NUMPAD4> <NUMPAD5> <NUMPAD6> <NUMPAD7> <NUMPAD8> <NUMPAD9>
    ------------------------------------------------------------------------------------------------]]--

-- [ 게임용 ] ----------------------------------------------------------------------------------------------------------
-- !! 선언 순서에 따라 키커스터마이징에 보여지는 우선순위가 결정되므로  1st와 2nd 설정에 주의해 주세요.
-- !! 각 세트에 누락된 항목이 없어야 합니다. 키를 제외할 경우 NULL로 세팅해 주세요.

KEY("RCTRL", "RCONTROL")
KEY("LCTRL", "LCONTROL")

-- 1st ----------------------------------------------------------------------------------------------------------
-- 조향
KEY("THROTTLE", "UP")
KEY("TURN_LEFT", "LEFT")
KEY("TURN_RIGHT", "RIGHT")
KEY("BRAKE", "DOWN")

-- 박차/마법 사용
KEY("ACTION", "LCONTROL")

-- 슬라이딩
KEY("SLIDING", "LSHIFT")

-- 점프
KEY("JUMP", "Z")

-- 2nd ----------------------------------------------------------------------------------------------------------
-- 조향
KEY("THROTTLE", "W")
KEY("TURN_LEFT", "A")
KEY("TURN_RIGHT", "D")
KEY("BRAKE", "S")

-- 박차/마법 사용
KEY("ACTION", "RCONTROL")

-- 슬라이딩
KEY("SLIDING", "RSHIFT")

-- 점프
KEY("JUMP", "/")

-- 3rd ----------------------------------------------------------------------------------------------------------
-- 조향
KEY("THROTTLE", "I")
KEY("TURN_LEFT", "J")
KEY("TURN_RIGHT", "L")
KEY("BRAKE", "K")

-- 박차/마법 사용
KEY("ACTION", "X")

-- 슬라이딩
KEY("SLIDING", "NULL")

-- 점프
KEY("JUMP", "NULL")

-- 4th ----------------------------------------------------------------------------------------------------------
-- 조향
KEY("THROTTLE", "NUMPAD8")
KEY("TURN_LEFT", "NUMPAD4")
KEY("TURN_RIGHT", "NUMPAD6")
KEY("BRAKE", "NUMPAD5")

-- 박차/마법 사용
KEY("ACTION", ".") 

-- 슬라이딩
KEY("SLIDING", "NULL")

-- 점프
KEY("JUMP", "NULL")


-- [ 기타 ] --------------------------------------------------------------------------------------------------------

-- 공용 사용
KEY("UP", "UP")
KEY("DOWN", "DOWN")
KEY("LEFT", "LEFT")
KEY("RIGHT", "RIGHT")
KEY("TAB_FOCUS", "TAB")

-- 게임 ui
KEY("INGAME_MAP", "TAB")

KEY("RESET_POSITION", "R")
KEY("RESET_SINGLE_PLAY", "SHIFT", "R")
KEY("SHOW_VIDEO_PLAY", "SHIFT", "T")

--KEY("RESET_POSITION", "F10")
KEY("GOALIN", "RCONTROL", "G")

-- 매크로
KEY("MACRO_1", "F1")
KEY("MACRO_2", "F2")
KEY("MACRO_3", "F3")
KEY("MACRO_4", "F4")
KEY("MACRO_5", "F5")
KEY("MACRO_6", "F6")
KEY("MACRO_7", "F7")
KEY("MACRO_8", "F8")

KEY("CHAT_ENABLE", "RETURN")
KEY("CHAT_ENABLE", "NUMPADENTER")

-- 게임대기방
KEY("QUICK_READY", "F10")
KEY("TEAM_CHANGE", "F9")

-- Rider 액션 관련
--KEY("MELEE_ATTACK", "S")
--KEY("SHOT_ATTACK", "A")
KEY("CEREMONY", "SPACE")

KEY("RIDE_MOUNT", "LALT", "X")
KEY("RIDE_MOUNT", "F")

KEY("LALT", "LALT")
KEY("RALT", "RALT")

-- [ 테스트용 ] --------------------------------------------------------------------------------------------------------

KEY("DASH_LEFT", "LEFT")
KEY("DASH_RIGHT", "RIGHT")

-- Rider 조작 관련
KEY("FRONT_DIRECTION", "W")
KEY("BACK_DIRECTION", "S")
KEY("LEFT_DIRECTION", "A")
KEY("RIGHT_DIRECTION", "D")
KEY("RIDER_MOVE_TURN_L", "Q")
KEY("RIDER_MOVE_TURN_R", "E")
KEY("RIDER_MOVE_FAST", "LALT")
KEY("RIDER_MOVE_LOCK", "NUMLOCK")

-- 카메라 조작 관련
KEY("CAM_MODE_0", "NUMPAD0")
KEY("CAM_MODE_2", "NUMPADPERIOD")
KEY("CAM_MODE_4", "NUMPAD1")
KEY("CAM_MODE_5", "NUMPAD2")
KEY("CAM_MODE_6", "NUMPAD3")

-- 안 쓰는 키는 아래 키로 할당
KEY("CAM_MODE_1", "NUMPAD9")
KEY("CAM_MODE_3", "NUMPAD3")
KEY("CAM_MODE_7", "NUMPAD9")
KEY("CAM_MODE_8", "NUMPAD9")
KEY("CAM_MODE_9", "NUMPAD9")

KEY("CAM_MODE_0", "0", "RCONTROL")
KEY("CAM_MODE_7", "9", "RCONTROL")
KEY("CAM_MOVE_FRONT", "W")
KEY("CAM_MOVE_BACK", "S")
KEY("CAM_TURN_LEFT", "A")
KEY("CAM_TURN_RIGHT", "D")
KEY("CAM_PITCH_UP", "Q")
KEY("CAM_PITCH_DOWN", "E")
KEY("CAM_INCREASE_FOV", "PGUP")
KEY("CAM_DECREASE_FOV", "PGDN")
KEY("CAM_ZOOM", "Z")
KEY("CAM_CHANGE_FOCUS", "TAB", "RCONTROL")
KEY("CAM_OTHERUSER_FOCUS", "TAB")
KEY("CAM_SELF_FOCUS", "SPACE")
KEY("CAM_RANK_1", "1")
KEY("CAM_RANK_2", "2")
KEY("CAM_RANK_3", "3")
KEY("CAM_RANK_4", "4")
KEY("CAM_RANK_5", "5")
KEY("CAM_RANK_6", "6")
KEY("CAM_RANK_7", "7")
KEY("CAM_RANK_8", "8")
KEY("CAM_CHANGE", "INSERT")
KEY("CAM_MONSTER_FOCUS", "TAB", "LCONTROL")
KEY("CAM_BACKVIEW", "C")
KEY("CAM_OBS_TARGET", "F5")
KEY("CAM_OBS_HORSE", "F6")
KEY("CAM_OBS_COURSE", "F7")
KEY("CAM_OBS_OPTION1", "LCONTROL")
KEY("CAM_OBS_OPTION2", "LSHIFT")

-- 디버그용
for num = 1, 12 do
    KEY("FUNC_"..num, "F"..num)
end
KEY("HEIMA_TEST", "SPACE")
KEY("RESET", "RCONTROL", "F6")
KEY("REFRESH", "CONTROL", "F5")
KEY("FAST_MODE", "=")
KEY("SLOW_MODE", "-")
KEY("FROZEN_MODE", "\\")
KEY("MAPMAKING", "RCONTROL", "M")
KEY("HIDE_UI", "RCONTROL", "H")
KEY("CONSOLE", "SCROLL")
KEY("SCREEN_CAPTURE", "F11")
KEY("SCREEN_CAPTURE_N_REPORT", "LSHIFT", "F11")
KEY("VIDEO_CAPTURE", "F12")
KEY("SCREEN_CAPTURE360", "RCONTROL", "F11")
KEY("SCREEN_CAPTURE360TEST", "RALT", "F11")
KEY("SCREEN_CAPTURECUBE", "RSHIFT", "F11")
KEY("MICRO_CONTROL", "ALT")
KEY("ZOOM_IN", "RSHIFT", "=")
KEY("ZOOM_IN", "NUMPADPLUS")
KEY("ZOOM_OUT", "RSHIFT", "-")
KEY("ZOOM_OUT", "NUMPADMINUS")
KEY("PROFILING", "RSHIFT", "F8")
KEY("PROFILING_R", "RSHIFT", "F9")
KEY("CAM4_OPTION", "F9")
KEY("LAUNCH_GAME", "RETURN")
KEY("LAUNCH_GAME", "NUMPADENTER")
KEY("TOGGLE_CHAT", "RETURN")
KEY("TOGGLE_CHAT", "NUMPADENTER")
KEY("DISPLAY_COLLI_COURSE", "RCONTROL", "F2")
KEY("TOGGLE_GRASS", "RCONTROL", "F3")
KEY("SHOW_CAMERA_EVENT", "RCONTROL", "F4")
KEY("FORCE_MOVE_RIGHT", "RCONTROL", "R")
--KEY("STAT_WINDOW", "F2")

-- boss camera
KEY("LOOK_BOSS", "SPACE")

KEY("FREEZEFRUSTUM", "RCONTROL", "F7")
KEY("FORCE_STATE", "RCONTROL", "SPACE")

KEY("UI_EXIT", "ESCAPE")
KEY("UI_MAP_GUIDE", "F1")

KEY("SAVE_POS", "HOME", "RCONTROL")
KEY("LOAD_POS", "HOME")
KEY("CHARACTER_SHOW", "C")

-- 슬롯
KEY("ATTACK_MELEE", "X")
KEY("ATTACK_ARROW", "X")
KEY("ATTACK_SPECIAL", "C")
KEY("WEAPON_CHANGE", "W", "LCONTROL")

-- 스킬
KEY("SKILL_1", "1")
KEY("SKILL_2", "2")
KEY("SKILL_3", "3")
KEY("SKILL_4", "4")

--KEY("MAGIC_TURBO", "X") 

-- 아이템 테스트
KEY("UPGRADED_ITEM", "LSHIFT")
KEY("ITEM_1", "Q")
KEY("ITEM_2", "W")
KEY("ITEM_3", "E")
KEY("ITEM_4", "R")
KEY("ITEM_5", "T")
KEY("ITEM_6", "Y")
KEY("ITEM_7", "S")
KEY("ITEM_8", "D")
KEY("ITEM_9", "F")
KEY("ITEM_10", "V")
KEY("ITEM_11", "U")
KEY("ITEM_12", "I")
KEY("ITEM_13", "J")
KEY("ITEM_14", "K")


-- 싱글월드(보스몹) 테스트
KEY("BOSS_LOAD", "0")
KEY("BOSS_ATTACH_WING", "1")
KEY("BOSS_ATTACH_TAIL", "2")
KEY("BOSS_DETACH_WING", "3")
KEY("BOSS_DETACH_TAIL", "4")
KEY("BOSS_STATE1", "5")
KEY("BOSS_STATE2", "6")
KEY("BOSS_STATE3", "7")
KEY("BOSS_STATE4", "8")
KEY("BOSS_STATE5", "9")
KEY("BOSS_SCALE_INC", "=")
KEY("BOSS_SCALE_DEC", "-")
KEY("CHANGE_MOB", "TAB")

-- 목장 관리
KEY("MANAGE_WALK", "`")
KEY("MOUNT", "K")
KEY("DISMOUNT", "L")
KEY("RIDER_MOVETRANS", "J")
KEY("CREATE_DUMMYCHARACTER", "LSHIFT", "N")
KEY("CALL_HORSE", "SPACE")
KEY("GOTO_NPC1", "RCONTROL", "1")
KEY("GOTO_NPC1", "LCONTROL", "1")
KEY("GOTO_NPC2", "RCONTROL", "2")
KEY("GOTO_NPC2", "LCONTROL", "2")
KEY("GOTO_NPC3", "RCONTROL", "3")
KEY("GOTO_NPC3", "LCONTROL", "3")
KEY("GOTO_NPC4", "RCONTROL", "4")
KEY("GOTO_NPC4", "LCONTROL", "4")
KEY("GOTO_NPC5", "RCONTROL", "5")
KEY("GOTO_NPC5", "LCONTROL", "5")
KEY("GOTO_NPC6", "RCONTROL", "6")
KEY("GOTO_NPC6", "LCONTROL", "6")


-- NPC채팅 디버깅용
KEY("NPC_CHAT_BACK", "BACKSPACE")
KEY("NPC_CHAT_SELECT_1", "1")
KEY("NPC_CHAT_SELECT_2", "2")
KEY("NPC_CHAT_SELECT_3", "3")
KEY("NPC_CHAT_SELECT_4", "4")
KEY("NPC_CHAT_SELECT_5", "5")
KEY("NPC_CHAT_SELECT_6", "6")
KEY("NPC_CHAT_SELECT_7", "7")
KEY("NPC_CHAT_SELECT_8", "8")
KEY("NPC_CHAT_SELECT_9", "9")
KEY("NPC_CHAT_SELECT_10", "0")
KEY("NPC_CHAT_SELECT_11", "Q")
KEY("NPC_CHAT_SELECT_12", "W")
KEY("NPC_CHAT_SELECT_13", "E")
KEY("NPC_CHAT_SELECT_14", "R")
KEY("NPC_CHAT_SELECT_15", "T")
KEY("NPC_CHAT_SELECT_16", "Y")
KEY("NPC_CHAT_SELECT_17", "U")
KEY("NPC_CHAT_SELECT_18", "I")
KEY("NPC_CHAT_SELECT_19", "O")
KEY("NPC_CHAT_SELECT_20", "P")


-- 말 씻기기 테스트용
KEY("WASH_SEC0_UP", "NUMPAD7")
KEY("WASH_SEC0_DN", "NUMPAD4")
KEY("WASH_SEC1_UP", "NUMPAD8")
KEY("WASH_SEC1_DN", "NUMPAD5")
KEY("WASH_SEC2_UP", "NUMPAD9")
KEY("WASH_SEC2_DN", "NUMPAD6")

-- GNB 단축키
--KEY("GNB_RANCH", "LCONTROL", "R")
--KEY("GNB_GAME", "LCONTROL", "G")
--KEY("GNB_SHOP", "LCONTROL", "S")
--KEY("GNB_INVEN", "LCONTROL", "I")
--KEY("GNB_MANAGE", "LCONTROL", "H")
--KEY("GNB_WIDGET", "H")

KEY("GNB_HORSEINFO", "1")
KEY("GNB_MYINFO", "2")
KEY("GNB_MESSENGER", "3")
KEY("GNB_POST", "4")
--KEY("GNB_STORAGEBOX", "5")
KEY("GNB_RANKING", "6")
KEY("GNB_QUEST", "5")
KEY("GNB_OPTION", "8")
--KEY("GNB_NOTICE", "6")
KEY("GNB_COLLECTION", "7")
KEY("CHAT_TAB", "TAB", "LCONTROL")

KEY("MYINFO_TAB", "TAB")
KEY("EMOTICON_FORM", "LCONTROL", "E")

-- emblem editor
KEY("UNDO", "LCONTROL", "Z")
KEY("UNDO", "RCONTROL", "Z")
KEY("REDO", "LCONTROL", "Y")
KEY("REDO", "RCONTROL", "Y")
KEY("MAGNIFICATION_HIGH", "W")
KEY("MAGNIFICATION_LOW", "S")
KEY("ROTATION_LEFT", "A")
KEY("ROTATION_RIGHT", "D")
KEY("FLIP", "F")

--[[--------------------------------------------------------------------------------------------------------------------
                                                       A L I C E                                                        
--------------------------------------------------------------------------------------------------------------------]]--

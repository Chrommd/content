--[[----------------------------------------------------------___-------------------------------------------------------
                                                             /   |
                                                            / /| |
                                                           / ___ |
                                            P R O J E C T /_/  |_| L I C E
                                        Copyright (C) 2005-2009 NTREEV SOFT Inc.
--------------------------------------------------------------------------------------------------------------------]]--

    --[[<GAMEPAD> --------------------------------------------
    
    <X_AXIS_LEFT> <X_AXIS_RIGHT> <Y_AXIS_UP> <Y_AXIS_DOWN> <Z_AXIS_MINUS> <Z_AXIS_PLUS>
    <X_ROT_LEFT> <X_ROT_RIGHT> <Y_ROT_UP> <Y_ROT_DOWN> <Z_ROT_MINUS> <Z_ROT_PLUS>
    <POV_LEFT> <POV_RIGHT> <POV_UP> <POV_DOWN>
    <BUTTON01> <BUTTON02> <BUTTON03> <BUTTON04> <BUTTON05> <BUTTON06>
    <BUTTON07> <BUTTON08> <BUTTON09> <BUTTON10> <BUTTON11> <BUTTON12>
    <BUTTON13> <BUTTON14> <BUTTON15> <BUTTON16> <BUTTON17> <BUTTON18>
    <SLIDER_MINUS> <SLIDER_PLUS>
    
    -- 제어판의 "게임 컨트롤러" 를 클릭 "속성"의 "테스트" 탭을 보시면 컨트롤러 버튼을 확인 할수있습니다. --
            
    < 팁 : xbox360 - Z_AXIS 값의 경우 "테스트" 하고 "보정" 에서 표시가 반대로 됩니다. 실제값은 보정에서 표시되는 값입니다. >
    
        Left Stick left/right   -> X_AXIS (left/right)
        Left Stick up/down      -> Y_AXIS (up/down)
        Left Stick click        -> BUTTON09
        
        Right Stick left/right  -> X_ROT (left/right)
        Right Stick up/down     -> Y_ROT (up/down)
        Right Stick click       -> BUTTON10
        
        Dpad left/right         -> POV (left/right)
        Dpad up/down            -> POV (up/down)
        
        A Button                -> BUTTON01
        B Button                -> BUTTON02
        X Button                -> BUTTON03
        Y Button                -> BUTTON04
        
        Left(위)    Button      -> BUTTON05
        Left(아래)  Button      -> Z_AXIS_PLUS
        Right(위)   Button      -> BUTTON06
        Right(아래) Button      -> Z_AXIS_MINUS
        
        Back  Button            -> BUTTON07
        Start Button            -> BUTTON08
    ------------------------------------------------------]]--


-- [ 게임용 ] ----------------------------------------------------------------------------------------------------------

--[[
X Device용 키값을 DI용으로 매핑하여 사용함.
스크립트에서는 DI용으로만 셋팅하면 DI, XInput 구분 없이 사용 가능.
--]]

KEY("THROTTLE", "POV_UP")
KEY("THROTTLE", "BUTTON07")

KEY("TURN_LEFT", "POV_LEFT")

KEY("TURN_RIGHT", "POV_RIGHT")

KEY("BRAKE", "POV_DOWN")
KEY("BRAKE", "BUTTON08")

KEY("ACTION", "BUTTON04")
KEY("ACTION", "BUTTON05")

KEY("SLIDING", "BUTTON01")
KEY("SLIDING", "BUTTON03")

KEY("JUMP", "BUTTON02")

KEY("CEREMONY", "BUTTON11")

KEY("RESET_POSITION", "BUTTON10")

KEY("INGAME_MAP", "BUTTON09")

KEY("CAM_CHANGE", "BUTTON12")

KEY("CAM_BACKVIEW", "BUTTON06")



-- 채팅 매크로
--[[
KEY("MACRO_1", "Y_AXIS_UP")
KEY("MACRO_2", "Y_AXIS_DOWN")
KEY("MACRO_3", "X_AXIS_LEFT")
KEY("MACRO_4", "X_AXIS_RIGHT")
KEY("MACRO_5", "Z_AXIS_MINUS")
KEY("MACRO_6", "Z_AXIS_PLUS")
KEY("MACRO_7", "Z_ROT_MINUS")
KEY("MACRO_8", "Z_ROT_PLUS")
--]]

--[[	Type 1
KEY("THROTTLE", "BUTTON08")		-- R1
KEY("BRAKE", "X_ROT_RIGHT")		-- R2

KEY("TURN_LEFT", "X_AXIS_LEFT")
KEY("TURN_LEFT", "POV_LEFT")

KEY("TURN_RIGHT", "X_AXIS_RIGHT")
KEY("TURN_RIGHT", "POV_RIGHT")

KEY("JUMP", "BUTTON01")			-- 세모/Y
KEY("SLIDING", "BUTTON04")		-- 네모/X

KEY("ACTION", "BUTTON02")		-- O/B
KEY("ACTION", "BUTTON07")	-- L1

KEY("USE_MAGIC_SLOT", "BUTTON03")	-- X/A
KEY("USE_MAGIC_SLOT", "BUTTON07")	-- L1
--]]

--[[ Type2
KEY("THROTTLE", "BUTTON03")		-- X
KEY("BRAKE", "BUTTON02")		-- O

KEY("TURN_LEFT", "X_AXIS_LEFT")
KEY("TURN_LEFT", "POV_LEFT")

KEY("TURN_RIGHT", "X_AXIS_RIGHT")
KEY("TURN_RIGHT", "POV_RIGHT")

KEY("JUMP", "BUTTON04")			-- 네모
KEY("SLIDING", "BUTTON08")		-- R1

KEY("ACTION", "X_ROT_RIGHT")		-- R2
KEY("ACTION", "BUTTON07")	-- L1

KEY("USE_MAGIC_SLOT", "X_ROT_RIGHT")	-- R2
KEY("USE_MAGIC_SLOT", "BUTTON07")	-- L1
--]]

--[[
KEY("CURSOR_LEFT", "X_AXIS_LEFT")
KEY("CURSOR_RIGHT", "X_AXIS_RIGHT")
KEY("CURSOR_UP", "Y_AXIS_UP")
KEY("CURSOR_DOWN", "Y_AXIS_DOWN")

KEY("CURSOR_LEFT", "POV_LEFT")
KEY("CURSOR_RIGHT", "POV_RIGHT")
KEY("CURSOR_UP", "POV_UP")
KEY("CURSOR_DOWN", "POV_DOWN")

KEY("CURSOR_LEFT", "Z_ROT_MINUS")
KEY("CURSOR_RIGHT", "Z_ROT_PLUS")
KEY("CURSOR_UP", "Z_AXIS_MINUS")
KEY("CURSOR_DOWN", "Z_AXIS_PLUS")

KEY("BUTTON_SELECT", "BUTTON09")		-- Select
KEY("BUTTON_START", "BUTTON10")			-- Start
KEY("QUICK_READY", "BUTTON10")			-- Start

KEY("BUTTON_A", "BUTTON02")				-- X/B
KEY("BUTTON_B", "BUTTON03")				-- O/A

KEY("CAM_CHANGE", "X_ROT_LEFT")			-- L2
KEY("RESET_POSITION", "BUTTON10")		-- Start
--]]
-- [ 테스트용 ] --------------------------------------------------------------------------------------------------------


--[[--------------------------------------------------------------------------------------------------------------------
                                                       A L I C E                                                        
--------------------------------------------------------------------------------------------------------------------]]--

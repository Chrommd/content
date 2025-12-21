--[[----------------------------------------------------------___-------------------------------------------------------
                                                             /   |
                                                            / /| |
                                                           / ___ |
                                            P R O J E C T /_/  |_| L I C E
                                        Copyright (C) 2005-2006 NTREEV SOFT Inc.
--------------------------------------------------------------------------------------------------------------------]]--

acCheckOnce("keysetup")

------------------------------------------------------------------------------------------------------------------------

local s_keyList = {}

local function AddKey2Device(device, list)
    local argument
    for i, key in pairs(list) do
        if key.code0 == "CONTROL" or key.code0 == "SHIFT" or key.code0 == "ALT" then
            argument = string.format("-name [%s] -device [%s] -key0 [L%s]", key.alise, device, key.code0)
            if key.code1 ~= nil then
                argument = argument..string.format(" -key1 [%s]", key.code1)
            end
            acAddKey(argument)        
            
            argument = string.format("-name [%s] -device [%s] -key0 [R%s]", key.alise, device, key.code0)
            if key.code1 ~= nil then
                argument = argument..string.format(" -key1 [%s]", key.code1)
            end
            acAddKey(argument)        
        else    
            argument = string.format("-name [%s] -device [%s] -key0 [%s]", key.alise, device, key.code0)
            if key.code1 ~= nil then
                argument = argument..string.format(" -key1 [%s]", key.code1)
            end
            acAddKey(argument)        
        end
    end
end

function KEY(a, c0, c1, list)
    list = list or s_keyList
    if a ~= NULL then
        c0 = c0 or a
        local index = table.getn(list) + 1
        list[index] = { alise = a, code0 = c0, code1 = c1 }
    else
        AddKey2Device(c0, list)
        s_keyList = {}
    end
end

acParseScriptOnce("keymap_keyboard")
KEY(NULL, "KEYBOARD") -- 추가한 키를 실제로 키보드 디바이스에 추가

acParseScriptOnce("keymap_mouse")
KEY(NULL, "MOUSE") -- 추가한 키를 실제로 마우스 디바이스에 추가

acParseScriptOnce("keymap_gamepad")
KEY(NULL, "GAMEPAD") -- 추가한 키를 실제로 게임패드 디바이스에 추가

--[[--------------------------------------------------------------------------------------------------------------------
                                                       A L I C E                                                        
--------------------------------------------------------------------------------------------------------------------]]--

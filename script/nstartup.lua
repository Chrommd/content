--[[----------------------------------------------------------___-------------------------------------------------------
                                                             /   |
                                                            / /| |
                                                           / ___ |
                                            P R O J E C T /_/  |_| L I C E
                                        Copyright (C) 2005-2006 NTREEV SOFT Inc.
--------------------------------------------------------------------------------------------------------------------]]--

ScpMgr = AcScpMgrProxy()
Config = AcConfigProxy()
ObjMgr = AcObjMgrProxy()
ResMgr = AcResMgrProxy()

function acAddKey(argument)
    Config:addKey(argument)
end

function acParseScript(file)
    ScpMgr:parse(file)
end

function acPurgeMgr(type)
    if type == "OBJ" then
        ObjMgr:purgeAll()
    elseif type == "RES" then
        ResMgr:purgeAll()
    end
end

local kScpList = {}
function acParseScriptOnce(fileName)
    if kScpList[fileName] == nil then
        acParseScript(fileName)
        kScpList[fileName] = 1
    end
end

acParseScript("macro")
acParseScript("keysetup")

--[[--------------------------------------------------------------------------------------------------------------------
                                                       A L I C E                                                        
--------------------------------------------------------------------------------------------------------------------]]--

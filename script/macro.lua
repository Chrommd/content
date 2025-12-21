--[[----------------------------------------------------------___-------------------------------------------------------
                                                             /   |
                                                            / /| |
                                                           / ___ |
                                            P R O J E C T /_/  |_| L I C E
                                        Copyright (C) 2005-2006 NTREEV SOFT Inc.
--------------------------------------------------------------------------------------------------------------------]]--

-- 상수들 정의 --

NULL = 0

YES = 1
NO = 0

ENABLE = 1
DISABLE = 0

MASTER = 0
RELEASE = 1
DEBUG = 2

-- 유틸리티 함수들 --

function RGB(r, g, b)
    local color = {}
    color.r = r
    color.g = g
    color.b = b
    return color
end

function V2D(x, y)
    local v2d = {}
    v2d.x = x or 0
    v2d.y = y or 0
    return v2d
end

function V3D(x, y, z)
    local v3d = {}
    v3d.x = x or 0
    v3d.y = y or 0
    v3d.z = z or 0
    return v3d
end

function _M(meter)
    return meter
end

function _DEG(degree)
    return degree
end

-- 디버깅 관련 함수들 --

local s_once_tag = {}

function acASSERT(exp, msg)
    if (exp == false) or (exp == nil) or (exp == 0) then
        ScpMgr:msgbox(msg)
    end
end

function acASSERT_FAIL(msg)
    acASSERT(0, msg)
end

function acASSERTE(exp)
    acASSERT(exp, "Assert!")
end

function acTRACE(...)
    ScpMgr:trace(string.format(...))
end

function acCheckOnce(tag, skip)
    for i, key in pairs(s_once_tag) do
        if key == tag then
            if skip == nil then
                acASSERT_FAIL(tag.." 파일은 한번만 로드 되어야 합니다!")
            end
            return
        end
    end
    s_once_tag[table.getn(s_once_tag)] = tag
end

--[[--------------------------------------------------------------------------------------------------------------------
                                                       A L I C E                                                        
--------------------------------------------------------------------------------------------------------------------]]--

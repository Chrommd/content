--[[--------------------------------------------------------------------------------------------------------------------
                                                             /   |
                                                            / /| |
                                                           / ___ |
                                            P R O J E C T /_/  |_| L I C E
                                        Copyright (C) 2005-2009 NTREEV SOFT Inc.
--------------------------------------------------------------------------------------------------------------------]]--

-- add current path as a additional package path, so that we don't need to specify path for the 'require' function.
local __FILE__ = string.sub(debug.getinfo(1,'S').source, 2)

local add_path1 = string.gsub(__FILE__, "\\([_%w]+)\.lua", "\\?.lua")
local add_path2 = string.gsub(__FILE__, "\\([_%w]+)\.luc", "\\?.luc")

package.path = package.path .. ";" .. add_path1 .. ";" .. add_path2

function include(module_name)
   package.loaded[module_name] = nil
   require(module_name)
end

-- include form files
include "sys_function"
include "sys_filelist"

--[[--------------------------------------------------------------------------------------------------------------------
                                               P R O J E C T - A L I C E                                                
--------------------------------------------------------------------------------------------------------------------]]--

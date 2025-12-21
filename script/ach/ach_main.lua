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

-- include module
require "ach_lib"
require "ach_conditions"

-- Player Object
local Player = {}
Player.duplicate = function (self)
   local o = {}
   setmetatable(o, self)
   self.__index = self
   return o
end
Player.get_num = function (self, key)
   local o = self[key] or "0"
   return tonumber(o)
end
Player.get_bool = function (self, key)
   local num = self:get_num(key)
   if num == 0 then
      return false
   end
   return true
end
Player.get_str = function (self, key)
   local o = self[key] or ""
   return tostring(o)
end
Player.get = Player.get_num
Player.set = function (self, k, v)
   self[k] = tostring(v)
end

-- debug
Player.LOG = function (self, message)
   _ALERT("["..self.user_uid.."] "..self.nickname..": "..message.."\n")
end


-- list of player object
local PlayerList = {}

-- helper functions
function create_player(user_uid, login_id, nickname)
   local o = Player:duplicate()
   o.user_uid = user_uid
   o.login_id = login_id
   o.nickname = nickname

   PlayerList[user_uid] = o
end

function delete_player(user_uid)
   leave_room(user_uid)

   PlayerList[user_uid] = nil
end

function update_property(user_uid, k, v)
   local player = PlayerList[user_uid]
   if player == nil then
      _ALERT("update_property - player not found: USER_UID("..user_uid..")\n")
      return
   end

   player:set(k,v)
end

function query_property(user_uid, k)
   local player = PlayerList[user_uid]
   if player == nil then
      _ALERT("query_property - player not found: USER_UID("..user_uid..")\n")
      return
   end

   return player[k]
end

function check_achievements(user_uid, fun, arg1)
   local check = _G[fun]
   if check == nil then
      return false
   end
   
   return check(PlayerList[user_uid], arg1)
end

-- list of roomobject
local RoomList = {}

function enter_room(room_id, user_uid)
   leave_room(user_uid)

   local player = PlayerList[user_uid]
   if player == nil then
      return
   end
   
   RoomList[room_id] = RoomList[room_id] or {}
   
   local room = RoomList[room_id]
   room.room_id = room_id
   room.playerList = room.playerList or {}
   room.playerList[user_uid] = player
end

function leave_room(user_uid)
   local player = PlayerList[user_uid]
   if player == nil then
      return
   end
   
   local room_id = query_property(user_uid, "RoomId")
   local room = RoomList[room_id]
   if room == nil then
      return
   end
   
   room.playerList[user_uid] = nil
   
   if getTableSize(room.playerList) == 0 then
      RoomList[room_id] = nil
   end
end

function find_room(roomId)
   return RoomList[roomId]
end

function for_room_player(me, fn)
   local roomId = me:get("RoomId")
   local room = find_room(roomId)
   if room == nil then
      return
   end

   for _,v in pairs(room.playerList) do
      if fn(v) == false then
         break
      end
   end
end

--[[--------------------------------------------------------------------------------------------------------------------
                                               P R O J E C T - A L I C E                                                
--------------------------------------------------------------------------------------------------------------------]]--

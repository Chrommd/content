require('AIState')
require('AIHelper')
require('AIDefault')
require('MissionTypes')
require('GameHelper')

g_Game = CREATE_GAME()

function CreateGameState()
	local stateList = 
	{	
		WAIT =
		{
			event = function( state, game, event, strValue, intValue1, intValue2 )
			
				if event==EVENT_WAIT then
					if strValue=="client" and intValue1==CS_EVENT_LOAD_COMPLETE then						
						NEXT_STATE( game, "INIT" )
					end
				end
			end,
		},
			
		INIT = 
		{	
			enter = function (state, game) 
				-- Create Stato
				local stato = mgr:CreateMob( "stato_thief", "stato_thief", statoStartPos )	
				game.statoID = stato:GetObjID()
				
				local path = {}
				if mgr:SetMobPath(stato, "stato_path", "patrol_path") then
					local info = GET_MOB_INFO(stato)
					if info ~= nil and info.patrol_path ~= nil then
						local pos = info.patrol_path[1]
						print('startPos( '..pos.x..', '..pos.y..', '..pos.z..' )\n')
						stato:ResetPos(pos.x, pos.y, pos.z)
					end
				end
				
				local info = GET_MOB_INFO(stato)
				if info ~= nil then
					info.active = true
				end
				
				mgr:SendEventToClient( EVENT_SCRIPT, SC_EVENT_ADD_NPC, game.statoID )
				
				state.procDelay = 0.1
			end,			
			
			event = function( state, game, event, strValue, intValue1, intValue2 )
			
				if event==EVENT_SCRIPT then
					if strValue=="client" and intValue1==CS_EVENT_MISSION_START then						
						NEXT_STATE( game, "PLAY" )
					end
				end
			end,
		},
		
		PLAY = 
		{	
			enter = function (state, game) 
				
				NEXT_MOB_STATE( game.statoID, STATE_PATROL )				
				state.procDelay = 0.1
			end,			
			
			process = function (state, game) 
				if game.velocityLockTime and game.curTime >= game.velocityLockTime then
					local stato = mgr:GetMob(game.statoID)
					if stato ~= nil then
						stato:SetVelocity( stato:GetDefaultVelocity() )
					end
				end
			end,			
			
			event = function( state, game, event, strValue, intValue1, intValue2 )
				if event==EVENT_SCRIPT then
					if strValue=="client" then
						if intValue1==SC_EVENT_ROAD_DEPTH_GAP then
							local depthGap = intValue2
							--print('depth = '..depthGap..'\n')							
							if depthGap > 10 then
								local stato = mgr:GetMob(game.statoID)
								local curVelocity = stato:GetVelocity()
								if stato ~= nil and stato:GetVelocity()>0 then 
									local newVelocity = RANGE( 10, curVelocity - 5, curVelocity )
									stato:SetVelocity( newVelocity )
									
									if newVelocity <= 0 then
										local info = GET_MOB_INFO(stato)
										if info ~= nil then
											PLAY_MOTION( info, stato, MOTION_IDLE )
										end
									end
								end
							elseif depthGap < 0 then
								local stato = mgr:GetMob(game.statoID)
								if stato ~= nil then
									stato:SetVelocity( stato:GetDefaultVelocity() )
									local info = GET_MOB_INFO(stato)
									if info ~= nil then
										local state = info.state[STATE_PATROL]
										state.knockbackTime = info.curTime + 1
									end
								end
							else
								if not game.velocityLockTime or game.curTime >= game.velocityLockTime then
									local stato = mgr:GetMob(game.statoID)
									stato:SetVelocity( stato:GetDefaultVelocity() )
								end
							end
						end
					elseif strValue=="server" then
						if intValue1==SC_EVENT_ACQUIRE_ITEM then
							-- get!
							mgr:SendEventToClient( EVENT_SCRIPT, SC_EVENT_ACQUIRE_ITEM )
						elseif intValue1==SC_EVENT_MISSION_END_WAIT then
							NEXT_STATE( game, "WAIT_END" )
						end
					end
				end
			end
		},
		
		WAIT_END = 
		{
			enter = function (state, game) 
				SET_TIMER(game, "WAIT_TIME_OVER", END_WAIT_TIME)
				--print(END_WAIT_TIME..' sec to end\n')
				mgr:SendEventToClient( EVENT_SCRIPT, SC_EVENT_MISSION_END_WAIT, END_WAIT_TIME )
			end,
			
			leave = function (state, game) 
				CLEAR_TIMER(game, "WAIT_TIME_OVER")
			end,
			
			event = function( state, game, event, strValue, intValue1, intValue2 )
				if event==EVENT_TIMER then
					if strValue=="WAIT_TIME_OVER" then	
						-- TODO:client에서 안 보내는 경우 알아서 처리해야한다									
					end
				elseif event==EVENT_SCRIPT then
					if strValue=="client" and intValue1==CS_EVENT_MISSION_RESULT then						
						--print('CS_EVENT_JUMP_SUCCESS received\n')
						mgr:EndGame(intValue2)						
						NEXT_STATE( game, "END" )
					end
				end
			end			
		},
		
		END = 
		{
			enter = function (state, game) 
				state.procDelay = 1
			end,			
		},
	}

	return stateList
end
		
-- 초기화
function OnInit()	
	RANDOMSEED()
	g_Game.state = CreateGameState()
	NEXT_STATE( g_Game, "WAIT" )
	
	print('--- server Init OK\n')
end

-- process때마다 호출
function OnProcess( deltaTime )

	if g_Game.active then
		PROCESS_GAME( g_Game, deltaTime )
	end
end


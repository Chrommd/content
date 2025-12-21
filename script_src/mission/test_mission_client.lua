require('AIState')
require('AIHelper')
require('AIDefault')
require('MissionTypes')
require('GameHelper')

DIALOG_ASK_JUMP		= 1
DIALOG_JUMP_FAIL	= 2
DIALOG_GOOD_JOB		= 3

MISSION_TRY_TIME		= 90		-- 초

g_Game = CREATE_GAME()

local goalLine1 = v3(-358.25, 56, -13.41)
local goalLine2 = v3(-358.25, -4.14, 11.09)
local statoStartPos = v3(403.41, 52.58, -5.28)
local statoFirstMovePos = v3(350.47, 56, 17.09)
local statoLastMovePos = v3(-380.68, 56, 13.72)

function CreateGameState()
	local stateList = 
	{	
		INIT = 
		{	
			enter = function (state, game) 
				-- client only mob
				local stato = mgr:CreateMob( "stato", "stato", statoStartPos, MONSTER_TYPE_FRIENDLY )	
				game.statoID = stato:GetObjID()
				
				-- SetCameraFocus( objectID, distance, cameraHeight, targetHeight )
				util:SetCameraFocus(game.statoID, 5, 2, 2)
				util:ShowInfo(MISSION_TRY_TIME.."초 안에 끝까지 점프해서 가보세요!", DIALOG_ASK_JUMP)
				
				state.procDelay = 0.1
			end,			
			
			event = function( state, game, event, strValue, intValue1, intValue2 )
				if event==EVENT_UI_CLOSE then
					if strValue=="MissionInfo" and intValue1==DIALOG_ASK_JUMP then						
						NEXT_STATE( game, "JUMP" )
					end
				end
			end,
		},
	
		JUMP =
		{
			enter = function (state, game) 
				local player = mgr:GetPlayer( util:GetMyOID() )
				if player ~= nil then
					local pos = player:GetPos()
					local stato = mgr:GetMob(game.statoID)
					if stato ~= nil then
						-- 첫번째 언덕 위
						stato:Move( statoFirstMovePos.x, statoFirstMovePos.y, statoFirstMovePos.z )
						stato:LookAt( player:GetPos() )
					end
					
					util:SetCameraPlayer()
					
					util:ShowTimer(MISSION_TRY_TIME)
					SET_TIMER(game, "JUMP_TIME_OVER", MISSION_TRY_TIME)
					
					game.jumpCount = 0
					state.procDelay = 0.1				
				
					state.prevPos = v3(pos.x, pos.y, pos.z)
				else
					state.prevPos = v3(0,0,0)
				end
			end,
			
			process = function (state, game)
				local player = mgr:GetPlayer( util:GetMyOID() )
				if player ~= nil then
					local pos = player:GetPos()
				
					if util:IsCrossLine( state.prevPos, pos, goalLine1, goalLine2 ) then
						NEXT_STATE( game, "SUCCESS" )					
					end
					
					state.prevPos = v3(pos.x, pos.y, pos.z)
				end
			end,
			
			leave = function (state, game) 
				CLEAR_TIMER(game, "JUMP_TIME_OVER")
			end,
			
			event = function( state, game, event, strValue, intValue1, intValue2 )
				if event==EVENT_TIMER then
					if strValue=="JUMP_TIME_OVER" then
						NEXT_STATE( game, "FAIL" )						
					end
				end
			end
		},
		
		SUCCESS =
		{
			enter = function (state, game)
				local stato = mgr:GetMob(game.statoID)
				if stato ~= nil then
					-- 결승점 근처
					stato:ResetPos( statoLastMovePos.x, statoLastMovePos.y, statoLastMovePos.z )
					
					local player = mgr:GetPlayer( util:GetMyOID() )
					if player ~= nil then
						stato:LookAt( player:GetPos() )
					end
				end
				
				util:SetCameraFocus(game.statoID, 5, 2, 2)
				util:ShowInfo("와우 잘했어요!", DIALOG_GOOD_JOB)
				util:SendEventToServer( EVENT_SCRIPT, CS_EVENT_MISSION_RESULT, MISSIONRESULT_SUCCESS )
				game.active = false
			end,
			
			event = function( state, game, event, strValue, intValue1, intValue2 )
				if event==EVENT_UI_CLOSE then
					if strValue=="MissionInfo" and intValue1==DIALOG_GOOD_JOB then						
						util:SetCameraPlayer()
					end
				end
			end,
		},		
		
		FAIL =
		{
			enter = function (state, game)
				util:SetCameraFocus(game.statoID, 5, 2, 2)
				util:ShowInfo("저런! "..MISSION_TRY_TIME.."초가 지났군요. 실패했어욧!", DIALOG_JUMP_FAIL)
				util:SendEventToServer( EVENT_SCRIPT, CS_EVENT_MISSION_RESULT, MISSIONRESULT_FAILED )
				game.active = false
			end,
			
			event = function( state, game, event, strValue, intValue1, intValue2 )
				if event==EVENT_UI_CLOSE then
					if strValue=="MissionInfo" and intValue1==DIALOG_JUMP_FAIL then						
						util:SetCameraPlayer()
					end
				end
			end,
		},		
	}

	return stateList
end

-- 초기화
function OnInit()
	
	g_Game.state = CreateGameState()
	NEXT_STATE( g_Game, "INIT" )
	
	print('--- client Init OK\n')
end

-- process때마다 호출
function OnProcess( deltaTime )

	if g_Game.active then
		PROCESS_GAME( g_Game, deltaTime )		
	end
end

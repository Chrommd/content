require('AIState')
require('AIHelper')
require('AIDefault')
require('MissionTypes')
require('GameHelper')
require('UITypes')
require('EffectTypes')
require('NetTypes')
require('tutorialHelper')

DIALOG_TUTORIAL_FAIL	= 1
DIALOG_GOOD_JOB			= 2

RESULT_AUTO_CLOSE_DELAY = 5

DELETE_GAME(g_Game)
g_Game = CREATE_GAME()


function RestartTutorial(game)
	
	print('RestartTutorial\n')
	if g_subMission~=nil and g_subMission.Retry~=nil then
		g_subMission:Retry(game)
	end

	mgr:SendEventToServer( EVENT_SCRIPT, CS_EVENT_MISSION_RETRY )

	NEXT_STATE( game, "PLAY" )
	game.active = true

end

function NextTutorial(game, nextMissionID, restartMission)
	mgr:SendEventToServer( EVENT_SCRIPT, CS_EVENT_MISSION_GO_NEXT, nextMissionID )

	if not restartMission then

		if g_subMission~=nil and g_subMission.Release~=nil then
			g_subMission:Release()
		end

		util:StartNextMission(nextMissionID)
	end

	game.active = true
end

function CreateGameState()
	local stateList = 
	{	
		INIT = 
		{	
			enter = function (state, game) 
			
				util:ReleaseIncidentHandles()
				util:InputBlock(true)
				
				if g_subMission~=nil and g_subMission.Init~=nil then
					g_subMission:Init(game)
				end

				NEXT_STATE( game, "PLAY" )				
				
				state.procDelay = 0.1
			end,
		},
		
		PLAY =
		{
			enter = function (state, game) 
				
				util:InputBlock(true)
				util:StopTimeRecord()

				if not state.isInit then
				else

					if USE_MAP_START_POS then
						-- 맵 자체의 시작 위치 -> 고스트 시작용
						util:SetMyStartPos()
					else
						-- 맵의 특정 위치에 지정된 스타트 노드
						local startMat = mgr:GetNodePos(riderStartPosName)
						util:SetMyPos( startMat.pos, startMat.at )				
					end
				
					util:RestartGame()
				end
				
				local pos = util:GetMyPos()

				util:ActivateGoalAsset(GOALIN_GATE, true)
				game.result = PLAYING
				state.procDelay = 0.1				
			
				state.prevPos = v3(pos.x, pos.y, pos.z)
				state.isInit = true
				
				game.startTime = game.curTime

				game.enableCheckGoalIn = false
				SET_TIMER(game, "ENABLE_CHECK_GOAL_IN", 1)				
			end,
			
			process = function (state, game)
				local pos = util:GetMyPos()
				state.prevPos = v3(pos.x, pos.y, pos.z)

                if g_subMission~=nil and g_subMission.CheckSuccess~=nil then
                    if g_subMission:CheckSuccess(game) and g_subMission.OnCheckSuccess ~=nil then
                        g_subMission.OnCheckSuccess()
                    end
                end

			end,
			
			leave = function (state, game) 
				CLEAR_TIMER(game, "TUTORIAL_TIME_OVER")
			end,
			
			event = function( state, game, event, strValue, intValue1, intValue2 )
				if event==EVENT_GAME_STEP then
					
					-- 타이머 시작!
					local gameStep = intValue1
					if gameStep==GameStep_Ready then
						if g_subMission~=nil and g_subMission.Ready~=nil then
							g_subMission:Ready(game)
						end
					elseif gameStep==GameStep_Racing then

						util:InputBlock(false)				

						if USING_TIMER then
							--util:ShowTimer(MISSION_TRY_TIME)
							util:StartTimeRecord(MISSION_TRY_TIME)
							SET_TIMER(game, "TUTORIAL_TIME_OVER", MISSION_TRY_TIME)
						end
										
						if g_subMission~=nil and g_subMission.StartPlay~=nil then
							--print('game step racing!\n')
							g_subMission:StartPlay(game)
						end
					end

				elseif event==EVENT_UI and strValue=="NextTutorial" then	

					NextTutorial(game, 0, false)

				elseif event==EVENT_UI and strValue=="RestartTutorial" then	

					RestartTutorial(game)

				elseif event==EVENT_PLAYER_ACTION then
					if g_subMission~=nil and g_subMission.CheckEventPlayerAction~=nil then
						g_subMission:CheckEventPlayerAction(game, strValue, intValue1, intValue2)

						--이벤트만으로 성공체크
						if g_subMission:CheckSuccess(game) then
							NEXT_STATE( game, "SUCCESS" )
						end
					end
				elseif event==EVENT_TIMER then
					if USING_TIMER and strValue=="TUTORIAL_TIME_OVER" then

						if util:GetMissionID()==PROLOGUE_MISSION_ID then
							-- 프롤로그는 무조건 성공으로 처리
							NEXT_STATE( game, "SUCCESS" )
						else
							game.result = FAIL_TIME
							NEXT_STATE( game, "FAIL_RETRY" )						
						end
					elseif strValue=="ENABLE_CHECK_GOAL_IN" then
						game.enableCheckGoalIn = true
					end
				elseif event==EVENT_GAME then
					if intValue1==MissionEventValue_GhostGoalIn then
						print('MissionEventValue_GhostGoalIn By EVENT_GAME\n')
						game.result = FAIL_TIME
						NEXT_STATE( game, "FAIL_RETRY" )
					end

				elseif event==EVENT_TRIGGER then
					if strValue=="goalin" and game.enableCheckGoalIn then
						print('check goalin['..GOALIN_GATE..'] : '..intValue1..', oid = '..intValue2..'\n')

						local isMyGoalIn = (util:GetMyOID()==intValue2)

						if intValue1==GOALIN_GATE and g_subMission~=nil and g_subMission.CheckSuccess~=nil then

							if isMyGoalIn then
						
								-- 골인을 이벤트로 변환해서 처리
								if g_subMission~=nil and g_subMission.CheckEventPlayerAction~=nil then
									g_subMission:CheckEventPlayerAction(game, "GOALIN", 0, 0)								
								end

								if g_subMission:CheckSuccess(game) then
									NEXT_STATE( game, "SUCCESS" )
								else
									NEXT_STATE( game, "FAIL_RETRY" )
								end
							else
								-- ghost 골인
								print('MissionEventValue_GhostGoalIn by EventBox\n')
								game.result = FAIL_TIME
								NEXT_STATE( game, "FAIL_RETRY" )
							end
						end
					end
				end
			end
		},
		
		SUCCESS =
		{
			enter = function (state, game)
				
				util:InputBlock(true)
				util:StopTimeRecord()
				util:ShowGameExitForm(1, RESULT_AUTO_CLOSE_DELAY)

				print('Success MissionID = '..util:GetMissionID()..'\n')

				local lapTime = util:GetTimeRecord()
				mgr:SendEventToServer( EVENT_RECORD, MISSIONRECORD_MINTIME, lapTime )
				mgr:SendEventToServer( EVENT_SCRIPT, CS_EVENT_MISSION_RESULT, lapTime )
				game.active = false
			end,
			
			event = function( state, game, event, strValue, intValue1, intValue2 )
				if event==EVENT_UI_CLOSE then
					if strValue=="MissionSelect" then						

						local missionID = intValue1
						local needRestart = (intValue2>0 and true or false)

						util:InputBlock(false)		

						NextTutorial(game, missionID, needRestart)
					end

				elseif event==EVENT_UI and strValue=="NextTutorial" then	

					util:InputBlock(false)
					NextTutorial(game, 0, false)

				elseif event==EVENT_UI and strValue=="RestartTutorial" then	

					RestartTutorial(game)

				end
			end,
		},		
		
		FAIL_RETRY =
		{
			enter = function (state, game)
				util:InputBlock(true)
				util:StopTimeRecord()
				util:ShowGameExitForm(2, RESULT_AUTO_CLOSE_DELAY)

				game.active = false				
			end,
			
			event = function( state, game, event, strValue, intValue1, intValue2 )
				if event==EVENT_UI_CLOSE then
					if strValue=="MissionSelect" then						
						local missionID = intValue1
						local needRestart = (intValue2>0 and true or false)
						util:InputBlock(false)		

						NextTutorial(game, missionID, needRestart)
					end

				elseif event==EVENT_UI and strValue=="NextTutorial" then	
					util:InputBlock(false)
					NextTutorial(game, 0, false)
				elseif event==EVENT_UI and strValue=="RestartTutorial" then	
					RestartTutorial(game)
				end
			end,
			leave = function(stage, game)
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

function OnRelease()
	if g_subMission~=nil and g_subMission.Release~=nil then
		g_subMission:Release()
	end
end
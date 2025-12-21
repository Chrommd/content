
function EVAL_FUNCTION( funcValues )
	if funcValues then
		if type(funcValues[1])=="table" then
			local lastRet
			for i,subValues in pairs(funcValues) do
				lastRet = EVAL_FUNCTION( subValues )
			end
			return lastRet
		else
			local func	= funcValues[1]
			
			if func then
				-- 일단 parameter는 6개 까지만
				local value1	= EVAL( funcValues[2] )
				local value2	= EVAL( funcValues[3] )
				local value3	= EVAL( funcValues[4] )
				local value4	= EVAL( funcValues[5] )
				local value5	= EVAL( funcValues[6] )
				local value6	= EVAL( funcValues[7] )
				
				return func(value1, value2, value3, value4, value5, value6)	
			else
				alert('[Error] EVAL_FUNCTION is nil\n')
				for k,v in pairs(funcValues) do
					if v then
						alert('['..k..'] = '..v..'\n')
					end
				end
			end
		end
	end
	
	return nil
end

function CREATE_EVENT_SCENE( sceneName, sceneInfo )
	
	if not sceneInfo.action then
		alert('[Error] No Scene Action: '..sceneName..'\n')
	end
	
	local scene = 
	{
		enter = function (state, game)
			state.actionIndex	= 1
			state.actionList	= sceneInfo.action
			state.processList	= sceneInfo.process
			state.eventList		= sceneInfo.event
			state.processTime	= game.curTime
		end,
		
		process = function (state, game)
		
			--
			-- 순차 액션 처리
			--
			if state.actionList then
				while state.actionIndex < table.getn(state.actionList) do
					
					-- {GameTime, 0}, {CreateNPC, "stato", "PlayerPos"},
					local cond		= state.actionList[state.actionIndex]
					local action	= state.actionList[state.actionIndex+1]
						
					if not cond or table.getn(cond)==0 or EVAL_FUNCTION( cond ) then
						EVAL_FUNCTION( action )
						state.actionIndex = state.actionIndex + 2
						state.processTime = game.curTime
					else
						break
					end				
				end
			end
			
			--
			-- 항상 체크하는 process처리
			--
			if state.processList then
				for i=1, table.getn(state.processList), 2 do
					local cond		= state.processList[i]
					local action	= state.processList[i+1]
					
					if not cond or table.getn(cond)==0 or EVAL_FUNCTION( cond ) then
						EVAL_FUNCTION( action )
					end
				end
			end
		end,
		
		event = function( state, game, event, strValue, intValue1, intValue2 )
			-- {Event, EVENT_CAMERA_STOP}, { CameraPlayer },
			
			--print('[Event] '..event..', '..(strValue or 'nil')..', '..(intValue1 or 'nil')..', '..(intValue2 or nil)..'\n')
						
			if state.eventList then
				for i=1, table.getn(state.eventList), 2 do
					local cond		= state.eventList[i]
					local action	= state.eventList[i+1]
					
					if cond then
						local checkEvent = EVAL_FUNCTION( cond )
						
						--for k,v in pairs(checkEvent) do
						--	if v then
						--		print('['..k..'] = '..v..'\n')
						--	end
						--end
						
						if checkEvent and checkEvent[1]==event then
							if not checkEvent[2] or string.len(checkEvent[2])==0 or checkEvent[2]==strValue then
								if checkEvent[3]=="->" then
									if type(action)=="table" then
										local func	= action[1]
										func(intValue1, intValue2)	
										return
									end
									
								elseif not checkEvent[3] or checkEvent[3]==intValue1 then
									if not checkEvent[4] or checkEvent[4]==intValue2 then
										EVAL_FUNCTION( action )
										return
									end
								end
							end
						end
					end
				end
			end
		end,
	}
	
	return scene
end

function CREATE_EVENT_SCENARIO( scenarioInfo )
	
	local scenario = {}
	
	for sceneName, sceneInfo in pairs(scenarioInfo) do
		local scene = CREATE_EVENT_SCENE(sceneName, sceneInfo)
	
		scenario[sceneName] = scene	
	end
	
	return scenario
end

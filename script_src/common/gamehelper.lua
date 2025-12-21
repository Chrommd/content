if g_Games==nil then
	g_Games = {}
end

function __DEBUG(...)
	if ENABLE_DEBUG then
		print(...)
	end
end

function RANGE( min, value, max )
	local ret
	if value < min then
		ret = min
	elseif value > max then
		ret = max
	else
		ret = value
	end
	return ret
end


function SET_TIMER( game, timerName, sec )
	if sec ~= nil then
		local activeTime = game.curTime + sec
		game.timer[timerName] = activeTime
		--print('SET_TIMER('..timerName..') = '..game.curTime..'+'..sec..' = '..activeTime..'\n')		
	else
		print('SET_TIMER: sec is nil\n')
	end
end

function CLEAR_TIMER( game, timerName )
	game.timer[timerName] = -1
end

function UPDATE_TIMER(game)
	if game.timer ~= nil then
		local curTime = game.curTime
		for timerName, activeTime in pairs(game.timer) do
			if curTime >= activeTime and activeTime >= 0 then 
				--print('ON_TIMER('..timerName..') = '..activeTime..'\n')
				game.timer[timerName] = -1
				OnEvent( EVENT_TIMER, timerName )
			end
		end
		
		for timerName, activeTime in pairs(game.timer) do
			if activeTime < 0 then
				game.timer[timerName] = nil
			end
		end
	end
end

function UPDATE_DEAD_PLAYER(game)
	if game.deadPlayerList ~= nil then
	
		for i,id in pairs(game.deadPlayerList) do
			local player = mgr:GetPlayer(id)
			
			-- 죽은 상태가 끝났으면(상태 제거는 AcPlayerProxy에서 체크한다)
			if player ~= nil then
				if not player:HasStatus(PLAYERSTATUS_FAINT) then
					OnPlayerResurrect(player)
					game.deadPlayerList[i] = nil
				end
			else
				game.deadPlayerList[i] = nil
			end
		end
	end
end

function SET_GAME_STATE( game, stateName )

	--print( 'SET_GAME_STATE('..stateName..')\n' )
	
	-- leave
	if game.curState ~= nil then
		local curState = game.state[game.curState]
		if curState~=nil and curState.leave ~= nil then
			curState:leave( game )
		end
	end

	-- set newState
	game.curState = stateName
	local newState	= game.state[stateName]
	
	if newState~=nil then
		if newState.enter ~= nil then
			newState:enter( game )
		end
	end	
end

function PROCESS_GAME( game, deltaTime )

	game.curTime = mgr:GetUpdateTime()
	
	UPDATE_TIMER(game)
	
	if game.curTime >= game.activeTime then
			
		if game.active then			
		
			UPDATE_DEAD_PLAYER(game)

			-- change state?
			if game.nextState ~= nil then
				local curNextState = game.nextState
				SET_GAME_STATE( game, game.nextState )
				if curNextState == game.nextState then
					game.nextState = nil
				end
			end
			
			-- process curState
			if game.curState ~= nil and game.curTime >= game.activeTime then
				local curState = game.state[game.curState]
				if curState ~= nil then
					local process = curState.process
					
					if process ~= nil then
						curState:process( game )
					end	
					
					-- set process delay
					if curState.procDelay ~= nil then
						SET_DELAY( game, curState.procDelay )
					else
						-- default process delay
						SET_DELAY( game, 0.1 )
					end
				end
			end
		end
	end
end

function RANDOMSEED()
	math.randomseed(os.clock()*1000)
end

function RAND(min,max)
	return math.random(min,max)
end

function CREATE_GAME()
	game = {}
	game.curTime = 0
	game.state = {}
	game.npclist = {}
	game.timer = {}
	game.activeTime = 0
	game.active = true
	game.deadPlayerList = {}
	game.namelist = {}
	game.GetState = function (game) return game.state[game.curState] end
	game.FindState = function (game, state) return game.state[state] end
	
	table.insert(g_Games, game)
	
	return game
end

function DELETE_GAME(game)
	if game ~= nil then
		for k,v in pairs(g_Games) do
			if v==game then
				table.remove(g_Games, k)
				break
			end
		end
	end
end

function SubMission(eventList)
	local m =
	{
		Init = function (self, game)		
			for k,v in pairs(eventList) do
				if v.OnInit then v:OnInit(game) end
			end

			if self.OnInit then
				self:OnInit(game)
			end
		end,
	
		StartPlay = function (self, game)
			for k,v in pairs(eventList) do
				if v.OnInit then v:OnInit(game) end
				if v.OnStart then v:OnStart(game) end
			end		

			if self.OnStart then
				self:OnStart(game)
			end
		end,
	
		CheckEventPlayerAction = function (self, game, strValue, intValue1, intValue2)
			for k,v in pairs(eventList) do
				if v.OnEvent then
					v:OnEvent(game, strValue, intValue1, intValue2)
				end
			end
            if self.OnEvent then
                self:OnEvent(game, strValue, intValue1, intValue2)
            end
		end,

		CheckSuccess = function (self, game)		
	
			local allDone = true
			for k,v in pairs(eventList) do
				allDone = allDone and v:IsComplete(game)			
			end

			if allDone then
				return true
			end

			return false
		end,

		Ready = function (self, game)
			for k,v in pairs(eventList) do
				if v.OnReady then v:OnReady(game) end
			end

			if self.OnReady then
				self:OnReady(game)
			end
		end,


		Retry = function (self, game)
			for k,v in pairs(eventList) do
				if v.OnRetry then v:OnRetry(game) end
			end

			if self.OnRetry then
				self:OnRetry(game)
			end
		end,

		Release = function(self)
			for k,v in pairs(eventList) do
				if v.OnRelease then v:OnRelease(game) end
			end

			if self.OnRelease then
				self:OnRelease()
			end
		end,
	}

	return m
end


g_DefaultClientGameState =
{
	CreateWaitStartState = function ( nextStateName )
	
		local state =
		{
			enter = function (state, game) 				
				mgr:SendEventToServer( EVENT_WAIT, CS_EVENT_LOAD_COMPLETE )
				
				state.procDelay = 0.1
			end,			
			
			event = function( state, game, event, strValue, intValue1, intValue2 )
				if event==EVENT_SCRIPT then
					if strValue=="server" and intValue1==SC_EVENT_MISSION_START then						
						NEXT_STATE( game, nextStateName )
					end
				end
			end,
		}
		
		return state
	end,
}

g_DefaultServerGameState =
{
	CreateWaitLoadingState = function ( nextStateName )

		local state =
		{
			event = function( state, game, event, strValue, intValue1, intValue2 )
			
				if event==EVENT_WAIT then
					if strValue=="client" and intValue1==CS_EVENT_LOAD_COMPLETE then						
						NEXT_STATE( game, nextStateName )
					end
				end
			end,
		}
		
		return state
	end,
}
require('AIState')
require('AIHelper')
require('AIDefault')
require('MissionTypes')
require('GameHelper')
require('UITypes')
require('EffectTypes')
require('NetTypes')

function GetGameTime()
	return EVAL("$GameTime")
end

function GameTime(time)
	return EVAL("$GameTime") >= time
end

function ElapseTime(time)
	return EVAL("$ElapsedTime") >= time
end

function IsPatrolEnd(npcName)

	local objID
	if type(npcName)=="number" then
		objID = npcName
	else
		objID = EVAL("$GetNPC", npcName)
	end
	
	if objID then
		if objID==util:GetMyOID() then
			-- my player
			return util:IsPatrolEnd()
		else
			-- mob
			local npc = mgr:GetMob(objID)
			if npc then
				local info = GET_MOB_INFO(npc)
				if info then	
					if info.curState == STATE_PATROL and info.patrol_path==nil then
						return true
					end
				end
			end
		end
	end
	
	return false
end

function Event(event, strValue, value1, value2)

	-- event param converting 
	if event==EVENT_PATROL_END then
		if type(value1)=="string" then
			value1 = EVAL("$GetNPC", value1)
		end
	end


	return { event, strValue, value1, value2 }
end

function ResetPos( npcName, pos, dir )
	local objID 
	if type(npcName)=="number" then
		objID = npcName
	else
		objID = EVAL("$GetNPC", npcName)
	end
	
	if objID then
		if objID==util:GetMyOID() then
			-- my character!
			util:SetMyPos( pos, dir )
		else
			-- mob
			local npc = mgr:GetMob(objID)
			if npc then
				npc:ResetPos( pos.x, pos.y, pos.z )
				npc:LookAt( dir )
			end
		end
	end
end

function GetMobInfo( npcName )
	local objID 
	if type(npcName)=="number" then
		objID = npcName
	else
		objID = EVAL("$GetNPC", npcName)
	end
	
	if objID then
		local npc = mgr:GetMob(objID)
		if npc then
			local info = GET_MOB_INFO(npc)
			return info
		end
	end
end

function GetMobByName( npcName )
	local objID 
	if type(npcName)=="number" then
		objID = npcName
	else
		objID = EVAL("$GetNPC", npcName)
	end
	
	if objID then
		return mgr:GetMob(objID)
	end

	return nil
end

function CreateNPC( npcName, mobName, aiName, _initPos, oid )
	
	local initPos = _initPos
	local lookPos
	if type(initPos)=="string" then
		local mat = util:GetNodePos(_initPos)
		initPos = mat.pos
		lookPos = GetFrontPos(initPos, mat.at, 10)		
	end

	__DEBUG('CreateNPC('..npcName..', {'..initPos.x..','..initPos.y..','..initPos.z..'} )\n')
	local npc = mgr:CreateMob( mobName, aiName, initPos, MONSTER_TYPE_FRIENDLY, oid )
	
	local game = EVAL("$Game")
	if game and type(game.namelist)=="table" then
		game.namelist[npcName] = npc:GetObjID()
		
		if lookPos then
			npc:LookAt(lookPos)
		end
	end
end

function CreateJapanNPC( npcName, mobName, aiName, _initPos, oid )
	if util:IsJapan() then
		CreateNPC( npcName, mobName, aiName, _initPos, oid )
	end
end

function Patrol( npcName, _nodeList )
	__DEBUG('nodeList type = '..type(_nodeList)..'\n')
	
	local nodeList
	if type(_nodeList)=="string" then
		nodeList = util:GetNodeList(_nodeList)
	elseif type(_nodeList)=="table" then 
		nodeList = _nodeList
	else
		__DEBUG('[Error] unknown Patrol nodeList\n')
		return
	end
	
	__DEBUG('Patrol('..npcName..' --> #node='..table.getn(nodeList)..')\n')	
	
	if type(npcName)=="number" and npcName==util:GetMyOID() then
		util:MovePatrol(nodeList, table.getn(nodeList))
	else
		local info = EVAL("$GetNPCInfo", npcName)
		if info then
			info.reset_patrol = true
			info.patrol_path = nodeList
			NEXT_STATE( info, STATE_PATROL )
		end
	end
end

function Follow(npcName, targetID)
	__DEBUG('Follow('..npcName..' --> targetID='..targetID..')\n')
	local info = EVAL("$GetNPCInfo", npcName)
	if info then
		NEXT_STATE( info, STATE_FOLLOW )
	end
end

function IncidentSelf(inci)
	util:IncidentSelf(inci)
end

function NPCState(npcName, state)
	__DEBUG('NPCState('..npcName..' --> state='..state..')\n')
	local info = EVAL("$GetNPCInfo", npcName)
	if info then
		NEXT_STATE( info, state )
	end
end			
			
function PlayMotion(npcName, motionID)
	__DEBUG('PlayMotion('..npcName..' --> motionID='..motionID..')\n')
	local objID = EVAL("$GetNPC", npcName)
	if objID then
		local npc = mgr:GetMob(objID)
		if npc then
			local info = GET_MOB_INFO(npc)
			if info and info.state and info.state.motion and info.state.motion[motionID] then
				PLAY_MOTION( info, npc, motionID )
			else
				alert('[Error] PlayMotion('..npcName..' : wrong motionID='..motionID..')\n')
			end
		end
	end
end

function HorseAction(playerID, actionState)
	if type(playerID)=="number" then
		util:HorseAction(playerID, actionState)
	else
		alert('[Error] wrong playerID='..(playerID or 'nil'))
	end
end

function UseSkillPos(npcName, skillName, _targetPos)
	__DEBUG('UseSkill('..npcName..' --> skillName='..skillName..')\n')
	local objID = EVAL("$GetNPC", npcName)
	if objID then
		local npc = mgr:GetMob(objID)
		if npc then
			local info = GET_MOB_INFO(npc)
			if info then
			
				local targetPos
				if type(_targetPos)=="string" then
					local mat = util:GetNodePos(_targetPos)
					targetPos = mat.pos
				else
					targetPos = _targetPos
				end
				USE_SKILL_POS(info, npc, skillName, targetPos)
			end
		end
	end
end

-- IntroEnd, BalloonComplete
function SendAchvComplete(eventStr, propValue)
	if type(propValue)~="string" then
		util:SendAchvComplete(eventStr, tostring(propValue))
	else
		util:SendAchvComplete(eventStr, propValue)
	end
end

function PlayBGMEvent(strEvent)
	util:PlayBGMEvent(strEvent)
end

function FadeIn(time)
	util:FadeIn(time)
end

function FadeOut(time)
	util:FadeOut(time)
end

function ShowManual(show, manualID, buttonName)
	util:ShowManualForm(show, manualID, buttonName)
end

function StartSlowMode(speedRatio)
	util:StartSlowMode(speedRatio)
end

function EndSlowMode(speedRatio)
	util:EndSlowMode()
end

function InputBlock(block)
	util:InputBlock(block)
end

function FinishIntro()
	util:FinishIntro()
end

function SetForceDisplay(playerID, enable)
	if type(playerID)=="number" then
		util:SetDisplayType(playerID, enable)
	end
end

function StartTimer(timerName, startTime)
	local game = EVAL("$Game")
	if game then
		SET_TIMER(game, timerName, startTime)
	end
end

function CameraMacro(npcName, macroName)
	
	local objID 
	if type(npcName)=="number" then
		objID = npcName
	else
		objID = EVAL("$GetNPC", npcName)
	end
	
	if objID then
		util:SetCameraMacro(objID, macroName)
	end
end

function CameraPlayer()
	__DEBUG('CameraPlayer\n')
	util:SetCameraPlayer()
end

function NextScene( sceneName )
	__DEBUG('NextScene('..sceneName..')\n')
	
	local game = EVAL("$Game")
	if game and game.state then
		if game.state[sceneName] then
			SET_GAME_STATE( game, sceneName )
		else
			alert('[Error] Not Exist NextScene('..sceneName..')\n')	
		end
	end
end



function CreateUI(uiConfig)
	for frameName, frameInfos in pairs(UIConfig) do
		local frameInfo = frameInfos[1]
		
		util:UICreateFrame(frameName, frameInfo[1], frameInfo[2], frameInfo[3])
		
		for uiName, uiInfo in pairs(frameInfos) do
			if uiName ~= 1 then
				local uiType	= uiInfo[1]
				local v1		= uiInfo[2]
				local v2		= uiInfo[3]
				local v3		= uiInfo[4]
				local v4		= uiInfo[5]
				
				if uiType==UI_OVERLAY then
					util:UICreateOverlay(frameName, uiName, v1, v2)
				elseif uiType==UI_FONT then
					util:UICreateImageFont(frameName, uiName, v1, v2, v3)
				elseif uiType==UI_TEXT then
					util:UICreateText(frameName, uiName, v1, v2, v3, v4)
				end
			end
		end
	end
end

function UISetText(frameName, uiName, text)
	util:UIEvent(frameName, uiName, "SetText", text)
end

function UIHide(frameName, uiName, fadeTime)
	util:UIHide(frameName, uiName, fadeTime)
end				
				
function UIHideFrame(frameName, fadeTime)
	util:UIFrameEvent(frameName, "Hide", fadeTime)
end

function UIShowFrame(frameName, fadeTime)
	util:UIFrameEvent(frameName, "Show", fadeTime)
end

function RFCreateWnd(uiName, formName, x, y)
	util:RFCreateWnd(uiName, formName, x, y, 0)
end

function RFCreateForm(uiName, formName, x, y, isModal)
	util:RFCreateForm(uiName, formName, x, y, isModal)
end

function RFButtonClicked(uiName, buttonName, rfevent, v1, v2)
	util:RFOnButtonClicked(uiName, buttonName, rfevent, v1, v2)
end

function RFKeyDown(uiName, vkKey, rfevent, v1, v2)
	util:RFOnKeyDown(uiName, vkKey, rfevent, v1, v2)
end

function RFSetPos(uiName, x, y)
	util:RFSetPos(uiName, x, y)
end

function RFSetLabel(uiName, labelName, text)
	util:RFSetLabel(uiName, labelName, text)
end

function RFAddTextArea(uiName, textAreaName, text)
	util:RFAddTextArea(uiName, textAreaName, text)
end

function RFClearTextArea(uiName, textAreaName)
	util:RFClearTextArea(uiName, textAreaName)
end

function RFAddTextAreaString(uiName, textAreaName, keyName)
	util:RFAddTextArea(uiName, textAreaName, util:GetRaceString(keyName))
end

function RFAnimation(uiName, aniName)
	util:RFPlayAnimation(uiName, aniName)
end

function RFClose(uiName)
	util:RFClose(uiName)
end

function ShowNavigationBar(show)
	util:ShowNavigationBar(show)
end

function CreateValueEvaluator(game)
	local evaluators =
	{
		["$Game"]			= function () return game end,
		["$GetNPC"]			= function (npcName) if game.namelist then return game.namelist[npcName] end end,
		["$GetNPCInfo"]		= function (npcName) 
									local objID = EVAL("$GetNPC", npcName)
									if objID then
										local npc = mgr:GetMob(objID)
										if npc then
											local info = GET_MOB_INFO(npc)
											return info
										end
									end
								end,
		["$GameTime"]		= function () return game.curTime end,
		["$ElapsedTime"]	= function () 
									if game.state and game.curState then 
										local curState = game.state[game.curState]
										if curState.processTime	then
											return game.curTime - curState.processTime
										end
									end
									return 0
								end,
		["$Player"]			= function () return util:GetMyOID() end,
		["$PlayerPos"]		= function () return util:GetMyPos() end,
	}
	return evaluators
end

function EVAL(valueName, ...)
	if g_ValueEvaluator and valueName~=nil then
		local evaluator = g_ValueEvaluator[valueName]
		if evaluator then
			return evaluator(...)
		end
	end
	
	return valueName
end

--g_ValueEvaluator = CreateValueEvaluator(g_Opening)


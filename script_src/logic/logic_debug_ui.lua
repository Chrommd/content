require('logichelper')
require('uitypes')
require('rfhelper')

------------------------------------------------------------------------------------------------------------------------
-- TestUI
------------------------------------------------------------------------------------------------------------------------
TestUI =
{
	-- 
	Create = function ()
		
		local form = RFHelper.CreateForm("TestUI", 100, 200, 600, 500)		-- name, x, y, width, height
		
		form:CreateListBox("List1", 30, 100, { 1, 2, 34,5,6,7,8,9,11,12,13,14,65,88,23432,45,234,23,32 } )		
		form:CreateLabel("Label1", 50, 20, "LabelTest:")					-- name, x, y, text
		form:CreateComboBox("Combo1", 20, 60, {"Item1", "Item2", "Item3", "Item4", "Item5", "Item6"})
		form:CreateComboBox("Combo2", 270, 60, {"1234", "6789"})			-- name, x, y, itemList
		form:CreateButton("Button1", 450, 350, "버튼1", 1,2)					-- name, x, y, text, value1, value2
		form:CreateButton("Button2", 450, 400, "버튼2", 5,6)		
		
	end,

	Close = function ()		
		RFHelper.CloseForm("TestUI")
	end,	
}

Button1 = 
{
	OnEvent = function (v1, v2)
		print('Button1 event = '..v1..', '..v2..'\n')
	end,
}

Button2 = 
{
	OnEvent = function (v1, v2)
		print('Button2 event = '..v1..', '..v2..'\n')
	end,
}

Combo1 = 
{
	OnEvent = function (index, text)
		print('Combo1 event = '..index..', '..text..'\n')
	end,
}

Combo2 = 
{
	OnEvent = function (index, text)
		print('Combo2 event = '..index..', '..text..'\n')
	end,
}

List1 =
{
	OnDraw = function (id, x, y, alpha, selected)		
		local color = (selected and 0xFF0000FF or 0xFFFF0000)
		util:RFPrintText(x, y, 'Item ['..id..']', color, 0xFF000000)
	end,

	OnSelect = function (id)
		print('List1 Select Item = '..id..'\n')
	end,

	OnUnselect = function (id)
		print('List1 Unselect Item = '..id..'\n')
	end,
}

------------------------------------------------------------------------------------------------------------------------
-- SelectGhost
------------------------------------------------------------------------------------------------------------------------
g_GhostPlayerList = {}
g_GhostPlayerListCount = 0
SelectGhostUI =
{
	-- 
	Create = function ()
		
		local form = RFHelper.CreateForm("SelectGhostUI", 600, 200, 300, 350)		-- name, x, y, width, height
		
		form:CreateLabel("Label1", 100, 20, "GhostPlayer를")					-- name, x, y, text
		form:CreateLabel("Label2", 100, 50, "선택하세요.")					-- name, x, y, text
		form:CreateComboBox("ComboGhostPlayer", 30, 90, {})

		SelectGhostUI.Reset()
	end,

	Reset = function ()
		RFHelper.RFClearComboBox("ComboGhostPlayer")
		RFHelper.RFAddComboBoxText("ComboGhostPlayer", '나의 고스트')

		g_GhostPlayerList = {}
		g_GhostPlayerList[0] = util:GetMyUID()	-- 자기 자신 기본으로 추가
		g_GhostPlayerListCount = 1
	end,

	AddGhostPlayer = function(uid, nickname, record)
		local sec = math.floor(record * 0.001)
		local text = nickname..' : '..sec..' sec.'
		RFHelper.RFAddComboBoxText("ComboGhostPlayer", text)
		
		print('AddGhostPlayer['..g_GhostPlayerListCount..'] = '..uid..'\n')
		g_GhostPlayerList[g_GhostPlayerListCount] = uid
		g_GhostPlayerListCount = g_GhostPlayerListCount + 1		
	end,

	Close = function ()		
		RFHelper.CloseForm("SelectGhostUI")
	end,	
}

ComboGhostPlayer =
{
	OnEvent = function (index, text)
		--print('ComboGhostPlayer event = '..index..', '..text..'\n')
		
		local uid = g_GhostPlayerList[index]
		--print('			uid = '..uid..'\n')

		util:SelectGhostPlayer(uid)
	end,
}


------------------------------------------------------------------------------------------------------------------------
-- SingleGameRoomUI
------------------------------------------------------------------------------------------------------------------------
SingleGameRoomUI =
{
-- 
	Create = function ()
		
		local form = RFHelper.CreateForm("SingleGameRoomUI", 600, 140, 200, 60)
		
		form:CreateLabel("SingleFeeText", 35, 20, "요금:")
		form:CreateLabel("SingleFeeValue", 85, 20, "")		
	end,

	SetFee = function (fee)
		RFHelper.RFSetLabel("SingleFeeValue", tostring(fee))
	end,

	Close = function ()
		RFHelper.CloseForm("SingleGameRoomUI")
	end,
}

------------------------------------------------------------------------------------------------------------------------
-- RanchHorseUI
------------------------------------------------------------------------------------------------------------------------
TendencyString =
{
	[MountTendency_None] = '없음',
	[MountTendency_Greedy] = '식탐',
	[MountTendency_Vigorous] = '활발',
	[MountTendency_Timid] = '소심',
	[MountTendency_Curiosity] = '호기심',
	[MountTendency_Kindness] = '박애',
	[MountTendency_Clean] = '청결',
}

GroupForceString =
{
	[MountGroupForce_Normal] = '없음',
	[MountGroupForce_Greed1] = '풀 다 먹을',
	[MountGroupForce_Greed2] = '쇠도 씹어먹을',
	[MountGroupForce_Play1] = '맹렬하게 놀',
	[MountGroupForce_Play2] = '밤새워 놀',
	[MountGroupForce_Haste] = '1위할',
	[MountGroupForce_Solo] = '혼자서도 잘 할',
	[MountGroupForce_Rest] = '잠입액션 찍을',
}

GroupActionString =
{
	[MountGroupAction_Normal] = '없음',
	[MountGroupAction_Greedy] = '먹자',
	[MountGroupAction_Busy] = '부산하다',
	[MountGroupAction_Indivisual] = '개인주의',
	[MountGroupAction_Excited] = '정신없는',
	[MountGroupAction_Gloomy] = '음침한',
	[MountGroupAction_Pairing] = '짝꿍',
	[MountGroupAction_Tired] = '나른한',
	[MountGroupAction_Parade] = '퍼레이드',
}

function GetTendencyString(tendency)
	return TendencyString[tendency]==nil and 'Unknown' or TendencyString[tendency]
end

function GetGroupForceString(groupForce)
	return GroupForceString[groupForce]==nil and 'Unknown' or GroupForceString[groupForce]
end

function GetGroupActionString(groupAction)
	return GroupActionString[groupAction]==nil and 'Unknown' or GroupActionString[groupAction]
end

g_RanchHorseList = {}
g_LastSelectRanchHorseIndex = -1

RanchHorseUI =
{
	-- 	
	Create = function ()

		local form = RFHelper.CreateForm("RanchHorseUI", 300, 100, 750, 400)		-- name, x, y, width, height
		
		form:CreateLabel("Label1", 100, 20, "방목말 정보")					-- name, x, y, text

		local horseCount = util:GetGrazeHorseCount()
		local mounts = {}
		for i=1,horseCount do
			table.insert(mounts, i)
		end

		form:CreateListBox("ListHorse", 30, 70, mounts )		

		form:CreateLabel("HorseListTitleNameTag", 50, 50, "<이름>")
		form:CreateLabel("HorseListTitleTendencyTag", 140, 50, "<기질>")
		form:CreateLabel("HorseListTitleGroupForceTag", 220, 50, "<집단기세>")
		form:CreateLabel("HorseListTitleGroupActionTag", 340, 50, "<집단행동>")

		form:CreateLabel("NameTag", 450, 50, "이름:")		
		form:CreateLabel("GroupActionTag", 450, 220, "집단행동:")

		form:CreateLabel("Name", 550, 50, "-")
		--form:CreateLabel("Tendency", 550, 70, "0")
		--form:CreateLabel("GroupForce", 550, 90, "0")
		--form:CreateLabel("GroupAction", 550, 110, "0")

		form:CreateButton("RanchHorseCheckForce", 490, 280, "기세 체크", 1, 2)
		form:CreateButton("RanchHorseUIClose", 490, 330, "Close", 1, 2)

		form:CreateLabel("TendencyTag", 450, 80, "기질:")		
		form:CreateLabel("GroupForceTag", 450, 150, "집단기세:")		

		form:CreateComboBox("RanchHorseGroupForceCombo", 450, 170, GroupForceString)
		form:CreateComboBox("RanchHorseTendencyCombo", 450, 100, TendencyString)

		g_LastSelectRanchHorseIndex = -1
	end,

	Close = function ()		
		RFHelper.CloseForm("RanchHorseUI")
	end,	
}

RanchHorseTendencyCombo = 
{
	OnEvent = function (index, text)
		print('RanchHorseTendencyCombo event = '..index..', '..text..'\n')

		local tendency = -1

		for k,v in pairs(TendencyString) do
			if text==v then
				tendency = k
				break
			end
		end

		if tendency >= 0 then
			local mountInfo = util:GetGrazeHorseInfo(g_LastSelectRanchHorseIndex)
			if mountInfo ~= nil then
				mountInfo.tendency = tendency
			end
		end
	end,
}

RanchHorseGroupForceCombo =
{
	OnEvent = function (index, text)
		print('RanchHorseGroupForceCombo event = '..index..', '..text..'\n')

		local groupForce = -1

		for k,v in pairs(GroupForceString) do
			if text==v then
				groupForce = k
				break
			end
		end

		if groupForce >= 0 then
			--local horseCount = util:GetGrazeHorseCount()
			--local mountInfo = util:GetGrazeHorseInfo(g_LastSelectRanchHorseIndex)

			--for index=1,horseCount do
				--local mountInfo = util:GetGrazeHorseInfo(index)
				--if mountInfo ~= nil then
					--mountInfo.groupForce = groupForce					
				--end
			--end

			util:RequestMountGroupForce(groupForce)
		end
	end,
}

RanchHorseCheckForce =
{
	OnEvent = function (v1, v2)
		local msg = '발동 가능한 기세: '
		for i=1,MountGroupForce_Max do
			if util:IsEnableMountGroupForce(i) then
				msg = msg..GetGroupForceString(i)..', '
			end
		end

		util:InsertNoticeMsg(msg)
	end,
}

RanchHorseUIClose =
{
	OnEvent = function (v1, v2)
		RanchHorseUI.Close()		
	end,
}

ListHorse =
{
	OnDraw = function (id, x, y, alpha, selected)		
		local color = (selected and 0xFF0000FF or 0xFF000000)
		local shadow = 0xFFFFFFFF

		-- 기질 기세 행동
		local mountInfo = util:GetGrazeHorseInfo(id-1)
		if mountInfo ~= nil then
			util:RFPrintText(x, y, '['..id..'] '..mountInfo:GetNickname(), color, shadow)
			util:RFPrintText(x+100, y, '['..mountInfo.tendency..'] '..GetTendencyString(mountInfo.tendency), color, shadow)
			util:RFPrintText(x+170, y, '['..mountInfo.groupForce..'] '..GetGroupForceString(mountInfo.groupForce), color, shadow)
			util:RFPrintText(x+300, y, '['..mountInfo:GetGroupAction()..'] '..GetGroupActionString(mountInfo:GetGroupAction()), color, shadow)							
		else
			util:RFPrintText(x, y, 'Item ['..id..']  <Unknown>', color, 0xFF000000)
		end
	end,

	OnSelect = function (id)
		local mountInfo = util:GetGrazeHorseInfo(id-1)
		if mountInfo ~= nil then
			RFHelper.RFSetLabel("Name", mountInfo:GetNickname())
			RFHelper.RFSetLabel("Tendency", GetTendencyString(mountInfo.tendency))
			RFHelper.RFSetLabel("GroupForce", GetGroupForceString(mountInfo.groupForce))
			RFHelper.RFSetLabel("GroupAction", GetGroupActionString(mountInfo:GetGroupAction()))

			g_LastSelectRanchHorseIndex = id-1

			--util:RFSetComboBoxSel("RanchHorseTendencyCombo", "combo", 0)
		end
	end,

	OnUnselect = function (id)		
	end,
}

------------------------------------------------------------------------------------------------------------------------
-- MyHorseUI
------------------------------------------------------------------------------------------------------------------------
MyHorseUI =
{
	-- 	
	Create = function ()
		
		local form = RFHelper.CreateForm("RanchHorseUI", 300, 100, 650, 400)		-- name, x, y, width, height
		
		form:CreateLabel("Label1", 100, 20, "방목말 정보")					-- name, x, y, text

		local horseCount = util:GetGrazeHorseCount()
		local mounts = {}
		for i=1,horseCount do
			table.insert(mounts, i)
		end

		form:CreateListBox("ListHorse", 30, 50, mounts )		

		form:CreateLabel("NameTag", 450, 50, "이름:")
		form:CreateLabel("TendencyTag", 450, 70, "기질:")
		form:CreateLabel("GroupForceTag", 450, 90, "집단기세:")
		form:CreateLabel("GroupActionTag", 450, 110, "집단행동:")

		form:CreateLabel("Name", 550, 50, "-")
		form:CreateLabel("Tendency", 550, 70, "0")
		form:CreateLabel("GroupForce", 550, 90, "0")
		form:CreateLabel("GroupAction", 550, 110, "0")

		form:CreateComboBox("RanchHorseTendencyCombo", 400, 150, TendencyString)

		form:CreateButton("RanchHorseCheckForce", 490, 280, "기세 체크", 1, 2)
		form:CreateButton("RanchHorseUIClose", 490, 330, "Close", 1, 2)

		g_LastSelectRanchHorseIndex = -1
	end,

	Close = function ()		
		RFHelper.CloseForm("RanchHorseUI")
	end,	
}

------------------------------------------------------------------------------------------------------------------------
-- VarSystemUI
------------------------------------------------------------------------------------------------------------------------
g_varLists = 
{
	'item_debugHotkey',
	'com_magic_self_missile',
	'com_magic_self_target',
}

VarSystemUI =
{
-- 
	Create = function ()
		
		local form = RFHelper.CreateForm("VarSystemUI", 300, 300, 450, 420)
		
		local keys = {}
		for i=1,table.getn(g_varLists) do
			table.insert(keys, i)
		end

		form:CreateLabel("VarSystemLabel", 50, 25, "CVarSystemUI")
		form:CreateListBox("VarList", 20, 50, keys )
		form:CreateButton("VarSystemClose", 290, 360, "Close", 1, 2)
	end,

	Close = function ()
		RFHelper.CloseForm("VarSystemUI")
	end,
}

VarSystemClose = 
{
	OnEvent = function (v1, v2)
		VarSystemUI.Close()		
	end,
}

VarList =
{
	OnDraw = function (id, x, y, alpha, selected)		
		local color = (selected and 0xFF0000FF or 0xFFFF0000)

		local var = g_varLists[id]
		if var ~= nil then
			local isBool = util:IsVarBool(var)
			local valueStr
			
			if isBool then
				valueStr = util:GetVarInteger(var)>0 and 'True' or 'False'
			else
				valueStr = util:GetVarInteger(var)
			end

			util:RFPrintText(x, y, var..'  =  '..valueStr, color, 0xFF000000)
		end
	end,

	OnSelect = function (id)
		local var = g_varLists[id]
		if var ~= nil then
			local isBool = util:IsVarBool(var)
			if isBool then
				if util:GetVarInteger(var)>0 then					
					util:SetVarBool(var, false)
				else
					util:SetVarBool(var, true)
				end
			end
		end
	end,

	OnUnselect = function (id)		
	end,
}


------------------------------------------------------------------------------------------------------------------------
-- ServerCommandUI
------------------------------------------------------------------------------------------------------------------------
ServerCommandUI =
{
	-- 
	Create = function ()
		
		local form = RFHelper.CreateForm("ServerCommandUI", 500, 300, 350, 400)		-- name, x, y, width, height
		
		form:CreateLabel("ServerCmdLabel1", 50, 20, "ServerCommandUI")					-- name, x, y, text
		form:CreateButton("ServerCmdButton_GuildMode", 30, 50, "길드모드", 0,0)					-- name, x, y, text, value1, value2
		form:CreateButton("ServerCmdButton_ForceStart", 30, 100, "강제시작", 0,0)		
		form:CreateButton("ServerCmdButton_InjuryUI", 30, 200, "부상 테스트", 0,0)
		form:CreateButton("ServerCmdButton_AISetting", 30, 250, "AI설정", 0,0)
		form:CreateButton("ServerCmdButton_SkillSystem", 195, 200, "스킬 설정", 0,0)
		form:CreateButton("ServerCmdButton_RanchHorseUI", 195, 250, "방목말 설정", 0,0)
		form:CreateButton("ServerCmdButton_Close", 100, 340, "OK", 5,6)		
	end,

	Close = function ()		
		RFHelper.CloseForm("ServerCommandUI")
	end,	
}

ServerCmdButton_GuildMode = 
{
	OnEvent = function (v1, v2)
		util:ServerChatCommand("*cmd guildMode")
	end,
}

ServerCmdButton_ForceStart = 
{
	OnEvent = function (v1, v2)
		util:ServerChatCommand("*cmd start")
		ServerCommandUI.Close()
	end,
}

ServerCmdButton_InjuryUI = 
{
	OnEvent = function (v1, v2)

		InjuryTestUI.Close()
		InjuryStatusUI.Close()

		InjuryTestUI.Create()
		InjuryStatusUI.Create()
	end,
}

ServerCmdButton_AISetting =
{
	OnEvent = function (v1, v2)
		AISettingUI.Close()
		AISettingUI.Create()
	end,
}

ServerCmdButton_SkillSystem =
{
	OnEvent = function (v1, v2)
		SkillSystemTestUI.Close()
		SkillSystemTestUI.Create()
	end,
}

ServerCmdButton_RanchHorseUI =
{
	OnEvent = function (v1, v2)
		RanchHorseUI.Close()
		RanchHorseUI.Create()
	end,
}

ServerCmdButton_Close = 
{
	OnEvent = function (v1, v2)
		ServerCommandUI.Close()
	end,
}

------------------------------------------------------------------------------------------------------------------------
-- InjuryTestUI
------------------------------------------------------------------------------------------------------------------------
g_MountInjuryString = 
{
	[MountInjury_None]					= "부상없음",
	[MountInjury_LightAnkleFracture]	= "경상: 근육",
	[MountInjury_LightKneeFracture]		= "경상: 상처",
	[MountInjury_LightPaceDown]			= "경상: 골절",
	[MountInjury_HeavyAnkleFracture]	= "중상: 근육",
	[MountInjury_HeavyKneeFracture]		= "중상: 상처",
	[MountInjury_HeavyPaceDown]			= "중상: 골절",
}

InjuryTestUI =
{
	-- 
	Create = function ()
		
		local form = RFHelper.CreateForm("InjuryTestUI", 500, 300, 320, 300)		-- name, x, y, width, height
		
		form:CreateLabel("InjuryLabel1", 50, 20, "< 부상 테스트 >")					-- name, x, y, text
				
		form:CreateButton("InjuryTestButton_ForceCheck", 80, 140, "강제 부상체크", 1,2)					-- name, x, y, text, value1, value2
		form:CreateButton("InjuryTestButton_Cure", 80, 180, "즉시 치료하기", 1,2)					-- name, x, y, text, value1, value2
		
		form:CreateButton("InjuryTestButton_Close", 170, 240, "OK", 5,6)		

		form:CreateLabel("InjuryLabel2", 50, 50, "부상 변경")					-- name, x, y, text
		
		local injuryList = {}
			
		local mountInfo = util:GetMountInfo( util:GetMyUID() )
		local index = 0
		local selectIndex = -1
		if mountInfo ~= nil then
			for injury,v in pairs(g_MountInjuryString) do
				table.insert( injuryList, v )
				
				if injury == mountInfo.injury then
					selectIndex = index
				end				

				index = index + 1
			end
		end

		form:CreateComboBox("InjuryTestCombo_SetInjury", 50, 80, injuryList)

		if selectIndex >= 0 then
			util:RFSetComboBoxSel("InjuryTestCombo_SetInjury", "combo", selectIndex)
		end	

	end,

	Close = function ()		
		RFHelper.CloseForm("InjuryTestUI")
	end,	
}

InjuryTestButton_ForceCheck = 
{
	OnEvent = function (v1, v2)
		util:ServerChatCommand("*cmd injury check")		
	end,
}

InjuryTestButton_Cure =
{
	OnEvent = function (v1, v2)
		util:SendInjuryHeal()
	end,
}

InjuryTestCombo_SetInjury = 
{
	OnEvent = function (index, text)
		
		for injury,v in pairs(g_MountInjuryString) do
			if text==v then
				
				-- client test only
				local mountInfo = util:GetMountInfo( util:GetMyUID() )
				if mountInfo ~= nil then
					mountInfo.injury = injury
					print('SetInjury = ['..injury..'] '..index..', '..text..'\n')
					
					local cmdStr = '*cmd injury type'

					if IsBitSet(injury, MountInjuryFlag_Light) then cmdStr = cmdStr..' light'
					elseif IsBitSet(injury, MountInjuryFlag_Heavy) then cmdStr = cmdStr..' heavy'
					end
					
					if IsBitSet(injury, MountInjuryFlag_AnkleFracture) then cmdStr = cmdStr..' ankle'
					elseif IsBitSet(injury, MountInjuryFlag_KneeFracture) then cmdStr = cmdStr..' knee'
					elseif IsBitSet(injury, MountInjuryFlag_PaceDown) then cmdStr = cmdStr..' pace'
					end

					util:ServerChatCommand(cmdStr)

					print('Send to Server: '..cmdStr..'\n')

				else
					print('No MountInfo\n')
				end
			end
		end
	end,
}

InjuryTestButton_Close = 
{
	OnEvent = function (v1, v2)
		InjuryTestUI.Close()
	end,
}

------------------------------------------------------------------------------------------------------------------------
-- InjuryStatusUI
------------------------------------------------------------------------------------------------------------------------
InjuryStatusUI =
{
	-- 
	Create = function ()
		
		local form = RFHelper.CreateForm("InjuryStatusUI", 800, 150, 220, 300)		-- name, x, y, width, height
		
		form:CreateLabel("InjuryStatusLabel1", 20, 20, "< 부상 상태 >")					-- name, x, y, text

		form:CreateLabel("InjuryStatus_Check", 50, 60, "부상체크  :"..(util:IsInjuryCheck() and "작동" or "안함"))
		form:CreateLabel("InjuryStatus_Max", 50, 80, "부상체크값:")
		form:CreateLabel("InjuryStatus_Current", 50, 100, "현재부상값:")
				
		form:CreateButton("InjuryStatusButton_MaxValue", 40, 140, "부상체크값= 1", 1,0)					-- name, x, y, text, value1, value2
		form:CreateButton("InjuryStatusButton_MaxValue", 40, 190, "부상체크값=10", 10,0)					-- name, x, y, text, value1, value2
		
		form:CreateButton("InjuryStatusButton_Close", 70, 240, "OK", 0,0)		

	end,

	SetInjuryStatusCheck = function (check)
		RFHelper.RFSetLabel("InjuryStatus_Check", "부상체크  :"..(check and "작동" or "안함"))
	end,

	SetInjuryStatusMax = function (maxValue)
		InjuryStatusUI.SetInjuryStatusCheck( util:IsInjuryCheck() )
		RFHelper.RFSetLabel("InjuryStatus_Max", "부상체크값: "..maxValue)
	end,

	SetInjuryStatusCurrent = function (curValue)
		InjuryStatusUI.SetInjuryStatusCheck( util:IsInjuryCheck() )
		RFHelper.RFSetLabel("InjuryStatus_Current", "현재부상값: "..curValue)
	end,
		
	Close = function ()		
		RFHelper.CloseForm("InjuryStatusUI")
	end,	
}

InjuryStatusButton_MaxValue = 
{
	OnEvent = function (v1, v2)
		util:ServerChatCommand("*cmd injury check "..v1)
	end,
}

InjuryStatusButton_Close = 
{
	OnEvent = function (v1, v2)
		InjuryStatusUI.Close()
	end,
}


------------------------------------------------------------------------------------------------------------------------
-- AISettingUI
------------------------------------------------------------------------------------------------------------------------
AISettingUI =
{
	-- 
	Create = function ()
		
		local form = RFHelper.CreateForm("AISettingUI", 700, 300, 250, 400)		-- name, x, y, width, height
		
		form:CreateLabel("AISettingUI_Label1", 50, 20, "AISettingUI")
		form:CreateButton("AISettingButton_AIPreset", 50, 50, "2등급 하수", 10)
		form:CreateButton("AISettingButton_AIPreset", 50, 100, "5등급 중수", 32)		
		form:CreateButton("AISettingButton_AIPreset", 50, 150, "8등급 초고수", 54)
		form:CreateButton("AISettingButton_AIPreset", 50, 250, "<기본 설정>", 0)
		form:CreateButton("AISettingButton_Close", 100, 340, "OK")
	end,

	Close = function ()		
		RFHelper.CloseForm("AISettingUI")
	end,	
}

AISettingButton_AIPreset = 
{
	OnEvent = function (v1, v2)
		util:InsertNoticeMsg("AI preset = "..v1)
		util:SetVarValue("var_ai_preset_type", tostring(v1))
	end,
}

AISettingButton_Close = 
{
	OnEvent = function (v1, v2)
		AISettingUI.Close()
	end,
}


------------------------------------------------------------------------------------------------------------------------
-- SkillSystemTestUI
------------------------------------------------------------------------------------------------------------------------
g_SkillSystemList = {}

g_SkillSystemSelect1 = 0
g_SkillSystemSelect2 = 0
g_SkillSystemSelect3 = 0

SkillSystemTestUI =
{
	-- 
	Create = function ()
		
		local form = RFHelper.CreateForm("SkillSystemTestUI", 300, 200, 350, 400)		-- name, x, y, width, height
		
		form:CreateLabel("SkillSystemLabel1", 50, 20, "< 스킬 설정 >")					-- name, x, y, text
		
		form:CreateLabel("SkillSystemLabel2", 35, 265, "고른 후에 Set버튼 클릭! -->")

		form:CreateButton("SkillSystemTestButton_Set", 190, 230, "스피드전", 1)
		form:CreateButton("SkillSystemTestButton_Set", 190, 270, "마법전", 2)
		form:CreateButton("SkillSystemTestButton_Close", 190, 330, "Close", 5,6)

		g_SkillSystemList = {}
		
		form:CreateComboBox("SkillSystemTestCombo3", 30, 150, g_SkillSystemList)		
		form:CreateComboBox("SkillSystemTestCombo2", 30, 100, g_SkillSystemList)
		form:CreateComboBox("SkillSystemTestCombo1", 30, 50, g_SkillSystemList)

		for i=0,SkillSystem_Max-1 do
			local comment 
			
			if i==0 then
				comment = '<알 수 없음>'
			else
				-- 스킬?
				comment = util:GetSkillSystemComment(i)
						
				-- 잠재력?	
				if comment == nil then
					comment = util:GetPotentialComment(i)
				end
			end

			if comment ~= nil then
				g_SkillSystemList[i] = '['..i..'] '..comment
				util:RFAddComboBoxText("SkillSystemTestCombo1", "combo", g_SkillSystemList[i])
				util:RFAddComboBoxText("SkillSystemTestCombo2", "combo", g_SkillSystemList[i])
				util:RFAddComboBoxText("SkillSystemTestCombo3", "combo", g_SkillSystemList[i])
			end
		end		

	end,

	Close = function ()		
		RFHelper.CloseForm("SkillSystemTestUI")
	end,	

	isSkillSetValue = false,

	IsSkillSet = function ()
		return SkillSystemTestUI.isSkillSetValue
	end,
}

SkillSystemTestCombo1 = 
{
	OnEvent = function (index, text)
		
		for ss,comment in pairs(g_SkillSystemList) do
			if text==comment then
				g_SkillSystemSelect1 = ss
				break
			end
		end
	end,
}

SkillSystemTestCombo2 = 
{
	OnEvent = function (index, text)
		
		for ss,comment in pairs(g_SkillSystemList) do			
			if text==comment then
				g_SkillSystemSelect2 = ss
				break
			end
		end
	end,
}

SkillSystemTestCombo3 = 
{
	OnEvent = function (index, text)
		
		for ss,comment in pairs(g_SkillSystemList) do			
			if text==comment then
				g_SkillSystemSelect3 = ss
				break
			end
		end
	end,
}

SkillSystemTestButton_Set = 
{
	OnEvent = function (mode, v2)
		-- preset 설정
		local cmdStr = '*cmd skillCard 0,'..mode..','..g_SkillSystemSelect1..','..g_SkillSystemSelect2..','..g_SkillSystemSelect3
		util:ServerChatCommand(cmdStr)
		print(cmdStr..'\n')

		-- preset 선택
		util:ServerChatCommand('*cmd skillCard 0,'..mode)

		SkillSystemTestUI.isSkillSetValue = true
	end,
}

SkillSystemTestButton_Close = 
{
	OnEvent = function (v1, v2)
		SkillSystemTestUI.Close()
	end,
}

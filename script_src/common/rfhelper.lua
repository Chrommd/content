require('uitypes')

--
-- DebugUI
--

g_RFFormList = {}

RFHelper = 
{
	CloseAllFormsExcept = function (exceptUI1)
		for _, formName in pairs(g_RFFormList) do
			print(exceptUI1, formName)
			if exceptUI1==nil or formName~=exceptUI1 then
				util:RFClose(formName)
			end
		end
		g_RFFormList = {}
		 
		if exceptUI1~=nil then table.insert(g_RFFormList, exceptUI1) end
	end,

	CreateForm = function (formName, x, y, width, height)
		
		local form = 
		{
			CreateLabel = function(self, labelName, x, y, text)
				util:RFCreateWnd(labelName, "template_label.xml", x, y, formName)	-- parent를 formName으로 설정
				util:RFSetLabel(labelName, "label", text)
			end,

			CreateComboBox = function(self, comboName, x, y, items)
				util:RFCreateWnd(comboName, "template_combobox.xml", x, y, formName)
				for _,item in pairs(items) do
					util:RFAddComboBoxText(comboName, "combo", item)
				end

				-- combo박스는 선택한 item에 대한 index, text가 넘어감
				util:RFOnSelChange(comboName, "combo", RFEVENT_SCRIPT)			
			end,

			CreateListBox = function(self, listboxName, x, y, items)
				util:RFCreateWnd(listboxName, "template_listbox.xml", x, y, formName)

				-- item값은 int로만 등록 가능
				for _,item in pairs(items) do
					util:RFAddListBoxItem(listboxName, "listbox", item)
				end

				util:RFOnDrawItem(listboxName, "listbox", RFEVENT_SCRIPT_DRAW)

				-- listbox박스는 선택한 item에 대한 item값이 int로 넘어감
				util:RFOnSelChange(listboxName, "listbox", RFEVENT_SCRIPT_LISTCHANGE)			
			end,

			CreateButton = function(self, buttonName, x, y, text, v1, v2)
				util:RFCreateWnd(buttonName, "template_button.xml", x, y, formName)
				util:RFSetLabel(buttonName, "label", text)

				-- button은 클릭하면 v1, v2가 넘어감
				util:RFOnButtonClicked(buttonName, "btn", RFEVENT_SCRIPT, v1, v2)
			end,

			Close = function(self)
				util:RFClose(formName)
			end,
		}

		form.formName = formName

		util:RFCreateForm(formName, "template_window.xml", x, y, false)
		util:RFSetSize(formName, width, height)

		table.insert(g_RFFormList, formName)

		return form
	end,

	RFAddComboBoxText = function(comboName, text)
		util:RFAddComboBoxText(comboName, "combo", text)
	end,

	RFClearComboBox = function(comboName)
		util:RFDeleteAllComboBoxItems(comboName, "combo")
	end,

	RFSetLabel = function(labelName, text)
		util:RFSetLabel(labelName, "label", text)
	end,

	CloseForm = function(formName)
		util:RFClose(formName)
	end,
}


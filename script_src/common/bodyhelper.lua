require('skilltypes')

if g_body == nil then
	g_body = {}
end

--function GET_STATE_BY_NAME( stateName )
	--local stateID	= g_States[stateName]
	--
	--return stateID
--end
--
function GET_BODY_FILE(name)
	if g_body[name] ~= nil then
		return g_body[name].file
	end
end

function GET_BODYSET(name)
	if g_body[name] ~= nil then
		return g_body[name].bodyset
	end
end

function GET_BODY_STATES_SIZE(name)
	if g_body[name] ~= nil then
		return table.getn(g_body[name].states)
	end
end

function GET_BODY_STATES_NAME(name, index)
	if g_body[name] ~= nil then
		local statename = g_body[name].states[index]
		if statename ~= nil then
			return statename
		end
	end
	return ''
end

--function GET_BODY_STATES_VALUE(name, index)
	--if g_body[name] ~= nil then
		--local statename = g_body[name].states[index]
		--if statename ~= nil then
			--local state = GET_STATE_BY_NAME(statename)
			--if state ~= nil then
				--return state
			--end
		--end
	--end
	--return 0
--end

function GET_BODY_TARGET_SIZE(name)
	if g_body[name] ~= nil and g_body[name].target ~= nil then
		return table.getn(g_body[name].target)
	end
	return 0
end

function GET_BODY_TARGET_NAME(name, index)
	if g_body[name] ~= nil then
		local targetname = g_body[name].target[index]
		if targetname ~= nil then
			return targetname
		end
	end
	return ''
end

function GET_BODY_VALUE(name, valueName)
	if g_body[name] ~= nil then
		return g_body[name][valueName]
	end
end

function BODY_LINK_ALL(name, rcMob)
	if g_body[name] ~= nil then
		if g_body[name].link ~= nil then
			for i,info in pairs(g_body[name].link) do
				rcBodyLink(rcMob, info.id, info.class, info.file, info.link, info.args)
			end
			
			return true
		end
	end
	
	return false
end

function GET_BODY_LOGIC(name, index)
	if g_body[name] ~= nil then
		if g_body[name].logic ~= nil then
			local logicInfo = g_body[name].logic[index]
			if type(logicInfo)=="table" then
				return logicInfo[1]
			else
				return logicInfo
			end
		end
	end
	
	return nil
end

function GET_BODY_LOGIC_PARAM(name, index)
	if g_body[name] ~= nil then
		if g_body[name].logic ~= nil then
			local logicInfo = g_body[name].logic[index]
			if type(logicInfo)=="table" and table.getn(logicInfo)>=2 then
				return logicInfo[2]
			end
		end
	end
	
	return nil
end

function GET_BODY_SKILL(name, index)
	if g_body[name] ~= nil then
		if g_body[name].skill ~= nil then
			return g_body[name].skill[index]
		end
	end
	
	return nil
end

function CREATE_BODY_SKILL_ID(name)
	local skillIDs = {}
	if g_body[name] ~= nil then
		local skill = g_body[name].skill
		if skill ~= nil then
			for index,info in pairs(skill) do
				--for k,v in pairs(info) do
				--	print(k..' : '..v..'\n')
				--end
				if info.id == nil then
					print('Wrong SkillID : body='..name..', skillIndex='..index..'\n')
				end
				skillIDs[info.name] = { id=info.id, target=info.target }
			end
		end
	end
	
	return skillIDs
end

function GET_BODY_SKILL_ID(name, skillIndex)
	if g_body[name] ~= nil then
		local skill = g_body[name].skill
		if skill ~= nil then
			local skillID = skill[skillIndex].id
			if skillID ~= nil then
				return skillID
			else
				alert('[Error] Unknown skill Index: mob['..name..'], index='..skillIndex..'\n')
			end
		end
	else
		alert('[Error] Unknown mob['..name..']\n')
	end
	
	return -1
end


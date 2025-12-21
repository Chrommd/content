
function LOGIC_CALL(tableName, funcName, values)
	if _G[tableName] then
		if type(_G[tableName])=="table" then
			local func = _G[tableName][funcName]
			if func~=nil then
				local funcType = type(func)
				
				if funcType=="function" then
					if values~=nil and type(values)=="table" then
						local v1 = values[1]
						local v2 = values[2]
						local v3 = values[3]
						local v4 = values[4]
						local v5 = values[5]
						local v6 = values[6]
						
						return func( v1, v2, v3, v4, v5, v6 )
					else
						return func()
					end
				else
					return func
				end
			else
				--local value = func
				--if type(value)=='boolean' then
					--value = value and 'true' or 'false'
				--elseif type(value)=='function' then
					--value = 'function'
				--elseif value==nil then
					--value = 'nil'
				--end
				
				alert('[Error] Not exist function name : '..funcName..' in '..tableName..'\n')
			end
		else
			alert('[Error] '..tableName..' is not table\n')
		end
	else
		alert('[Error] not exist table: '..(tableName or 'nil')..'\n')
	end
	
	return 0
end

function SET_DEFAULT( source, target )

	if type(target)~="table" then
		alert('[Error] '..target..' is not table\n')
		return
	end
	
	if type(source)~="table" then
		alert('[Error] '..source..' is not table\n')
		return
	end
	
	for k,v in pairs(source) do
		if target[k]==nil then
			target[k] = v
		end
	end
end

function AcKMpH(speed) 
	return speed * 1000 / 3600
end
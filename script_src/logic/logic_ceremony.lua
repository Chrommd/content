require('logichelper')

--
-- Ceremony - 시상식용
--

--
Ceremony =
{
	-- 위치 조절
	-- 기준위치의 MinFrontDist ~ MaxFrontDist 구간에서는 기본속도를 유지하고 벗어나면 속도를 조절한다.
	TargetFrontDist = 2,									-- PositionGap위치의 얼마만큼 앞을 속도제어의 기준위치로 삼을 것인가?
    MinFrontDist	= 0,									-- 기준위치 최소거리
    MaxFrontDist	= 2,									-- 기준위치 최대거리
    
    -- 속도 조절
    BaseSpeed		= 80,									-- 말 달리는 기본 속도
    AdjustSpeed		= 10,									-- 위치가 벗어날을 때 속도 변화 +/-값
    
	-- 1등 기준으로 상대적인 좌표값( v3(좌측,위쪽,정면) )
	PositionGap = function (ranking)
		
		local posGap = v3(0,0,0)							-- 1등
		if ranking==2 then		posGap = v3(3, 0, 2)		-- 2등
		elseif ranking==3 then	posGap = v3(6, 0, -3)		-- 3등
		elseif ranking==4 then	posGap = v3(8, 0, -4)		-- 4등
		end
		
		--if ranking ~= 1 then
		--	posGap.z = posGap.z - Ceremony.TargetFrontDist		
		--end
		return posGap
	end,	
}
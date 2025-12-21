require('logichelper')

--
-- PVP UI용
--

-- 미사일 타겟팅 영역 크기(가운데를 기준으로 상하좌우 증감값)
TargetArea =
{
	CenterGapX = -18,		-- 가운데서 우측
	CenterGapY = -138,		-- 가운데서 아래?
	
	TopGap		= 15,			-- 위로
	BottomGap	= 130,			-- 아래로	
	LeftGap		= -60,			-- 좌우
	RightGap	= 60,			-- 우로
}

TargetArea1 =
{
	CenterGapX = -18,		-- 가운데서 우측
	CenterGapY = -185,		-- 가운데서 아래
	
	TopGap		= 25,			-- 위로
	BottomGap	= 150,		-- 아래로	
	LeftGap		= -100,		-- 좌우
	RightGap	= 100,			-- 우로
}

TargetArea2 =
{
	CenterGapX = -18,		-- 가운데서 우측
	CenterGapY = -260,		-- 가운데서 아래
	
	TopGap		= 35,			-- 위로
	BottomGap	= 160,		-- 아래로	
	LeftGap		= -100,		-- 좌우
	RightGap	= 100,			-- 우로
}

-- 미사일 맞았을때 아이콘 표시UI
AttackIcon =
{
	SquareFadeInTime		= 0.8,									-- fade in 시간
	SquareDisplayTime		= 0.8,									-- 완전히 출력해있는 시간	
	SquareScaleTime			= 0.2,								-- 사각형 크기 변하는 시간
	SquareBeginRatio		= 1,									-- 사각형 처음 크기
    SquareEndRatio			= 10,									-- 사격형 마지막 크기
}

-- Attacked 출력(내가 마법 맞았을 때 표시)
Attacked =
{
	-- 화면 왼쪽 가운데 기준
	X			= function (screenWidth)	return 0 end,							-- X좌표 보정(center 기준)
	Y			= function (screenHeight)	return -150 * screenHeight/768 end,		-- Y좌표 보정(center 기준)
	
	FadeInTime	= 0.1,													-- 나타나는 시간(초)
	DisplayTime = 1.0,													-- 완전히 출력되어 있는 시간(초)
	FadeOutTime	= 0.1,													-- 사라지는 시간(초)
	
	FaceX       = 10,													-- 얼굴 그림 위치 보정
    FaceY       = 10,
    FontX       = 40,													-- 폰트 위치
    FontY       = 10,
    FontSize    = 20,													-- 대상 이름 글자 크기
    FontColor   = 0xFFFFFFFF,											-- ARGB
}

-- [마법 획득 연출] 마법 게이지 Full됐을때, 캐릭터부터 UI까지 날아가는 것
ObtainMagic =
{
	AssetOption		= "",								-- asset parameter
	AssetScale		= 0.2,								-- 크기(1은 기본)
	StartHeight		= 2,								-- 바닥에서 지정된 높이에서 시작
	ArriveDist		= 3,								-- 화면 앞 몇 미터 앞까지 이동하는가?
	MovingTime		= 0.2,								-- UI까지 이동하는 시간
	TargetLeftX		= 130,								-- 도착 UI위치(왼쪽으로부터)
	TargetBottomY	= 100,								-- 도착 UI위치(아래로부터)
	CancelLeftX		= function (screenWidth) return -50 end,								-- 도착 UI위치(왼쪽으로부터)
	CancelBottomY	= function (screenHeight) return 500 * screenHeight/768 end,								-- 도착 UI위치(아래로부터)
	CurveWidth		= 4,								-- 곡선으로 꺽이는 정도(왼쪽)
	CurveHeight		= 5,								-- 곡선으로 꺽이는 정도(높이)
	RotateSpeed		= 4 * 360,							-- Y축 회전속도(초당 몇바퀴)
	
    FXInterval      = 0.5,                              -- FX 출력 길이 간격
}

require('logichelper')

-- Default AI(Expert)
DefaultAIParam =
{
	ENABLE_COURBETTE = 1,								-- 초반 시작시 쿠르베트 가능 여부(0 or 1)
    COURBETTE_BASE_TIME = 1.5,							-- 쿠르베트 시작 시간(0~초)
    COURBETTE_START_ADJUST = 0,							-- 쿠르베트 시작 시간 조절값(0~초)
    COURBETTE_START_DELAY_ADJUST = 0,					-- 쿠르베트 실제 시작시 조절값(0~초)

	PREPARE_JUMP_OBSTACLE_MIN_HEIGHT = -5,				-- 점프대를 탐지했을때 넘으려고 점프대로 향하는 최소 높이차
	PREPARE_JUMP_OBSTACLE_MAX_HEIGHT = 5,				-- 점프대를 탐지했을때 넘으려고 점프대로 향하는 최대 높이차
    PREPARE_JUMP_OBSTACLE_ANGLE = 20,					-- 점프대를 탐지했을때) 넘으려고 점프대로 향하는 각도
    PREPARE_JUMP_OBSTACLE_CENTER_ADJUST = 0.05,			-- 현재 각도와 비례해서 점프대의 가운데에서 어느 위치로 넘을까(0~비율)
    JUMP_ENABLE_VELOCITY = AcKMpH(30),					-- 점프가 가능한 속도
    ENABLE_JUMP_CONTINUE = 1,							-- 연속 점프 가능 여부
    ENABLE_JUMP2ND = 1,									-- 2단 점프 가능 여부

    ENABLE_SPUR_USE = 1,								-- 박차 사용 가능한가?
	
	ENABLE_SPUR_SAVE = 1,            					-- 무조건 박차 3개 모으나?
    SPUR_SAVE_ON_FIRST_LAP = 1,							-- 첫바퀴째는 박차 3개되기 전까지 박차를 아끼는가?
	SPUR_SAVE_ON_LASTSPURT = 0,            				-- 라스트 스퍼트 구간에서도 3개 모으길 기다리나?
	SPUR_UNUSED_BEFORE_LASTSPURT = 0,				    -- 라스트스퍼트 전까지 박차를 사용하지 않는가?
	
    SPUR_CHECK_FRONT_ROAD_DIST = 20,					-- 박차 사용시 직선 주행로 체크 거리
    SPUR_CHECK_FRONT_ROAD_ANGLE = 25,					-- 박차 사용시 직선 주행로 체크 각도
    SPUR_ENABLE_CONTINUE_USE = 1,						-- 연속 박차 사용이 가능한가?	
    SPUR_FORCE_USE_DELAY = 0,							-- 박차 사용 후 강제 delay(초)
    SPUR_CONTINUE_CHECK_FRONT_ROAD_DIST =  10,			-- 연속박차 사용시 직선 주행로 체크 거리
    SPUR_CONTINUE_CHECK_FRONT_ROAD_ANGLE = 55,			-- 연속박차 사용시 직선 주행로 체크 각도
    SPUR_CONTINUE_USE_REMAIN_TIME = 0.4,				-- 연속박차 사용시 몇 초 남겨두고 또 쓸까?
    SPUR_CONTINUE_USE_REMAIN_ADJUST = 0.1,				-- SPUR_CONTINUE_USE_REMAIN_TIME에 대한 보정값(추가로 남겨두는 초)
    SPUR_FORCE_USE_WHEN_JUMP = 3,						-- 점프 시(점프대) 박차 사용할때의 박차 모은 개수
    
    ENABLE_FAR_DOWN_JUMP_CHECK = 1,       				-- far앞쪽 낭떠러지 판단 여부
	FAR_DOWN_JUMP_CHECK_DIST = 10,        				-- far앞쪽 낭떠러지 판단 거리
	FAR_DOWN_JUMP_CHECK_HEIGHT_1ST = -1,   				-- far앞쪽 낭떠러지 1단 점프 체크 높이(음수이면 무시)
	FAR_DOWN_JUMP_CHECK_HEIGHT_2ND = 10,   				-- far앞쪽 낭떠러지 2단 점프 체크 높이

    ENABLE_DOWN_JUMP_CHECK = 1,							-- 앞쪽 낭떠러지 판단 여부
    DOWN_JUMP_CHECK_DIST = 2.5,							-- 앞쪽 낭떠러지 판단 거리
    DOWN_JUMP_CHECK_HEIGHT_1ST = 0.7,					-- 앞쪽 낭떠러지 1단 점프 체크 높이
    DOWN_JUMP_CHECK_HEIGHT_2ND =  2.3,					-- 앞쪽 낭떠러지 2단 점프 체크 높이

    ENABLE_UP_JUMP_CHECK = 1,							-- 앞쪽 언덕길 판단 여부
    UP_JUMP_CHECK_DIST = 5,								-- 앞쪽 언덕길 판단 거리
    UP_JUMP_CHECK_HEIGHT_1ST = 1.3,						-- 앞쪽 언덕길 1단 점프 체크 높이
    UP_JUMP_CHECK_HEIGHT_2ND = 2.3,						-- 앞쪽 언덕길 2단 점프 체크 높이
    UP_JUMP_CHECK_ADD_HEIGHT = 5,						-- 앞쪽 언덕길 추가 체크 높이
    
    ENABLE_UP_GLIDING_CHECK = 1,						-- 앞쪽 언덕길 gliding 판단 여부
	UP_GLIDING_CHECK_DIST = 45,				            -- 앞쪽 언덕길 gliding 판단 거리
	UP_GLIDING_CHECK_CUR_HEIGHT = 12,				    -- 앞쪽 언덕길 gliding 점프 체크 현재 높이
	UP_GLIDING_CHECK_FRONT_GAP = -12,					-- 앞쪽 언덕길 gliding 높이차 이상(-면 아래쪽)
	UP_GLIDING_CHECK_FRONT_HIGHER_GAP = 2,				-- 앞쪽 언덕길 - 현재 땅보다 앞쪽이 얼마나 더 높아야 하는가
	UP_GLIDING_DELAY_MIN = 0.8,							-- 앞쪽 언덕길 gliding time
	UP_GLIDING_DELAY_MAX = 1.2,							-- 앞쪽 언덕길 gliding time
    
    NORMAL_ADJUST_ANGLE_GAP = 5,						-- 일반 주행시 조향 보정해주는 각도차
    JUMP_ADJUST_ANGLE_GAP = 3,							-- 점프 시 조향 보정해주는 각도차
    JUMP2ND_ADJUST_ANGLE_GAP = 5,						-- 2단 점프 시 조향 보정해주는 각도차
    JUMP_CONTINUE_ADJUST_ANGLE_GAP = 1,					-- 연속 점프 시 조향 보정해주는 각도차
    JUMP_TIMING_ADJUST_RATIO = 0,						-- 점프해야될때 점프타이밍 조절 확률(0~1)
	JUMP_TIMING_ADJUST_TIME = 0,						-- 점프해야될때 점프타이밍 조절 시간
    
    ENABLE_SLIDING = 1,									-- 슬라이딩 가능한가?
    SLIDING_ENABLE_MIN_VELOCITY = AcKMpH(65),			-- 슬라이딩 가능한 최소 속도
    SLIDING_STOP_MIN_VELOCITY = AcKMpH(65),				-- 슬라이딩 중단하는 최소 속도
    SLIDING_START_ANGLE = 12,							-- 슬라이딩 시작하는 각도차이
    SLIDING_DELAY_TIME = 0.3,							-- 슬라이딩 기본 딜레이
    SLIDING_ENABLE_THROTTLE_ANGLE = 70,					-- 슬라이딩시 전진키 누르는 각도
    ENABLE_KEEP_SLIDING_TO_DASH = 0,					-- 대쉬할때까지 슬라이딩을 하는가?
    SLIDING_STOP_CHECK_ANGLE = 3,						-- 슬라이딩 중단 체크하는 각도
    SLIDING_DASH_CHECK_ANGLE = 20,						-- 슬라이딩 중 대쉬 가능한 각도
    ENABLE_SLIDING_CANCEL_WHEN_OPPOSITE_SLIDING = 1,	-- 슬라이딩 중 반대쪽으로 슬라이딩 하는 경우
    ENABLE_SLIDING_CHECK_STOP_OPPOSITE_ANGLE = 1,		-- 슬라이딩 중 반대쪽으로 각도도 체크

    ENABLE_DASH = 1,									-- 대쉬 가능한가?
    DASH_USE_RATIO = 1,									-- 대쉬가능할때 사용 확률(0~1)
    DASH_FORCE_USE_DELAY = 0.5,							-- 슬라이딩 후 강제로 대쉬 사용하게 되는 시간

    ENABLE_CHECK_ITEM = 1,								-- 아이템 먹기 판단하는가?
    ITEM_CHECK_MIN_DIST = 10,							-- 아이템 먹기체크 최소 거리
    ITEM_CHECK_MAX_DIST = 25,							-- 아이템 먹기체크 최대 거리
    ITEM_CHECK_ANGLE = 20,								-- 아이템 먹기체크 각도

    TARGET_RETAIN_ITEM_ANGLE = 25,						-- 계속 아이템을 먹으려하고 할때의 최대 각도차
    TARGET_RETAIN_JUMP_ANGLE = 40,						-- 계속 점프대로 가려할때의 최대 각도차

    NORMAL_FRONT_CHECK_DIST = 10,						-- 일반 주행시의 앞쪽 길방향 체크 거리
    ENABLE_BLOCK_FRONT_CHECK = 1,						-- 앞쪽이 block되는지 체크를 하는가?
	BLOCK_FRONT_CHECK_RADIUS = 3,						-- 일반 주행시의 앞이 막혔을때 충돌체크반경
	BLOCK_GO_NEXT_ROAD_COUNT = 2,						-- 막혔을때 현재 길에서 리셋포인트 몇 칸앞의 길을 체크하는가?
    ROAD_FOLLOW_SIDE_RATIO = 0.3,						-- 일반 주행시의 길 옆을 따라 가는 경향(0~1)
    ROAD_FOLLOW_SIDE_GAP_CHANGE_RATIO = 0.1,			-- 길 옆을 따라 갈때 위치를 다시 결정하는 빈도(0~1)
    ENABLE_ROAD_ANGLE_ADJUST = 1,						-- 꺽이는 길 옆으로 붙는가?
    ROAD_ANGLE_ADJUST_GAP = 10,							-- 꺽이는 길 옆으로 붙을때의 길 각도차
    ROAD_ANGLE_ADJUST_ATTACH_RATIO = 0.05,				-- 꺽일때 붙는 비율
    ROAD_ANGLE_ADJUST_CHECK_FALLING_DIST = 2,			-- 꺽이는 곳에서 낭떠러지 체크할때의 거리

    OBSTACLE_FAR_CHECK_DIST = 12,						-- 장애물 체크 먼거리
    OBSTACLE_NEAR_CHECK_DIST = 5.5,						-- 장애물 체크 단거리
    OBSTACLE_PREPARE_DEFAULT_JUMP_DIST = 30,			-- 장애물 체크 기본 거리
    OBSTACLE_DIST_ADJUST_BASIS_VELOCITY = AcKMpH(80),	-- 체크 거리 보정 시의 기본 속도
    OBSTACLE_DIST_ADJUST_VELOCITY_GAP_RATIO = 0.2,		-- 체크 거리 보정 시의 초과 속도에 따른 거리 비율
    OBSTACLE_SIMPLE_CHECK_DIST = 12,					-- simple check 거리
    
    ENABLE_BLOCK_RESET = 1,								-- 길막히면 알아서 reset하는가?
	BLOCK_RESET_CHECK_RANGE = 1.5,						-- 길막혔다는거 판단하기 위한 거리
	BLOCK_RESET_CHECK_TIME = 1,			                -- 길막혔다는거 판단하기 위한 시간(초)

    -- 강제 밸런싱
    ENABLE_BALANCE = 1,									-- AI balance
	BALANCE_START_TIME = 5,								-- 최초 밸런싱 시작 시간
    BALANCE_DELAY = 5,									-- AI밸런싱 주기
    BALANCE_VELOCITY_MAX_UP = 15,						-- AI밸런싱 변화 속도 최대값
    BALANCE_VELOCITY_MAX_DOWN = 5,						-- AI밸런싱 변화 속도 최소값
    BALANCE_VELOCITY_ACC_UP = 1.5,						-- AI밸런싱 변화 속도 증가(초당)
    BALANCE_VELOCITY_ACC_DOWN = 1,						-- AI밸런싱 변화 속도 감속(초당)
	BALANCE_VELOCITY_RANDOM_MIN = -1,					-- AI밸런싱 속도 변화값 랜덤범위
	BALANCE_VELOCITY_RANDOM_MAX = 1,					-- AI밸런싱 속도 변화값 랜덤범위
    BALANCE_SPEED_UP_RATIO = 0.01,						-- AI밸런싱 속도 증가시 거리 비율
    BALANCE_SPEED_DOWN_RATIO = 0.05,					-- AI밸런싱 속도 감소시 거리 비율

	-- 초보 케어용 밸런싱
	ENABLE_NEWBIE_BALANCE = 0,							-- 초보 접대용? 이게 켜지면 밸런싱 대상이 젤 후미 플레이어가 됨. 밸런싱도 켜야 작동
	
	-- 스탯 리미트
	ENABLE_LIMIT_STAT = 0,								-- 스탯 관련 제한
	LIMIT_STAT_MAXSPEED = 0,							-- 최대속도 제한 ( 0이면 무시 )
	
	
	-- 마법 판정
	ENABLE_CHECK_TARGETISAI = 1,						-- 타겟이 AI인지 체크, 0이면 AI 우선 타겟팅도 OFF
	ENABLE_CHECK_NEXTPLAYERHASMAGIC = 1,				-- 내 다음 순위의 플레이어가 마법을 갖고 있는지 체크
	
	ENABLE_CHECK_CORNER = 1,							-- AI 마법 사용, 타겟이 코너 진입하는지 체크 여부
	CHECK_CORNER_DIST = 20,					    		-- 타겟의 코너 진입 체크 거리. (이 값 이내에 체크)
	CHECK_CORNER_ANGLE = 30,							-- 타겟의 코너 진입 체크 각도. (이 값보다 클 경우 코너로 인식)
	
	ENABLE_CHECK_CLIFF = 1,				    -- 절벽 체크
    ENABLE_CHECK_LASTSPURT = 1,             -- 라스트 스퍼트 체크
    ENABLE_CHECK_JUMPOBSTACLE = 1,          -- 점프대 체크
	
	ENABLE_MAGIC_USE = 1,					-- 마법 사용 여부
	
	ENABLE_CHECK_MAGICITEM = 1,							-- 마법 아이템 먹기 판단하는가?
    MAGICITEM_CHECK_MIN_DIST = 10,						-- 마법 아이템 먹기체크 최소 거리
    MAGICITEM_CHECK_MAX_DIST = 50,						-- 마법 아이템 먹기체크 최대 거리
    MAGICITEM_CHECK_ANGLE = 90,							-- 마법 아이템 먹기체크 각도
	
	MAGIC_USEDELAY_RAND_WARTERSHIELD = 2,				-- 워터 실드 랜덤 딜레이
	MAGIC_USEDELAY_LIGHTNING = 0,						-- 번개 마법 딜레이
	
	ENABLE_ICEWALL_AVOID_LEVEL = 3,          -- 빙벽 회피가능? (0:안함, 1:그립, 2:그립+점프, 3:그립+점프+급슬라이딩)
	ICEWALL_JUMP_CHOICE = 10,                -- 빙벽 점프로 피하기 확률 ( 가능/불가능 여부 판단 없이 무조건 점프할 확률, 1~100 )
	ICEWALL_SLIDING_DIST = 15,				 -- 슬라이딩 회피를 하는 지점. 빙벽까지 남은 거리.
	ICEWALL_AVOID_DELAY_TIME_RANDOM = 1,     -- 빙벽 인식후 몇초후 반응하는가? (랜덤)
	ICEWALL_JUMPDELAY_DIST_RANDOM = 10,		 -- 점프 명령 후 점프 지점 오차범위.

	
    ENABLE_ROAD_SPREAD = 1,						-- 길 가운데서 옆쪽으로 좀 퍼지기 작동?
	ROAD_SPREAD_MIN	= -0.75,						-- 옆으로 퍼지기 최소값(-1 ~ 0)
	ROAD_SPREAD_MAX = 0.75,						-- 옆으로 퍼지기 최대값( 0 ~ 1)
	ROAD_SPREAD_CHECK_DIST = 15,				-- 옆으로 퍼지기 벽체크 거리(한쪽 기준, 미터)
	ROAD_SPREAD_VALUE = 0.25,					-- 옆으로 퍼지기 한번의 변화값
	ROAD_SPREAD_KEEP_DIST = 20,					-- 옆으로 퍼지기 위치 유지 거리(미터)
}


-- Expert
ExpertAIParam =
{
}

-- Expert2
Expert2AIParam =
{
	PREPARE_JUMP_OBSTACLE_ANGLE = 25,					-- 점프대를 탐지했을때) 넘으려고 점프대로 향하는 각도
	
	SPUR_UNUSED_BEFORE_LASTSPURT = 0,				    -- 라스트스퍼트 전까지 박차를 사용하지 않는가?
	SPUR_CONTINUE_CHECK_FRONT_ROAD_DIST =  15,			-- 연속박차 사용시 직선 주행로 체크 거리
    SPUR_CONTINUE_CHECK_FRONT_ROAD_ANGLE = 65,			-- 연속박차 사용시 직선 주행로 체크 각도
	
	ENABLE_SLIDING_CANCEL_WHEN_OPPOSITE_SLIDING = 0,	-- 슬라이딩 중 반대쪽으로 슬라이딩 하는 경우
	SLIDING_START_ANGLE = 15,							-- 슬라이딩 시작하는 각도차이
	ENABLE_KEEP_SLIDING_TO_DASH = 1,					-- 대쉬할때까지 슬라이딩을 하는가?
	
	DASH_FORCE_USE_DELAY = 0.1,							-- 슬라이딩 후 강제로 대쉬 사용하게 되는 시간
	
	NORMAL_FRONT_CHECK_DIST = 10,						-- 일반 주행시의 앞쪽 길방향 체크 거리
    ENABLE_BLOCK_FRONT_CHECK = 1,						-- 앞쪽이 block되는지 체크를 하는가?
	BLOCK_FRONT_CHECK_RADIUS = 3,						-- 일반 주행시의 앞이 막혔을때 충돌체크반경
	BLOCK_GO_NEXT_ROAD_COUNT = 3,						-- 막혔을때 현재 길에서 리셋포인트 몇 칸앞의 길을 체크하는가?

	TARGET_RETAIN_ITEM_ANGLE = 25,						-- 계속 아이템을 먹으려하고 할때의 최대 각도차
    TARGET_RETAIN_JUMP_ANGLE = 30,						-- 계속 점프대로 가려할때의 최대 각도차
    
    ROAD_FOLLOW_SIDE_RATIO = 0.5,						-- 일반 주행시의 길 옆을 따라 가는 경향(0~1)
    ROAD_FOLLOW_SIDE_GAP_CHANGE_RATIO = 0.2,			-- 길 옆을 따라 갈때 위치를 다시 결정하는 빈도(0~1)
	ROAD_ANGLE_ADJUST_ATTACH_RATIO = -0.03,				-- 꺽일때 붙는 비율
}

-- Average
AverageAIParam =
{
	ENABLE_COURBETTE = 1,								-- 초반 시작시 쿠르베트 가능 여부(0 or 1)
    COURBETTE_BASE_TIME = 1.5,							-- 쿠르베트 시작 시간(0~초)
    COURBETTE_START_ADJUST = 0.3,						-- 쿠르베트 시작 시간 조절값(0~초)
    COURBETTE_START_DELAY_ADJUST = 0.2,					-- 쿠르베트 실제 시작시 조절값(0~초)

    PREPARE_JUMP_OBSTACLE_ANGLE = 30,					-- 점프대를 탐지했을때) 넘으려고 점프대로 향하는 각도
    PREPARE_JUMP_OBSTACLE_CENTER_ADJUST = 0.2,			-- 현재 각도와 비례해서 점프대의 가운데에서 어느 위치로 넘을까(0~비율)
    
    ENABLE_SPUR_USE = 1,								-- 박차 사용 가능한가?
    SPUR_SAVE_ON_FIRST_LAP = 1,							-- 첫바퀴째는 박차 3개되기 전까지 박차를 아끼는가?
    SPUR_UNUSED_BEFORE_LASTSPURT = 0,				    -- 라스트스퍼트 전까지 박차를 사용하지 않는가?
    
    ENABLE_FAR_DOWN_JUMP_CHECK = 0,       				-- far앞쪽 낭떠러지 판단 여부
	
    NORMAL_ADJUST_ANGLE_GAP = 8,						-- 일반 주행시 조향 보정해주는 각도차
    JUMP_ADJUST_ANGLE_GAP = 5,							-- 점프 시 조향 보정해주는 각도차
    JUMP2ND_ADJUST_ANGLE_GAP = 5,						-- 2단 점프 시 조향 보정해주는 각도차
    JUMP_CONTINUE_ADJUST_ANGLE_GAP = 2,					-- 연속 점프 시 조향 보정해주는 각도차
    JUMP_TIMING_ADJUST_RATIO = 0.2,						-- 점프해야될때 점프타이밍 조절 확률(0~1)
	JUMP_TIMING_ADJUST_TIME = 0.3,						-- 점프해야될때 점프타이밍 조절 시간
    
    ENABLE_SLIDING = 1,									-- 슬라이딩 가능한가?
    SLIDING_START_ANGLE = 20,							-- 슬라이딩 시작하는 각도차이
    SLIDING_DELAY_TIME = 1,								-- 슬라이딩 기본 딜레이
    SLIDING_ENABLE_THROTTLE_ANGLE = 50,					-- 슬라이딩시 전진키 누르는 각도
    SLIDING_STOP_CHECK_ANGLE = 6,						-- 슬라이딩 중단 체크하는 각도
    SLIDING_DASH_CHECK_ANGLE = 10,						-- 슬라이딩 중 대쉬 가능한 각도
    ENABLE_SLIDING_CANCEL_WHEN_OPPOSITE_SLIDING = 0,	-- 슬라이딩 중 반대쪽으로 슬라이딩 하는 경우
    ENABLE_SLIDING_CHECK_STOP_OPPOSITE_ANGLE = 0,		-- 슬라이딩 중 반대쪽으로 각도도 체크

    ENABLE_DASH = 1,									-- 대쉬 가능한가?
    DASH_USE_RATIO = 0.7,								-- 대쉬가능할때 사용 확률(0~1)
    DASH_FORCE_USE_DELAY = 0.2,							-- 슬라이딩 후 강제로 대쉬 사용하게 되는 시간

    NORMAL_FRONT_CHECK_DIST = 10,						-- 일반 주행시의 앞쪽 길방향 체크 거리
    ENABLE_BLOCK_FRONT_CHECK = 0,						-- 앞쪽이 block되는지 체크를 하는가?
	ROAD_FOLLOW_SIDE_RATIO = 1,							-- 일반 주행시의 길 옆을 따라 가는 경향(0~1)
    ROAD_FOLLOW_SIDE_GAP_CHANGE_RATIO = 0.2,			-- 길 옆을 따라 갈때 위치를 다시 결정하는 빈도(0~1)
    ROAD_ANGLE_ADJUST_ATTACH_RATIO = 0.02,				-- 꺽일때 붙는 비율

    OBSTACLE_FAR_CHECK_DIST = 11,						-- 장애물 체크 먼거리
    OBSTACLE_NEAR_CHECK_DIST = 6.5,						-- 장애물 체크 단거리
    OBSTACLE_PREPARE_DEFAULT_JUMP_DIST = 25,			-- 장애물 체크 기본 거리
    OBSTACLE_DIST_ADJUST_BASIS_VELOCITY = AcKMpH(80),	-- 체크 거리 보정 시의 기본 속도
    OBSTACLE_DIST_ADJUST_VELOCITY_GAP_RATIO = 0.05,		-- 체크 거리 보정 시의 초과 속도에 따른 거리 비율
    OBSTACLE_SIMPLE_CHECK_DIST = 11,					-- simple check 거리

    -- 강제 밸런싱
    ENABLE_BALANCE = 0,									-- AI balance
}

-- Poor
PoorAIParam =
{
	ENABLE_COURBETTE = 0,								-- 초반 시작시 쿠르베트 가능 여부(0 or 1)

    PREPARE_JUMP_OBSTACLE_ANGLE = 30,					-- 점프대를 탐지했을때) 넘으려고 점프대로 향하는 각도
    PREPARE_JUMP_OBSTACLE_CENTER_ADJUST = 0.3,			-- 현재 각도와 비례해서 점프대의 가운데에서 어느 위치로 넘을까(0~비율)
    JUMP_ENABLE_VELOCITY = AcKMpH(20),					-- 점프가 가능한 속도
    ENABLE_JUMP_CONTINUE = 0,							-- 연속 점프 가능 여부
    ENABLE_JUMP2ND = 1,									-- 2단 점프 가능 여부

    ENABLE_SPUR_USE = 1,								-- 박차 사용 가능한가?
    SPUR_SAVE_ON_FIRST_LAP = 0,							-- 첫바퀴째는 박차 3개되기 전까지 박차를 아끼는가?
    SPUR_UNUSED_BEFORE_LASTSPURT = 0,				    -- 라스트스퍼트 전까지 박차를 사용하지 않는가?
    SPUR_CHECK_FRONT_ROAD_DIST = 20,					-- 박차 사용시 직선 주행로 체크 거리
    SPUR_CHECK_FRONT_ROAD_ANGLE = 40,					-- 박차 사용시 직선 주행로 체크 각도
    SPUR_ENABLE_CONTINUE_USE = 0,						-- 연속 박차 사용이 가능한가?	
    SPUR_FORCE_USE_DELAY = 10,							-- 박차 사용 후 강제 delay(초)    

	ENABLE_FAR_DOWN_JUMP_CHECK = 0,       				-- far앞쪽 낭떠러지 판단 여부
    ENABLE_DOWN_JUMP_CHECK = 0,							-- 앞쪽 낭떠러지 판단 여부
    ENABLE_UP_GLIDING_CHECK = 0,						-- 앞쪽 언덕길 gliding 판단 여부
    
    NORMAL_ADJUST_ANGLE_GAP = 5,						-- 일반 주행시 조향 보정해주는 각도차
    JUMP_ADJUST_ANGLE_GAP = 3,							-- 점프 시 조향 보정해주는 각도차
    JUMP2ND_ADJUST_ANGLE_GAP = 5,						-- 2단 점프 시 조향 보정해주는 각도차
    JUMP_CONTINUE_ADJUST_ANGLE_GAP = 1,					-- 연속 점프 시 조향 보정해주는 각도차
    JUMP_TIMING_ADJUST_RATIO = 0.4,						-- 점프해야될때 점프타이밍 조절 확률(0~1)
	JUMP_TIMING_ADJUST_TIME = 0.5,						-- 점프해야될때 점프타이밍 조절 시간
    
    ENABLE_SLIDING = 0,									-- 슬라이딩 가능한가?
    
    ENABLE_DASH = 0,									-- 대쉬 가능한가?
    
    ENABLE_CHECK_ITEM = 0,								-- 아이템 먹기 판단하는가?
  
    NORMAL_FRONT_CHECK_DIST = 3,						-- 일반 주행시의 앞쪽 길방향 체크 거리
    ENABLE_BLOCK_FRONT_CHECK = 0,						-- 앞쪽이 block되는지 체크를 하는가?	
    ENABLE_ROAD_ANGLE_ADJUST = 0,						-- 꺽이는 길 옆으로 붙는가?
    ROAD_FOLLOW_SIDE_RATIO = 1.5,						-- 일반 주행시의 길 옆을 따라 가는 경향(0~1)
    ROAD_FOLLOW_SIDE_GAP_CHANGE_RATIO = 1,				-- 길 옆을 따라 갈때 위치를 다시 결정하는 빈도(0~1)
    
    OBSTACLE_FAR_CHECK_DIST = 10,						-- 장애물 체크 먼거리
    OBSTACLE_NEAR_CHECK_DIST = 6,						-- 장애물 체크 단거리
    OBSTACLE_PREPARE_DEFAULT_JUMP_DIST = 25,			-- 장애물 체크 기본 거리
    OBSTACLE_DIST_ADJUST_BASIS_VELOCITY = AcKMpH(80),	-- 체크 거리 보정 시의 기본 속도
    OBSTACLE_DIST_ADJUST_VELOCITY_GAP_RATIO = 0.03,		-- 체크 거리 보정 시의 초과 속도에 따른 거리 비율
    OBSTACLE_SIMPLE_CHECK_DIST = 10,					-- simple check 거리

    -- 강제 밸런싱
    ENABLE_BALANCE = 0,									-- AI balance
}



-- 초보자케어용
BeginnerAIParam =
{
	ENABLE_COURBETTE = 0,								-- 초반 시작시 쿠르베트 가능 여부(0 or 1)

    PREPARE_JUMP_OBSTACLE_ANGLE = 30,					-- 점프대를 탐지했을때) 넘으려고 점프대로 향하는 각도
    PREPARE_JUMP_OBSTACLE_CENTER_ADJUST = 0.3,			-- 현재 각도와 비례해서 점프대의 가운데에서 어느 위치로 넘을까(0~비율)
    JUMP_ENABLE_VELOCITY = AcKMpH(20),					-- 점프가 가능한 속도
    ENABLE_JUMP_CONTINUE = 0,							-- 연속 점프 가능 여부
    ENABLE_JUMP2ND = 1,									-- 2단 점프 가능 여부

    ENABLE_SPUR_USE = 1,								-- 박차 사용 가능한가?
    SPUR_SAVE_ON_FIRST_LAP = 0,							-- 첫바퀴째는 박차 3개되기 전까지 박차를 아끼는가?
    SPUR_UNUSED_BEFORE_LASTSPURT = 0,				    -- 라스트스퍼트 전까지 박차를 사용하지 않는가?
    SPUR_CHECK_FRONT_ROAD_DIST = 20,					-- 박차 사용시 직선 주행로 체크 거리
    SPUR_CHECK_FRONT_ROAD_ANGLE = 40,					-- 박차 사용시 직선 주행로 체크 각도
    SPUR_ENABLE_CONTINUE_USE = 0,						-- 연속 박차 사용이 가능한가?	
    SPUR_FORCE_USE_DELAY = 10,							-- 박차 사용 후 강제 delay(초)    

	ENABLE_FAR_DOWN_JUMP_CHECK = 0,       				-- far앞쪽 낭떠러지 판단 여부
    ENABLE_DOWN_JUMP_CHECK = 0,							-- 앞쪽 낭떠러지 판단 여부
    ENABLE_UP_GLIDING_CHECK = 0,						-- 앞쪽 언덕길 gliding 판단 여부
    
    NORMAL_ADJUST_ANGLE_GAP = 5,						-- 일반 주행시 조향 보정해주는 각도차
    JUMP_ADJUST_ANGLE_GAP = 3,							-- 점프 시 조향 보정해주는 각도차
    JUMP2ND_ADJUST_ANGLE_GAP = 5,						-- 2단 점프 시 조향 보정해주는 각도차
    JUMP_CONTINUE_ADJUST_ANGLE_GAP = 1,					-- 연속 점프 시 조향 보정해주는 각도차
    JUMP_TIMING_ADJUST_RATIO = 0.4,						-- 점프해야될때 점프타이밍 조절 확률(0~1)
	JUMP_TIMING_ADJUST_TIME = 0.5,						-- 점프해야될때 점프타이밍 조절 시간
    
    ENABLE_SLIDING = 0,									-- 슬라이딩 가능한가?
    
    ENABLE_DASH = 0,									-- 대쉬 가능한가?
    
    ENABLE_CHECK_ITEM = 0,								-- 아이템 먹기 판단하는가?
  
    NORMAL_FRONT_CHECK_DIST = 3,						-- 일반 주행시의 앞쪽 길방향 체크 거리
    ENABLE_BLOCK_FRONT_CHECK = 0,						-- 앞쪽이 block되는지 체크를 하는가?	
    ENABLE_ROAD_ANGLE_ADJUST = 0,						-- 꺽이는 길 옆으로 붙는가?
    ROAD_FOLLOW_SIDE_RATIO = 1.5,						-- 일반 주행시의 길 옆을 따라 가는 경향(0~1)
    ROAD_FOLLOW_SIDE_GAP_CHANGE_RATIO = 1,				-- 길 옆을 따라 갈때 위치를 다시 결정하는 빈도(0~1)
    
    OBSTACLE_FAR_CHECK_DIST = 10,						-- 장애물 체크 먼거리
    OBSTACLE_NEAR_CHECK_DIST = 6,						-- 장애물 체크 단거리
    OBSTACLE_PREPARE_DEFAULT_JUMP_DIST = 25,			-- 장애물 체크 기본 거리
    OBSTACLE_DIST_ADJUST_BASIS_VELOCITY = AcKMpH(80),	-- 체크 거리 보정 시의 기본 속도
    OBSTACLE_DIST_ADJUST_VELOCITY_GAP_RATIO = 0.03,		-- 체크 거리 보정 시의 초과 속도에 따른 거리 비율
    OBSTACLE_SIMPLE_CHECK_DIST = 10,					-- simple check 거리
	
	-- 스탯 리미트
	ENABLE_LIMIT_STAT = 1,								-- 스탯 관련 제한
	LIMIT_STAT_MAXSPEED = 0,							-- 최대속도 제한 ( 0이면 무시 )
	
    -- 강제 밸런싱
    ENABLE_BALANCE = 1,									-- AI balance
    BALANCE_VELOCITY_MAX_UP = 5,						-- AI밸런싱 변화 속도 최대값
    BALANCE_VELOCITY_MAX_DOWN = 20,						-- AI밸런싱 변화 속도 최소값    
	BALANCE_VELOCITY_ACC_UP = 1,						-- AI밸런싱 변화 속도 증가(초당)
    BALANCE_VELOCITY_ACC_DOWN = 5,						-- AI밸런싱 변화 속도 감속(초당)
	BALANCE_VELOCITY_RANDOM_MIN = -3,					-- AI밸런싱 속도 변화값 랜덤범위
	BALANCE_VELOCITY_RANDOM_MAX = 3,					-- AI밸런싱 속도 변화값 랜덤범위
	BALANCE_SPEED_UP_RATIO = 0.01,						-- AI밸런싱 속도 증가시 거리 비율
    BALANCE_SPEED_DOWN_RATIO = 0,						-- AI밸런싱 속도 감소시 거리 비율

	-- 초보 케어용 밸런싱
	ENABLE_NEWBIE_BALANCE = 1,							-- 초보 접대용?
}

-- 초보자케어용2
Beginner2AIParam =
{
	ENABLE_COURBETTE = 1,								-- 초반 시작시 쿠르베트 가능 여부(0 or 1)
    COURBETTE_BASE_TIME = 1.5,							-- 쿠르베트 시작 시간(0~초)
    COURBETTE_START_ADJUST = 0.3,						-- 쿠르베트 시작 시간 조절값(0~초)
    COURBETTE_START_DELAY_ADJUST = 0.2,					-- 쿠르베트 실제 시작시 조절값(0~초)

    PREPARE_JUMP_OBSTACLE_ANGLE = 30,					-- 점프대를 탐지했을때) 넘으려고 점프대로 향하는 각도
    PREPARE_JUMP_OBSTACLE_CENTER_ADJUST = 0.2,			-- 현재 각도와 비례해서 점프대의 가운데에서 어느 위치로 넘을까(0~비율)
    
    ENABLE_SPUR_USE = 1,								-- 박차 사용 가능한가?
    SPUR_SAVE_ON_FIRST_LAP = 1,							-- 첫바퀴째는 박차 3개되기 전까지 박차를 아끼는가?
    SPUR_UNUSED_BEFORE_LASTSPURT = 0,				    -- 라스트스퍼트 전까지 박차를 사용하지 않는가?
    
    ENABLE_FAR_DOWN_JUMP_CHECK = 0,       				-- far앞쪽 낭떠러지 판단 여부
	
    NORMAL_ADJUST_ANGLE_GAP = 8,						-- 일반 주행시 조향 보정해주는 각도차
    JUMP_ADJUST_ANGLE_GAP = 5,							-- 점프 시 조향 보정해주는 각도차
    JUMP2ND_ADJUST_ANGLE_GAP = 5,						-- 2단 점프 시 조향 보정해주는 각도차
    JUMP_CONTINUE_ADJUST_ANGLE_GAP = 2,					-- 연속 점프 시 조향 보정해주는 각도차
    JUMP_TIMING_ADJUST_RATIO = 0.2,						-- 점프해야될때 점프타이밍 조절 확률(0~1)
	JUMP_TIMING_ADJUST_TIME = 0.3,						-- 점프해야될때 점프타이밍 조절 시간
    
    ENABLE_SLIDING = 1,									-- 슬라이딩 가능한가?
    SLIDING_START_ANGLE = 20,							-- 슬라이딩 시작하는 각도차이
    SLIDING_DELAY_TIME = 1,								-- 슬라이딩 기본 딜레이
    SLIDING_ENABLE_THROTTLE_ANGLE = 50,					-- 슬라이딩시 전진키 누르는 각도
    SLIDING_STOP_CHECK_ANGLE = 6,						-- 슬라이딩 중단 체크하는 각도
    SLIDING_DASH_CHECK_ANGLE = 10,						-- 슬라이딩 중 대쉬 가능한 각도
    ENABLE_SLIDING_CANCEL_WHEN_OPPOSITE_SLIDING = 0,	-- 슬라이딩 중 반대쪽으로 슬라이딩 하는 경우
    ENABLE_SLIDING_CHECK_STOP_OPPOSITE_ANGLE = 0,		-- 슬라이딩 중 반대쪽으로 각도도 체크

    ENABLE_DASH = 1,									-- 대쉬 가능한가?
    DASH_USE_RATIO = 0.7,								-- 대쉬가능할때 사용 확률(0~1)
    DASH_FORCE_USE_DELAY = 0.2,							-- 슬라이딩 후 강제로 대쉬 사용하게 되는 시간

    NORMAL_FRONT_CHECK_DIST = 10,						-- 일반 주행시의 앞쪽 길방향 체크 거리
    ENABLE_BLOCK_FRONT_CHECK = 0,						-- 앞쪽이 block되는지 체크를 하는가?
	ROAD_FOLLOW_SIDE_RATIO = 1,							-- 일반 주행시의 길 옆을 따라 가는 경향(0~1)
    ROAD_FOLLOW_SIDE_GAP_CHANGE_RATIO = 0.2,			-- 길 옆을 따라 갈때 위치를 다시 결정하는 빈도(0~1)
    ROAD_ANGLE_ADJUST_ATTACH_RATIO = 0.02,				-- 꺽일때 붙는 비율

    OBSTACLE_FAR_CHECK_DIST = 11,						-- 장애물 체크 먼거리
    OBSTACLE_NEAR_CHECK_DIST = 6.5,						-- 장애물 체크 단거리
    OBSTACLE_PREPARE_DEFAULT_JUMP_DIST = 25,			-- 장애물 체크 기본 거리
    OBSTACLE_DIST_ADJUST_BASIS_VELOCITY = AcKMpH(80),	-- 체크 거리 보정 시의 기본 속도
    OBSTACLE_DIST_ADJUST_VELOCITY_GAP_RATIO = 0.05,		-- 체크 거리 보정 시의 초과 속도에 따른 거리 비율
    OBSTACLE_SIMPLE_CHECK_DIST = 11,					-- simple check 거리

	 -- 강제 밸런싱
    ENABLE_BALANCE = 1,									-- AI balance
    BALANCE_VELOCITY_MAX_UP = 5,						-- AI밸런싱 변화 속도 최대값
    BALANCE_VELOCITY_MAX_DOWN = 10,						-- AI밸런싱 변화 속도 최소값    
	BALANCE_VELOCITY_ACC_UP = 1,						-- AI밸런싱 변화 속도 증가(초당)
    BALANCE_VELOCITY_ACC_DOWN = 5,						-- AI밸런싱 변화 속도 감속(초당)
	BALANCE_VELOCITY_RANDOM_MIN = -3,					-- AI밸런싱 속도 변화값 랜덤범위
	BALANCE_VELOCITY_RANDOM_MAX = 3,					-- AI밸런싱 속도 변화값 랜덤범위
	BALANCE_SPEED_UP_RATIO = 0.01,						-- AI밸런싱 속도 증가시 거리 비율
    BALANCE_SPEED_DOWN_RATIO = 0,						-- AI밸런싱 속도 감소시 거리 비율

    -- 초보 케어용 밸런싱
	ENABLE_NEWBIE_BALANCE = 1,							-- 초보 접대용?
}

-- 싱글 AI easy 쿠키
SAI_easy1Param =
{
	ENABLE_COURBETTE = 0,								-- 초반 시작시 쿠르베트 가능 여부(0 or 1)

    PREPARE_JUMP_OBSTACLE_ANGLE = 30,					-- 점프대를 탐지했을때) 넘으려고 점프대로 향하는 각도
    PREPARE_JUMP_OBSTACLE_CENTER_ADJUST = 0.3,			-- 현재 각도와 비례해서 점프대의 가운데에서 어느 위치로 넘을까(0~비율)
    JUMP_ENABLE_VELOCITY = AcKMpH(20),					-- 점프가 가능한 속도
    ENABLE_JUMP_CONTINUE = 0,							-- 연속 점프 가능 여부
    ENABLE_JUMP2ND = 1,									-- 2단 점프 가능 여부

    ENABLE_SPUR_USE = 1,								-- 박차 사용 가능한가?
    SPUR_SAVE_ON_FIRST_LAP = 0,							-- 첫바퀴째는 박차 3개되기 전까지 박차를 아끼는가?
    SPUR_UNUSED_BEFORE_LASTSPURT = 0,				    -- 라스트스퍼트 전까지 박차를 사용하지 않는가?
    SPUR_CHECK_FRONT_ROAD_DIST = 20,					-- 박차 사용시 직선 주행로 체크 거리
    SPUR_CHECK_FRONT_ROAD_ANGLE = 40,					-- 박차 사용시 직선 주행로 체크 각도
    SPUR_ENABLE_CONTINUE_USE = 0,						-- 연속 박차 사용이 가능한가?	
    SPUR_FORCE_USE_DELAY = 10,							-- 박차 사용 후 강제 delay(초)    



    
    NORMAL_ADJUST_ANGLE_GAP = 5,						-- 일반 주행시 조향 보정해주는 각도차
    JUMP_ADJUST_ANGLE_GAP = 3,							-- 점프 시 조향 보정해주는 각도차
    JUMP2ND_ADJUST_ANGLE_GAP = 5,						-- 2단 점프 시 조향 보정해주는 각도차
    JUMP_CONTINUE_ADJUST_ANGLE_GAP = 1,					-- 연속 점프 시 조향 보정해주는 각도차
    JUMP_TIMING_ADJUST_RATIO = 0.4,						-- 점프해야될때 점프타이밍 조절 확률(0~1)
	JUMP_TIMING_ADJUST_TIME = 0.5,						-- 점프해야될때 점프타이밍 조절 시간
    
    ENABLE_SLIDING = 0,									-- 슬라이딩 가능한가?
    
    ENABLE_DASH = 0,									-- 대쉬 가능한가?
    
    ENABLE_CHECK_ITEM = 0,								-- 아이템 먹기 판단하는가?
  
    NORMAL_FRONT_CHECK_DIST = 3,						-- 일반 주행시의 앞쪽 길방향 체크 거리
    ENABLE_BLOCK_FRONT_CHECK = 0,						-- 앞쪽이 block되는지 체크를 하는가?	
    ENABLE_ROAD_ANGLE_ADJUST = 0,						-- 꺽이는 길 옆으로 붙는가?
    ROAD_FOLLOW_SIDE_RATIO = 1.5,						-- 일반 주행시의 길 옆을 따라 가는 경향(0~1)
    ROAD_FOLLOW_SIDE_GAP_CHANGE_RATIO = 1,				-- 길 옆을 따라 갈때 위치를 다시 결정하는 빈도(0~1)
    
    OBSTACLE_FAR_CHECK_DIST = 10,						-- 장애물 체크 먼거리
    OBSTACLE_NEAR_CHECK_DIST = 6,						-- 장애물 체크 단거리
    OBSTACLE_PREPARE_DEFAULT_JUMP_DIST = 25,			-- 장애물 체크 기본 거리
    OBSTACLE_DIST_ADJUST_BASIS_VELOCITY = AcKMpH(80),	-- 체크 거리 보정 시의 기본 속도
    OBSTACLE_DIST_ADJUST_VELOCITY_GAP_RATIO = 0.03,		-- 체크 거리 보정 시의 초과 속도에 따른 거리 비율
    OBSTACLE_SIMPLE_CHECK_DIST = 10,					-- simple check 거리
	
	-- 스탯 리미트
	ENABLE_LIMIT_STAT = 1,								-- 스탯 관련 제한
	LIMIT_STAT_MAXSPEED = 74,							-- 최대속도 제한 ( 0이면 무시 )
	
    -- 강제 밸런싱
    ENABLE_BALANCE = 0,									-- AI balance
}



-- 싱글 AI easy 제이크
SAI_easy2Param =
{
	ENABLE_COURBETTE = 0,								-- 초반 시작시 쿠르베트 가능 여부(0 or 1)

    PREPARE_JUMP_OBSTACLE_ANGLE = 30,					-- 점프대를 탐지했을때) 넘으려고 점프대로 향하는 각도
    PREPARE_JUMP_OBSTACLE_CENTER_ADJUST = 0.3,			-- 현재 각도와 비례해서 점프대의 가운데에서 어느 위치로 넘을까(0~비율)
    JUMP_ENABLE_VELOCITY = AcKMpH(20),					-- 점프가 가능한 속도
    ENABLE_JUMP_CONTINUE = 0,							-- 연속 점프 가능 여부
    ENABLE_JUMP2ND = 1,									-- 2단 점프 가능 여부

    ENABLE_SPUR_USE = 1,								-- 박차 사용 가능한가?
    SPUR_SAVE_ON_FIRST_LAP = 0,							-- 첫바퀴째는 박차 3개되기 전까지 박차를 아끼는가?
    SPUR_UNUSED_BEFORE_LASTSPURT = 0,				    -- 라스트스퍼트 전까지 박차를 사용하지 않는가?
    SPUR_CHECK_FRONT_ROAD_DIST = 20,					-- 박차 사용시 직선 주행로 체크 거리
    SPUR_CHECK_FRONT_ROAD_ANGLE = 40,					-- 박차 사용시 직선 주행로 체크 각도
    SPUR_ENABLE_CONTINUE_USE = 0,						-- 연속 박차 사용이 가능한가?	
    SPUR_FORCE_USE_DELAY = 10,							-- 박차 사용 후 강제 delay(초)    

    
    NORMAL_ADJUST_ANGLE_GAP = 5,						-- 일반 주행시 조향 보정해주는 각도차
    JUMP_ADJUST_ANGLE_GAP = 3,							-- 점프 시 조향 보정해주는 각도차
    JUMP2ND_ADJUST_ANGLE_GAP = 5,						-- 2단 점프 시 조향 보정해주는 각도차
    JUMP_CONTINUE_ADJUST_ANGLE_GAP = 1,					-- 연속 점프 시 조향 보정해주는 각도차
    JUMP_TIMING_ADJUST_RATIO = 0.4,						-- 점프해야될때 점프타이밍 조절 확률(0~1)
	JUMP_TIMING_ADJUST_TIME = 0.5,						-- 점프해야될때 점프타이밍 조절 시간
    
    ENABLE_SLIDING = 0,									-- 슬라이딩 가능한가?
    
    ENABLE_DASH = 0,									-- 대쉬 가능한가?
    
    ENABLE_CHECK_ITEM = 0,								-- 아이템 먹기 판단하는가?
  
    NORMAL_FRONT_CHECK_DIST = 3,						-- 일반 주행시의 앞쪽 길방향 체크 거리
    ENABLE_BLOCK_FRONT_CHECK = 0,						-- 앞쪽이 block되는지 체크를 하는가?	
    ENABLE_ROAD_ANGLE_ADJUST = 0,						-- 꺽이는 길 옆으로 붙는가?
    ROAD_FOLLOW_SIDE_RATIO = 1.5,						-- 일반 주행시의 길 옆을 따라 가는 경향(0~1)
    ROAD_FOLLOW_SIDE_GAP_CHANGE_RATIO = 1,				-- 길 옆을 따라 갈때 위치를 다시 결정하는 빈도(0~1)
    
    OBSTACLE_FAR_CHECK_DIST = 10,						-- 장애물 체크 먼거리
    OBSTACLE_NEAR_CHECK_DIST = 6,						-- 장애물 체크 단거리
    OBSTACLE_PREPARE_DEFAULT_JUMP_DIST = 25,			-- 장애물 체크 기본 거리
    OBSTACLE_DIST_ADJUST_BASIS_VELOCITY = AcKMpH(80),	-- 체크 거리 보정 시의 기본 속도
    OBSTACLE_DIST_ADJUST_VELOCITY_GAP_RATIO = 0.03,		-- 체크 거리 보정 시의 초과 속도에 따른 거리 비율
    OBSTACLE_SIMPLE_CHECK_DIST = 10,					-- simple check 거리
	
	-- 스탯 리미트
	ENABLE_LIMIT_STAT = 1,								-- 스탯 관련 제한
	LIMIT_STAT_MAXSPEED = 75,							-- 최대속도 제한 ( 0이면 무시 )
	
    -- 강제 밸런싱
    ENABLE_BALANCE = 0,									-- AI balance
}

-- 싱글 AI easy  제이드
SAI_easy3Param =
{
	ENABLE_COURBETTE = 0,								-- 초반 시작시 쿠르베트 가능 여부(0 or 1)

    PREPARE_JUMP_OBSTACLE_ANGLE = 30,					-- 점프대를 탐지했을때) 넘으려고 점프대로 향하는 각도
    PREPARE_JUMP_OBSTACLE_CENTER_ADJUST = 0.3,			-- 현재 각도와 비례해서 점프대의 가운데에서 어느 위치로 넘을까(0~비율)
    JUMP_ENABLE_VELOCITY = AcKMpH(20),					-- 점프가 가능한 속도
    ENABLE_JUMP_CONTINUE = 0,							-- 연속 점프 가능 여부
    ENABLE_JUMP2ND = 1,									-- 2단 점프 가능 여부

    ENABLE_SPUR_USE = 1,								-- 박차 사용 가능한가?
    SPUR_SAVE_ON_FIRST_LAP = 0,							-- 첫바퀴째는 박차 3개되기 전까지 박차를 아끼는가?
    SPUR_UNUSED_BEFORE_LASTSPURT = 0,				    -- 라스트스퍼트 전까지 박차를 사용하지 않는가?
    SPUR_CHECK_FRONT_ROAD_DIST = 20,					-- 박차 사용시 직선 주행로 체크 거리
    SPUR_CHECK_FRONT_ROAD_ANGLE = 40,					-- 박차 사용시 직선 주행로 체크 각도
    SPUR_ENABLE_CONTINUE_USE = 0,						-- 연속 박차 사용이 가능한가?	
    SPUR_FORCE_USE_DELAY = 10,							-- 박차 사용 후 강제 delay(초)    


    
    NORMAL_ADJUST_ANGLE_GAP = 5,						-- 일반 주행시 조향 보정해주는 각도차
    JUMP_ADJUST_ANGLE_GAP = 3,							-- 점프 시 조향 보정해주는 각도차
    JUMP2ND_ADJUST_ANGLE_GAP = 5,						-- 2단 점프 시 조향 보정해주는 각도차
    JUMP_CONTINUE_ADJUST_ANGLE_GAP = 1,					-- 연속 점프 시 조향 보정해주는 각도차
    JUMP_TIMING_ADJUST_RATIO = 0.4,						-- 점프해야될때 점프타이밍 조절 확률(0~1)
	JUMP_TIMING_ADJUST_TIME = 0.5,						-- 점프해야될때 점프타이밍 조절 시간
    
    ENABLE_SLIDING = 0,									-- 슬라이딩 가능한가?
    
    ENABLE_DASH = 0,									-- 대쉬 가능한가?
    
    ENABLE_CHECK_ITEM = 0,								-- 아이템 먹기 판단하는가?
  
    NORMAL_FRONT_CHECK_DIST = 3,						-- 일반 주행시의 앞쪽 길방향 체크 거리
    ENABLE_BLOCK_FRONT_CHECK = 0,						-- 앞쪽이 block되는지 체크를 하는가?	
    ENABLE_ROAD_ANGLE_ADJUST = 0,						-- 꺽이는 길 옆으로 붙는가?
    ROAD_FOLLOW_SIDE_RATIO = 1.5,						-- 일반 주행시의 길 옆을 따라 가는 경향(0~1)
    ROAD_FOLLOW_SIDE_GAP_CHANGE_RATIO = 1,				-- 길 옆을 따라 갈때 위치를 다시 결정하는 빈도(0~1)
    
    OBSTACLE_FAR_CHECK_DIST = 10,						-- 장애물 체크 먼거리
    OBSTACLE_NEAR_CHECK_DIST = 6,						-- 장애물 체크 단거리
    OBSTACLE_PREPARE_DEFAULT_JUMP_DIST = 25,			-- 장애물 체크 기본 거리
    OBSTACLE_DIST_ADJUST_BASIS_VELOCITY = AcKMpH(80),	-- 체크 거리 보정 시의 기본 속도
    OBSTACLE_DIST_ADJUST_VELOCITY_GAP_RATIO = 0.03,		-- 체크 거리 보정 시의 초과 속도에 따른 거리 비율
    OBSTACLE_SIMPLE_CHECK_DIST = 10,					-- simple check 거리
	
	-- 스탯 리미트
	ENABLE_LIMIT_STAT = 1,								-- 스탯 관련 제한
	LIMIT_STAT_MAXSPEED = 71,							-- 최대속도 제한 ( 0이면 무시 )
	
    -- 강제 밸런싱
    ENABLE_BALANCE = 0,									-- AI balance
}


-- 싱글 AI easy 앤
SAI_easy4Param =
{
	ENABLE_COURBETTE = 0,								-- 초반 시작시 쿠르베트 가능 여부(0 or 1)

    PREPARE_JUMP_OBSTACLE_ANGLE = 30,					-- 점프대를 탐지했을때) 넘으려고 점프대로 향하는 각도
    PREPARE_JUMP_OBSTACLE_CENTER_ADJUST = 0.3,			-- 현재 각도와 비례해서 점프대의 가운데에서 어느 위치로 넘을까(0~비율)
    JUMP_ENABLE_VELOCITY = AcKMpH(20),					-- 점프가 가능한 속도
    ENABLE_JUMP_CONTINUE = 0,							-- 연속 점프 가능 여부
    ENABLE_JUMP2ND = 1,									-- 2단 점프 가능 여부

    ENABLE_SPUR_USE = 1,								-- 박차 사용 가능한가?
    SPUR_SAVE_ON_FIRST_LAP = 0,							-- 첫바퀴째는 박차 3개되기 전까지 박차를 아끼는가?
    SPUR_UNUSED_BEFORE_LASTSPURT = 0,				    -- 라스트스퍼트 전까지 박차를 사용하지 않는가?
    SPUR_CHECK_FRONT_ROAD_DIST = 20,					-- 박차 사용시 직선 주행로 체크 거리
    SPUR_CHECK_FRONT_ROAD_ANGLE = 40,					-- 박차 사용시 직선 주행로 체크 각도
    SPUR_ENABLE_CONTINUE_USE = 0,						-- 연속 박차 사용이 가능한가?	
    SPUR_FORCE_USE_DELAY = 10,							-- 박차 사용 후 강제 delay(초)    


    
    NORMAL_ADJUST_ANGLE_GAP = 5,						-- 일반 주행시 조향 보정해주는 각도차
    JUMP_ADJUST_ANGLE_GAP = 3,							-- 점프 시 조향 보정해주는 각도차
    JUMP2ND_ADJUST_ANGLE_GAP = 5,						-- 2단 점프 시 조향 보정해주는 각도차
    JUMP_CONTINUE_ADJUST_ANGLE_GAP = 1,					-- 연속 점프 시 조향 보정해주는 각도차
    JUMP_TIMING_ADJUST_RATIO = 0.4,						-- 점프해야될때 점프타이밍 조절 확률(0~1)
	JUMP_TIMING_ADJUST_TIME = 0.5,						-- 점프해야될때 점프타이밍 조절 시간
    
    ENABLE_SLIDING = 0,									-- 슬라이딩 가능한가?
    
    ENABLE_DASH = 0,									-- 대쉬 가능한가?
    
    ENABLE_CHECK_ITEM = 0,								-- 아이템 먹기 판단하는가?
  
    NORMAL_FRONT_CHECK_DIST = 3,						-- 일반 주행시의 앞쪽 길방향 체크 거리
    ENABLE_BLOCK_FRONT_CHECK = 0,						-- 앞쪽이 block되는지 체크를 하는가?	
    ENABLE_ROAD_ANGLE_ADJUST = 0,						-- 꺽이는 길 옆으로 붙는가?
    ROAD_FOLLOW_SIDE_RATIO = 1.5,						-- 일반 주행시의 길 옆을 따라 가는 경향(0~1)
    ROAD_FOLLOW_SIDE_GAP_CHANGE_RATIO = 1,				-- 길 옆을 따라 갈때 위치를 다시 결정하는 빈도(0~1)
    
    OBSTACLE_FAR_CHECK_DIST = 10,						-- 장애물 체크 먼거리
    OBSTACLE_NEAR_CHECK_DIST = 6,						-- 장애물 체크 단거리
    OBSTACLE_PREPARE_DEFAULT_JUMP_DIST = 25,			-- 장애물 체크 기본 거리
    OBSTACLE_DIST_ADJUST_BASIS_VELOCITY = AcKMpH(80),	-- 체크 거리 보정 시의 기본 속도
    OBSTACLE_DIST_ADJUST_VELOCITY_GAP_RATIO = 0.03,		-- 체크 거리 보정 시의 초과 속도에 따른 거리 비율
    OBSTACLE_SIMPLE_CHECK_DIST = 10,					-- simple check 거리
	
	-- 스탯 리미트
	ENABLE_LIMIT_STAT = 1,								-- 스탯 관련 제한
	LIMIT_STAT_MAXSPEED = 70,							-- 최대속도 제한 ( 0이면 무시 )
	
    -- 강제 밸런싱
    ENABLE_BALANCE = 0,									-- AI balance
}

-- 싱글 AI easy 세인트
SAI_easy5Param =
{
	ENABLE_COURBETTE = 0,								-- 초반 시작시 쿠르베트 가능 여부(0 or 1)

    PREPARE_JUMP_OBSTACLE_ANGLE = 30,					-- 점프대를 탐지했을때) 넘으려고 점프대로 향하는 각도
    PREPARE_JUMP_OBSTACLE_CENTER_ADJUST = 0.3,			-- 현재 각도와 비례해서 점프대의 가운데에서 어느 위치로 넘을까(0~비율)
    JUMP_ENABLE_VELOCITY = AcKMpH(20),					-- 점프가 가능한 속도
    ENABLE_JUMP_CONTINUE = 0,							-- 연속 점프 가능 여부
    ENABLE_JUMP2ND = 1,									-- 2단 점프 가능 여부

    ENABLE_SPUR_USE = 1,								-- 박차 사용 가능한가?
    SPUR_SAVE_ON_FIRST_LAP = 0,							-- 첫바퀴째는 박차 3개되기 전까지 박차를 아끼는가?
    SPUR_UNUSED_BEFORE_LASTSPURT = 0,				    -- 라스트스퍼트 전까지 박차를 사용하지 않는가?
    SPUR_CHECK_FRONT_ROAD_DIST = 20,					-- 박차 사용시 직선 주행로 체크 거리
    SPUR_CHECK_FRONT_ROAD_ANGLE = 40,					-- 박차 사용시 직선 주행로 체크 각도
    SPUR_ENABLE_CONTINUE_USE = 0,						-- 연속 박차 사용이 가능한가?	
    SPUR_FORCE_USE_DELAY = 10,							-- 박차 사용 후 강제 delay(초)    


    
    NORMAL_ADJUST_ANGLE_GAP = 5,						-- 일반 주행시 조향 보정해주는 각도차
    JUMP_ADJUST_ANGLE_GAP = 3,							-- 점프 시 조향 보정해주는 각도차
    JUMP2ND_ADJUST_ANGLE_GAP = 5,						-- 2단 점프 시 조향 보정해주는 각도차
    JUMP_CONTINUE_ADJUST_ANGLE_GAP = 1,					-- 연속 점프 시 조향 보정해주는 각도차
    JUMP_TIMING_ADJUST_RATIO = 0.4,						-- 점프해야될때 점프타이밍 조절 확률(0~1)
	JUMP_TIMING_ADJUST_TIME = 0.5,						-- 점프해야될때 점프타이밍 조절 시간
    
    ENABLE_SLIDING = 0,									-- 슬라이딩 가능한가?
    
    ENABLE_DASH = 0,									-- 대쉬 가능한가?
    
    ENABLE_CHECK_ITEM = 0,								-- 아이템 먹기 판단하는가?
  
    NORMAL_FRONT_CHECK_DIST = 3,						-- 일반 주행시의 앞쪽 길방향 체크 거리
    ENABLE_BLOCK_FRONT_CHECK = 0,						-- 앞쪽이 block되는지 체크를 하는가?	
    ENABLE_ROAD_ANGLE_ADJUST = 0,						-- 꺽이는 길 옆으로 붙는가?
    ROAD_FOLLOW_SIDE_RATIO = 1.5,						-- 일반 주행시의 길 옆을 따라 가는 경향(0~1)
    ROAD_FOLLOW_SIDE_GAP_CHANGE_RATIO = 1,				-- 길 옆을 따라 갈때 위치를 다시 결정하는 빈도(0~1)
    
    OBSTACLE_FAR_CHECK_DIST = 10,						-- 장애물 체크 먼거리
    OBSTACLE_NEAR_CHECK_DIST = 6,						-- 장애물 체크 단거리
    OBSTACLE_PREPARE_DEFAULT_JUMP_DIST = 25,			-- 장애물 체크 기본 거리
    OBSTACLE_DIST_ADJUST_BASIS_VELOCITY = AcKMpH(80),	-- 체크 거리 보정 시의 기본 속도
    OBSTACLE_DIST_ADJUST_VELOCITY_GAP_RATIO = 0.03,		-- 체크 거리 보정 시의 초과 속도에 따른 거리 비율
    OBSTACLE_SIMPLE_CHECK_DIST = 10,					-- simple check 거리
	
	-- 스탯 리미트
	ENABLE_LIMIT_STAT = 1,								-- 스탯 관련 제한
	LIMIT_STAT_MAXSPEED = 73,							-- 최대속도 제한 ( 0이면 무시 )
	
    -- 강제 밸런싱
    ENABLE_BALANCE = 0,									-- AI balance
}
-- 싱글 AI easy 제니스
SAI_easy6Param =
{
	ENABLE_COURBETTE = 0,								-- 초반 시작시 쿠르베트 가능 여부(0 or 1)

    PREPARE_JUMP_OBSTACLE_ANGLE = 30,					-- 점프대를 탐지했을때) 넘으려고 점프대로 향하는 각도
    PREPARE_JUMP_OBSTACLE_CENTER_ADJUST = 0.3,			-- 현재 각도와 비례해서 점프대의 가운데에서 어느 위치로 넘을까(0~비율)
    JUMP_ENABLE_VELOCITY = AcKMpH(20),					-- 점프가 가능한 속도
    ENABLE_JUMP_CONTINUE = 0,							-- 연속 점프 가능 여부
    ENABLE_JUMP2ND = 1,									-- 2단 점프 가능 여부

    ENABLE_SPUR_USE = 1,								-- 박차 사용 가능한가?
    SPUR_SAVE_ON_FIRST_LAP = 0,							-- 첫바퀴째는 박차 3개되기 전까지 박차를 아끼는가?
    SPUR_UNUSED_BEFORE_LASTSPURT = 0,				    -- 라스트스퍼트 전까지 박차를 사용하지 않는가?
    SPUR_CHECK_FRONT_ROAD_DIST = 20,					-- 박차 사용시 직선 주행로 체크 거리
    SPUR_CHECK_FRONT_ROAD_ANGLE = 40,					-- 박차 사용시 직선 주행로 체크 각도
    SPUR_ENABLE_CONTINUE_USE = 0,						-- 연속 박차 사용이 가능한가?	
    SPUR_FORCE_USE_DELAY = 10,							-- 박차 사용 후 강제 delay(초)    


    
    NORMAL_ADJUST_ANGLE_GAP = 5,						-- 일반 주행시 조향 보정해주는 각도차
    JUMP_ADJUST_ANGLE_GAP = 3,							-- 점프 시 조향 보정해주는 각도차
    JUMP2ND_ADJUST_ANGLE_GAP = 5,						-- 2단 점프 시 조향 보정해주는 각도차
    JUMP_CONTINUE_ADJUST_ANGLE_GAP = 1,					-- 연속 점프 시 조향 보정해주는 각도차
    JUMP_TIMING_ADJUST_RATIO = 0.4,						-- 점프해야될때 점프타이밍 조절 확률(0~1)
	JUMP_TIMING_ADJUST_TIME = 0.5,						-- 점프해야될때 점프타이밍 조절 시간
    
    ENABLE_SLIDING = 0,									-- 슬라이딩 가능한가?
    
    ENABLE_DASH = 0,									-- 대쉬 가능한가?
    
    ENABLE_CHECK_ITEM = 0,								-- 아이템 먹기 판단하는가?
  
    NORMAL_FRONT_CHECK_DIST = 3,						-- 일반 주행시의 앞쪽 길방향 체크 거리
    ENABLE_BLOCK_FRONT_CHECK = 0,						-- 앞쪽이 block되는지 체크를 하는가?	
    ENABLE_ROAD_ANGLE_ADJUST = 0,						-- 꺽이는 길 옆으로 붙는가?
    ROAD_FOLLOW_SIDE_RATIO = 1.5,						-- 일반 주행시의 길 옆을 따라 가는 경향(0~1)
    ROAD_FOLLOW_SIDE_GAP_CHANGE_RATIO = 1,				-- 길 옆을 따라 갈때 위치를 다시 결정하는 빈도(0~1)
    
    OBSTACLE_FAR_CHECK_DIST = 10,						-- 장애물 체크 먼거리
    OBSTACLE_NEAR_CHECK_DIST = 6,						-- 장애물 체크 단거리
    OBSTACLE_PREPARE_DEFAULT_JUMP_DIST = 25,			-- 장애물 체크 기본 거리
    OBSTACLE_DIST_ADJUST_BASIS_VELOCITY = AcKMpH(80),	-- 체크 거리 보정 시의 기본 속도
    OBSTACLE_DIST_ADJUST_VELOCITY_GAP_RATIO = 0.03,		-- 체크 거리 보정 시의 초과 속도에 따른 거리 비율
    OBSTACLE_SIMPLE_CHECK_DIST = 10,					-- simple check 거리
	
	-- 스탯 리미트
	ENABLE_LIMIT_STAT = 1,								-- 스탯 관련 제한
	LIMIT_STAT_MAXSPEED = 72,							-- 최대속도 제한 ( 0이면 무시 )
	
    -- 강제 밸런싱
    ENABLE_BALANCE = 0,									-- AI balance
}
-- 싱글 AI easy 캐시
SAI_easy7Param =
{
	ENABLE_COURBETTE = 0,								-- 초반 시작시 쿠르베트 가능 여부(0 or 1)

    PREPARE_JUMP_OBSTACLE_ANGLE = 30,					-- 점프대를 탐지했을때) 넘으려고 점프대로 향하는 각도
    PREPARE_JUMP_OBSTACLE_CENTER_ADJUST = 0.3,			-- 현재 각도와 비례해서 점프대의 가운데에서 어느 위치로 넘을까(0~비율)
    JUMP_ENABLE_VELOCITY = AcKMpH(20),					-- 점프가 가능한 속도
    ENABLE_JUMP_CONTINUE = 0,							-- 연속 점프 가능 여부
    ENABLE_JUMP2ND = 1,									-- 2단 점프 가능 여부

    ENABLE_SPUR_USE = 1,								-- 박차 사용 가능한가?
    SPUR_SAVE_ON_FIRST_LAP = 0,							-- 첫바퀴째는 박차 3개되기 전까지 박차를 아끼는가?
    SPUR_UNUSED_BEFORE_LASTSPURT = 0,				    -- 라스트스퍼트 전까지 박차를 사용하지 않는가?
    SPUR_CHECK_FRONT_ROAD_DIST = 20,					-- 박차 사용시 직선 주행로 체크 거리
    SPUR_CHECK_FRONT_ROAD_ANGLE = 40,					-- 박차 사용시 직선 주행로 체크 각도
    SPUR_ENABLE_CONTINUE_USE = 0,						-- 연속 박차 사용이 가능한가?	
    SPUR_FORCE_USE_DELAY = 10,							-- 박차 사용 후 강제 delay(초)    


    
    NORMAL_ADJUST_ANGLE_GAP = 5,						-- 일반 주행시 조향 보정해주는 각도차
    JUMP_ADJUST_ANGLE_GAP = 3,							-- 점프 시 조향 보정해주는 각도차
    JUMP2ND_ADJUST_ANGLE_GAP = 5,						-- 2단 점프 시 조향 보정해주는 각도차
    JUMP_CONTINUE_ADJUST_ANGLE_GAP = 1,					-- 연속 점프 시 조향 보정해주는 각도차
    JUMP_TIMING_ADJUST_RATIO = 0.4,						-- 점프해야될때 점프타이밍 조절 확률(0~1)
	JUMP_TIMING_ADJUST_TIME = 0.5,						-- 점프해야될때 점프타이밍 조절 시간
    
    ENABLE_SLIDING = 0,									-- 슬라이딩 가능한가?
    
    ENABLE_DASH = 0,									-- 대쉬 가능한가?
    
    ENABLE_CHECK_ITEM = 0,								-- 아이템 먹기 판단하는가?
  
    NORMAL_FRONT_CHECK_DIST = 3,						-- 일반 주행시의 앞쪽 길방향 체크 거리
    ENABLE_BLOCK_FRONT_CHECK = 0,						-- 앞쪽이 block되는지 체크를 하는가?	
    ENABLE_ROAD_ANGLE_ADJUST = 0,						-- 꺽이는 길 옆으로 붙는가?
    ROAD_FOLLOW_SIDE_RATIO = 1.5,						-- 일반 주행시의 길 옆을 따라 가는 경향(0~1)
    ROAD_FOLLOW_SIDE_GAP_CHANGE_RATIO = 1,				-- 길 옆을 따라 갈때 위치를 다시 결정하는 빈도(0~1)
    
    OBSTACLE_FAR_CHECK_DIST = 10,						-- 장애물 체크 먼거리
    OBSTACLE_NEAR_CHECK_DIST = 6,						-- 장애물 체크 단거리
    OBSTACLE_PREPARE_DEFAULT_JUMP_DIST = 25,			-- 장애물 체크 기본 거리
    OBSTACLE_DIST_ADJUST_BASIS_VELOCITY = AcKMpH(80),	-- 체크 거리 보정 시의 기본 속도
    OBSTACLE_DIST_ADJUST_VELOCITY_GAP_RATIO = 0.03,		-- 체크 거리 보정 시의 초과 속도에 따른 거리 비율
    OBSTACLE_SIMPLE_CHECK_DIST = 10,					-- simple check 거리
	
	-- 스탯 리미트
	ENABLE_LIMIT_STAT = 1,								-- 스탯 관련 제한
	LIMIT_STAT_MAXSPEED = 70,							-- 최대속도 제한 ( 0이면 무시 )
	
    -- 강제 밸런싱
    ENABLE_BALANCE = 0,									-- AI balance
}
-- 싱글 AI nomal 카림
SAI_nomal1Param =
{
	
   -- 강제 밸런싱
    ENABLE_BALANCE = 0,									-- AI balance
	
   
}
-- 싱글 AI nomal 이든
SAI_nomal2Param =
{
	PREPARE_JUMP_OBSTACLE_ANGLE = 25,					-- 점프대를 탐지했을때) 넘으려고 점프대로 향하는 각도
	
	SPUR_UNUSED_BEFORE_LASTSPURT = 0,				    -- 라스트스퍼트 전까지 박차를 사용하지 않는가?
	SPUR_CONTINUE_CHECK_FRONT_ROAD_DIST =  15,			-- 연속박차 사용시 직선 주행로 체크 거리
    SPUR_CONTINUE_CHECK_FRONT_ROAD_ANGLE = 65,			-- 연속박차 사용시 직선 주행로 체크 각도
	
	ENABLE_SLIDING_CANCEL_WHEN_OPPOSITE_SLIDING = 0,	-- 슬라이딩 중 반대쪽으로 슬라이딩 하는 경우
	SLIDING_START_ANGLE = 15,							-- 슬라이딩 시작하는 각도차이
	ENABLE_KEEP_SLIDING_TO_DASH = 1,					-- 대쉬할때까지 슬라이딩을 하는가?
	
	DASH_FORCE_USE_DELAY = 0.1,							-- 슬라이딩 후 강제로 대쉬 사용하게 되는 시간
	
	NORMAL_FRONT_CHECK_DIST = 10,						-- 일반 주행시의 앞쪽 길방향 체크 거리
    ENABLE_BLOCK_FRONT_CHECK = 1,						-- 앞쪽이 block되는지 체크를 하는가?
	BLOCK_FRONT_CHECK_RADIUS = 3,						-- 일반 주행시의 앞이 막혔을때 충돌체크반경
	BLOCK_GO_NEXT_ROAD_COUNT = 3,						-- 막혔을때 현재 길에서 리셋포인트 몇 칸앞의 길을 체크하는가?

	TARGET_RETAIN_ITEM_ANGLE = 25,						-- 계속 아이템을 먹으려하고 할때의 최대 각도차
    TARGET_RETAIN_JUMP_ANGLE = 30,						-- 계속 점프대로 가려할때의 최대 각도차
    
    ROAD_FOLLOW_SIDE_RATIO = 0.5,						-- 일반 주행시의 길 옆을 따라 가는 경향(0~1)
    ROAD_FOLLOW_SIDE_GAP_CHANGE_RATIO = 0.2,			-- 길 옆을 따라 갈때 위치를 다시 결정하는 빈도(0~1)
	ROAD_ANGLE_ADJUST_ATTACH_RATIO = -0.03,				-- 꺽일때 붙는 비율
	
	
   -- 강제 밸런싱
    ENABLE_BALANCE = 0,									-- AI balance
}
-- 싱글 AI nomal 워렌 /poor
SAI_nomal3Param =
{
	ENABLE_COURBETTE = 1,								-- 초반 시작시 쿠르베트 가능 여부(0 or 1)
    COURBETTE_BASE_TIME = 1.5,							-- 쿠르베트 시작 시간(0~초)
    COURBETTE_START_ADJUST = 0,							-- 쿠르베트 시작 시간 조절값(0~초)
    COURBETTE_START_DELAY_ADJUST = 0,					-- 쿠르베트 실제 시작시 조절값(0~초)

    PREPARE_JUMP_OBSTACLE_ANGLE = 30,					-- 점프대를 탐지했을때) 넘으려고 점프대로 향하는 각도
    PREPARE_JUMP_OBSTACLE_CENTER_ADJUST = 0.3,			-- 현재 각도와 비례해서 점프대의 가운데에서 어느 위치로 넘을까(0~비율)
    JUMP_ENABLE_VELOCITY = AcKMpH(20),					-- 점프가 가능한 속도
    ENABLE_JUMP_CONTINUE = 0,							-- 연속 점프 가능 여부
    ENABLE_JUMP2ND = 1,									-- 2단 점프 가능 여부

    ENABLE_SPUR_USE = 1,								-- 박차 사용 가능한가?
    SPUR_SAVE_ON_FIRST_LAP = 0,							-- 첫바퀴째는 박차 3개되기 전까지 박차를 아끼는가?
    SPUR_UNUSED_BEFORE_LASTSPURT = 0,				    -- 라스트스퍼트 전까지 박차를 사용하지 않는가?
    SPUR_CHECK_FRONT_ROAD_DIST = 20,					-- 박차 사용시 직선 주행로 체크 거리
    SPUR_CHECK_FRONT_ROAD_ANGLE = 40,					-- 박차 사용시 직선 주행로 체크 각도
    SPUR_ENABLE_CONTINUE_USE = 1,						-- 연속 박차 사용이 가능한가?	
    SPUR_FORCE_USE_DELAY = 10,							-- 박차 사용 후 강제 delay(초)    

	ENABLE_FAR_DOWN_JUMP_CHECK = 0,       				-- far앞쪽 낭떠러지 판단 여부
    ENABLE_DOWN_JUMP_CHECK = 0,							-- 앞쪽 낭떠러지 판단 여부
    ENABLE_UP_GLIDING_CHECK = 0,						-- 앞쪽 언덕길 gliding 판단 여부
    
    NORMAL_ADJUST_ANGLE_GAP = 5,						-- 일반 주행시 조향 보정해주는 각도차
    JUMP_ADJUST_ANGLE_GAP = 3,							-- 점프 시 조향 보정해주는 각도차
    JUMP2ND_ADJUST_ANGLE_GAP = 5,						-- 2단 점프 시 조향 보정해주는 각도차
    JUMP_CONTINUE_ADJUST_ANGLE_GAP = 1,					-- 연속 점프 시 조향 보정해주는 각도차
    JUMP_TIMING_ADJUST_RATIO = 0.4,						-- 점프해야될때 점프타이밍 조절 확률(0~1)
	JUMP_TIMING_ADJUST_TIME = 0.5,						-- 점프해야될때 점프타이밍 조절 시간
    
    ENABLE_SLIDING = 1,									-- 슬라이딩 가능한가?
    SLIDING_ENABLE_MIN_VELOCITY = AcKMpH(65),			-- 슬라이딩 가능한 최소 속도
    SLIDING_STOP_MIN_VELOCITY = AcKMpH(65),				-- 슬라이딩 중단하는 최소 속도
    SLIDING_START_ANGLE = 12,							-- 슬라이딩 시작하는 각도차이
    SLIDING_DELAY_TIME = 0.3,							-- 슬라이딩 기본 딜레이
    SLIDING_ENABLE_THROTTLE_ANGLE = 70,					-- 슬라이딩시 전진키 누르는 각도
    ENABLE_KEEP_SLIDING_TO_DASH = 0,					-- 대쉬할때까지 슬라이딩을 하는가?
    SLIDING_STOP_CHECK_ANGLE = 3,						-- 슬라이딩 중단 체크하는 각도
    SLIDING_DASH_CHECK_ANGLE = 20,						-- 슬라이딩 중 대쉬 가능한 각도
    ENABLE_SLIDING_CANCEL_WHEN_OPPOSITE_SLIDING = 1,	-- 슬라이딩 중 반대쪽으로 슬라이딩 하는 경우
    ENABLE_SLIDING_CHECK_STOP_OPPOSITE_ANGLE = 1,		-- 슬라이딩 중 반대쪽으로 각도도 체크
    
    ENABLE_DASH = 1,									-- 대쉬 가능한가?
    DASH_USE_RATIO = 0.5,									-- 대쉬가능할때 사용 확률(0~1)
    DASH_FORCE_USE_DELAY = 0.5,							-- 슬라이딩 후 강제로 대쉬 사용하게 되는 시간
    
    ENABLE_CHECK_ITEM = 1,								-- 아이템 먹기 판단하는가?
    ITEM_CHECK_MIN_DIST = 10,							-- 아이템 먹기체크 최소 거리
    ITEM_CHECK_MAX_DIST = 25,							-- 아이템 먹기체크 최대 거리
    ITEM_CHECK_ANGLE = 20,								-- 아이템 먹기체크 각도
  
    NORMAL_FRONT_CHECK_DIST = 3,						-- 일반 주행시의 앞쪽 길방향 체크 거리
    ENABLE_BLOCK_FRONT_CHECK = 0,						-- 앞쪽이 block되는지 체크를 하는가?	
    ENABLE_ROAD_ANGLE_ADJUST = 0,						-- 꺽이는 길 옆으로 붙는가?
    ROAD_FOLLOW_SIDE_RATIO = 1.5,						-- 일반 주행시의 길 옆을 따라 가는 경향(0~1)
    ROAD_FOLLOW_SIDE_GAP_CHANGE_RATIO = 1,				-- 길 옆을 따라 갈때 위치를 다시 결정하는 빈도(0~1)
    
    OBSTACLE_FAR_CHECK_DIST = 10,						-- 장애물 체크 먼거리
    OBSTACLE_NEAR_CHECK_DIST = 6,						-- 장애물 체크 단거리
    OBSTACLE_PREPARE_DEFAULT_JUMP_DIST = 25,			-- 장애물 체크 기본 거리
    OBSTACLE_DIST_ADJUST_BASIS_VELOCITY = AcKMpH(80),	-- 체크 거리 보정 시의 기본 속도
    OBSTACLE_DIST_ADJUST_VELOCITY_GAP_RATIO = 0.03,		-- 체크 거리 보정 시의 초과 속도에 따른 거리 비율
    OBSTACLE_SIMPLE_CHECK_DIST = 10,					-- simple check 거리

    -- 강제 밸런싱
    ENABLE_BALANCE = 0,									-- AI balance
}
-- 싱글 AI nomal 티엔 / poor
SAI_nomal4Param =
{
	ENABLE_COURBETTE = 1,								-- 초반 시작시 쿠르베트 가능 여부(0 or 1)
    COURBETTE_BASE_TIME = 1.5,							-- 쿠르베트 시작 시간(0~초)
    COURBETTE_START_ADJUST = 0,							-- 쿠르베트 시작 시간 조절값(0~초)
    COURBETTE_START_DELAY_ADJUST = 0,					-- 쿠르베트 실제 시작시 조절값(0~초)

    PREPARE_JUMP_OBSTACLE_ANGLE = 30,					-- 점프대를 탐지했을때) 넘으려고 점프대로 향하는 각도
    PREPARE_JUMP_OBSTACLE_CENTER_ADJUST = 0.3,			-- 현재 각도와 비례해서 점프대의 가운데에서 어느 위치로 넘을까(0~비율)
    JUMP_ENABLE_VELOCITY = AcKMpH(20),					-- 점프가 가능한 속도
    ENABLE_JUMP_CONTINUE = 0,							-- 연속 점프 가능 여부
    ENABLE_JUMP2ND = 1,									-- 2단 점프 가능 여부

    ENABLE_SPUR_USE = 1,								-- 박차 사용 가능한가?
    SPUR_SAVE_ON_FIRST_LAP = 0,							-- 첫바퀴째는 박차 3개되기 전까지 박차를 아끼는가?
    SPUR_UNUSED_BEFORE_LASTSPURT = 0,				    -- 라스트스퍼트 전까지 박차를 사용하지 않는가?
    SPUR_CHECK_FRONT_ROAD_DIST = 20,					-- 박차 사용시 직선 주행로 체크 거리
    SPUR_CHECK_FRONT_ROAD_ANGLE = 40,					-- 박차 사용시 직선 주행로 체크 각도
    SPUR_ENABLE_CONTINUE_USE = 1,						-- 연속 박차 사용이 가능한가?	
    SPUR_FORCE_USE_DELAY = 10,							-- 박차 사용 후 강제 delay(초)    

	ENABLE_FAR_DOWN_JUMP_CHECK = 0,       				-- far앞쪽 낭떠러지 판단 여부
    ENABLE_DOWN_JUMP_CHECK = 0,							-- 앞쪽 낭떠러지 판단 여부
    ENABLE_UP_GLIDING_CHECK = 0,						-- 앞쪽 언덕길 gliding 판단 여부
    
    NORMAL_ADJUST_ANGLE_GAP = 5,						-- 일반 주행시 조향 보정해주는 각도차
    JUMP_ADJUST_ANGLE_GAP = 3,							-- 점프 시 조향 보정해주는 각도차
    JUMP2ND_ADJUST_ANGLE_GAP = 5,						-- 2단 점프 시 조향 보정해주는 각도차
    JUMP_CONTINUE_ADJUST_ANGLE_GAP = 1,					-- 연속 점프 시 조향 보정해주는 각도차
    JUMP_TIMING_ADJUST_RATIO = 0.4,						-- 점프해야될때 점프타이밍 조절 확률(0~1)
	JUMP_TIMING_ADJUST_TIME = 0.5,						-- 점프해야될때 점프타이밍 조절 시간
    
    ENABLE_SLIDING = 1,									-- 슬라이딩 가능한가?
    SLIDING_ENABLE_MIN_VELOCITY = AcKMpH(65),			-- 슬라이딩 가능한 최소 속도
    SLIDING_STOP_MIN_VELOCITY = AcKMpH(65),				-- 슬라이딩 중단하는 최소 속도
    SLIDING_START_ANGLE = 12,							-- 슬라이딩 시작하는 각도차이
    SLIDING_DELAY_TIME = 0.3,							-- 슬라이딩 기본 딜레이
    SLIDING_ENABLE_THROTTLE_ANGLE = 70,					-- 슬라이딩시 전진키 누르는 각도
    ENABLE_KEEP_SLIDING_TO_DASH = 0,					-- 대쉬할때까지 슬라이딩을 하는가?
    SLIDING_STOP_CHECK_ANGLE = 3,						-- 슬라이딩 중단 체크하는 각도
    SLIDING_DASH_CHECK_ANGLE = 20,						-- 슬라이딩 중 대쉬 가능한 각도
    ENABLE_SLIDING_CANCEL_WHEN_OPPOSITE_SLIDING = 1,	-- 슬라이딩 중 반대쪽으로 슬라이딩 하는 경우
    ENABLE_SLIDING_CHECK_STOP_OPPOSITE_ANGLE = 1,		-- 슬라이딩 중 반대쪽으로 각도도 체크
    
    ENABLE_DASH = 1,									-- 대쉬 가능한가?
    DASH_USE_RATIO = 0.5,									-- 대쉬가능할때 사용 확률(0~1)
    DASH_FORCE_USE_DELAY = 0.5,							-- 슬라이딩 후 강제로 대쉬 사용하게 되는 시간
    
    ENABLE_CHECK_ITEM = 1,								-- 아이템 먹기 판단하는가?
    ITEM_CHECK_MIN_DIST = 10,							-- 아이템 먹기체크 최소 거리
    ITEM_CHECK_MAX_DIST = 25,							-- 아이템 먹기체크 최대 거리
    ITEM_CHECK_ANGLE = 20,								-- 아이템 먹기체크 각도
  
    NORMAL_FRONT_CHECK_DIST = 3,						-- 일반 주행시의 앞쪽 길방향 체크 거리
    ENABLE_BLOCK_FRONT_CHECK = 0,						-- 앞쪽이 block되는지 체크를 하는가?	
    ENABLE_ROAD_ANGLE_ADJUST = 0,						-- 꺽이는 길 옆으로 붙는가?
    ROAD_FOLLOW_SIDE_RATIO = 1.5,						-- 일반 주행시의 길 옆을 따라 가는 경향(0~1)
    ROAD_FOLLOW_SIDE_GAP_CHANGE_RATIO = 1,				-- 길 옆을 따라 갈때 위치를 다시 결정하는 빈도(0~1)
    
    OBSTACLE_FAR_CHECK_DIST = 10,						-- 장애물 체크 먼거리
    OBSTACLE_NEAR_CHECK_DIST = 6,						-- 장애물 체크 단거리
    OBSTACLE_PREPARE_DEFAULT_JUMP_DIST = 25,			-- 장애물 체크 기본 거리
    OBSTACLE_DIST_ADJUST_BASIS_VELOCITY = AcKMpH(80),	-- 체크 거리 보정 시의 기본 속도
    OBSTACLE_DIST_ADJUST_VELOCITY_GAP_RATIO = 0.03,		-- 체크 거리 보정 시의 초과 속도에 따른 거리 비율
    OBSTACLE_SIMPLE_CHECK_DIST = 10,					-- simple check 거리

    -- 강제 밸런싱
    ENABLE_BALANCE = 0,									-- AI balance
}
-- 싱글 AI nomal 데인즈
SAI_nomal5Param =
{
	ENABLE_COURBETTE = 1,								-- 초반 시작시 쿠르베트 가능 여부(0 or 1)
    COURBETTE_BASE_TIME = 1.5,							-- 쿠르베트 시작 시간(0~초)
    COURBETTE_START_ADJUST = 0.3,						-- 쿠르베트 시작 시간 조절값(0~초)
    COURBETTE_START_DELAY_ADJUST = 0.2,					-- 쿠르베트 실제 시작시 조절값(0~초)

    PREPARE_JUMP_OBSTACLE_ANGLE = 30,					-- 점프대를 탐지했을때) 넘으려고 점프대로 향하는 각도
    PREPARE_JUMP_OBSTACLE_CENTER_ADJUST = 0.2,			-- 현재 각도와 비례해서 점프대의 가운데에서 어느 위치로 넘을까(0~비율)
    
    ENABLE_SPUR_USE = 1,								-- 박차 사용 가능한가?
    SPUR_SAVE_ON_FIRST_LAP = 1,							-- 첫바퀴째는 박차 3개되기 전까지 박차를 아끼는가?
    SPUR_UNUSED_BEFORE_LASTSPURT = 0,				    -- 라스트스퍼트 전까지 박차를 사용하지 않는가?
    
    ENABLE_FAR_DOWN_JUMP_CHECK = 0,       				-- far앞쪽 낭떠러지 판단 여부
	
    NORMAL_ADJUST_ANGLE_GAP = 8,						-- 일반 주행시 조향 보정해주는 각도차
    JUMP_ADJUST_ANGLE_GAP = 5,							-- 점프 시 조향 보정해주는 각도차
    JUMP2ND_ADJUST_ANGLE_GAP = 5,						-- 2단 점프 시 조향 보정해주는 각도차
    JUMP_CONTINUE_ADJUST_ANGLE_GAP = 2,					-- 연속 점프 시 조향 보정해주는 각도차
    JUMP_TIMING_ADJUST_RATIO = 0.2,						-- 점프해야될때 점프타이밍 조절 확률(0~1)
	JUMP_TIMING_ADJUST_TIME = 0.3,						-- 점프해야될때 점프타이밍 조절 시간
    
    ENABLE_SLIDING = 1,									-- 슬라이딩 가능한가?
    SLIDING_START_ANGLE = 20,							-- 슬라이딩 시작하는 각도차이
    SLIDING_DELAY_TIME = 1,								-- 슬라이딩 기본 딜레이
    SLIDING_ENABLE_THROTTLE_ANGLE = 50,					-- 슬라이딩시 전진키 누르는 각도
    SLIDING_STOP_CHECK_ANGLE = 6,						-- 슬라이딩 중단 체크하는 각도
    SLIDING_DASH_CHECK_ANGLE = 10,						-- 슬라이딩 중 대쉬 가능한 각도
    ENABLE_SLIDING_CANCEL_WHEN_OPPOSITE_SLIDING = 0,	-- 슬라이딩 중 반대쪽으로 슬라이딩 하는 경우
    ENABLE_SLIDING_CHECK_STOP_OPPOSITE_ANGLE = 0,		-- 슬라이딩 중 반대쪽으로 각도도 체크

    ENABLE_DASH = 1,									-- 대쉬 가능한가?
    DASH_USE_RATIO = 0.7,								-- 대쉬가능할때 사용 확률(0~1)
    DASH_FORCE_USE_DELAY = 0.2,							-- 슬라이딩 후 강제로 대쉬 사용하게 되는 시간

    NORMAL_FRONT_CHECK_DIST = 10,						-- 일반 주행시의 앞쪽 길방향 체크 거리
    ENABLE_BLOCK_FRONT_CHECK = 0,						-- 앞쪽이 block되는지 체크를 하는가?
	ROAD_FOLLOW_SIDE_RATIO = 1,							-- 일반 주행시의 길 옆을 따라 가는 경향(0~1)
    ROAD_FOLLOW_SIDE_GAP_CHANGE_RATIO = 0.2,			-- 길 옆을 따라 갈때 위치를 다시 결정하는 빈도(0~1)
    ROAD_ANGLE_ADJUST_ATTACH_RATIO = 0.02,				-- 꺽일때 붙는 비율

    OBSTACLE_FAR_CHECK_DIST = 11,						-- 장애물 체크 먼거리
    OBSTACLE_NEAR_CHECK_DIST = 6.5,						-- 장애물 체크 단거리
    OBSTACLE_PREPARE_DEFAULT_JUMP_DIST = 25,			-- 장애물 체크 기본 거리
    OBSTACLE_DIST_ADJUST_BASIS_VELOCITY = AcKMpH(80),	-- 체크 거리 보정 시의 기본 속도
    OBSTACLE_DIST_ADJUST_VELOCITY_GAP_RATIO = 0.05,		-- 체크 거리 보정 시의 초과 속도에 따른 거리 비율
    OBSTACLE_SIMPLE_CHECK_DIST = 11,					-- simple check 거리

    -- 강제 밸런싱
    ENABLE_BALANCE = 0,									-- AI balance
}
-- 싱글 AI nomal 글렌
SAI_nomal6Param =
{
	ENABLE_COURBETTE = 1,								-- 초반 시작시 쿠르베트 가능 여부(0 or 1)
    COURBETTE_BASE_TIME = 1.5,							-- 쿠르베트 시작 시간(0~초)
    COURBETTE_START_ADJUST = 0.3,						-- 쿠르베트 시작 시간 조절값(0~초)
    COURBETTE_START_DELAY_ADJUST = 0.2,					-- 쿠르베트 실제 시작시 조절값(0~초)

    PREPARE_JUMP_OBSTACLE_ANGLE = 30,					-- 점프대를 탐지했을때) 넘으려고 점프대로 향하는 각도
    PREPARE_JUMP_OBSTACLE_CENTER_ADJUST = 0.2,			-- 현재 각도와 비례해서 점프대의 가운데에서 어느 위치로 넘을까(0~비율)
    
    ENABLE_SPUR_USE = 1,								-- 박차 사용 가능한가?
    SPUR_SAVE_ON_FIRST_LAP = 1,							-- 첫바퀴째는 박차 3개되기 전까지 박차를 아끼는가?
    SPUR_UNUSED_BEFORE_LASTSPURT = 0,				    -- 라스트스퍼트 전까지 박차를 사용하지 않는가?
    
    ENABLE_FAR_DOWN_JUMP_CHECK = 0,       				-- far앞쪽 낭떠러지 판단 여부
	
    NORMAL_ADJUST_ANGLE_GAP = 8,						-- 일반 주행시 조향 보정해주는 각도차
    JUMP_ADJUST_ANGLE_GAP = 5,							-- 점프 시 조향 보정해주는 각도차
    JUMP2ND_ADJUST_ANGLE_GAP = 5,						-- 2단 점프 시 조향 보정해주는 각도차
    JUMP_CONTINUE_ADJUST_ANGLE_GAP = 2,					-- 연속 점프 시 조향 보정해주는 각도차
    JUMP_TIMING_ADJUST_RATIO = 0.2,						-- 점프해야될때 점프타이밍 조절 확률(0~1)
	JUMP_TIMING_ADJUST_TIME = 0.3,						-- 점프해야될때 점프타이밍 조절 시간
    
    ENABLE_SLIDING = 1,									-- 슬라이딩 가능한가?
    SLIDING_START_ANGLE = 20,							-- 슬라이딩 시작하는 각도차이
    SLIDING_DELAY_TIME = 1,								-- 슬라이딩 기본 딜레이
    SLIDING_ENABLE_THROTTLE_ANGLE = 50,					-- 슬라이딩시 전진키 누르는 각도
    SLIDING_STOP_CHECK_ANGLE = 6,						-- 슬라이딩 중단 체크하는 각도
    SLIDING_DASH_CHECK_ANGLE = 10,						-- 슬라이딩 중 대쉬 가능한 각도
    ENABLE_SLIDING_CANCEL_WHEN_OPPOSITE_SLIDING = 0,	-- 슬라이딩 중 반대쪽으로 슬라이딩 하는 경우
    ENABLE_SLIDING_CHECK_STOP_OPPOSITE_ANGLE = 0,		-- 슬라이딩 중 반대쪽으로 각도도 체크

    ENABLE_DASH = 1,									-- 대쉬 가능한가?
    DASH_USE_RATIO = 0.7,								-- 대쉬가능할때 사용 확률(0~1)
    DASH_FORCE_USE_DELAY = 0.2,							-- 슬라이딩 후 강제로 대쉬 사용하게 되는 시간

    NORMAL_FRONT_CHECK_DIST = 10,						-- 일반 주행시의 앞쪽 길방향 체크 거리
    ENABLE_BLOCK_FRONT_CHECK = 0,						-- 앞쪽이 block되는지 체크를 하는가?
	ROAD_FOLLOW_SIDE_RATIO = 1,							-- 일반 주행시의 길 옆을 따라 가는 경향(0~1)
    ROAD_FOLLOW_SIDE_GAP_CHANGE_RATIO = 0.2,			-- 길 옆을 따라 갈때 위치를 다시 결정하는 빈도(0~1)
    ROAD_ANGLE_ADJUST_ATTACH_RATIO = 0.02,				-- 꺽일때 붙는 비율

    OBSTACLE_FAR_CHECK_DIST = 11,						-- 장애물 체크 먼거리
    OBSTACLE_NEAR_CHECK_DIST = 6.5,						-- 장애물 체크 단거리
    OBSTACLE_PREPARE_DEFAULT_JUMP_DIST = 25,			-- 장애물 체크 기본 거리
    OBSTACLE_DIST_ADJUST_BASIS_VELOCITY = AcKMpH(80),	-- 체크 거리 보정 시의 기본 속도
    OBSTACLE_DIST_ADJUST_VELOCITY_GAP_RATIO = 0.05,		-- 체크 거리 보정 시의 초과 속도에 따른 거리 비율
    OBSTACLE_SIMPLE_CHECK_DIST = 11,					-- simple check 거리

    -- 강제 밸런싱
    ENABLE_BALANCE = 0,									-- AI balance
}
-- 싱글 AI nomal 메이린 / poor
SAI_nomal7Param =
{
	ENABLE_COURBETTE = 1,								-- 초반 시작시 쿠르베트 가능 여부(0 or 1)
    COURBETTE_BASE_TIME = 1.5,							-- 쿠르베트 시작 시간(0~초)
    COURBETTE_START_ADJUST = 0,							-- 쿠르베트 시작 시간 조절값(0~초)
    COURBETTE_START_DELAY_ADJUST = 0,					-- 쿠르베트 실제 시작시 조절값(0~초)

    PREPARE_JUMP_OBSTACLE_ANGLE = 30,					-- 점프대를 탐지했을때) 넘으려고 점프대로 향하는 각도
    PREPARE_JUMP_OBSTACLE_CENTER_ADJUST = 0.3,			-- 현재 각도와 비례해서 점프대의 가운데에서 어느 위치로 넘을까(0~비율)
    JUMP_ENABLE_VELOCITY = AcKMpH(20),					-- 점프가 가능한 속도
    ENABLE_JUMP_CONTINUE = 0,							-- 연속 점프 가능 여부
    ENABLE_JUMP2ND = 1,									-- 2단 점프 가능 여부

    ENABLE_SPUR_USE = 1,								-- 박차 사용 가능한가?
    SPUR_SAVE_ON_FIRST_LAP = 0,							-- 첫바퀴째는 박차 3개되기 전까지 박차를 아끼는가?
    SPUR_UNUSED_BEFORE_LASTSPURT = 0,				    -- 라스트스퍼트 전까지 박차를 사용하지 않는가?
    SPUR_CHECK_FRONT_ROAD_DIST = 20,					-- 박차 사용시 직선 주행로 체크 거리
    SPUR_CHECK_FRONT_ROAD_ANGLE = 40,					-- 박차 사용시 직선 주행로 체크 각도
    SPUR_ENABLE_CONTINUE_USE = 1,						-- 연속 박차 사용이 가능한가?	
    SPUR_FORCE_USE_DELAY = 10,							-- 박차 사용 후 강제 delay(초)    

	ENABLE_FAR_DOWN_JUMP_CHECK = 0,       				-- far앞쪽 낭떠러지 판단 여부
    ENABLE_DOWN_JUMP_CHECK = 0,							-- 앞쪽 낭떠러지 판단 여부
    ENABLE_UP_GLIDING_CHECK = 0,						-- 앞쪽 언덕길 gliding 판단 여부
    
    NORMAL_ADJUST_ANGLE_GAP = 5,						-- 일반 주행시 조향 보정해주는 각도차
    JUMP_ADJUST_ANGLE_GAP = 3,							-- 점프 시 조향 보정해주는 각도차
    JUMP2ND_ADJUST_ANGLE_GAP = 5,						-- 2단 점프 시 조향 보정해주는 각도차
    JUMP_CONTINUE_ADJUST_ANGLE_GAP = 1,					-- 연속 점프 시 조향 보정해주는 각도차
    JUMP_TIMING_ADJUST_RATIO = 0.4,						-- 점프해야될때 점프타이밍 조절 확률(0~1)
	JUMP_TIMING_ADJUST_TIME = 0.5,						-- 점프해야될때 점프타이밍 조절 시간
    
    ENABLE_SLIDING = 1,									-- 슬라이딩 가능한가?
    SLIDING_ENABLE_MIN_VELOCITY = AcKMpH(65),			-- 슬라이딩 가능한 최소 속도
    SLIDING_STOP_MIN_VELOCITY = AcKMpH(65),				-- 슬라이딩 중단하는 최소 속도
    SLIDING_START_ANGLE = 12,							-- 슬라이딩 시작하는 각도차이
    SLIDING_DELAY_TIME = 0.3,							-- 슬라이딩 기본 딜레이
    SLIDING_ENABLE_THROTTLE_ANGLE = 70,					-- 슬라이딩시 전진키 누르는 각도
    ENABLE_KEEP_SLIDING_TO_DASH = 0,					-- 대쉬할때까지 슬라이딩을 하는가?
    SLIDING_STOP_CHECK_ANGLE = 3,						-- 슬라이딩 중단 체크하는 각도
    SLIDING_DASH_CHECK_ANGLE = 20,						-- 슬라이딩 중 대쉬 가능한 각도
    ENABLE_SLIDING_CANCEL_WHEN_OPPOSITE_SLIDING = 1,	-- 슬라이딩 중 반대쪽으로 슬라이딩 하는 경우
    ENABLE_SLIDING_CHECK_STOP_OPPOSITE_ANGLE = 1,		-- 슬라이딩 중 반대쪽으로 각도도 체크
    
    ENABLE_DASH = 1,									-- 대쉬 가능한가?
    DASH_USE_RATIO = 0.5,									-- 대쉬가능할때 사용 확률(0~1)
    DASH_FORCE_USE_DELAY = 0.5,							-- 슬라이딩 후 강제로 대쉬 사용하게 되는 시간
    
    ENABLE_CHECK_ITEM = 1,								-- 아이템 먹기 판단하는가?
    ITEM_CHECK_MIN_DIST = 10,							-- 아이템 먹기체크 최소 거리
    ITEM_CHECK_MAX_DIST = 25,							-- 아이템 먹기체크 최대 거리
    ITEM_CHECK_ANGLE = 20,								-- 아이템 먹기체크 각도
  
    NORMAL_FRONT_CHECK_DIST = 3,						-- 일반 주행시의 앞쪽 길방향 체크 거리
    ENABLE_BLOCK_FRONT_CHECK = 0,						-- 앞쪽이 block되는지 체크를 하는가?	
    ENABLE_ROAD_ANGLE_ADJUST = 0,						-- 꺽이는 길 옆으로 붙는가?
    ROAD_FOLLOW_SIDE_RATIO = 1.5,						-- 일반 주행시의 길 옆을 따라 가는 경향(0~1)
    ROAD_FOLLOW_SIDE_GAP_CHANGE_RATIO = 1,				-- 길 옆을 따라 갈때 위치를 다시 결정하는 빈도(0~1)
    
    OBSTACLE_FAR_CHECK_DIST = 10,						-- 장애물 체크 먼거리
    OBSTACLE_NEAR_CHECK_DIST = 6,						-- 장애물 체크 단거리
    OBSTACLE_PREPARE_DEFAULT_JUMP_DIST = 25,			-- 장애물 체크 기본 거리
    OBSTACLE_DIST_ADJUST_BASIS_VELOCITY = AcKMpH(80),	-- 체크 거리 보정 시의 기본 속도
    OBSTACLE_DIST_ADJUST_VELOCITY_GAP_RATIO = 0.03,		-- 체크 거리 보정 시의 초과 속도에 따른 거리 비율
    OBSTACLE_SIMPLE_CHECK_DIST = 10,					-- simple check 거리

    -- 강제 밸런싱
    ENABLE_BALANCE = 0,									-- AI balance
}
-- 싱글 AI hard 멀린
SAI_hard1Param =
{
   -- 강제 밸런싱
    ENABLE_BALANCE = 0,									-- AI balance
}
-- 싱글 AI hard 델타
SAI_hard2Param =
{
	PREPARE_JUMP_OBSTACLE_ANGLE = 25,					-- 점프대를 탐지했을때) 넘으려고 점프대로 향하는 각도
	
	SPUR_UNUSED_BEFORE_LASTSPURT = 0,				    -- 라스트스퍼트 전까지 박차를 사용하지 않는가?
	SPUR_CONTINUE_CHECK_FRONT_ROAD_DIST =  15,			-- 연속박차 사용시 직선 주행로 체크 거리
    SPUR_CONTINUE_CHECK_FRONT_ROAD_ANGLE = 65,			-- 연속박차 사용시 직선 주행로 체크 각도
	
	ENABLE_SLIDING_CANCEL_WHEN_OPPOSITE_SLIDING = 0,	-- 슬라이딩 중 반대쪽으로 슬라이딩 하는 경우
	SLIDING_START_ANGLE = 15,							-- 슬라이딩 시작하는 각도차이
	ENABLE_KEEP_SLIDING_TO_DASH = 1,					-- 대쉬할때까지 슬라이딩을 하는가?
	
	DASH_FORCE_USE_DELAY = 0.1,							-- 슬라이딩 후 강제로 대쉬 사용하게 되는 시간
	
	NORMAL_FRONT_CHECK_DIST = 10,						-- 일반 주행시의 앞쪽 길방향 체크 거리
    ENABLE_BLOCK_FRONT_CHECK = 1,						-- 앞쪽이 block되는지 체크를 하는가?
	BLOCK_FRONT_CHECK_RADIUS = 3,						-- 일반 주행시의 앞이 막혔을때 충돌체크반경
	BLOCK_GO_NEXT_ROAD_COUNT = 3,						-- 막혔을때 현재 길에서 리셋포인트 몇 칸앞의 길을 체크하는가?

	TARGET_RETAIN_ITEM_ANGLE = 25,						-- 계속 아이템을 먹으려하고 할때의 최대 각도차
    TARGET_RETAIN_JUMP_ANGLE = 30,						-- 계속 점프대로 가려할때의 최대 각도차
    
    ROAD_FOLLOW_SIDE_RATIO = 0.5,						-- 일반 주행시의 길 옆을 따라 가는 경향(0~1)
    ROAD_FOLLOW_SIDE_GAP_CHANGE_RATIO = 0.2,			-- 길 옆을 따라 갈때 위치를 다시 결정하는 빈도(0~1)
	ROAD_ANGLE_ADJUST_ATTACH_RATIO = -0.03,				-- 꺽일때 붙는 비율
	
   -- 강제 밸런싱
    ENABLE_BALANCE = 0,									-- AI balance
}
-- 싱글 AI hard 엔쥬
SAI_hard3Param =
{
	ENABLE_COURBETTE = 1,								-- 초반 시작시 쿠르베트 가능 여부(0 or 1)
    COURBETTE_BASE_TIME = 1.5,							-- 쿠르베트 시작 시간(0~초)
    COURBETTE_START_ADJUST = 0.3,						-- 쿠르베트 시작 시간 조절값(0~초)
    COURBETTE_START_DELAY_ADJUST = 0.2,					-- 쿠르베트 실제 시작시 조절값(0~초)

    PREPARE_JUMP_OBSTACLE_ANGLE = 30,					-- 점프대를 탐지했을때) 넘으려고 점프대로 향하는 각도
    PREPARE_JUMP_OBSTACLE_CENTER_ADJUST = 0.2,			-- 현재 각도와 비례해서 점프대의 가운데에서 어느 위치로 넘을까(0~비율)
    
    ENABLE_SPUR_USE = 1,								-- 박차 사용 가능한가?
    SPUR_SAVE_ON_FIRST_LAP = 1,							-- 첫바퀴째는 박차 3개되기 전까지 박차를 아끼는가?
    SPUR_UNUSED_BEFORE_LASTSPURT = 0,				    -- 라스트스퍼트 전까지 박차를 사용하지 않는가?
    
    ENABLE_FAR_DOWN_JUMP_CHECK = 0,       				-- far앞쪽 낭떠러지 판단 여부
	
    NORMAL_ADJUST_ANGLE_GAP = 8,						-- 일반 주행시 조향 보정해주는 각도차
    JUMP_ADJUST_ANGLE_GAP = 5,							-- 점프 시 조향 보정해주는 각도차
    JUMP2ND_ADJUST_ANGLE_GAP = 5,						-- 2단 점프 시 조향 보정해주는 각도차
    JUMP_CONTINUE_ADJUST_ANGLE_GAP = 2,					-- 연속 점프 시 조향 보정해주는 각도차
    JUMP_TIMING_ADJUST_RATIO = 0.2,						-- 점프해야될때 점프타이밍 조절 확률(0~1)
	JUMP_TIMING_ADJUST_TIME = 0.3,						-- 점프해야될때 점프타이밍 조절 시간
    
    ENABLE_SLIDING = 1,									-- 슬라이딩 가능한가?
    SLIDING_START_ANGLE = 20,							-- 슬라이딩 시작하는 각도차이
    SLIDING_DELAY_TIME = 1,								-- 슬라이딩 기본 딜레이
    SLIDING_ENABLE_THROTTLE_ANGLE = 50,					-- 슬라이딩시 전진키 누르는 각도
    SLIDING_STOP_CHECK_ANGLE = 6,						-- 슬라이딩 중단 체크하는 각도
    SLIDING_DASH_CHECK_ANGLE = 10,						-- 슬라이딩 중 대쉬 가능한 각도
    ENABLE_SLIDING_CANCEL_WHEN_OPPOSITE_SLIDING = 0,	-- 슬라이딩 중 반대쪽으로 슬라이딩 하는 경우
    ENABLE_SLIDING_CHECK_STOP_OPPOSITE_ANGLE = 0,		-- 슬라이딩 중 반대쪽으로 각도도 체크

    ENABLE_DASH = 1,									-- 대쉬 가능한가?
    DASH_USE_RATIO = 0.7,								-- 대쉬가능할때 사용 확률(0~1)
    DASH_FORCE_USE_DELAY = 0.2,							-- 슬라이딩 후 강제로 대쉬 사용하게 되는 시간

    NORMAL_FRONT_CHECK_DIST = 10,						-- 일반 주행시의 앞쪽 길방향 체크 거리
    ENABLE_BLOCK_FRONT_CHECK = 0,						-- 앞쪽이 block되는지 체크를 하는가?
	ROAD_FOLLOW_SIDE_RATIO = 1,							-- 일반 주행시의 길 옆을 따라 가는 경향(0~1)
    ROAD_FOLLOW_SIDE_GAP_CHANGE_RATIO = 0.2,			-- 길 옆을 따라 갈때 위치를 다시 결정하는 빈도(0~1)
    ROAD_ANGLE_ADJUST_ATTACH_RATIO = 0.02,				-- 꺽일때 붙는 비율

    OBSTACLE_FAR_CHECK_DIST = 11,						-- 장애물 체크 먼거리
    OBSTACLE_NEAR_CHECK_DIST = 6.5,						-- 장애물 체크 단거리
    OBSTACLE_PREPARE_DEFAULT_JUMP_DIST = 25,			-- 장애물 체크 기본 거리
    OBSTACLE_DIST_ADJUST_BASIS_VELOCITY = AcKMpH(80),	-- 체크 거리 보정 시의 기본 속도
    OBSTACLE_DIST_ADJUST_VELOCITY_GAP_RATIO = 0.05,		-- 체크 거리 보정 시의 초과 속도에 따른 거리 비율
    OBSTACLE_SIMPLE_CHECK_DIST = 11,					-- simple check 거리

    -- 강제 밸런싱
    ENABLE_BALANCE = 0,									-- AI balance
}
-- 싱글 AI hard 크리스틴
SAI_hard4Param =
{
	ENABLE_COURBETTE = 1,								-- 초반 시작시 쿠르베트 가능 여부(0 or 1)
    COURBETTE_BASE_TIME = 1.5,							-- 쿠르베트 시작 시간(0~초)
    COURBETTE_START_ADJUST = 0,							-- 쿠르베트 시작 시간 조절값(0~초)
    COURBETTE_START_DELAY_ADJUST = 0,					-- 쿠르베트 실제 시작시 조절값(0~초)

    PREPARE_JUMP_OBSTACLE_ANGLE = 30,					-- 점프대를 탐지했을때) 넘으려고 점프대로 향하는 각도
    PREPARE_JUMP_OBSTACLE_CENTER_ADJUST = 0.3,			-- 현재 각도와 비례해서 점프대의 가운데에서 어느 위치로 넘을까(0~비율)
    JUMP_ENABLE_VELOCITY = AcKMpH(20),					-- 점프가 가능한 속도
    ENABLE_JUMP_CONTINUE = 1,							-- 연속 점프 가능 여부
    ENABLE_JUMP2ND = 1,									-- 2단 점프 가능 여부

    ENABLE_SPUR_USE = 1,								-- 박차 사용 가능한가?
    SPUR_SAVE_ON_FIRST_LAP = 1,							-- 첫바퀴째는 박차 3개되기 전까지 박차를 아끼는가?
    SPUR_UNUSED_BEFORE_LASTSPURT = 0,				    -- 라스트스퍼트 전까지 박차를 사용하지 않는가?
    SPUR_CHECK_FRONT_ROAD_DIST = 20,					-- 박차 사용시 직선 주행로 체크 거리
    SPUR_CHECK_FRONT_ROAD_ANGLE = 40,					-- 박차 사용시 직선 주행로 체크 각도
    SPUR_ENABLE_CONTINUE_USE = 1,						-- 연속 박차 사용이 가능한가?	
    SPUR_FORCE_USE_DELAY = 10,							-- 박차 사용 후 강제 delay(초)    

	ENABLE_FAR_DOWN_JUMP_CHECK = 1,       				-- far앞쪽 낭떠러지 판단 여부
	FAR_DOWN_JUMP_CHECK_DIST = 10,        				-- far앞쪽 낭떠러지 판단 거리
	FAR_DOWN_JUMP_CHECK_HEIGHT_1ST = -1,   				-- far앞쪽 낭떠러지 1단 점프 체크 높이(음수이면 무시)
	FAR_DOWN_JUMP_CHECK_HEIGHT_2ND = 10,   				-- far앞쪽 낭떠러지 2단 점프 체크 높이
	
	
    ENABLE_DOWN_JUMP_CHECK = 1,							-- 앞쪽 낭떠러지 판단 여부
    DOWN_JUMP_CHECK_DIST = 2.5,							-- 앞쪽 낭떠러지 판단 거리
    DOWN_JUMP_CHECK_HEIGHT_1ST = 0.7,					-- 앞쪽 낭떠러지 1단 점프 체크 높이
    DOWN_JUMP_CHECK_HEIGHT_2ND =  2.3,					-- 앞쪽 낭떠러지 2단 점프 체크 높이
	
	
    ENABLE_UP_GLIDING_CHECK = 1,						-- 앞쪽 언덕길 gliding 판단 여부
    UP_JUMP_CHECK_DIST = 5,								-- 앞쪽 언덕길 판단 거리
    UP_JUMP_CHECK_HEIGHT_1ST = 1.3,						-- 앞쪽 언덕길 1단 점프 체크 높이
    UP_JUMP_CHECK_HEIGHT_2ND = 2.3,						-- 앞쪽 언덕길 2단 점프 체크 높이
    UP_JUMP_CHECK_ADD_HEIGHT = 5,						-- 앞쪽 언덕길 추가 체크 높이
    
    NORMAL_ADJUST_ANGLE_GAP = 5,						-- 일반 주행시 조향 보정해주는 각도차
    JUMP_ADJUST_ANGLE_GAP = 3,							-- 점프 시 조향 보정해주는 각도차
    JUMP2ND_ADJUST_ANGLE_GAP = 5,						-- 2단 점프 시 조향 보정해주는 각도차
    JUMP_CONTINUE_ADJUST_ANGLE_GAP = 1,					-- 연속 점프 시 조향 보정해주는 각도차
    JUMP_TIMING_ADJUST_RATIO = 0.4,						-- 점프해야될때 점프타이밍 조절 확률(0~1)
	JUMP_TIMING_ADJUST_TIME = 0.5,						-- 점프해야될때 점프타이밍 조절 시간
    
    ENABLE_SLIDING = 1,									-- 슬라이딩 가능한가?
    SLIDING_ENABLE_MIN_VELOCITY = AcKMpH(65),			-- 슬라이딩 가능한 최소 속도
    SLIDING_STOP_MIN_VELOCITY = AcKMpH(65),				-- 슬라이딩 중단하는 최소 속도
    SLIDING_START_ANGLE = 12,							-- 슬라이딩 시작하는 각도차이
    SLIDING_DELAY_TIME = 0.3,							-- 슬라이딩 기본 딜레이
    SLIDING_ENABLE_THROTTLE_ANGLE = 70,					-- 슬라이딩시 전진키 누르는 각도
    ENABLE_KEEP_SLIDING_TO_DASH = 0,					-- 대쉬할때까지 슬라이딩을 하는가?
    SLIDING_STOP_CHECK_ANGLE = 3,						-- 슬라이딩 중단 체크하는 각도
    SLIDING_DASH_CHECK_ANGLE = 20,						-- 슬라이딩 중 대쉬 가능한 각도
    ENABLE_SLIDING_CANCEL_WHEN_OPPOSITE_SLIDING = 1,	-- 슬라이딩 중 반대쪽으로 슬라이딩 하는 경우
    ENABLE_SLIDING_CHECK_STOP_OPPOSITE_ANGLE = 1,		-- 슬라이딩 중 반대쪽으로 각도도 체크
    
    ENABLE_DASH = 1,									-- 대쉬 가능한가?
    DASH_USE_RATIO = 0.5,									-- 대쉬가능할때 사용 확률(0~1)
    DASH_FORCE_USE_DELAY = 0.5,							-- 슬라이딩 후 강제로 대쉬 사용하게 되는 시간
    
    ENABLE_CHECK_ITEM = 0,								-- 아이템 먹기 판단하는가?
  
    NORMAL_FRONT_CHECK_DIST = 3,						-- 일반 주행시의 앞쪽 길방향 체크 거리
    ENABLE_BLOCK_FRONT_CHECK = 1,						-- 앞쪽이 block되는지 체크를 하는가?	
    ENABLE_ROAD_ANGLE_ADJUST = 1,						-- 꺽이는 길 옆으로 붙는가?
    ROAD_FOLLOW_SIDE_RATIO = 1.5,						-- 일반 주행시의 길 옆을 따라 가는 경향(0~1)
    ROAD_FOLLOW_SIDE_GAP_CHANGE_RATIO = 1,				-- 길 옆을 따라 갈때 위치를 다시 결정하는 빈도(0~1)
    
    OBSTACLE_FAR_CHECK_DIST = 10,						-- 장애물 체크 먼거리
    OBSTACLE_NEAR_CHECK_DIST = 6,						-- 장애물 체크 단거리
    OBSTACLE_PREPARE_DEFAULT_JUMP_DIST = 25,			-- 장애물 체크 기본 거리
    OBSTACLE_DIST_ADJUST_BASIS_VELOCITY = AcKMpH(80),	-- 체크 거리 보정 시의 기본 속도
    OBSTACLE_DIST_ADJUST_VELOCITY_GAP_RATIO = 0.03,		-- 체크 거리 보정 시의 초과 속도에 따른 거리 비율
    OBSTACLE_SIMPLE_CHECK_DIST = 10,					-- simple check 거리

    -- 강제 밸런싱
    ENABLE_BALANCE = 0,									-- AI balance
}
-- 싱글 AI hard 라이라
SAI_hard5Param =
{
	ENABLE_COURBETTE = 1,								-- 초반 시작시 쿠르베트 가능 여부(0 or 1)
    COURBETTE_BASE_TIME = 1.5,							-- 쿠르베트 시작 시간(0~초)
    COURBETTE_START_ADJUST = 0.3,						-- 쿠르베트 시작 시간 조절값(0~초)
    COURBETTE_START_DELAY_ADJUST = 0.2,					-- 쿠르베트 실제 시작시 조절값(0~초)

    PREPARE_JUMP_OBSTACLE_ANGLE = 30,					-- 점프대를 탐지했을때) 넘으려고 점프대로 향하는 각도
    PREPARE_JUMP_OBSTACLE_CENTER_ADJUST = 0.2,			-- 현재 각도와 비례해서 점프대의 가운데에서 어느 위치로 넘을까(0~비율)
    
    ENABLE_SPUR_USE = 1,								-- 박차 사용 가능한가?
    SPUR_SAVE_ON_FIRST_LAP = 1,							-- 첫바퀴째는 박차 3개되기 전까지 박차를 아끼는가?
    SPUR_UNUSED_BEFORE_LASTSPURT = 0,				    -- 라스트스퍼트 전까지 박차를 사용하지 않는가?
    
    ENABLE_FAR_DOWN_JUMP_CHECK = 0,       				-- far앞쪽 낭떠러지 판단 여부
	
    NORMAL_ADJUST_ANGLE_GAP = 8,						-- 일반 주행시 조향 보정해주는 각도차
    JUMP_ADJUST_ANGLE_GAP = 5,							-- 점프 시 조향 보정해주는 각도차
    JUMP2ND_ADJUST_ANGLE_GAP = 5,						-- 2단 점프 시 조향 보정해주는 각도차
    JUMP_CONTINUE_ADJUST_ANGLE_GAP = 2,					-- 연속 점프 시 조향 보정해주는 각도차
    JUMP_TIMING_ADJUST_RATIO = 0.2,						-- 점프해야될때 점프타이밍 조절 확률(0~1)
	JUMP_TIMING_ADJUST_TIME = 0.3,						-- 점프해야될때 점프타이밍 조절 시간
    
    ENABLE_SLIDING = 1,									-- 슬라이딩 가능한가?
    SLIDING_START_ANGLE = 20,							-- 슬라이딩 시작하는 각도차이
    SLIDING_DELAY_TIME = 1,								-- 슬라이딩 기본 딜레이
    SLIDING_ENABLE_THROTTLE_ANGLE = 50,					-- 슬라이딩시 전진키 누르는 각도
    SLIDING_STOP_CHECK_ANGLE = 6,						-- 슬라이딩 중단 체크하는 각도
    SLIDING_DASH_CHECK_ANGLE = 10,						-- 슬라이딩 중 대쉬 가능한 각도
    ENABLE_SLIDING_CANCEL_WHEN_OPPOSITE_SLIDING = 0,	-- 슬라이딩 중 반대쪽으로 슬라이딩 하는 경우
    ENABLE_SLIDING_CHECK_STOP_OPPOSITE_ANGLE = 0,		-- 슬라이딩 중 반대쪽으로 각도도 체크

    ENABLE_DASH = 1,									-- 대쉬 가능한가?
    DASH_USE_RATIO = 0.7,								-- 대쉬가능할때 사용 확률(0~1)
    DASH_FORCE_USE_DELAY = 0.2,							-- 슬라이딩 후 강제로 대쉬 사용하게 되는 시간

    NORMAL_FRONT_CHECK_DIST = 10,						-- 일반 주행시의 앞쪽 길방향 체크 거리
    ENABLE_BLOCK_FRONT_CHECK = 0,						-- 앞쪽이 block되는지 체크를 하는가?
	ROAD_FOLLOW_SIDE_RATIO = 1,							-- 일반 주행시의 길 옆을 따라 가는 경향(0~1)
    ROAD_FOLLOW_SIDE_GAP_CHANGE_RATIO = 0.2,			-- 길 옆을 따라 갈때 위치를 다시 결정하는 빈도(0~1)
    ROAD_ANGLE_ADJUST_ATTACH_RATIO = 0.02,				-- 꺽일때 붙는 비율

    OBSTACLE_FAR_CHECK_DIST = 11,						-- 장애물 체크 먼거리
    OBSTACLE_NEAR_CHECK_DIST = 6.5,						-- 장애물 체크 단거리
    OBSTACLE_PREPARE_DEFAULT_JUMP_DIST = 25,			-- 장애물 체크 기본 거리
    OBSTACLE_DIST_ADJUST_BASIS_VELOCITY = AcKMpH(80),	-- 체크 거리 보정 시의 기본 속도
    OBSTACLE_DIST_ADJUST_VELOCITY_GAP_RATIO = 0.05,		-- 체크 거리 보정 시의 초과 속도에 따른 거리 비율
    OBSTACLE_SIMPLE_CHECK_DIST = 11,					-- simple check 거리

    -- 강제 밸런싱
    ENABLE_BALANCE = 0,									-- AI balance

}
-- 싱글 AIhard 해피
SAI_hard6Param =
{
   -- 강제 밸런싱
    ENABLE_BALANCE = 0,									-- AI balance
}
-- 싱글 AI hard 페퍼
SAI_hard7Param =
{
	ENABLE_COURBETTE = 1,								-- 초반 시작시 쿠르베트 가능 여부(0 or 1)
    COURBETTE_BASE_TIME = 1.5,							-- 쿠르베트 시작 시간(0~초)
    COURBETTE_START_ADJUST = 0,							-- 쿠르베트 시작 시간 조절값(0~초)
    COURBETTE_START_DELAY_ADJUST = 0,					-- 쿠르베트 실제 시작시 조절값(0~초)

    PREPARE_JUMP_OBSTACLE_ANGLE = 30,					-- 점프대를 탐지했을때) 넘으려고 점프대로 향하는 각도
    PREPARE_JUMP_OBSTACLE_CENTER_ADJUST = 0.3,			-- 현재 각도와 비례해서 점프대의 가운데에서 어느 위치로 넘을까(0~비율)
    JUMP_ENABLE_VELOCITY = AcKMpH(20),					-- 점프가 가능한 속도
    ENABLE_JUMP_CONTINUE = 1,							-- 연속 점프 가능 여부
    ENABLE_JUMP2ND = 1,									-- 2단 점프 가능 여부

    ENABLE_SPUR_USE = 1,								-- 박차 사용 가능한가?
    SPUR_SAVE_ON_FIRST_LAP = 1,							-- 첫바퀴째는 박차 3개되기 전까지 박차를 아끼는가?
    SPUR_UNUSED_BEFORE_LASTSPURT = 0,				    -- 라스트스퍼트 전까지 박차를 사용하지 않는가?
    SPUR_CHECK_FRONT_ROAD_DIST = 20,					-- 박차 사용시 직선 주행로 체크 거리
    SPUR_CHECK_FRONT_ROAD_ANGLE = 40,					-- 박차 사용시 직선 주행로 체크 각도
    SPUR_ENABLE_CONTINUE_USE = 1,						-- 연속 박차 사용이 가능한가?	
    SPUR_FORCE_USE_DELAY = 10,							-- 박차 사용 후 강제 delay(초)    

	ENABLE_FAR_DOWN_JUMP_CHECK = 1,       				-- far앞쪽 낭떠러지 판단 여부
	FAR_DOWN_JUMP_CHECK_DIST = 10,        				-- far앞쪽 낭떠러지 판단 거리
	FAR_DOWN_JUMP_CHECK_HEIGHT_1ST = -1,   				-- far앞쪽 낭떠러지 1단 점프 체크 높이(음수이면 무시)
	FAR_DOWN_JUMP_CHECK_HEIGHT_2ND = 10,   				-- far앞쪽 낭떠러지 2단 점프 체크 높이
	
	
    ENABLE_DOWN_JUMP_CHECK = 1,							-- 앞쪽 낭떠러지 판단 여부
    DOWN_JUMP_CHECK_DIST = 2.5,							-- 앞쪽 낭떠러지 판단 거리
    DOWN_JUMP_CHECK_HEIGHT_1ST = 0.7,					-- 앞쪽 낭떠러지 1단 점프 체크 높이
    DOWN_JUMP_CHECK_HEIGHT_2ND =  2.3,					-- 앞쪽 낭떠러지 2단 점프 체크 높이
	
	
    ENABLE_UP_GLIDING_CHECK = 1,						-- 앞쪽 언덕길 gliding 판단 여부
    UP_JUMP_CHECK_DIST = 5,								-- 앞쪽 언덕길 판단 거리
    UP_JUMP_CHECK_HEIGHT_1ST = 1.3,						-- 앞쪽 언덕길 1단 점프 체크 높이
    UP_JUMP_CHECK_HEIGHT_2ND = 2.3,						-- 앞쪽 언덕길 2단 점프 체크 높이
    UP_JUMP_CHECK_ADD_HEIGHT = 5,						-- 앞쪽 언덕길 추가 체크 높이
    
    NORMAL_ADJUST_ANGLE_GAP = 5,						-- 일반 주행시 조향 보정해주는 각도차
    JUMP_ADJUST_ANGLE_GAP = 3,							-- 점프 시 조향 보정해주는 각도차
    JUMP2ND_ADJUST_ANGLE_GAP = 5,						-- 2단 점프 시 조향 보정해주는 각도차
    JUMP_CONTINUE_ADJUST_ANGLE_GAP = 1,					-- 연속 점프 시 조향 보정해주는 각도차
    JUMP_TIMING_ADJUST_RATIO = 0.4,						-- 점프해야될때 점프타이밍 조절 확률(0~1)
	JUMP_TIMING_ADJUST_TIME = 0.5,						-- 점프해야될때 점프타이밍 조절 시간
    
    ENABLE_SLIDING = 1,									-- 슬라이딩 가능한가?
    SLIDING_ENABLE_MIN_VELOCITY = AcKMpH(65),			-- 슬라이딩 가능한 최소 속도
    SLIDING_STOP_MIN_VELOCITY = AcKMpH(65),				-- 슬라이딩 중단하는 최소 속도
    SLIDING_START_ANGLE = 12,							-- 슬라이딩 시작하는 각도차이
    SLIDING_DELAY_TIME = 0.3,							-- 슬라이딩 기본 딜레이
    SLIDING_ENABLE_THROTTLE_ANGLE = 70,					-- 슬라이딩시 전진키 누르는 각도
    ENABLE_KEEP_SLIDING_TO_DASH = 0,					-- 대쉬할때까지 슬라이딩을 하는가?
    SLIDING_STOP_CHECK_ANGLE = 3,						-- 슬라이딩 중단 체크하는 각도
    SLIDING_DASH_CHECK_ANGLE = 20,						-- 슬라이딩 중 대쉬 가능한 각도
    ENABLE_SLIDING_CANCEL_WHEN_OPPOSITE_SLIDING = 1,	-- 슬라이딩 중 반대쪽으로 슬라이딩 하는 경우
    ENABLE_SLIDING_CHECK_STOP_OPPOSITE_ANGLE = 1,		-- 슬라이딩 중 반대쪽으로 각도도 체크
    
    ENABLE_DASH = 1,									-- 대쉬 가능한가?
    DASH_USE_RATIO = 0.5,									-- 대쉬가능할때 사용 확률(0~1)
    DASH_FORCE_USE_DELAY = 0.5,							-- 슬라이딩 후 강제로 대쉬 사용하게 되는 시간
    
    ENABLE_CHECK_ITEM = 0,								-- 아이템 먹기 판단하는가?
  
    NORMAL_FRONT_CHECK_DIST = 3,						-- 일반 주행시의 앞쪽 길방향 체크 거리
    ENABLE_BLOCK_FRONT_CHECK = 1,						-- 앞쪽이 block되는지 체크를 하는가?	
    ENABLE_ROAD_ANGLE_ADJUST = 1,						-- 꺽이는 길 옆으로 붙는가?
    ROAD_FOLLOW_SIDE_RATIO = 1.5,						-- 일반 주행시의 길 옆을 따라 가는 경향(0~1)
    ROAD_FOLLOW_SIDE_GAP_CHANGE_RATIO = 1,				-- 길 옆을 따라 갈때 위치를 다시 결정하는 빈도(0~1)
    
    OBSTACLE_FAR_CHECK_DIST = 10,						-- 장애물 체크 먼거리
    OBSTACLE_NEAR_CHECK_DIST = 6,						-- 장애물 체크 단거리
    OBSTACLE_PREPARE_DEFAULT_JUMP_DIST = 25,			-- 장애물 체크 기본 거리
    OBSTACLE_DIST_ADJUST_BASIS_VELOCITY = AcKMpH(80),	-- 체크 거리 보정 시의 기본 속도
    OBSTACLE_DIST_ADJUST_VELOCITY_GAP_RATIO = 0.03,		-- 체크 거리 보정 시의 초과 속도에 따른 거리 비율
    OBSTACLE_SIMPLE_CHECK_DIST = 10,					-- simple check 거리

    -- 강제 밸런싱
    ENABLE_BALANCE = 0,									-- AI balance
}

-- Poor
PrologueAIParam =
{
	-- 스탯 리미트
	ENABLE_LIMIT_STAT = 1,								-- 스탯 관련 제한
	LIMIT_STAT_MAXSPEED = 30,							-- 최대속도 제한 ( 0이면 무시 )
}

----------------------------------------------------------------------------------------------------------------
--
--					기본값 설정( source  -->  target )
-- target쪽에 설정안된 값은 source를 참고한다.
--
----------------------------------------------------------------------------------------------------------------
-- 기본 효과 설정
SET_DEFAULT( DefaultAIParam, ExpertAIParam )
SET_DEFAULT( DefaultAIParam, Expert2AIParam )
SET_DEFAULT( DefaultAIParam, PoorAIParam )
SET_DEFAULT( DefaultAIParam, AverageAIParam )
SET_DEFAULT( DefaultAIParam, BeginnerAIParam ) -- 초보자케어용
SET_DEFAULT( DefaultAIParam, Beginner2AIParam ) -- 초보자케어용2(중수급)
SET_DEFAULT( DefaultAIParam, SAI_easy1Param ) -- 싱글 AI easy 데코짱
SET_DEFAULT( DefaultAIParam, SAI_easy2Param ) -- 싱글 AI easy 아뭐래
SET_DEFAULT( DefaultAIParam, SAI_easy3Param ) -- 싱글 AI easy 마지막도미
SET_DEFAULT( DefaultAIParam, SAI_easy4Param ) -- 싱글 AI easy 앙뉴
SET_DEFAULT( DefaultAIParam, SAI_easy5Param ) -- 싱글 AI easy 그아이리스
SET_DEFAULT( DefaultAIParam, SAI_easy6Param ) -- 싱글 AI easy 뉴뉴
SET_DEFAULT( DefaultAIParam, SAI_easy7Param ) -- 싱글 AI easy 해달귀요미
SET_DEFAULT( DefaultAIParam, SAI_nomal1Param ) -- 싱글 AI nomal 해임마
SET_DEFAULT( DefaultAIParam, SAI_nomal2Param ) -- 싱글 AI nomal 식이
SET_DEFAULT( DefaultAIParam, SAI_nomal3Param ) -- 싱글 AI nomal 재드래곤
SET_DEFAULT( DefaultAIParam, SAI_nomal4Param ) -- 싱글 AI nomal 메타기어
SET_DEFAULT( DefaultAIParam, SAI_nomal5Param ) -- 싱글 AI nomal 미캉
SET_DEFAULT( DefaultAIParam, SAI_nomal6Param ) -- 싱글 AI nomal 라스타방
SET_DEFAULT( DefaultAIParam, SAI_nomal7Param ) -- 싱글 AI nomal 배째
SET_DEFAULT( DefaultAIParam, SAI_hard1Param ) -- 싱글 AI hard 라크넷
SET_DEFAULT( DefaultAIParam, SAI_hard2Param ) -- 싱글 AI hard 대나무다
SET_DEFAULT( DefaultAIParam, SAI_hard3Param ) -- 싱글 AI hard 공원님
SET_DEFAULT( DefaultAIParam, SAI_hard4Param ) -- 싱글 AI hard 카니
SET_DEFAULT( DefaultAIParam, SAI_hard5Param ) -- 싱글 AI hard 야생루비
SET_DEFAULT( DefaultAIParam, SAI_hard6Param ) -- 싱글 AI hard 파워다이어리
SET_DEFAULT( DefaultAIParam, SAI_hard7Param ) -- 싱글 AI hard 스위티
SET_DEFAULT( PoorAIParam, PrologueAIParam )		-- 프롤로그 초반 걷기용 AI



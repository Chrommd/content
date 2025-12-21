------------------------------------------------------------
--		RoadLimiter ResetType
------------------------------------------------------------
RESET_NONE				= 0     -- 리셋 안함
RESET_BOTTOM			= 1     -- 아래쪽에서 리셋
RESET_1ST				= 2		-- 1등 위치로 리셋

------------------------------------------------------------
--		eMissionEvent : GlobalEnum.h
------------------------------------------------------------
EVENT_UI_CLOSE			= 1     -- UI 닫음
EVENT_PLAYER_INPUT		= 2     -- 사용자 키입력
EVENT_PLAYER_ACTION		= 3		-- 사용자 행동
EVENT_ENTER_POSITION	= 4		-- 특정 위치 도착
EVENT_GET_ITEM			= 5     -- 아이템 획득
EVENT_USE_ITEM			= 6		-- 아이템 사용
EVENT_TIMER				= 7		-- 타이머 이벤트
EVENT_SCRIPT			= 8		-- 스크립트에서 발생한 이벤트
EVENT_TRIGGER			= 9		-- 맵에 지정된 트리거를 작동시킨 경우
EVENT_WAIT				= 10	-- 대기 상태
EVENT_RECORD            = 11    -- 미션 기록 남기기
EVENT_GAME				= 12	-- 게임로직 관련 이벤트
EVENT_CAMERA_STOP		= 13	-- 카메라 종료 이벤트
EVENT_PATROL_END		= 14	-- patrol end
EVENT_PATROL_NEXT		= 15	-- patrol next
EVENT_HORSE_ACTION_END	= 16	-- horse action end
EVENT_UI				= 17	-- ui event
EVENT_AREA_ENTER		= 18	-- 왕뜨 -AREA[XXXX] 들어가고
EVENT_AREA_LEAVE		= 19	-- 왕뜨 -AREA[XXXX] 나갈때
EVENT_NPC_CHAT			= 20	-- NPC와 대화중 발생
EVENT_ACTIVE_CONTENT	= 21	-- 작동한 미션 상태
EVENT_PLAYER_COLLISION	= 22	-- player와 충돌
EVENT_CALL_NPC			= 23	-- NPC 호출
EVENT_ORDER_NPC			= 24	-- NPC에게 명령
EVENT_CALLED_NPC		= 25	-- 호출당한 NPC
EVENT_CALL_NPC_RESULT	= 26	-- 호출 결과
EVENT_NPC_FOLLOWING_END = 27	-- NPC가 쫓아다니는 것 끝
EVENT_DEV_SET_MOUNT_CONDITION = 28  -- [개발용] mount condition 값 설정
EVENT_NPC_FOLLOW_START	= 29	-- NPC가 플레이어 쫓아다닌다.
EVENT_CHANGE_MOUNT		= 30	-- 플레이어가 말을 갈아탄 경우
EVENT_GAME_STEP			= 31	-- GameStep 변경
EVENT_DEV_SET_GROUP_FORCE = 32	-- mount group force(기세) 변경
EVENT_FUN_KNOCKBACK		= 33	-- 재미로 knockback(양치기)
EVENT_FUN_KNOCKBACK_INFO= 34	-- 재미로 knockback(양치기) 정보
EVENT_SHEEP_COIN_DROP	= 35	-- 양치기 캐롯 드랍
EVENT_WAVE_START		= 36	-- 디펜스 WAVE 시작
EVENT_WAVE_END			= 37	-- 디펜스 WAVE 종료

------------------------------------------------------------
--		eMissionContent : GlobalEnum.h
------------------------------------------------------------
CONTENT_EXERCISE		= 1		-- 목장 한바퀴

------------------------------------------------------------
--		eNpcChatEvent : GlobalEnum.h
------------------------------------------------------------
NPCCHATEVENT_ASSIGNHORSENAME	= 0	-- 말 이름 지어졌다.
NPCCHATEVENT_BALLOONRESULT		= 1 -- 풍선 터뜨리기 결과

------------------------------------------------------------
--
-- 스크립트에서 정의된 이벤트 값
--
------------------------------------------------------------
CS_EVENT_LOAD_COMPLETE		= 1001		-- 이거는 globalEnum.h의 eMissionEventValueType 값과 같아야 한다.
CS_EVENT_MISSION_START		= 1002
SC_EVENT_MISSION_END_WAIT	= 1003
SC_EVENT_MISSION_END		= 1004
CS_EVENT_MISSION_RESULT		= 1005
SC_EVENT_MISSION_START		= 1006
SC_EVENT_MISSION_GOALIN		= 1007
SC_EVENT_MISSION_RESULT		= 1008
SC_EVENT_MISSION_PLAY_TIMER	= 1009
CS_EVENT_OPENING_COMPLETE	= 1010
SC_EVENT_OPENING_COMPLETE	= 1011
SC_EVENT_MISSION_DEAD_WAIT	= 1012
CS_EVENT_MISSION_RESURRECT	= 1013
SC_EVENT_MISSION_DEAD_WAIT_CANCEL	= 1014
CS_EVENT_MISSION_RETRY		= 1015
CS_EVENT_MISSION_GO_NEXT	= 1016

SC_EVENT_ADD_BOSS			= 1099
SC_EVENT_ADD_NPC			= 1100
SC_EVENT_ROAD_DEPTH			= 1101
SC_EVENT_ROAD_DEPTH_GAP		= 1102
SC_EVENT_ACQUIRE_ITEM		= 1103		
SS_EVENT_ACTIVATE_OBJECT	= 1104
SC_EVENT_BEGIN_TRACE_PLAYER	= 1105
SC_EVENT_END_TRACE_PLAYER	= 1106
SS_EVENT_ARRIVED			= 1107
SS_EVENT_ATTACK_OBJECT		= 1108
SC_EVENT_ATTACK_OBJECT		= 1109
SC_EVENT_INCIDENT			= 1110
SC_EVENT_SCENE_START		= 1111
SC_EVENT_SCENE_END			= 1112
SC_EVENT_SCORE_RED			= 1113
SC_EVENT_SCORE_BLUE			= 1114
SC_EVENT_RESURRECT			= 1115
SC_EVENT_DEAD_COUNT			= 1116
SC_EVENT_KILL_COUNT			= 1117
CS_EVENT_FIRST_PLAYER_IN	= 1118
CS_EVENT_FIRST_PLAYER_OUT	= 1119
SC_EVENT_FIRST_PLAYER_IN	= 1120
SC_EVENT_FIRST_PLAYER_OUT	= 1121
SC_EVENT_BOSS_RUNAWAY		= 1122
SS_EVENT_MONSTER_DEAD		= 1123
CS_EVENT_PLAYER_REFLECTION  = 1124

SS_EVENT_HORSE_ANGRY		= 2001
SC_EVENT_HORSE_LEAVE_RANCH  = 2002
SS_EVENT_HORSE_LEADER_BUSY	= 2003
SS_EVENT_HORSE_PAIR_MOVE	= 2004
SS_EVENT_HORSE_LEADER_PARADE = 2005

EVENT_SCENE1	= 1
EVENT_SCENE2	= 2
EVENT_SCENE3	= 3
EVENT_SCENE4	= 4
EVENT_SCENE5	= 5
EVENT_SCENE6	= 6
EVENT_SCENE7	= 7
EVENT_SCENE8	= 8
EVENT_SCENE9	= 9

PLAYER_ACTION_REFLECTION = 1000
PLAYER_ACTION_HIT_BALLOON = 1001
PLAYER_ACTION_HIT_BALLOON_COMPLETE = 1002

MISSIONRESULT_CANCEL	= 0
MISSIONRESULT_FAILED	= 1
MISSIONRESULT_SUCCESS	= 2
MISSIONRESULT_REDWIN	= 3
MISSIONRESULT_BLUEWIN	= 4
MISSIONRESULT_DRAW		= 5

MISSIONRECORD_MINTIME           = 0
MISSIONRECORD_MAXTIME           = 1
MISSIONRECORD_SUCCESSCOUNT      = 2
MISSIONRECORD_FAILCOUNT         = 3
MISSIONRECORD_GAINCOUNT         = 4
MISSIONRECORD_SUCCESSOPTIONFLAG = 5

-- RcLogicForceAction::eActionState
ACTIONSTATE_NONE				= 0
ACTIONSTATE_JUMP				= 1
ACTIONSTATE_JUMP2ND				= 2
ACTIONSTATE_GLIDING				= 3
ACTIONSTATE_SPUR				= 4

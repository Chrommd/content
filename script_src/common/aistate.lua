-- AI용 전역 변수

------------------------------------------------------------
--		AcInputType
------------------------------------------------------------
-- 키보드 입력값: AcInputStation.h의 AcInputType값 - client code에서 직접 가져와야 한다.
IT_DOWN		= 0   -- 버튼이 처음 눌렸을때
IT_UP		= 1   -- 버튼이 놓였을때
IT_PRESS	= 2   -- 버튼을 누루고 있을때 (IT_DOWN 일때도 포함)
IT_VALUE	= 3   -- 버튼의 현재 입력값
IT_DCLICK	= 4

------------------------------------------------------------
--		AcInputType
------------------------------------------------------------
KEYMAPCODE_THROTTLE     = 1
KEYMAPCODE_TURN_LEFT    = 2
KEYMAPCODE_TURN_RIGHT   = 3
KEYMAPCODE_BRAKE        = 4
KEYMAPCODE_ACTION       = 5
KEYMAPCODE_SLIDING      = 6
KEYMAPCODE_JUMP         = 7
KEYMAPCODE_CEREMONY     = 8
KEYMAPCODE_RESET_POSITION = 9
KEYMAPCODE_INGAME_MAP   = 10
KEYMAPCODE_CAM_CHANGE   = 11
KEYMAPCODE_CAM_BACKVIEW = 12

------------------------------------------------------------
--		AI State : client랑 관계없다.
------------------------------------------------------------
-- 이 STATE는 script안에서만 독립적으로 사용되는 값이다.
STATE_NONE		= 0
STATE_IDLE		= 1
STATE_PATROL	= 2
STATE_FOLLOW	= 3
STATE_LEAD		= 4
STATE_DEAD		= 5
STATE_INIT		= 6
STATE_ATTACK	= 7
STATE_WAIT		= 8
STATE_ATTACK1	= 9
STATE_ATTACK2	= 10
STATE_ATTACK3	= 11
STATE_ATTACK4	= 12
STATE_ATTACK5	= 13
STATE_ATTACK6	= 14
STATE_ATTACK7	= 15
STATE_ATTACK8	= 16
STATE_ATTACK9	= 17
STATE_WEAK1		= 18
STATE_WEAK2		= 19
STATE_WEAK3		= 20
STATE_WEAK4		= 21
STATE_WEAK5		= 22
STATE_EVENT		= 23
STATE_EVENT1	= 24
STATE_EVENT2	= 25
STATE_EVENT3	= 26
STATE_EVENT4	= 27
STATE_EVENT5	= 28
STATE_EVENT6	= 29
STATE_EVENT7	= 30
STATE_EVENT8	= 31
STATE_EVENT9	= 32
STATE_HIDE		= 33
STATE_CALLED	= 34
STATE_DEAD_IM  = 35

------------------------------------------------------------
--		AI motion state : client랑 관계없다.
------------------------------------------------------------
MOTION_NONE		= 0
MOTION_IDLE		= 1
MOTION_MOVE		= 2
MOTION_ATTACK	= 3
MOTION_FIRE		= 4
MOTION_ATTACKED	= 5
MOTION_DEAD		= 6
MOTION_INIT		= 7
MOTION_JUMP		= 8
MOTION_ATTACK1	= 9
MOTION_ATTACK2	= 10
MOTION_ATTACK3	= 11
MOTION_ATTACK4	= 12
MOTION_ATTACK5	= 13
MOTION_ATTACK6	= 14
MOTION_ATTACK7	= 15
MOTION_ATTACK8	= 16
MOTION_ATTACK9	= 17
MOTION_ATTACKED1 = 18
MOTION_ATTACKED2 = 19
MOTION_ATTACKED3 = 20
MOTION_ATTACKED4 = 21
MOTION_ATTACKED5 = 22
MOTION_ATTACKED6 = 23
MOTION_ATTACKED7 = 24
MOTION_ATTACKED8 = 25
MOTION_ATTACKED9 = 26
MOTION_GLIDE	 = 27
MOTION_DEAD_START =28
MOTION_DASH		= 29
MOTION_ANI1		= 30
MOTION_ANI2		= 31
MOTION_ANI3		= 32
MOTION_ANI4		= 33
MOTION_ANI5		= 34
MOTION_ANI6		= 35
MOTION_ANI7		= 36
MOTION_ANI8		= 37
MOTION_ANI9		= 38
MOTION_MOVE1	= 39
MOTION_MOVE2	= 40
MOTION_MOVE3	= 41
MOTION_MOVE4	= 42
MOTION_MOVE5	= 43
MOTION_TURN_L	= 44
MOTION_TURN_R	= 45
MOTION_GREETING = 46
MOTION_EAT_FOOD	= 47
MOTION_EAT_FOOD_END	= 48
MOTION_ANI10	= 49
MOTION_ANI11	= 50
MOTION_ANI12	= 51
MOTION_ANI13	= 52
MOTION_ANI14	= 53
MOTION_ANI15	= 54
MOTION_ANI16	= 55
MOTION_ANI17	= 56
MOTION_ANI18	= 57
MOTION_ANI19	= 58
MOTION_COLLISION = 59
MOTION_COLLISION_END = 60

------------------------------------------------------------
-- only script
------------------------------------------------------------
RUNAWAY_RANDOM		= 1
RUNAWAY_SIDE			= 2
RUNAWAY_FRONT		= 3

------------------------------------------------------------
-- MonsterType : global enum
------------------------------------------------------------
MONSTER_TYPE_HOSTILE = 1
MONSTER_TYPE_FRIENDLY = 2

------------------------------------------------------------
-- MoveType : global enum
------------------------------------------------------------
MOVE_TYPE_GROUND = 0
MOVE_TYPE_FLYING = 1
MOVE_TYPE_UNDERGROUND = 2


------------------------------------------------------------
-- 아이템 ID
------------------------------------------------------------
ITEM_SUGAR		= 2
ITEM_CARROT		= 3
ITEM_APPLE		= 4
ITEM_STAR		= 101
ITEM_STAR2		= 102
ITEM_HP			= 301
ITEM_MP			= 302
ITEM_SPUR		= 303
ITEM_SPECIAL	= 304

------------------------------------------------------------
-- item spawn style
------------------------------------------------------------
ITEM_SPAWN_STYLE_NONE	= 0
ITEM_SPAWN_STYLE_POPUP	= 1
ITEM_SPAWN_STYLE_DANGLE = 2
ITEM_SPAWN_STYLE_ROAD	= 3

------------------------------------------------------------
-- RcMob::eKnockbackStyle
------------------------------------------------------------
KNOCKBACK_NORMAL	= 0
KNOCKBACK_JUMP		= 1
KNOCKBACK_RUSH		= 2
KNOCKBACK_DAMAGE	= 3
KNOCKBACK_UPPER		= 4
KNOCKBACK_GLIDING	= 5
KNOCKBACK_SLIDING	= 6
KNOCKBACK_SURPRISE  = 7
    
------------------------------------------------------------
-- GazeType
------------------------------------------------------------
GAZE_NONE			= 0
GAZE_ATTACK			= 1		-- 공격하려고 바라보기
GAZE_FAVOR			= 2		-- 좋아서 바라보기(쓰일지는 의문?)
GAZE_IGNORE			= 3		-- 무시하면서 바라보기? -_-

------------------------------------------------------------
-- HP/MP max 설정 상태
------------------------------------------------------------
HP_INITIALIZE		= 0		-- 최초 상태
HP_HEAL				= 1		-- 힐

------------------------------------------------------------
-- eTeam
------------------------------------------------------------
TEAM_NONE			= 0
TEAM_NEUTRAL		= 1
TEAM_A				= 2
TEAM_B				= 3


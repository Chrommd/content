-- module setup
require ('BodyHelper')

--module(..., package.seeall)

-- 몬스터 모양 설정
g_body['horse'] = 
{

-- dff file
file  = "h04",

-- link
link = 
{
	{ id=1, class="RcTail", file="h000_tl", link="tail" },
	--{ id=2, class="RcSimpleAsset", file="r00_wa02_00", link="head" },
	{ id=3, class="RcRiderPuppet", file="r00", link="sit", args="-simple -multiParts -prefix[r00]" },	
},

-- 추가 argument
args  = "-prefix[h000] -nodefault -keymapper -nohp",

-- logic link
logic = 
{ 
	--"RcLogicApplyFeature", 
	--"RcLogicJump", 
	--"RcLogicPowerBrake", 
	--"RcLogicSpur", 
	--"RcLogicStarting", 
	"RcLogicMove", 
	"RcLogicEffect", 
	"RcLogicVelocityAdjust", 
},

-- 제일 앞에게 default state다. ani가 특별히 없으면 default가 된다.
states = 
{
	"IDLE",
	"IDLE1",

	"MOVE_1ST",
	"MOVE_1ST_L",
	"MOVE_1ST_R",
	"MOVE_2ND",
	"MOVE_2ND_L",
	"MOVE_2ND_R",
	"MOVE_3RD",
	"MOVE_3RD_L",
	"MOVE_3RD_R",
	"BOOSTER",
	"BOOSTER_START",
	"BOOSTER__",
	"DASH_L",
	"DASH_R",

	"SWIM_IDLE",
	"SWIM_IDLETO1ST",
	"SWIM_1ST",
	"SWIM_1STTOIDLE",
	"SWIM_2ND",
	"SWIM_L",
	"SWIM_R",
	"SWIM_SPUR",

	"REVERSE",

	"BRAKE",
	"BRAKE_END",

	"JUMP",
	"JUMP_AIR",
	"JUMP2",
	"JUMP2_AIR",
	"GLIDE",
	"GLIDE_SPUR",
	"FALL",
	"FALL_HIGH",
	"FALL_AIR",
	"FALL_AIR_HIGH",

	"TURN_L",
	"TURN_R",

	"SKID_L",
	"SKID_L_FAIL",
	"SKID_L_SUCCESS",
	"SKID_R",
	"SKID_R_FAIL",
	"SKID_R_SUCCESS",

	"POWERBRAKE_L",
	"POWERBRAKE_R",

	"WINNER",
	"WINNER_END",

	"COURBETTE",
	"COURBETTE_SUCCESS",
	"COURBETTE_FAIL",

	"COLWALL_FRONT_1ST",
	"COLWALL_FRONT_2ND",
	"COLWALL_FRONT_3RD",
	"COLWALL_SIDE_1ST_L",
	"COLWALL_SIDE_1ST_R",
	"COLWALL_SIDE_2ND_L_A",
	"COLWALL_SIDE_2ND_R_A",
	"COLWALL_SIDE_2ND_L_B",
	"COLWALL_SIDE_2ND_R_B",
	"COLWALL_SIDE_3RD_L_A",
	"COLWALL_SIDE_3RD_R_A",
	"COLWALL_SIDE_3RD_L_B",
	"COLWALL_SIDE_3RD_R_B",
	"COLWALL_SLIDE_2ND_L",
	"COLWALL_SLIDE_2ND_R",
	"COLWALL_SLIDE_3RD_L",
	"COLWALL_SLIDE_3RD_R",

	"COLOBJ_1ST",
	"COLOBJ_2ND",
	"COLOBJ_2ND_L",
	"COLOBJ_2ND_R",
	"COLOBJ_3RD",
	"COLOBJ_3RD_L",
	"COLOBJ_3RD_R",

	"COLJUMP_STRONG_R",
	"COLJUMP_STRONG_L",
	"COLJUMP_WEAK_R",
	"COLJUMP_WEAK_L",
	"COLJUMP_AIR",
	"COLJUMP_FALL",

	"LAND_1ST",
	"LAND_2ND",
	"LAND_3RD",
	"LAND_LOW",
	"LAND_HIGH",

	"STAND_IDLE",

	"ITEM_BOW_DMG",
	"ITEM_DRAGON_DMG",

	"MOVE_START",

	"GETOFF_START",
	"GETOFF_JUMP_AIR",
	"GETOFF_JUMP",
	"GETOFF_RUN",
	"GETOFF_LAND_EVENT",
	"GETOFF_LAND_NORMAL",
},

-- 이동속도M
velocity = 10,

approach_dist = 2.5,

}

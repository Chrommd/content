require('logichelper')

--
-- Event - 이벤트용
--

	effect1 = 0
	effect2 = 0

EventScript =
{
    FogDistance = function(near, far, t)
        Set_FogDistance(near, far, t)
        return true
    end,

    FogColor = function(red, green, blue, t)
        Set_FogColor(red,green,blue,t)
        return true
    end,

    AttachFxSelf = function(fxname, dummyname, autoremove)
        oid = util:GetMyOID()
        return util:AttachFx_User(fxname, oid, dummyname, autoremove)
    end,

    RemoveFx = function(heffect)
        GameUtil:RemoveFx(heffect)
        return true
    end,

    DefaultFogColor = function(t)
        Set_DefaultFogColor(t)
        return true
    end,

    DefaultFogDistance = function(t)
        Set_DefaultFogDistance(t)
        return true
    end,
}

EventArea =
{
	Event_Test_enter = function ()
		Set_FogColor(255,255,0,1)
		return true
	end,	

	Event_Test_leave = function ()
		Set_FogColor(255,0,0,1)
		return true
    end,
	
	Event_RainTest = function ()
		oid = util:GetMyOID()
		util:AttachFx_User("bg_rain", oid, "root", false)
	end,

	Event_HeavyRainTest = function ()
		oid = util:GetMyOID()
		Set_FogColor(0,0,0,3)
		util:AttachFx_User("bg_rain", oid, "root", false)
		util:AttachFx_User("bg_rain", oid, "root", false)
	end,

-----------------------------------------------------------------------------------------------------------------------

        --리버스맵 실프언덕
        --회전하는 부분의 포그변화
        
        ri_land07_01_enter = function ()
		Set_FogDistance(0.00, 0.900, 1)
		Set_FogColor(170,199,203,2)
		return true
        end,

	ri_land07_01_leave = function ()
                Set_FogDistance(0.50, 0.550, 1)
		Set_FogColor(102,171,181,1)
		return true
        end,





        --클라에스 시장길 포그변화
        --마을 지나 스타트부분을 만나는 곳 까지

        ri_land06_00_enter = function ()
		Set_FogDistance(0.00, 0.580, 2)
		Set_FogColor(74,53,26,2)
		return true
        end,

	ri_land06_00_leave = function ()
                Set_FogDistance(0.00, 0.550, 2)
		Set_FogColor(157,102,31,2)
		return true

        end,


        --스타트 부분 포그 변화


        ri_land06_01_enter = function ()
		Set_FogDistance(0.00, 0.600, 1)
		Set_FogColor(39,29,9,1)
		return true
        end,

	ri_land06_01_leave = function ()
                Set_FogDistance(0.00, 0.550, 1)
		Set_FogColor(157,102,31,1)
		return true

        end,

-----------------------------------------------------------------------------------------------------------------------
        
        --실리온 해안길 포그변화와 거리

        --마을 입구 부터 성 앞까지
        ri_dorf03_test_00_enter = function ()
		Set_FogDistance(0.00, 0.900, 2)
		Set_FogColor(114,185,207,2)
		return true
        end,

	ri_dorf03_test_00_leave = function ()
		return true

        end,

-----------------------------------------------------------------------------------------------------------------------

        --아킨즈 사막 맵 모래바람 언덕 마을지점


        sand01_sand01_enter = function ()
		Set_FogDistance(0.45, 1.050, 8)
		Set_FogColor(104,131,139,8)
		oid = GameUtil:GetMyOID()
		--특정위치에 효과발생
		--effect2 = GameUtil:AttachFx("aad", x,y,z )
		effect1 = GameUtil:AttachFx_User("bg_sandstorm", oid, "root", false)
		--effect2 = GameUtil:AttachFx_User("bg_sandstorm", oid, "root", false)
		return true
        end,

        sand01_sand01_leave = function ()
		GameUtil:RemoveFx(effect1)
		return true
        end,


	-------------------------------------------------------------------------------


-----------------------------------------------------------------------------------------------------------------------

        --시상식 사막 맵 모래바람.


        award_sand_enter = function ()
		Set_FogDistance(0.45, 1.050, 8)
		Set_FogColor(104,131,139,8)
		oid = GameUtil:GetMyOID()
		--특정위치에 효과발생
		--effect2 = GameUtil:AttachFx("aad", x,y,z )
		effect1 = GameUtil:AttachFx_User("bg_sandstorm", oid, "root", false)
		--effect2 = GameUtil:AttachFx_User("bg_sandstorm", oid, "root", false)
		return true
        end,

        sand01_sand01_leave = function ()
		GameUtil:RemoveFx(effect1)
		return true
        end,


	-------------------------------------------------------------------------------




        
        --도르프 무역항 dorf02 포그값 총 4군데 

        --메인스타트
	ri_dorf02_sta01_enter = function ()
		Set_FogDistance(0.00, 0.650, 3)
		Set_FogColor(133,91,36,3)
		return true
        end,

	ri_dorf02_sta01_leave = function ()
		return true

        end,





        --초중부 집 구간
        ri_dorf02_sta02_enter = function ()
		Set_FogDistance(0.00, 0.700, 3)
		Set_FogColor(46,56,60,3)
		return true
        end,

	ri_dorf02_sta02_leave = function ()
		return true

        end,





        --중앙 술집과 그 이후 구간
        ri_dorf02_sta03_enter = function ()
		Set_FogDistance(0.00, 0.700, 3)
		Set_FogColor(46,56,60,3)
		return true
        end,

	ri_dorf02_sta03_leave = function ()
		return true

        end,





        --공장
        ri_dorf02_fac01_enter = function ()
		Set_FogDistance(0.00, 0.650, 3)
		Set_FogColor(69,44,30,3)
		return true
        end,

	ri_dorf02_fac01_leave = function ()
		return true

        end,


-----------------------------------------------------------------------------------

	--울랜숲 이벤트

        --포그관련
        



        --초반 크리스탈 다리부분
        ri_fore01_id00_enter = function ()
		Set_FogDistance(0.00, 0.500, 2)
		Set_FogColor(101,123,88,2)
		return true

	end,

        ri_fore01_id00_leave = function ()
		Set_FogDistance(0.00, 0.750, 2)
		Set_FogColor(113,157,158,2)
		return true

        end,






        --지하던젼
        ri_fore01_id01_enter = function ()
		Set_FogDistance(0.00, 0.250, 2)
		Set_FogColor(100,230,248,1)
		return true

	end,

        ri_fore01_id01_leave = function ()
		Set_FogDistance(0.00, 0.750, 2)
		Set_FogColor(113,157,158,2)
		return true

        end,






        --얼굴석상 초입부
        ri_fore01_00_enter = function ()
		Set_FogDistance(0.00, 0.700, 2)
		Set_FogColor(194,193,150,2)
		return true

	end,

        ri_fore01_00_leave = function ()
		Set_FogDistance(0.00, 0.800, 3)
		Set_FogColor(48,60,51,3)
		return true

        end,





        --메인숲속
	ri_fore01_01_enter = function ()
		Set_FogDistance(0.00, 0.340, 3)
		Set_FogColor(47,142,127,4)
		return true
        end,

	ri_fore01_01_leave = function ()
		return true
        end,


        --마지막 골인지점부
        ri_fore01_02_enter = function ()
		Set_FogDistance(0.00, 0.550, 4)
		Set_FogColor(149,201,194,3)
		return true
        end,

	ri_fore01_02_leave = function ()
		return true
        end,
	












        --비 

--	fore01_rain_enter = function ()
--		Set_FogDistance(0.00, 0.360, 4)
--		Set_FogColor(47,142,127,4)
--		oid = util:GetMyOID();
--		effect1 = util:AttachFx_User("bg_rain", oid, "root", false)
--		effect2 = util:AttachFx_User("bg_rain", oid, "root", false)
--		return true
--      end,
--
--      fore01_box01_rain_enter = function ()
--		util:RemoveFx(effect1)
--		util:RemoveFx(effect2)
--		return true
--
--      end,
--
--      fore01_box01_rain_leave = function ()
--		Set_FogDistance(0.00, 0.360, 4)
--		Set_FogColor(47,142,127,4)
--		oid = util:GetMyOID();
--		effect1 = util:AttachFx_User("bg_rain", oid, "root", false)
--		effect2 = util:AttachFx_User("bg_rain", oid, "root", false)
--		return true
--      
--      end,
--
--      dorf04_rain_enter = function ()
--		Set_FogDistance(0.00, 0.360, 4)
--		Set_FogColor(47,142,127,4)
--		oid = util:GetMyOID();
--		effect1 = util:AttachFx_User("bg_rain", oid, "root", false)
--		effect2 = util:AttachFx_User("bg_rain", oid, "root", false)
--		return true
--      end,


}
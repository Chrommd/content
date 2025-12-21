/*------------------------------------------------------------___-------------------------------------------------------
                                                             /   |                                                      
                                                            / /| |                                                      
                                                           / ___ |                                                      
                                            P R O J E C T /_/  |_| L I C E                                              
                                        Copyright (C) 2005-2007 NTREEV SOFT Inc.                                        
----------------------------------------------------------------------------------------------------------------------*/

//! g_뭐시기 엔진에서 설정해주는 상수값
//! c_뭐시기 max 에서 디자이너가 설정하는 상수값
//! TEXCOORD0 : Diffuse Texture Coord
//! TEXCOORD1 : Lightmap or AO Texture Coord


//! 2011.04.21 (by mars)
//! 상점용 define추가. CHARACTER_Pixel, SM_3_0
//! per_pixel을 위해 Function으로 정리.
//! 2011.05.20 (by mars)
//! rim 분리(per_pixel용 별도. 수치제어가능하도록.), c_rimWidth: 임시 고정(value : 0.2)
//! 2011.06.08 (by mars)
//! ao texcoord에 3dsmax용으로 oTex1.y += 1.0; 연산추가함.
/////////////////////////////////////////////////////////////////////////////////////////////
#ifndef VS_VER
#define VS_VER  vs_3_0
#endif
#ifndef PS_VER
#define PS_VER  ps_3_0
#endif

#ifdef RIM
    #ifndef LAMBERT
    #define LAMBERT
    #endif
    #ifndef SPECULAR
    #define SPECULAR
    #endif
    #ifndef USING_RIM_COLOR
    #define USING_RIM_COLOR
    #endif
    #ifndef USING_RIM_DENSITY
    #define USING_RIM_DENSITY
    #endif
    #ifndef USING_RIM_WIDTH
    #define USING_RIM_WIDTH
    #endif
#endif

#ifdef BRUSH
    #ifndef SPECULAR
    #define SPECULAR
    #endif
    #ifndef USING_BRUSH_COLOR
    #define USING_BRUSH_COLOR
    #endif
    #ifndef USING_BRUSH_CENTER
    #define USING_BRUSH_CENTER
    #endif
    #ifndef USING_BRUSH_LEVEL
    #define USING_BRUSH_LEVEL
    #endif
    #ifndef USING_BRUSH_GLOSS
    #define USING_BRUSH_GLOSS
    #endif
#endif

#ifdef SPECULAR
    #ifndef LAMBERT
    #define LAMBERT
    #endif
    #ifndef USING_CAM_POS
    #define USING_CAM_POS
    #endif
    #ifndef USING_SPEC_COLOR
    #define USING_SPEC_COLOR
    #endif
    #ifndef USING_SPEC_LEVEL
    #define USING_SPEC_LEVEL
    #endif
    #ifndef USING_SPEC_GLOSS
    #define USING_SPEC_GLOSS
    #endif
    #ifndef USING_SPEC_TEX1
    #define USING_SPEC_TEX1
    #endif
#endif

#ifdef SSS
    #ifndef LAMBERT
    #define LAMBERT
    #endif
    #ifndef USING_SSS_LEVEL
    #define USING_SSS_LEVEL
    #endif
    #ifndef USING_SSS_WIDTH
    #define USING_SSS_WIDTH
    #endif
    #ifndef USING_SSS_COLOR
    #define USING_SSS_COLOR
    #endif
    #ifndef USING_SSS_TEX1
    #define USING_SSS_TEX1
    #endif
#endif

#ifdef WASH
    #ifndef USING_WASH_TEX
    #define USING_WASH_TEX
    #endif
    #ifndef USING_WASH_VALUE
    #define USING_WASH_VALUE
    #endif
#endif

#ifdef AMOLED   //! Self Illumination = 자체발광 = AMOLED = 손담비짱
    #ifndef USING_AMOLED_TEX1
    #define USING_AMOLED_TEX1
    #endif
#endif

#ifdef LAMBERT
    #ifndef USING_LIGHTDIR
    #define USING_LIGHTDIR
    #endif
    #ifndef AMBIENT
    #define AMBIENT
    #endif
#endif

#ifdef AMBIENT
    #ifndef USING_DIRECT
    #define USING_DIRECT
    #endif
    #ifndef USING_INDIRECT
    #define USING_INDIRECT
    #endif
#endif

#ifdef SKINING
    #ifndef SKINING_OLD
        #ifndef USING_SKIN_MATRIX
        #define USING_SKIN_MATRIX
        #endif
        #ifndef USING_MAX_WEIGHT
        #define USING_MAX_WEIGHT
        #endif
    #endif
#endif

#ifdef FAKE_INSTANCING
    #ifndef USING_INSTANCING_DATA
    #define USING_INSTANCING_DATA
    #endif
#endif

#ifdef _FOG_
    #ifndef USING_FOG_PARAM
    #define USING_FOG_PARAM
    #endif
    #ifndef USING_FOG_COLOR
    #define USING_FOG_COLOR
    #endif
#endif

#ifdef EXPFOG
    #ifndef USING_FOG_PARAM
    #define USING_FOG_PARAM
    #endif
    #ifndef USING_FOG_COLOR
    #define USING_FOG_COLOR
    #endif
#endif
//
//#ifdef FOG_EXP
//#endif
//
#ifdef ADDFOG
    #ifndef USING_ADDFOG_PARAM
    #define USING_ADDFOG_PARAM
    #endif
    #ifndef USING_ADDFOG_COLOR
    #define USING_ADDFOG_COLOR
    #endif
#endif

/////////////////////////////////////////////////////////////////////////////////////////////
//! Declare Variables With Defines
float4x4 g_WVP : WORLDVIEWPROJ;
//float4x4 g_WV : WORLDVIEW;

#ifdef INSTANCING
float4x4 g_VP : VIEWPROJ;
#endif

#ifdef USING_MODULATE
float g_modulate : MODULATE2X;
#endif

#ifdef USING_MAX_WEIGHT
int g_numWeight : NUM_WEIGHT = 4;
#endif

#ifdef USING_SKIN_MATRIX
float4 g_boneLocalTM[150];
#endif

#ifdef USING_INSTANCING_DATA
float4 g_InstanceData[240];
#endif

#ifdef USING_DIFFUSE_TEX3
    #ifndef USING_DIFFUSE_TEX1
    #define USING_DIFFUSE_TEX1
    #endif
#endif
#ifdef USING_DIFFUSE_TEX1
    texture c_diffTex0 //디퓨즈 텍스쳐
    <
        string UIName = "Diffuse0";
        int Texcoord = 0;
        int MapChannel = 1;
    >;
    
    sampler2D c_diffSamp0 = sampler_state //디퓨즈 셈플러
    {
        Texture   = (c_diffTex0);
        MinFilter = LINEAR;
        MagFilter = LINEAR;
        MipFilter = LINEAR;
        AddressU = Wrap;    
        AddressV = Wrap;
    };
#endif
//!#modify byMars 
#ifdef USING_DYE 
    float c_dyeColor0 
    <
        string UIName = "Skin_Color";
        string UIType = "Slider";
       float UIMin = 0.0f;
       float UIMax = 1.0f;
       float UIStep = 0.001f;
       float UIAtten = 1.0f;
    > = 0.5;

    float3 c_dyeColor1 
    <
        string UIName = "DYE_Color1";
        string UIType = "Slider";
       float UIMin = 0.0f;
       float UIMax = 1.0f;
       float UIStep = 0.001f;
       float UIAtten = 1.0f;
    > = float3( 0.5, 0.5, 0.5 );

    float3 c_dyeColor2 
    <
        string UIName = "DYE_Color2";
        string UIType = "Slider";
       float UIMin = 0.0f;
       float UIMax = 1.0f;
       float UIStep = 0.001f;
       float UIAtten = 1.0f;
    > = float3( 0.5, 0.5, 0.5 );

    texture c_dyeTex0 //염색마스크 텍스쳐
    <
        string UIName = "DYE";
        int Texcoord = 1;
        int MapChannel = 1;
    >;
    
    sampler2D c_dyeSamp0 = sampler_state //염색마스크 샘플러
    {
        Texture   = (c_dyeTex0);
        MinFilter = LINEAR;
        MagFilter = LINEAR;
        MipFilter = LINEAR;
        AddressU = Wrap;    
        AddressV = Wrap;
    };
#endif

#ifdef USING_WEATHER
	float3 c_weatherColor : weatherColor
	<
		string UIName = "Weather Color";
		string UIType = "Slider";
		float UIMin = 0.0f;
		float UIMax = 1.0f;
		float UIStep = 0.01f;
		float UIAtten = 1.0f;
	> = float3(1.0f, 1.0f, 1.0f);
#endif
//!#end byMars

#ifdef USING_DIFFUSE_TEX3
    texture c_diffTex1 //디퓨즈 텍스쳐
    <
        string UIName = "Diffuse_Tatu";
    >;
    
    sampler2D c_diffSamp1 = sampler_state //디퓨즈 셈플러
    {
        Texture   = (c_diffTex1);
        MinFilter = LINEAR;
        MagFilter = LINEAR;
        MipFilter = LINEAR;
        AddressU = Wrap;    
        AddressV = Wrap;    
    };
    texture c_diffTex2 //디퓨즈 텍스쳐
    <
        string UIName = "Diffuse_Eq";
    >;
    sampler2D c_diffSamp2 = sampler_state //디퓨즈 셈플러
    {
        Texture   = (c_diffTex2);
        MinFilter = LINEAR;
        MagFilter = LINEAR;
        MipFilter = LINEAR;    
        AddressU = Wrap;    
        AddressV = Wrap;
    };
#endif

#ifdef USING_AMOLED_TEX3
    #ifndef USING_AMOLED_TEX1
    #define USING_AMOLED_TEX1
    #endif
#endif
#ifdef USING_AMOLED_TEX1
    texture c_selfIlumTex0 //셀프 일루미네이션 텍스쳐(익스포트 과정에서 invers해야 함)
    <
        string UIName = "Self Illum";
    >;
    sampler2D c_selfIlumSamp0 = sampler_state //셀프 일루미네이션 셈플러
    {
        Texture   = (c_selfIlumTex0);
        MinFilter = LINEAR;
        MagFilter = LINEAR;
        MipFilter = LINEAR;
        AddressU = Wrap;    
        AddressV = Wrap;
    };
#endif
#ifdef USING_AMOLED_TEX3
    texture c_selfIlumTex1 //셀프 일루미네이션 텍스쳐(익스포트 과정에서 invers해야 함)
    <
        string UIName = "Self Illum_Tatu";
    >;
    sampler2D c_selfIlumSamp1 = sampler_state //셀프 일루미네이션 셈플러
    {
        Texture   = (c_selfIlumTex1);
        MinFilter = LINEAR;
        MagFilter = LINEAR;
        MipFilter = LINEAR;
        AddressU = Wrap;    
        AddressV = Wrap;
    };
    texture c_selfIlumTex2 //셀프 일루미네이션 텍스쳐(익스포트 과정에서 invers해야 함)
    <
        string UIName = "Self Illum_Eq";
    >;
    sampler2D c_selfIlumSamp2 = sampler_state //셀프 일루미네이션 셈플러
    {
        Texture   = (c_selfIlumTex2);
        MinFilter = LINEAR;
        MagFilter = LINEAR;
        MipFilter = LINEAR;
        AddressU = Wrap;    
        AddressV = Wrap;
    };
#endif


#ifdef USING_LIGHTDIR
    float3	g_lightDir : Direction 
    <  
    	string UIName = "Light"; 
    	string Object = "TargetLight";
    	int refID = 0;
    > = {0.577, 0.577, 0.577};
#endif

// always use
#ifdef USING_DIRECT
    float3 g_direct : direct
    <
    	string UIName = "Direct";
    > = float3(0.177986f, 0.173842f, 0.161236f);
#endif

// always use
#ifdef USING_INDIRECT
    float4 g_indirect : Indirect
    <
    	string UIName = "Indirect";
    > = float4( 0.133369, 0.135692, 0.131679, 1.0);
#endif  //! end of USING_INDIRECT

#ifdef USING_CAM_POS
    float3 g_worldCamera : WORLDCAMERAPOSITION;
#endif

//! Specular
#ifdef USING_SPEC_COLOR
    float3 c_specColor //스펙큘러 컬러
    <
        string UIName = "Spec Color";
    > = float3( 1.0, 1.0, 1.0 );
#endif

#ifdef USING_SPEC_LEVEL
    float c_specLevel //스펙큘러 강도
    <
        string UIName = "Spec Level";
    > = 0.16;
#endif

#ifdef USING_SPEC_GLOSS
    float c_specGloss //스펙큘러 넓이
    <
        string UIName = "Spec Glossiness";
       float UIMin = -100.00;
       float UIMax = 100.00;
    > = 2.8;
#endif

#ifdef USING_SPEC_TEX3
    #ifndef USING_SPEC_TEX1
    #define USING_SPEC_TEX1
    #endif
#endif
#ifdef USING_SPEC_TEX1
    texture c_specTex0 //스펙큘러 텍스쳐
    <
        string UIName = "Spec";
        int Texcoord = 2;
        int MapChannel = 3;
    >;
    sampler2D c_specSamp0 = sampler_state //스펙큘러셈플러
    {
        Texture   = (c_specTex0);
        MinFilter = LINEAR;
        MagFilter = LINEAR;
        MipFilter = LINEAR;
        AddressU = Wrap;    
        AddressV = Wrap;
    };
#endif
#ifdef USING_SPEC_TEX3
    texture c_specTex1 //스펙큘러 텍스쳐
    <
        string UIName = "Spec_Tatu";
    >;
    sampler2D c_specSamp1 = sampler_state //스펙큘러셈플러
    {
        Texture   = (c_specTex1);
        MinFilter = LINEAR;
        MagFilter = LINEAR;
        MipFilter = LINEAR;
        AddressU = Wrap;    
        AddressV = Wrap;
    };
    texture c_specTex2 //스펙큘러 텍스쳐
    <
        string UIName = "Spec_Eq";
    >;
    sampler2D c_specSamp2 = sampler_state //스펙큘러셈플러
    {
        Texture   = (c_specTex2);
        MinFilter = LINEAR;
        MagFilter = LINEAR;
        MipFilter = LINEAR;
        AddressU = Wrap;    
        AddressV = Wrap;
    };
#endif
#ifdef USING_AO_TEX1
    texture c_aoTex1
    <
        string UIName = "Ambient Occlusion";
        int Texcoord = 1;
        int MapChannel = 2;
    >;
    sampler2D c_aoSamp1 = sampler_state
    {
        Texture   = (c_aoTex1);
        MinFilter = LINEAR;
        MagFilter = LINEAR;
        MipFilter = LINEAR;    
        AddressU = Clamp;    
        AddressV = Clamp;
    };
#endif
#ifdef USING_LIGHTMAP_TEX
    texture c_ltmapTex //! lightmap texture
    <
        string UIName = "Lightmap";
        int Texcoord   = 1;
        int MapChannel = 2;
    >;
    sampler2D c_ltmapSamp = sampler_state //! lightmap sampler
    {
        Texture   = (c_ltmapTex);
        MinFilter = LINEAR;
        MagFilter = LINEAR;
        MipFilter = LINEAR;
        AddressU  = Clamp;
        AddressV  = Clamp;
    };
    #ifdef THIS_IS_MAX
      bool c_lightmapCompressed
      <
        string UIName = "Lightmap Compressed";
      > = false;
      float c_lightmapMulti	
      <
        string UIName = "Lightmap Multi";
      > = 1.0f;
    #endif
#endif


//! Brush
/*
    #ifdef USING_BRUSH_COLOR            //사용안함
    float3 c_brushColor //브러싱 컬러
    <
        string UIName = "Brush Color";
    > = float3( 1.0f, 1.0f, 1.0f );
    #endif
*/
//#ifdef USING_BRUSH_PARAM
// center, level, gloss 를 하나의 벡터에 추가
//#endif

#ifdef USING_BRUSH_CENTER
    float c_brushCenter //브러싱 스펙큘러 중심위치
    <
        string UIName = "Brush CenterPoint";
        float UIMin = -1.00;
        float UIMax = 1.00;
    > = 0.0;
#endif

#ifdef USING_BRUSH_LEVEL
    float c_brushLevel //스러싱 스펙큘러 강도
    <
        string UIName = "Brush Level";
//    > = 0.16;
    > = 1.5;
#endif

#ifdef USING_BRUSH_GLOSS
    float c_brushGloss //브러싱 스펙큘러 넓이
    <
        string UIName = "Brush Glossiness";
        float UIMin = -100.00;
        float UIMax = 100.00;
    > = 2.8;
#endif

//! Rim
#ifdef USING_RIM_COLOR
    float3 c_rimColor //림라이트 컬러
    <
        string UIName = "Rim Color...(No Touch)";
    > = float3( 0.0, 0.16, 0.66);
#endif

#ifdef USING_RIM_DENSITY
    float c_rimDensity //림라이트 강도
    <
        string UIName = "Rim Density...(No Touch)";
        float UIMin = -100.00;
        float UIMax = 100.00;
    > = 0.95;
#endif

#ifdef USING_RIM_WIDTH
    float c_rimWidth //림라이트 넓이
    <
        string UIName = "Rim Width...(No Touch)";
        float UIMin = 0.00;
        float UIMax = 1.00;
    > = 0.52;
#endif

//! SSS
#ifdef USING_SSS_LEVEL
    float c_sssLevel //서브 서피스 스케터링 강도
    <
        string UIName = "SSS Level...(No Touch)";
    > = 0.53;
#endif
#ifdef USING_SSS_WIDTH
    float c_sssWidth //서브 서피스 스케터링 넓이
    <
        string UIName = "SSS Width...(No Touch)";
    > = 0.5;
#endif
#ifdef USING_SSS_COLOR
    float3 c_sssColor //서브 서피스 스케터링 컬러
    <
        string UIName = "SSS Color...(No Touch)";
    > = float3( 0.935, 0.0, 0.0);
#endif

#ifdef USING_SSS_TEX3
    #ifndef USING_SSS_TEX1
    #define USING_SSS_TEX1
    #endif
#endif
#ifdef USING_SSS_TEX1
    texture c_sssTex0 //서브 서피스 스케터링 텍스쳐
    <
        string UIName = "Sub Surface Scatter";
    >;
    sampler2D c_sssSamp0 = sampler_state //서브 서피스 스케터링 셈플러
    {
        Texture   = (c_sssTex0);
        MinFilter = LINEAR;
        MagFilter = LINEAR;
        MipFilter = LINEAR;    
        AddressU = Wrap;    
        AddressV = Wrap;
    };
#endif
#ifdef USING_SSS_TEX3
    texture c_sssTex1 //서브 서피스 스케터링 텍스쳐
    <
        string UIName = "Sub Surface Scatter_Tatu";
    >;
    sampler2D c_sssSamp1 = sampler_state //서브 서피스 스케터링 셈플러
    {
        Texture   = (c_sssTex1);
        MinFilter = LINEAR;
        MagFilter = LINEAR;
        MipFilter = LINEAR;
        AddressU = Wrap;    
        AddressV = Wrap;    
    };
    texture c_sssTex2 //서브 서피스 스케터링 텍스쳐
    <
        string UIName = "Sub Surface Scatter_Eq";
    >;
    sampler2D c_sssSamp2 = sampler_state //서브 서피스 스케터링 셈플러
    {
        Texture   = (c_sssTex2);
        MinFilter = LINEAR;
        MagFilter = LINEAR;
        MipFilter = LINEAR;    
        AddressU = Wrap;    
        AddressV = Wrap;
    };
#endif

#ifdef USING_WASH_TEX
    texture c_dirtTex0 //서브 서피스 스케터링 텍스쳐
    <
        string UIName = "Dirt Texture Section0";
    >;
    sampler2D c_dirtSamp0 = sampler_state
    {
        Texture   = (c_dirtTex0);
        MinFilter = LINEAR;
        MagFilter = LINEAR;
        MipFilter = LINEAR;    
        AddressU = Wrap;    
        AddressV = Wrap;
    };
    texture c_dirtTex1 //서브 서피스 스케터링 텍스쳐
    <
        string UIName = "Dirt Texture Section1";
    >;
    sampler2D c_dirtSamp1 = sampler_state
    {
        Texture   = (c_dirtTex1);
        MinFilter = LINEAR;
        MagFilter = LINEAR;
        MipFilter = LINEAR;    
        AddressU = Wrap;    
        AddressV = Wrap;
    };
    texture c_dirtTex2 //서브 서피스 스케터링 텍스쳐
    <
        string UIName = "Dirt Texture Section2";
    >;
    sampler2D c_dirtSamp2 = sampler_state
    {
        Texture   = (c_dirtTex2);
        MinFilter = LINEAR;
        MagFilter = LINEAR;
        MipFilter = LINEAR;    
        AddressU = Wrap;    
        AddressV = Wrap;
    };
#endif

#ifdef USING_WASH_VALUE
    float3 c_dirtValue = float3(0.0f, 0.0f, 0.0f);
#endif

#ifdef USING_FOG_PARAM
    shared float2 g_fogParam: FogParam
    <
    > = float2(0.0f, 0.0f);
#endif
#ifdef USING_FOG_COLOR
    shared float3 g_fogColor : FogColor
    <
    > = float3(1.0f, 1.0f, 1.0f);
#endif

#ifdef USING_ADDFOG_PARAM
    shared float2 g_addfogParam: AddFogParam
    <
    > = float2(0.0f, 0.0f);
#endif
#ifdef USING_ADDFOG_COLOR
    shared float3 g_addfogColor : AddFogColor
    <
    > = float3(1.0f, 1.0f, 1.0f);
#endif

#ifdef THIS_IS_MAX
/*
    float c_bias
    <
      string UIName = "Mipmap Bias";
        float UIMin = -10.0f;
        float UIMax = 10.0f;
    > = 0.0f;
*/
    bool c_alphaTest
    <
      string UIName = "Alpha Test";
    > = true;
    int c_alphaRef
    <
        string UIName = "Alpha Ref";
        float UIMin = 0;
        float UIMax = 255;
    > = 128;
    bool c_alphaBlend
    <
      string UIName = "Alpha Blend";
    > = false;
    int c_cullMode
    <
        string UIName = "Backface Cull (1:none 2:cw 3:ccw)";
        float UIMin = 1;
        float UIMax = 3;
    > = 2;
    
#endif

/////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////
//Function
//////////////////////////////

void LightSSSFn(
    float3 vNormal
  #ifdef AMBIENT
    , out half3 oLight
  #endif
  #ifdef SSS
    , out half3 oSSS
  #endif
    )
{
//!#modify byMars
	#ifdef USING_WEATHER
		#ifdef USING_DIRECT
			g_direct.rgb *= c_weatherColor;
		#endif
		#ifdef USING_INDIRECT
			g_indirect.rgb *= c_weatherColor;
		#endif
	#endif
//!#end byMars

	#ifdef USING_LIGHTMAP_TEX
        oLight = float3(0.0f, 0.0f, 0.0f);
    #else
        #ifdef LAMBERT
            vNormal = normalize(vNormal);     //! Local TM 기준의 노멀값이므로 normalize 필요 없을듯..??
            half fLight = 1.0f + dot(vNormal, g_lightDir);
            half fLambert = smoothstep(0.9f, 2.0f, fLight);
            oLight = g_indirect.rgb + (g_direct*fLambert);
        #else
            #ifdef AMBIENT
                oLight = g_indirect.rgb + (g_direct*0.5);
            #endif
        #endif
    #endif
    #ifdef SSS
        half fSSS = c_sssLevel * (smoothstep((0.9f-c_sssWidth), 2.0f, fLight) - fLambert);
        oSSS = g_direct * c_sssColor * fSSS;
    #endif  
}


void RimSpecFn(
    float3 vNormal
    , float3 vLight
  #ifdef SPECULAR   
    , half3 vViewDir
  #endif
  #ifdef RIM
    , float vDist
  #endif
    , out half3 oLight
  #ifdef SPECULAR
    , out half3 oSpec
  #endif
    )
{
//!#modify byMars
	#ifdef USING_WEATHER
		#ifdef USING_DIRECT
			g_direct.rgb *= c_weatherColor;
		#endif
		#ifdef USING_INDIRECT
			g_indirect.rgb *= c_weatherColor;
		#endif
	#endif
//!#end byMars

	oLight = vLight;
    #ifdef SPECULAR
        half3 dirSpecColor = g_direct*c_specColor;
    #endif
    #ifndef USING_LIGHTMAP_TEX
        #ifdef LAMBERT
            #ifdef RIM
                float3x3 rimLightTranMat = {{0.939693, -0.34202, 0.0}, {0.34202, 0.939693, 0.0}, {0.0, 0.0, 1.0}};
                half rimView = saturate(dot(g_lightDir, vViewDir));
                #ifdef SSS //캐릭터 셰이더에만 사용되는 define이므로 Rim제어에도 같이 사용함. 주의할것.
                    //수치 제어(Character/Horse) //! c_rimWidth 임시 고정 (2011.05.20)
                    half rim = saturate(0.2+dot(vNormal, (mul(vViewDir, rimLightTranMat))))*c_rimDensity;
                    half3 rimLight = rim * lerp(g_indirect,g_direct,rimView)*c_rimColor;
                #else
                    //고정(기존 수치적용)(캐릭터외 오브젝트)
                    half rim = saturate(0.21+dot(vNormal, (mul(vViewDir, rimLightTranMat))))*0.65;
                    half3 rimLight = rim * lerp(g_indirect,g_direct,rimView);
                #endif
                #ifndef TONEMAP
                    rimLight += min(rimLight*vDist, 4.0f);
                #else
                    rimLight += min(rimLight*(vDist*0.1f), 2.0f);
                #endif
                oLight = vLight + rimLight;
            #endif
        #endif
    #endif    
    #ifdef SPECULAR
        half3 vReflect = reflect(vViewDir, vNormal);
        half specF = dot(g_lightDir, vReflect);    
        #ifdef BRUSH
            half fBrush = pow(1.0f - abs(specF+c_brushCenter), c_brushGloss) * c_brushLevel;
        #endif
        
        half specV = c_specLevel;        
        specV *= pow(saturate(specF), c_specGloss);    
        #ifdef BRUSH
            specV += fBrush;
        #endif    
        oSpec = dirSpecColor*specV;
        #ifndef USING_LIGHTMAP_TEX
            #ifdef RIM
                oSpec += rimLight;
            #endif
        #endif
    #endif
}
//////////////////////////////
//Vertex Shader
//////////////////////////////

void DefaultVS(
     float4 vPos        : POSITION
    ,float3 vNormal     : NORMAL
    ,float2 vTex0       : TEXCOORD0
#ifdef USING_AO_TEX1
    , float2 vTex1      : TEXCOORD2   //! TEXCOORD1을 써야 하지만 AO 자동 생성시 문제가 있어 임시로 사용합니다.
#endif
#ifdef USING_LIGHTMAP_TEX
    , float2 vTex1      : TEXCOORD2   //! TEXCOORD1을 써야 하지만 AO 자동 생성시 문제가 있어 임시로 사용합니다.
#endif
#ifdef INSTANCING
    ,float4 vWVP0       : TEXCOORD3
    ,float4 vWVP1       : TEXCOORD4
    ,float4 vWVP2       : TEXCOORD5
    ,float4 vWVP3       : TEXCOORD6
  #ifdef USING_LIGHTDIR
    ,float3 vLightDir   : POSITION1
  #endif
  #ifdef USING_CAM_POS
    ,float3 vCamPos     : POSITION2
  #endif
  #ifdef USING_DIRECT
    ,float4 vDirect     : COLOR0
  #endif
  #ifdef USING_INDIRECT
    ,float4 vIndirect   : COLOR1
  #endif
#endif
#ifdef FAKE_INSTANCING
    , float fIndex      : BLENDWEIGHT
#endif
#ifdef SKINING
    ,float4 vWeight	    : BLENDWEIGHT0
    ,float4 vIndices    : BLENDINDICES0
#endif
#ifdef USING_AO_VERTEX
    , float3 vAO        : COLOR0
#endif

    , out float4 oPos       : POSITION
    , out float2 oTex0      : TEXCOORD0
#ifdef _FOG_
    , out float oFog        : FOG
#endif
#ifdef USING_AO_TEX1 
    , out float2 oTex1      : TEXCOORD1
#endif
#ifdef USING_LIGHTMAP_TEX
    , out float2 oTex1      : TEXCOORD1
#endif
#ifdef AMBIENT
    , out half3 oLight      : TEXCOORD2
#endif
#ifdef SPECULAR
    , out half3 oSpec       : TEXCOORD3
#endif
#ifdef SSS
    , out half3 oSSS        : TEXCOORD4
#endif
#ifdef ADDFOG
    , out half oAddFog      : TEXCOORD5
#endif
#ifdef CHARACTER_Pixel
    , out float3 oNormal    : TEXCOORD5                    //perPixel
  #ifdef SPECULAR
    , out float3 oViewDir   : TEXCOORD6                    //perPixel
  #endif
  #ifdef RIM
    , out float oDist       : TEXCOORD7                   //perPixel
  #endif
#endif      
    )
{
oTex0 = vTex0;

#ifdef SKINING
    #ifdef SKINING_OLD
        VS_SKIN_INPUT  vsi = { vPos, vWeight, vIndices, vNormal };
  	    VS_SKIN_OUTPUT vso = ComputeSkin(vsi, g_numWeight);
        oPos = mul(vso.vPos, g_WVP);
  	    vNormal = vso.vNor;
    #else
        // vs_2_0 에서 성능 하락이 있다.
        // vs_3_0 Results 216 cycles, 20 r regs, 19,200,000 vertices/s
        // vs_2_a Results 233 cycles, 20 r regs, 18,773,332 vertices/s
        // vs_2_0 Results 315 cycles, 18 r regs, 16,853,332 vertices/s
        
        if (1 == g_numWeight)
        {
          vWeight.x = 1.0f;
        }
        
        float3 vTempPos = 0, vTempNor = 0;
        for(int i=0; i<g_numWeight; ++i)
        {
            float index = vIndices[i];
            float fWeight = vWeight[i];

            float3x4 model = float3x4(g_boneLocalTM[index+0], g_boneLocalTM[index+1], g_boneLocalTM[index+2]);
            float3x3 rotate = float3x3(model[0].xyz, model[1].xyz, model[2].xyz);
            vTempPos += fWeight*mul(model, vPos);
            vTempNor += fWeight*mul(rotate, vNormal);
        }
        vPos.xyz = vTempPos;

        oPos = mul(float4(vTempPos,1), g_WVP);
        vNormal = normalize(vTempNor);
        
        // vs_2_0 에서 좀 더 나은 성능
        // vs_3_0 Results 227 cycles, 21 r regs, 18,773,332 vertices/s
        // vs_2_a Results 244 cycles, 21 r regs, 18,560,000 vertices/s
        // vs_2_0 Results 288 cycles, 17 r regs, 17,493,333 vertices/s

        /*float4 src1 = 0,src2 = 0, src3 = 0;
        for( int i = 0; i < g_numWeight; ++ i )
        {
	        float fWeight = vWeight[i];
            float index = vIndices[i];

            src1 += ( fWeight * g_boneLocalTM[ index + 0 ] );
            src2 += ( fWeight * g_boneLocalTM[ index + 1 ] );
            src3 += ( fWeight * g_boneLocalTM[ index + 2 ] );
        }
        //oPos = mul(float4(mul(float3x4(src1,src2,src3),vPos).xyz,1), g_WVP);
        //vNormal = normalize( mul(float3x3(src1.xyz, src2.xyz, src3.xyz),vNormal) );
        oPos = mul(float4(dot(vPos,src1), dot(vPos,src2), dot(vPos,src3), 1), g_WVP);
        vNormal = normalize(float3(dot(vNormal,src1),dot(vNormal,src2),dot(vNormal,src3)));*/
    #endif
#else
    #ifdef INSTANCING
        float4x4 mWVP = {vWVP0,vWVP1,vWVP2,vWVP3};
        mWVP = mul(mWVP, g_VP);

        oPos = mul(vPos, mWVP);
    #else
        #ifdef FAKE_INSTANCING
            float4x4 mWVP = {g_InstanceData[fIndex],
                             g_InstanceData[fIndex+1],
                             g_InstanceData[fIndex+2],
                             g_InstanceData[fIndex+3]};
            oPos = mul(vPos, mWVP);
        #else
            oPos = mul(vPos, g_WVP);
        #endif
    #endif
#endif
    
#ifdef SKYMODEL
    return;
#endif

#ifdef USING_AO_TEX1
    oTex1 = vTex1;
    #ifdef THIS_IS_MAX
        oTex1.y += 1.0;
    #endif
#endif
#ifdef USING_LIGHTMAP_TEX
    oTex1 = vTex1;
    #ifdef THIS_IS_MAX
        oTex1.y += 1.0;
    #endif
#endif
#ifdef INSTANCING
    #ifdef USING_DIRECT
        g_direct = vDirect;
    #endif
    #ifdef USING_INDIRECT
        g_indirect = vIndirect;
    #endif
    #ifdef USING_LIGHTDIR
        g_lightDir = vLightDir;
    #endif
    #ifdef USING_CAM_POS
        g_worldCamera = vCamPos;
    #endif
#endif

#ifdef FAKE_INSTANCING
    #ifdef USING_DIRECT
        g_direct = g_InstanceData[fIndex+4].rgb;
    #endif
    #ifdef USING_INDIRECT
        g_indirect = g_InstanceData[fIndex+5];
    #endif
    #ifdef USING_LIGHTDIR
        g_lightDir = g_InstanceData[fIndex+6].xyz;
    #endif
    #ifdef USING_CAM_POS
        g_worldCamera = g_InstanceData[fIndex+7].xyz;
    #endif
#endif
#ifdef TONEMAP
    g_direct.rgb *= 2.0f;
    g_indirect.rgb *= 2.0f;
#endif

#ifdef CHARACTER_Pixel                   //perPixel
    oNormal = vNormal;     //perPixel
    #ifdef SPECULAR    
        oViewDir = normalize(vPos - g_worldCamera);
        oSpec = float3(0.0f, 0.0f, 0.0f);
    #endif 
    #ifdef RIM
      oDist = vPos.z*0.01 + 1.0f;  
    #endif
    #ifdef SM_3_0
        oLight = float3(0.0f, 0.0f, 0.0f);
        #ifdef SSS
            oSSS = float3(0.0f, 0.0f, 0.0f);
        #endif      
    #else
        LightSSSFn(
            vNormal
          #ifdef AMBIENT
            , oLight
          #endif
          #ifdef SSS
            , oSSS
          #endif
            );
    #endif
#else
    LightSSSFn(
        vNormal
      #ifdef AMBIENT
        , oLight
      #endif
      #ifdef SSS
        , oSSS
      #endif
        );

    #ifdef SPECULAR
        float3 viewDir = normalize(vPos - g_worldCamera);
    #endif
    #ifdef RIM
        float dist = oPos.z*0.01 + 1.0f;
    #endif 
  #ifdef AMBIENT
    RimSpecFn(
        vNormal
      #ifdef AMBIENT
        , oLight
      #endif
      #ifdef SPECULAR  
        , viewDir
      #endif
      #ifdef RIM
        , dist
      #endif
      #ifdef AMBIENT
        , oLight
      #endif
      #ifdef SPECULAR
        , oSpec
      #endif
        );
  #endif
#endif

#ifdef USING_AO_VERTEX
    #ifdef LAMBERT
        oLight *= vAO;
    #endif
    #ifdef SPECULAR
        oSpec *= vAO;
    #endif
#endif

#ifdef _FOG_
    //#ifdef EXPFOG
    //oFog = 1 / exp(oPos.z * g_fogParam.z);
    //#else
    //oFog = saturate((g_fogParam.x * oPos.z) + g_fogParam.y);
    //#endif
    oFog = saturate((g_fogParam.x * oPos.z) + g_fogParam.y);
#endif

#ifdef ADDFOG
    oAddFog = saturate((g_addfogParam.x * oPos.z) + g_addfogParam.y);
#endif

#ifdef CHARACTER
  //oLight.xyz = normalize(mul(vNormal, g_WVP));
  //oLight.xyz = normalize(vNormal.xyz);
  //oLight.xyz = normalize(mul(vNormal, g_WV));
#endif
}


//////////////////////////////
//Pixel Shader
//////////////////////////////

void DefaultPS(
      float2 vTex0       : TEXCOORD0
#ifdef USING_AO_TEX1
    , float2 vTex1       : TEXCOORD1
#endif
#ifdef USING_LIGHTMAP_TEX
    , float2 vTex1       : TEXCOORD1
#endif
#ifdef AMBIENT
    , half3 vLight       : TEXCOORD2
#endif
#ifdef SPECULAR
    , half3 vSpec        : TEXCOORD3
#endif
#ifdef SSS
    , half3 vSSS         : TEXCOORD4
#endif
#ifdef ADDFOG
    , half fAddFog       : TEXCOORD5
#endif
#ifdef CHARACTER_Pixel                                      //perPixel
    , float3 vNormal     : TEXCOORD5 
    #ifdef SPECULAR                
        ,float3 vViewDir : TEXCOORD6
    #endif
    #ifdef RIM
        ,float vDist     : TEXCOORD7
    #endif
#endif               
#ifdef _FOG_
    , half fFog          : FOG
#endif

    , out half4 oColor   : COLOR0           
#ifdef USING_MRT
    , out half4 oMRT     : COLOR1
#endif     
    )
{
#ifdef USING_DIFFUSE_TEX1
    oColor = tex2D(c_diffSamp0, vTex0);
#else
    oColor = 1;
#endif

#ifdef USING_DYE
	half4 mask = tex2D(c_dyeSamp0, vTex0);
   
  oColor.rgb = lerp(oColor.rgb, oColor.rgb+(c_dyeColor0-0.5)*0.5, mask.r);  //바디 컬러

//////////////////////////
  oColor.rgb = lerp(oColor.rgb, mask.a+(c_dyeColor1-0.5), mask.g);   //메인 컬러 (의상, 눈동자)
  oColor.rgb = lerp(oColor.rgb, mask.a+(c_dyeColor2-0.5), mask.b);   //포인트 컬러 (의상, 입술)

#endif

#ifdef SKYMODEL
    #ifdef USING_MRT
        oMRT = half4(0,0,0,1);
    #endif
    return;
#endif

/*#ifdef CHARACTER
  oColor.rgb = vLight.xyz;
  oColor.a = 1.f;
  return;
#endif*/

#ifdef WASH
    half4 dirtTex0 = tex2D(c_dirtSamp0, vTex0);
    half4 dirtTex1 = tex2D(c_dirtSamp1, vTex0);
    half4 dirtTex2 = tex2D(c_dirtSamp2, vTex0);
    oColor.rgb = lerp(oColor.rgb, dirtTex0.rgb, dirtTex0.a * c_dirtValue.x);
    oColor.rgb = lerp(oColor.rgb, dirtTex1.rgb, dirtTex1.a * c_dirtValue.y);
    oColor.rgb = lerp(oColor.rgb, dirtTex2.rgb, dirtTex2.a * c_dirtValue.z);
#endif

#ifdef USING_DIFFUSE_TEX3 
    half4 diffTex1 = tex2D(c_diffSamp1, vTex0);
    half4 diffTex2 = tex2D(c_diffSamp2, vTex0);
    oColor.rgb = lerp(oColor.rgb, diffTex1.rgb, diffTex1.a);
    oColor.rgb = lerp(oColor.rgb, diffTex2.rgb, diffTex2.a);
#endif


#ifdef TONEMAP
    oColor.rgb = pow(oColor.rgb, 1.22);
#endif

#ifdef USING_MODULATE
    oColor.rgb *= g_modulate;
#endif

#ifdef TEXTURE_COLOR
    #ifdef USING_INDIRECT
        oColor.a *= g_indirect.a;
    #endif
    return;
#endif

#ifdef CHARACTER_Pixel                                //perPixel
    #ifdef SM_3_0
        LightSSSFn(
                vNormal
              #ifdef AMBIENT
                , vLight
              #endif
              #ifdef SSS
                , vSSS
              #endif
                );
    #endif
    vNormal = normalize(vNormal);
    RimSpecFn(
            vNormal
            , vLight
          #ifdef SPECULAR   
            , vViewDir
          #endif
          #ifdef RIM
            , vDist
          #endif
            , vLight
          #ifdef SPECULAR
            , vSpec
          #endif
            );
#endif

#ifdef USING_LIGHTMAP_TEX
    vLight = tex2D(c_ltmapSamp, vTex1);
    vLight = vLight / (1.0f - vLight);
#endif
#ifdef USING_AO_TEX1
    half3 ao = tex2D(c_aoSamp1, vTex1);
    #ifdef LAMBERT
        vLight *= ao;
    #endif
    #ifdef SPECULAR
        vSpec *= ao;
    #endif
#endif


#ifdef SSS
    #ifdef USING_SSS_TEX1
        half3 sssLight = tex2D(c_sssSamp0, vTex0);
    #endif
    #ifdef USING_SSS_TEX3
        half4 sssTex1 = tex2D(c_sssSamp1, vTex0);
        half4 sssTex2 = tex2D(c_sssSamp2, vTex0);
        sssLight = lerp(sssLight.rgb, sssTex1.rgb, sssTex1.a);
        sssLight = lerp(sssLight.rgb, sssTex2.rgb, sssTex2.a);
    #endif
    //    vLight += (sssLight*vSSS);
#endif  //! end of SSS

#ifdef AMOLED
    #ifdef USING_AMOLED_TEX1
        half3 amoled = tex2D(c_selfIlumSamp0, vTex0);
    #endif
    #ifdef USING_AMOLED_TEX3
        half4 amoledTex1 = tex2D(c_selfIlumSamp1, vTex0);
        half4 amoledTex2 = tex2D(c_selfIlumSamp2, vTex0);
        amoled = lerp(amoled.rgb, amoledTex1.rgb, amoledTex1.a);
        amoled = lerp(amoled.rgb, amoledTex2.rgb, amoledTex2.a);
    #endif
    //    vLight += amoled;
#endif  //! end of AMOLED

#ifdef AMBIENT
    oColor.rgb *= vLight;
#endif

#ifdef SPECULAR
    #ifdef USING_SPEC_TEX1
        half3 specLight = tex2D(c_specSamp0, vTex0);
    #endif
    #ifdef USING_SPEC_TEX3
        half4 spec1Tex = tex2D(c_specSamp1, vTex0);
        half4 spec2Tex = tex2D(c_specSamp2, vTex0);
        specLight = lerp(specLight, spec2Tex.rgb, spec2Tex.a);
        specLight = lerp(specLight, spec1Tex.rgb, spec1Tex.a);        
    #endif
    #ifndef TONEMAP
        oColor.rgb += (specLight*vSpec);
    #else
        oColor.rgb += (specLight*vSpec)*2.0f;
    #endif
#endif

#ifdef CONSTANT_COLOR
    oColor = float4(1, 0, 0, 1);
    return;
#endif

#ifdef USING_INDIRECT
    oColor.a *= g_indirect.a;
#endif
#ifdef SSS
    oColor.rgb += (sssLight*vSSS);
#endif  //! end of SSS

#ifdef TONEMAP
    oColor.rgb = oColor.rgb / (oColor.rgb*0.7 + 1.f);
//케릭터톤조절
#else
    oColor.rgb = oColor.rgb / (oColor.rgb*0.15 + 1.f); 
#endif

#ifdef AMOLED
    oColor.rgb += amoled;
#endif

#ifdef ADDFOG
    oColor.rgb = lerp(oColor.rgb, 1, fAddFog*g_addfogColor.rgb);
#endif

#ifdef _FOG_
    oColor.rgb = lerp(oColor.rgb, g_fogColor.rgb, fFog);
#endif
    //oColor = saturate(oColor);    //! 알아서 짤리는가?!
}

#ifdef THIS_IS_MAX  //! 맥스에서는 프리뷰 기능만 있으면 된다!!!

    technique Preview
    {
        pass P0
        {
            ZEnable         = true;
          	ZWriteEnable    = true;
          	ZFunc           = 4;
          	CullMode        = (c_cullMode);
            AlphaTestEnable = (c_alphaTest);
            AlphaRef        = (c_alphaRef);
          	AlphaBlendEnable= (c_alphaBlend);
            DestBlend 		  = INVSRCALPHA;
            SrcBlend 		    = SRCALPHA;
      
            VertexShader = compile vs_3_0 DefaultVS();
            PixelShader  = compile ps_3_0 DefaultPS();
        }
    }   
#else
    technique RenderScene_1_1
    {
        pass P0
        {
            VertexShader = compile VS_VER DefaultVS();
            PixelShader  = compile PS_VER DefaultPS();
        }    
    }
    
    technique RenderScene_2_0
    {
        pass P0
        {
            VertexShader = compile VS_VER DefaultVS();
            PixelShader  = compile PS_VER DefaultPS();
        }
    }
#endif



/*----------------------------------------------------------------------------------------------------------------------
                                               P R O J E C T - A L I C E                                                
----------------------------------------------------------------------------------------------------------------------*/
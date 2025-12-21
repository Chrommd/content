/*------------------------------------------------------------___-------------------------------------------------------
                                                             /   |                                                      
                                                            / /| |                                                      
                                                           / ___ |                                                      
                                            P R O J E C T /_/  |_| L I C E                                              
                                        Copyright (C) 2005-2007 NTREEV SOFT Inc.                                        
----------------------------------------------------------------------------------------------------------------------*/

#ifdef THIS_IS_CLIENT
  #ifndef USING_DIFFUSE_TEX1
  #define USING_DIFFUSE_TEX1
  #endif
  
  #ifdef USING_AO_TEX1
  #undef USING_AO_VERTEX
  #endif
  
  #ifdef SSS
  #undef SSS
  #endif
  
  #ifdef BRUSH
  #undef BRUSH
  #endif
  
  #ifdef SKINING
  #undef SKINING
  #endif
#else
  #ifndef THIS_IS_MAX
  #define THIS_IS_MAX
  #endif
  #ifndef LAMBERT
  #define LAMBERT
  #endif
  #ifndef SPECULAR
  #define SPECULAR
  #endif
  #ifndef RIM
  #define RIM
  #endif
  #ifndef AMOLED
  #define AMOLED
  #endif
  #ifndef USING_DIFFUSE_TEX1
  #define USING_DIFFUSE_TEX1
  #endif
  #ifndef USING_SPEC_TEX1
  #define USING_SPEC_TEX1
  #endif
  #ifndef USING_AMOLED_TEX1
  #define USING_AMOLED_TEX1
  #endif
  #ifndef USING_AO_VERTEX
  #define USING_AO_VERTEX
  #endif
  #ifndef USING_AO_TEX1
  #define USING_AO_TEX1
  #endif
#endif

/*
//FX_parameter.Direct.g_direct.color.true
//FX_parameter.Inirect.g_indirect.color.true
*/

//FX_parameter.Diffuse0.c_diffTex0.bitmap.selectable
//FX_parameter.Diffuse0_Ch.c_diffTex0mapChannel.integer.true
/*
//FX_parameter.Diffuse1.c_diffTex1.bitmap.selectable
//FX_parameter.Diffuse2.c_diffTex2.bitmap.selectable
*/

//FX_parameter.Spec0.c_specTex0.bitmap.selectable
//FX_parameter.Spec0_Ch.c_specTex0mapChannel.integer.true
/*
//FX_parameter.Spec1.c_specTex1.bitmap.selectable
//FX_parameter.Spec2.c_specTex2.bitmap.selectable
*/

//FX_parameter.SelfIllum0.c_selfIlumTex0.bitmap.selectable
/*
//FX_parameter.SelfIllum1.c_selfIlumTex1.bitmap.selectable
//FX_parameter.SelfIllum2.c_selfIlumTex2.bitmap.selectable
*/

/*
//FX_parameter.SubSurfaceScatter0.c_sssTex0.bitmap.selectable
//FX_parameter.SubSurfaceScatter1.c_sssTex1.bitmap.selectable
//FX_parameter.SubSurfaceScatter2.c_sssTex2.bitmap.selectable
*/

//FX_parameter.AO.c_aoTex1.bitmap.selectable
//FX_parameter.AO_Ch.c_aoTex1mapChannel.integer.true

//FX_parameter.SpecColor.c_specColor.color.true
//FX_parameter.SpecLevel.c_specLevel.float.true
//FX_parameter.SpecGlossiness.c_specGloss.float.true

/*
//FX_parameter.BrushColor.c_brushColor.color.true
//FX_parameter.BrushCenterPoint.c_brushCenter.float.true
//FX_parameter.BrushLevel.c_brushLevel.float.true
//FX_parameter.BrushGlossiness.c_brushGloss.float.true
*/

//FX_parameter.RimLightColor.c_rimColor.color.true
//FX_parameter.RimLightDensity.c_rimDensity.float.true
//FX_parameter.RimLightWidth.c_rimWidth.float.true

/*
//FX_parameter.SSSlevel.c_sssLevel.float.true
//FX_parameter.SSSwidth.c_sssWidth.float.true
//FX_parameter.SSScolor.c_sssColor.color.true
*/

//FX_parameter.Bias.c_bias.float.true
//FX_parameter.AlphaTest.c_alphaTest.bool.true
//FX_parameter.AlphaRef.c_alphaRef.integer.true
//FX_parameter.AlphaRef.c_alphaRef.bool.true
//FX_parameter.BackfaceCull.c_cullMode.integer.true

//FX_parameter.EnableLambert.c_enableLambert.bool.true
//FX_parameter.EnableSpecular.c_enableSpec.bool.true
//FX_parameter.EnableRim.c_enableRim.bool.true
/*
//FX_parameter.EnableSSS.c_enableSSS.bool.true
//FX_parameter.EnableBrush.c_enableBrush.bool.true
*/
//FX_parameter.EnableSelfIllum.c_enableAmoled.bool.true
//FX_parameter.EnableAO.c_enableAO.bool.true
//FX_parameter.UseAOTexture.c_enableAOTex.bool.true

/*----------------------------------------------------------------------------------------------------------------------
                                               P R O J E C T - A L I C E                                                
----------------------------------------------------------------------------------------------------------------------*/
//! g_뭐시기 엔진에서 설정해주는 상수값
//! c_뭐시기 max 에서 디자이너가 설정하는 상수값
//! TEXCOORD0 : Diffuse Texture Coord
//! TEXCOORD1 : Lightmap or AO Texture Coord

/////////////////////////////////////////////////////////////////////////////////////////////
#ifndef VS_VER
#define VS_VER  vs_3_0
#endif
#ifndef PS_VER
#define PS_VER  ps_3_0
#endif


#ifndef USING_INDIRECT
#define USING_INDIRECT
#endif

#ifndef USING_DIRECT
#define USING_DIRECT
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

#ifdef AMOLED   //! Self Illumination = 자체발광 = AMOLED = 손담비짱
    #ifndef USING_AMOLED_TEX1
    #define USING_AMOLED_TEX1
    #endif
#endif

#ifdef LAMBERT
//const float c_lambertMin = 0.9f;
//const float c_lambertMax = 2.0f;
    #ifndef USING_LIGHTDIR
    #define USING_LIGHTDIR
    #endif
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

#ifdef USING_MAX_WEIGHT
int g_numWeight : NUM_WEIGHT = 4;
#endif

#ifdef USING_SKIN_MATRIX
float4 g_boneLocalTM[150];
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
//#ifdef USING_DIRECT
float3 g_direct : direct
<
	string UIName = "Direct";
> = float3(0.177986f, 0.173842f, 0.161236f);
//#endif

// always use
//#ifdef USING_INDIRECT
float4 g_indirect : Indirect
<
	string UIName = "Indirect";
> = float4( 0.133369, 0.135692, 0.131679, 1.0);
//#endif  //! end of USING_INDIRECT

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



//! Brush
#ifdef USING_BRUSH_COLOR
float3 c_brushColor //브러싱 컬러
<
    string UIName = "Brush Color";
> = float3( 1.0f, 1.0f, 1.0f );
#endif

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
> = 0.16;
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
    string UIName = "Rim Color";
> = float3( 0.0, 0.16, 0.66);
#endif

#ifdef USING_RIM_DENSITY
float c_rimDensity //림라이트 강도
<
    string UIName = "Rim Density";
    float UIMin = -100.00;
    float UIMax = 100.00;
> = 0.95;
#endif

#ifdef USING_RIM_WIDTH
float c_rimWidth //림라이트 넓이
<
    string UIName = "Rim Width";
    float UIMin = 0.00;
    float UIMax = 1.00;
> = 0.52;
#endif

//! SSS
#ifdef USING_SSS_LEVEL
float c_sssLevel //서브 서피스 스케터링 강도
<
    string UIName = "SSS Level";
> = 0.53;
#endif
#ifdef USING_SSS_WIDTH
float c_sssWidth //서브 서피스 스케터링 넓이
<
    string UIName = "SSS Width";
> = 0.5;
#endif
#ifdef USING_SSS_COLOR
float3 c_sssColor //서브 서피스 스케터링 컬러
<
    string UIName = "SSS Color";
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
    AddressU = Wrap;    
    AddressV = Wrap;
};
#endif

#ifdef USING_FOG_PARAM
shared float2 g_fogParam: FogParam
<
> = float2(1.0f, 1.0f);
#endif
#ifdef USING_FOG_COLOR
shared float3 g_fogColor : FogColor
<
> = float3(1.0f, 1.0f, 1.0f);
#endif

#ifdef USING_ADDFOG_PARAM
shared float2 g_addfogParam: AddFogParam
<
> = float2(1.0f, 1.0f);
#endif
#ifdef USING_ADDFOG_COLOR
shared float3 g_addfogColor : AddFogColor
<
> = float3(1.0f, 1.0f, 1.0f);
#endif

#ifdef THIS_IS_MAX
float c_bias
<
  string UIName = "Mipmap Bias";
    float UIMin = -10.0f;
    float UIMax = 10.0f;
> = 0.0f;
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

#ifdef LAMBERT
bool c_enableLambert
<
    string UIName = "Enable Lambert";
> = true;
#endif

#ifdef SPECULAR
bool c_enableSpec
<
    string UIName = "Enable Specular";
> = true;
#endif

#ifdef RIM
bool c_enableRim
<
    string UIName = "Enable Rim";
> = true;
#endif

#ifdef SSS
bool c_enableSSS
<
    string UIName = "Enable SSS";
> = true;
#endif

#ifdef BRUSH
bool c_enableBrush
<
    string UIName = "Enable Brush";
> = true;
#endif

#ifdef AMOLED
bool c_enableAmoled
<
    string UIName = "Enable Self Illum";
> = true;
#endif

#ifdef USING_AO_VERTEX
bool c_enableAO
<
    string UIName = "Enable AO";
> = true;
#endif
#ifdef USING_AO_TEX1
bool c_enableAOTex
<
    string UIName = "Use AO Texture";
> = true;
#endif

#endif

/////////////////////////////////////////////////////////////////////////////////////////////

void DefaultVS(
     float4 vPos        : POSITION
    ,float3 vNormal     : NORMAL
    ,float2 vTex0       : TEXCOORD0
#ifdef USING_AO_TEX1
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

//#ifdef LAMBERT
    , out half3 oLight      : TEXCOORD2
//#endif
#ifdef SPECULAR
    , out half3 oSpec       : TEXCOORD3
#endif
#ifdef SSS
    , out half3 oSSS        : TEXCOORD4
#endif
#ifdef ADDFOG
    , out half oAddFog      : TEXCOORD5
#endif
    )
{
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
        oPos = mul(vPos, mWVP);
    #else
        oPos = mul(vPos, g_WVP);
    #endif
#endif

    oTex0 = vTex0;
#ifdef USING_AO_TEX1
    oTex1 = vTex1;
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

#ifdef LAMBERT
    vNormal = normalize(vNormal);     //! Local TM 기준의 노멀값이므로 normalize 필요 없을듯..??
    half fLight = 1.0f + dot(vNormal, g_lightDir);
    //half fLambert = smoothstep(c_lambertMin, c_lambertMax, fLight);
    half fLambert = smoothstep(0.9f, 2.0f, fLight);
    oLight = g_indirect.rgb + (g_direct*fLambert);
#else
    oLight = g_indirect.rgb + (g_direct*0.5);
#endif

#ifdef SPECULAR
    half3 viewDir = normalize(vPos - g_worldCamera);
    half3 dirSpecColor = g_direct*c_specColor;
#endif

#ifdef RIM
    //! 코드 최적화
    half rim = 1.0f + dot(vNormal, viewDir);
    half rimBtm = (0.3f * vNormal.z) + 0.7f;
    half rimView = saturate(dot(g_lightDir, viewDir)) * rim;
    half rimW = (c_rimWidth + (0.5f * rimView));
    half rimD = c_rimDensity * (1.0f + (rimView * fLambert));
    half rimV = rimD * smoothstep(1.0f-rimW, 2.0f, rim) * rimBtm * 2.0f;
    half3 rimLight = rimV * lerp(c_rimColor, dirSpecColor, rimView);
    oLight += rimLight;
#endif

#ifdef SSS
    half fSSS = c_sssLevel * (smoothstep((0.9f-c_sssWidth), 2.0f, fLight) - fLambert);
    oSSS = g_direct * c_sssColor * fSSS;
#endif

#ifdef SPECULAR
    half3 vReflect = reflect(viewDir, vNormal);
    half specF = dot(g_lightDir, vReflect);

    #ifdef BRUSH
        half fBrush = pow(1.0f - abs(specF+c_brushCenter), c_brushGloss) * c_brushLevel;
        #ifdef RIM
            fBrush = fBrush * (0.7f + rimView);
        #endif
    #endif
    
    //half specV = (c_specLevel + rimView) * pow(saturate(specF), c_specGloss) + fBrush;
    half specV = c_specLevel;    
    #ifdef RIM
        specV += rimView;
    #endif
    specV *= pow(saturate(specF), c_specGloss);    
    #ifdef BRUSH
        specV += fBrush;
    #endif

    oSpec = dirSpecColor*specV;
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
    oAddFog = saturate((g_addfogParam.x * oPos.z * 0.001) + g_addfogParam.y);
#endif
}

void DefaultPS(float2 vTex0 : TEXCOORD0
#ifdef USING_AO_TEX1
               , float2 vTex1 : TEXCOORD1
#endif
//#ifdef LAMBERT
               , half3 vLight : TEXCOORD2
//#endif
#ifdef SPECULAR
               , half3 vSpec : TEXCOORD3
#endif
#ifdef SSS
               , half3 vSSS : TEXCOORD4
#endif
#ifdef ADDFOG
               , half fAddFog : TEXCOORD5
#endif
#ifdef _FOG_
               , half fFog : FOG
#endif
               , out half4 oColor : COLOR0
               )
{
#ifdef USING_DIFFUSE_TEX1
    oColor = tex2D(c_diffSamp0, vTex0);
#else
    oColor = 1;
#endif
/*
#ifdef USING_DIFFUSE_TEX3 
    half4 diffTex1 = tex2D(c_diffSamp1, vTex0);
    half4 diffTex2 = tex2D(c_diffSamp2, vTex0);
    oColor.rgb = lerp(oColor.rgb, diffTex1.rgb, diffTex1.a);
    oColor.rgb = lerp(oColor.rgb, diffTex2.rgb, diffTex2.a);
#endif

#ifdef TEXTURE_COLOR
  #ifdef USING_INDIRECT
    oColor.a *= g_indirect.a;
  #endif
    return;
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
        vLight += (sssLight*vSSS);
#endif  //! end of SSS

#ifdef AMOLED
    #ifdef USING_AMOLED_TEX1
        half3 amoled = tex2D(c_selfIlumSamp0, vTex0);
    #endif
    #ifdef USING_AMOLED_TEX3
        half4 amoledTex1 = tex2D(c_selfIlumSamp1, vTex0);
        half4 amoledTex2 = tex2D(c_selfIlumSamp2, vTex0);
        amoled = lerp(amoled.rgb, amoledTex1.rgb, amoledTex2.a);
        amoled = lerp(amoled.rgb, amoledTex2.rgb, amoledTex2.a);
    #endif
        vLight += amoled;
#endif  //! end of AMOLED

//#ifdef LAMBERT
        oColor.rgb *= vLight;
//#endif

#ifdef SPECULAR
    #ifdef USING_SPEC_TEX1
        half3 specLight = tex2D(c_specSamp0, vTex0);
    #endif
    #ifdef USING_SPEC_TEX3
        half4 spec1Tex = tex2D(c_specSamp1, vTex0);
        half4 spec2Tex = tex2D(c_specSamp2, vTex0);
        specLight = lerp(specLight, spec1Tex.rgb, spec1Tex.a);
        specLight = lerp(specLight, spec2Tex.rgb, spec2Tex.a);
    #endif
        oColor.rgb += (specLight*vSpec);
#endif

#ifdef ADDFOG
    oColor.rgb = lerp(oColor.rgb, 1, fAddFog*g_addfogColor.rgb);
#endif

#ifdef _FOG_
    oColor.rgb = lerp(oColor.rgb, g_fogColor.rgb, fFog);
#endif

#ifdef CONSTANT_COLOR
    oColor = float4(1, 0, 0, 1);
    return;
#endif

#ifdef USING_INDIRECT
    oColor.a *= g_indirect.a;
#endif
*/
//#ifdef FOG
//#endif
//
//#ifdef FOG_ADD
//#endif
}

#ifdef THIS_IS_MAX
void PreviewVS(
     float4 vPos        : POSITION
    ,float3 vNormal     : NORMAL
    ,float2 vTex0       : TEXCOORD0
    ,float2 vTex1       : TEXCOORD1
#ifdef USING_AO_VERTEX
    , float3 vAO        : COLOR0
#endif
    , out float4 oPos       : POSITION
    , out float2 oTex0      : TEXCOORD0
    , out float2 oTex1      : TEXCOORD1
    , out half3 oLight      : TEXCOORD2
    , out half3 oSpec       : TEXCOORD3
    , out half3 oSSS         : TEXCOORD4
    )
{
    oPos = mul(vPos, g_WVP);

    oTex0 = vTex0;
    oTex1 = vTex1;

    oSpec = half3(0,0,0);
    oSSS = half3(0,0,0);

#ifdef LAMBERT
    vNormal = normalize(vNormal);     //! Local TM 기준의 노멀값이므로 normalize 필요 없을듯..??
    half fLight = 1.0f + dot(vNormal, g_lightDir);
    //half fLambert = smoothstep(c_lambertMin, c_lambertMax, fLight);
    half fLambert = smoothstep(0.9f, 2.0f, fLight);
    if (c_enableLambert)
        oLight = g_indirect + (g_direct*fLambert);
    else
        oLight = g_indirect + (g_direct*0.5f);
#endif

#ifdef SPECULAR
    half3 viewDir = normalize(vPos - g_worldCamera);
    half3 dirSpecColor = g_direct*c_specColor;
#endif

#ifdef RIM
    //! 코드 최적화
    half rim = 1.0f + dot(vNormal, viewDir);
    half rimBtm = (0.3f * vNormal.z) + 0.7f;
    half rimView = saturate(dot(g_lightDir, viewDir)) * rim;
    half rimW = (c_rimWidth + (0.5f * rimView));
    half rimD = c_rimDensity * (1.0f + (rimView * fLambert));
    half rimV = rimD * smoothstep(1.0f-rimW, 2.0f, rim) * rimBtm * 2.0f;
    half3 rimLight = rimV * lerp(c_rimColor, dirSpecColor, rimView);
    if(c_enableLambert && c_enableRim)
    {
      oLight += rimLight;
    }
#endif

#ifdef SSS
    half fSSS = c_sssLevel * (smoothstep((0.9f-c_sssWidth), 2.0f, fLight) - fLambert);
    oSSS = g_direct * c_sssColor * fSSS;
#endif

#ifdef SPECULAR
    half3 vReflect = reflect(viewDir, vNormal);
    half specF = dot(g_lightDir, vReflect);

  #ifdef BRUSH
    half fBrush = 0;
    if(c_enableBrush)
    {
        fBrush = pow(1.0f - abs(specF+c_brushCenter), c_brushGloss)*c_brushLevel;

        if(c_enableLambert && c_enableRim)
        {
            fBrush = fBrush * (0.7f + rimView);
        }
    }
  #endif
    
    half specV = c_specLevel;
    if(c_enableRim)
    {
        specV += rimView;
    }

    specV *= pow(saturate(specF), c_specGloss);
    
  #ifdef BRUSH
    if(c_enableBrush)
    {
        specV += fBrush;
    }
  #endif

    oSpec = dirSpecColor*specV;
#endif

#ifdef USING_AO_VERTEX
    if(c_enableAO && !c_enableAOTex)
    {
        #ifdef LAMBERT
        oLight *= vAO;
        #endif
        #ifdef SPECULAR
        oSpec *= vAO;
        #endif
    }
#endif
}


void PreviewPS(float2 vTex0 : TEXCOORD0
               , float2 vTex1 : TEXCOORD1       //! Lightmap or AO
               , half3 vLight : TEXCOORD2
               , half3 vSpec : TEXCOORD3
               , half3 vSSS : TEXCOORD4
               , out half4 oColor : COLOR0
               )
{
    oColor = tex2Dbias(c_diffSamp0, float4(vTex0.xy,c_bias.x,c_bias.x));
/*
#ifdef USING_DIFFUSE_TEX3
    half4 diffTex1 = tex2Dbias(c_diffSamp1, float4(vTex0.xy,c_bias.x,c_bias.x));
    half4 diffTex2 = tex2Dbias(c_diffSamp2, float4(vTex0.xy,c_bias.x,c_bias.x));
    oColor.rgb = lerp(oColor.rgb, diffTex1.rgb, diffTex1.a);
    oColor.rgb = lerp(oColor.rgb, diffTex2.rgb, diffTex2.a);
#endif

#ifdef USING_AO_TEX1
    if(c_enableAOTex)
    {
        half3 ao = tex2D(c_aoSamp1, vTex1);
        vLight *= ao;
        vSpec *= ao;
    }
#endif

#ifdef SSS
    if(c_enableSSS)
    {
        half3 sssLight = tex2Dbias(c_sssSamp0, float4(vTex0.xy,c_bias.x,c_bias.x));
      #ifdef USING_SSS_TEX3
        half4 sssTex1 = tex2Dbias(c_sssSamp1, float4(vTex0.xy,c_bias.x,c_bias.x));
        half4 sssTex2 = tex2Dbias(c_sssSamp2, float4(vTex0.xy,c_bias.x,c_bias.x));
        sssLight = lerp(sssLight.rgb, sssTex1.rgb, sssTex1.a);
        sssLight = lerp(sssLight.rgb, sssTex2.rgb, sssTex2.a);
      #endif
        vLight += (sssLight*vSSS);
    }
#endif

#ifdef AMOLED
    if(c_enableAmoled)
    {
        half3 amoled = tex2Dbias(c_selfIlumSamp0, float4(vTex0.xy,c_bias.x,c_bias.x));
      #ifdef USING_AMOLED_TEX3
        half4 amoledTex1 = tex2Dbias(c_selfIlumSamp1, float4(vTex0.xy,c_bias.x,c_bias.x));
        half4 amoledTex2 = tex2Dbias(c_selfIlumSamp2, float4(vTex0.xy,c_bias.x,c_bias.x));
        amoled = lerp(amoled.rgb, amoledTex1.rgb, amoledTex2.a);
        amoled = lerp(amoled.rgb, amoledTex2.rgb, amoledTex2.a);
      #endif
        vLight += amoled;
    }
#endif

    //if(c_enableLambert)
    {
        oColor.rgb *= vLight;
    }

#ifdef SPECULAR
    if(c_enableSpec == true)
    {
        half3 specLight = tex2Dbias(c_specSamp0, float4(vTex0.xy,c_bias.x,c_bias.x));
      #ifdef USING_SPEC_TEX3
        half4 spec1Tex = tex2Dbias(c_specSamp1, float4(vTex0.xy,c_bias.x,c_bias.x));
        half4 spec2Tex = tex2Dbias(c_specSamp2, float4(vTex0.xy,c_bias.x,c_bias.x));
        specLight = lerp(specLight, spec1Tex.rgb, spec1Tex.a);
        specLight = lerp(specLight, spec2Tex.rgb, spec2Tex.a);
      #endif
        oColor.rgb += (specLight*vSpec);
    }
#endif

    oColor.a *= g_indirect.a;
*/
}
#endif  //! end of THIS_IS_MAX


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
      DestBlend 		= INVSRCALPHA;
      SrcBlend 		= SRCALPHA;

      VertexShader = compile vs_3_0 PreviewVS();
      PixelShader  = compile ps_3_0 PreviewPS();
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
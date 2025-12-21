/*------------------------------------------------------------___-------------------------------------------------------
                                                             /   |                                                      
                                                            / /| |                                                      
                                                           / ___ |                                                      
                                            P R O J E C T /_/  |_| L I C E                                              
                                        Copyright (C) 2005-2007 NTREEV SOFT Inc.                                        
----------------------------------------------------------------------------------------------------------------------*/
#ifndef VS_VER
#define VS_VER  vs_3_0
#endif
#ifndef PS_VER
#define PS_VER  ps_3_0
#endif

#ifndef USING_LAYER_SCALE
#define USING_LAYER_SCALE
#endif
#ifndef USING_DIFFUSE_TEX4
#define USING_DIFFUSE_TEX4
#endif

#ifdef THIS_IS_CLIENT
#else
    #ifndef THIS_IS_MAX
    #define THIS_IS_MAX
    #endif
    #define SPECULAR
    #define RIM
    #define LIGHTMAP
    #define USING_VERTEX_COLOR
    #define SPLATTING
    #define USING_LAYER_EDGE
    #define USING_LAYER_SHADOW
#endif

/////////////////////////////////////////////////////////////////////////////////////////////
#ifdef LAYER_BLEND_DIFFUSE
    #ifndef SPLATTING
    #define SPLATTING
    #endif
    #ifndef LIGHTMAP
    #define LIGHTMAP
    #endif
    #ifndef USING_DIFFUSE_TEX4
    #define USING_DIFFUSE_TEX4
    #endif
#endif

#ifdef LAYER_BLEND_SPECULAR
    #ifndef SPLATTING
    #define SPLATTING
    #endif
    #ifndef LIGHTMAP
    #define LIGHTMAP
    #endif
    #ifndef SPECULAR
    #define SPECULAR
    #endif
#endif

#ifdef LIGHTMAP
    #ifndef USING_LIGHTMAP_TEX
    #define USING_LIGHTMAP_TEX
    #endif
    #ifndef USING_LIGHTMAP_DECOMP
    #define USING_LIGHTMAP_DECOMP
    #endif
    #ifndef USING_LIGHTMAP_TONE
    #define USING_LIGHTMAP_TONE
    #endif
#endif

#ifdef RIM
    #ifndef USING_VIEW_DIR
    #define USING_VIEW_DIR
    #endif
    #ifndef USING_CAM_POS
    #define USING_CAM_POS
    #endif
    #ifndef USING_RIM_COLOR
    #define USING_RIM_COLOR
    #endif
    #ifndef USING_RIM_DENSITY
    #define USING_RIM_DENSITY
    #endif
    #ifndef USING_RIM_GLOSS
    #define USING_RIM_GLOSS
    #endif
#endif

#ifdef SPECULAR
    #ifndef USING_LIGHTDIR
    #define USING_LIGHTDIR
    #endif
    #ifndef USING_VIEW_DIR
    #define USING_VIEW_DIR
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
    #ifndef USING_SPEC_TEX4
    #define USING_SPEC_TEX4
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


#ifdef USING_DIFFUSE_TEX4
  #ifndef USING_DIFFUSE_TEX3
  #define USING_DIFFUSE_TEX3
  #endif
#endif

#ifdef USING_DIFFUSE_TEX3
    #ifndef USING_DIFFUSE_TEX1
    #define USING_DIFFUSE_TEX1
    #endif
#endif

/////////////////////////////////////////////////////////////////////////////////////////////
//! Declare Variables With Defines
float4x4 g_WVP : WORLDVIEWPROJ;

//!#modify byMars
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
    float c_weatherContrast : WeatherContrast
    <
    	string UIName = "Weather Contrast";
		string UIType = "Slider";
		float UIMin = 0.0f;
		float UIMax = 1.0f;
		float UIStep = 0.01f;
		float UIAtten = 1.0f;
	> = 1.0f;
/*
	float c_weatherBrightness
    <
    	string UIName = "Weather Brightness";
    > = 0.0f;
*/
#endif
//!#end byMars

#ifdef USING_LIGHTDIR
float3	g_lightDir : Direction 
<  
	string UIName = "Light"; 
	string Object = "TargetLight";
	int refID = 0;
> = {0.577, 0.577, 0.577};
#endif

#ifdef USING_DIRECT
//FX_parameter.Direct.g_direct.color.true
float3 g_direct : direct
<
	string UIName = "Direct";
> = float3(0.177986f, 0.173842f, 0.161236f);
#endif

#ifdef USING_INDIRECT
//FX_parameter.Inirect.g_indirect.color.true
float4 g_indirect : Indirect
<
	string UIName = "Indirect";
> = float4( 0.133369, 0.135692, 0.131679, 1.0);
#endif  //! end of USING_INDIRECT

#ifdef USING_CAM_POS
float3 g_worldCamera : WORLDCAMERAPOSITION;
#endif


#ifdef USING_LIGHTMAP_TEX
//FX_parameter.LightMap.c_ltmapTex.bitmap.selectable
//FX_parameter.LightMap_Ch.c_ltmapTexmapChannel.integer.selectable
texture c_ltmapTex //! lightmap texture
<
    string UIName = "Lightmap";
    int Texcoord   = 0;
    int MapChannel = 1;
>;
sampler2D c_ltmapSamp = sampler_state //! lightmap sampler
{
    Texture   = (c_ltmapTex);
    MinFilter = LINEAR;
    MagFilter = LINEAR;
    MipFilter = LINEAR;
    AddressU  = Wrap;
    AddressV  = Wrap;
};
#endif

#ifdef USING_LIGHTMAP_DECOMP
//FX_parameter.Lightmap_decomp.c_ltmapDecomp.float.true
float c_ltmapDecomp
<
  string UIName = "Lightmap Decomp";
> = 1.0f;
#endif
#ifdef USING_LIGHTMAP_TONE
//FX_parameter.toneVal.c_ltmapTone.float.true
float c_ltmapTone
<
  string UIName = "Lightmap Tone";
> = 1.0f;
float g_ltmapTone : GLtMapTone                                  //by mars. 2011.03.16
<
  string UIName = "Global Lightmap Tone";
> = 1.0f;
#endif

#ifdef USING_DIFFUSE_TEX1
//FX_parameter.Diffuse0.c_diffTex0.bitmap.selectable
//FX_parameter.Diffuse0_Ch.c_diffTex0mapChannel.integer.true
texture c_diffTex0 //디퓨즈 텍스쳐
<
    string UIName = "Diffuse0";
    int Texcoord = 1;
    int MapChannel = 2;
>;
sampler2D c_diffSamp0 = sampler_state //디퓨즈 셈플러
{
    Texture   = (c_diffTex0);
    MinFilter = LINEAR;
    MagFilter = LINEAR;
    MipFilter = LINEAR;
    AddressU  = Wrap;
    AddressV  = Wrap;
};
#endif

#ifdef USING_DIFFUSE_TEX3
//FX_parameter.Diffuse1.c_diffTex1.bitmap.selectable
//FX_parameter.Diffuse1_Ch.c_diffTex1mapChannel.integer.true
texture c_diffTex1 //디퓨즈 텍스쳐
<
    string UIName = "Diffuse1";
    int Texcoord = 2;
    int MapChannel = 3;
>;

sampler2D c_diffSamp1 = sampler_state //디퓨즈 셈플러
{
    Texture   = (c_diffTex1);
    MinFilter = LINEAR;
    MagFilter = LINEAR;
    MipFilter = LINEAR;
    AddressU  = Wrap;
    AddressV  = Wrap;
};
//FX_parameter.Diffuse2.c_diffTex2.bitmap.selectable
//FX_parameter.Diffuse2_Ch.c_diffTex2mapChannel.integer.true
texture c_diffTex2 //디퓨즈 텍스쳐
<
    string UIName = "Diffuse2";
    int Texcoord   = 3;
    int MapChannel = 4;
>;

sampler2D c_diffSamp2 = sampler_state //디퓨즈 셈플러
{
    Texture   = (c_diffTex2);
    MinFilter = LINEAR;
    MagFilter = LINEAR;
    MipFilter = LINEAR;    
    AddressU  = Wrap;
    AddressV  = Wrap;
};
#endif

#ifdef USING_DIFFUSE_TEX4
//FX_parameter.Diffuse3.c_diffTex3.bitmap.selectable
//FX_parameter.Diffuse3_Ch.c_diffTex3mapChannel.integer.true
texture c_diffTex3 //디퓨즈 텍스쳐
<
    string UIName = "Diffuse3";
    int Texcoord   = 4;
    int MapChannel = 5;
>;

sampler2D c_diffSamp3 = sampler_state //디퓨즈 셈플러
{
    Texture   = (c_diffTex3);
    MinFilter = LINEAR;
    MagFilter = LINEAR;
    MipFilter = LINEAR;    
    AddressU  = Wrap;
    AddressV  = Wrap;
};
#endif

//! Layer Edge
#ifdef USING_LAYER_EDGE
//FX_parameter.layer1UseEdge.c_layerEdge1.bool.selectable
bool c_layerEdge1
<
  string UIName = "Use Edge For Layer1";
> = false;
//FX_parameter.layer2UseEdge.c_layerEdge2.bool.selectable
bool c_layerEdge2
<
  string UIName = "Use Edge For Layer2";
> = false;
//FX_parameter.layer3UseEdge.c_layerEdge3.bool.selectable
bool c_layerEdge3
<
  string UIName = "Use Edge For Layer3";
> = false;
#endif

//! Layer Shadow
#ifdef USING_LAYER_SHADOW
//FX_parameter.layer1UseSh.c_layerShadow1.bool.selectable
bool c_layerShadow1
<
  string UIName = "Use Shadow For Layer1";
> = false;
//FX_parameter.layer1UseSh.c_layerShadowColor1.color.selectable
float3 c_layerShadowColor1
<
  string UIName = "Shadow Color For Layer1";
> = float3(0.56,0.5,0.45);
//FX_parameter.layer2UseSh.c_layerShadow2.bool.selectable
bool c_layerShadow2
<
  string UIName = "Use Shadow For Layer2";
> = false;
//FX_parameter.layer2UseSh.c_layerShadowColor2.color.selectable
float3 c_layerShadowColor2
<
  string UIName = "Shadow Color For Layer2";
> = float3(0.56,0.5,0.45);
//FX_parameter.layer2UseSh.c_layerShadow3.bool.selectable
bool c_layerShadow3
<
  string UIName = "Use Shadow For Layer3";
> = false;
//FX_parameter.layer3UseSh.c_layerShadowColor3.color.selectable
float3 c_layerShadowColor3
<
  string UIName = "Shadow Color For Layer3";
> = float3(0.56,0.5,0.45);
#endif

//FX_parameter.Diff0_UVch.c_layerUV0.bool.selectable
bool c_layerUV0
<
  string UIName = "Use Extra UV For Diffuse 0";
> = false;
//FX_parameter.Diff1_UVch.c_layerUV1.bool.selectable
bool c_layerUV1
<
  string UIName = "Use Extra UV For Diffuse 1";
> = false;
//FX_parameter.Diff2_UVch.c_layerUV2.bool.selectable
bool c_layerUV2
<
  string UIName = "Use Extra UV For Diffuse 2";
> = false;
//FX_parameter.Diff3_UVch.c_layerUV3.bool.selectable
bool c_layerUV3
<
  string UIName = "Use Extra UV For Diffuse 3";
> = false;

#ifdef USING_LAYER_SCALE
//FX_parameter.Diffuse0_Scale.c_layerScale0.inversScale.selectable
float c_layerScale0
<
  string UIName = "UV Scale For Diffuse 0";
> = 1.0f;
//FX_parameter.Diffuse1_Scale.c_layerScale1.inversScale.selectable
float c_layerScale1
<
  string UIName = "UV Scale For Diffuse 1";
> = 1.0f;
//FX_parameter.Diffuse2_Scale.c_layerScale2.inversScale.selectable
float c_layerScale2
<
  string UIName = "UV Scale For Diffuse 2";
> = 1.0f;
//FX_parameter.Diffuse3_Scale.c_layerScale3.inversScale.selectable
float c_layerScale3
<
  string UIName = "UV Scale For Diffuse 3";
> = 1.0f;
#endif


//! Specular
#ifdef USING_SPEC_COLOR
//FX_parameter.Diff0_specColor.c_specColor0.color.selectable
float3 c_specColor0 //스펙큘러 컬러
<
    string UIName = "Spec Color For Diffuse 0";
> = float3( 1.0, 1.0, 1.0 );
//FX_parameter.Diff1_specColor.c_specColor1.color.selectable
float3 c_specColor1 //스펙큘러 컬러
<
    string UIName = "Spec Color For Diffuse 1";
> = float3( 1.0, 1.0, 1.0 );
//FX_parameter.Diff2_specColor.c_specColor2.color.selectable
float3 c_specColor2 //스펙큘러 컬러
<
    string UIName = "Spec Color For Diffuse 2";
> = float3( 1.0, 1.0, 1.0 );
//FX_parameter.Diff3_specColor.c_specColor3.color.selectable
float3 c_specColor3 //스펙큘러 컬러
<
    string UIName = "Spec Color For Diffuse 3";
> = float3( 1.0, 1.0, 1.0 );
#endif


#ifdef USING_SPEC_LEVEL
//FX_parameter.Diff0_speclevel.c_specLevel0.float.selectable
float c_specLevel0 //스펙큘러 강도
<
    string UIName = "Spec Level For Diffuse 0";
> = 0.16;
//FX_parameter.Diff1_speclevel.c_specLevel1.float.selectable
float c_specLevel1 //스펙큘러 강도
<
    string UIName = "Spec Level For Diffuse 1";
> = 0.16;
//FX_parameter.Diff2_speclevel.c_specLevel2.float.selectable
float c_specLevel2 //스펙큘러 강도
<
    string UIName = "Spec Level For Diffuse 2";
> = 0.16;
//FX_parameter.Diff3_speclevel.c_specLevel3.float.selectable
float c_specLevel3 //스펙큘러 강도
<
    string UIName = "Spec Level For Diffuse 3";
> = 0.16;
#endif

#ifdef USING_SPEC_GLOSS
//FX_parameter.Diff0_glossness.c_specGloss0.float.selectable
float c_specGloss0 //스펙큘러 넓이
<
    string UIName = "Spec Glossiness For Diffuse 0";
   float UIMin = -100.00;
   float UIMax = 100.00;
> = 2.8;
//FX_parameter.Diff1_glossness.c_specGloss1.float.selectable
float c_specGloss1 //스펙큘러 넓이
<
    string UIName = "Spec Glossiness For Diffuse 1";
   float UIMin = -100.00;
   float UIMax = 100.00;
> = 2.8;
//FX_parameter.Diff2_glossness.c_specGloss2.float.selectable
float c_specGloss2 //스펙큘러 넓이
<
    string UIName = "Spec Glossiness For Diffuse 2";
   float UIMin = -100.00;
   float UIMax = 100.00;
> = 2.8;
//FX_parameter.Diff3_glossness.c_specGloss3.float.selectable
float c_specGloss3 //스펙큘러 넓이
<
    string UIName = "Spec Glossiness For Diffuse 3";
   float UIMin = -100.00;
   float UIMax = 100.00;
> = 2.8;
#endif

#ifdef USING_SPEC_TEX4
  #ifndef USING_SPEC_TEX3
  #define USING_SPEC_TEX3
  #endif
#endif

#ifdef USING_SPEC_TEX3
    #ifndef USING_SPEC_TEX1
    #define USING_SPEC_TEX1
    #endif
#endif

#ifdef USING_SPEC_TEX1
//FX_parameter.Spec0.c_specTex0.bitmap.selectable
//FX_parameter.Spec0_Ch.c_specTex0mapChannel.integer.selectable
texture c_specTex0 //스펙큘러 텍스쳐
<
    string UIName = "Specular0";
    int Texcoord = 5;
    int MapChannel = 6;
>;
sampler2D c_specSamp0 = sampler_state //스펙큘러셈플러
{
    Texture   = (c_specTex0);
    MinFilter = LINEAR;
    MagFilter = LINEAR;
    MipFilter = LINEAR;
    AddressU  = Wrap;
    AddressV  = Wrap;
};

#endif
#ifdef USING_SPEC_TEX3
//FX_parameter.Spec1.c_specTex1.bitmap.selectable
//FX_parameter.Spec1_Ch.c_specTex1mapChannel.integer.selectable
texture c_specTex1 //스펙큘러 텍스쳐
<
    string UIName = "Specular1";
    int Texcoord = 6;
    int MapChannel = 7;
>;
sampler2D c_specSamp1 = sampler_state //스펙큘러셈플러
{
    Texture   = (c_specTex1);
    MinFilter = LINEAR;
    MagFilter = LINEAR;
    MipFilter = LINEAR;
    AddressU  = Wrap;
    AddressV  = Wrap;
};

//FX_parameter.Spec2.c_specTex2.bitmap.selectable
//FX_parameter.Spec2_Ch.c_specTex2mapChannel.integer.selectable
texture c_specTex2 //스펙큘러 텍스쳐
<
    string UIName = "Specular2";
    int Texcoord = 7;
    int MapChannel = 8;
>;
sampler2D c_specSamp2 = sampler_state //스펙큘러셈플러
{
    Texture   = (c_specTex2);
    MinFilter = LINEAR;
    MagFilter = LINEAR;
    MipFilter = LINEAR;
    AddressU  = Wrap;
    AddressV  = Wrap;
};


#endif
#ifdef USING_SPEC_TEX4
//FX_parameter.Spec3.c_specTex3.bitmap.selectable
texture c_specTex3 //스펙큘러 텍스쳐
<
    string UIName = "Specular3";
>;
sampler2D c_specSamp3 = sampler_state //스펙큘러셈플러
{
    Texture   = (c_specTex3);
    MinFilter = LINEAR;
    MagFilter = LINEAR;
    MipFilter = LINEAR;
    AddressU  = Wrap;
    AddressV  = Wrap;
};

#endif



//! Rim
#ifdef USING_RIM_COLOR
//FX_parameter.RimLightColor.c_rimColor.color.true
float3 c_rimColor //림라이트 컬러
<
    string UIName = "Rim Color";
> = float3( 1.0, 1.0, 1.0);
#endif

#ifdef USING_RIM_DENSITY
//FX_parameter.Diff0_rimLevel.c_rimDensity0.float.selectable
float c_rimDensity0 //림라이트 강도
<
    string UIName = "Diff0_RimLevel";
    float UIMin = -100.00;
    float UIMax = 10000.00;
> = 1.0f;
//FX_parameter.Diff1_rimLevel.c_rimDensity1.float.selectable
float c_rimDensity1 //림라이트 강도
<
    string UIName = "Diff1_RimLevel";
    float UIMin = -100.00;
    float UIMax = 10000.00;
> = 1.0f;
//FX_parameter.Diff2_rimLevel.c_rimDensity2.float.selectable
float c_rimDensity2 //림라이트 강도
<
    string UIName = "Diff2_RimLevel";
    float UIMin = -100.00;
    float UIMax = 10000.00;
> = 1.0f;
//FX_parameter.Diff3_rimLevel.c_rimDensity3.float.selectable
float c_rimDensity3 //림라이트 강도
<
    string UIName = "Diff0_RimLevel";
    float UIMin = -100.00;
    float UIMax = 10000.00;
> = 1.0f;

#endif

#ifdef USING_RIM_GLOSS
//FX_parameter.Diff0_rimGlossness.c_rimGloss0.float.selectable
float c_rimGloss0
<
    string UIName = "Diff0_RimGlossness";
    float UIMin = -100.00;
    float UIMax = 10000.00;
> = 50.0f;
//FX_parameter.Diff1_rimGlossness.c_rimGloss1.float.selectable
float c_rimGloss1
<
    string UIName = "Diff1_RimGlossness";
    float UIMin = -100.00;
    float UIMax = 10000.00;
> = 50.0f;
//FX_parameter.Diff2_rimGlossness.c_rimGloss2.float.selectable
float c_rimGloss2
<
    string UIName = "Diff2_RimGlossness";
    float UIMin = -100.00;
    float UIMax = 10000.00;
> = 50.0f;
//FX_parameter.Diff3_rimGlossness.c_rimGloss3.float.selectable
float c_rimGloss3
<
    string UIName = "Diff3_RimGlossness";
    float UIMin = -100.00;
    float UIMax = 10000.00;
> = 50.0f;
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
bool c_alphaTest
<
  string UIName = "Alpha Test";
> = true;
int c_alphaRef
<
    string UIName = "Alpha Ref";
    int UIMin = 0;
    int UIMax = 255;
> = 128;
bool c_alphaBlend
<
  string UIName = "Alpha Blend";
> = false;
int c_cullMode
<
    string UIName = "Backface Cull (1:none 2:cw 3:ccw)";
    int UIMin = 1;
    int UIMax = 3;
> = 2;


bool c_enableSpec
<
    string UIName = "Enable Specular";
> = true;
bool c_enableRim
<
    string UIName = "Enable Rim";
> = true;
bool c_enableLightmap
<
    string UIName = "Enable Lightmap";
> = true;

texture c_layerDiplace0 //디스플레이스 텍스쳐 (라이트맵 렌더링을 위해 맥스에서만 필요한 부분)
<
    string UIName = "Diplace0";
>;
sampler2D c_layerDiplace0Samp = sampler_state //디스플레이스셈플러 (라이트맵 렌더링을 위해 맥스에서만 필요한 부분)
{
    Texture   = (c_layerDiplace0);
    MinFilter = LINEAR;
    MagFilter = LINEAR;
    MipFilter = LINEAR;
    AddressU  = Wrap;
    AddressV  = Wrap;
};
texture c_layerDiplace1 //디스플레이스 텍스쳐 (라이트맵 렌더링을 위해 맥스에서만 필요한 부분)
<
    string UIName = "Diplace1";
>;
sampler2D c_layerDiplace1Samp = sampler_state //디스플레이스셈플러 (라이트맵 렌더링을 위해 맥스에서만 필요한 부분)
{
    Texture   = (c_layerDiplace1);
    MinFilter = LINEAR;
    MagFilter = LINEAR;
    MipFilter = LINEAR;
    AddressU  = Wrap;
    AddressV  = Wrap;
};
texture c_layerDiplace2 //디스플레이스 텍스쳐 (라이트맵 렌더링을 위해 맥스에서만 필요한 부분)
<
    string UIName = "Diplace2";
>;
sampler2D c_layerDiplace2Samp = sampler_state //디스플레이스셈플러 (라이트맵 렌더링을 위해 맥스에서만 필요한 부분)
{
    Texture   = (c_layerDiplace2);
    MinFilter = LINEAR;
    MagFilter = LINEAR;
    MipFilter = LINEAR;
    AddressU  = Wrap;
    AddressV  = Wrap;
};
texture c_layerDiplace3 //디스플레이스 텍스쳐 (라이트맵 렌더링을 위해 맥스에서만 필요한 부분)
<
    string UIName = "Diplace3";
>;
sampler2D c_layerDiplace3Samp = sampler_state //디스플레이스셈플러 (라이트맵 렌더링을 위해 맥스에서만 필요한 부분)
{
    Texture   = (c_layerDiplace3);
    MinFilter = LINEAR;
    MagFilter = LINEAR;
    MipFilter = LINEAR;
    AddressU  = Wrap;
    AddressV  = Wrap;
};
#endif

/////////////////////////////////////////////////////////////////////////////////////////////



void DefaultVS(
     float4 vPos          : POSITION
    ,float3 vNormal       : NORMAL
    ,float2 vTexDiff0     : TEXCOORD0   //! Diffuse 0 UV
#ifdef LIGHTMAP
    ,float2 vTexLtMap     : TEXCOORD1   //! Lightmap UV
#endif
    ,float2 vTexDiff1     : TEXCOORD2   //! Diffuse 1 UV
    ,float2 vLayerBlend   : TEXCOORD3   //! Layer Blend Alpha X,Y
    ,float2 vVertexColor  : TEXCOORD4   //! Vertex Color R,G

    ,float2 vTempExtra    : TEXCOORD6   //! Layer Blend Alpah Z & Vertex Color B
                                        //! XYZ 좌표 사용이 불가능하여 채널을 추가로 사용
    
    , out float4 oPos       : POSITION

#ifdef USING_VERTEX_COLOR
    , out half3 oColor     : COLOR0
#endif

    , out half3 oLayerBlend: COLOR1
    
    , out float4 oTexLayer01 : TEXCOORD0
    , out float4 oTexLayer23 : TEXCOORD1
//    , out float2 oTexLayer2 : TEXCOORD2 //! Texcoord가 줄어 하드웨어에 따라 최적화 효과가 있기에 줄였습니다.
//    , out float2 oTexLayer3 : TEXCOORD3
    
#ifdef LIGHTMAP
    , out float2 oTexLtMap  : TEXCOORD4
#endif

#ifdef RIM
    , out half oRim     : TEXCOORD5
#endif

#ifdef SPECULAR
    , out half oSpec       : TEXCOORD6
#endif

#ifdef ADDFOG
    , out half oAddFog      : TEXCOORD7
#endif

#ifdef _FOG_
    , out half oFog        : FOG
#endif
    )
{
    oPos = mul(vPos, g_WVP);

#ifdef LAYER_BLEND_DIFFUSE
    oPos = float4(-1.f + vTexLtMap.x*2.0f, 1.f - vTexLtMap.y*2.0f, 1.0f, 1.0f);
#endif
#ifdef LAYER_BLEND_SPECULAR
    oPos = float4(-1.f + vTexLtMap.x*2.0f, 1.f - vTexLtMap.y*2.0f, 1.0f, 1.0f);
#endif
    
    oTexLayer01.xy = (c_layerUV0 ? vTexDiff1 : vTexDiff0) * c_layerScale0;
    oTexLayer01.zw = (c_layerUV1 ? vTexDiff1 : vTexDiff0) * c_layerScale1;
    oTexLayer23.xy = (c_layerUV2 ? vTexDiff1 : vTexDiff0) * c_layerScale2;
    oTexLayer23.zw = (c_layerUV3 ? vTexDiff1 : vTexDiff0) * c_layerScale3;
    
#ifdef LIGHTMAP
    oTexLtMap = vTexLtMap;
#endif

//#ifdef SPLATTING
  #ifdef THIS_IS_MAX
    oLayerBlend.x = vLayerBlend.x;
    oLayerBlend.y = vLayerBlend.y;
    oLayerBlend.z = vTempExtra.x;
  #else
    oLayerBlend.x = vLayerBlend.x;
    oLayerBlend.y = -1.0f + vLayerBlend.y;
    oLayerBlend.z = vTempExtra.x;
  #endif
//#endif

#ifdef USING_VERTEX_COLOR
  #ifdef THIS_IS_MAX
    oColor.x = vVertexColor.x;
    oColor.y = vVertexColor.y;
    oColor.z = vTempExtra.y;
  #else
    oColor.x = vVertexColor.x;
    oColor.y = 1.f - vVertexColor.y;
    oColor.z = 1.f - vTempExtra.y;
  #endif
#endif

#ifdef USING_VIEW_DIR
    half3 viewDir = normalize(vPos.xyz - g_worldCamera);
#endif

#ifdef RIM
	oRim = (dot(viewDir, vNormal))*0.5+0.5;
//    //! 코드 최적화
//    half rim = (dot(viewDir, vNormal))*0.5+0.5;
//    oRim = c_rimDensity * pow(rim, c_rimGloss) * c_rimColor;      //! 계산 순서에 따른 최적화 비교
#endif

#ifdef SPECULAR
    half3 vReflect = reflect(viewDir, vNormal);
    oSpec = max(0, dot(g_lightDir, vReflect));
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
}

void DefaultPS(
     float4 vTexLayer01 : TEXCOORD0
    ,float4 vTexLayer23 : TEXCOORD1

#ifdef LIGHTMAP
    ,float2 vTexLtMap  : TEXCOORD4
#endif

#ifdef RIM
    ,half vRim     : TEXCOORD5
#endif

#ifdef SPECULAR
    ,half vSpec       : TEXCOORD6
#endif
                 
#ifdef ADDFOG
    ,half fAddFog : TEXCOORD7
#endif

#ifdef USING_VERTEX_COLOR
    ,half3 vColor     : COLOR0
#endif

//#ifdef SPLATTING
    ,half3 vLayerBlend: COLOR1
//#endif

#ifdef _FOG_
    ,half fFog : FOG
#endif
    , out half4 oColor : COLOR0 )
{
#ifdef USING_DIFFUSE_TEX1
    half4 diff0 = tex2D(c_diffSamp0, vTexLayer01.xy);
#endif
#ifdef USING_DIFFUSE_TEX3
    half4 diff1 = tex2D(c_diffSamp1, vTexLayer01.zw);
    half4 diff2 = tex2D(c_diffSamp2, vTexLayer23.xy);
#endif
#ifdef USING_DIFFUSE_TEX4
    half4 diff3 = tex2D(c_diffSamp3, vTexLayer23.zw);
#endif

#ifdef LIGHTMAP
    half3 ltmap = tex2D(c_ltmapSamp, vTexLtMap).rgb;

    #ifdef ONLY_LIGHTMAP_COLOR
    oColor.rgb = ltmap.rgb;
    oColor.a = 1.0f;
    return;
    #endif
    ltmap = ltmap / (1.0f - ltmap*0.99999);                   //by mars. 2011.03.22     무한대값 수정
//    ltmap = pow(ltmap, c_ltmapDecomp);


    #ifdef USING_VERTEX_COLOR
        #ifdef THIS_IS_MAX
            vColor = float3(vColor.r, -vColor.g, -vColor.b);
        #endif
        ltmap.rgb = max(0.f, ltmap.rgb * (0.5f + vColor.rgb) + (vColor.rgb - 0.5));
    #endif

#endif
//!#modify byMars
#ifdef SPECULAR
  #ifdef AMOLED
        #ifdef USING_SPEC_TEX1
                half3 emissive0 = tex2D(c_specSamp0, vTexLayer01.xy)*c_specLevel0; 
        #endif
        #ifdef USING_SPEC_TEX3
                half3 emissive1 = tex2D(c_specSamp1, vTexLayer01.zw)*c_specLevel1;
                half3 emissive2 = tex2D(c_specSamp2, vTexLayer23.xy)*c_specLevel2;
        #endif
        #ifdef USING_SPEC_TEX4
                half3 emissive3 = tex2D(c_specSamp3, vTexLayer23.zw)*c_specLevel3;
        #endif
  #else
    #ifdef USING_SPEC_TEX1
        half3 spec0 = c_specLevel0 * c_specColor0 * tex2D(c_specSamp0, vTexLayer01.xy).x;
    #endif
    #ifdef USING_SPEC_TEX3
        half3 spec1 = c_specLevel1 * c_specColor1 * tex2D(c_specSamp1, vTexLayer01.zw).x;
        half3 spec2 = c_specLevel2 * c_specColor2 * tex2D(c_specSamp2, vTexLayer23.xy).x;
    #endif
    #ifdef USING_SPEC_TEX4
        half3 spec3 = c_specLevel3 * c_specColor3 * tex2D(c_specSamp3, vTexLayer23.zw).x;
    #endif
  #endif
#endif
//!#end byMars

#ifdef SPLATTING
    #ifdef USING_LAYER_EDGE
        half layerAlpha1 = c_layerEdge1 ? smoothstep(1.0f - vLayerBlend.x, 1.0002, diff1.a + vLayerBlend.x) : (diff1.a * vLayerBlend.x);
        half layerAlpha2 = c_layerEdge2 ? smoothstep(1.0f - vLayerBlend.y, 1.0002, diff2.a + vLayerBlend.y) : (diff2.a * vLayerBlend.y);
        half layerAlpha3 = c_layerEdge3 ? smoothstep(1.0f - vLayerBlend.z, 1.0002, diff3.a + vLayerBlend.z) : (diff3.a * vLayerBlend.z);
    #else
        half layerAlpha1 = vLayerBlend.x;
        half layerAlpha2 = vLayerBlend.y;
        half layerAlpha3 = vLayerBlend.z;
    #endif
    
    #ifdef USING_LAYER_SHADOW
        if (c_layerShadow1)
        {
            diff1.rgb *= (1.0+0.7*(1.0-pow(layerAlpha1,3.0)) - (3.0*(1.01-pow(layerAlpha1,0.8))*(1.0-c_layerShadowColor1)));
        }
        if (c_layerShadow2)
        {
            diff2.rgb *= (1.0+0.7*(1.0-pow(layerAlpha2,3.0)) - (3.0*(1.01-pow(layerAlpha2,0.8))*(1.0-c_layerShadowColor2)));
        }
        if (c_layerShadow3)
        {
            diff3.rgb *= (1.0+0.7*(1.0-pow(layerAlpha3,3.0)) - (3.0*(1.01-pow(layerAlpha3,0.8))*(1.0-c_layerShadowColor3)));
        }
    #endif
    
    oColor.rgb = lerp(diff0.rgb , diff1.rgb, layerAlpha1);
    oColor.rgb = lerp(oColor.rgb, diff2.rgb, layerAlpha2);
    oColor.rgb = lerp(oColor.rgb, diff3.rgb, layerAlpha3);
#else
    oColor.rgb = lerp(diff0.rgb , diff1.rgb, vLayerBlend.x);
    oColor.rgb = lerp(oColor.rgb, diff2.rgb, vLayerBlend.y);
    oColor.rgb = lerp(oColor.rgb, diff3.rgb, vLayerBlend.z);
#endif

#ifdef LAYER_BLEND_DIFFUSE
    oColor.a = 1.0f;
    return;
#endif

#ifdef ONLY_DIFFUSE_COLOR
    oColor.a = 1.0f;
    return;
#endif

    #ifdef USING_LIGHTMAP_TONE
    oColor.rgb = pow(oColor.rgb, 1.22);
    #endif

//!#modify byMars
#ifdef SPECULAR
  #ifdef AMOLED
    	#ifdef SPLATTING
          half3 emissiveV = lerp(emissive0,emissive1,layerAlpha1);
          emissiveV = lerp(emissiveV,emissive2,layerAlpha2);
          emissiveV = lerp(emissiveV,emissive3,layerAlpha3);
    	#else
          half3 emissiveV = lerp(emissive0,emissive1,vLayerBlend.x);
          emissiveV = lerp(emissiveV,emissive2,vLayerBlend.y);
          emissiveV = lerp(emissiveV,emissive3,vLayerBlend.z);
    	#endif
  #else 
    	#ifdef SPLATTING
    	    half3 specLevel = lerp(spec0, spec1, layerAlpha1);
    	    specLevel = lerp(specLevel, spec2, layerAlpha2);
    	    specLevel = lerp(specLevel, spec3, layerAlpha3);
    	    
    	    half specGloss = lerp(c_specGloss0, c_specGloss1, layerAlpha1);
    	    specGloss = lerp(specGloss, c_specGloss2, layerAlpha2);
    	    specGloss = lerp(specGloss, c_specGloss3, layerAlpha3);
    	    
    	#else
    	    half3 specLevel = lerp(spec0, spec1, vLayerBlend.x);
    	    specLevel = lerp(specLevel, spec2, vLayerBlend.y);
    	    specLevel = lerp(specLevel, spec3, vLayerBlend.z);
    	    
    	    half specGloss = lerp(c_specGloss0, c_specGloss1, vLayerBlend.x);
    	    specGloss = lerp(specGloss, c_specGloss2, vLayerBlend.y);
    	    specGloss = lerp(specGloss, c_specGloss3, vLayerBlend.z);
    	#endif
    #ifdef ONLY_SPECULAR_COLOR
    oColor.rgb = specLevel.rgb;
    oColor.a = 1.0f;
    return;
    #endif

    #ifdef LAYER_BLEND_SPECULAR
    oColor.rgb = specLevel.rgb;
    oColor.a = 1.0f;
    return;
    #endif

    half3 specLight = specLevel * pow(vSpec, specGloss);
    #ifdef LIGHTMAP
    specLight *= ltmap;
    #endif
  #endif

#ifdef ONLY_SELFILLUMINATION_COLOR
    oColor.rgb = (half3)0;
    oColor.a = 1.0f;

    #ifdef AMOLED
        oColor.rgb = emissiveV.rgb;
    #endif

    return;
#endif

#endif //SPECULAR
//!#end byMars

#ifdef RIM
	#ifdef SPLATTING
	    half3 rimDensity = lerp(c_specColor0 * c_rimDensity0,c_specColor1 * c_rimDensity1,layerAlpha1);
	    rimDensity = lerp(rimDensity,c_specColor2 * c_rimDensity2,layerAlpha2);
	    rimDensity = lerp(rimDensity,c_specColor3 * c_rimDensity3,layerAlpha3);
	    
	    half rimGloss = lerp(c_rimGloss0,c_rimGloss1,layerAlpha1);
	    rimGloss = lerp(rimGloss,c_rimGloss2,layerAlpha2);
	    rimGloss = lerp(rimGloss,c_rimGloss3,layerAlpha3);
	#else
	    half3 rimDensity = lerp(c_specColor0 * c_rimDensity0,c_specColor1 * c_rimDensity1,vLayerBlend.x);
	    c_rimDensity0 = lerp(rimDensity,c_specColor2 * c_rimDensity2,vLayerBlend.y);
	    c_rimDensity0 = lerp(rimDensity,c_specColor3 * c_rimDensity3,vLayerBlend.z);
	    
	    half rimGloss = lerp(c_rimGloss0,c_rimGloss1,vLayerBlend.x);
	    c_rimGloss0 = lerp(rimGloss,c_rimGloss2,vLayerBlend.y);
	    c_rimGloss0 = lerp(rimGloss,c_rimGloss3,vLayerBlend.z);
	#endif
	
	half3 pRim = rimDensity * pow(vRim, rimGloss) * c_rimColor;
	
#endif

#ifdef LIGHTMAP
    #ifdef RIM
    ltmap += pRim; 
    #endif

    #ifdef SPECULAR
      #ifdef AMOLED              //!#modify byMars
      #else
        ltmap += specLight;
      #endif
    #endif

//!#modify byMars    //날씨 테스트
#ifdef USING_WEATHER
    ltmap.rgb = pow(ltmap.rgb, c_weatherContrast);//+c_weatherBrightness;
    ltmap.rgb *= c_weatherColor;    
#endif
//!#end byMars

    oColor.rgb *= ltmap.rgb;
    #ifdef USING_LIGHTMAP_TONE
//!Old    oColor.rgb /= (1.0f + (oColor.rgb * c_ltmapTone));          //by mars. 2011.03.16
    oColor.rgb /= (1.0f + (oColor.rgb * g_ltmapTone));                //by mars. 2011.03.16 ini에서 제어가능하도록 수정
    #endif
//!#modify byMars
    #ifdef AMOLED
       oColor.rgb += emissiveV;         
    #endif
//!#end byMars
#endif

#ifdef ADDFOG
    oColor.rgb = lerp(oColor.rgb, 1, fAddFog*g_addfogColor.rgb);
    //oColor.rgb += (1.0 - oColor.rgb) * g_addfogColor * fAddFog;
#endif
#ifdef _FOG_
    oColor.rgb = lerp(oColor.rgb, g_fogColor.rgb, fFog);
#endif

#ifdef CONSTANT_COLOR
    oColor = float4(1, 0, 0, 1);
#endif

#ifdef USING_INDIRECT
    oColor.a *= g_indirect.a;
#else
    oColor.a = 1.0f;

#endif
//oColor = float4(vColor.r, vColor.g, vColor.b, 1.0f);
//oColor = float4(vColor.bbb, 1.0f);
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
      DestBlend 		= INVSRCALPHA;
      SrcBlend 		= SRCALPHA;

      //VertexShader = compile vs_3_0 PreviewVS();
      //PixelShader  = compile ps_3_0 PreviewPS();
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
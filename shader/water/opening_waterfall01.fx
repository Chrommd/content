/*------------------------------------------------------------___-------------------------------------------------------
                                                             /   |                                                      
                                                            / /| |                                                      
                                                           / ___ |                                                      
                                            P R O J E C T /_/  |_| L I C E                                              
                                        Copyright (C) 2005-2007 NTREEV SOFT Inc.                                        
----------------------------------------------------------------------------------------------------------------------*/

//#define ps_2_0 2
//#define PS_VER ps_2_0
#ifndef VS_VER
#define VS_VER vs_3_0
#endif
#ifndef PS_VER
#define PS_VER3_0
#define PS_VER ps_3_0
#endif

#ifndef USING_LAYER_SCALE
#define USING_LAYER_SCALE
#endif
#ifndef USING_DIFFUSE_TEX4
#define USING_DIFFUSE_TEX4
#endif

#ifndef THIS_IS_CLIENT
  #ifndef THIS_IS_MAX
  #define THIS_IS_MAX
  #endif
#endif
#ifdef THIS_IS_MAX
string ParamID = "0x0";
  //uv1 : 라이트맵
  //uv2 : 컬러
  //uv3 : 파도의 높이
  //uv4 : 투명도
#endif  
float3 waveScale = float3( 1.0, 0.5, 1.0 ); // 각 파도의 크기(넓이, 작을수록 파도는 커짐, flaot3(디퓨즈1, 디퓨즈2, 알파스크롤))
float3 localWaveSpeed = float3( 1.0, 0.45, 0.75); // 각 파도의 속도(클수록 파도는 빨라짐)
float3 waveDen = float3(0.0,1.0,0.0); //각 파도의 영향력(클수록 높음)
float2 waveDir = float2( 0.0, -3.5); // 파도의 방향(전체 속도 포함)

#include "../include/fog.fxh"

#ifdef THIS_IS_MAX
float g_timeScroll : TIME;
#else
float g_timeScroll : TimeScroll
<
   string UIName = "fadeExp";
   string UIWidget = "Numeric";
   bool UIVisible =  true;
   float UIMin = 0.00;
   float UIMax = 5.00;
> = float( 1 );
#endif

//float4x4 view_proj_matrix : PROJECTION;
float4 g_viewPos : WORLDCAMERAPOSITION;
float4x4 g_worldViewProjMatrix : WORLDVIEWPROJ;
float4x4 World : WORLD;

//FX_parameter.alphaBase.g_alphaBaseTexture.bitmap.selectable
//FX_parameter.alphaBase_Ch.g_alphaBaseTextureChannel.integer.true
texture g_alphaBaseTexture< 
    string UIName = "alphaBase";
    int Texcoord = 0;
    int MapChannel = 1;
>;
sampler g_alphaBaseSampler = sampler_state
{
   Texture = (g_alphaBaseTexture);
   ADDRESSU = WRAP;
   ADDRESSV = WRAP;
   MAGFILTER = LINEAR;
   MINFILTER = LINEAR;
   MIPFILTER = LINEAR;
};
//FX_parameter.alphaScroll.g_alphaScrollTexture.bitmap.selectable
//FX_parameter.alphaScroll_Ch.g_alphaScrollTextureChannel.integer.true
texture g_alphaScrollTexture< 
    string UIName = "alphaScroll";
    int Texcoord = 1;
    int MapChannel = 2;
>;
sampler g_alphaScrollSampler = sampler_state
{
   Texture = (g_alphaScrollTexture);
   ADDRESSU = WRAP;
   ADDRESSV = WRAP;
   MAGFILTER = LINEAR;
   MINFILTER = LINEAR;
   MIPFILTER = LINEAR;
};
//FX_parameter.Diffuse1.Tex0.bitmap.selectable
//FX_parameter.Diffuse1_Ch.Tex0mapChannel.integer.true
texture Tex0
<
    string UIName = "Diffuse1";
    int Texcoord = 2;
    int MapChannel = 3;
>;

sampler Diff1Samp = sampler_state
{
    Texture   = (Tex0);
    MinFilter = LINEAR;
    MagFilter = LINEAR;
    MipFilter = LINEAR;    
    AddressU  = Wrap;
    AddressV  = Wrap;
};
//FX_parameter.LightMap.LtMap.bitmap.selectable
//FX_parameter.LightMap_Ch.LtMapmapChannel.integer.true
texture LtMap
<
    string UIName  = "Light";
    int Texcoord   = 3;
    int MapChannel = 4;
>;
    
sampler LtMapSamp = sampler_state
{
    Texture   = (LtMap);
    MinFilter = LINEAR;
    MagFilter = LINEAR;
    MipFilter = LINEAR;   
    AddressU  = Wrap;
    AddressV  = Wrap;
};






struct VS_OUTPUT {
   float4 oPos:     POSITION;
   float4 Pos:     TEXCOORD0;
   float3 normal:  TEXCOORD1;
   float4 waveDiffuse      : TEXCOORD2;
   float2 waveAlpha      : TEXCOORD3;
   float2 uv_ltmap   : TEXCOORD4;
   float3 viewVec     : TEXCOORD5;

};

VS_OUTPUT VSmain(
   float4 Pos      : POSITION, 
   float3 normal      : NORMAL,
   float2 uv_diff1 : TEXCOORD0,
   float2 uv_ltmap : TEXCOORD1,
   float3  uv_wave  : TEXCOORD2,
   float3  uv_color  : TEXCOORD3
){
   VS_OUTPUT Out;
   Out.oPos = mul(Pos,  g_worldViewProjMatrix);
   
   Out.Pos = Pos;
   waveDir *= g_timeScroll;
#ifdef THIS_IS_MAX
   waveDir *= 0.01;
   Out.normal = normalize(mul(normal, (float3x3)World));
#else
   Out.normal = normal;
#endif 
   Out.waveDiffuse.xy = uv_diff1.xy * waveScale.x + waveDir*localWaveSpeed.x;
   Out.waveDiffuse.zw = uv_diff1.xy * waveScale.y + waveDir*localWaveSpeed.y;
   Out.waveAlpha.xy = uv_diff1.xy * waveScale.z + waveDir*localWaveSpeed.z;

   float4 viewVec = Pos - g_viewPos;
   
   Out.viewVec = viewVec;
   Out.uv_ltmap = uv_ltmap;
//   Out.fog.x = ComputeLinearFog(Out.oPos.z);
//   Out.fog.y = ComputeAddFog(Out.oPos.z);
   
   return Out;
}

float4 PSmain(
   float4 Pos:     TEXCOORD0,
   float3 normal:  TEXCOORD1,
   float4 waveDiffuse      : TEXCOORD2,
   float2 waveAlpha      : TEXCOORD3,
   float2 uv_ltmap   : TEXCOORD4,
   float3 viewVec     : TEXCOORD5
) : COLOR {
   viewVec = normalize(viewVec);

   half alpha = tex2D(g_alphaBaseSampler, uv_ltmap.xy).x;
   alpha *= lerp(1.0f, tex2D(g_alphaScrollSampler, waveAlpha.xy).x, waveDen.z);
   
   half4 diffuse = tex2D(Diff1Samp, waveDiffuse.xy) * waveDen.x;
   
   diffuse += tex2D(Diff1Samp, waveDiffuse.zw) * waveDen.y;
//return diffuse;
   half3 light = tex2D(LtMapSamp, uv_ltmap.xy);
   
   diffuse.rgb *= light;
   diffuse.a *= alpha;
   //diffuse.rgb = alpha.xxx;
   //diffuse.a = 1.f;
   return diffuse;
}

technique RenderScene_2_0
{
   pass Object
   {
      VertexShader = compile VS_VER VSmain();
      PixelShader = compile PS_VER PSmain();
   }
}
technique RenderPreview_2_0
{
   pass Object
   {
      VertexShader = compile VS_VER VSmain();
      PixelShader = compile PS_VER PSmain();
   }

}

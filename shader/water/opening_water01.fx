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
#endif
  //uv1 : 라이트맵
  //uv2 : 컬러
  //uv3 : 파도의 높이
  //uv4 : 투명도
  
float4 fadeColor = float4( 0.1, 0.1, 0.3, 1.00 ); // 가까운 물의 색
float fadeExp = float( 2.0 ); //가까운 물의 색이 미치는 범위
float fadeDen = float( 1.0 ); //가까이 물의 색이 미치는 강도

float waterColorDen = float( 0.9 ); // 물의 디퓨즈&라이트 맵이 물의 색에 미치는 강도
float3 waveDen = float3( 0.062, 0.12, 0.014 ); // 파도의 세기(높이, 클수록 파도는 높아짐)
float3 waveScale = float3( 0.08, 0.25, 0.28 ); // 파도의 크기(넓이, 작을수록 파도는 커짐)
float3 localWaveSpeed = float3( 0.10, 0.1, 0.10); // 각 파도의 속도(클수록 파도는 빨라짐)
float2 waveDir = float2( -3.24, -6.24); // 파도의 방향(전체 속도 포함)

float diffWave = float(0.1); // 디퓨즈 흐르는 속도
float shadowDistort = float(0.0); //그림자가 일그러지는 정도

float alphaLow = float( 0.5 ); // 가까운 투명도 물의 투명도
float alphaWidthHigh = float( 10.0 ); // 가가운 투명도가 미치는 먼 범위(1.0이 수평선, 0.0이 카메라 바로 아래)
float alphaWidthLow = float( -10.0 ); // 가가운 투명도가 미치는 가까운 범위(1.0이 수평선, 0.0이 카메라 바로 아래)

float sunPower = float( 0.99 ); // 태양맵의 강도

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


//FX_parameter.g_environmentTexture.g_environmentTexture.bitmap.selectable
//FX_parameter.g_environmentTexture_Ch.g_environmentTexturemapChannel.integer.true
texture g_environmentTexture< 
    string UIName = "env";
    int Texcoord = 0;
    int MapChannel = 1;
>;
samplerCUBE Environment = sampler_state
{
   Texture = (g_environmentTexture);
   ADDRESSU = CLAMP;
   ADDRESSV = CLAMP;
   MAGFILTER = LINEAR;
   MINFILTER = LINEAR;
   MIPFILTER = LINEAR;
};
//FX_parameter.g_bumpTexture.g_bumpTexture.bitmap.selectable
//FX_parameter.g_bumpTexture_Ch.g_bumpTexturemapChannel.integer.true
texture g_bumpTexture< 
    string UIName = "Wave";
    int Texcoord = 1;
    int MapChannel = 2;
>;
sampler g_bumpSampler = sampler_state
{
   Texture = (g_bumpTexture);
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
   float3 viewVec: TEXCOORD2;
   float4 wave0      : TEXCOORD3;
   float2 wave1      : TEXCOORD4;
   float2 uv_diff1   : TEXCOORD5;
   float2 uv_ltmap   : TEXCOORD6;
   float3 uv_color   : COLOR;
   float2 fog : TEXCOORD7;

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
   g_timeScroll *= 0.00000000;
   waveDir *= 0.0001;
   waveDir = float2(waveDir.x, -waveDir.y);
   Out.wave0.wx = uv_wave.xy * waveScale.x + waveDir*localWaveSpeed.x + float2(-g_timeScroll*3.8, 0)*waveScale.x;
   Out.wave0.yz = uv_wave.xy * waveScale.y + waveDir*localWaveSpeed.y + float2(0, -g_timeScroll*3)*waveScale.y;
   Out.wave1.xy = uv_wave.xy * waveScale.z + waveDir*localWaveSpeed.z + (g_timeScroll*1.24)*waveScale.z;
   Out.normal = normalize(mul(normal, (float3x3)World));
#else
   Out.wave0.wx = uv_wave.xy * waveScale.x + waveDir*localWaveSpeed.x + float2(-g_timeScroll*3.8, 0)*localWaveSpeed.x;
   Out.wave0.yz = uv_wave.xy * waveScale.y + waveDir*localWaveSpeed.y + float2(0, -g_timeScroll*3)*localWaveSpeed.y;
   Out.wave1.xy = uv_wave.xy * waveScale.z + waveDir*localWaveSpeed.z + (g_timeScroll*1.24)*localWaveSpeed.z;
   Out.normal = normal;
#endif 
   float4 viewVec = Pos - g_viewPos;
   
   Out.viewVec = viewVec;
   Out.uv_color = uv_color;
   Out.uv_diff1 = uv_diff1+waveDir*diffWave;
   Out.uv_ltmap = uv_ltmap;
   Out.fog.x = ComputeLinearFog(Out.oPos.z);
   Out.fog.y = ComputeAddFog(Out.oPos.z);
   
   return Out;
}

float4 PSmain(
   float4 Pos:     TEXCOORD0,
   float3 normal:  TEXCOORD1,
   float3 viewVec: TEXCOORD2,
   float4 wave0      : TEXCOORD3,
   float2 wave1      : TEXCOORD4,
   float2 uv_diff1   : TEXCOORD5,
   float2 uv_ltmap   : TEXCOORD6,
   float3 uv_color   : COLOR,
   float2 fog : TEXCOORD7
) : COLOR {
   viewVec = normalize(viewVec);
   float lVal = abs(frac((wave0.w+wave0.x)*10)*2-1);
//return float4(1,0,0, 1);

#ifdef PS_VER3_0
   float2 bumpA = tex2D(g_bumpSampler, wave0.wx).xy;
   float2 bumpA_B = tex2D(g_bumpSampler, wave0.wx+0.5).xy;
   bumpA = (lerp(bumpA, bumpA_B, lVal)-0.5)*waveDen.x;
   float2 bumpB = tex2D(g_bumpSampler, wave0.yz).xy;
   float2 bumpB_B = tex2D(g_bumpSampler, wave0.yz+0.5).xy;
   bumpB = (lerp(bumpB, bumpB_B, lVal)-0.5)*waveDen.y;
   float2 bumpC = tex2D(g_bumpSampler, wave1.xy).xy;
   float2 bumpC_B = tex2D(g_bumpSampler, wave1.xy+0.5).xy;
   bumpC = (lerp(bumpC, bumpC_B, lVal)-0.5)*waveDen.z;
   float3 bump = normalize(float3(((bumpA + bumpB + bumpC) / 3),1.0f));
#else
   float2 bumpA = tex2D(g_bumpSampler, wave0.wx).xy;
   bumpA = (bumpA-0.5)*waveDen.x;
//   float3 bump = normalize(float3((bumpA * wave1.z),1.0f));
   float2 bumpB = tex2D(g_bumpSampler, wave0.yz).xy;
   bumpB = (bumpB-0.5)*waveDen.y;
//   float3 bump = normalize(float3(((bumpA + bumpB + bumpC) * wave1.z / 3),1.0f));
   float2 bumpC = tex2D(g_bumpSampler, wave1.xy).xy;
   bumpC = (bumpC-0.5)*waveDen.z;
   float3 bump = normalize(float3(((bumpA + bumpB) / 2),1.0f));
#endif

//   float3 bump = normalize(float3(((bumpA + bumpB + bumpC) / 3),1.0f));
//return float4((bump.xy+0.5) ,0, 1);
//return float4(wave1.zzz, 1);

#ifndef THIS_IS_MAX
   bump = bump.xzy;
#endif

   float4 clrBase0 = tex2D(Diff1Samp, uv_diff1.xy + (bump.xy * shadowDistort)); 
   float waveDenFromA = pow(clrBase0.a,0.5);
   float3 reflVec = reflect(viewVec, bump);
   waveDenFromA = 1.0f;
   float4 refl = texCUBE(Environment, reflVec.xyz);

    float4 ltmap = tex2D(LtMapSamp, uv_ltmap.xy + (bump.xy * shadowDistort));
//return float4(ltmap.aaa, 1);
   float4 sun = saturate(refl - 0.2) * 4 * sunPower * ltmap.x;
   sun = max(0.0f, pow(sun-0.1,3.5))*3-0.3;
//   sun = min(sun, 0.7);
   refl = saturate(refl * 2);
   float frnl = pow((1.0f - dot(bump, -viewVec)),2.0) ;
   float4 reflA = lerp( refl, clrBase0, (waterColorDen * frnl));
//return float4(reflA.xyz, 1);
   reflA = (lerp( reflA, fadeColor, saturate(pow(1-frnl, fadeExp)*fadeDen)) * ((ltmap.x*0.5)+0.5)) + sun;
//return float4(reflA.xyz, 1);
   reflA.a = min((saturate(((frnl-alphaWidthLow)/(1-alphaWidthLow))/(alphaWidthHigh-alphaWidthLow))*(1-alphaLow)+alphaLow),ltmap.a) + (sun*waveDenFromA);
   reflA.a = (sun.x+sun.y+sun.z)/3 * ltmap.a;
//   reflA.xyz = float3(1,1,1);
   reflA.xyz = reflA.aaa;
   
//return float4(reflA.xyz, 1);
#ifndef THIS_IS_MAX
    reflA.rgb += (1.0 - reflA.rgb) * g_addfogColor * fog.y;
    reflA.rgb = lerp(reflA.rgb, g_fogColor, fog.x);
#endif
//reflA.a = 0.0f;
//reflA.xyz = float3(1,1,1);
   return reflA;
  
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

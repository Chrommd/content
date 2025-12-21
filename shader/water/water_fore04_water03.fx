//uv1 : 라이트맵
//uv2 : 컬러
//uv3 : 파도의 높이
//uv4 : 투명도

float4 fadeColor = float4( 0.55, 0.4, 0.6, 1.00 ); // 가까운 물의 색
float fadeExp = float( 1.2 ); //가까운 물의 색이 미치는 범위
float fadeDen = float( 0.2 ); //가까이 물의 색이 미치는 강도

float waterColorDen = float( 0.999 ); // 물의 디퓨즈&라이트 맵이 물의 색에 미치는 강도
float3 waveDen = float3( 0.212, 0.32, 0.12 ); // 파도의 세기(높이, 클수록 파도는 높아짐)
float3 waveScale = float3( 0.01, 0.043, 0.177 ); // 파도의 크기(넓이, 작을수록 파도는 커짐)
float3 localWaveSpeed = float3( 0.02, 4.37, 12.0); // 각 파도의 속도(클수록 파도는 빨라짐)
float2 waveDir = float2( 130, 92.4); // 파도의 방향(전체 속도 포함)

float diffWave = float(0.004); // 디퓨즈 흐르는 속도
float shadowDistort = float(0.0); //그림자가 일그러지는 정도

float alphaLow = float( 0.2 ); // 가까운 투명도 물의 투명도
float alphaWidthHigh = float( 1.4 ); // 가가운 투명도가 미치는 먼 범위(1.0이 수평선, 0.0이 카메라 바로 아래)
float alphaWidthLow = float( -2.0 ); // 가가운 투명도가 미치는 가까운 범위(1.0이 수평선, 0.0이 카메라 바로 아래)

float sunPower = float( 0.99 ); // 태양맵의 강도


#include "../include/fog.fxh"
float g_timeScroll : TimeScroll
<
   string UIName = "fadeExp";
   string UIWidget = "Numeric";
   bool UIVisible =  true;
   float UIMin = 0.00;
   float UIMax = 5.00;
> = float( 1 );
//float4x4 view_proj_matrix : PROJECTION;
float4 g_viewPos : WORLDCAMERAPOSITION;
float4x4 g_worldViewProjMatrix : WORLDVIEWPROJ;
//float4x4 World : WORLD;

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
    MipFilter = NONE;    
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
    MipFilter = NONE;    
    AddressU  = Wrap;
    AddressV  = Wrap;
};






struct VS_OUTPUT {
   float4 oPos:     POSITION;
   float4 Pos:     TEXCOORD0;
   float3 normal:  TEXCOORD1;
   float3 viewVec: TEXCOORD2;
   float4 wave0      : TEXCOORD3;
   float3 wave1      : TEXCOORD4;
   float2 uv_diff1   : TEXCOORD5;
   float2 uv_ltmap   : TEXCOORD6;
   float2 fog : TEXCOORD7;

};

VS_OUTPUT VSmain(
   float4 Pos      : POSITION, 
   float3 normal      : NORMAL,
   float2 uv_diff1 : TEXCOORD0,
   float2 uv_ltmap : TEXCOORD1,
   float  uv_flat  : TEXCOORD2
){
   VS_OUTPUT Out;
   Out.oPos = mul(Pos,  g_worldViewProjMatrix);
   
   Out.Pos = Pos;
   waveDir *= g_timeScroll;
   Out.wave0.wx = Pos.xz * waveScale.x + waveDir*localWaveSpeed.x + float2(-g_timeScroll*3.8, 0)*waveScale;
   Out.wave0.yz = Pos.xz * waveScale.y + waveDir*localWaveSpeed.x + float2(0, -g_timeScroll*3)*waveScale;
   Out.wave1.xy = Pos.xz * waveScale.z + waveDir*localWaveSpeed.x + (g_timeScroll*1.24)*waveScale;
   
   Out.normal = normal;
   float4 viewVec = Pos - g_viewPos;
   
   Out.viewVec = viewVec;
    Out.wave1.z = uv_flat;
   Out.uv_diff1 = uv_diff1+waveDir*diffWave;
   Out.uv_ltmap = uv_ltmap;
    Out.fog.x = ComputeLinearFog(Out.oPos.z);
    Out.fog.y = ComputeAddFog(Out.oPos.z);
   
   return Out;
}

VS_OUTPUT VSmainMax(
   float4 Pos      : POSITION, 
   float3 normal      : NORMAL,
   float2 uv_diff1 : TEXCOORD0,
   float2 uv_ltmap : TEXCOORD1,
   float  uv_flat  : TEXCOORD2 
){
   VS_OUTPUT Out;
//   g_timeScroll *= 1;
//   Pos.xz *= 1000;
   Out.oPos = mul(Pos,  g_worldViewProjMatrix);
   
   Out.Pos = Pos;
//   g_timeScroll *= timeScale;
   Out.wave0.wx = Pos.xz * waveScale.x + waveDir + float2(-g_timeScroll*0.38, 0);
   Out.wave0.yz = Pos.xz * waveScale.y + waveDir + float2(0, -g_timeScroll*0.3);
   Out.wave1.xy = Pos.xz * waveScale.z + waveDir + (g_timeScroll*0.124);
   
   Out.normal = normal;
   float4 viewVec = Pos - g_viewPos;
//   float distance = length(viewVec.xyz);
float distance = 10.0 ;//- saturate(length(viewVec.xyz) * 0.0001);
   Out.viewVec = viewVec;
 //  Out.flat = pow(0.5*(abs((dot(normal, normalize(-viewVec)))*0.5)), 1);// + distance;
 //  Out.flat = asin(dot(normal, normalize(-viewVec))) * 0.5;
 Out.wave1.z = uv_flat;
   Out.uv_diff1 = uv_diff1;
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
   float3 wave1      : TEXCOORD4,
   float2 uv_diff1   : TEXCOORD5,
   float2 uv_ltmap   : TEXCOORD6,
   float2 fog : TEXCOORD7
) : COLOR {
   viewVec = normalize(viewVec);
   float lVal = abs(frac((wave0.w+wave0.x)*10)*2-1);
   float2 bumpA = tex2D(g_bumpSampler, wave0.wx).xy;
//   return float4(bumpA, 0, 1);
//   float2 bumpA_B = tex2D(g_bumpSampler, wave0.wx+0.5).xy;
//   bumpA = (lerp(bumpA, bumpA_B, lVal)-0.5)*waveDen.x;
    bumpA = (bumpA-0.5)*waveDen.x;
   float2 bumpB = tex2D(g_bumpSampler, wave0.yz).xy;
//   float2 bumpB_B = tex2D(g_bumpSampler, wave0.yz+0.5).xy;
//   bumpB = (lerp(bumpB, bumpB_B, lVal)-0.5)*waveDen.y;
   bumpB = (bumpB-0.5)*waveDen.y;
   float2 bumpC = tex2D(g_bumpSampler, wave1.xy).xy;
//   float2 bumpC_B = tex2D(g_bumpSampler, wave1.xy+0.5).xy;
//   bumpC = (lerp(bumpC, bumpC_B, lVal)-0.5)*waveDen.z;
    bumpC = (bumpC-0.5)*waveDen.z;
   float3 bump = float3(((bumpA + bumpB + bumpC) * wave1.z / 3),1.0f);
//return float4(bump, 1);
//return float4(wave1.zzz, 1);
    bump = bump.xzy;
    bump = normalize(bump);
    
    float4 clrBase0 = tex2D(Diff1Samp, uv_diff1.xy + (bump.xy * shadowDistort)); 
    float waveDenFromA = pow(clrBase0.a,0.5);
   float3 reflVec = reflect(viewVec, bump);
   
   float4 refl = texCUBE(Environment, reflVec.xyz);
//return refl;
    float4 ltmap = tex2D(LtMapSamp, uv_ltmap.xy + (bump.xy * shadowDistort));
//return float4(ltmap.aaa,1);
   float4 sun = saturate(refl - 0.5) * 2 * sunPower * ltmap.x;
   refl = saturate(refl * 2);

   float frnl = pow((1 - dot(bump, -viewVec)),2.0) ;

   float4 reflA = lerp( refl, clrBase0, (waterColorDen * frnl));
//return reflA;
   reflA = (lerp( reflA, fadeColor, saturate(pow(1-frnl, fadeExp)*fadeDen)) * ((ltmap.x*0.5)+0.5)) + sun;
//return float4(ltmap.xxx,1);
   reflA.a = min((saturate(((frnl-alphaWidthLow)/(1-alphaWidthLow))/(alphaWidthHigh-alphaWidthLow))*(1-alphaLow)+alphaLow),ltmap.a) + (sun*waveDenFromA);
    reflA.rgb += (1.0 - reflA.rgb) * g_addfogColor * fog.y;
    reflA.rgb = lerp(reflA.rgb, g_fogColor, fog.x);
//reflA.a = 1.0f;
   return reflA;
  
}
float4 PSmainMax(
   float4 Pos:     TEXCOORD0,
   float3 normal:  TEXCOORD1,
   float3 viewVec: TEXCOORD2,
   float4 wave0      : TEXCOORD3,
   float3 wave1      : TEXCOORD4,
   float2 uv_diff1   : TEXCOORD5,
   float2 uv_ltmap   : TEXCOORD6,
   float4 flat : TEXCOORD7
) : COLOR {
//return float4(flat.xxx,1);
   viewVec = normalize(viewVec);
   float2 bumpA = (tex2D(g_bumpSampler, wave0.wx).wx-0.5)*waveDen.x;
   float2 bumpB = (tex2D(g_bumpSampler, wave0.yz).wx-0.5)*waveDen.y;
   float2 bumpC = (tex2D(g_bumpSampler, wave1.xy).wx-0.5)*waveDen.z;
   float3 bump = float3(((bumpA + bumpB + bumpC)/3),0.0f);
return float4(bump, 1);
    float4 clrBase0 = tex2D(LtMapSamp, uv_diff1.xy); 
return clrBase0;

//bump.y = + 5;
//bump = bump.xzy;
//return float4(bump.xyz, 1);
bump.xy = bump.xy * clrBase0.a * flat.x;
bump = normalize(bump);
//return float4(bump.yyy, 1);  
  // bump.xz = (bump.xz * waveDen) * clrBase0.a * flat;
   bump = normalize(float3(bump.x, pow(bump.y, 2), bump.z ));
//return float4(bump.xyz, 1);  

   float3 reflVec = reflect(viewVec, bump);
   
   float4 refl = texCUBE(Environment, reflVec.xyz);
   float4 sun = saturate(refl - 0.5) * 2 * sunPower;
   refl = saturate(refl * 2);
   
 //  float4 sun = texCUBE(EnvironmentSun, reflVec.xyz) * sunPower;
 
//   dot(g_lightDir, 
//   g_lightDir = normalize(g_lightDir);
 //  float frnl = pow(((dot(g_lightDir, viewVec) * 0.5) + 0.5), 2)*1;
 //  bump = float3(0,1,0);
 //    bump = normalize(bump);
  // float frnl = pow((1 + (asin(dot(bump, viewVec)) * 0.5)),10);
//   float frnl = pow((1 - (dot(bump, -viewVec))), 2);
//return float4(frnl,frnl,frnl,1);

   float frnl = pow((1 - dot(bump, -viewVec)),2) ;
 //  float frnl = pow(lrp, 2);
 //  lrp = saturate( (asin(lrp) + 2 ) / 4) ;
 //  return float4(frnl,frnl,frnl,1);
//return float4(lrp.xxx,1);

   float4 reflA = lerp( refl, clrBase0, (waterColorDen - frnl));
   reflA = lerp( reflA, fadeColor, saturate(pow(1-frnl, fadeExp)*fadeDen)) + sun;
//   reflA += sun*sunPower;
//reflA = sun;
   reflA.a = min((saturate(((frnl-alphaWidthLow)/(1-alphaWidthLow))/(alphaWidthHigh-alphaWidthLow))*(1-alphaLow)+alphaLow),clrBase0.a) + sun + frnl;
//reflA.a += sun*sunPower;
   return reflA;
  
}


//--------------------------------------------------------------//
// Technique Section for Glass Effect Group
//--------------------------------------------------------------//
technique RenderPreview_2_0
{
   pass Object
   {
      VertexShader = compile vs_2_0 VSmainMax();
      PixelShader = compile ps_2_0 PSmainMax();
   }

}
technique RenderScene_2_0
{
   pass Object
   {
      VertexShader = compile vs_3_0 VSmain();
      PixelShader = compile ps_3_0 PSmain();
   }

}

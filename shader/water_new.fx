float4 fadeColor = float4( 0.0, 0.0, 0.5, 1.00 ); // 가까운 물의 색
float fadeExp = float( 2.2 ); //가까운 물의 색이 미치는 범위
float fadeDen = float( 0.5 ); //가까이 물의 색이 미치는 강도

float waterColorDen = float( 0.5 ); // 물의 디퓨즈&라이트 맵이 물의 색에 미치는 강도
float waveDen = float( 2.0 ); // 파도의 세기
float waveScale = float( 0.5 ); // 파도의 크기
float timeScale = float(1.7); // 파도의 흐름 속도

float alphaLow = float( 0.4 ); // 가까운 투명도 물의 투명도
float alphaWidthHigh = float( 1.8 ); // 가가운 투명도가 미치는 먼 범위(1.0이 수평선, 0.0이 카메라 바로 아래)
float alphaWidthLow = float( 0.6 ); // 가가운 투명도가 미치는 가까운 범위(1.0이 수평선, 0.0이 카메라 바로 아래)

float sunPower = float( 0.88 ); // 태양맵의 강도



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


texture g_environmentTexture< 
    string UIName = "env";
    int Texcoord = 6;
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
texture g_bumpTexture< 
    string UIName = "Wave";
    int Texcoord = 6;
    int MapChannel = 1;
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
    int Texcoord = 0;
    int MapChannel = 1;
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
    int Texcoord   = 1;
    int MapChannel = 2;
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
   float2 wave1      : TEXCOORD4;
   float4 uv_diff1   : TEXCOORD5;
   float3 uv_ltmap   : TEXCOORD6;
   float flat : TEXCOORD7;

};

VS_OUTPUT VSmain(
   float4 Pos      : POSITION, 
   float3 normal      : NORMAL,
   float4 uv_diff1 : TEXCOORD0,
   float3 uv_ltmap : TEXCOORD1 
){
   VS_OUTPUT Out;
   g_timeScroll *= timeScale;
//   Pos.xz *= 1000;
   Out.oPos = mul(Pos,  g_worldViewProjMatrix);
   
   Out.Pos = Pos;
   g_timeScroll *= timeScale;
   Out.wave0.wx = Pos.xz * 0.18 * waveScale + float2(-g_timeScroll*0.38, 0);
   Out.wave0.yz = Pos.xz * 0.3 * waveScale + float2(0, -g_timeScroll*0.3);
   Out.wave1.xy = Pos.xz * 0.77 * waveScale + (g_timeScroll*0.73*0.17);
   
   Out.normal = normal;
   float4 viewVec = Pos - g_viewPos;
   
   Out.viewVec = viewVec;
   Out.flat = max((0.2 + 0.8 * saturate(20 * pow((abs((dot(normal, normalize(-viewVec)))*0.5)), 1))),(2.5 - 2.5*saturate(0.035 * length(viewVec))));
 //  Out.flat = asin(dot(normal, normalize(-viewVec))) * 0.5;
   Out.uv_diff1 = uv_diff1;
   Out.uv_ltmap = uv_ltmap;
   return Out;
}

VS_OUTPUT VSmainMax(
   float4 Pos      : POSITION, 
   float3 normal      : NORMAL,
   float4 uv_diff1 : TEXCOORD0,
   float3 uv_ltmap : TEXCOORD1 
){
   VS_OUTPUT Out;
//   g_timeScroll *= 1;
//   Pos.xz *= 1000;
   Out.oPos = mul(Pos,  g_worldViewProjMatrix);
   
   Out.Pos = Pos;
   g_timeScroll *= timeScale;
   Out.wave0.wx = Pos.xy * 0.18 * waveScale + float2(-g_timeScroll*0.38, 0);
   Out.wave0.yz = Pos.xy * 0.3 * waveScale + float2(0, -g_timeScroll*0.3);
   Out.wave1.xy = Pos.xy * 0.77 * waveScale + (g_timeScroll*0.73*0.17);
   
   Out.normal = normal;
   float4 viewVec = Pos - g_viewPos;
//   float distance = length(viewVec.xyz);
float distance = 10.0 ;//- saturate(length(viewVec.xyz) * 0.0001);
   Out.viewVec = viewVec;
   Out.flat = pow(0.5*(abs((dot(normal, normalize(-viewVec)))*0.5)), 1);// + distance;
 //  Out.flat = asin(dot(normal, normalize(-viewVec))) * 0.5;
   Out.uv_diff1 = uv_diff1;
   Out.uv_ltmap = uv_ltmap;
   return Out;
}


float4 PSmain(
   float4 Pos:     TEXCOORD0,
   float3 normal:  TEXCOORD1,
   float3 viewVec: TEXCOORD2,
   float4 wave0      : TEXCOORD3,
   float2 wave1      : TEXCOORD4,
   float4 uv_diff1   : TEXCOORD5,
   float3 uv_ltmap   : TEXCOORD6,
   float4 flat : TEXCOORD7
) : COLOR {
   viewVec = normalize(viewVec);
   float3 bumpA = tex2D(g_bumpSampler, wave0.wx).xyz;
    
   float3 bumpB = tex2D(g_bumpSampler, wave0.yz).xyz;
   float3 bumpC = tex2D(g_bumpSampler, wave1.xy).xyz;
   float3 bump = ((bumpA + bumpB + bumpC)/3);
   float4 clrBase0 = tex2D(Diff1Samp, uv_diff1.xy + (bump.xz - 0.5)*0.01); 
    bump = bump.xzy;
    
     

    float waveDenFromA = pow(clrBase0.a,0.5);
    bump.xz = (((bump.xz-0.5) * waveDen) * waveDenFromA) * flat.x;
//    bump = normalize(bump);

   bump = normalize(float3(bump.x, pow(bump.y, 2), bump.z ));

//bump = float3(0,-1,0);
   float3 reflVec = reflect(viewVec, bump);
   
   float4 refl = texCUBE(Environment, reflVec.xyz);
//   return refl;
float4 ltmap = tex2D(LtMapSamp, uv_ltmap.xy+ bump.xz*0.01);
   float4 sun = saturate(refl - 0.5) * 2 * sunPower * ltmap.x;
   refl = saturate(refl * 2);

   float frnl = pow((1 - dot(bump, -viewVec)),2.0) ;

   float4 reflA = lerp( refl, clrBase0, (waterColorDen * frnl));
   reflA = (lerp( reflA, fadeColor, saturate(pow(1-frnl, fadeExp)*fadeDen)) * ((ltmap.x*0.5)+0.5)) + sun;

   reflA.a = min((saturate(((frnl-alphaWidthLow)/(1-alphaWidthLow))/(alphaWidthHigh-alphaWidthLow))*(1-alphaLow)+alphaLow),clrBase0.a) + (sun*waveDenFromA);

   return reflA;
  
}
float4 PSmainMax(
   float4 Pos:     TEXCOORD0,
   float3 normal:  TEXCOORD1,
   float3 viewVec: TEXCOORD2,
   float4 wave0      : TEXCOORD3,
   float2 wave1      : TEXCOORD4,
   float4 uv_diff1   : TEXCOORD5,
   float3 uv_ltmap   : TEXCOORD6,
   float4 flat : TEXCOORD7
) : COLOR {
//return float4(flat.xxx,1);
   viewVec = normalize(viewVec);
   float3 bumpA = tex2D(g_bumpSampler, wave0.wx).xyz;
    
   float3 bumpB = tex2D(g_bumpSampler, wave0.yz).xyz;
   float3 bumpC = tex2D(g_bumpSampler, wave1.xy).xyz;
   float3 bump = ((bumpA + bumpB + bumpC)/3);
//return float4(bump.zzz, 1);
    float4 clrBase0 = tex2D(LtMapSamp, uv_diff1.xy); 
return clrBase0;

//bump.y = + 5;
//bump = bump.xzy;
//return float4(bump.xyz, 1);
bump.xy = (((bump.xy-0.5) * waveDen) * clrBase0.a) * flat.x;
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
technique RenderScene_1_1
{
   pass Object
   {
      VertexShader = compile vs_2_0 VSmain();
      PixelShader = compile ps_2_0 PSmain();
   }
}
technique RenderScene_2_0
{
   pass Object
   {
      VertexShader = compile vs_2_0 VSmain();
      PixelShader = compile ps_2_0 PSmain();
   }
}

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

#ifdef THIS_IS_CLIENT
#else
    #ifndef THIS_IS_MAX
    #define THIS_IS_MAX
    #endif
    #ifndef REFLECTION
    #define REFLECTION
    #endif
    #ifndef BUMP
    #define BUMP
    #endif
    #ifndef DETAIL_BUMP
    #define DETAIL_BUMP
    #endif
#endif


#ifndef USING_DIFFUSE_TEX1
#define USING_DIFFUSE_TEX1
#endif

#ifndef USING_CAM_POS
#define USING_CAM_POS
#endif

#ifndef USING_TIME_SCROLL
#define USING_TIME_SCROLL
#endif

///////////////////////////////////////////////////////////////////////////////////////////////////////////////
//

#ifdef REFLECTION
    #ifndef BUMP
    #define BUMP
    #endif
    #ifndef USING_ENV_TEX
    #define USING_ENV_TEX
    #endif
    #ifndef USING_LIGHTMAP_TEX
    #define USING_LIGHTMAP_TEX
    #endif
#endif

#ifdef BUMP
    #ifndef USING_BUMP_TEX
    #define USING_BUMP_TEX
    #endif
    #ifdef DETAIL_BUMP
        #ifndef USING_BUMP_LERP
        #define USING_BUMP_LERP
        #endif
        #ifndef USING_BUMP_DETAIL
        #define USING_BUMP_DETAIL
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

#ifdef ADDFOG
    #ifndef USING_ADDFOG_PARAM
    #define USING_ADDFOG_PARAM
    #endif
    #ifndef USING_ADDFOG_COLOR
    #define USING_ADDFOG_COLOR
    #endif
#endif



/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//

float4x4 g_WVP : WORLDVIEWPROJ;

#ifdef USING_CAM_POS
float3 g_worldCamera : WORLDCAMERAPOSITION;
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
#endif

#ifdef USING_ENV_TEX
//FX_parameter.g_environmentTexture.g_environmentTexture.bitmap.selectable
//FX_parameter.g_environmentTexture_Ch.g_environmentTexturemapChannel.integer.true
texture c_envTex
< 
    string UIName = "EnvMap";
    int Texcoord = 2;
    int MapChannel = 3;
>;
samplerCUBE c_envSamp = sampler_state
{
   Texture = (c_envTex);
   ADDRESSU = CLAMP;
   ADDRESSV = CLAMP;
   MAGFILTER = LINEAR;
   MINFILTER = LINEAR;
   MIPFILTER = LINEAR;
};
#endif  //! end of USING_ENV_TEX

#ifdef USING_BUMP_TEX
//FX_parameter.g_bumpTexture.g_bumpTexture.bitmap.selectable
//FX_parameter.g_bumpTexture_Ch.g_bumpTexturemapChannel.integer.true
texture c_bumpTex
< 
    string UIName = "BumpMap";
    int Texcoord = 3;
    int MapChannel = 4;
>;
sampler c_bumpSamp = sampler_state
{
   Texture = (c_bumpTex);
   ADDRESSU = WRAP;
   ADDRESSV = WRAP;
   MAGFILTER = LINEAR;
   MINFILTER = LINEAR;
   MIPFILTER = LINEAR;
};
#endif  //! end of USING_BUMP_TEX


//#ifdef USING_WATER_FADE
//#endif    //! end of USING_WATER_FADE
float c_alphaNear   // 가까운 물의 투명도
<
   string UIName = "Alpha Near";
   string UIType = "Slider";
   float UIMin = 0.0f;
   float UIMax = 1.0f;
   float UIStep = 0.001f;
   float UIAtten = 1.0f;
> = float(0.99);

float c_alphaRangeFar   // 물의 투명도가 미치는 먼 범위(1.0이 수평선, 0.0이 카메라 바로 아래)
<
   string UIName = "Alpha Range Far";
   string UIType = "Slider";
   float UIMin = 0.0f;
   float UIMax = 5.0f;
   float UIStep = 0.001f;
   float UIAtten = 1.0f;
> = float(0.6);

float c_alphaRangeNear  // 물의 투명도가 미치는 가까운 범위(1.0이 수평선, 0.0이 카메라 바로 아래)
<
   string UIName = "Alpha Range Near";
   string UIType = "Slider";
   float UIMin = -2.0f;
   float UIMax = 1.0f;
   float UIStep = 0.001f;
   float UIAtten = 1.0f;
> = float(0);

float   c_diffuseDistort    // 디퓨즈맵 왜곡
<
   string UIName = "Diffuse Distort";
   string UIType = "Slider";
   float UIMin = 0.0f;
   float UIMax = 2.0f;
   float UIStep = 0.001f;
   float UIAtten = 1.0f;
> = float(0.01);

float3 c_fadeColor  // 가까운 물의 색
<
   string UIName = "Fade Color";
   string UIType = "Slider";
   float UIMin = 0.0f;
   float UIMax = 1.0f;
   float UIStep = 0.001f;
   float UIAtten = 1.0f;
> = float3( 0.05, 0.2, 0.1);

float c_fadeDen     //가까운 물의 색이 미치는 강도
<
   string UIName = "Fade Density";
   string UIType = "Slider";
   float UIMin = -10.0f;
   float UIMax = 10.0f;
   float UIStep = 0.001f;
   float UIAtten = 1.0f;
> = float(1.0f);

float c_fadeExp     //가까운 물의 색이 미치는 범위
<
   string UIName = "Fade Exp";
   string UIType = "Slider";
   float UIMin = -10.0f;
   float UIMax = 10.0f;
   float UIStep = 0.001f;
   float UIAtten = 1.0f;
> = float(1.0f);

float   c_lightmapDistort    // 라이트맵 왜곡
<
   string UIName = "Ltmap Distort";
   string UIType = "Slider";
   float UIMin = 0.0f;
   float UIMax = 2.0f;
   float UIStep = 0.001f;
   float UIAtten = 1.0f;
> = float(0.1);

float c_sunDen   // 태양맵의 강도
<
   string UIName = "Sun Density";
   string UIType = "Slider";
   float UIMin = 0.0f;
   float UIMax = 1.0f;
   float UIStep = 0.001f;
   float UIAtten = 1.0f;
> = float(0.58);

float c_waterDen // 디퓨즈,라이트 맵이 물의 색에 미치는 강도
<
   string UIName = "Water Density";
   string UIType = "Slider";
   float UIMin = 0.0f;
   float UIMax = 1.0f;
   float UIStep = 0.001f;
   float UIAtten = 1.0f;
> = float( 0.999);

float2  c_waveDir   // 파동의 방향 (waveDir)
<
   string UIName = "Wave Direction";
   string UIType = "Slider";
   float UIMin = 0.0f;
   float UIMax = 1.0f;
   float UIStep = 0.001f;
   float UIAtten = 1.0f;
> = float2( -0.45, -0.45);

float3  c_waveHeight  // 파동의 높이 (waveDen)
<
   string UIName = "Wave Height";
   string UIType = "Slider";
   float UIMin = 0.0f;
   float UIMax = 2.0f;
   float UIStep = 0.001f;
   float UIAtten = 1.0f;
> = float3( 0.412, 0.22, 0.12 );

float3  c_waveLength // 파동의 길이 (waveScale)
<
   string UIName = "Wave Length";
   string UIType = "Slider";
   float UIMin = 0.0f;
   float UIMax = 1.0f;
   float UIStep = 0.001f;
   float UIAtten = 1.0f;
> = float3( 0.002, 0.023, 0.077 ); 

float3  c_waveSpeed // 파동의 속도 (localWaveSpeed)
<
   string UIName = "Wave Speed";
   string UIType = "Slider";
   float UIMin = 0.0f;
   float UIMax = 4.0f;
   float UIStep = 0.001f;
   float UIAtten = 1.0f;
> = float3( 0.2, 0.6, 1.0); 

float   c_waveUV    // 디퓨즈 흐르는 속도 (diffWave)
<
   string UIName = "Wave UV";
   string UIType = "Slider";
   float UIMin = 0.0f;
   float UIMax = 2.0f;
   float UIStep = 0.001f;
   float UIAtten = 1.0f;
> = float(0.2);


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

#ifdef USING_TIME_SCROLL
float g_timeScroll : TimeScroll;
/*
<
   //string UIName = "fadeExp";
   //string UIWidget = "Numeric";
   bool UIVisible =  true;
   float UIMin = 0.00;
   float UIMax = 5.00;
> = float( 1 );
*/
#endif

void DefaultVS( float4 vPos : POSITION
               , float2 vTex0 : TEXCOORD0
            #ifdef USING_LIGHTMAP_TEX
               , float2 vTex1 : TEXCOORD1
            #endif
               , float vWaveFlat : TEXCOORD2
               
               , out float4 oPos : POSITION

               , out float3 oViewDir : TEXCOORD0
               
               , out float2 oTex0 : TEXCOORD1       //! Diffuse
            #ifdef USING_LIGHTMAP_TEX
               , out float2 oTex1 : TEXCOORD2       //! Lightmap
            #endif
               
            #ifdef USING_BUMP_TEX
                #ifdef USING_BUMP_LERP
                   , out float4 oWave0 : TEXCOORD3
                   , out float4 oWave1 : TEXCOORD4
                   , out float ofTemp  : TEXCOORD7
                    #ifdef DETAIL_BUMP
                        , out float4 oWave2 : TEXCOORD5
                    #endif
                #else
                   , out float2 oWave0 : TEXCOORD3
                   , out float2 oWave1 : TEXCOORD4
                    #ifdef DETAIL_BUMP
                        , out float2 oWave2 : TEXCOORD5
                    #endif
                #endif
               , out float  oWaveFlat : TEXCOORD6
            #endif

            #ifdef _FOG_
               , out float oFog        : FOG
            #endif
               )
{
    oPos = mul(vPos, g_WVP);

    float timeScroll = g_timeScroll * c_waveUV;
    float2 waveDir = c_waveDir * timeScroll;

    oTex0 = vTex0 + waveDir;

#ifdef USING_LIGHTMAP_TEX
    oTex1 = vTex1;
#endif

    oViewDir = normalize(vPos - g_worldCamera);

#ifdef USING_BUMP_TEX
    float3 waveSpeed = c_waveSpeed.xyz * timeScroll;
    float3 waveLength = c_waveLength.xyz;
    
    oWave0.xy = (vPos.xz * waveLength.x) + (waveDir + float2(-3.8f * waveSpeed.x, 0.f));
    oWave1.xy = (vPos.xz * waveLength.y) + (waveDir + float2(0.f, -3 * waveSpeed.y));
    
    #ifdef USING_BUMP_LERP
        oWave0.zw = oWave0.xy + 0.5f;
        oWave1.zw = oWave1.xy + 0.5f;
        ofTemp = abs(frac((vPos.z+vPos.x)*10.0f)*2.0f-1.0f);
    #endif

    #ifdef DETAIL_BUMP
        oWave2.xy = (vPos.xz * waveLength.z) + (waveDir + (1.24 * waveSpeed.z));
        #ifdef USING_BUMP_LERP
            oWave2.zw = oWave2.xy + 0.5f;
        #endif
        oWaveFlat = vWaveFlat/3.f;
    #else
        oWaveFlat = vWaveFlat/2.f;
    #endif  //! end of DETAIL_BUMP
#endif  //! end of USING_BUMP_TEX

#ifdef _FOG_
    oFog = saturate((g_fogParam.x * oPos.z) + g_fogParam.y);
#endif

#ifdef ADDFOG
    oAddFog = saturate((g_addfogParam.x * oPos.z) + g_addfogParam.y);
#endif
}

void DefaultPS(  
                 float3 vViewDir : TEXCOORD0
               , float2 vTex0 : TEXCOORD1       //! Diffuse
            #ifdef USING_LIGHTMAP_TEX
               , float2 vTex1 : TEXCOORD2       //! Lightmap
            #endif
            
            #ifdef USING_BUMP_TEX
                #ifdef USING_BUMP_LERP
                   , float4 vWave0 : TEXCOORD3
                   , float4 vWave1 : TEXCOORD4
                   , float vfTemp  : TEXCOORD7
                    #ifdef USING_BUMP_DETAIL
                        , float4 vWave2 : TEXCOORD5
                    #endif
                #else
                   , float2 vWave0 : TEXCOORD3
                   , float2 vWave1 : TEXCOORD4
                    #ifdef USING_BUMP_DETAIL
                        , float2 vWave2 : TEXCOORD5
                    #endif
                #endif
               , float  vWaveFlat : TEXCOORD6
            #endif

            #ifdef _FOG_
               , float fFog : FOG
            #endif
               , out float4 oColor : COLOR)
{
    //! 최하 옵션 : 디퓨즈만
#ifdef USING_BUMP_TEX
    float3 vBump = float3(0.f,1.f,0.f);

    #ifdef USING_BUMP_LERP
        float2 vBumpTemp0;
        float2 vBumpTemp1;

        vBumpTemp0 = tex2D(c_bumpSamp, vWave0.xy).xy;
        vBumpTemp1 = tex2D(c_bumpSamp, vWave0.zw).xy;
        vBumpTemp0 = lerp(vBumpTemp0, vBumpTemp1, vfTemp) - 0.5f;
        vBump.xz += (vBumpTemp0*c_waveHeight.x);

        vBumpTemp0 = tex2D(c_bumpSamp, vWave1.xy).xy;
        vBumpTemp1 = tex2D(c_bumpSamp, vWave1.zw).xy;
        vBumpTemp0 = lerp(vBumpTemp0, vBumpTemp1, vfTemp) - 0.5f;
        vBump.xz += (vBumpTemp0*c_waveHeight.y);

        #ifdef USING_BUMP_DETAIL
            vBumpTemp0 = tex2D(c_bumpSamp, vWave2.xy).xy;
            vBumpTemp1 = tex2D(c_bumpSamp, vWave2.zw).xy;
            vBumpTemp0 = lerp(vBumpTemp0, vBumpTemp1, vfTemp) - 0.5f;
            vBump.xz += (vBumpTemp0*c_waveHeight.z);
        #endif
    #else
        vBump.xz += (tex2D(c_bumpSamp, vWave0.xy).xy - 0.5f) * c_waveHeight.x;
        vBump.xz += (tex2D(c_bumpSamp, vWave1.xy).xy - 0.5f) * c_waveHeight.y;
        #ifdef USING_BUMP_DETAIL
            vBump.xz += (tex2D(c_bumpSamp, vWave2.xy).xy - 0.5f) * c_waveHeight.z;
        #endif
    #endif  //! end of LERP_BUMP

    vBump.xz *= vWaveFlat;
    vBump = normalize(vBump);
    vTex0 += (c_diffuseDistort*vBump.xz);

    #ifdef USING_LIGHTMAP_TEX
        vTex1 += (c_lightmapDistort*vBump.xz);
    #endif
#endif

    oColor = tex2D(c_diffSamp0, vTex0);

#ifdef REFLECTION
    float3 vReflect = texCUBE(c_envSamp, reflect(vViewDir,vBump));
    float4 vLight = tex2D(c_ltmapSamp, vTex1);
    float3 vSun = saturate(vReflect - 0.5f) * 2.0f * c_sunDen * vLight.x;
    
    vReflect = saturate(vReflect*2.0f);
    float frnl = pow(1.0f - dot(vBump,-vViewDir), 2.0f);
    vReflect.rgb = lerp( vReflect.rgb, oColor.rgb, saturate(c_waterDen * frnl));
    oColor.rgb = lerp(vReflect.rgb, c_fadeColor, saturate(pow(1.f-frnl, c_fadeExp)*c_fadeDen)) * vLight.x;
    oColor.rgb += vSun.rgb;

    //! 중요한 기능
    //! 알파 - 중급이상?
    float fAlpha = (frnl-c_alphaRangeNear)/(1.f - c_alphaRangeNear);
    fAlpha = saturate(fAlpha/(c_alphaRangeFar-c_alphaRangeNear));
    oColor.a *= vSun;   //! 태양에 의한 알파 조절
    oColor.a += min(lerp(c_alphaNear, 1.f, fAlpha), vLight.a);  //! 거리에 의한 알파 조절
#endif

#ifdef ADDFOG
    oColor.rgb = lerp(oColor.rgb, 1, fAddFog*g_addfogColor.rgb);
#endif

#ifdef _FOG_
    oColor.rgb = lerp(oColor.rgb, g_fogColor.rgb, fFog);
#endif
}

#ifdef THIS_IS_MAX
technique Preview
{
    pass P0
    {
      VertexShader = compile VS_VER DefaultVS();
      PixelShader  = compile PS_VER DefaultPS();
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

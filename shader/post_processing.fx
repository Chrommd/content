//#define USE_LEVELOUTPUT

//! 콘솔창에 dbg_postprocessing 1, test render COLOR_ADJUST 입력.

//! New
    float g_Contrast : Contrast
    <
       string UIType = "Slider";
       float UIMin = 0.75f;
       float UIMax = 1.25f;
       float UIStep = 0.001f;
       float UIAtten = 1.0f;
    > = 1.00f;
    float g_Brightness : Brightness
    <
       string UIType = "Slider";
       float UIMin = -0.25f;
       float UIMax = 0.25f;
       float UIStep = 0.001f;
       float UIAtten = 1.0f;
    > = 0.00f;
    float3 g_ColorTone : ColorBalance
    <
       string UIType = "Slider";
       float UIMin = -0.25f;
       float UIMax = 0.25f;
       float UIStep = 0.001f;
       float UIAtten = 1.0f;
    > = 0.00f;                           //! 화면 색감,   기본값: float3( 1, 1, 1 )


//! Old
/*    float3 g_InputLvMax : LevelMax 
    <
        string UIType = "Slider";
       float UIMin = 0.0f;
       float UIMax = 1.0f;
       float UIStep = 0.001f;
       float UIAtten = 1.0f;
    > = 0.00f;
    float3 g_InputLvMid : LevelMid
    <
        string UIType = "Slider";
       float UIMin = 0.0f;
       float UIMax = 10.0f;
       float UIStep = 0.001f;
       float UIAtten = 1.0f;
    > = 1.13f;
    float3 g_InputLvMin : LevelMin
    <
        string UIType = "Slider";
       float UIMin = 0.0f;
       float UIMax = 1.0f;
       float UIStep = 0.001f;
       float UIAtten = 1.0f;
    > = 0.93f;*/
//! --------------Old  여기까지


texture			g_texture0;
texture			g_texture1;
texture     c_blurtexture; //블러 텍스쳐

int g_glowSamples = 7;

float g_glowWeight[7] = { 0.1, 0.358, 0.773, 1.0, 0.773, 0.358, 0.1 };
float g_glowKernel[7] = { -3.0, -2.0, -1.0, 0.0, 1.0, 2.0f, 3.0 };

float g_glowx;
float g_glowy;
float g_glowIntensity = 4.5f;

float			g_desaturation = 0.5f;
const float3	g_sepiaColor = float3(0.77, 0.89, 0.65);
float g_whiteOutFactor;
float2 g_sunPos : SunPos;

float c_blurFactor = 0.0f;

float   c_padInterval = 0.1f;
int     c_padSize = 1;
int     c_padPitch = 3; // size*2 + 1
int     c_padCount = 9; // pitch * pitch

//texture c_mrtTex : MRT;

sampler g_sampler0 = sampler_state
{
    Texture = <g_texture0>;
    MinFilter = LINEAR;
    MagFilter = LINEAR;
    MipFilter = LINEAR;
    AddressU = CLAMP;
    AddressV = CLAMP;
};

sampler g_sampler1 = sampler_state
{
    Texture = <g_texture1>;
    MinFilter = LINEAR;
    MagFilter = LINEAR;
    MipFilter = LINEAR;
    AddressU = CLAMP;
    AddressV = CLAMP;
};

sampler c_blurTextureSampler = sampler_state
{
    Texture = <c_blurtexture>;
    MinFilter = LINEAR;
    MagFilter = LINEAR;
    MipFilter = LINEAR;
    AddressU = Clamp;
    AddressV = Clamp;
};

float2 TexelKernel[16] =
{
	{-0.003805725 , 0.0002410247},
	{0.002212938 , 0.0027190275},
	{-0.001826741 , 0.003003854},
	{0.001146817 , -0.0006511855},
	{-0.007371385 , -0.0004637465},
	{-0.00566133 , 0.004619825},
	{0.002702455 , -0.002803801},
	{-0.000798175 , -0.006878515},
	{0.0027238925 , -0.006394885},
	{0.005299385 , 0.00504763},
	{-0.0029837675 , 0.006305075},
	{-0.0022724625 , -0.0031702195},
	{-0.00540988 , -0.00508172},
	{0.00034520955 , 0.006622175},
	{0.0072534 , 0.0011501},
	{0.006038725 , -0.00353157}
};

float2 PaddingKernel[24] = 
{
    {-2,-2},
    {-1,-2},
    { 0,-2},
    { 1,-2},
    { 2,-2},

    {-2,-1},
    {-1,-1},
    { 0,-1},
    { 1,-1},
    { 2,-1},

    {-2, 0},
    {-1, 0},
    { 1, 0},
    { 2, 0},

    {-2, 1},
    {-1, 1},
    { 0, 1},
    { 1, 1},
    { 2, 1},

    {-2, 2},
    {-1, 2},
    { 0, 2},
    { 1, 2},
    { 2, 2},
};



void BloomPS(
  float2 vTex0 : TEXCOORD
  , out float4 oColor : COLOR)
{
  float3 src = tex2D(g_sampler0, vTex0).rgb;
  float3 vBloom = float3(0.f, 0.f, 0.f);
  
  for (int i = 0; i < 8; i++)
  {
	  vBloom += tex2D( g_sampler0, (vTex0 + TexelKernel[i]/2) ).rgb;
  }
	vBloom /= 8.f;

//! Old
/*  float v = dot(float3(0.222, 0.707, 0.071), vBloom);
//블룸 채도 설정
	
	vBloom = lerp(vBloom, v,0.1f);

//블룸 색설정 ;;  1f 가 256, 순서는 rgb ;; 콘솔명령어 - dbg_postprocessing 1 넣고 test render BLOOM
	
	vBloom = pow(vBloom,3.5f)*float3(0.32f,0.31f,0.32f);
*/

//! New
	vBloom = pow(clamp(vBloom, 0, 0.65f), 1.5f);
  oColor = float4(vBloom*1.6f,1.f);
}

void BloomBlendPS(
  float2 vTex0 : TEXCOORD0
  , out float4 oColor : COLOR)
{
  float3 src = tex2D(g_sampler0, vTex0).rgb;
  float3 bloom = tex2D(g_sampler1, vTex0).rgb;
  
//! Old
/*oColor.rgb = bloom;
  oColor.rgb = src + bloom;
*/

//! New
  oColor.rgb = lerp(src, bloom, 0.175f);           //<---- bloom 설정값조절
  oColor.a = 1.f;
}

//콘솔 - test render SKYBLOOM
//타겟 사이즈 조절 - r_downSampleLvl
void SkyBloomPS(
    float2 vTex0 : TEXCOORD
    , out float4 oColor : COLOR)
{
    float3 vSky = tex2D(g_sampler1, vTex0).rgb;
    float3 vBloom = vSky;
  
    float2 normToSun = g_sunPos + 0.5f;
    normToSun.y = 1.0f - normToSun.y;
    normToSun = (normToSun - vTex0) * 0.005f;
  
    for (int i = 0; i < 16; i++)
    {
    	//vBloom += tex2D( g_sampler1, (vTex0 + (normToSun*i) ) );
        vBloom += tex2D( g_sampler1, (vTex0 + TexelKernel[i]*2) ).rgb;
    }

	vBloom /= 16.f;
	//vBloom = max(vSky, vBloom);
	//vBloom = pow(((max(vBloom,0.65)-0.65) * 7.f), 1);
	//vBloom *= 1.05 - pow(length(vTex0 - 0.5)*1.2, 2.4) ;
	//vBloom *= vSky;
	vBloom = pow(vBloom, 1.5);
	vBloom *= 0.4;
    oColor = float4(vBloom, 1.f);
  //oColor = float4(float3(1,0,0)*vSky, 1.f);
}


void SkyBloomBlendPS(
  float2 vTex0 : TEXCOORD0
  , out float4 oColor : COLOR)
{
  float3 src = tex2D(g_sampler0, vTex0).rgb;
  float3 bloom = tex2D(g_sampler1, vTex0).rgb;
  
  float scale = 1.05 - pow(length(vTex0 - 0.5f)*1.2, 2.4);
  oColor.rgb = src + bloom ;
//oColor.rgb = bloom ;
  oColor.a = 1.f;
}


//#define GRAYSCALE
//#define SEPIA
//#define INVERSE_COLOR
#ifdef GRAYSCALE
  #define VALUE
#elifdef SEPIA
  #define VALUE
#endif
void ColorAdjustPS(
  float2 vTex0 : TEXCOORD0
  , out float4 oColor : COLOR)
{
    float3 src = tex2D(g_sampler0, vTex0).rgb;
    //! if need value
#ifdef GRAYSCALE
    float s = dot(float3(0.222, 0.707, 0.071), src);
#endif


    //! grayscale
#ifdef GRAYSCALE
    src = lerp(src, float3(s, s, s), g_desaturation);
#endif
    
    //! sepia
#ifdef SEPIA
	//float3 temp = lerp(float3(0, 0, 0), g_sepiaColor, s);
	float3 temp = lerp(float3(0, 0, 0), float3(0.77, 0.89, 0.65), s);
	src = lerp(src, temp, g_desaturation);
#endif
	
	//! inverse
#ifdef INVERSE_COLOR
	src = 1.0f - src;
#endif

    //! color tone
//    src = max(0.f, src/g_InputLvMax);
//    src = pow( src, g_InputLvMid );
    src += g_Brightness;
    src = lerp(float3(0.5, 0.5, 0.5), src, g_Contrast);
    src += g_ColorTone;

    src += float4(g_whiteOutFactor, g_whiteOutFactor, g_whiteOutFactor, 0.f);
    oColor = float4(src, 1.f);
}


void DetectSkyPS(
     float2 vTex0 : TEXCOORD0
    , out float4 oColor : COLOR)
{
    float3 src1 = tex2D(g_sampler0, vTex0).rgb;
    float3 src2 = tex2D(g_sampler1, vTex0).rgb;
  

    oColor = float4(0,0,0,1);
    //! In some cases , It occurs wrong results. But, It's Cheap.
    if (length(src1-src2) == 0.0f)
    {
        oColor = float4(src1,1);
    }
  
  /*if (src1.x==src2.x && src1.y==src2.y && src1.z==src2.z)
  {
    oColor = float4(1,1,1,1);
  }
  else
  {
    oColor = float4(0,0,0,1);
  }*/
}

void MotionBlurPS(
    float2 vTex0 : TEXCOORD0
    , out float4 oColor : COLOR)
{
    float3 dst = float3(0.f, 0.f, 0.f);
    float3 blurTex = tex2D(c_blurTextureSampler, vTex0).rgb;
    
    float nsamples = 8;
    float2 center = float2(0.5f, 0.2f);

//! nTest
/*    vTex0 -= center;   
    for (int i = 0; i < nsamples; i++)
    {
      float scale = 1.0f + (-blurTex*15* c_blurFactor)*(i/(float) (nsamples-1));   //<---- blur 강도 조절(현재값 15)
      dst += tex2D( g_sampler0, vTex0*scale + center);
    }
*/
//! Old
    float2 vecToCenter = (center - vTex0) * c_blurFactor * blurTex*2.f;   //<---- blur 강도 조절(현재값 2)

    for (int i = 0; i < nsamples; i++)
    {
        dst += tex2D( g_sampler0, (vTex0 + (vecToCenter*i)) ).rgb;
    }

    dst /= nsamples;

    oColor = float4(dst, 1.f); 
}

//! for layer blend
void PaddingPS(
    float2 vTex0 : TEXCOORD0
    , out float4 oColor : COLOR)
{
    float4 src = tex2D(g_sampler0, vTex0);
    
    oColor = src;

    for (int i=0; i<24; i++)
    {
        float2 uv = PaddingKernel[i]*c_padInterval + vTex0;
        float4 neighbor = tex2D(g_sampler0, uv);

        if (uv.x >= 0.0f && uv.x <= 1.0f && uv.y >= 0.0f && uv.y <= 1.0f && neighbor.a > 0.0f && oColor.a == 0)
        {
            oColor = neighbor;
        }
    }

    /*
    for (int i=0; i<c_padCount; i++)
    {
        float2 uv = saturate((float2(ceil(i/c_padPitch),fmod(i,c_padPitch)) - c_padSize)*c_padInterval + vTex0);
        if (uv.x != vTex0.x && uv.y != vTex0.y)
        {
            float4 neighbor = tex2D(g_sampler0, uv);
            if (neighbor.a > 0.0f && src.a == 0)
            {
                oColor = neighbor;
            }    
        }
    } 
    */
}

float4 OutlinePS(float2 Texcoord0 : TEXCOORD0,
                        float2 Texcoord1 : TEXCOORD1,
                        float2 Texcoord2 : TEXCOORD2,
                        float2 Texcoord3 : TEXCOORD3) : COLOR
{
    float tex0 = tex2D(g_sampler0, Texcoord0).r;
    float tex1 = tex2D(g_sampler0, Texcoord1).r;
    float tex2 = tex2D(g_sampler0, Texcoord2).r;
    float tex3 = tex2D(g_sampler0, Texcoord3).r;

    float r0 = 4 * (tex0 - tex1);
    float r1 = 4 * (tex2 - tex3);

    r0 = 4 * (r0 * r0);
    r1 = 4 * (r1 * r1);
    r0 = 4 * (r0 + r1);

    return float4(r0, r0, r0, 1.0f);
}

float4 OutlinePSFinal(float2 Texcoord0 : TEXCOORD0) : COLOR
{
    float4 color = 0;

    color.rgb = tex2D(g_sampler0, Texcoord0).rgb + tex2D(g_sampler1, Texcoord0).rgb;

    return color;
}

float4 OutlinePSGlowX(float2 Texcoord0 : TEXCOORD0) : COLOR
{
    float4 Color = 0;

     Color += g_glowWeight[2] * (tex2D(g_sampler0, Texcoord0 + float2( -1.5 / g_glowx, 0)));
     Color += g_glowWeight[3] * (tex2D(g_sampler0, Texcoord0 + float2(  0.0 / g_glowx, 0)));
     Color += g_glowWeight[4] * (tex2D(g_sampler0, Texcoord0 + float2( +1.5 / g_glowx, 0)));

    return Color / g_glowIntensity;
}

float4 OutlinePSGlowY(float2 Texcoord0 : TEXCOORD0) : COLOR
{
    float4 Color = 0;

     Color += g_glowWeight[2] * (tex2D(g_sampler0, Texcoord0 + float2(0, -1.5 / g_glowy)));
     Color += g_glowWeight[3] * (tex2D(g_sampler0, Texcoord0 + float2(0,  0.0 / g_glowy)));
     Color += g_glowWeight[4] * (tex2D(g_sampler0, Texcoord0 + float2(0, +1.5 / g_glowy)));

    return Color / g_glowIntensity;
}

technique RenderBloom
{
    pass p0
    {       
        PixelShader = compile ps_2_0 BloomPS();
    }
}

technique RenderBloomBlend
{
    pass p0
    {       
        PixelShader = compile ps_2_0 BloomBlendPS();
    }
}

technique RenderSkyBloom
{
    pass p0
    {       
        PixelShader = compile ps_2_0 SkyBloomPS();
    }
}

technique RenderSkyBloomBlend
{
    pass p0
    {       
        PixelShader = compile ps_2_0 SkyBloomBlendPS();
    }
}

technique RenderColorAdjust
{
    pass p0
    {       
        PixelShader = compile ps_2_0 ColorAdjustPS();
    }
}


technique DetectSky
{
    pass p0
    {       
        PixelShader = compile ps_2_0 DetectSkyPS();
    }
}

technique RenderMotionBlur
{
    pass p0
    {       
        PixelShader = compile ps_2_0 MotionBlurPS();
    }
}

technique RenderPadding
{
    pass p0
    {       
        PixelShader = compile ps_2_a PaddingPS();
    }
}

technique RenderOutline
{
    pass p0
    {
        VertexShader = NULL;
        PixelShader = compile ps_2_0 OutlinePS();
    }
}

technique RenderOutlineFinal
{
    pass p0
    {
        VertexShader = NULL;
        PixelShader = compile ps_2_0 OutlinePSFinal();
    }
}

technique RenderOutlineGlowX
{
    pass p0
    {
        VertexShader = NULL;
        PixelShader = compile ps_2_0 OutlinePSGlowX();
    }
}

technique RenderOutlineGlowY
{
    pass p0
    {
        VertexShader = NULL;
        PixelShader = compile ps_2_0 OutlinePSGlowY();
    }
}

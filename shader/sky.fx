texture			g_texture0;
texture			g_texture1;
texture			g_sunTexture;
texture			g_lensFlareTexture;
float           g_delta;

float g_sunX;
float g_sunY;
float g_width;
float g_height;

float g_ratio;
float4 g_scale;
float4 g_color;

float g_constA; //중심 포인트x
float g_constB; //중심 포인트y
float g_constC; //로테이션 컨트롤
float g_constD; //pre 스케일 컨트롤
float g_constE; //post 스케일 컨트롤
float g_constF;

float3 g_sunPos : SunPos;
bool g_sunHit : SunHit;
float3 g_sunColor : SunColor;


float4x4 g_ViewProjMatrix : PROJ;

sampler g_textureSampler0 = sampler_state
{
    Texture = <g_texture0>;
    MinFilter = LINEAR;
    MagFilter = LINEAR;
    MipFilter = LINEAR;
    AddressU = CLAMP;
    AddressV = CLAMP;
};

sampler g_textureSampler1 = sampler_state
{
    Texture = <g_texture1>;
    MinFilter = LINEAR;
    MagFilter = LINEAR;
    MipFilter = LINEAR;
    AddressU = CLAMP;
    AddressV = CLAMP;
};


sampler g_sunTextureSampler = sampler_state
{
    Texture = <g_sunTexture>;
    MinFilter = LINEAR;
    MagFilter = LINEAR;
    MipFilter = LINEAR;
    AddressU = CLAMP;
    AddressV = CLAMP;
};

sampler g_lensFlareTextureSampler = sampler_state
{
    Texture = <g_lensFlareTexture>;
    MinFilter = LINEAR;
    MagFilter = LINEAR;
    MipFilter = LINEAR;
    AddressU = CLAMP;
    AddressV = CLAMP;
};

texture Diff1
<
    string UIName = "Diffuse1";
    int Texcoord = 0;
    int MapChannel = 1;
>;

sampler Diff1Samp = sampler_state
{
    Texture   = (Diff1);
    MinFilter = LINEAR;
    MagFilter = LINEAR;
    MipFilter = LINEAR;    
    AddressU  = CLAMP;
    AddressV  = CLAMP;
};

struct PS_OUTPUT
{
    float4 color 		: COLOR0;  // Pixel color
};

void DefaultRender(
    float2 uv :TEXCOORD0
    , out float4 FinalColor : COLOR0
#ifdef _DEPTH_BUFFER
    , out float4 DepthColor : COLOR1
#endif
)
{
    FinalColor = tex2D(Diff1Samp, uv);
#ifdef _DEPTH_BUFFER
    DepthColor = float4(0,0,0,1);
#endif
}

PS_OUTPUT SkyPass(float2 uv :TEXCOORD0)
{
	PS_OUTPUT O;	
    
    float4 skyColor0 = tex2D(g_textureSampler0, uv);
    float4 skyColor1 = tex2D(g_textureSampler1, uv);
             
    if (skyColor0.x == skyColor1.x && skyColor0.y == skyColor1.y && skyColor0.z == skyColor1.z)
    {
        O.color = skyColor0;
        O.color.w = 1;
    }
    else
    {
        O.color = float4(0, 0, 0, 0);
    }
    
	return O;
}

PS_OUTPUT EyeAdaptation(float2 uv :TEXCOORD0)
{
	PS_OUTPUT O;
	
    float4 curColor = tex2D(g_textureSampler1, uv);
    if (curColor.x > 1.f)
        curColor.x = 1.f;
    else if (curColor.x < 0.f)
        curColor.x = 0.f;
        
    int lightIntensity = 0;
    for (int i = 1; i < 4; ++i)
    {
        for (int j = 1; j < 4; ++j)
        {
            float4 skyColor = tex2D(g_textureSampler0, float2(i / 4.f, j / 4.f));
            if (skyColor.x + skyColor.y + skyColor.z > 0)
                lightIntensity += 1.f;
        }
    }
    
    if (lightIntensity > 6)
    {
        curColor.x += 0.01f;
        if (curColor.x > 1.f)
            curColor.x = 1.f;
    }
    else if (lightIntensity < 4)
    {
        curColor.x -= 0.01f;
        if (curColor.x < 0.f)
            curColor.x = 0.f;
    }
        
    O.color = curColor;
    
	return O;
}

PS_OUTPUT RenderSun(float2 uv :TEXCOORD0)
{
    PS_OUTPUT O;
    
    O.color = float4(0, 0, 0, 0);
    
    if (g_sunX >= 0)
    {    
        float2 sunUV[5];
        sunUV[0] = float2(g_sunX / g_width, g_sunY / g_height);
        sunUV[1] = float2((g_sunX - 10) / g_width, (g_sunY - 10) / g_height);
        sunUV[2] = float2((g_sunX - 10) / g_width, (g_sunY + 10) / g_height);
        sunUV[3] = float2((g_sunX + 10) / g_width, (g_sunY - 10) / g_height);
        sunUV[4] = float2((g_sunX + 10) / g_width, (g_sunY + 10) / g_height);
        
        
        for (int i = 0; i < 5; ++i)
        {
            float2 checkUV = sunUV[i];
            if (checkUV.x < 0)
                checkUV.x = 0;
            if (checkUV.x > 1)
                checkUV.x = 1;
                
            if (checkUV.y < 0)
                checkUV.y = 0;
            if (checkUV.y > 1)
                checkUV.y = 1;
                
            float4 skyColor = tex2D(g_textureSampler0, checkUV);
            if (skyColor.x + skyColor.y + skyColor.z > 0)
            {
                O.color.x = 1.f;
            }
        }
    }
    
    return O;
}

PS_OUTPUT RenderLensFlare(float2 uv :TEXCOORD0)
{
    PS_OUTPUT O;
    
    float4 color = tex2D(g_textureSampler0, uv);
    float4 sunColor = tex2D(g_sunTextureSampler, uv);
    float4 lensFlareColor = tex2D(g_lensFlareTextureSampler, uv);
    
    O.color = color;
    if (sunColor.x > 0)
        O.color += lensFlareColor;
    
    return O;
}

void LensFlareVS(
    float2 vPos : POSITION,
    float2 vTexCoord0 : TEXCOORD0,
    float4 vColor : COLOR0,
    
    out float4 oPos : POSITION,
    out float2 oTexCoord0 : TEXCOORD0,
    out float4 oColor : COLOR0)
{
    //태양위치 올바르게 들어오면 고칠부분
//    g_sunPos = max(min(g_sunPos,3.0),-3.0);
//    g_sunPos.y = 0.5 - g_sunPos.y;
    ////////////////////////////////////
//    vPos.x *= 10.5;

    oColor = g_color * 5;
    
    float2 centerPos = float2(0.0,0.0);
    float2 moveVal =float2(0.0,0.30);
    float posRate = 1;
    float2 preScale = float2(1.00,1.00);
    float2 postScale = float2(2.00,2.00);
    float startRotation = 3.141592;
    float rotRate = 0.0;
    float2 posLimit = float2(1,1);
    
    float3 fadeStep = float3(0.1,1.0,2.1);
    float3 alphaStep = float3(0.1,10.55,0);
    
    float2 newPos = (g_sunPos - centerPos) * posRate;
    float3 normalToSun = normalize(g_sunPos);
    float angleVal = startRotation + (g_sunPos.x * rotRate);
    float cosVal = cos(angleVal);
    float sinVal = sin(angleVal);
    float3x3 rotMat;
    rotMat[0] = float3(cosVal, -sinVal, 0);
    rotMat[1] = float3(sinVal, cosVal, 0);
    rotMat[2] = float3(0,0,1);

    float4 position = float4(vPos.xy,0,1);
    position.xy *= preScale;
    position.xyz = mul(position, rotMat);
    position.xy *= postScale;
    position.xy += min(max(newPos.xy, -posLimit),posLimit) + moveVal;
//    float2 alpha = 1-min(1,((max((abs(g_sunPos)-fadeStart),0)) / (displayRange-fadeStart)));
    
    float alpha = length(g_sunPos.xy);
    if (alpha > fadeStep.y)
    {
        alphaStep.xy = float2(alphaStep.y,alphaStep.z);
        fadeStep.xy = float2(fadeStep.y,fadeStep.z);
    };
    alpha = lerp(alphaStep.x, alphaStep.y, saturate(alpha - fadeStep.x) / (fadeStep.y-fadeStep.x));
//    alpha = max(0,(alpha - fadeStep.x)) / (fadeStep.y-fadeStep.x);
//    alpha = fadeStep.z;
    oColor.xyz = alpha;// * g_sunColor.xyz;
    oColor.a = 1;
//    oColor.xy = 1-max((abs(g_sunPos)-fadeStart),0);
    oColor.rgb = min((normalToSun.z*2),1)*g_sunColor.xyz*4;
    oTexCoord0 = vTexCoord0;
    oPos = position;
    

/*
    oPos.x = (vPos.x*g_scale.x) + g_sunPos.x - 2*g_sunPos.x*g_ratio;
    oPos.y = (vPos.y*g_scale.y) + g_sunPos.y - 2*g_sunPos.y*g_ratio;
    oPos.zw = float2(0.0f, 1.0f);
    
    oTexCoord0 = vTexCoord0;
    oColor = g_color;
*/
}

void LensFlarePS(
    float2 uv :TEXCOORD0,
    float4 vColor : COLOR0,
    out float4 oColor : COLOR0)
{
    oColor = vColor * tex2D(g_textureSampler0, uv);
//    oColor = vColor.xxxx;
//    oColor.xyz = g_sunColor.xyz*5;
//    oColor.xyz = g_sunHit;
//    oColor = float4(0,0,1,1);
}

technique RenderSky
{
    pass p0
    {       
        PixelShader = compile ps_2_0 DefaultRender();
    }
}

technique SkyPass
{
    pass p0
    {       
        PixelShader = compile ps_2_0 SkyPass();
    }
}

technique SkyCopy
{
    pass p0
    {       
        PixelShader = compile ps_2_0 DefaultRender();
    }
}

technique EyeAdaptation
{
    pass p0
    {       
        PixelShader = compile ps_2_0 EyeAdaptation();
    }
}

technique RenderSun
{
    pass p0
    {       
        PixelShader = compile ps_2_0 RenderSun();
    }
}

technique RenderLensFlareToBuffer
{
    pass p0
    {       
        VertexShader = compile vs_2_0 LensFlareVS();
        PixelShader = compile ps_2_0 LensFlarePS();
    }
}

technique RenderLensFlare
{
    pass p0
    {       
        PixelShader = compile ps_2_0 RenderLensFlare();
    }
}

technique RenderScene_1_1
{
    pass P0
    {
        PixelShader  = compile ps_2_0 DefaultRender();
    }    
}

technique RenderScene_2_0
{
    pass P0
    {
        PixelShader  = compile ps_2_0 DefaultRender();
    }
}

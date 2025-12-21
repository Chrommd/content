/*------------------------------------------------------------___-------------------------------------------------------
                                                             /   |                                                      
                                                            / /| |                                                      
                                                           / ___ |                                                      
                                            P R O J E C T /_/  |_| L I C E                                              
                                        Copyright (C) 2005-2007 NTREEV SOFT Inc.                                        
----------------------------------------------------------------------------------------------------------------------*/

#ifdef THIS_IS_CLIENT
    float timeV : TimeScroll;
#else
    #ifndef THIS_IS_MAX
    #define THIS_IS_MAX
    #endif
    float timeV : Time;
#endif

texture c_diffTex0
<
    string UIName = "Diffuse0 Texture";
    int Texcoord   = 0;
    int MapChannel = 1;
>;

float3 c_diff0Color
<
    string UIName = "Diff0 Color";
> = float3( 1.0, 1.0, 1.0);
float c_diff0Opac
<
    string UIName = "Diff0 Opacity";
> = 1.0f;  
float2 c_diff0UVCoord
<
  string UIName = "Diff0 UV_Coordinate";
> = float2(0.0, 0.0);    

float c_diff0UVSize
<
  string UIName = "Diff0 UV_Size";
> = 1.0f;  

float c_diff0UVSpeed
<
  string UIName = "Diff0 UV_Speed";
> = 1.0f;  


texture c_diffTex1
<
    string UIName = "Diffuse1 Texture";
>;

float3 c_diff1Color
<
    string UIName = "Diff1 Color";
> = float3( 1.0, 1.0, 1.0);
float c_diff1Opac
<
    string UIName = "Diff1 Opacity";
> = 1.0f;  
float2 c_diff1UVCoord
<
  string UIName = "Diff1 UV_Coordinate";
> = float2(0.0, 0.0);    

float c_diff1UVSize
<
  string UIName = "Diff1 UV_Size";
> = 1.0f;  

float c_diff1UVSpeed
<
  string UIName = "Diff1 UV_Speed";
> = 1.0f;  


sampler2D c_diffSamp0 = sampler_state 
{
    Texture   = (c_diffTex0);
    MinFilter = LINEAR;
    MagFilter = LINEAR;
    MipFilter = LINEAR;
    AddressU  = Wrap;
    AddressV  = Wrap;
};

sampler2D c_diffSamp1 = sampler_state 
{
    Texture   = (c_diffTex1);
    MinFilter = LINEAR;
    MagFilter = LINEAR;
    MipFilter = LINEAR;
    AddressU  = Wrap;
    AddressV  = Wrap;
};

texture c_diffTex2
<
    string UIName = "Alpha Mask";
>;

sampler2D c_diffSamp2 = sampler_state 
{
    Texture   = (c_diffTex2);
    MinFilter = LINEAR;
    MagFilter = LINEAR;
    MipFilter = LINEAR;
    AddressU  = Wrap;
    AddressV  = Wrap;
};

#ifdef THIS_IS_MAX
    int c_blendMode
    <
      string UIName = "Blend Mode(1:Add 2:Blend 3:BlendedAdd 4:Inverse)";
      float UIMin = 1;
      float UIMax = 4;
    > = 3;  

    //Function  
    int blendModeSrcFn(int vBlend)
    {
        int oSrc;
        if (c_blendMode == 1)
        {
            oSrc = 2;
        }
        else if (c_blendMode == 4)
        {
            oSrc = 1;
        }
        else
        {
            oSrc = 5;
        }
        return oSrc;
    }
    int blendModeDestFn(int vBlend)
    {
        int oDest;
        if (c_blendMode == 1 || c_blendMode == 3)
        {
            oDest = 2;
        }
        else
        {
            oDest = 6;
        }
        return oDest;
    }
#endif

// transformations
float4x4 WorldViewProj : 	WORLDVIEWPROJ;
    
struct VS_OUTPUT
{
    float4 Pos  : POSITION;
    float2 Tex0  : TEXCOORD0; 
    float2 Tex1  : TEXCOORD1;
    float2 Tex2  : TEXCOORD2;
};

VS_OUTPUT VS(
    float3 Pos  : POSITION, 
    float2 Tex0  : TEXCOORD0)
//    float2 Tex1  : TEXCOORD1,
//    float2 Tex2  : TEXCOORD2)
{
    VS_OUTPUT Out = (VS_OUTPUT)0;

    Out.Pos  = mul(float4(Pos,1),WorldViewProj);    // position (projected)

    #ifdef THIS_IS_MAX
        timeV *= 0.027;
    #endif
    
    Out.Tex0 = (Tex0+c_diff0UVCoord)*c_diff0UVSize;    
//    Out.Tex0.y *= abs(0.05*cos(0.5*timeV))+1;
    Out.Tex0.y -= timeV*c_diff0UVSpeed;

    Out.Tex1 = (Tex0+c_diff1UVCoord)*c_diff1UVSize;    
    Out.Tex1.y -= timeV*c_diff1UVSpeed;
    Out.Tex2 = Tex0;

    return Out;
}


float4 PS(
    float2 Tex0  : TEXCOORD0,
    float2 Tex1  : TEXCOORD1,
    float2 Tex2  : TEXCOORD2 ) : COLOR
{
    float4 diff0Map = tex2D(c_diffSamp0, Tex0);
    diff0Map.rgb *= c_diff0Color.rgb;
    diff0Map.a *= c_diff0Opac;
//    float sh = tex2D(c_diffSamp1, Tex1*1.5).a;  // 그림자테스트
//    diff0Map.rgb = lerp(diff0Map.rgb, float3(0.1,0.1,0.1), sh);
    float4 diff1Map = tex2D(c_diffSamp1, Tex1);
    diff1Map.rgb *= c_diff1Color.rgb;
    diff1Map.a *= c_diff1Opac;
    float alphaLayerMap = tex2D(c_diffSamp2, Tex2).r;
    
//    float4 color = diff0Map+diff1Map;
    float4 color = lerp(diff1Map, diff0Map, diff0Map.a)*1.2;
    color.a *= alphaLayerMap;
    return  color;
}

float4 PS_p0(
    float2 Tex0  : TEXCOORD0,
//    float2 Tex1  : TEXCOORD1,
    float2 Tex2  : TEXCOORD2     ) : COLOR
{
    float4 diff0Map = tex2D(c_diffSamp0, Tex0);
//    float sh = tex2D(c_diffSamp1, Tex1*1.5).a;  // 그림자테스트
    diff0Map.rgb *= c_diff0Color.rgb;
    diff0Map.a *= c_diff0Opac;
//    diff0Map.rgb = lerp(diff0Map.rgb, float3(0.1,0.1,0.1), sh);
    float alphaLayerMap = tex2D(c_diffSamp2, Tex2).r;
    
    float4 color = diff0Map;
    color.a *= alphaLayerMap;
    return  color ;
}

float4 PS_p1(
    float2 Tex1  : TEXCOORD1,
    float2 Tex2  : TEXCOORD2 ) : COLOR
{
    float4 diff1Map = tex2D(c_diffSamp1, Tex1);
    diff1Map.rgb *= c_diff1Color.rgb;
    diff1Map.a *= c_diff1Opac;
    float alphaLayerMap = tex2D(c_diffSamp2, Tex2).r;
    
    float4 color = diff1Map;
    color.a *= alphaLayerMap;
    return  color ;
}

#ifdef THIS_IS_MAX
technique RenderScene_2_0
{
    pass P0
    {
        ZEnable         = true;
      	ZWriteEnable    = false;
        SrcBlend 		    = blendModeSrcFn(c_blendMode);
        DestBlend 		  = blendModeDestFn(c_blendMode);
        VertexShader = compile vs_2_0 VS();
        PixelShader  = compile ps_2_0 PS_p0();
    }  
    pass P1
    {
        ZEnable         = true;
      	ZWriteEnable    = false;
        SrcBlend 		    = blendModeSrcFn(c_blendMode);
        DestBlend 		  = blendModeDestFn(c_blendMode);
        VertexShader = compile vs_2_0 VS();
        PixelShader  = compile ps_2_0 PS_p1();
    }  
}
#else
technique RenderScene_1_1
{
    pass P0
    {
        VertexShader = compile vs_2_0 VS();
        PixelShader  = compile ps_2_0 PS();
    }    
}

technique RenderScene_2_0
{
    pass P0
    {
        VertexShader = compile vs_2_0 VS();
        PixelShader  = compile ps_2_0 PS_p0();
    }  
    pass P1
    {
        VertexShader = compile vs_2_0 VS();
        PixelShader  = compile ps_2_0 PS_p1();
    }  
}
#endif

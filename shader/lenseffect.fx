half			g_width;
float			g_height;
float g_screenRatio //화면 좌우 비율. (넓이/높이)
<
  string UIName = "Screen Ratio";
  float UIMin = -100.00;
  float UIMax = 100.00;
> = 0.75;
float c_posRatio
<
  string UIName = "Pos Ratio                                    /// Pos Ratio ///";
  float UIMin = -100.00;
  float UIMax = 100.00;
> = 0.75; 
float2 c_center
<
  string UIName = "Center  (float2)";
> = float2(0.0f, 0.0f);
float3 c_color
<
  string UIName = "Color  (float3)                                       *** Color ***";
> = float3(1.0f, 1.0f, 1.0f);
float g_alpha
<
  string UIName = "Alpha                                                  *** Alpha ***";
  float UIMin = 0.00;
  float UIMax = 1.00;
> = 1.0f;
float2 c_blockPoint
<
  string UIName = "Block Point  (float2)                           /// Block ///";
  float UIMin = -100.00;
  float UIMax = 100.00;
> = 1.2;



/*
float2 c_posOffset
<
  string UIName = "Pos Offset  (float2)";
> = float2(0.0, 0.0);
*/
float2 c_scale
<
  string UIName = "Scale (float2)                                      *** Scale ***";
> = float2(1.0,1.0);
float2 c_scaleLevel
<
  string UIName = "Scale Per Pos (float2)                         *** Scale ***";
> = 0.0;
float c_angLevel
<
  string UIName = "Rot Per Pos -All                                   /// Rot ///";
> = 0.0; 
float2 c_diffAngLevel
<
  string UIName = "Rot Per Pos -RGB  (float2)                   /// Rot ///";
> = 0.0; 

float2 c_fadeInPointA
<
  string UIName = "Fade In Point A (float2)                 in *** Fade A ***";
> = float2(1.0f, 1.0f);
float2 c_fadeOutPointA
<
  string UIName = "Fade Out Point A (float2)            out *** Fade A ***";
> = float2(1.2f, 1.2f);
float2 c_fadeExpA
<
  string UIName = "Fade Exp A";
> = float2(1.0f, 1.0f);
float c_fadeBrightA
<
  string UIName = "Fade Bright A";
> = 1.0;
/*
float c_fadeScaleA
<
  string UIName = "Fade Scale A";
> = 1.0;
*/
float2 c_fadeInPointB
<
  string UIName = "Fade In Point B (float2)              out *** Fade B ***";
> = float2(1.0f, 1.0f);
float2 c_fadeOutPointB
<
  string UIName = "Fade Out Point B (float2)              in *** Fade B ***";
> = float2(1.2f, 1.2f);
float2 c_fadeExpB
<
  string UIName = "Fade Exp B";
> = float2(1.0f, 1.0f);
float c_fadeBrightB
<
  string UIName = "Fade Bright B";
> = 0.0;
/*
float c_fadeScaleB
<
  string UIName = "Fade Scale B";
> = 0.0;
*/
float c_depth   //! if it is the sun , 1.0f
<
    string  UIName = "Depth Offset";
> = 0.0001f;
float3 sunPos : SunPos
<
> = float3(1,1,1);
float4x4 g_WVP : WORLDVIEWPROJ;
float4x4 g_VP : VIEWPROJ;
float3 g_worldCamera : WORLDCAMERAPOSITION;
float3	g_lightDir : Direction 
<  
	string UIName = "Light"; 
	string Object = "TargetLight";
	int refID = 0;
> = {0.577, 0.577, 0.577};
float4 g_direct : direct
<
	string UIName = "Direct";
> = float4(0.177986f, 0.173842f, 0.161236f, 1.0f);
float4 g_indirect : Indirect
<
	string UIName = "Indirect";
> = float4( 0.133369, 0.135692, 0.131679, 1.0);

texture c_texture //디퓨즈 텍스쳐
<
    string UIName = "Diffuse0";
    int Texcoord = 0;
    int MapChannel = 1;
>;
sampler c_textureSampler0 = sampler_state
{
    Texture = <c_texture>;
    MinFilter = LINEAR;
    MagFilter = LINEAR;
    MipFilter = LINEAR;
    AddressU = Clamp;
    AddressV = Clamp;
};


// 정리중
void DefaultVS(
     float4 vPos            : POSITION
    ,float2 vTex0           : TEXCOORD0
    , out float4 oPos       : POSITION
    , out float2 oTex0      : TEXCOORD0
    , out float2 oTex1      : TEXCOORD1
    , out float oOpacity    : TEXCOORD2
    )
{
    //! 태양의 월드 위치를 계산하고 프로젝션하여 뷰포트내에 포함되는지 체크한다.
    //! 클라이언트에서 계산해서 전달 가능
    
    oPos.xyz = sunPos;
    float3 vSun = sunPos;

    //! 거리에 따른 투명도 조절
    float directAlpha = 1.f; //g_direct.a * g_alpha;
    
    float2 fadeA = lerp(1.f, 0.001f, saturate((abs(vSun.xy)-c_fadeInPointA) / abs(c_fadeOutPointA-c_fadeInPointA)));
    fadeA = pow(fadeA, c_fadeExpA); //화면위치에 따른 외곽 페이드 값(알파값) 구하기
	
	float2 fadeBrightA = lerp(1.0f, fadeA, c_fadeBrightA); // 외곽 페이드 값에 따른 밝기 조절
    
    float2 fadeB = lerp(0.001f, 1.0f, saturate((abs(vSun.xy)-c_fadeOutPointB) / abs(c_fadeInPointB-c_fadeOutPointB)));
    fadeB = pow(fadeB, c_fadeExpB); //화면 위치에 따른 내부 페이드 값(알파값) 구하기

    float2 fadeBrightB = lerp(1.0f, fadeB, c_fadeBrightB); // 내부 페이드 값에 따른 밝기 조절

    //oOpacity = g_alpha*fadeA.x*fadeA.y*max(fadeBrightB.x,fadeBrightB.y)*directAlpha; // 전체 밝기(알파값) 구하기
	oOpacity = g_alpha*min(fadeBrightA.x,fadeBrightA.y)*max(fadeBrightB.x,fadeBrightB.y)*directAlpha; // 전체 밝기(알파값) 구하기

    float       fCos = 0.0f;
    float       fSin = 0.0f;
    float2x2    mRot;

    float2 vUp = float2(0.0f, 1.0f);
    float2 vNorSun = lerp(vUp,normalize(vSun.xy),c_angLevel);         //! c_angLevel 은 0~1 사이의 값이어야 합니다.
    //float2 vNorSun = normalize(vSun.xy);                                //! 상수값이 이상한듯 하여 테스트로 넣어봄
    
    float fRot = acos(dot(vUp, vNorSun));
    
    if(vNorSun.x<0.0f)
    {
        fRot *= -1.0f;
    }
    sincos(fRot, fSin, fCos);

    mRot[0] = float2(fCos, -fSin);
    mRot[1] = float2(fSin, fCos);

    //! 태양의 거리로 메쉬의 크기를 결정
	float vDist = length(vSun.xy - c_center);
    float2 vScale = max(0.0f, (vDist*c_scaleLevel) + c_scale);
    //float2 vScale = max(0.0f, length(vSun.xy) + 1.f);   //! 상수값이 이상한듯 하여 테스트로 넣어봄
    float2 vTrans = mul(vPos.xz, mRot);
    vTrans.x *= g_screenRatio;
    vTrans *= vScale;

    //! 태양 위치를 기준으로 텍스쳐를 회전
    //fRot = (oPos.x * c_diffAngLevel.x) + (oPos.y * c_diffAngLevel.y); //고친 부분
    fRot = dot(oPos.xy, c_diffAngLevel.xy);
    sincos(fRot, fSin, fCos);
    mRot[0] = float2(fCos, -fSin);
    mRot[1] = float2(fSin, fCos);

    //! 태양이 보이는 영역을 제한
    //vSun.xy = clamp((vSun.xy*c_posRatio)+c_center, -c_blockPoint, c_blockPoint);
	vSun.xy = clamp((vSun.xy*c_posRatio), (-c_blockPoint + c_center), (c_blockPoint + c_center));
	vSun.xy += c_center * (1.0f - c_posRatio);
	
    oPos.xy = vSun.xy + vTrans;
    oPos.z = c_depth;
    oPos.w = 1.f;

    oTex0 = mul(vTex0-0.5f, mRot)+0.5f; //! 중점 회전을 위해 이동->회전->이동
    oTex1 = vTex0;
}


void DefaultPS(float2 vTex0         : TEXCOORD0
                , float2 vTex1      : TEXCOORD1
                , float vOpacity    : TEXCOORD2
                , out half4 oColor  : COLOR0
                )
{
    oColor.rgb = tex2D(c_textureSampler0, vTex0).rgb * c_color;
    oColor.a = tex2D(c_textureSampler0, vTex1).a * vOpacity*g_indirect.a;
    //oColor.a = 1.0f;
    //oColor.rgb *= 8.0f;
}


void PassThruVS(
          float4 vPos           : POSITION
        , float2 vTex0          : TEXCOORD0
        , out float4 oPos       : POSITION
        , out float2 oTex0      : TEXCOORD0
        , out float2 oTex1      : TEXCOORD1
        , out float oOpacity    : TEXCOORD2
      //  , out half4 oColor0     : COLOR0
    )
{
    ////////////////////////////////////태양위치 구하는 부분 - 맥스에서만 사용.
    oPos = mul(float4(g_worldCamera.xyz+(g_lightDir*128.f), 1.0f), g_WVP);
    oPos.xy /= oPos.w;
//    oColor0 = 1.0f;
//    oColor0.a = 1.0f;
    if (oPos.w < 0)
    {
        oPos.xy *= -1;
    }
    float3 vSun = oPos;
    ///////////////////////////////////////
    float directAlpha = 1.f; //g_direct.a * g_alpha;
    
    float2 fadeA = lerp(1.f, 0.001f, saturate((abs(vSun.xy)-c_fadeInPointA) / abs(c_fadeOutPointA-c_fadeInPointA)));
    fadeA = pow(fadeA, c_fadeExpA); //화면위치에 따른 외곽 페이드 값(알파값) 구하기
	
	float2 fadeBrightA = lerp(1.0f, fadeA, c_fadeBrightA); // 외곽 페이드 값에 따른 밝기 조절
    
    float2 fadeB = lerp(0.001f, 1.0f, saturate((abs(vSun.xy)-c_fadeOutPointB) / abs(c_fadeInPointB-c_fadeOutPointB)));
    fadeB = pow(fadeB, c_fadeExpB); //화면 위치에 따른 내부 페이드 값(알파값) 구하기

    float2 fadeBrightB = lerp(1.0f, fadeB, c_fadeBrightB); // 내부 페이드 값에 따른 밝기 조절
    
    if (oPos.w>0.0f) //! 맥스를 위해 추가한 부분 - 태양이 뒷면에 있을 때 안그리도록
    {
        //oOpacity = g_alpha*fadeA.x*fadeA.y*max(fadeBrightB.x,fadeBrightB.y)*directAlpha; // 전체 밝기(알파값) 구하기
		oOpacity = g_alpha*min(fadeBrightA.x,fadeBrightA.y)*max(fadeBrightB.x,fadeBrightB.y)*directAlpha; // 전체 밝기(알파값) 구하기
    }
    else
    {
        oOpacity = 0.0f;
    }

    float       fCos = 0.0f;
    float       fSin = 0.0f;
    float2x2    mRot;

    float2 vUp = float2(0.0f, -1.0f);
    float2 vNorSun = lerp(vUp,normalize(vSun.xy),c_angLevel);         //! c_angLevel 은 0~1 사이의 값이어야 합니다.
    //float2 vNorSun = normalize(vSun.xy);                                //! 상수값이 이상한듯 하여 테스트로 넣어봄
    
    float fRot = acos(dot(vUp, vNorSun));
    
    if(vNorSun.x>0.0f)
    {
        fRot *= -1.0f;
    }
    sincos(fRot, fSin, fCos);

    mRot[0] = float2(fCos, -fSin);
    mRot[1] = float2(fSin, fCos);
    
    //! 태양의 거리로 메쉬의 크기를 결정
	float vDist = length(vSun.xy - c_center);
    float2 vScale = max(0.0f, (vDist*c_scaleLevel) + c_scale);
    //float2 vScale = max(0.0f, length(vSun.xy) + 1.f);   //! 상수값이 이상한듯 하여 테스트로 넣어봄
    float2 vTrans = mul(vPos.xy, mRot); //맥스 좌표계에 맞게 변형(게임에서는 float2 vTrans = mul(vPos.xz, mRot);)
    vTrans.x *= g_screenRatio;
    vTrans *= vScale;
    
    //! 태양 위치를 기준으로 텍스쳐를 회전
    fRot = (oPos.x * c_diffAngLevel.x) + (oPos.y * c_diffAngLevel.y);
    sincos(fRot, fSin, fCos);
    mRot[0] = float2(fCos, -fSin);
    mRot[1] = float2(fSin, fCos);

    //! 태양이 보이는 영역을 제한
	vSun.xy = clamp((vSun.xy*c_posRatio), (-c_blockPoint + c_center), (c_blockPoint + c_center));
	vSun.xy += c_center * (1.0f - c_posRatio);
    //vSun.xy = clamp(vSun.xy, -c_blockPoint, c_blockPoint);
	
    
    //sunPos = float3(vSun.xy*c_posRatio, 0.f);
    
    oPos.xy = vSun.xy + vTrans;
    oPos.z = 0.0001;
    oPos.w = 1.f;
    oTex0 = mul(vTex0+float2(-0.5f, 0.5f), mRot)+0.5f; //! 중점 회전을 위해 이동->회전->이동, 맥스 좌표계에 맞게 변형
    oTex1 = vTex0 + float2(0.f, 1.f);
}

void PassThruPS(float2 vTex0 : TEXCOORD0
                , float2 vTex1      : TEXCOORD1
                , float vOpacity    : TEXCOORD2
             //   , half4 vColor0      : COLOR01
             , out half4 oColor : COLOR0
             )
{
    oColor.rgb = tex2D(c_textureSampler0, vTex0).rgb * c_color;
    oColor.a = tex2D(c_textureSampler0, vTex1).a * vOpacity;
//    oColor.rgb = 1.f;
//    oColor.a = 1.0f;
}

technique Preview
{
    pass P0
    {
      AlphaBlendEnable= true;
      ZEnable         = true;
    	ZWriteEnable    = false;
      CullMode        = None;
      AlphaTestEnable = false;
    	
      DestBlend 		= ONE;
      SrcBlend 		= SRCALPHA;

      VertexShader = compile vs_2_0 PassThruVS();
      PixelShader  = compile ps_2_0 PassThruPS();
    }
}

technique RenderScene_1_1
{
    pass P0
    {
        VertexShader = compile vs_2_0 DefaultVS();
        PixelShader  = compile ps_2_0 DefaultPS();
    }    
}

technique RenderScene_2_0
{
    pass P0
    {
        VertexShader = compile vs_2_0 DefaultVS();
        PixelShader  = compile ps_2_0 DefaultPS();
    }
}

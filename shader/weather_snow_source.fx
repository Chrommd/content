/*
//weather_snow_source.fx
// Creation Date: 23 November 2011
// Last Update:
// Version: 0.1
// Description: 0.1 snow 효과에 사용되는 shader_source
//                  
*/

///////////
float4x4 g_worldViewProjMatrix : WORLDVIEWPROJ;
float4x4 g_worldMatrix : WORLD;

#ifdef _3DSMAX_
float3 g_cameraPosition : WORLDCAMERAPOSITION;
float timeV : TIME;
#else
float3 g_cameraPosition : CameraPosition;
float timeV : TimeScroll;
#endif

float3 g_charPos : WeatherCharPosition;     //캐릭터위치
float2 g_speedV : WeatherCharSpeed;         // x: 회전x축, y: 이동거리
float4 g_collision : WeatherCollisionSphere;      //xyz: 충돌체 구의위치, w:충돌체 구의 반지름
float g_visibility : WeatherVisibility;

float c_turbulence : WeatherTurbulence
<
	string UIName = "turbulence";
	string UIType = "Slider";
	float UIMin = 0.0f;
	float UIMax = 20.0f;
	float UIStep = 0.1f;
	float UIAtten = 1.0f;
> = 1.0;

float c_density : WeatherDensity
<
	string UIName = "density";
	string UIType = "Slider";
	float UIMin = 0.0f;
	float UIMax = 5.0f;
	float UIStep = 0.1f;
	float UIAtten = 1.0f;
> = 1.0;

float c_speed : WeatherSpeed
<
	string UIName = "speed";
	string UIType = "Slider";
	float UIMin = 0.0f;
	float UIMax = 5.0f;
	float UIStep = 0.1f;
	float UIAtten = 1.0f;
> = 1.0;

float2 c_uvTile : WeatherUVTile
<
	string UIName = "uv Tile";
	string UIType = "Slider";
	float UIMin = 0.0f;
	float UIMax = 10.0f;
	float UIStep = 0.1f;
	float UIAtten = 1.0f;
> = float2(1.0, 1.0);

float c_streak : WeatherStreak                 // 기본값 0.3. 속도감 제어용. 눈의 종류 및 고정된 속도의 카메라(대기방 등) 이동시에 값 높일것
<
	string UIName = "streak";
	string UIType = "Slider";
	float UIMin = 0.0f;
	float UIMax = 2.0f;
	float UIStep = 0.1f;
	float UIAtten = 1.0f;
> = 1.0;

float c_fadeOut : WeatherFadeOut                  // 공간감표현
<
	string UIName = "fade out";
	string UIType = "Slider";
	float UIMin = 0.0f;
	float UIMax = 2.0f;
	float UIStep = 0.1f;
	float UIAtten = 1.0f;
> = 1;

float c_snowDust : WeatherSnowDust                 // 밀도
<
	string UIName = "snow dust";
	string UIType = "Slider";
	float UIMin = 0.0f;
	float UIMax = 2.0f;
	float UIStep = 0.1f;
	float UIAtten = 1.0f;
> = 1.0;

//------------------------------- Texture Samplers --------------------------//
texture t0
<
    string UIName = "Diffuse0";
    int Texcoord = 0;
    int MapChannel = 1;
>;
sampler s0 = sampler_state 
{ 
	Texture		= (t0);
	MinFilter	= Linear;
	MagFilter	= Linear;
	MipFilter	= Linear;
	AddressU	= Wrap;
	AddressV	= Wrap;
};


///////////

void mainVS(
	float3 vPos : POSITION
	, float2 vTex0 : TEXCOORD0
	, out float4 oPos : POSITION
	, out float4 oTex0 : TEXCOORD0
	, out float4 oColor : TEXCOORD1
	, out float oVertColor : TEXCOORD2)  
{
	oTex0 = float4(1,1,1,1); //초기화

	// 이동속도에 따른 텍스쳐이동속도변화
	float tV = 0.020*g_speedV.y*c_streak;   //이동거리값으로 계산

#ifdef BASIC   //일반용
	//실내 진입 블렌딩. 충돌체용과는 반대로. 충돌체크 거리값 10으로 설정
	float3 wPos = mul(float4(vPos, 1.0), g_worldMatrix);
	float distV = distance(g_collision.xyz, wPos);
	oVertColor = 1-smoothstep(0.25*g_collision.w, 0.45*g_collision.w, (g_collision.w-distV));   

	oPos = mul(float4(vPos, 1.0), g_worldViewProjMatrix);

	float c_scaleV = 0.8;   //사이즈테스트용
	oTex0.x = (1-0.007*g_speedV.x*c_scaleV)*(vTex0.x+0.003)*c_uvTile.x*1.1+oTex0.w*0.5;   // x좌표 스케일/이동 (xTileMove). 속도에 따라서 스케일 변화 추가
	oTex0.y = (1-0.012*g_speedV.x*c_scaleV)*vTex0.y*c_uvTile.y*2.f;                       // y좌표 스케일/이동 (yTileMove), x축 회전값 연계하여 y texcoord 길이늘림
	oTex0.z = timeV*c_speed+tV;//-0.09*g_speedV.x;               // y좌표 이동속도  (ySpeed) : 회전값만큼 이동 감소 시킴 >> 각 레이어당 제어하도록 픽셀셰이더로 넘김
#endif

#ifdef COLLISION  //충돌용: 회전되지 않음
	//실내 진입 블렌딩. 일반용과는 반대로. 충돌체크 거리값 10으로 설정
	float distV = distance(g_collision.xyz, g_charPos);
	oVertColor = smoothstep(-10*g_collision.w, -5*g_collision.w, (g_collision.w-distV));       //blending을 부드럽게. 나타나는 시간. 내부 외부 겹쳐지도록 설정.

	//실내 진입시 스케일 변경. 충돌체 사이즈 참고
	float sV = 3.0f*clamp(0.1*g_collision.w, 0.5, 0.1*g_collision.w);            // 메시 사이즈가 작아졌으므로 수정필요
	float3x3 scaleMatrix = {float3(sV,0,0),
							float3(0,sV,0),
							float3(0,0,sV)};
	oPos = mul(float4(mul(scaleMatrix,vPos), 1.0), g_worldViewProjMatrix);

	oTex0.x = (vTex0.x+0.003)*c_uvTile.x*(0.15*sV+0.5)*1.1+oTex0.w*0.5;   // x좌표 스케일/이동 (xTileMove)
	oTex0.y = vTex0.y*c_uvTile.y*(0.15*sV+0.5)*2.f;                       // y좌표 스케일/이동 (yTileMove)
	oTex0.z = timeV*c_speed+tV;      
#endif

	//공통 texcoord 연산
	oTex0.w = c_turbulence*sin(2*timeV)*0.05;  // (turbV)

	// 카메라 뷰에 따른 fadeOut
	float3 viewDir = normalize(g_cameraPosition - g_charPos);
	float distanceV = distance(g_cameraPosition, g_charPos);
	float camAng = 1.0-saturate(dot(float3(0.0, 1.0, 0.0), viewDir));    //그라운드면과 캐릭터to카메라 벡터 내적. top:0 >> side:1

	oColor.x = 1.0f;
	if ((vTex0.y > 0.8f) || (vTex0.y < 0.10f))
	{
		oColor.x = 0.0;
	}
	oColor.y = 1.0f;
	if ((vTex0.y > 0.8f - camAng*0.35*c_fadeOut+ 0.008*distanceV - 0.1) || (vTex0.y < 0.11f))
	{
		oColor.y = 0.0;
	}
	oColor.z = 1.0f;
	if ((vTex0.y > 0.75f - camAng*0.42*c_fadeOut+ 0.008*distanceV - 0.1) || (vTex0.y < 0.12f))
	{
		oColor.z = 0.0;
	}
	oColor.w = 1.0f;
	if ((vTex0.y > 0.7f - camAng*0.48*c_fadeOut+ 0.008*distanceV - 0.1) || (vTex0.y < 0.13f))
	{
		oColor.w = 0.0;
	}
}


//////////////
float4 mainPS(
	float4 vTex0 : TEXCOORD0
	,	float4 vColor : TEXCOORD1
	,	float vVertColor : TEXCOORD2) : COLOR
{
	//각 layer별 texcoord 연산
	float2 nTex0; float2 nTex1; float2 nTex2; float2 nTex3; float2 nTex4; 

	float c_ScaleV=0.9f;      //사이즈테스트용

#ifdef BASIC   //일반용
	nTex0.x = vTex0.x*1.25+vTex0.w;
	nTex0.y = vTex0.y*1.1 - vTex0.z*1.1+0.05*g_speedV.x*c_ScaleV;      // y좌표 이동속도  (ySpeed) : 회전값만큼 이동 감소 시킴. 각 레이어별 제어
	
	nTex1.x = vTex0.x*2.5+vTex0.w;
	nTex1.y = vTex0.y*2.5 - vTex0.z*1.1+0.1*g_speedV.x*c_ScaleV;

	#ifdef WEATHER_HIGH
		nTex2.x = vTex0.x*4.0-vTex0.w;
		nTex2.y = vTex0.y*4.0 - vTex0.z*1.4+0.15*g_speedV.x*c_ScaleV;

		nTex3.x = vTex0.x*3.0+vTex0.w;     
		nTex3.y = vTex0.y*3.0 - vTex0.z*1.3+0.12*g_speedV.x*c_ScaleV;
	#endif

	nTex4.x = vTex0.x*2.0 - vTex0.z*0.01;
	nTex4.y = vTex0.y*2.0 - vTex0.z*0.5+0.05*g_speedV.x;
#endif

#ifdef COLLISION  //충돌용
	nTex0.x = vTex0.x*2.0+vTex0.w;
	nTex0.y = vTex0.y*2.0 - vTex0.z*1.1;

	nTex1.x = vTex0.x*2.5+vTex0.w;
	nTex1.y = vTex0.y*2.5 - vTex0.z*1.1;

	#ifdef WEATHER_HIGH                        // 그래픽옵션 중이상
		nTex2.x = vTex0.x*4.0-vTex0.w;
		nTex2.y = vTex0.y*4.0 - vTex0.z*1.4;

		nTex3.x = vTex0.x*3.0+vTex0.w;     
		nTex3.y = vTex0.y*3.0 - vTex0.z*1.3;
	#endif

	nTex4.x = vTex0.x*2.0 - vTex0.z*0.01;
	nTex4.y = vTex0.y*2.0 - vTex0.z*0.5;
#endif

	float4 color0 = tex2D(s0, nTex0+nTex4*0.1).r*c_density*1.4;
	float4 color1 = tex2D(s0, nTex1).g*c_density*1.1;
#ifdef WEATHER_HIGH           
	float4 color2 = tex2D(s0, nTex2).r*c_density*0.8;
	float4 color3 = tex2D(s0, nTex3).g*c_density*0.9;
#endif
	float4 color4;
#ifdef BASIC   //일반용
	color4 = tex2D(s0, nTex4).b*c_density*2*c_snowDust;    //눈가루
#endif
#ifdef COLLISION  //충돌용
	color4 = tex2D(s0, nTex4).b*c_density*0.3*c_snowDust;    //눈가루
#endif

	// 카메라 뷰에 따른 fadeOut
	color0.a = (color0.r)*vColor.x;
	color1.a = (color1.r)*vColor.y;
#ifdef WEATHER_HIGH
	color2.a = (color2.r)*vColor.z;
	color3.a = (color3.r)*vColor.w;
#endif
	color4.a = (color4.r)*vColor.y;

	float4 oColor;
#ifdef WEATHER_HIGH
	oColor = vVertColor*((color0 + color1 + color2 + color3 + color4)*1.5)/5;   //실내 진입 블렌딩 계산추가
#else
	oColor = vVertColor*((color0 + color1+color4)*0.8)/3;     //저사양용
#endif

    oColor.a *= g_visibility;

	return oColor;
}

#ifdef _3DSMAX_
technique technique0 <
	string Script = "Pass=p0;";
>
{
	pass p0 
	{
		AlphaBlendEnable= true;
		ZEnable         = true;
		ZWriteEnable    = false;
		CullMode        = none;
		AlphaTestEnable = false;
		DestBlend 		= ONE;
		SrcBlend 		= SRCALPHA;
	   VertexShader = compile vs_2_0 mainVS();
	   PixelShader = compile ps_2_0 mainPS();
	}
}
#else
technique RenderScene_1_1
{
   pass Object
   {
		VertexShader = compile vs_2_0 mainVS();
		PixelShader = compile ps_2_0 mainPS();
   }
}
technique RenderScene_2_0
{
   pass Object
   {
		VertexShader = compile vs_2_0 mainVS();
		PixelShader = compile ps_2_0 mainPS();
   }
}
#endif
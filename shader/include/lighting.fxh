//g_lightDir (float4)              : object space local light direction
//g_lightColor (float4)            : light diffuse color

#ifndef __LIGHTING__
#define __LIGHTING__

float3	g_lightDir : Direction 
<  
	string UIName = "Light"; 
	string Object = "TargetLight";
	int refID = 0;
> = {0.577, 0.577, 0.577};

float4	g_lightColor : LIGHTCOLOR
<
	int LightRef = 0;
> = float4(1.0f, 1.0f, 1.0f, 1.0f);


// L : light direction
// N : face normal vector
float3 ComputeDirectionalLight(float3 N)
{
	return g_ambientColor.rgb + (g_lightColor * saturate(dot(N,g_lightDir)));
}

#endif
//g_lightDir (float4)              : object space local light direction
//g_lightColor (float4)            : light diffuse color
//g_localView (float3)             : object space local view origin

shared float3 g_fogColor : FogColor
<
> = float3(1.0f, 1.0f, 1.0f);

shared float2 g_fogParam : FogParam	// 1/(end-start), -start/(end-start), 1, 0
<
> = float2(1.0f,1.0f);
shared float3 g_addfogColor : AddFogColor
<
> = float3(1.0f, 1.0f, 1.0f);
shared float2 g_addfogParam: AddFogParam
<
> = float2(1.0f, 1.0f);

// N : normal vector
float ComputeLinearFog(const float depth)
{
	return saturate((g_fogParam.x * depth) + g_fogParam.y);
}
float ComputeAddFog(const float depth)
{
	return saturate((g_addfogParam.x * 0.001 * depth) + g_addfogParam.y);
}


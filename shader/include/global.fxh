/////////////////////////////////////////////////////////////////////////
// Global Variables

/////////////////////////////////////////////////////////////////////////
// engine constants:
//

//g_projMatrix (float4x4)          : projection matrix
//g_viewProjMatrix (float4x4)      : view projection matrix
//g_worldViewProjMatrix (float4x4) : world view projection matrix
//g_localView (float3)             : object space local view origin
//g_ambientColor (float4)          : light ambient color
//g_timeScroll (float)             : engine elapsed time


float4x4 g_worldViewProjMatrix : WORLDVIEWPROJ;

float4 g_ambientColor  
<
	string UIName = "Ambient";
> = float4( 0.47f, 0.47f, 0.47f, 1.0f );    // ambient


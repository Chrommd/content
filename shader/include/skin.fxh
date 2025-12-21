//g_lightDir (float4)              : object space local light direction
//g_lightColor (float4)            : light diffuse color

#ifndef __SKIN__
#define __SKIN__

#ifndef MATRIX_PALETTE_SIZE_DEFAULT
#define MATRIX_PALETTE_SIZE_DEFAULT 50
#endif

const int MATRIX_PALETTE_SIZE = MATRIX_PALETTE_SIZE_DEFAULT;

float4 g_boneLocalTM[MATRIX_PALETTE_SIZE_DEFAULT*3];
int g_numWeight = 1;

// define the inputs -- caller must fill this, usually right from the VB
struct VS_SKIN_INPUT
{
    float4      vPos;
    float4      vBlendWeights;
    float4      vBlendIndices;
    float3      vNor;
};

// return skinned position and normal
struct VS_SKIN_OUTPUT
{
    float4 vPos;
    float3 vNor;
};

float3	_m3x3(const float3 src0, const float4 src1, const float4 src2, const float4 src3)
{
	float3 dest;

	dest.x = dot(src0, src1);
	dest.y = dot(src0, src2);
	dest.z = dot(src0, src3);

	return dest;
}

float3	_m4x3(const float4 src0, const float4 src1, const float4 src2, const float4 src3)
{
	float3 dest;

	dest.x = dot(src0, src1);
	dest.y = dot(src0, src2);
	dest.z = dot(src0, src3);

	return dest;
}

float4	_m4x4(const float4 src0, const float4 src1, const float4 src2, const float4 src3, const float4 src4)
{
	float4 dest;

	dest.x = dot(src0, src1);
	dest.y = dot(src0, src2);
	dest.z = dot(src0, src3);
	dest.w = dot(src0, src4);

	return dest;
}

// call this function to skin VB position and normal
VS_SKIN_OUTPUT ComputeSkin( VS_SKIN_INPUT vInput, int iNumBones )
{
    VS_SKIN_OUTPUT vOutput = (VS_SKIN_OUTPUT) 0;
    
    float fWeight = 0.0f;
    float fLastWeight = 1.0f;
    float afBlendWeights[ 4 ] = (float[ 4 ]) vInput.vBlendWeights;
    float aiIndices[ 4 ] = (float[ 4 ]) vInput.vBlendIndices;

    float4 src1 = float4(0,0,0,0);
    float4 src2 = float4(0,0,0,0);
    float4 src3 = float4(0,0,0,0);
    
    for( int iBone = 0; (iBone < 3) && (iBone < iNumBones-1); ++ iBone )
    {
		fWeight = afBlendWeights[ iBone ];
		fLastWeight -= fWeight;
		
        src1 += ( fWeight * g_boneLocalTM[ aiIndices[ iBone ] + 0 ] );
        src2 += ( fWeight * g_boneLocalTM[ aiIndices[ iBone ] + 1 ] );
        src3 += ( fWeight * g_boneLocalTM[ aiIndices[ iBone ] + 2 ] );
    }

    src1 += ( fLastWeight * g_boneLocalTM[ aiIndices[ iNumBones-1 ] + 0 ] );
   	src2 += ( fLastWeight * g_boneLocalTM[ aiIndices[ iNumBones-1 ] + 1 ] );
    src3 += ( fLastWeight * g_boneLocalTM[ aiIndices[ iNumBones-1 ] + 2 ] );
   
    vOutput.vPos = float4(_m4x3( vInput.vPos, src1, src2, src3), vInput.vPos.w);
    vOutput.vNor = _m3x3( vInput.vNor, src1, src2, src3);

    return vOutput;
}
    
#endif

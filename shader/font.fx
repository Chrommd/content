sampler2D samp;
float4 PSMain(float2 tex: TEXCOORD0
	, in float4 vColor0 : COLOR0
	, in float4 vColor1 : COLOR1

) : COLOR
{
    float4 resultColor = 0;
    float2 TexelKernel[13] =
	{	   
		{ -6, 0 },
		{ -5, 0 },
		{ -4, 0 },
		{ -3, 0 },
		{ -2, 0 },
		{ -1, 0 },
		{  0, 0 },
		{  1, 0 },
		{  2, 0 },
		{  3, 0 },
		{  4, 0 },
		{  5, 0 },
		{  6, 0 },
	};

	const float BlurWeights[13] =
	{
		0.002216,
		0.008764,
		0.026995,
		0.064759,
		0.120985,
		0.176033,
		0.199471,
		0.176033,
		0.120985,
		0.064759,
		0.026995,
		0.008764,
		0.002216,
	};
      
    float4 color = float4(0, 0, 0, 0);
    for (int i = 0; i < 13; i++)
    {
        color +=  tex2D(samp, tex + TexelKernel[i].xy/10) * BlurWeights[i];
    }
        
    resultColor = color * 1.5f;
    return resultColor;
}
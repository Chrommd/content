sampler bumpSampler : register(s0);
sampler screenSampler : register(s1);
sampler alphaMaskSampler : register(s2);

VertexShader HeatHazeVS = asm
{
	vs.1.1

	dcl_position	v0
	dcl_color		v1
	dcl_texcoord0	v2
	
	def		c5, 1.9, 1.9, 0.0, 0.0
	def		c6, 0.02, 0.02, 0.02, 0.0

	dp4		r0.x, c0, v0
	dp4		r0.y, c1, v0
	dp4		r0.z, c2, v0
	dp4		r0.w, c3, v0
	mov		oPos, r0

	mov		oT0, v2					// heat haze alpha mask texture coordinates
	add		oT1, v2, c4.yz			// scroll bumpmap texture coordinates
	mov		r1, c4.yz
	mad		oT2, v2, c5.xy, r1.xy	// scale & scroll bumpmap texture coordinates 2
	mov		oT3, r0					// background texture coordinates (clip coordinates before divide by w)

	// scale deform magnitude
	//mul		r1, v1, r2.x
	//min		r1, r1, c6
	//mul		r1, r1, c4.x
	mul		oD0, v1, c4.xxxx
};

PixelShader HeatHazePS = asm
{
	ps.2.0

	dcl		t0				// heathaze alpha mask texture coordinates
	dcl		t1				// bump map texture coordinates
	dcl		t2				// bump map texture coordinates 2
	dcl		t3				// background texture coordinates (clip coordinates)
	dcl		v0				// diffuse color
	
	dcl_2d	s0				// bump map
	dcl_2d	s1				// background texture
	dcl_2d	s2				// heathaze alpha mask texture
	
	def		c0, 2.0, 2.0, 0.0, 0.0
	def		c1, -1.0, -1.0, 0.0, 0.0
	def		c2, 0.5, -0.5, 0.0, 0.0
	def		c3, 0.5, 0.5, 0.0, 0.0
	def		c4, 0.01, 0.01, 0.0, 0.0

	texld	r2, t0, s2		// alpha texture
	sub		r3, r2, c4
	texkill	r3				// kill the pixel by alpha mask 

	texld	r0, t1, s0		// bump map
	texld	r1, t2, s0
	mul		r0, r0, r1
	mov		r1, c1
	mad		r0, r0, c0, r1	// normalize to -1.0 ~ 1.0
	mul		r0, r0, v0		// scale by diffuse color
	mul		r0, r0, r2		// mask

	rcp		r1.x, t3.w
	mul		r1, t3, r1.xxxx	// perspective division
	mul		r1, r1, c2
	add		r1, r1, c3

	add		r0, r1, r0		// perturb texture coordinates
	texld	r0, r0, s1

	mov		oC0, r0
};

Technique HeatHaze
{
    Pass p0
    {    	
        VertexShader = (HeatHazeVS);       		
		PixelShader = (HeatHazePS);		
	}
}
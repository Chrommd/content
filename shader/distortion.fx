sampler bumpSampler : register(s0);
sampler screenSampler : register(s1);

VertexShader DistortionVS = asm
{
	vs.1.1

	dcl_position	v0
	dcl_color		v1
	dcl_texcoord0	v2

	dp4		r0.x, c0, v0
	dp4		r0.y, c1, v0
	dp4		r0.z, c2, v0
	dp4		r0.w, c3, v0
	mov		oPos, r0

	// bumpmap texture coordinates
	mov		oT0, v2

	// background texture coordinates (clip coordinates before divide by w)
	mov		oT1, r0

	// scale deform magnitude
	mul		oT2, v1, c4.xxxx
};

PixelShader DistortionPS = asm
{
    ps.2.0

	dcl		t0			// bump map texture coordinates
	dcl		t1			// background texture coordinates (clip coordinates)
	dcl		t2			// diffuse color

	dcl_2d	s0			// bump map
	dcl_2d	s1			// background texture
	
	def		c0, 2.0, 2.0, 0.0, 0.0
	def		c1, -1.0, -1.0, 0.0, 0.0
	def		c2, 0.5, -0.5, 0.0, 0.0
	def		c3, 0.5, 0.5, 0.0, 0.0
	def		c4, 0.0004, 0.0, 0.0, 0.0

	// bump map normalize to -1.0 ~ 1.0
	texld	r0, t0, s0
	mov		r1, c1
	mad		r0, r0, c0, r1

	dp3		r1.x, r0, r0
	sub		r2, r1.x, c4.x
	texkill	r2

	// scale by diffuse color
	mul		r0, r0, t2

	// perspective division
	rcp		r1.x, t1.w
	mul		r1, t1, r1.xxxx
	mul		r1, r1, c2
	add		r1, r1, c3

	// perturb texture coordinates
	add		r0, r1, r0
	texld	r0, r0, s1

	mov		oC0, r0
};

Technique Distortion
{
    Pass p0
    {       
		VertexShader = (DistortionVS);
        PixelShader = (DistortionPS);
	}
}
        
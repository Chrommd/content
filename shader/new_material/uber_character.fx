/*------------------------------------------------------------___-------------------------------------------------------
                                                             /   |                                                      
                                                            / /| |                                                      
                                                           / ___ |                                                      
                                            P R O J E C T /_/  |_| L I C E                                              
                                        Copyright (C) 2005-2007 NTREEV SOFT Inc.                                        
----------------------------------------------------------------------------------------------------------------------*/

#ifdef THIS_IS_CLIENT
  //! 반드시 사용해야 하는 애들
  #ifndef AMBIENT
  #define AMBIENT
  #endif
  
  #ifndef USING_MODULATE
  #define USING_MODULATE
  #endif

  #ifndef USING_DIFFUSE_TEX1
  #define USING_DIFFUSE_TEX1
  #endif
  
  #ifndef SKINING
  #define SKINING
  #endif
  
//  #ifndef TONEMAP
//  #define TONEMAP
//  #endif
  
  //! 삭제해야 하는 디파인들
  #ifdef USING_AO_TEX1
  #undef USING_AO_TEX1
  #endif

  #ifdef USING_AO_VERTEX
  #undef USING_AO_VERTEX
  #endif
  
//  #ifdef TONEMAP
//  #undef TONEMAP
//  #endif
  
//  #ifndef TONEMAP
//  #define TONEMAP
//  #endif

    #ifndef CHARACTER
    #define CHARACTER
    #endif
#else
  #ifndef THIS_IS_MAX
  #define THIS_IS_MAX
  #endif
  #ifndef USING_DIFFUSE_TEX1
  #define USING_DIFFUSE_TEX1
  #endif
  #ifndef USING_SPEC_TEX1
  #define USING_SPEC_TEX1
  #endif
  #ifndef USING_SSS_TEX1
  #define USING_SSS_TEX1
  #endif
  #ifndef USING_AMOLED_TEX1
  #define USING_AMOLED_TEX1
  #endif
  #include "uber_3dsmax.fx"
/*
  #ifndef LAMBERT
  #define LAMBERT
  #endif
  #ifndef SPECULAR
  #define SPECULAR
  #endif
  #ifndef RIM
  #define RIM
  #endif
  #ifndef BRUSH
  #define BRUSH
  #endif
  #ifndef SSS
  #define SSS
  #endif
  #ifndef AMOLED
  #define AMOLED
  #endif
*/
#endif

//#define OUTLINE

#include "uber_source.fx"

/*
//FX_parameter.Direct.g_direct.color.true
//FX_parameter.Inirect.g_indirect.color.true
*/

//FX_parameter.Diffuse0.c_diffTex0.bitmap.selectable
//FX_parameter.Diffuse0_Ch.c_diffTex0mapChannel.integer.true
/*
//FX_parameter.Diffuse1.c_diffTex1.bitmap.selectable
//FX_parameter.Diffuse2.c_diffTex2.bitmap.selectable
*/

//FX_parameter.Spec0.c_specTex0.bitmap.selectable
//FX_parameter.Spec0_Ch.c_specTex0mapChannel.integer.true
/*
//FX_parameter.Spec1.c_specTex1.bitmap.selectable
//FX_parameter.Spec2.c_specTex2.bitmap.selectable
*/

//FX_parameter.SelfIllum0.c_selfIlumTex0.bitmap.selectable
/*
//FX_parameter.SelfIllum1.c_selfIlumTex1.bitmap.selectable
//FX_parameter.SelfIllum2.c_selfIlumTex2.bitmap.selectable
*/

//FX_parameter.SubSurfaceScatter0.c_sssTex0.bitmap.selectable
/*
//FX_parameter.SubSurfaceScatter1.c_sssTex1.bitmap.selectable
//FX_parameter.SubSurfaceScatter2.c_sssTex2.bitmap.selectable
*/

/*
//FX_parameter.AO.c_aoTex1.bitmap.selectable
//FX_parameter.AO_Ch.c_aoTex1mapChannel.integer.true
*/

//FX_parameter.SpecColor.c_specColor.color.true
//FX_parameter.SpecLevel.c_specLevel.float.true
//FX_parameter.SpecGlossiness.c_specGloss.float.true

//FX_parameter.BrushColor.c_brushColor.color.true
//FX_parameter.BrushCenterPoint.c_brushCenter.float.true
//FX_parameter.BrushLevel.c_brushLevel.float.true
//FX_parameter.BrushGlossiness.c_brushGloss.float.true

//FX_parameter.RimLightColor.c_rimColor.color.true
//FX_parameter.RimLightDensity.c_rimDensity.float.true
//FX_parameter.RimLightWidth.c_rimWidth.float.true

//FX_parameter.SSSlevel.c_sssLevel.float.true
//FX_parameter.SSSwidth.c_sssWidth.float.true
//FX_parameter.SSScolor.c_sssColor.color.true

//FX_parameter.Bias.c_bias.float.true
//FX_parameter.AlphaTest.c_alphaTest.bool.true
//FX_parameter.AlphaRef.c_alphaRef.integer.true
//FX_parameter.AlphaRef.c_alphaRef.bool.true
//FX_parameter.BackfaceCull.c_cullMode.integer.true

//FX_parameter.EnableLambert.c_enableLambert.bool.true
//FX_parameter.EnableSpecular.c_enableSpec.bool.true
//FX_parameter.EnableRim.c_enableRim.bool.true
//FX_parameter.EnableSSS.c_enableSSS.bool.true
//FX_parameter.EnableBrush.c_enableBrush.bool.true
//FX_parameter.EnableSelfIllum.c_enableAmoled.bool.true
/*
//FX_parameter.EnableAO.c_enableAO.bool.true
//FX_parameter.UseAOTexture.c_enableAOTex.bool.true
*/

/*----------------------------------------------------------------------------------------------------------------------
                                               P R O J E C T - A L I C E                                                
----------------------------------------------------------------------------------------------------------------------*/
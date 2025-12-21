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

  #ifndef USING_DIFFUSE_TEX1
  #define USING_DIFFUSE_TEX1
  #endif
  
  #ifndef SKINING
  #define SKINING
  #endif
  
  #ifndef WASH
  #define WASH
  #endif
  
  //! 삭제해야 하는 디파인들
  #ifdef USING_AO_TEX1
  #undef USING_AO_TEX1
  #endif

  #ifdef USING_AO_VERTEX
  #undef USING_AO_VERTEX
  #endif
#else
  #ifndef THIS_IS_MAX
  #define THIS_IS_MAX
  #endif
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
#endif

#include "uber_source.fx"

/*----------------------------------------------------------------------------------------------------------------------
                                               P R O J E C T - A L I C E                                                
----------------------------------------------------------------------------------------------------------------------*/
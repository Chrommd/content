/*------------------------------------------------------------___-------------------------------------------------------
                                                             /   |                                                      
                                                            / /| |                                                      
                                                           / ___ |                                                      
                                            P R O J E C T /_/  |_| L I C E                                              
                                        Copyright (C) 2005-2007 NTREEV SOFT Inc.                                        
----------------------------------------------------------------------------------------------------------------------*/

#ifdef THIS_IS_CLIENT
  #ifndef AMBIENT
  #define AMBIENT
  #endif

  #ifndef USING_DIFFUSE_TEX1
  #define USING_DIFFUSE_TEX1
  #endif
  
  #ifndef INSTANCING
  #define INSTANCING
  #endif
  
  #ifndef _FOG_
  #define _FOG_
  #endif
  
  #ifdef SSS
  #undef SSS
  #endif
  
  #ifdef BRUSH
  #undef BRUSH
  #endif
  
  #ifdef SKINING
  #undef SKINING
  #endif
  
  #ifndef TONEMAP
  #define TONEMAP
  #endif
  //! instancing is available over shader 3
  #ifdef VS_VER
  #undef VS_VER
  #endif
  #define VS_VER vs_3_0
  
  #ifdef PS_VER
  #undef PS_VER
  #endif
  #define PS_VER ps_3_0
  
#endif

#include "uber_source.fx"
/*----------------------------------------------------------------------------------------------------------------------
                                               P R O J E C T - A L I C E                                                
----------------------------------------------------------------------------------------------------------------------*/
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
  
  #ifdef INSTANCING
  #undef INSTANCING
  #endif
  
  #ifndef FAKE_INSTANCING
  #define FAKE_INSTANCING
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
  
#endif

#include "uber_source.fx"
/*----------------------------------------------------------------------------------------------------------------------
                                               P R O J E C T - A L I C E                                                
----------------------------------------------------------------------------------------------------------------------*/
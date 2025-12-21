/*------------------------------------------------------------___-------------------------------------------------------
                                                             /   |                                                      
                                                            / /| |                                                      
                                                           / ___ |                                                      
                                            P R O J E C T /_/  |_| L I C E                                              
                                        Copyright (C) 2005-2007 NTREEV SOFT Inc.                                        
----------------------------------------------------------------------------------------------------------------------*/

#ifdef THIS_IS_CLIENT
  #ifndef SKYMODEL
  #define SKYMODEL
  #endif

  //! 반드시 사용해야 하는 애들
  #ifndef USING_DIFFUSE_TEX1
  #define USING_DIFFUSE_TEX1
  #endif
  
  #ifdef SKINING
  #undef SKINING
  #endif
  
  #ifdef SKINING
  #undef SKINING
  #endif
  
  #ifdef RIM
  #undef RIM
  #endif
  
  #ifdef LAMBERT
  #undef LAMBERT
  #endif
  
  #ifdef SPECULAR
  #undef SPECULAR
  #endif
  
  #ifdef SSS
  #undef SSS
  #endif
  
  #ifdef AMOLED
  #undef AMOLED
  #endif
  
  #ifdef USING_DIRECT
  #undef USING_DIRECT
  #endif
  
  #ifdef USING_INDIRECT
  #undef USING_INDIRECT
  #endif
  
  #ifdef _FOG_
  #undef _FOG_
  #endif
  
  #ifdef ADDFOG
  #undef ADDFOG
  #endif
  
  #ifdef USING_MODULATE
  #undef USING_MODULATE
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
#endif

#include "uber_source.fx"

/*----------------------------------------------------------------------------------------------------------------------
                                               P R O J E C T - A L I C E                                                
----------------------------------------------------------------------------------------------------------------------*/
/*
//weather_snow.fx
// Creation Date: 18 November 2011
// Last Update: 23 November 2011
// Version: 0.2
// Description: 0.1 일반 snow 효과에 사용되는 shader
//              0.2 shader 관리를 위해 uber shader 타입으로 변경
*/

#ifdef THIS_IS_CLIENT
    #ifndef BASIC
    #define BASIC
    #endif
    #ifdef COLLISION
    #undef COLLISION
    #endif
#else
    #ifndef THIS_IS_MAX
    #define THIS_IS_MAX
    #endif
    #ifndef BASIC
    #define BASIC
    #endif
#endif

#include "weather_snow_source.fx"
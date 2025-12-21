/*
//weather_snowCollision.fx
// Creation Date: 18 November 2011
// Last Update: 23 November 2011
// Version: 0.2
// Description: 0.1 충돌시 사용되는 shader
//              0.2 shader 관리를 위해 uber shader 타입으로 변경
*/

#ifdef THIS_IS_CLIENT
    #ifndef COLLISION
    #define COLLISION
    #endif
    #ifdef BASIC
    #undef BASIC
    #endif
#else
    #ifndef THIS_IS_MAX
    #define THIS_IS_MAX
    #endif
    #ifndef COLLISION
    #define COLLISION
    #endif
#endif

#include "weather_snow_source.fx"
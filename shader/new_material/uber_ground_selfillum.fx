#ifdef THIS_IS_CLIENT
    #ifdef SPECULAR
    #define AMOLED                //!#modify byMars  적용필요
    #endif
#else
    #ifndef THIS_IS_MAX
    #define THIS_IS_MAX
    #endif
    #define SPECULAR
    #ifdef SPECULAR
    #define AMOLED              //!#modify byMars  적용필요
    #endif
#endif

#include "uber_ground_source.fx"


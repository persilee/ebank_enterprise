#pragma once
#include "./../version.h"

//version 多层封装后，避免库冲突, RPN_DATE在version.h中定义

#ifdef RPNNameSpace
#undef RPNNameSpace
#endif

#define RPN_VERSION_(x) rpdnet##x
#define RPN_VERSION(x)  RPN_VERSION_(x)
#ifdef RPN_DATE
#define RPNNameSpace RPN_VERSION(RPN_DATE)
#else
#define RPNNameSpace RPN_VERSION()
#endif



#if defined(__APPLE__)    // apple

#if TARGET_OS_IPHONE        // iphone not simulator
#if defined(TARGET_IPHONE_SIMULATOR)
#if TARGET_IPHONE_SIMULATOR == 0
#define ENABLE_NEON
#define ENABLE_GEMMLOWP
#endif //#if TARGET_IPHONE_SIMULATOR == 0
#elif TARGET_OS_MAC         // mac
#endif
#endif


#endif


#define LOG_LEVEL 2
#define LOG_FUNCTION (LOG_LEVEL >= 3 ? __PRETTY_FUNCTION__ : __FUNCTION__)

//Log
#if defined(__ANDROID__)
#include <android/log.h>

#if LOG_LEVEL == 0
#define LOGI(fmt, ...) __android_log_print(ANDROID_LOG_INFO, "rapidnet", ("%s [Line %d] " fmt), LOG_FUNCTION, __LINE__, ##__VA_ARGS__)
#define LOGD(fmt, ...) __android_log_print(ANDROID_LOG_DEBUG, "rapidnet", ("%s [Line %d] " fmt), LOG_FUNCTION, __LINE__, ##__VA_ARGS__)
#define LOGE(fmt, ...) __android_log_print(ANDROID_LOG_ERROR, "rapidnet", ("%s [Line %d] " fmt), LOG_FUNCTION, __LINE__, ##__VA_ARGS__)
#elif LOG_LEVEL == 1
#define LOGI(fmt, ...)
#define LOGD(fmt, ...) __android_log_print(ANDROID_LOG_DEBUG, "rapidnet", ("%s [Line %d] " fmt), LOG_FUNCTION, __LINE__, ##__VA_ARGS__)
#define LOGE(fmt, ...) __android_log_print(ANDROID_LOG_ERROR, "rapidnet", ("%s [Line %d] " fmt), LOG_FUNCTION, __LINE__, ##__VA_ARGS__)
#elif LOG_LEVEL >= 2
#define LOGI(fmt, ...)
#define LOGD(fmt, ...)
#define LOGE(fmt, ...) __android_log_print(ANDROID_LOG_ERROR, "rapidnet", ("%s [Line %d] " fmt), LOG_FUNCTION, __LINE__, ##__VA_ARGS__)
#endif

#else

#if LOG_LEVEL == 0
#define LOGI(fmt, ...) printf(("%s [Line %d] " fmt), LOG_FUNCTION, __LINE__, ##__VA_ARGS__)
#define LOGD(fmt, ...) printf(("%s [Line %d] " fmt), LOG_FUNCTION, __LINE__, ##__VA_ARGS__)
#define LOGE(fmt, ...) printf(("%s [Line %d] " fmt), LOG_FUNCTION, __LINE__, ##__VA_ARGS__)
#elif LOG_LEVEL == 1
#define LOGI(fmt, ...)
#define LOGD(fmt, ...) printf(("%s [Line %d] " fmt), LOG_FUNCTION, __LINE__, ##__VA_ARGS__)
#define LOGE(fmt, ...) printf(("%s [Line %d] " fmt), LOG_FUNCTION, __LINE__, ##__VA_ARGS__)
#elif LOG_LEVEL >= 2
#define LOGI(fmt, ...)
#define LOGD(fmt, ...)
#define LOGE(fmt, ...) printf(("%s [Line %d] " fmt), LOG_FUNCTION, __LINE__, ##__VA_ARGS__)
#endif

#endif


namespace RPNNameSpace{
    //USE_GPU_OR_CPU means Prefer GPU than CPU and this is the default configuration as in the constructor
    //USE_CPU means only support CPU
    //USE_GPU means only support GPU
    enum DeviceType{INVALID_DEVICE=0, USE_CPU, USE_GPU, USE_CPU_NNPACK_MULTI_THREAD, USE_CPU_NEON};
}

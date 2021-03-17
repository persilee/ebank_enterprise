#ifndef _RPD_ERROR_20160517_H_
#define _RPD_ERROR_20160517_H_
#include "platforms/platforms.h"

namespace RPNNameSpace
{
static const int RPD_OK = 0x0;

/* param errcode*/
static const int RPD_PARAM_ERR = 0x1000;
static const int RPDERR_IVALID_NETCFG = 0x1002;
static const int RPDERR_IVALID_LAYERCFG = 0x1003;
static const int RPDERR_NULL_PARAM = 0x1004;
static const int RPDERR_IVALID_GROUP = 0x1005;
static const int RPDERR_IVALID_AXIS = 0x1006;

/* network errcode*/
static const int RPD_NET_ERR = 0x2000;
static const int RPDERR_UNSUPPORT_NET = 0x2001;

/* layer errcode*/
static const int RPD_LAYER_ERR = 0x3000;
static const int RPDERR_UNKNOWN_LAYER = 0x3001;
static const int RPDERR_CREATE_LAYER = 0x3002;
static const int RPDERR_INIT_LAYER = 0x3003;
static const int RPDERR_INVALID_DATA = 0x3004;
static const int RPDERR_ELT_UNSUP_OP = 0x3005;
static const int RPDERR_FUSED_LAYER_INVALID_COUNT = 0x3006;
static const int RPDERR_FUSED_LAYER_INVALID_LAYER = 0x3007;
    
/* model errcode*/
static const int RPD_MODEL_ERR = 0x4000;
static const int RPDERR_INVALID_MODEL = 0x4001;
static const int RPDERR_FIND_MODEL = 0x4002;

/* instance errcode*/
static const int RPD_INST_ERR = 0x5000;
static const int RPDERR_MAXINST_COUNT = 0x5001;
static const int RPDERR_ALLOC_INSTANCE = 0x5002;
static const int RPDERR_INVALID_INSTANCE = 0x5003;

/* common errcode*/
static const int RPD_COMMON_ERROR = 0x6000;
static const int RPDERR_OUTOFMEMORY = 0x6001;
static const int RPDERR_INVALID_INPUT = 0x6002;
static const int RPDERR_FIND_RESOURCE = 0x6003;
static const int RPDERR_NO_RESULT = 0x6004;
static const int RPDERR_LOAD_MODEL = 0x6005;
static const int RPDERR_FUNCTION_INVALID_IMPLEMENT = 0x6006;

}


#endif /* _RPD_ERROR_20160517_H_ */

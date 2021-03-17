#ifndef __CLOUDROOMVIDEO_SDK_ERRDEF_H__
#define __CLOUDROOMVIDEO_SDK_ERRDEF_H__

#ifdef __cplusplus
#define CRVSDK_EXPORT       extern "C" __attribute__((visibility ("default")))
#else
#define CRVSDK_EXPORT       extern __attribute__((visibility ("default")))
#endif
typedef enum
{
    CRVIDEOSDK_NOERR = 0,

    //基础错误
    CRVIDEOSDK_UNKNOWERR,                 //未知错误
    CRVIDEOSDK_OUTOF_MEM,                 //内存不足
    CRVIDEOSDK_INNER_ERR,                 //sdk内部错误
    CRVIDEOSDK_MISMATCHCLIENTVER,         //不支持的sdk版本
    CRVIDEOSDK_MEETPARAM_ERR,             //参数错误
    CRVIDEOSDK_ERR_DATA,                  //无效数据
    CRVIDEOSDK_ANCTPSWD_ERR,              //帐号密码不正确
    CRVIDEOSDK_SERVER_EXCEPTION,          //服务异常
    CRVIDEOSDK_LOGINSTATE_ERROR,          //登录状态错误
    CRVIDEOSDK_USER_BEEN_KICKOUT,         //用户被踢掉
    CRVIDEOSDK_NOT_INIT,                  //sdk未初始化
    CRVIDEOSDK_NOT_LOGIN,                 //还没有登录
    CRVIDEOSDK_BASE64_COV_ERR,            //base64转换失败
    CRVIDEOSDK_API_NO_PERMISSION,          //没有api访问权限

    CRVIDEOSDK_CUSTOMAUTH_NOINFO,        //启用了第三方鉴权，但没有携带鉴权信息
    CRVIDEOSDK_CUSTOMAUTH_NOTSUPPORT,    //没有启用第三方鉴权，但携带了鉴权信息
    CRVIDEOSDK_CUSTOMAUTH_EXCEPTION,    //访问第三方鉴权服务异常
    CRVIDEOSDK_CUSTOMAUTH_FAILED,        //第三方鉴权不通过

    //Token鉴权失败
    CRVIDEOSDK_TOKEN_TIMEOUT,            //token已过期
    CRVIDEOSDK_TOKEN_AUTHINFOERR,        //鉴权信息错误
    CRVIDEOSDK_TOKEN_APPIDNOTEXIST,        //appid不存在
    CRVIDEOSDK_TOKEN_AUTH_FAILED,        //鉴权失败
    CRVIDEOSDK_TOKEN_NOTTOKENTYPE,        //非token鉴权方式

    //网络
    CRVIDEOSDK_NETWORK_INITFAILED=200,    //网络初始化失败
    CRVIDEOSDK_NO_SERVERINFO,             //没有服务器信息
    CRVIDEOSDK_NOSERVER_RSP,              //服务器没有响应
    CRVIDEOSDK_CREATE_CONN_FAILED,        //创建连接失败
    CRVIDEOSDK_SOCKETEXCEPTION,           //socket异常
    CRVIDEOSDK_SOCKETTIMEOUT,             //网络超时
    CRVIDEOSDK_FORCEDCLOSECONNECTION,     //连接被关闭
    CRVIDEOSDK_CONNECTIONLOST,            //连接丢失
    CRVIDEOSDK_VOICEENG_INITFAILED,          //语音引擎初始化失败
    CRVIDEOSDK_SSL_ERR,                      //ssl错误

    //队列相关错误定义
    CRVIDEOSDK_QUE_ID_INVALID=400,        //队列ID错误
    CRVIDEOSDK_QUE_NOUSER,                //没有用户在排队
    CRVIDEOSDK_QUE_USER_CANCELLED,        //排队用户已取消
    CRVIDEOSDK_QUE_SERVICE_NOT_START,
    CRVIDEOSDK_ALREADY_OTHERQUE,          //已在其它队列排队(客户只能在一个队列排队)

    //呼叫
    CRVIDEOSDK_INVALID_CALLID=600,        //无效的呼叫ID
    CRVIDEOSDK_ERR_CALL_EXIST,            //已在呼叫中
    CRVIDEOSDK_ERR_BUSY,                  //对方忙
    CRVIDEOSDK_ERR_OFFLINE,               //对方不在线
    CRVIDEOSDK_ERR_NOANSWER,              //对方无应答
    CRVIDEOSDK_ERR_USER_NOT_FOUND,        //用户不存在
    CRVIDEOSDK_ERR_REFUSE,                //对方拒接

    //会话业务错误
    CRVIDEOSDK_MEETNOTEXIST=800,          //会议不存在或已结束
    CRVIDEOSDK_AUTHERROR,                 //会议密码不正确
    CRVIDEOSDK_MEMBEROVERFLOWERROR,       //会议终端数量已满（购买的license不够)
    CRVIDEOSDK_RESOURCEALLOCATEERROR,     //分配会议资源失败
    CRVIDEOSDK_MEETROOMLOCKED,            //会议已加锁
    CRVIDEOSDK_BALANCELESSERROR,          //余额不足
    CRVIDEOSDK_SEVICE_NOTENABLED,         //业务权限未开启
    CRVIDEOSDK_ALREADYLOGIN,              //不能再次登录
    CRVIDEOSDK_MIC_NORIGHT,               //没有mic权限
    CRVIDEOSDK_MIC_BEING_USED,            //mic已被使用
    CRVIDEOSDK_MIC_UNKNOWERR,             //mic未知错误
    CRVIDEOSDK_SPK_NORIGHT,               //没有扬声器权限
    CRVIDEOSDK_SPK_BEING_USED,            //扬声器已被使用
    CRVIDEOSDK_SPK_UNKNOWERR,             //扬声器未知错误
    CRVIDEOSDK_PIC_ISNULL,                  //图像为空

    //录制错误
    CRVIDEOSDK_CATCH_SCREEN_ERR = 900,        //抓屏失败
    CRVIDEOSDK_RECORD_MAX,                    //单次录制达到最大时长(8h)
    CRVIDEOSDK_RECORD_NO_DISK,                //磁盘空间不够
    CRVIDEOSDK_RECORD_SIZE_ERR,                //录制尺寸超出了允许值
    CRVIDEOSDK_CFG_RESTRICTED,                //录制超出限制
    CRVIDEOSDK_FILE_ERR,                    //录制文件操作出错
    CRVIDEOSDK_RECORDSTARTED,                //录制已开启
    CRVIDEOSDK_NOMORE_MCU,                    //录制服务器资源不足

    //IM
    CRVIDEOSDK_SENDFAIL = 1000,                //发送失败
    CRVIDEOSDK_CONTAIN_SENSITIVEWORDS,        //有敏感词语

    //透明通道
    CRVIDEOSDK_SENDCMD_LARGE = 1100,        //发送信令数据过大
    CRVIDEOSDK_SENDBUFFER_LARGE ,            //发送数据过大
    CRVIDEOSDK_SENDDATA_TARGETINVALID,        //目标用户不存在
    CRVIDEOSDK_SENDFILE_FILEINERROR,        //文件错误
    CRVIDEOSDK_TRANSID_INVALID,                //无效的发送id

    //录制文件管理
    CRVIDEOSDK_RECORDFILE_STATE_ERR = 1200,    //状态错误不可上传/取消上传
    CRVIDEOSDK_RECORDFILE_NOT_EXIST,        //录制文件不存在
    CRVIDEOSDK_RECORDFILE_UPLOAD_FAILED,    //上传失败，失败原因参考日志
    CRVIDEOSDK_RECORDFILE_DEL_FAILED,        //移除本地文件失败

    //网络摄像头
    CRVIDEOSDK_IPCAM_URLERR = 1300,            //ipcam url不正确
    CRVIDEOSDK_IPCAM_ALREADYEXIST,            //ipcam已存在
    CRVIDEOSDK_IPCAM_TOOMANYCAM,            //添加太多ip cam

    //文件相关错误
    CRVIDEOSDK_FILE_NOT_EXIST = 1400,        //文件不存在
    CRVIDEOSDK_FILE_READ_ERR,                //文件读失败
    CRVIDEOSDK_FILE_WRITE_ERR,                //文件写失败
    CRVIDEOSDK_FILE_ALREADY_EXIST,            //目标文件已存在
    CRVIDEOSDK_FILE_OPERATOR_ERR,            //文件操作失败

    //网盘错误
    CRVIDEOSDK_NETDISK_NOT_EXIST = 1500,    //网盘不存在
    CRVIDEOSDK_NETDISK_PERMISSIONDENIED,    //没有网盘权限
    CRVIDEOSDK_NETDISK_INVALIDFILENAME,        //不合法文件名
    CRVIDEOSDK_NETDISK_FILEALREADYEXISTS,    //文件已存在
    CRVIDEOSDK_NETDISK_FILEORDIRECTORYNOTEXISTS, //文件或目录不存在
    CRVIDEOSDK_NETDISK_FILENOTTRANSFORM,    //文件没有转换
    CRVIDEOSDK_NETDISK_TRANSFORMFAILED,        //文件转换失败
    CRVIDEOSDK_NETDISK_NOSPACE,                //空间不足

    
    //web js定义， 2000~3000

} CRVIDEOSDK_ERR_DEF;

/* mouse events */
#define NX_LMOUSEDOWN        1    /* left mouse-down event */
#define NX_LMOUSEUP        2    /* left mouse-up event */
#define NX_RMOUSEDOWN        3    /* right mouse-down event */
#define NX_RMOUSEUP        4    /* right mouse-up event */
#define NX_MOUSEMOVED        5    /* mouse-moved event */
#define NX_LMOUSEDRAGGED    6    /* left mouse-dragged event */
#define NX_RMOUSEDRAGGED    7    /* right mouse-dragged event */
#define NX_MOUSEENTERED        8    /* mouse-entered event */
#define NX_MOUSEEXITED        9    /* mouse-exited event */
/* other mouse events
 *
 * event.data.mouse.buttonNumber should contain the
 * button number (2-31) changing state.
 */
#define NX_OMOUSEDOWN        25    /* other mouse-down event */
#define NX_OMOUSEUP        26    /* other mouse-up event */
#define NX_OMOUSEDRAGGED    27    /* other mouse-dragged event */
/* Scroll wheel events */
#define NX_SCROLLWHEELMOVED    22

#define MOUSEEVENTF_LEFTUP         NX_LMOUSEUP
#define MOUSEEVENTF_LEFTDOWN       NX_LMOUSEDOWN
#define MOUSEEVENTF_MIDDLEUP       NX_OMOUSEUP
#define MOUSEEVENTF_MIDDLEDOWN     NX_OMOUSEDOWN
#define MOUSEEVENTF_RIGHTUP        NX_RMOUSEUP
#define MOUSEEVENTF_RIGHTDOWN      NX_RMOUSEDOWN
#define MOUSEEVENTF_XUP            NX_OMOUSEUP
#define MOUSEEVENTF_XDOWN          NX_OMOUSEDOWN
#define MOUSEEVENTF_WHEEL          NX_SCROLLWHEELMOVED
#define MOUSEEVENTF_MOVE           NX_MOUSEMOVED



#endif

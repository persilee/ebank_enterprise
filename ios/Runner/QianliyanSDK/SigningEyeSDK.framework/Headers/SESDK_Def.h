//
//  SESDK_Def.h
//  SigningEyeSDK
//
//  Created by 大锅 on 2020/1/10.
//  Copyright © 2020 大锅. All rights reserved.
//

#ifndef SESDK_Def_h
#define SESDK_Def_h

typedef enum
{
    SEVIDEOSDK_NOERR = 0,
        
    //基础错误
    SEVIDEOSDK_UNKNOWERR,                 //未知错误
    SEVIDEOSDK_OUTOF_MEM,                 //内存不足
    SEVIDEOSDK_INNER_ERR,                 //sdk内部错误
    SEVIDEOSDK_MISMATCHCLIENTVER,         //不支持的sdk版本
    SEVIDEOSDK_MEETPARAM_ERR,             //参数错误
    SEVIDEOSDK_ERR_DATA,                  //无效数据
    SEVIDEOSDK_ANCTPSWD_ERR,              //帐号密码不正确
    SEVIDEOSDK_SERVER_EXCEPTION,          //服务异常
    SEVIDEOSDK_LOGINSTATE_ERROR,          //登录状态错误
    SEVIDEOSDK_USER_BEEN_KICKOUT,         //用户被踢掉
    SEVIDEOSDK_NOT_INIT,                  //sdk未初始化
    SEVIDEOSDK_NOT_LOGIN,                 //还没有登录
    SEVIDEOSDK_BASE64_COV_ERR,            //base64转换失败
    SEVIDEOSDK_CUSTOMAUTH_NOINFO,         //启用了第三方鉴权，但没有携带鉴权信息
    SEVIDEOSDK_CUSTOMAUTH_NOTSUPPORT,     //没有启用第三方鉴权，但携带了鉴权信息
    SEVIDEOSDK_CUSTOMAUTH_EXCEPTION,      //访问第三方鉴权服务异常
    SEVIDEOSDK_CUSTOMAUTH_FAILED,        //第三方鉴权不通过
    //Token鉴权失败
    SEVIDEOSDK_KICKOUT_INVALID_TOKEN,            //令牌失效被踢

    SEVIDEOSDK_TOKEN_AUTHINFOERR,        //鉴权信息错误
    SEVIDEOSDK_TOKEN_SECRETERR,            //用户秘钥信息错误
    SEVIDEOSDK_TOKEN_AUTHCHECKERR,        //鉴权校验失败
    SEVIDEOSDK_TOKEN_AUTHERR,            //鉴权异常
    SEVIDEOSDK_TOKEN_AUTHINFOTIMEOUT,    //鉴权信息已过期
    SEVIDEOSDK_TOKEN_APPIDNOTSAME,        //鉴权appid不一致

    SEVIDEOSDK_TOKEN_AUTH_FAILED,
    SEVIDEOSDK_TOKEN_TIMEOUT,
    SEVIDEOSDK_TOKEN_APPIDNOTEXIST,
    SEVIDEOSDK_TOKEN_NOTTOKENTYPE,

    //网络
    SEVIDEOSDK_NETWORK_INITFAILED=200,    //网络初始化失败
    SEVIDEOSDK_NO_SERVERINFO,             //没有服务器信息
    SEVIDEOSDK_NOSERVER_RSP,              //服务器没有响应
    SEVIDEOSDK_CREATE_CONN_FAILED,        //创建连接失败
    SEVIDEOSDK_SOCKETEXCEPTION,           //socket异常
    SEVIDEOSDK_SOCKETTIMEOUT,             //网络超时
    SEVIDEOSDK_FORCEDCLOSECONNECTION,     //连接被关闭
    SEVIDEOSDK_CONNECTIONLOST,            //连接丢失
    SEVIDEOSDK_VOICEENG_INITFAILED,          //语音引擎初始化失败
    SEVIDEOSDK_SSL_ERR,

    //队列相关错误定义
    SEVIDEOSDK_QUE_ID_INVALID=400,        //队列ID错误
    SEVIDEOSDK_QUE_NOUSER,                //没有用户在排队
    SEVIDEOSDK_QUE_USER_CANCELLED,        //排队用户已取消
    SEVIDEOSDK_QUE_SERVICE_NOT_START,
    SEVIDEOSDK_ALREADY_OTHERQUE,          //已在其它队列排队(客户只能在一个队列排队)

    //呼叫
    SEVIDEOSDK_INVALID_CALLID=600,        //无效的呼叫ID
    SEVIDEOSDK_ERR_CALL_EXIST,            //已在呼叫中
    SEVIDEOSDK_ERR_BUSY,                  //对方忙
    SEVIDEOSDK_ERR_OFFLINE,               //对方不在线
    SEVIDEOSDK_ERR_NOANSWER,              //对方无应答
    SEVIDEOSDK_ERR_USER_NOT_FOUND,        //用户不存在
    SEVIDEOSDK_ERR_REFUSE,                //对方拒接

    //会话业务错误
    SEVIDEOSDK_MEETNOTEXIST=800,          //会议不存在或已结束
    SEVIDEOSDK_AUTHERROR,                 //会议密码不正确
    SEVIDEOSDK_MEMBEROVERFLOWERROR,       //会议终端数量已满（购买的license不够)
    SEVIDEOSDK_RESOURCEALLOCATEERROR,     //分配会议资源失败
    SEVIDEOSDK_MEETROOMLOCKED,            //会议已加锁
    SEVIDEOSDK_BALANCELESSERROR,          //余额不足
    SEVIDEOSDK_SEVICE_NOTENABLED,         //业务权限未开启
    SEVIDEOSDK_ALREADYLOGIN,              //不能再次登录
    SEVIDEOSDK_MIC_NORIGHT,               //没有mic权限
    SEVIDEOSDK_MIC_BEING_USED,            //mic已被使用
    SEVIDEOSDK_MIC_UNKNOWERR,             //mic未知错误
    SEVIDEOSDK_SPK_NORIGHT,               //没有扬声器权限
    SEVIDEOSDK_SPK_BEING_USED,            //扬声器已被使用
    SEVIDEOSDK_SPK_UNKNOWERR,             //扬声器未知错误

    //录制错误
    SEVIDEOSDK_CATCH_SCREEN_ERR = 900,        //抓屏失败
    SEVIDEOSDK_RECORD_MAX,                    //单次录制达到最大时长(8h)
    SEVIDEOSDK_RECORD_NO_DISK,                //磁盘空间不够
    SEVIDEOSDK_RECORD_SIZE_ERR,                //录制尺寸超出了允许值
    SEVIDEOSDK_CFG_RESTRICTED,                //录制超出限制
    SEVIDEOSDK_FILE_ERR,                    //录制文件操作出错
    SEVIDEOSDK_RECORDSTARTED,

    //IM
    SEVIDEOSDK_SENDFAIL = 1000,                //发送失败
    SEVIDEOSDK_CONTAIN_SENSITIVEWORDS,        //有敏感词语

    //透明通道
    SEVIDEOSDK_SENDCMD_LARGE = 1100,        //发送信令数据过大
    SEVIDEOSDK_SENDBUFFER_LARGE ,            //发送数据过大
    SEVIDEOSDK_SENDDATA_TARGETINVALID,        //目标用户不存在
    SEVIDEOSDK_SENDFILE_FILEINERROR,        //文件错误
    SEVIDEOSDK_TRANSID_INVALID,                //无效的发送id

    //录制文件管理
    SEVIDEOSDK_RECORDFILE_STATE_ERR = 1200,    //状态错误不可上传/取消上传
    SEVIDEOSDK_RECORDFILE_NOT_EXIST,        //录制文件不存在
    SEVIDEOSDK_RECORDFILE_UPLOAD_FAILED,    //上传失败，失败原因参考日志
    SEVIDEOSDK_RECORDFILE_DEL_FAILED,        //移除本地文件失败

    //网络摄像头
    SEVIDEOSDK_IPCAM_URLERR = 1300,            //ipcam url不正确
    SEVIDEOSDK_IPCAM_ALREADYEXIST,            //ipcam已存在
    SEVIDEOSDK_IPCAM_TOOMANYCAM,            //添加太多ip cam

    //文件相关错误
    SEVIDEOSDK_FILE_NOT_EXIST = 1400,        //文件不存在
    SEVIDEOSDK_FILE_READ_ERR,                //文件读失败
    SEVIDEOSDK_FILE_WRITE_ERR,                //文件写失败
    SEVIDEOSDK_FILE_OPERATOR_ERR,
    SEVIDEOSDK_FILE_ALREADY_EXIST,

    //网盘错误
    SEVIDEOSDK_NETDISK_NOT_EXIST = 1500,    //网盘不存在
    SEVIDEOSDK_NETDISK_PERMISSIONDENIED,    //没有网盘权限
    SEVIDEOSDK_NETDISK_INVALIDFILENAME,        //不合法文件名
    SEVIDEOSDK_NETDISK_FILEALREADYEXISTS,    //文件已存在
    SEVIDEOSDK_NETDISK_FILEORDIRECTORYNOTEXISTS, //文件或目录不存在
    SEVIDEOSDK_NETDISK_FILENOTTRANSFORM,    //文件没有转换
    SEVIDEOSDK_NETDISK_TRANSFORMFAILED,        //文件转换失败
    SEVIDEOSDK_NETDISK_NOSPACE,                //空间不足
    
    
    SEVIDEOSDK_PARAM_ERR = 1600,             //参数错误
    SEVIDEOSDK_FACEVERDATA_ERR,             //人脸比对数据错误
    SEVIDEOSDK_NETWORK_ERR,                 //网络错误
    SEVIDEOSDK_FILENOTEXIST,                 //上传文件不存在
    SEVIDEOSDK_QUEUEID_ERR,                     //队列ID不存在
    SEVIDEOSDK_NOAUTOSIGN,                      //后台没有开通自助面签的功能
    SEVIDEOSDK_NOREMOTESIGN,                       //后台没有开通远程面签的功能
    SEVIDEOSDK_GETBALANCE_ERROR,                       //余额不足
    SEVIDEOSDK_UPLOAD_ERR,                  //自助录像上传失败
    

} SEVIDEOSDK_ERR_DEF;


/**
 面签的方式
 */
typedef NS_ENUM(NSInteger, SEInterviewType){
    SEInterviewTypeRemote = 1 << 0,     //远程面签
    SEInterviewTypeAuto = 1 << 1,       //自助面签
    SEInterviewTypeBoth = 1 << 2,        //既有远程面签，又有自助面签
    SEInterviewTypeCertificate = 2 << 3        //证件识别

};

/**
 人脸识别结果
 */
typedef NS_ENUM(NSInteger, SEFaceVerifyResultType){
    SEFaceVerifyResultTypetFail = 1 << 0,       //人脸比对失败
    SEFaceVerifyResultTypeSuccess = 1 << 1,      //人脸比对成功
    SEFaceVerifyResultTypeUnknow = 1 << 2       //没有人脸比对结果
};

/**
 面签的方式
 */
typedef NS_ENUM(NSInteger, SECertificateType){
    SECertificateMainland = 1,     //大陆居民身份证
    SECertificateHongKong,       //香港居民身份证
    SECertificatePassport        //护照

};

/**
 语音类型
 */
typedef NS_ENUM(NSInteger, SELanguageType){
    SELanguageTypeChinese = 1 << 0,     //简体中文
    SELanguageTypeTraditionalChinese = 1 << 1,       //繁体中文
    SELanguageTypeEnglish = 1 << 2,        //英文
};

#endif /* SESDK_Def_h */

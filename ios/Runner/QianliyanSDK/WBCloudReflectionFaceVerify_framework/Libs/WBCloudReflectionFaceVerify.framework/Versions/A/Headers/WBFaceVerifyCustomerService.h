//
//  WBFaceVerifyCustomerService.h
//  WBFaceV2
//
//  Created by tank on 25/10/2016.
//  Copyright © 2016 webank. All rights reserved.
//

/**
 注意拉起页面的方式:

 SDK会创建一个UIWindow覆盖在当前界面,并在新创建的UIWindow界面进行人脸认证,并且可以通过实现 wbfaceVerifyServiceGetWindowLevel 代理方法,传入创建的UIWindow的windowLevel, 传入的windowLevel必须是1~999, 默认情况如果不实现 wbfaceVerifyServiceGetWindowLevel 方法,windowLevel = UIWindowLevelNormal + 1
 */


#import <UIKit/UIKit.h>
#import "WBFaceVerifyConst.h"
#import "WBFaceVerifySDKConfig.h"
#import "WBFaceVerifyCompareSourceConfig.h"
#import "WBFaceVerifyResult.h"
#import "WBFaceUserInfo.h"

NS_ASSUME_NONNULL_BEGIN



// SDK在运行结束退出时候会发出通知. 具体的通知内容可以见delegate方法wbfaceVerifyCustomerServiceDidFinished:中的注释
UIKIT_EXTERN NSString *const WBFaceVerifyCustomerServiceDidFinishedNotification;

/**
 处理刷脸回调
 */
@class WBFaceVerifyCustomerService;
@protocol WBFaceVerifyCustomerServiceDelegate  <NSObject>
@optional
-(void)wbfaceVerifyCustomerServiceWillUploadBestImage:(UIImage *)bestImage;

@required
-(void)wbfaceVerifyCustomerServiceDidFinishedWithFaceVerifyResult:(WBFaceVerifyResult *)faceVerifyResult;
@end

@interface WBFaceVerifyCustomerService : NSObject
@property (nullable,nonatomic,weak) id<WBFaceVerifyCustomerServiceDelegate> delegate;
@property (nonatomic, assign, readonly) BOOL isService;

/*
 全局唯一单例
 */
+(instancetype)sharedInstance;

/*
初始化云刷脸sdk，仅做参数初始化与登陆，不拉起刷脸页面
登陆有时效性，建议在登陆完成后success回调中拉起刷脸页面！！
登陆过程为异步操作，多次登陆以最后一次收到的结果为准！！
 
此SDK接口中
合作方后台开发需要通过后台接口获取sign,
然后根据自带比对源接口, 通过后台接口获取faceId!!!!(native端无需传入自带比对源图)

注意, 请使用 dispatch_async(dispatch_get_main_queue(), ^{  }); 异步调用SDK的入口方法

@param userid 用户唯一标识, 由合作方自行定义（具体要求，参考word接入文档）
@param nonce  满足接入要求的32位随机数（具体要求，参考word接入文档）
@param sign 满足接入要求的40位签名值（具体要求，参考word接入文档）
@param appid 腾讯服务分配的appid
@param orderNo 每次人脸身份认证请求的唯一订单号: 建议为32位字符串(不超过32位)
@param apiVersion 后台api接口版本号(不是SDK的版本号),默认请填写@"1.0.0"
@param licence 腾讯给合作方派发的前端使用的licence(该licence同app当前使用的bundle id绑定)

@param faceId 合作方必须要先在获取faceId的接口里送入用户自带比对源图片信息，得到相应的faceId后，再送入sdk!!!!(参考word接入文档)

@param sdkConfig SDK基础配置项目
@param success 服务登录成功回调,登录成功以后开始进行活体和检测服务
@param failure 服务登录失败回调,具体参考错误码文档(参考word接入文档)
*/
-(void)initSDKWithUserId:(NSString *)userid
                   nonce:(NSString *)nonce
                    sign:(NSString *)sign
                   appid:(NSString *)appid
                 orderNo:(NSString *)orderNo
              apiVersion:(NSString *)apiVersion
                 licence:(NSString *)licence
                  faceId:(NSString * __nullable)faceId
               sdkConfig:(WBFaceVerifySDKConfig *)sdkConfig
                 success:(void (^)())success
                 failure:(void (^)(WBFaceError * _Nonnull))failure;

/**
 以上一次的登陆结果拉起刷脸页面，必须先登录再拉起刷脸页面
 
 @return 拉起是否成功
 */
- (BOOL)startWbFaceVeirifySdk;


/**
 接口服务包含: 活体检测 + 人脸比对(身份证的网文照片进行对比) -- 使用faceID版本(只支持WBFaceVerifyLivingType_Action,WBFaceVerifyLivingType_Light, 不支持 WBFaceVerifyLivingType_Number)



 此SDK接口中
 合作方后台开发需要通过后台接口获取sign,
 然后根据身份证+姓名通过后台接口, 获取faceId!!!!(native端无需传入身份证, 姓名)

 注意, 请使用 dispatch_async(dispatch_get_main_queue(), ^{  }); 异步调用SDK的入口方法


 @param userid 用户唯一标识, 由合作方自行定义（具体要求，参考word接入文档）
 @param nonce  满足接入要求的32位随机数（具体要求，参考word接入文档）
 @param sign 满足接入要求的40位签名值（具体要求，参考word接入文档）
 @param appid 腾讯服务分配的appid
 @param orderNo 每次人脸身份认证请求的唯一订单号: 建议为32位字符串(不超过32位)
 @param apiVersion 后台api接口版本号(不是SDK的版本号),默认请填写@"1.0.0"
 @param licence 腾讯给合作方派发的前端使用的licence(该licence同app当前使用的bundle id绑定)

 @param faceId 合作方必须要先在获取faceId的接口里送入用户的姓名与身份证号信息，得到相应的faceId后，再送入sdk!!!!(参考word接入文档)

 @param sdkConfig SDK基础配置项目
 @param success 服务登录成功回调,登录成功以后开始进行(做动作/读数字/光线反射)活体动作检测
 @param failure 服务登录失败回调,具体参考错误码文档(参考word接入文档)
 */
-(void)loginInLiveCheckAndCompareWithIdImageService:(NSString *)userid
                                              nonce:(NSString *)nonce
                                               sign:(NSString *)sign
                                              appid:(NSString *)appid
                                            orderNo:(NSString *)orderNo
                                        apiVersion:(NSString *)apiVersion
                                            licence:(NSString *)licence
                                             faceId:(NSString *)faceId
                                          sdkConfig:(WBFaceVerifySDKConfig *)sdkConfig
                                            success:(void (^)())success
                                            failure:(void (^)(WBFaceError *error))failure;

/**
 接口服务包含: 活体检测 + 人脸比对(合作方提供的比对源图片进行比对) -- 使用faceID版本(只支持WBFaceVerifyLivingType_Action,WBFaceVerifyLivingType_Light, 不支持 WBFaceVerifyLivingType_Number)

 此SDK接口中
 合作方后台开发需要通过后台接口获取sign,
 然后根据自带比对源接口, 通过后台接口获取faceId!!!!(native端无需传入自带比对源图)

 注意, 请使用 dispatch_async(dispatch_get_main_queue(), ^{  }); 异步调用SDK的入口方法

 @param userid 用户唯一标识, 由合作方自行定义（具体要求，参考word接入文档）
 @param nonce  满足接入要求的32位随机数（具体要求，参考word接入文档）
 @param sign 满足接入要求的40位签名值（具体要求，参考word接入文档）
 @param appid 腾讯服务分配的appid
 @param orderNo 每次人脸身份认证请求的唯一订单号: 建议为32位字符串(不超过32位)
 @param apiVersion 后台api接口版本号(不是SDK的版本号),默认请填写@"1.0.0"
 @param licence 腾讯给合作方派发的前端使用的licence(该licence同app当前使用的bundle id绑定)

 @param faceId 合作方必须要先在获取faceId的接口里送入用户自带比对源图片信息，得到相应的faceId后，再送入sdk!!!!(参考word接入文档)

 @param sdkConfig SDK基础配置项目
 @param success 服务登录成功回调,登录成功以后开始进行活体和检测服务
 @param failure 服务登录失败回调,具体参考错误码文档(参考word接入文档)
 */
-(void)loginInLiveCheckAndCompareWithSourceImageService:(NSString *)userid
                                                  nonce:(NSString *)nonce
                                                   sign:(NSString *)sign
                                                  appid:(NSString *)appid
                                                orderNo:(NSString *)orderNo
                                             apiVersion:(NSString *)apiVersion
                                                licence:(NSString *)licence
                                                 faceId:(NSString *)faceId
                                              sdkConfig:(WBFaceVerifySDKConfig *)sdkConfig
                                                success:(void (^)())success
                                                failure:(void (^)(WBFaceError *error))failure;

/**
 接口服务包含: 活体检测

 注意, 请使用 dispatch_async(dispatch_get_main_queue(), ^{  }); 异步调用SDK的入口方法


 此接口为新版本接口, 只是修改名称, 功能同
 `-(void)startLoginLiveCheckServiceWithUserid:nonce:sign:appid:orderNo:apiVersion:licence:faceverifyType:configure:success:failure:`

 @param userid 用户唯一标识, 由合作方自行定义（具体要求，参考word接入文档）
 @param nonce 满足接入要求的32位随机数（具体要求，参考word接入文档）
 @param sign 满足接入要求的40位签名值（具体要求，参考word接入文档）

 @param appid 腾讯服务分配的appid
 @param orderNo 每次人脸身份认证请求的唯一订单号: 建议为32位字符串(不超过32位)
 @param apiVersion  后台api接口版本号(不是SDK的版本号),默认请填写@"1.0.0"
 @param licence 腾讯给合作方派发的前端使用的licence(该licence同app当前使用的bundle id绑定)
 @param sdkConfig SDK基础配置项目
 @param success 服务登录成功回调,登录成功以后开始进行(做动作/读数字/光线反射)活体动作检测
 @param failure 服务登录失败回调,具体参考错误码文档(参考word接入文档)
 */
-(void)loginInLiveCheckService:(NSString *)userid
                         nonce:(NSString *)nonce
                          sign:(NSString *)sign
                         appid:(NSString *)appid
                       orderNo:(NSString *)orderNo
                    apiVersion:(NSString *)apiVersion
                       licence:(NSString *)licence
                     sdkConfig:(WBFaceVerifySDKConfig *)sdkConfig
                       success:(void (^)())success
                       failure:(void (^)(WBFaceError *error))failure;


/**
 接口服务包含: 活体检测 + 人脸比对(身份证的网文照片进行对比)

 注意, 请使用 dispatch_async(dispatch_get_main_queue(), ^{  }); 异步调用SDK的入口方法


 @param userid 用户唯一标识, 由合作方自行定义（具体要求，参考word接入文档）
 @param nonce 满足接入要求的32位随机数（具体要求，参考word接入文档）
 @param sign 满足接入要求的40位签名值（具体要求，参考word接入文档）
 @param appid 腾讯服务分配的appid
 @param orderNo 每次人脸身份认证请求的唯一订单号: 建议为32位字符串(不超过32位)
 @param apiVersion 后台api接口版本号(不是SDK的版本号),默认请填写@"1.0.0"
 @param licence 腾讯给合作方派发的前端使用的licence(该licence同app当前使用的bundle id绑定)

 @param userInfo 需要比对者的身份信息: 18位身份证号 + 姓名 + id类型

 •    身份证 idNo - 仅支持18位身份证
 •    姓名 name
 •    证件类型 idType - 默认18位身份证填写 @”01”

 @param configure SDK基础配置项目
 @param success 服务登录成功回调,登录成功以后开始进行(做动作/读数字/光线反射)活体动作检测
 @param failure 服务登录失败回调,具体参考错误码文档(参考word接入文档)
 */
-(void)startLoginLiveCheckAndCompareServiceWithUserid:(NSString *)userid
                                          nonce:(NSString *)nonce
                                           sign:(NSString *)sign
                                          appid:(NSString *)appid
                                        orderNo:(NSString *)orderNo
                                     apiVersion:(NSString *)apiVersion
                                        licence:(NSString *)licence
                                       userInfo:(WBFaceUserInfo *)userInfo
                                      configure:(WBFaceVerifySDKConfig *)configure
                                        success:(void (^)())success
                                        failure:(void (^)(WBFaceError *error))failure;

/**
 接口服务包含: 活体检测 + 人脸比对(合作方提供的比对源图片进行比对)

 注意, 请使用 dispatch_async(dispatch_get_main_queue(), ^{  }); 异步调用SDK的入口方法

 @param userid 用户唯一标识, 由合作方自行定义（具体要求，参考word接入文档）
 @param nonce 满足接入要求的32位随机数（具体要求，参考word接入文档）
 @param sign 满足接入要求的40位签名值（具体要求，参考word接入文档）
 @param appid 腾讯服务分配的appid
 @param orderNo 每次人脸身份认证请求的唯一订单号: 建议为32位字符串(不超过32位)
 @param apiVersion  后台api接口版本号(不是SDK的版本号),默认请填写@"1.0.0"
 @param licence 腾讯给合作方派发的前端使用的licence(该licence同app当前使用的bundle id绑定)
 @param compareSoureConfig 自带比对源接口配置项目

 @param configure SDK基础配置项目
 @param success 服务登录成功回调,登录成功以后开始进行(做动作/读数字/光线反射)活体动作检测
 @param failure 服务登录失败回调,具体参考错误码文档(参考word接入文档)
 */
-(void)startLoginLiveCheckAndCompareServiceWithUserid:(NSString *)userid
                                                nonce:(NSString *)nonce
                                                 sign:(NSString *)sign
                                                appid:(NSString *)appid
                                              orderNo:(NSString *)orderNo
                                           apiVersion:(NSString *)apiVersion
                                              licence:(NSString *)licence
                                  compareSourceConfig:(WBFaceVerifyCompareSourceConfig *)compareSoureConfig
                                            configure:(WBFaceVerifySDKConfig *)configure
                                              success:(void (^)())success
                                              failure:(void (^)(WBFaceError *error))failure;


/**
 接口服务包含: 活体检测 + 人脸比对(合作方提供的比对源图片进行比对)

 注意, 请使用 dispatch_async(dispatch_get_main_queue(), ^{  }); 异步调用SDK的入口方法

 @param userid 用户唯一标识, 由合作方自行定义（具体要求，参考word接入文档）
 @param nonce 满足接入要求的32位随机数（具体要求，参考word接入文档）
 @param sign 满足接入要求的40位签名值（具体要求，参考word接入文档）
 @param appid 腾讯服务分配的appid
 @param orderNo 每次人脸身份认证请求的唯一订单号: 建议为32位字符串(不超过32位)
 @param apiVersion  后台api接口版本号(不是SDK的版本号),默认请填写@"1.0.0"
 @param licence 腾讯给合作方派发的前端使用的licence(该licence同app当前使用的bundle id绑定)
 @param userInfo 需要比对者的身份信息: 18位身份证号 + 姓名 + id类型

 @param compareSoureConfig 自带比对源接口配置项目, 注意自带比对源图片大小不能超过2M

 @param configure SDK基础配置项目
 @param success 服务登录成功回调,登录成功以后开始进行(做动作/读数字/光线反射)活体动作检测
 @param failure 服务登录失败回调,具体参考错误码文档(参考word接入文档)
 */
-(void)startLoginLiveCheckAndCompareServiceWithUserid:(NSString *)userid
                                                nonce:(NSString *)nonce
                                                 sign:(NSString *)sign
                                                appid:(NSString *)appid
                                              orderNo:(NSString *)orderNo
                                           apiVersion:(NSString *)apiVersion
                                              licence:(NSString *)licence
                                             userInfo:(nullable WBFaceUserInfo *)userInfo
                                  compareSourceConfig:(WBFaceVerifyCompareSourceConfig *)compareSoureConfig
                                            configure:(WBFaceVerifySDKConfig *)configure
                                              success:(void (^)())success
                                              failure:(void (^)(WBFaceError *error))failure;

/*
 接口服务包含: 活体检测

 注意, 请使用 dispatch_async(dispatch_get_main_queue(), ^{  }); 异步调用SDK的入口方法

@param userid 用户唯一标识, 由合作方自行定义（具体要求，参考word接入文档）
@param nonce 满足接入要求的32位随机数（具体要求，参考word接入文档）
@param sign 满足接入要求的40位签名值（具体要求，参考word接入文档）
@param appid 腾讯服务分配的appid
@param orderNo 每次人脸身份认证请求的唯一订单号: 建议为32位字符串(不超过32位)
@param apiVersion  后台api接口版本号(不是SDK的版本号),默认请填写@"1.0.0"
@param licence 腾讯给合作方派发的前端使用的licence(该licence同app当前使用的bundle id绑定)
@param configure SDK基础配置项目
@param success 服务登录成功回调,登录成功以后开始进行(做动作/读数字/光线反射)活体动作检测
@param failure 服务登录失败回调,具体参考错误码文档(参考word接入文档)
*/
-(void)startLoginLiveCheckServiceWithUserid:(NSString *)userid
                                          nonce:(NSString *)nonce
                                           sign:(NSString *)sign
                                          appid:(NSString *)appid
                                        orderNo:(NSString *)orderNo
                                     apiVersion:(NSString *)apiVersion
                                        licence:(NSString *)licence
                                      configure:(WBFaceVerifySDKConfig *)configure
                                        success:(void (^)())success
                                        failure:(void (^)(WBFaceError *error))failure;
@end

NS_ASSUME_NONNULL_END

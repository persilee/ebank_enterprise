//
//  WBFaceVerifySDKConfig.h
//  Pods
//
//  Created by pp on 2017/8/2.
//
//

#import <Foundation/Foundation.h>
#import "WBFaceVerifyConst.h"
NS_ASSUME_NONNULL_BEGIN

/**
 人脸识别SDK 基础配置类
 */
@interface WBFaceVerifySDKConfig : NSObject

/**
 sdk中拉起人脸活体识别界面中使用UIWindow时的windowLevel配置,默认配置是1 + UIWindowLevelNormal

 如果接入放app中有其他自定义UIWindow, 为了防止界面覆盖,可以酌情设置该参数
 */
@property (nonatomic, assign) NSUInteger windowLevel;

/**
 人脸识别服务结果页是否展示配置项 - 是否展示人脸对比成功界面 -> 建议关闭

 default: NO
 */
@property (nonatomic, assign) BOOL showSuccessPage;

/**
 人脸识别服务结果页是否展示配置项 - 是否展示人脸对比失败界面 -> 建议关闭

 default: NO
 */
@property (nonatomic, assign) BOOL showFailurePage;

/**
 人脸识别服务是否进行通过录像, 从而进行视频存证 -> 建议开启

 default: YES
 */
@property (nonatomic, assign) BOOL recordVideo;

/**
 光线活体专属配置: 预检检测过程是否允许闭眼睛

 default: YES - 允许用户闭眼
 */
@property (nonatomic, assign) BOOL enableCloseEyes;

/**
 人脸识别页面中的主题风格, 需要配合不同资源包使用:
 WBFaceVerifyThemeDarkness - 暗灰主题
 WBFaceVerifyThemeLightness - 明亮主题
 */
@property (nonatomic, assign) WBFaceVerifyTheme theme;


/**
 默认sdk配置
 */
+(instancetype)sdkConfig;

@end
NS_ASSUME_NONNULL_END

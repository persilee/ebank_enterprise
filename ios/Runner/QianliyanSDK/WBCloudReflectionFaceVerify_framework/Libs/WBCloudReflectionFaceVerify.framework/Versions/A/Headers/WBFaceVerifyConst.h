//
//  WBFaceVerifyConst.h
//  Pods
//
//  Created by pp on 2017/7/31.
//
//
#import <UIKit/UIKit.h>
#ifndef WBFaceVerifyConst_h
#define WBFaceVerifyConst_h
#define WBCloudReflectionFaceVerifyVersion @"5.0.3"

UIKIT_EXTERN NSString *const WBCloudFaceVerifySDKVersion;

/**
 具体的活体检测的类型:

 - WBFaceVerifyLivingType_Action:   动作活体
 - WBFaceVerifyLivingType_Number:   读4个数字活体
 - WBFaceVerifyLivingType_Light:    光线活体
 */
typedef NS_ENUM(NSInteger,WBFaceVerifyLivingType){
    WBFaceVerifyLivingType_Action,// 老版本的 - WBFaceVerifyLivingType_Middle
    WBFaceVerifyLivingType_Number,// 老版本的 - WBFaceVerifyLivingType_Advanced
    WBFaceVerifyLivingType_Light,
};

/**
 SDK使用的主题风格

 - WBFaceVerifyThemeDarkness: 暗黑色系主题
 - WBFaceVerifyThemeLightness: 明亮色系主题
 */
typedef NS_ENUM(NSInteger, WBFaceVerifyTheme) {
    WBFaceVerifyThemeDarkness,
    WBFaceVerifyThemeLightness,
    WBFaceVerifyThemeCustom
};

#endif /* WBFaceVerifyConst_h */

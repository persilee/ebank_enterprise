//
//  AppDelegate+HSQlyDelegate.h
//  Runner
//
//  Created by 李家伟 on 2021/5/22.
//

#import "AppDelegate.h"
#import <SigningEyeSDK/SigningEyeSDK.h>

NS_ASSUME_NONNULL_BEGIN

@interface AppDelegate (HSQlyDelegate) <SEVideoManagerDelegate,SigningESDKDelegate>

- (void)initializeQly:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;

@end

NS_ASSUME_NONNULL_END

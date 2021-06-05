//
//  AppDelegate+HSPushDelegate.h
//  Runner
//
//  Created by 李家伟 on 2021/5/21.
//

#import "AppDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface AppDelegate (HSPushDelegate)<FlutterStreamHandler>

- (void)initializePush:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;

@end

NS_ASSUME_NONNULL_END

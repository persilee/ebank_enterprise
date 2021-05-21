//
//  AppDelegate+HSPushDelegate.m
//  Runner
//
//  Created by 李家伟 on 2021/5/21.
//

#import "AppDelegate+HSPushDelegate.h"
#import <CloudPushSDK/CloudPushSDK.h>
#import <UserNotifications/UserNotifications.h>

@implementation AppDelegate (HSPushDelegate)

- (void)initializePush:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self initCloudPush];
    [self registerAPNS:application];
    [self registerMessageReceive];
//    [self listenerOnChannelOpened];
    
    // 点击通知将App从关闭状态启动时，将通知打开回执上报
    // [CloudPushSDK handleLaunching:launchOptions];(Deprecated from v1.8.1)
    [CloudPushSDK sendNotificationAck:launchOptions];
}

#pragma mark - aliPush 设置参数
/// 推送设置参数
/// @param type 1 account 2 tags 3 alias
/// @param parameters 设置的值，统一为字符串数组，除了tags其他只能传一个元素
- (void)bindPushType:(int)type parameters:(NSArray<NSString *> *)parameters callback:(CallbackHandler)callback
{
    if (parameters == NULL || parameters == nil || parameters.count == 0) {
        if (callback) {
            callback(nil);
        }
        return;
    }
    switch (type) {
        case 1:
        {
            [CloudPushSDK bindAccount:parameters[0] withCallback:callback];
        }
            break;
            
        case 2:
        {
            [CloudPushSDK bindTag:2 withTags:parameters withAlias:nil withCallback:callback];
        }
            break;
            
        case 3:
        {
            [CloudPushSDK addAlias:parameters[0] withCallback:callback];
        }
            break;
            
        default:
            break;
    }
}

/// 取消设置的推送参数
/// @param type 1 account 2 tags 3 alias
/// @param parameters 需要取消的值，统一为字符串数组，除了tags其他只能传一个元素（account不用传，alias传空则会取消设备绑定的所有别名）
- (void)unbindPushType:(int)type parameters:(NSArray<NSString *> *)parameters callback:(CallbackHandler)callback
{
    switch (type) {
        case 1:
        {
            [CloudPushSDK unbindAccount:callback];
        }
            break;
            
        case 2:
        {
            if (parameters == NULL || parameters == nil || parameters.count == 0) {
                if (callback) {
                    callback(nil);
                }
                return;
            }
            [CloudPushSDK unbindTag:2 withTags:parameters withAlias:nil withCallback:callback];
        }
            break;
            
        case 3:
        {
            NSString *aliasStr;
            if (parameters == NULL || parameters == nil || parameters.count == 0) {
                aliasStr = @"";
            }
            else {
                aliasStr = parameters[0];
            }
            [CloudPushSDK removeAlias:aliasStr withCallback:callback];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - aliPush 接受推送
- (void)initCloudPush {
    // SDK初始化
    [CloudPushSDK asyncInit:@"333441016" appSecret:@"1c04ef22c4cc4cc787351ff734e68d7d" callback:^(CloudPushCallbackResult *res) {
        if (res.success) {
            NSLog(@"Push SDK init success, deviceId: %@.", [CloudPushSDK getDeviceId]);
            [CloudPushSDK bindAccount:@"brillink" withCallback:^(CloudPushCallbackResult *res) {
                if (res.success) {
                    NSLog(@"00000000000000000");
                }
            }];
        } else {
            NSLog(@"Push SDK init failed, error: %@", res.error);
        }
    }];
}

/**
 *    注册苹果推送，获取deviceToken用于推送
 *
 *    @param     application
 */
- (void)registerAPNS:(UIApplication *)application {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 100000
    if (@available(iOS 10.0, *)) {
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
            center.delegate = self;
            [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error){
                if( !error ){
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [[UIApplication sharedApplication] registerForRemoteNotifications];
                    });
                }
            }];
    }
#else
    else {
        // iOS 8 - 10 Notifications
        [application registerUserNotificationSettings:
         [UIUserNotificationSettings settingsForTypes:
          (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge)
                                           categories:nil]];
        [application registerForRemoteNotifications];
    }
//xcode baseSDK为7.0以下的

#endif
    
}
/*
 *  苹果推送注册成功回调，将苹果返回的deviceToken上传到CloudPush服务器
 */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [CloudPushSDK registerDevice:deviceToken withCallback:^(CloudPushCallbackResult *res) {
        if (res.success) {
            NSLog(@"Register deviceToken success.");
        } else {
            NSLog(@"Register deviceToken failed, error: %@", res.error);
        }
    }];
}
/*
 *  苹果推送注册失败回调
 */
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"didFailToRegisterForRemoteNotificationsWithError %@", error);
}

/**
 *    注册推送消息到来监听
 */
- (void)registerMessageReceive {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onMessageReceived:)
                                                 name:@"CCPDidReceiveMessageNotification"
                                               object:nil];
}
/**
 *    处理到来推送消息
 *
 *    @param     notification
 */
- (void)onMessageReceived:(NSNotification *)notification {
    CCPSysMessage *message = [notification object];
    NSString *title = [[NSString alloc] initWithData:message.title encoding:NSUTF8StringEncoding];
    NSString *body = [[NSString alloc] initWithData:message.body encoding:NSUTF8StringEncoding];
    NSLog(@"1111111 Receive message title: %@, content: %@.", title, body);
}

//iOS 10 +
/**
 *  App处于前台时收到通知(iOS 10+)
 */
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler{
    NSLog(@"4444Receive a notification in foregound.");
        // 处理iOS 10通知相关字段信息
        [self handleiOS10Notification:notification isClick:NO];
        // 通知不弹出
        //completionHandler(UNNotificationPresentationOptionNone);
        // 通知弹出，且带有声音、内容和角标（App处于前台时不建议弹出通知）
        completionHandler(UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert | UNNotificationPresentationOptionBadge);
}
/**
 *  触发通知动作时回调，比如点击、删除通知和点击自定义action(iOS 10+)
 */
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)(void))completionHandler
{
    NSString *userAction = response.actionIdentifier;
        // 点击通知打开
        if ([userAction isEqualToString:UNNotificationDefaultActionIdentifier]) {
            NSLog(@"5555User opened the notification.");
            // 处理iOS 10通知，并上报通知打开回执
            [self handleiOS10Notification:response.notification isClick:YES];
        }
        // 通知dismiss，category创建时传入UNNotificationCategoryOptionCustomDismissAction才可以触发
        if ([userAction isEqualToString:UNNotificationDismissActionIdentifier]) {
            NSLog(@"6666User dismissed the notification.");
        }
        NSString *customAction1 = @"action1";
        NSString *customAction2 = @"action2";
        // 点击用户自定义Action1
        if ([userAction isEqualToString:customAction1]) {
            NSLog(@"7777User custom action1.");
        }
        // 点击用户自定义Action2
        if ([userAction isEqualToString:customAction2]) {
            NSLog(@"88888User custom action2.");
        }
        completionHandler();
}

/**
 *  处理iOS 10通知(iOS 10+)
 */
- (void)handleiOS10Notification:(UNNotification *)notification isClick:(BOOL)isClick {
    UNNotificationRequest *request = notification.request;
    UNNotificationContent *content = request.content;
    NSDictionary *userInfo = content.userInfo;
    // 通知时间
    NSDate *noticeDate = notification.date;
    // 标题
    NSString *title = content.title;
    // 副标题
    NSString *subtitle = content.subtitle;
    // 内容
    NSString *body = content.body;
    // 角标
    int badge = [content.badge intValue];
    // 取得通知自定义字段内容，例：获取key为"Extras"的内容
    NSString *extras = [userInfo valueForKey:@"Extras"];
    // 通知打开回执上报
    [CloudPushSDK sendNotificationAck:userInfo];
    NSLog(@"99999Notification, date: %@, title: %@, subtitle: %@, body: %@, badge: %d, extras: %@.", noticeDate, title, subtitle, body, badge, extras);
}

@end

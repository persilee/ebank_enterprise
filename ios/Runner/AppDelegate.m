
#import <Flutter/Flutter.h>
#import "AppDelegate.h"
#import "GeneratedPluginRegistrant.h"
#import "MJExtension.h"
#import "UtilsMacros.h"
#import "IQKeyboardManager.h"
#import <CloudPushSDK/CloudPushSDK.h>
#import <UserNotifications/UserNotifications.h>

static NSString *const teantID = @"DLEAED";//LFFEAE

@interface AppDelegate ()
@property (nonatomic, strong) FlutterResult resultBlock;
@property (nonatomic, strong) NSDictionary *bodyDictData;
@end


@implementation AppDelegate

#pragma mark - 单利
+ (AppDelegate *)shareAppDelegate{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    [self keybordManager];
    // 1.获取FlutterViewController(是应用程序的默认Controller)
    FlutterViewController* controller = (FlutterViewController*)self.window.rootViewController;
    
    // 2.获取MethodChannel(方法通道)
    FlutterMethodChannel* batteryChannel = [FlutterMethodChannel
                                            methodChannelWithName:@"com.hsg.bank.brillink/auth-identity"
                                            binaryMessenger:controller.binaryMessenger];
    
    // 3.监听方法调用(会调用传入的回调函数)
    __weak typeof(self) weakSelf = self;
    [batteryChannel setMethodCallHandler:^(FlutterMethodCall* call, FlutterResult result){
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [[SigningESDK sharedInstance] initSDK];
        [SigningESDK sharedInstance].delegate = self;
        
        if ([@"startAuth" isEqualToString:call.method]) {//验证方法是否可用
            NSDictionary *bodyDictData = [call.arguments mj_JSONObject];
            
            NSString *tenantId = [bodyDictData objectForKey:@"body"];
            NSDictionary *jsonflutter = [tenantId mj_JSONObject];
            strongSelf.bodyDictData = jsonflutter;
            
            [weakSelf videoTenantID:[jsonflutter objectForKey:@"tenantId"] contractID:@"xxx2" businessID:[jsonflutter objectForKey:@"businessId"]];
            strongSelf.resultBlock = result;
            
        } else {
            // 3.2.如果调用的是VideoMethodCall的方法, 那么通过封装的另外一个方法实现回调
            result(FlutterMethodNotImplemented);
        }
    }];
    
    [GeneratedPluginRegistrant registerWithRegistry:self];
    
    [self initCloudPush];
    [self registerAPNS:application];
    [self registerMessageReceive];
//    [self listenerOnChannelOpened];
    
    // 点击通知将App从关闭状态启动时，将通知打开回执上报
    // [CloudPushSDK handleLaunching:launchOptions];(Deprecated from v1.8.1)
    [CloudPushSDK sendNotificationAck:launchOptions];
    
    
    return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

-(void)videoTenantID:(NSString *)tenantID contractID:(NSString *)contractId businessID:(NSString *)business{
    SEVideoManager *manager = [SEVideoManager sharedInstance];
    manager.delegate = self;
    [manager videoWithTenantID:tenantID contractID:contractId businessID:business extension:nil];
}

//人脸识别数据
-(SEFaceVerifyData *)SEVideoServiceWithFaceVerifyData{
    SEFaceVerifyData *faceData = [[SEFaceVerifyData alloc]init];
    //hasFaceVerFunc  没有标注说明
    faceData.hasFaceVerFunc = NO;
    //    faceData.idNo = @"身份证号";
    //    faceData.name = @"姓名";
    //    faceData.sourcePhotoStr = @"";
    return faceData;
}

/// 视频面签的数据
-(SEInterviewData *)SEVideoServiceWithInterviewData{
    
    SEInterviewData *interViewData = [[SEInterviewData alloc]init];
    interViewData.interviewType = SEInterviewTypeCertificate;//认证
    interViewData.isShowImg = YES;
    interViewData.isAgain = YES;
    
    interViewData.certificateType = [[self.bodyDictData objectForKey:@"type"] intValue];//证件类型
    
    interViewData.code = [self.bodyDictData objectForKey:@"tokId"];//话术id
    interViewData.errAIcode = [self.bodyDictData objectForKey:@"tokId"];//证件识别失败10次话术id
    
    NSString *language = [self.bodyDictData objectForKey:@"language"];// 语言  zh 中文，en 英文
    if (NOTNULLString(language) && [language isEqualToString:@"en"]) {//语言类型 必传
        interViewData.languageType =   SELanguageTypeEnglish;
    }else {//简体或者繁体
        NSString *country = [self.bodyDictData objectForKey:@"country"];// 国家/地区 CN 中国大陆，TW,台湾繁体
        NSString *apendCountry = [NSString stringWithFormat:@"%@_%@",language,country];
        if ([apendCountry isEqualToString:@"zh_CN"]) {//简体中文
            interViewData.languageType = SELanguageTypeChinese;
        }else{
            interViewData.languageType = SELanguageTypeTraditionalChinese;
        }
    }
    
    //    interViewData.userName= @"Jason";//用户名
    //    interViewData.tenantName = @"高阳寰球";//公司名
    
    return interViewData;
}

-(NSString *)SEVideoServiceCheckBoxSourcePhotoStr{
    return @"xxxx";
}
-(void)SEVideoServiceNextClick{
    NSLog(@"");
}

-(SEFaceVerifyResultType)SEVideoServiceMainFaceVerifyResult{
    return SEFaceVerifyResultTypeSuccess;
}

-(BOOL)SEVideoServiceContinueWithFaceVerifyResult:(SEFaceVerifyResult *)faceVerifyResult{
    return YES;
}
//视频服务结束的方法
-(void)SEVideoServiceDidFinishedWithResult:(SEVideoResult *)videoResult{
    NSString *resultValue;
    if (videoResult.certificationResul.length > 0) {
        NSLog(@"认证结果%@",videoResult.certificationResul);
        //        NSDictionary *reultDict = @{@"result":videoResult.certificationResul};
        resultValue = [videoResult.certificationResul mj_JSONString];
        
        NSLog(@"认证结果转换------------%@",resultValue);
        
        self.resultBlock(resultValue);
    }else{//用户操作失败等问题统一在这里处理
        NSLog(@"报错信息------------%@ %@ %u",videoResult.error.desc, videoResult.certificationResul, videoResult.error.errorType);
    }
    //    resultValue = [videoResult.certificationResul mj_JSONString];
    //    self.resultBlock(resultValue);
    //    else{//不成功
    //        NSDictionary *reultDict = @{@"result":@"failer"};
    //        resultValue = [reultDict mj_JSONString];
    //
    //        self.resultBlock(resultValue);
    //    }
}

#pragma mark - SigningESDKDelegate
-(void)SigningESDKinitResult:(SEInitResult *)result{
    NSLog(@">>>>>result = %@", result);
}

#pragma mark — IQKeyboardManager配置
- (void)keybordManager
{
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;// 控制整个功能是否启用。
    manager.shouldResignOnTouchOutside = YES;//控制点击背景是否收起键盘
    manager.shouldToolbarUsesTextFieldTintColor = YES;//控制键盘上的工具条文字颜色是否用户自定义
    manager.toolbarDoneBarButtonItemText = @"Done";//将右边Done改成完成
    manager.enableAutoToolbar = YES;// 控制是否显示键盘上的工具条
    manager.toolbarManageBehaviour = IQAutoToolbarBySubviews;//最新版的设置键盘的returnKey的关键字 ,可以点击键盘上的next键，自动跳转到下一个输入框，最后一个输入框点击完成，自动收起键盘。</span>
    manager.keyboardDistanceFromTextField = 15.0f; // 输入框距离键盘的距离
}

#pragma mark - aliPush
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

//- (void)listenerOnChannelOpened {
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(onChannelOpened:)
//                                                 name:@"CCPDidChannelConnectedSuccess"
//                                               object:nil];
//}
//// 通道打开通知
//- (void)onChannelOpened:(NSNotification *)notification {
//    NSLog(@"22222 notification: %@", notification);
//}

////iOS 10 -
///**
// *  App处于打开状态时，点击打开通知；
// */
//- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {
//    NSLog(@"Receive one notification.");
//    // 取得APNS通知内容
//    NSDictionary *aps = [userInfo valueForKey:@"aps"];
//    // 内容
//    NSString *content = [aps valueForKey:@"alert"];
//    // badge数量
//    NSInteger badge = [[aps valueForKey:@"badge"] integerValue];
//    // 播放声音
//    NSString *sound = [aps valueForKey:@"sound"];
//    // 取得Extras字段内容
//    NSString *Extras = [userInfo valueForKey:@"Extras"]; //服务端中Extras字段，key是自己定义的
//    NSLog(@"3333content = [%@], badge = [%ld], sound = [%@], Extras = [%@]", content, (long)badge, sound, Extras);
//    // iOS badge 清0
//    application.applicationIconBadgeNumber = 0;
//    // 通知打开回执上报
//    // [CloudPushSDK handleReceiveRemoteNotification:userInfo];(Deprecated from v1.8.1)
//    [CloudPushSDK sendNotificationAck:userInfo];
//}

//iOS 10 +
/**
 *  App处于前台时收到通知(iOS 10+)
 */
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler{
    NSLog(@"4444Receive a notification in foregound.");
        // 处理iOS 10通知相关字段信息
        [self handleiOS10Notification:notification];
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
            [self handleiOS10Notification:response.notification];
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
- (void)handleiOS10Notification:(UNNotification *)notification {
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

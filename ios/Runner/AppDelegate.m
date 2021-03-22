
#import <Flutter/Flutter.h>
#import "AppDelegate.h"
#import "GeneratedPluginRegistrant.h"
#import "MJExtension.h"
#import "UtilsMacros.h"
#import "IQKeyboardManager.h"

static NSString *const teantID = @"DLEAED";//LFFEAE

@interface AppDelegate ()
@property (nonatomic, strong) FlutterResult resultBlock;
@property (nonatomic, strong) NSDictionary *bodyDictData;
@end


@implementation AppDelegate 

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  
    [[SigningESDK sharedInstance] initSDK];
    [SigningESDK sharedInstance].delegate = self;
    
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
    faceData.idNo = @"身份证号";
    faceData.name = @"姓名";
//    faceData.sourcePhotoStr = @"";
    return faceData;
}

/// 视频面签的数据
-(SEInterviewData *)SEVideoServiceWithInterviewData{
        
    SEInterviewData *interViewData = [[SEInterviewData alloc]init];
    interViewData.interviewType = SEInterviewTypeCertificate;//认证
    interViewData.isShowImg = YES;
    interViewData.isAgain = YES;

    interViewData.code = [self.bodyDictData objectForKey:@"tokId"];//话术id
    interViewData.errAIcode = [self.bodyDictData objectForKey:@"tokId"];//证件识别失败10次话术id
    interViewData.statementStr = @"证件识别失败，即将进入到AI自助面签";
    
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
        NSDictionary *reultDict = @{@"result":videoResult.certificationResul};
        resultValue = [reultDict mj_JSONString];
        
        self.resultBlock(resultValue);
    }else{//用户操作失败等问题统一在这里处理
        NSLog(@"报错信息------------%@",videoResult.error.desc);
    }
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

@end

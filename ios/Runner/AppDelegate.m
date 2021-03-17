
#import <Flutter/Flutter.h>
#import "AppDelegate.h"
#import "GeneratedPluginRegistrant.h"

@implementation AppDelegate 

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  
    [[SigningESDK sharedInstance] initSDK];
    [SigningESDK sharedInstance].delegate = self;
    
    // 1.获取FlutterViewController(是应用程序的默认Controller)
     FlutterViewController* controller = (FlutterViewController*)self.window.rootViewController;

     // 2.获取MethodChannel(方法通道)
     FlutterMethodChannel* batteryChannel = [FlutterMethodChannel
                                             methodChannelWithName:@"com.hsg.bank.brillink/auth-identity"
                                             binaryMessenger:controller.binaryMessenger];
    
     // 3.监听方法调用(会调用传入的回调函数)
     __weak typeof(self) weakSelf = self;
     [batteryChannel setMethodCallHandler:^(FlutterMethodCall* call, FlutterResult result) {
       // 3.1.判断是否是VideoMethodCall的调用
         
       if ([@"startAuth" isEqualToString:call.method]) {
           SEVideoManager *manager = [SEVideoManager sharedInstance];
           manager.delegate = weakSelf;
           [manager videoWithTenantID:@"LFFEAE" contractID:@"xxx2" businessID:@"xxxxx2" extension:nil];
           
         result(@"我传回来的值");
       } else {
         // 3.2.如果调用的是VideoMethodCall的方法, 那么通过封装的另外一个方法实现回调
         result(FlutterMethodNotImplemented);
       }
     }];
        
    [GeneratedPluginRegistrant registerWithRegistry:self];
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
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
    interViewData.isShowImg = NO;
    interViewData.isAgain = NO;
    
    interViewData.certificateType = SECertificateHongKong;//大陆还是香港或者是护照类型
    interViewData.code = @"";//护照话术id
    interViewData.errAIcode = @"";//证件识别失败10次话术id
    interViewData.languageType = SELanguageTypeTraditionalChinese;//语言类型 必传
    interViewData.userName= @"";//用户名
    interViewData.tenantName = @"";//公司名
//    interViewData.videoArray=  @[@"http://114.215.80.46:80/blade-person/videoApp/download/file?path=C%3A%5Chome%5Cfile%5C%E7%AD%BE%E9%87%8C%E7%9C%BC%E9%A3%8E%E9%99%A9%E6%92%AD%E6%8A%A5%E8%A7%86%E9%A2%91.mp4"];
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
    NSLog(@"报错信息------------%@",videoResult.error.desc);
    if (videoResult.certificationResul.length > 0) {
        NSLog(@"认证结果%@",videoResult.certificationResul);
    }
}

#pragma mark - SigningESDKDelegate
-(void)SigningESDKinitResult:(SEInitResult *)result{
    NSLog(@">>>>>result = %@", result);
}

@end

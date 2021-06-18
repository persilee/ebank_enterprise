#import <Flutter/Flutter.h>
#import <UIKit/UIKit.h>

@interface AppDelegate : FlutterAppDelegate 

///签里眼的回调相关
@property (nonatomic, strong) FlutterResult resultBlock;
@property (nonatomic, strong) NSDictionary *bodyDictData;
///阿里推送的回调相关（设置参数）
@property (nonatomic, strong) FlutterResult resultPushSetBlock;
@property (nonatomic, strong) NSDictionary *bodyDictPushSetData;
///阿里推送的回调相关（取消参数）
@property (nonatomic, strong) FlutterResult resultPushCancelBlock;
@property (nonatomic, strong) NSDictionary *bodyDictPushCancelData;
///阿里推送的回调相关（消息推送）
@property (nonatomic, strong) FlutterResult resultPushMessageBlock;
//@property (nonatomic, strong) NSDictionary *bodyDictPushMessageData;
///阿里推送的回调相关（通知推送）
@property (nonatomic, strong) FlutterResult resultPushNotificationBlock;
//@property (nonatomic, strong) NSDictionary *bodyDictPushNotificatioData;

@property (nonatomic, strong) FlutterEventSink eventSink;

//单例
+ (AppDelegate *)shareAppDelegate;

@end

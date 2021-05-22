#import <Flutter/Flutter.h>
#import <UIKit/UIKit.h>
#import <SigningEyeSDK/SigningEyeSDK.h>

@interface AppDelegate : FlutterAppDelegate <SEVideoManagerDelegate,SigningESDKDelegate>

//单例
+ (AppDelegate *)shareAppDelegate;

@end

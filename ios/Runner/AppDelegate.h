#import <Flutter/Flutter.h>
#import <UIKit/UIKit.h>

@interface AppDelegate : FlutterAppDelegate

@property (nonatomic, strong) FlutterResult resultBlock;
@property (nonatomic, strong) NSDictionary *bodyDictData;

//单例
+ (AppDelegate *)shareAppDelegate;

@end

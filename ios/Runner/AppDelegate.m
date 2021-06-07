
#import <Flutter/Flutter.h>
#import "AppDelegate.h"
#import "GeneratedPluginRegistrant.h"
#import "IQKeyboardManager.h"
#import "AppDelegate+HSPushDelegate.h"
#import "AppDelegate+HSQlyDelegate.h"



@interface AppDelegate ()
@end


@implementation AppDelegate

#pragma mark - 单利
+ (AppDelegate *)shareAppDelegate{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    [self keybordManager];
    
    [self initializeQly:application didFinishLaunchingWithOptions:launchOptions];
    
    [GeneratedPluginRegistrant registerWithRegistry:self];
    
    ///阿里推送的初始配置
    [self initializePush:application didFinishLaunchingWithOptions:launchOptions];
    
    return [super application:application didFinishLaunchingWithOptions:launchOptions];
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

//
//  UtilsMacros.h
//  LTYingJiBang
//
//  Created by 雷霆应急 on 2019/8/29.
//  Copyright © 2019 雷霆应急. All rights reserved.
//

#ifndef OftenUser_h
#define OftenUser_h

//本文件下的宏是一些通用工具宏

//============================================================NSLog
//#ifdef DEBUG
//#define kLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
//#define BASE_URL @""
//#else
//#define kLog(...)
//#define BASE_URL @""
//#endif

#ifdef DEBUG
#define kString [NSString stringWithFormat:@"%s", __FILE__].lastPathComponent
#define kLog(...) printf("%s: %s [%d]: %s\n\n",[[NSString log_stringDate] UTF8String], [kString UTF8String] ,__LINE__, [[NSString stringWithFormat:__VA_ARGS__] UTF8String]);
#define BASE_URL @""
#else
#define kLog(...)
#define BASE_URL @""
#endif
//============================================================(第二个比较详细适应于真机模拟器)

//============================================================UIScreen/IPHONE机型判断

// 用户机型判断宏
#define kCurrentModeSize [[UIScreen mainScreen] currentMode].size
// 判断是否是IPAD
#define kIPAD ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
// 判断IPHONE4系列
#define kIPHONE4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), kCurrentModeSize) && !kIPAD : NO)
// 判断IPHONE5系列
#define kIPHONE5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), kCurrentModeSize) && !kIPAD : NO)
// 判断IPHONE6系列(包含IPHONE6/IPHONE7/IPHONE8)
#define kIPHONE6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), kCurrentModeSize) && !kIPAD : NO)
// 判断IPHONE6P系列(包含IPHONE6P/IPHONE7P/IPHONE8P)
#define kIPHONEP ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), kCurrentModeSize) && !kIPAD : NO)
// 判断IPHONEX
#define kIPHONEX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), kCurrentModeSize) && !kIPAD : NO)
// 判断IPHONEXr
#define kIPHONEXr ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), kCurrentModeSize) && !kIPAD : NO)
// 判断IPHONEXs
#define kIPHONEXs ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), kCurrentModeSize) && !kIPAD : NO)
// 判断IPHONEXs Max
#define kIPHONEXsMax ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), kCurrentModeSize) && !kIPAD : NO)
// IPHONEX系列判断(包含IPHONE X/IPHONE XS/IPHONE XS Max/IPHONE XR)
#define  kIS_IPHONEX (CGSizeEqualToSize(CGSizeMake(375.f, 812.f), [UIScreen mainScreen].bounds.size) || CGSizeEqualToSize(CGSizeMake(812.f, 375.f), [UIScreen mainScreen].bounds.size)  || CGSizeEqualToSize(CGSizeMake(414.f, 896.f), [UIScreen mainScreen].bounds.size) || CGSizeEqualToSize(CGSizeMake(896.f, 414.f), [UIScreen mainScreen].bounds.size))

#define kIsBangsScreen ({\
    BOOL isBangsScreen = NO; \
    if (@available(iOS 11.0, *)) { \
    UIWindow *window = [[UIApplication sharedApplication].windows firstObject]; \
    isBangsScreen = window.safeAreaInsets.bottom > 0; \
    } \
    isBangsScreen; \
})

// 顶部NavBar高度
#define kNavBarH (kIsBangsScreen ? 88.0 : 64.0)
// 底部TabBar高度
#define kTabBarH (kIsBangsScreen ? 83.0 : 49.0)
// 顶部StatusBar高度
#define kStatusBarH (kIsBangsScreen ? 44.0 : 20.0)
// 判断是不是刘海屏(IPHONEX系列)
#define kIPHONENewX ((kNavBarH==88.0 || kIPHONEXr==83.0 || kStatusBarH==44.0) ? YES : NO)
// 底部安全区域高度
#define kTabbarSafeH (kIsBangsScreen ? 34.f : 0.f)
// 顶部适配系统方法
#define STATUS_BAR_FRAME [[UIApplication sharedApplication] statusBarFrame]

//IPHONE 6 宽高比
#define IPHONE6ScaleWidth kScreenWidth/375.0
#define IPHONE6ScaleHeight kScreenHeight/667.0

//获取最大的frameY值
#define kMaxX(control) CGRectGetMaxX(control.frame)
#define kMaxY(control) CGRectGetMaxY(control.frame)

//设置图片
#define imageName(name) [UIImage imageNamed:name]



//获取系统对象
#define kApplication        [UIApplication sharedApplication]
#define kAppWindow          [UIApplication sharedApplication].delegate.window
#define kAppDelegate        [AppDelegate shareAppDelegate]
#define kRootViewController [UIApplication sharedApplication].delegate.window.rootViewController
#define kNotificationCenter [NSNotificationCenter defaultCenter]

// 获取屏幕的尺寸  宽度和高度
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

// IOS版本
#define IOSVersion [[[UIDevice currentDevice] systemVersion] floatValue]
// 是否为iOS7
#define IOS7 (IOSVersion >= 7.0)
//============================================================UIScreen/IPHONE机型判断(方法有很多种灵活运用)

//property属性快速声明
#define PropertyString(s) @property(nonatomic, copy) NSString * s
#define PropertyNSInteger(s) @property(nonatomic, assign) NSInteger s
#define PropertyFloat(s) @property(nonatomic, assign) float s
#define PropertyLongLong(s) @property(nonatomic, assign) long long s
#define PropertyNSDictionary(s) @property(nonatomic, copy) NSDictionary * s
#define PropertyNSArray(s) @property(nonatomic, copy) NSArray * s
#define PropertyNSMutableArray(s) @property(nonatomic, strong) NSMutableArray * s

//随机颜色
#define kRandomColor [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0]
//获取透明颜色
#define kClearColor [UIColor clearColor]
#define kWhiteColor [UIColor whiteColor]
#define kBlackColor [UIColor blackColor]
#define kGrayColor [UIColor grayColor]
#define kLightGrayColor [UIColor lightGrayColor]
#define kBlueColor [UIColor blueColor]
#define kRedColor [UIColor redColor]
//rgb颜色转换（16进制->10进制）
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define UIColorFromRGBWithAlpha(rgbValue,ap) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:ap]

//设置颜色RGB
#define COLOR(R, G, B, A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]

//字体的设计配置
#define wwww ({CGFloat W = 0;if(ispad == YES){if([UIScreen mainScreen].bounds.size.width > [UIScreen mainScreen].bounds.size.height){W = 667;  }else{W = 414;}}else{W = [[UIScreen mainScreen] bounds].size.width;}W;})
#define hhhh ({CGFloat H = 0;if(ispad == YES){if([UIScreen mainScreen].bounds.size.width > [UIScreen mainScreen].bounds.size.height){H = 414; }else{H = 667;}}else{H = [[UIScreen mainScreen] bounds].size.height;}H;})
#define ispad  ({BOOL ipad = YES;if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad){ipad = YES;}else{ ipad = NO;} ipad;})
#define fontScaleW ((wwww > hhhh) ? (hhhh / 375): (wwww / 375))
#define fontScaleH ((wwww > hhhh) ? (hhhh / 375): (hhhh / 667))

//颜色色值
#define SetColor(color,a) [UIColor colorwithHExString:[NSString stringWithFormat:@"%@",color] alpha:a]

//字体
#define SystemBoldFont(FONTSIZE) [UIFont boldSystemFontOfSize:FONTSIZE]
#define SystemFont(FONTSIZE) [UIFont systemFontOfSize:FONTSIZE]
#define Font(NAME,FONTSIZE) [UIFont fontWithName:(NAME) size:(FONTSIZE)]
#define HNFont(a) [UIFont fontWithName:@"PingFangTC-Regular" size:(a)]
#define HNMediumFont(a) [UIFont fontWithName:@"PingFangTC-Medium" size:(a)]
#define HNBoldFont(a) [UIFont fontWithName:@"PingFangTC-Semibold" size:(a)]
#define HNPasswordFont(a) [UIFont fontWithName:@"Menlo-Bold" size:(a)]

//设置View的圆角和边框
#define kViewBorderRadius(View, Radius, Width, Color)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES];\
[View.layer setBorderWidth:(Width)];\
[View.layer setBorderColor:[Color CGColor]]

//设置view的圆角
#define kViewRadius(View,Radius)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES]

//由角度转换弧度 由弧度转换角度
#define kDegreesToRadian(x) (M_PI * (x) / 180.0)
#define kRadianToDegrees(radian) (radian*180.0)/(M_PI)


//获取图片资源
#define kGetImage(imageName) [UIImage imageNamed:[NSString stringWithFormat:@"%@",imageName]]

//获取当前语言
#define kCurrentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0])

//拼接字符串
#define NSStringFormat(format,...) [NSString stringWithFormat:format,##__VA_ARGS__]

//是否为空对象
#define kObjectIsNil(__object)     ((nil == __object) || [__object isKindOfClass:[NSNull class]])

//字符串为空
#define kStringIsEmpty(__string)    (((__string) == nil) || ([(__string) isEqual:[NSNull null]]) ||([(__string)isEqualToString:@""]))

//字符串为空时,返回为@""不为null
#define NOTNULLString(str) (kStringIsEmpty(str)?@"":str)

#define NOTNULLObject(obj) (kObjectIsNil(obj)?@"":obj)

#define NOTNULLArray(obj) (KArrIsEmpty(obj)?@[]:obj)

// Integer转字符串
#define IntegerToString(number) [NSString stringWithFormat:@"%ld",number]

//数组是否为空
#define KArrIsEmpty(_ref)    (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]) ||([(_ref) count] == 0) )

//是否是字典
#define ValidDict(f) (f!=nil && [f isKindOfClass:[NSDictionary class]])

//发送通知
#define KPostNotification(name,obj) [[NSNotificationCenter defaultCenter] postNotificationName:name object:obj];

//HTTP 状态码
#define kHTTPStatusCode(task1) ([(NSHTTPURLResponse *)(task1).response statusCode])

//金额数字转含千位符的字符串
#define HSDecimal(string) [[NSDecimalNumber alloc] initWithString:string]

//缩短国际化文字代码
#define HSLocalizedString(key) NSLocalizedString(key, nil)
//金额数字转含千位符的字符串
#define HSMoneyString(money) [NSString stringMoney2Formatter:money]
//含千位符的字符串去除千位分割符
#define HSGetMoneyString(str) [str stringByReplacingOccurrencesOfString:@"," withString:@""]

//单例化一个类
#define SINGLETON_FOR_HEADER(className) \
\
+ (className *)shared##className;

#define SINGLETON_FOR_CLASS(className) \
\
+ (className *)shared##className { \
static className *shared##className = nil; \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
shared##className = [[self alloc] init]; \
}); \
return shared##className; \
}
#define  isNotNullOrNil(A) !( A == nil || [A isKindOfClass:[NSNull class]])//判断是否为空或NSNull的类型
#endif /* UtilsMacros_h */

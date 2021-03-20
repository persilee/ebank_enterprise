//
//  SigningEyeSDK.h
//  SigningEyeSDK
//
//  Created by 大锅 on 2019/12/31.
//  Copyright © 2019 大锅. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SEInitResult.h"


NS_ASSUME_NONNULL_BEGIN

@protocol SigningESDKDelegate <NSObject>

-(void)SigningESDKinitResult:(SEInitResult *)result;

@end

@interface SigningESDK : NSObject


@property (nonatomic, weak)id<SigningESDKDelegate> delegate;

+ (SigningESDK *)sharedInstance;


/**
 初始化
 */
- (void)initSDK;

/**
 初始化是否成功
 @return 初始化是否成功
 */
- (BOOL)isInitSuccess;

/**
 反初始化
 */

- (void)uninit;

@end

NS_ASSUME_NONNULL_END

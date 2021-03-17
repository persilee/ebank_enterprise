//
//  SEVideoError.h
//  SigningEyeSDK
//
//  Created by 大锅 on 2020/1/6.
//  Copyright © 2020 大锅. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SEVideoError : NSObject

@property (nonatomic, readonly, copy) NSString *desc; //获取本地化描述
@property (nonatomic, readonly, assign) SEVIDEOSDK_ERR_DEF errorType; //获取本地化描述


+ (instancetype)errorWithErrorType:(SEVIDEOSDK_ERR_DEF)errorType Desc:(NSString *)desc;

@end

NS_ASSUME_NONNULL_END

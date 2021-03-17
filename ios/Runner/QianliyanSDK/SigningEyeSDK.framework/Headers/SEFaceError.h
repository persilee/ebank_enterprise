//
//  SEFaceError.h
//  SigningEyeSDK
//
//  Created by Vito on 2020/4/14.
//  Copyright © 2020 大锅. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SEFaceError : NSObject

/*
 错误发生的地方, 具体的发生地方由上面定义的 WBFaceErrorDomainXXXX 指定
 */
@property (nonatomic, readonly, copy) NSString *domain;
/**
 每个domain中有相应的错误代码, 具体的错误代码见
 */
@property (nonatomic, readonly, assign) NSInteger code; //错误代码
@property (nonatomic, readonly, copy) NSString *desc; //获取本地化描述
@property (nonatomic, readonly, copy) NSString *reason; // 错误出现的真实原因原因
@property (nonatomic, readonly, copy) NSDictionary * _Nullable otherInfo;// 预留接口


+ (instancetype)errorWithDomain:(NSString *)domain code:(NSInteger)code desc:(NSString *)desc;
+ (instancetype)errorWithDomain:(NSString *)domain code:(NSInteger)code desc:(NSString *)desc reason:(NSString *)reason;
+ (instancetype)errorWithDomain:(NSString *)domain code:(NSInteger)code desc:(NSString *)desc reason:(NSString *)reason otherInfo:(nullable NSDictionary *)otherInfo;

@end

NS_ASSUME_NONNULL_END

//
//  SEInitResult.h
//  SigningEyeSDK
//
//  Created by vito on 2020/2/11.
//  Copyright © 2020 大锅. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SEInitResult : NSObject

@property (nonatomic, assign, readonly) BOOL isSuccess;
@property (nonatomic, strong, readonly) NSString *desc;

+(instancetype)resultWithIsSuccess:(BOOL)isSuccess desc:(NSString *)desc;

@end

NS_ASSUME_NONNULL_END

//
//  WBFaceVerifyResult.h
//  Pods
//
//  Created by pp on 2017/8/22.
//
//

#import <UIKit/UIKit.h>
#import "WBFaceError.h"

/**
 人脸服务返回结果对象
 */
@interface WBFaceVerifyResult : NSObject
/**
 人脸比对结果是否通过:

 YES: 表示人脸服务通过
 NO:  表示人脸服务不通过lo
 */
@property (nonatomic, assign, readonly) BOOL isSuccess;
@property (nonatomic, copy, readonly) NSString *orderNo;

/**
 isSuccess == YES 时, sign有值, 通过该sign可以去后台拉取本次人脸服务的照片,视频存证
 isSuccess == NO  时, sign 无意义
 */
@property (nonatomic, copy, readonly) NSString * sign;
/**
 活体检测服务得分

 isSuccess == YES 时, liveRate 有值:
        1. liveRate 可能是 @"分数为空", 这种情况具体咨询合作方
        2. float类型的字符串, 请调用 [liveRate floatValue] 获取具体分数
 isSuccess == NO  时, liveRate 无意义
 */
@property (nonatomic, copy, readonly) NSString * liveRate;

/**
 人脸比对服务得分

 isSuccess == YES 时, similarity 有值:
         1. similarity 可能是 @"分数为空", 这种情况具体咨询合作方
         2. float类型的字符串, 请调用 [similarity floatValue] 获取具体分数
 isSuccess == NO  时, similarity 无意义
 */
@property (nonatomic, copy, readonly) NSString * similarity;

/**
 人脸比对图片之一

 isSuccess == YES 时, 该属性是上送比对图片之一UIImage的base64编码字符串(图片格式是jpg)
 注意: userImageString 在WBFaceVerifyLivingType_Action和WBFaceVerifyLivingType_Light模式下有值,在WBFaceVerifyLivingType_Number中无结果

 isSuccess == NO  时, 该属性为nil
 */
@property (nonatomic, copy, readonly) NSString * userImageString;

/**
 isSuccess == YES 时候, error 无意义
 isSuccess == NO  时, error中存储的具体错误信息,参考 WBFaceError.h
 */
@property (nonatomic, strong, readonly) WBFaceError * error;

+(instancetype)resultWith:(BOOL)isSuccess error:(WBFaceError *)error;
+(instancetype)resultWith:(BOOL)isSuccess error:(WBFaceError *)error sign:(NSString *)sign;
+(instancetype)resultWith:(BOOL)isSuccess error:(WBFaceError *)error sign:(NSString *)sign liveRate:(NSString *)liveRate similarity:(NSString *)similarity;
+(instancetype)resultWith:(BOOL)isSuccess error:(WBFaceError *)error sign:(NSString *)sign liveRate:(NSString *)liveRate similarity:(NSString *)similarity userImageString:(NSString *)userImageString;

-(NSString *)description;
@end

//
//  SEVideoResult.h
//  SigningEyeSDK
//
//  Created by 大锅 on 2020/1/10.
//  Copyright © 2020 大锅. All rights reserved.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN
@class SEVideoError;

/// 视频面签结果
@interface SEVideoResult : NSObject

/**
 选择的面签方式
 */
@property (nonatomic, assign, readonly) SEInterviewType interviewType;

/**
 只有面签方式选择自助的时候有值
 YES: 表示自助面签的视频上传成功
 NO:  表示自助面签的视频没有上传，存在本地（自助面签结束的时候，点击退出系统）
 */
@property (nonatomic, assign, readonly) BOOL videoUploadOrNot;

/**
 业务ID
 */
@property (nonatomic, copy, readonly) NSString *businessID;

/**
 经纬度
 */
@property (nonatomic, copy, readonly) NSString * latitudeLongitude;

/**
 地理位置信息
 */
@property (nonatomic, copy, readonly) NSString *locationInformation;

/**
认证结果
{@"positive":positiveStr,@"back":backStr,@"icon":@"",@"isSuccess":@"1"};
positive 正面  图片base64
 back 反面   图片base64
 icon 人脸   图片base64
 videoUrl 录制视频路径
 isSuccess 是否成功  0失败 1 成功  2正在审核
 */
@property (nonatomic, copy, readonly) NSString * certificationResul;

/**
 本地视频名称
 */
@property (nonatomic, copy, readonly) NSString *localVideoName;

/**
 是否从本地沙盒中上传
 */
@property (nonatomic, assign, readonly)BOOL uploadFromLocal;

/**
 错误信息
 */
@property (nonatomic, strong, readonly) SEVideoError * error;

+ (instancetype)resultWithBusinessID:(NSString *)businessID error:(SEVideoError *)error;

+(instancetype)resultWithBusinessID:(NSString *)businessID certificationResul:(NSString *)certificationResuljosn interviewType:(SEInterviewType)interviewType videoUploadOrNot:(BOOL)videoUploadOrNot error:(SEVideoError *)error;

+ (instancetype)resultWithBusinessID:(NSString *)businessID interviewType:(SEInterviewType)interviewType error:(SEVideoError *)error;

+ (instancetype)resultWithBusinessID:(NSString *)businessID interviewType:(SEInterviewType)interviewType videoUploadOrNot:(BOOL)videoUploadOrNot error:(SEVideoError *)error;

+(instancetype)resultWithBusinessID:(NSString *)businessID localVideoName:(NSString *)localVideoName interviewType:(SEInterviewType)interviewType videoUploadOrNot:(BOOL)videoUploadOrNot error:(SEVideoError *)error;

+(instancetype)resultWithBusinessID:(NSString *)businessID uploadFromLocal:(BOOL)uploadFromLocal localVideoName:(NSString *)localVideoName interviewType:(SEInterviewType)interviewType videoUploadOrNot:(BOOL)videoUploadOrNot error:(SEVideoError *)error;

@end

NS_ASSUME_NONNULL_END

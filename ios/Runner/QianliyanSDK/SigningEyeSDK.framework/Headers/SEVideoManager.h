//
//  SEVideoManager.h
//  TSDK
//
//  Created by 大锅 on 2019/12/20.
//  Copyright © 2019 大锅. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SEFaceVerifyData.h"
#import "SEInterviewData.h"
#import "SEFaceVerifyResult.h"

NS_ASSUME_NONNULL_BEGIN

@class SEVideoResult;

@protocol SEVideoManagerDelegate <NSObject>

@optional

/// 视频面签的数据
-(SEInterviewData *)SEVideoServiceWithInterviewData;

/// 人脸识别的数据从这个代理方法中取
-(SEFaceVerifyData *)SEVideoServiceWithFaceVerifyData;


/// 业务系统根据人脸识别的结果给出是否继续视频面签的服务，如果不实现这个代理方法，默认人脸识别结果不影响流程
/// @param faceVerifyResult 人脸识别的结果
-(BOOL)SEVideoServiceContinueWithFaceVerifyResult:(SEFaceVerifyResult *)faceVerifyResult;

/// 页面是否有继续识别按钮。多人人脸识别的时候显示
-(BOOL)SEVideoServiceHasNext;

/// 人脸结果页，继续人脸识别按钮点击
-(void)SEVideoServiceNextClick;

///业务主要人员的人脸识别结果
-(SEFaceVerifyResultType)SEVideoServiceMainFaceVerifyResult;

//防出框功能的原图片（base64）
-(NSString *)SEVideoServiceCheckBoxSourcePhotoStr;


//视频服务结束的方法
-(void)SEVideoServiceDidFinishedWithResult:(SEVideoResult *)videoResult;

@end


@interface SEVideoManager : NSObject

@property (nonatomic, weak)id<SEVideoManagerDelegate> delegate;

+ (SEVideoManager *)sharedInstance;

/**
 
 调起服务
 
@param tenantID 租户ID
@param contractID 合同ID
@param businessID 业务ID
 @param extension 不需要传值

 */
-(void)videoWithTenantID:(NSString *)tenantID contractID:(nullable NSString *)contractID businessID:(NSString *)businessID extension:(nullable NSDictionary *)extension;


/**
 上传视频
 
 @param videoName 视频名称
 @param tenantID 租户ID
 @param contractId 合同ID
 @param businessID 业务ID
 */

-(void)uploadVideoWithVideoName:(NSString *)videoName
                       tenantID:(NSString *)tenantID
                     contractId:(NSString *)contractId
                     businessID:(NSString *)businessID;

@end

NS_ASSUME_NONNULL_END

//
//  SECertificationDataModel.h
//  SigningEyeSDK
//
//  Created by 张洪福 on 2021/3/18.
//  Copyright © 2021 大锅. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SECertificationDataModel : NSObject

@property (nonatomic, assign)BOOL isSuccess;//是否成功
@property (nonatomic, copy) NSString * positiveImage;//正面照片
@property (nonatomic, copy) NSString * backImage;//反面照片
@property (nonatomic, copy) NSString * videoUrl;//香港证件录制的本地视频路径
@property (nonatomic, copy) NSDictionary * infoStr;//证件信息
@property (nonatomic, copy) NSArray * speechFlowData;//ai对话数据
@property (nonatomic, copy) NSArray * compareImageData;//ai对比图片数据
@property (nonatomic, copy) NSString * certificateType;//证件类型
@property (nonatomic, copy) NSString * headerImg;//大头照
@property (nonatomic, copy) NSString * fileName;//ai录制后视频名称
@property (nonatomic, copy) NSString * tenant_id;//租户id
@property (nonatomic, copy) NSString * business_id;//业务编号
@property (nonatomic, copy) NSString * outCode;//错误编号
@property (nonatomic, copy) NSString * errorMessage;//错误信息解释


@end

NS_ASSUME_NONNULL_END

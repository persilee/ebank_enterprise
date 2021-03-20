//
//  SEFaceVerifyData.h
//  SigningEyeSDK
//
//  Created by 大锅 on 2020/1/6.
//  Copyright © 2020 大锅. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SESDK_Def.h"

NS_ASSUME_NONNULL_BEGIN

/**
    如果需要人脸识别的功能，姓名 name 和证件号 idNo 必传，
    人脸识别结果sourcePhotoStr 为非不传，
    sourcePhotoStr参数有值：使用合作伙伴提供的比对源照片进行比对，必须注照片是正脸可信照片，照片质量由合作方保证。参数为空 ：根据身份证号 + 姓名使用权威数据源比对
 
     如果没有人脸识别的功能，后面想要实现人员搜索的功能，需要传sourcePhotoStr，传的比对源图片上传到后台，后台放到腾讯的人员库中。
 */

@interface SEFaceVerifyData : NSObject

@property (nonatomic)BOOL hasFaceVerFunc;
@property(nonatomic, assign)SEFaceVerifyResultType faceVerifyResultType;//人脸识别结果
@property (nonatomic, copy)NSString *name;//姓名
@property (nonatomic, copy)NSString *idNo;//证件号
@property (nonatomic, copy)NSString *sourcePhotoStr;// BASE64String 比对源照片，注意：原始图片不能超过 500k，且必须为 JPG 或 PNG 格式。 参数有值：使用合作伙伴提供的比对源照片进行比对，必须注照片是正脸可信照片，照片质量由合作方保证。参数为空 ：根据身份证号 + 姓名使用权威数据源比对


@end

NS_ASSUME_NONNULL_END

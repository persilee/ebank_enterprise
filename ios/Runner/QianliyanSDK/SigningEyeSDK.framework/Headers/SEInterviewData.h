//
//  SEInterviewData.h
//  SigningEyeSDK
//
//  Created by 大锅 on 2020/1/6.
//  Copyright © 2020 大锅. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN



@interface SEInterviewData : NSObject

//面签的类型，分为 自助面签、远程面签、自助面签和远程面签、证件识别
@property (nonatomic, assign)SEInterviewType interviewType;//不能为空
@property (nonatomic, assign)SELanguageType languageType;//简体中文 繁体中文 英文不能为空
@property (nonatomic, copy)NSString * code;//护照AI话术ID不能为空
@property (nonatomic, copy)NSString * errAIcode;//识别错误AI话术ID不能为空
//远程面签必填队列编号、用户账号
@property (nonatomic, copy)NSString *queueID;
@property (nonatomic, copy)NSString *userName;//不能为空。
@property (nonatomic, copy)NSString *tenantName;//水印标签(公司名字)不能为空。
@property (nonatomic, assign)SECertificateType certificateType;//不传值进入选择页面

//自助面签视频播放列表和朗读声明的文字都是非必填
@property (nonatomic, copy)NSArray *videoArray;//这个是自助面签时播放的视频数组，数组中是可播放的视频地址。如果有值就播放视频，如果没有值就不播放
@property (nonatomic, copy)NSString *statementStr;//朗读声明的文字内容。如果有值，有朗读声明的部分，如果没有值不进行朗读声明
@property (nonatomic, assign)BOOL isShowImg;//是否显示提示文字不能为空
@property (nonatomic, assign)BOOL isAgain;//是否显示再试一次按钮不能为空
@property (nonatomic, copy) NSString * remotelyRiskVoideUrl;//必须为HTTPS并且坐席端同域)

@end

NS_ASSUME_NONNULL_END

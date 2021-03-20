//
//  WBFaceVerifyCompareSourceConfig.h
//  WBCloudReflectionFaceVerify
//
//  Created by pp on 2017/11/22.
//

#import <Foundation/Foundation.h>

@interface WBFaceVerifyCompareSourceConfig: NSObject
/**
 自带比对源图片, 请注意 自带比对源图片的大小不能超过2M
 */
@property (nonatomic, strong, readonly) UIImage * sourceImage;
/**
 自带比对源图片是否是高清图,默认: YES

 如果是公安系统网文图,请设置isHDImage = NO;
 */
@property (nonatomic, assign, readonly) BOOL isHDImage;

/**
 比对源图片大小超过2M时, 是否支持SDK自动压缩该图到2M以内, 默认: YES
 */
@property (nonatomic, assign, readonly) BOOL canCompressSourceImage;
-(void)setSourceImage:(UIImage *)sourceImage;

/**
 生成自带比对源配置对象

 默认配置 isHDImage = YES, canCompressSourceImage = YES;

 @param sourceImage 比对源图片
 @return 返回WBFaceVerifyCompareSourceConfig对象
 */
+(instancetype)compareSouceConfigWithImage:(UIImage *)sourceImage;

/**
 生成自带比对源配置对象

 @param sourceImage 比对源图片
 @param isHDImage 自带比对源图片是否是高清图,如果是公安系统网文图,请设置isHDImage = NO;
 @param canCompressSourceImage 图片大小超过2M时, 是否支持SDK自动压缩该图到2M以内
 @return 返回WBFaceVerifyCompareSourceConfig对象
 */
+(instancetype)compareSouceConfigWithImage:(UIImage *)sourceImage isHDImage:(BOOL)isHDImage canCompressSourceImage:(BOOL)canCompressSourceImage;
@end

#import <UIKit/UIKit.h>
#import "YTMacro.h"

#if IncludeUImageCvMat

#import "NextCV/Mat.h"

@interface UIImage (YTCvMat)
/**
 *@deprecated use yt_mat instead
 */
-(ncv::Mat)getCVMat __attribute__((deprecated));

/**
 *@deprecated use yt_rgbMat instead
 */
-(ncv::Mat)getCVRGBMat __attribute__((deprecated));

/**
 *@deprecated use yt_grayMat instead
 */
-(ncv::Mat)getCVGrayscaleMat __attribute__((deprecated));

/**
 *@deprecated use yt_imageWithCVMat instead
 */
+ (UIImage *)initWithCVMat:(const ncv::Mat&)cvMat __attribute__((deprecated));


-(ncv::Mat)yt_mat;
-(ncv::Mat)yt_rgbMat;
-(ncv::Mat)yt_grayMat;
+ (UIImage *)yt_imageWithCVMat:(const ncv::Mat&)cvMat;


@end

#endif

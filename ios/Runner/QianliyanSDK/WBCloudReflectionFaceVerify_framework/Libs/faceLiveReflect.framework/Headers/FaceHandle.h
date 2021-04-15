//
//  FaceHandle.h
//  FaceVideoTest
//
//  Created by PanCheng on 02/03/2017.
//  Copyright © 2017 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <vector>
#import <CoreMedia/CoreMedia.h>
#import "DataDef.h"
#include <NextCV/Mat.h>
#include <NextCV/NCVCommon.h>


#define WBYTVERSION "20210203"


#ifndef FaceHandle_h
#define FaceHandle_h
using namespace std;

typedef void (^setARGB)(uint argb1, CGFloat light1, uint argb2 , CGFloat light2);
typedef void (^updateDeviceSetting)(long expTime1000thSec, int isoValue);
typedef void (^stopDraScreen)();
/*
 return false if you want to end the process
 */
typedef bool (^doDetectFaceReflect)(UIImage* faceImage, NSMutableArray* landmarksVec,int ind);


@interface FaceHandle : NSObject

+(instancetype)sharedInstance;
+ (void)clearInstance;  //清理实例

- (void)initAG:(bool)Quality_Enhance;

- (void)clearAG;    //清理AG内的数据

- (double)Get_ISObackup;

- (void)setAGLabelShowing:(int) value;

- (int)getAGLabelShowing;

- (DataPack)getAGInDataPack;

- (ncv::Mat)getBestImg;

- (NSTimeInterval)getTimeIntercal;

- (void)setCurUserName:(NSString *)tmpName;

- (NSString*)getDirPath;

- (NSInteger) GenDataPack;

void GetBBox(vector<int> LandMarkX, vector<int> LandMarkY, int offsety, int offsetx, int height, int width, int* bbox );

- (float) get_face_sharp_score:(const ncv::Mat)rgb;

- (ncv::Mat) FindBestImg;

/*
 return: 0  success.
        -1  doDetectFaceReflectCB return false, cause the reflect detecting process be terminated immediately.
        -1024 auth check failed.
 */
- (int)processImgSequence:(doDetectFaceReflect)doDetectFaceReflectCB;

- (void)procesDrawScreen:(NSInteger)triggerTimes withLux:(CGFloat)lux_para
            withSetARGB:(setARGB)setARGB
            withStopCB:(stopDraScreen)stopCB;

- (int)initHandle:(NSString* )configFile ;

- (void)prepareStartCountTimer:(CGFloat)deviceISO withMinISO:(CGFloat)minISO withCB:(updateDeviceSetting)cb;

//- (void)doDetectFaceForCamAdjust:(CMSampleBufferRef)buffer
 //                       withFouceDeviceCB:(focusDevice)focusDeviceCB;

- (bool)getFaces:(doDetectFaceReflect)doDetectFaceReflectCB;

- (bool)GetImgSequence:(UIImage*)faceImageCrop withDeviceISO:(CGFloat)deviceISO;

- (void)GetImgSequence_buffer:(CMSampleBufferRef)buffer
                withDeviceISO:(CGFloat )deviceISO;


@end

#endif /* FaceHandle_h */

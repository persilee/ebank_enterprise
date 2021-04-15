//
//  PoseDetect.h
//  YoutuFaceSDK
//
//  Created by PanCheng on 27/04/2017.
//  Copyright © 2017 Patrick Yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YTTrackProWB/YTTrackFaceShape.h>

@interface PoseDetect: NSObject

+ (PoseDetect *)sharedManager;

- (BOOL)livePoseDetect:(TC_FaceShape)shape withbLiveNessDetect:(BOOL&)bLivenessDetect withLiveType:(int)liveType withImg:(ncv::Mat&)img withRes:(int*)res;

- (void)resetPoseDetect;
@end

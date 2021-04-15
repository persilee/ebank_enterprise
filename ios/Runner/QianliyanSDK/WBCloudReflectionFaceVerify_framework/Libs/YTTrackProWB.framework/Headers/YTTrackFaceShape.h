//
//  YTTrackFaceShape.h
//  rpd_tracker
//
//  Created by PanCheng on 05/09/2017.
//  Copyright © 2017 Patrick Yang. All rights reserved.
//

#ifndef YTTrackFaceShape_h
#define YTTrackFaceShape_h

#include "Nextcv/Mat.h"
#include <vector>
#include <string>
#include "YTTrackCommonDefine.h"

#define FACEALIGNMENT __attribute__((visibility("default")))

using namespace YT_WB;

struct FACEALIGNMENT FaceAlignParam
{
    FaceAlignParam(){
        refine_config= yttrackpro::REFINE_CONFIG_OFF;
        net_fix_config = yttrackpro::FIX_NONE;
        movement_model_config = yttrackpro::MOVEMENT_MODEL_CONFIG_OFF;
    };
    int refine_config;
    int net_fix_config;
    int movement_model_config;
   
};

    /** The face profile landmarks ordering
     *
     *     0                            20
     *     1                            19
     *      2                          18
     *      3                          17
     *       4                        16
     *        5                     15
     *         6                   14
     *          7                 13
     *            8              12
     *              9         11
     *                   10
     */
    
    typedef struct _TC_FaceProfile
    {
        std::vector<ncv::Point2f> points;
    }TC_FaceProfile;
    
    /** The left eye and eyebrow landmarks ordering
     *
     *         7   6   5
     *    0                 4
     *         1   2   3
     */
    
    typedef struct _TC_LeftEye
    {
        std::vector<ncv::Point2f> points;
    }TC_LeftEye;
    
    typedef struct _TC_LeftEyebrow
    {
        std::vector<ncv::Point2f> points;
    }TC_LeftEyebrow;
    
    
    /** The right eye and eyebrow landmarks ordering
     *
     *         5   6   7
     *    4                 0
     *         3   2   1
     */
    
    typedef struct _TC_RightEye
    {
        std::vector<ncv::Point2f> points;
    }TC_RightEye;
    
    typedef struct _TC_RightEyebrow
    {
        std::vector<ncv::Point2f> points;
    }TC_RightEyebrow;
    
    /** The nose landmarks ordering
     *
     *           1
     *        2    12
     *      3        11
     *     4     0    10
     *    5  6  7  8   9
     */
    
    
    typedef struct _TC_Nose
    {
        std::vector<ncv::Point2f> points;
    }TC_Nose;
    
    /** The mouth landmarks ordering
     *
     *                 10   9   8
     *          11                      7
     *            21  20  19 18 17
     *    0                                    6
     *            12  13  14 15 16
     *           1                      5
     *                  2   3   4
     */
    
    
    typedef struct _TC_Mouth
    {
        std::vector<ncv::Point2f> points;
    }TC_Mouth;
    
    /** The pupils ordering
     *
     *       0                          1
     */
    typedef struct _TC_Pupil
    {
        std::vector<ncv::Point2f> points;
        
    }TC_Pupil;
    
    typedef struct _TC_FaceShape
    {
        TC_LeftEyebrow leftEyebrow;
        TC_RightEyebrow rightEyebrow;
        TC_LeftEye leftEye;
        TC_RightEye rightEye;
        TC_Nose nose;
        TC_Mouth mouth;
        TC_FaceProfile faceProfile;
        TC_Pupil pupil;
    }TC_FaceShape;
    
    
namespace YT_WB {

namespace yttrackpro{
    typedef struct
    {
        TC_FaceShape faceShape;                           // get result points by TC_FaceShape
        std::vector<float> facePointsVis;                 // get the visibility of each point, the order of points aligns to face shape order
        float cls;                                        // get the confidence level by float : 0-1(best)
        // TC_FaceShape faceShapeOri;                        // get result points before stable by TC_FaceShape (not used often)
    } YTTrackResultInfo;
    
}

}

#endif /* YTTrackFaceShape_h */

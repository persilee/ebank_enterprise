//
//  YTTrackCommonDefine.h
//  rpd_tracker
//
//  Created by PanCheng on 04/07/2017.
//  Copyright © 2017 Patrick Yang. All rights reserved.
//

#ifndef YTTrackCommonDefine_h
#define YTTrackCommonDefine_h

#define FACEDETECT_EXPORT __attribute__((visibility("default")))

namespace YT_WB {
    
struct FACEDETECT_EXPORT YtFaceDetParam
{
    YtFaceDetParam();
    int min_face_size;//default=40; (12~max)
    float scale_factor;//default=1.414f; (1.1~2.5)
    
    float net1_threshold;//default=0.9f; (0.1~1.0)
    float net2_threshold;//default=0.9f; (0.3~1.0)
    float net3_threshold;//default=0.9f; (0.5~1.0)
    float final_threshold;//default=0.93f; (0.75~1.0)
    
    int max_face_size;//default=99999999; (12~max)
    bool bigger_face_mode;//default=false; (false/true)(attention: not biggest)
    bool non_square_rect;//default=false; (false/true)
    int extend_scale_num;//default=0; (1~max)
};


namespace yttrackpro
{
    static const int TRACKPRO_OK = 0x0;
    
    //auth
    static const int AUTH_LICENCE_ERROR = 0x1000;
    
    //detect
    static const int DETECT_MODEL_PATH_ERROR = 0x1001;
    static const int DETECT_MODEL_CONTENT_ERROR = 0x1002;
    static const int DETECT_NOT_INIT =0x1003;
    static const int DETECT_INPUT_MAT_EMPTY = 0x1004;
    static const int DETECT_NET_NULL = 0x1005;
    
    //track
    static const int TRACK_MODEL_OPEN_ERROR = 0x2001;
    static const int TRACK_RPDNET_INIT_ERROR = 0x2002;
    static const int TRACK_INPUT_MAT_FORMAT_ERROR = 0x2003;
    static const int TRACK_INPUT_RECT_ERROR = 0x2004;
    static const int TRACK_INPUT_SHAPE_ERROR = 0x2005;
    
    static const int REFINE_CONFIG_OFF = 0x2005;
    static const int REFINE_CONFIG_PTS86 = 0x2006;
    static const int REFINE_CONFIG_PTS40 = 0x2007;
    
    static const int TRACK_NET_NULL = 0x2010;


    static const int FIX_NONE = 0x0;
    static const int FIX_EYE = 0x1;
    static const int FIX_EYEBROW = 0x2;
    static const int FIX_EYE_EYEBROW = 0x3;
    static const int FIX_MOUTH = 0x4;
    static const int FIX_EYE_MOUTH = 0x5;
    static const int FIX_EYEBROW_MOUTH = 0x6;
    static const int FIX_EYE_EYEBROW_MOUTH = 0x7;

    static const int MOVEMENT_MODEL_CONFIG_ON = 0x201c;
    static const int MOVEMENT_MODEL_CONFIG_OFF = 0x201d;

    //pose
    static const int POSE_MODEL_PATH_ERROR = 0x3001;
    static const int POSE_MODEL_CONTENT_ERROR = 0x3002;
    
    static const int POSE_2D_OPEN = 0x3003;
    static const int POSE_3D_OPEN = 0x3004;
    static const int POSE_OFF = 0x3005;
    
}


}


#endif /* YTTrackCommonDefine_h */

//
//  YTFaceDetection.hpp
//  YTTrackPro
//
//  Created by PanCheng on 10/11/2017.
//  Copyright © 2017 Patrick Yang. All rights reserved.
//

#ifndef YTFaceDetection_hpp
#define YTFaceDetection_hpp

#include "Nextcv/Mat.h"
#include "YTTrackCommonDefine.h"

namespace YT_WB {

#define FACEDETECT_EXPORT __attribute__((visibility("default")))
class YtFaceDetection;

class FACEDETECT_EXPORT YTFaceDetection
{
public:
    YTFaceDetection();
    ~YTFaceDetection();
    // global init
    static int GlobalInit(const std::string bundlePath);
    // global exit
    static int GlobalRelease();
    // model inforamtion
    static const char* Version();
    static const char* Md5CheckSum();
    
    /**
     * @brief do detection, pass your parameter or use defalut
     *
     * @param[in] input_rgb: 8bit depth, 3 channels;
     * @param[out] ret_face_rects: all detected faces(sort by confidence, decending order)
     *
     * @return   -1: some error occurs
     *           others: face numbers(0 or positive integer)
     * @note
     *
     */
    int Detection(const ncv::Mat & input_rgb, std::vector<ncv::Rect>& ret_face_rects);
    int Detection(const ncv::Mat & input_rgb, const YtFaceDetParam& param, std::vector<ncv::Rect>& ret_face_rects);
    
    //get the corresponding detection confidence if necessary
    std::vector<float> GetFacesConfidence();
    
private:
    YtFaceDetection * m_ytFaceDetection;
    
};

}

#endif /* YTFaceDetection_hpp */

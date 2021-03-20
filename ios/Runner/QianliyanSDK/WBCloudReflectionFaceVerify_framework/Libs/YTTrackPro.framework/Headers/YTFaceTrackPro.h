//
// Created by PanCheng on 16/05/2017.
//

#ifndef SDK_PROJ_YTFACETRACKPRO_H
#define SDK_PROJ_YTFACETRACKPRO_H

#include "Nextcv/Mat.h"
#include "YTTrackFaceShape.h"

namespace YT_WB {

class TC_FaceAlignmentRunner;

//tack
namespace ytfacetrack {
class FaceAlignment {
public:
    FaceAlignment();
    ~FaceAlignment();
    static const char* version();
    static const char* stableVersion();
    static const char* VersionRefine();
    static int globalInit(const char* path);
    static int globalInit(const unsigned char* mem);
    static void globalRelease();
    static void setFaceAlignConfig(FaceAlignParam parm);

    int faceShapeTracking(const ncv::Mat& mat, const ncv::Rect& facerect, ::yttrackpro::YTTrackResultInfo &trackResInfo);
    int faceShapeTracking(const ncv::Mat& mat, const TC_FaceShape& srcShape, ::yttrackpro::YTTrackResultInfo &trackResInfo);

private:
    TC_FaceAlignmentRunner * privateTrackInst;
};
}

}
#endif //SDK_PROJ_YTFACETRACKPRO_H

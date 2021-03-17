//
// Created by PanCheng on 16/05/2017.
//

#ifndef SDK_PROJ_YTFACEUTIL_H
#define SDK_PROJ_YTFACEUTIL_H

#include "Nextcv/Mat.h"
#include "YTTrackFaceShape.h"

namespace YT_WB {

namespace ytfacetrack {
class YTFaceUtils {
public:
    static void Convert86ptsTo90pts(TC_FaceShape& faceShape);
    static void Convert86VisptsTo90Vispts(std::vector<float>& pointsVis);
private:
};
}

}

#endif //SDK_PROJ_YTFACETRACKPRO_H

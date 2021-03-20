//
//  DataDef.h
//  FaceVideoTest
//
//  Created by starimeliu on 2017/4/13.
//  Copyright © 2017年 Tencent. All rights reserved.
//

#ifndef DataDef_h
#define DataDef_h
#include <vector>
// IN
struct ImgWithLandmarks // === N pairs of images along with their landmarks ===
{
    std::vector<int> LandMarkX;				// landmarks X
    std::vector<int> LandMarkY; 				// landmarks Y
    //	cv::Mat frame;							// need use cv::imdecode to get the Mat
    std::vector<unsigned char> frame_buffer;			// Frame data in buffer
};

struct DataPack
{
    std::vector<ImgWithLandmarks> VideoData;		// Length = 2*N
    int frameNum;							// Number of frames = 2*N
    int LandMarkNum;						// Length of landmark points = 90 here
    char *log;							// text log info
};

#endif /* DataDef_h */

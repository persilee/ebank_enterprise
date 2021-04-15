#ifndef POSEESTIMATE_H
#define POSEESTIMATE_H

//#include "TC_FaceAlignment.h"
#include "YTFaceTrackPro.h"

namespace YT_WB {

const char* pose_sdk_version();


int pose_initModel(std::string modelPath);
//该SDK需要模型文件"PE.dat", 将该文件放入到工程文件中，并放置到工程根路径下 （[[NSBundle mainBundle] resourcePath]）
int pose_estimate(const TC_FaceShape& faceshape, float& pitch, float& yaw, float& roll);

}

#endif // POSEESTIMATE_H

#ifndef FACEILLUMINATIONSCORE_H_
#define FACEILLUMINATIONSCORE_H_

#include <NextCV/Mat.h>
#include <NextCV/NCVCommon.h>
#include <YTTrackProWB/YTTrackFaceShape.h>

int get_face_illumination_score(const ncv::Mat& rgb, const TC_FaceShape& faceshape);

#endif

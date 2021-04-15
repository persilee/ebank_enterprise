#pragma once//;
#include <vector>
#include <YTTrackProWB/YTTrackFaceShape.h>
#include <NextCV/Mat.h>
#include <NextCV/NCVCommon.h>

enum PoseDirection{NONE, MIDDLE, LEFT, RIGHT};
enum PoseDirectionNode{NONE_NOD, MIDDLE_NOD, UP, DOWN};

class PoseLivenessDetector {
public:
    PoseLivenessDetector(const int &numvoter, const int &yawthresh, const int &pitchthresh, const float &mt1, const float &mt2, const float &et1, const int &t);
    ~PoseLivenessDetector();
    
    int HeadMovementNod(const TC_FaceShape & shape);
    int HeadMovement(const TC_FaceShape & shape, bool &bFound);
    int MouthMovement(const TC_FaceShape & shape);
    int EyeMovement(const TC_FaceShape & shape, ncv::Mat &Img);
    
    int RejectShaking(const TC_FaceShape & shape);
    
    int reset();
    
private:
    
    float CrossProduct(const ncv::Point2f &p, const ncv::Point2f &q);
    void GetBBox_minmax(const int* LandMarkX, const int* LandMarkY, int head, int tail, int offsety, int offsetx, int* bbox );
    
    int LastBbox[4];
    void Bbox_Intersection(const int* a, const int* b, int* Intersection);
    
    int numvoter_;
    int yawthresh_;
    int pitchthresh_;
    std::vector<PoseDirection> directionSequence_;
    std::vector<PoseDirectionNode> directionNodSequence_;
    
    std::vector<float> mouthSeq;
    std::vector<float> leftEyeSeq, rightEyeSeq, PupilMeanSeq;
    float mouthThr1, mouthThr2;
    float eyeThr1;
    
    int FreezeDetect;
    int CloseEye_Detected;
    
    int minYaw, minPitch;
};

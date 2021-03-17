//
//  MatExt.h
//  NextCV
//
//  Created by PanCheng on 27/05/2017.
//  Copyright © 2017 leo leo. All rights reserved.
//

#include "Mat.h"
#include <math.h>

namespace ncv {
    
    static Mat getRotationMatrix2Df(Point2f center, double angle, double scale)
    {
        angle *= 3.14159265 / 180;
        double alpha = cos(angle)*scale;
        double beta = sin(angle)*scale;
        
        Mat M(2, 3, CV_32FC1);
        float* m = (float*)M.data;
        
        m[0] = alpha;
        m[1] = beta;
        m[2] = (1-alpha)*center.x - beta*center.y;
        m[3] = -beta;
        m[4] = alpha;
        m[5] = beta*center.x + (1-alpha)*center.y;
        
        return M;
    }
    
    
    static Mat getRotationMatrix2D( Point2f center, double angle, double scale )
    {
        angle *= 3.14159265/180;
        double alpha = cos(angle)*scale;
        double beta = sin(angle)*scale;
        
        Mat M(2, 3, CV_64F);
        double* m = (double*)M.data;
        
        m[0] = alpha;
        m[1] = beta;
        m[2] = (1-alpha)*center.x - beta*center.y;
        m[3] = -beta;
        m[4] = alpha;
        m[5] = beta*center.x + (1-alpha)*center.y;
        
        return M;
    }
    
    static void invertAffineTransformf(const Mat& src, Mat& dst)
    {
        dst.create(2, 3, CV_32FC1);
        
        const float* M = (const float*)src.data;
        float* iM = (float*)dst.data;
        
        double D = M[0]*M[4] - M[1]*M[3];
        D = D != 0 ? 1./D : 0;
        double A11 = M[4]*D;
        double A22 = M[0]*D;
        double A12 = -M[1]*D;
        double A21 = -M[3]*D;
        double b1 = -A11*M[2] - A12*M[5];
        double b2 = -A21*M[2] - A22*M[5];
        
        iM[0] = (float)A11;
        iM[1] = (float)A12;
        iM[2] = (float)b1;
        iM[3] = (float)A21;
        iM[4] = (float)A22;
        iM[5] = (float)b2;
    }
    
    static void  invertAffineTransform(const Mat& matM, Mat& _iM)
    {
        
        _iM.create(2, 3, matM.type());
        
        if( matM.type() == CV_32F )
        {
            const float* M = (const float*)matM.data;
            float* iM = (float*)_iM.data;
            int step = (int)(matM.step/sizeof(M[0])), istep = (int)(_iM.step/sizeof(iM[0]));
            
            double D = M[0]*M[step+1] - M[1]*M[step];
            D = D != 0 ? 1./D : 0;
            double A11 = M[step+1]*D, A22 = M[0]*D, A12 = -M[1]*D, A21 = -M[step]*D;
            double b1 = -A11*M[2] - A12*M[step+2];
            double b2 = -A21*M[2] - A22*M[step+2];
            
            iM[0] = (float)A11; iM[1] = (float)A12; iM[2] = (float)b1;
            iM[istep] = (float)A21; iM[istep+1] = (float)A22; iM[istep+2] = (float)b2;
        }
        else if( matM.type() == CV_64F )
        {
            const double* M = (const double*)matM.data;
            double* iM = (double*)_iM.data;
            int step = (int)(matM.step/sizeof(M[0])), istep = (int)(_iM.step/sizeof(iM[0]));
            
            double D = M[0]*M[step+1] - M[1]*M[step];
            D = D != 0 ? 1./D : 0;
            double A11 = M[step+1]*D, A22 = M[0]*D, A12 = -M[1]*D, A21 = -M[step]*D;
            double b1 = -A11*M[2] - A12*M[step+2];
            double b2 = -A21*M[2] - A22*M[step+2];
            
            iM[0] = A11; iM[1] = A12; iM[2] = b1;
            iM[istep] = A21; iM[istep+1] = A22; iM[istep+2] = b2;
        }
        else{
            printf("un supported format.\n");
        }
        //   CV_Error( CV_StsUnsupportedFormat, "" );
    }
    
    
    
    static void transform_points(std::vector<Point2f>& points, const Mat& m)
    {
        const float* mptr = (const float*)m.data;
        const float m0 = mptr[0];
        const float m1 = mptr[1];
        const float m2 = mptr[2];
        const float m3 = mptr[3];
        const float m4 = mptr[4];
        const float m5 = mptr[5];
        
        for (size_t i=0; i<points.size(); i++)
        {
            float x = points[i].x;
            float y = points[i].y;
            
            points[i].x = x * m0 + y * m1 + m2;
            points[i].y = x * m3 + y * m4 + m5;
        }
    }
    
    static void warpaffine_bilinear_c1(const Mat& src, Mat& dst, const Mat& tm, const Size& size, int flags)
    {
        dst.create(size.height, size.width, CV_8UC1);
        
        float* m = (float*)tm.data;
        
        for (int y=0; y<dst.rows; y++)
        {
            unsigned char* ptr = dst.ptr(y);
            
            float X = m[1] * y + m[2];
            float Y = m[4] * y + m[5];
            
            for (int x=0; x<dst.cols; x++)
            {
                //             float X = m[0] * x + m[1] * y + m[2];
                //             float Y = m[3] * x + m[4] * y + m[5];
                
                int Xf = X;
                int Yf = Y;
                
                if (Xf < 0 || Yf < 0 || Xf >= src.cols - 1 || Yf >= src.rows - 1)
                {
                    ptr[0] = 0;
                    ptr += 1;
                    
                    X += m[0];
                    Y += m[3];
                    
                    continue;
                }
                
                int Xc = X + 1;
                int Yc = Y + 1;
                
                float sx = X - Xf;
                float sy = Y - Yf;
                
                short alpha0 = (1.f - sx) * (1<<11);
                short alpha1 = sx * (1<<11);
                short beta0 = (1.f - sy) * (1<<11);
                short beta1 = sy * (1<<11);
                
                const unsigned char* p0 = src.ptr(Yf) + Xf;
                const unsigned char* p1 = src.ptr(Yf) + Xc;
                const unsigned char* p2 = src.ptr(Yc) + Xf;
                const unsigned char* p3 = src.ptr(Yc) + Xc;
                
                short q00 = (p0[0] * alpha0 + p1[0] * alpha1) >> 4;
                
                short q10 = (p2[0] * alpha0 + p3[0] * alpha1) >> 4;
                
                unsigned char q0 = (((q00 * beta0) >> 16) + ((q10 * beta1) >> 16) + 2) >> 2;
                
                ptr[0] = q0;
                ptr += 1;
                
                X += m[0];
                Y += m[3];
            }
        }
        
    }
    
    static void warpaffine_bilinear_c3(const Mat& src, Mat& dst, const Mat& tm, const Size& size, int flags)
    {
        dst.create(size.height, size.width, CV_8UC3);
        
        float* m = (float*)tm.data;
        
        for (int y=0; y<dst.rows; y++)
        {
            unsigned char* ptr = dst.ptr(y);
            
            float X = m[1] * y + m[2];
            float Y = m[4] * y + m[5];
            
            for (int x=0; x<dst.cols; x++)
            {
                //             float X = m[0] * x + m[1] * y + m[2];
                //             float Y = m[3] * x + m[4] * y + m[5];
                
                int Xf = X;
                int Yf = Y;
                
                if (Xf < 0 || Yf < 0 || Xf >= src.cols - 1 || Yf >= src.rows - 1)
                {
                    ptr[0] = 0;
                    ptr[1] = 0;
                    ptr[2] = 0;
                    ptr += 3;
                    
                    X += m[0];
                    Y += m[3];
                    
                    continue;
                }
                
                int Xc = X + 1;
                int Yc = Y + 1;
                
                float sx = X - Xf;
                float sy = Y - Yf;
                
                short alpha0 = (1.f - sx) * (1<<11);
                short alpha1 = sx * (1<<11);
                short beta0 = (1.f - sy) * (1<<11);
                short beta1 = sy * (1<<11);
                
                const unsigned char* p0 = src.ptr(Yf) + Xf * 3;
                const unsigned char* p1 = src.ptr(Yf) + Xc * 3;
                const unsigned char* p2 = src.ptr(Yc) + Xf * 3;
                const unsigned char* p3 = src.ptr(Yc) + Xc * 3;
                
                short q00 = (p0[0] * alpha0 + p1[0] * alpha1) >> 4;
                short q01 = (p0[1] * alpha0 + p1[1] * alpha1) >> 4;
                short q02 = (p0[2] * alpha0 + p1[2] * alpha1) >> 4;
                
                short q10 = (p2[0] * alpha0 + p3[0] * alpha1) >> 4;
                short q11 = (p2[1] * alpha0 + p3[1] * alpha1) >> 4;
                short q12 = (p2[2] * alpha0 + p3[2] * alpha1) >> 4;
                
                unsigned char q0 = (((q00 * beta0) >> 16) + ((q10 * beta1) >> 16) + 2) >> 2;
                unsigned char q1 = (((q01 * beta0) >> 16) + ((q11 * beta1) >> 16) + 2) >> 2;
                unsigned char q2 = (((q02 * beta0) >> 16) + ((q12 * beta1) >> 16) + 2) >> 2;
                
                ptr[0] = q0;
                ptr[1] = q1;
                ptr[2] = q2;
                ptr += 3;
                
                X += m[0];
                Y += m[3];
            }
        }
        
    }
    
    
    
    
    
    
    
    
}

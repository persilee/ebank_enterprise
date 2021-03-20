#ifndef RAPIDNET_INCLUDE_SHARED_BLOB_H_
#define RAPIDNET_INCLUDE_SHARED_BLOB_H_

#include <string>
#include <string.h>
#include <cassert>
#include <memory>
#include "smart_pointers/shared_ptr.h"
#include "platforms/platforms.h"
//#include "platforms/platforms_build.h"

namespace RPNNameSpace {

    template <typename T>
    class SharedBlob
    {
    public:
        SharedBlob(int num, int channel, int height, int width):data_(new T[num*channel*height*width], deleter)
        {
            shape_[0] = num;
            shape_[1] = channel;
            shape_[2] = height;
            shape_[3] = width;
        }

        ~SharedBlob() {}

        inline int offset(const int n, const int c = 0, const int h = 0,const int w = 0) const
        {
            return ((n * shape_[1] + c) * shape_[2] + h) * shape_[3] + w;
        }

        inline std::string& name(){
            return blob_name_;
        }

        inline int num()const{
            return shape_[0];
        }

        inline int channel()const{
            return shape_[1];
        }

        inline int height()const{
            return shape_[2];
        }

        inline int width()const{
            return shape_[3];
        }

        inline T* data(){
            return data_.get();
        }

        inline const T* data() const {
            return data_.get();
        }

        inline void set_name(const std::string& name){
            blob_name_ = name;
        }

        inline const int* shape()const{
            return shape_;
        }
        
        inline int count(int start, int end = shape_dimension_) const
        {
            if (start < 0 || start > shape_dimension_){
                return 0;
            }
            if (end < 0 || end > shape_dimension_){
                return 0;
            }
            int size = 1;
            for (int i = start; i < end; i++)
            {
                size *= shape_[i];
            }
            return size;
        }

        inline int count() const
        {
            return shape_[0] * shape_[1] * shape_[2] * shape_[3];
        }

        inline void set_shape(int* shape)
        {
            memcpy(shape_, shape, shape_dimension_ * sizeof(int));
        }

        const static int shape_dimension_ = 4;

        static void deleter(T* p)
        {
            delete[] p;
        }

    private:
        int shape_[shape_dimension_];
        smart_pointers::shared_ptr<T> data_;
        std::string blob_name_;
    };
}

#endif // RAPIDNET_INCLUDE_SHARED_BLOB_H_

#ifndef RAPIDNET_INCLUDE_RPDBLOB_H_
#define RAPIDNET_INCLUDE_RPDBLOB_H_

#include <stdlib.h>
#include <string>
#include <string.h>
#include <cassert>
#include <vector>
#include "platforms/platforms.h"

namespace RPNNameSpace {

    enum eshape_id
    {
        lnum = 0,
        lchannel = 1,
        lheight = 2,
        width = 3
    };

    struct blob_shape {
    public:
        blob_shape(){}
        ~blob_shape(){}

        void clear()
        {
            dim_.clear();
        }

        int dim_size() const
        {
            return dim_.size();
        }

        void clear_dim()
        {
            dim_.clear();
        }

        int dim(int index) const
        {
            return dim_[index];
        }

        void set_dim(int index, int value)
        {
            dim_[index] = value;
        }

        void add_dim(int value)
        {
            dim_.push_back(value);
        }

        const std::vector<int>& dim() const
        {
            return dim_;
        }

        const std::vector<int>* mutable_dim()
        {
            return &dim_;
        }

    private:
        std::vector<int> dim_;
    };

    enum rpd_blob_data_type{
        FLOAT32_BLOB_DATA,
        INT8_BLOB_DATA,
        INT32_BLOB_DATA
    };

    template <typename T>
    class rpd_blob
    {
    public:
        rpd_blob():data_ (NULL), data_type_(FLOAT32_BLOB_DATA) {
            memset(shape_, 0, shape_dimension_ * sizeof(int));
            channel_step_in_bytes_ = -1; // by default: invalid step
            memory_allocated_ = NULL;
        }
        ~rpd_blob() {}

    public:
        inline int offset(const int n, const int c = 0, const int h = 0,const int w = 0) const
        {
            //return ((n * shape_[1] + c) * shape_[2] + h) * shape_[3] + w;
            int channel_offset = channel_step_in_bytes_ <= 0 ? height()*width() : channel_step_in_bytes_/sizeof(T);
            return n*channel_offset*shape_[1] + c*channel_offset + h*width() + w;
        }

    public:

        inline std::string& name(){
            return blob_name_;
        }

        inline int num()const{
            return shape_[0];
        }

        inline int channel()const{
            return shape_[1];
        }

        inline T* channel(int c){
            return channel_step_in_bytes_ <= 0 ? data_ + c*height()*width() : data_ + c*(channel_step_in_bytes_/sizeof(T));
        }

        inline const T* channel(int c) const{
            return channel_step_in_bytes_ <= 0 ? data_ + c*height()*width() : data_ + c*(channel_step_in_bytes_/sizeof(T));
        }

        inline int height()const{
            return shape_[2];
        }

        inline int width()const{
            return shape_[3];
        }

        inline T* data(){
            return data_;
        }

        inline const T* data() const {
            return data_;
        }

        /*inline void set_data(T* data) {
            // Since data_ is not NULL, the overriding meay lead to memory leakage if the data_ is on the heap.
            // Let's make an assersion here to prob the overridingsss.
            //assert(data_ == NULL || data == NULL);
            data_ = data;
        }*/

        inline void set_data(const T* data) {
            // Since data_ is not NULL, the overriding meay lead to memory leakage if the data_ is on the heap.
            // Let's make an assersion here to prob the overridingsss.
            //assert(data_ == NULL || data == NULL || data_ == data);
            data_ = const_cast<T*>(data);
        }

        inline void set_name(const std::string& name){
            blob_name_ = name;
        }

        inline void set_num(int num){
            shape_[0] = num;
        }

        inline void set_channels(int channels){
            shape_[1] = channels;
        }

        inline void set_height(int height){
            shape_[2] = height;
        }

        inline void set_width(int width){
            shape_[3] = width;
        }

        inline int* shape(){
            return shape_;
        }

        inline int shape(int axis){
            return shape_[axis];
        }

        std::vector<int> shapes(){
            std::vector<int> shapes;

            shapes.push_back(shape_[0]);
            shapes.push_back(shape_[1]);
            shapes.push_back(shape_[2]);
            shapes.push_back(shape_[3]);
            return shapes;
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

        bool need_realloc_aligned_data(std::vector<int> shapes)
        {
            do {
                if (shapes[0]*shapes[1] !=  shape_[0]*shape_[1]) {
                    break;
                }

                if (shapes[2]*shapes[3] !=  shape_[2]*shape_[3]) {
                    break;
                }
                return false;
            }while(0);
            return true;
        }

        inline void set_shape(std::vector<int> shapes)
        {
            shape_[0] = 1;
            shape_[1] = 1;
            shape_[2] = 1;
            shape_[3] = 1;

            for (int i=0; i<shapes.size(); i++) {
                shape_[i] = shapes[i];
            }

            channel_step_in_bytes_ = -1; // invalid channel step
        }

        inline void set_shape(int* shape)
        {
            memcpy(shape_, shape, shape_dimension_ * sizeof(int));
            channel_step_in_bytes_ = -1; // invalid channel step
        }

        inline void set_shape(const blob_shape shape)
        {
            int dim_size = shape.dim_size();
            if (dim_size <= 0) {
                return;
            }

            shape_[0] = 1;
            shape_[1] = 1;
            shape_[2] = 1;
            shape_[3] = 1;


            for (int i=0; i<dim_size; i++) {
                shape_[i] = shape.dim(i);
            }

            channel_step_in_bytes_ = -1; // invalid channel step
        }

        inline int channel_step_in_bytes() const{
            return channel_step_in_bytes_;
        }

        void update_channel_step_in_bytes(){
            // youngdai comments the following lines out
            // if(channel() <= 1){ // As the default blob data's rule under CPU_NEON mode, the first channel's starting address is already aligned.
            //     return;
            // }

            //const static int align_bits = 128; // 128 bit aligned
            const static int align_bytes = 16; // 128/8=16: 128 bit aligned

            int channel_data_size_in_bytes = height()*width()*sizeof(T);
            if ((channel_data_size_in_bytes % align_bytes) == 0){ // Every channel's data ***size*** is aligned, so there is no need to align each starting address.
                channel_step_in_bytes_ = channel_data_size_in_bytes;
                return;
            }

            /*if(channel_step_in_bytes_ != 0 && channel_step_in_bytes_ % align_bytes == 0){ // already aligned. prevenet multiple calling of this align function
             return;
             }*/

            // we have to ensure that the channel_step % align_bytes == 0 and channel_step should be as small as possible but >= channel_data_size_in_bytes
            channel_step_in_bytes_ = ((channel_data_size_in_bytes >> 4) + 1 ) << 4; // align_bytes is 16, so move 4.
            assert(channel_step_in_bytes_ % align_bytes == 0);
        }

        // Insert margin among channels to ensure every channel's data's starting address is aligned based on **align_bits**
        void align_data_by_channel(){
            if(num()*channel() <= 1){ // As the default blob data's rule under CPU_NEON mode, the first channel's starting address is already aligned.
                return;
            }

            //const static int align_bits = 128; // 128 bit aligned
            const static int align_bytes = 16; // 128/8=16: 128 bit aligned

            int channel_data_size_in_bytes = height()*width()*sizeof(T);
            if ((channel_data_size_in_bytes % align_bytes) == 0){ // Every channel's data ***size*** is aligned, so there is no need to align each starting address.
                return;
            }

            if(channel_step_in_bytes_ > 0 && channel_step_in_bytes_ % align_bytes == 0){ // already aligned. prevenet multiple calling of this align function
                return;
            }

            // we have to ensure that the channel_step % align_bytes == 0 and channel_step should be as small as possible but >= channel_data_size_in_bytes
            channel_step_in_bytes_ = ((channel_data_size_in_bytes >> 4) + 1 ) << 4; // align_bytes is 16, so move 4.
            assert(channel_step_in_bytes_ % align_bytes == 0);

            int margin = channel_margin();
            if (margin == 0) {
                return;
            }

            assert(margin > 0);

            // There are c channels, move the last c-1 channels ***backwards***.
            // For the i th channel, we need to move back i*margin bytes back
            for(int n = num()-1 ; n>=0; --n){
                for(int i=channel()-1; i>=0; --i){
                    T* channel_i_old_addr = data_ + i*height()*width()+n * channel()*height()*width();
                    //T* channel_i_new_addr = (T*)((char*)(channel_i_old_addr) + i*margin);
                    T* channel_i_new_addr = data_ + i*channel_step_in_bytes_/sizeof(T)+n*channel()*channel_step_in_bytes_/sizeof(T);
                    for(int j=height()*width()-1; j>=0; --j){
                        channel_i_new_addr[j] = channel_i_old_addr[j];
                    }
                }
            }
        }

        // Remove margin among channels
        void unalign_data_by_channel(){
            if(channel_step_in_bytes_ == -1) { // not aligned
                return;
            }
            int margin = channel_margin();
            if(margin == 0) { return; }

            // There are c channels, move the last c-1 channels ***forwards***.
            // For the i th channel, we need to move back i*margin bytes forward
            int channels = channel();
            for(int n = 0 ; n <num(); ++n){
                for(int i=0; i<channels; ++i){
                    T* channel_i_old_addr = data_ + i*channel_step_in_bytes_/sizeof(T) + n*channels*channel_step_in_bytes_/sizeof(T);
                    T* channel_i_new_addr = data_ + i*height()*width() + n * channels*height()*width() ;
                    for(int j=0; j<height()*width(); ++j){
                        channel_i_new_addr[j] = channel_i_old_addr[j];
                    }
                }
            }

            channel_step_in_bytes_ = -1;
        }

        void allocate_16bytes_aligned_data(int c, int h, int w, const rpd_blob<T>* source_blob = NULL){
            allocate_16bytes_aligned_data(1, c, h, w, source_blob);
        }

        void allocate_16bytes_aligned_data(int n,int c, int h, int w, const rpd_blob<T>* source_blob = NULL) {
            // suppose n = 1
            if (memory_allocated_ != NULL && n == shape_[0] && c == shape_[1] && h == shape_[2] && w == shape_[3]) {
              return;
            } else {
              deallocate_16bytes_aligned_data();
            }
            set_num(n);
            set_channels(c);
            set_height(h);
            set_width(w);

            //            if(0){
            //                int align_bytes = 16;
            //                memory_allocated_ = (T*) malloc(n*c*h*w*sizeof(T) + n*c*align_bytes);
            //                data_ = (T*) (((size_t)memory_allocated_ + align_bytes-1) & -align_bytes);
            //
            //                update_channel_step_in_bytes();
            //                LOGE("blob name :%s memsize: %d  nchw:%d %d %d %d\n",blob_name_.c_str(), (int)(n*c*h*w*sizeof(T) + n*c*align_bytes),n,c,h,w);
            //            }

            int align_bytes = 16;
            memory_allocated_ = (T*) malloc(n*c*h*w*sizeof(T) + n*c*align_bytes*2); //*2 for safety
            data_ = (T*) (((size_t)memory_allocated_ + align_bytes-1) & -align_bytes);

            update_channel_step_in_bytes();
//            assert(channel_step_in_bytes_>0);

            //    LOGE("blob name :%s memsize: %d nchw:%d %d %d %d\n",blob_name_.c_str(), (int)(n*c*channel_step_in_bytes_ + n*c*align_bytes),n,c,h,w);

            if(source_blob != NULL){
                for(int n=0; n<this->num() ;++n){
                    for(int i=0; i<this->channel(); ++i){
                        memcpy(this->data() + this->offset(n,i), source_blob->data() + source_blob->offset(n,i), source_blob->height()*source_blob->width()*sizeof(float));
                    }

                }
            }
        }

        void deallocate_16bytes_aligned_data()
        {
            if (memory_allocated_ != NULL){
                free(memory_allocated_);
                memory_allocated_ = NULL;
            }
            shape_[0] = 0;
            shape_[1] = 0;
            shape_[2] = 0;
            shape_[3] = 0;
        }

        const static int shape_dimension_ = 4;

        void set_quantize_min(float quantize_min){
            quantize_min_ = quantize_min;
        }

        float get_quantize_min() const{
            return quantize_min_;
        }

        void set_quantize_max(float quantize_max){
            quantize_max_ = quantize_max;
        }

        float get_quantize_max() const{
            return quantize_max_;
        }

        void set_data_type(rpd_blob_data_type data_type){
            data_type_ = data_type;
        }

        rpd_blob_data_type get_data_type() const {
            return data_type_;
        }

    private:
        inline int channel_margin() const{
            return channel_step_in_bytes_ == -1 ? 0: channel_step_in_bytes_ - height()*width()*sizeof(T);
        }
        //rpd_blob(const rpd_blob&);
        //rpd_blob& operator=(const rpd_blob&);

        int shape_[shape_dimension_];
        T* data_;
        std::string blob_name_;

        T* memory_allocated_;

        int channel_step_in_bytes_;

        //int8 model blob info
        float quantize_min_;
        float quantize_max_;
        rpd_blob_data_type data_type_;
    };
}

#endif

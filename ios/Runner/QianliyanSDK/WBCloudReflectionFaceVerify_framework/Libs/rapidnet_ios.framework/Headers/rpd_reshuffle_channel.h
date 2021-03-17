#ifndef RAPIDNET_UTILS_RPD_RESHUFFLE_CHANNEL_H_
#define RAPIDNET_UTILS_RPD_RESHUFFLE_CHANNEL_H_

#include <string.h>
#include "shared_blob.h"
#include "rpdblob.h"

namespace RPNNameSpace{

template<class T>
void nchw_2_nhwc(T* data, T* buffer, int num, int channel, int height, int width)
{
    bool is_buffer_ready = true;

    if(buffer == NULL)
    {
        is_buffer_ready = false;
        buffer = (T*) malloc(num*channel*height*width*sizeof(T));
    }

    for(int n=0; n<num; ++n)
    {
        for(int c=0; c<channel; ++c)
        {
            for(int h=0; h<height; ++h)
            {
                for(int w=0; w<width; ++w)
                {
                    buffer[n*height*width*channel + h*width*channel + w*channel + c] = data[n*channel*height*width + c*height*width + h*width + w];
                }
            }
        }
    }

    memcpy(data, buffer, num*height*width*channel*sizeof(T));

    if(!is_buffer_ready)
    {
        free(buffer);
    }
}

template<class T>
void nchw_2_nhwc(rpd_blob<T>& blob, T* buffer)
{
    nchw_2_nhwc(blob.data(), buffer, blob.num(), blob.channel(), blob.height(), blob.width());
}

template<class T>
void nchw_2_nhwc(const rpd_blob<T>& source_blob, rpd_blob<T>& dest_blob)
{
    int num = source_blob.num();
    int channel = source_blob.channel();
    int height = source_blob.height();
    int width = source_blob.width();

    for(int n=0; n<num; ++n)
    {
        for(int c=0; c<channel; ++c)
        {
            for(int h=0; h<height; ++h)
            {
                for(int w=0; w<width; ++w)
                {
                    dest_blob.data()[n*height*width*channel + h*width*channel + w*channel + c] = source_blob.data()[n*channel*height*width + c*height*width + h*width + w];
                }
            }
        }
    }
}

template<class T>
void nchw_2_nhwc(SharedBlob<T>& blob, T* buffer)
{
    nchw_2_nhwc(blob.data(), buffer, blob.num(), blob.channel(), blob.height(), blob.width());
}

template<class T>
void nhwc_2_nchw(T* data, T* buffer, int num, int channel, int height, int width)
{
    bool is_buffer_ready = true;

    if(buffer == NULL)
    {
        is_buffer_ready = false;
        buffer = (T*) malloc(num*channel*height*width*sizeof(T));
    }

    for(int n=0; n<num; ++n)
    {
        for(int c=0; c<channel; ++c)
        {
            for(int h=0; h<height; ++h)
            {
                for(int w=0; w<width; ++w)
                {
                    buffer[n*channel*height*width + c*height*width + h*width + w] = data[n*height*width*channel + h*width*channel + w*channel + c];
                }
            }
        }
    }

    memcpy(data, buffer, num*height*width*channel*sizeof(T));
    
    if(!is_buffer_ready)
    {
        free(buffer);
    }
}

template<class T>
void nhwc_2_nchw(rpd_blob<T>& blob, T* buffer)
{
    nhwc_2_nchw(blob.data(), buffer, blob.num(), blob.channel(), blob.height(), blob.width());
}

template<class T>
void nhwc_2_nchw(const rpd_blob<T>& source_blob, rpd_blob<T>& dest_blob)
{
    int num = source_blob.num();
    int channel = source_blob.channel();
    int height = source_blob.height();
    int width = source_blob.width();
    for(int n=0; n<num; ++n)
    {
        for(int c=0; c<channel; ++c)
        {
            for(int h=0; h<height; ++h)
            {
                for(int w=0; w<width; ++w)
                {
                    dest_blob.data()[n*channel*height*width + c*height*width + h*width + w] = source_blob.data()[n*height*width*channel + h*width*channel + w*channel + c];
                }
            }
        }
    }
}

template<class T>
void nhwc_2_nchw(SharedBlob<T>& blob, T* buffer)
{
    nhwc_2_nchw(blob.data(), buffer, blob.num(), blob.channel(), blob.height(), blob.width());
}
}

#endif

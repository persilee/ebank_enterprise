//
//  rpdoption.hpp
//  rapidnet_ios
//
//  Created by darrenyao on 2018/5/18.
//  Copyright © 2018年 tc. All rights reserved.
//

#ifndef rpdoption_hpp
#define rpdoption_hpp
#include "platforms/platforms.h"

#include <memory>

#ifdef DEBUG
#include <string>
#endif

namespace RPNNameSpace {
    enum layer_fusion_mode {
        layer_fusion_non = 0,
        layer_fusion_bn_scale_xrelu = 1,
    };
    
    enum convolution_mode {
        convolution_direct = 0,
        convolution_packed_channel = 1,
        convolution_winograd = 2,
    };
    
    struct rpdoption {
        rpdoption();
        
        //net option
        layer_fusion_mode fusion_mode;
        
        //convolution option
        convolution_mode conv_mode;
        
        static rpdoption get_default_rpd_option();
#ifdef DEBUG
        std::string description();
#endif
    };
}

#endif /* rpdoption_hpp */

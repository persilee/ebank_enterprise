#ifndef _RPDNET_20160516_H_
#define _RPDNET_20160516_H_
#include <stdio.h>
#include <memory>
#include <vector>
#include <map>

#include "rpdblob.h"
#include "shared_blob.h"
#include "rpdoption.h"
#include "smart_pointers/shared_ptr.h"
#include "platforms/platforms.h"

namespace RPNNameSpace {

    class rpd_ctrl;
    class RapidnetInstance;

    typedef RapidnetInstance* HRPDINSTANCE; // Such weird type names as HRPDINSTANCE from brack is still maintained to support legacy SDK.

	class rapidnet
	{
	public:
        rapidnet();
        ~rapidnet();

        /**
         *  functionality  init the rapidnet net
         *  @param proto_file_content  The content in the proto file
         *  @param model_file_path  The path of the model file name
         *  @return error code  If successful, returns zero. Otherwise, returns an error code.
         */
        int init(const char* proto_file_content, const char* model_file_path);
        int init(const char* proto_file_content, const std::string& model_file_path);

        /**
         *  functionality  init the rapidnet net
         *  @param proto_file_content  The content in the proto file
         *  @param model_file_stream  The file stream of the input model file
         *  @return error code  If successful, returns zero. Otherwise, returns an error code.
         */
        int init(const char* proto_file_content, std::ifstream& model_file_stream);

        /**
         *  functionality  init the rapidnet net
         *  @param proto_file_content  The content in the proto file
         *  @param model_data  The data in the model file
         *  @param model_data_length  The data length of the model
         *  @return error code  If successful, returns zero. Otherwise, returns an error code.
         */
        int init(const char* proto_file_content, const char* model_data, size_t model_data_length);

        /**
         *  functionality  create an instance
         *  @param instance  The instance to be created.
         *  @return error code  If successful, returns zero. Otherwise, returns an error code.
         */
        int create_inst(RapidnetInstance* *instance);
        int create_inst(RapidnetInstance* *instance, DeviceType device_type);
        int create_inst(RapidnetInstance* *instance, DeviceType device_type, std::vector<int> input_blob_id_vec);

        /**
         *  functionality  Reshape the instance into the blob shape
         *  @param instance  The instance to be reshaped.
         *  @param blob  The input image blob that provides the shape information.
         *  @return error code  If successful, returns zero. Otherwise, returns an error code.
         */
        int reshape_inst(RapidnetInstance* instance, const rpd_blob<float>& blob);

        /**
         *  functionality  Reshape the instance into the shape of num, channel, height and width.
         *  @param instance  The instance to be reshaped.
         *  @param num  the num value that the instance'input will be reshaped into.
         *  @param channel  the channel value that the instance'input will be reshaped into.
         *  @param height  the height value that the instance'input will be reshaped into.
         *  @param width  the width value that the instance'input will be reshaped into.
         *
         *
         *  @return error code  If successful, returns zero. Otherwise, returns an error code.
         */
        int reshape_inst(RapidnetInstance* instance, int num, int channel, int height, int width);

        rpd_blob<float>& get_input_blob(RapidnetInstance* instance);

        /**
         *  functionality  Do forwarding computation based on input image blob under the given instance
         *  @param instance  The instance to do forwarding computation
         *  @param in  The input image blob
         *              Please note that the input image blob data memory ure user allocated and initialized with image data.
         *  @param output_feature  The output features in the proto file. In general, it's the output features of the last layer.
         *              Please note that the blob data memory in the out blob is allocated by rapidnet. In another word,
         *              the caller doesn't need to allocate the memory in the blob data, and the memory will be deallocated
         *              during the destroy_instance phase.
         *  @return error code  If successful, returns zero. Otherwise, returns an error code.
         */
        int forward(RapidnetInstance* instance, const rpd_blob<float>& in, rpd_blob<float>& output_feature);
        int forward(RapidnetInstance* instance, const rpd_blob<unsigned char>& in, rpd_blob<float>& output_feature);

        // Warning  This function is deprecated and will be removed in the future.
        int forward(RapidnetInstance* instance, rpd_blob<float>& in, rpd_blob<float>& output_feature);
        //multiple inputs
        int forward(RapidnetInstance* instance, std::vector<rpd_blob<float> >& in, rpd_blob<float>& output_feature);

        const rpd_blob<float>& forward_neon(RapidnetInstance* instance);

        /**
         *  functionality  Do forwarding computation based on input image blob under the given instance
         *  @param instance  The instance to do forwarding computation
         *  @param in  The input image blob
         *              Please note that the input image blob data memory ure user allocated and initialized with image data.
         *  @param layer_names  The list contains layer names whose feature the caller expect to get.
         *  @param output_features  The output features in output_features_layer_id_list param.
         *  @return error code  If successful, returns zero. Otherwise, returns an error code.
         */
        int forward(RapidnetInstance* instance, const rpd_blob<float>& in, const std::vector<std::string>& layer_names, std::vector<std::vector<smart_pointers::shared_ptr<SharedBlob<float> > > >& output_features);
        /**
         *  functionality  Do forwarding computation based on input image blob under the given instance
         *  @param instance  The instance to do forwarding computation
         *  @param in  The input image blob
         *              Please note that the input image blob data memory ure user allocated and initialized with image data.
         *  @param output_features_layer_id_list  The list contains layer ids whose feature the caller expect to get.
         *  @param output_features  The output features in output_features_layer_id_list param.
         *  @return error code  If successful, returns zero. Otherwise, returns an error code.
         */
        int forward(RapidnetInstance* instance, const rpd_blob<float>& in, const std::vector<int>& output_features_layer_id_list, std::vector<std::vector<smart_pointers::shared_ptr<SharedBlob<float> > > >& output_features);
        int forward(RapidnetInstance* instance, const rpd_blob<unsigned char>& in, const std::vector<int>& output_features_layer_id_list, std::vector<std::vector<smart_pointers::shared_ptr<SharedBlob<float> > > >& output_features);

        int forward_neon(RapidnetInstance* instance, const std::vector<int>& output_features_layer_id_list, std::vector<std::vector<smart_pointers::shared_ptr<SharedBlob<float> > > >& output_features);

        // Warning  This function is deprecated and will be removed in the future.
        int reset_inst(RapidnetInstance* instance);

        /**
         *  functionality  Get the output features of the layer whose id is layerId
         *  @param instance  The instance that did has finished the forwarding computation
         *  @param layerId  the layer id of the layer whose output features the caller are interested in
         *  @param featureBlobs  The output features of the layerId
         *  @return error code  If successful, returns zero. Otherwise, returns an error code.
         */
        int get_feature(RapidnetInstance* instance, size_t layerId, std::vector<rpd_blob<float>*>& featureBlobs);

        /**
         *  functionality  destroy an instance
         *  @param instance  The instance to be destroyed. remember to set it to null after call this method
         *  @return error code  If successful, returns zero. Otherwise, returns an error code.
         */
        int destroy_inst(RapidnetInstance* instance);

        // Warning  This interface is deprecated but still maintained to support legacy application SDK calling
        int destory_inst(RapidnetInstance* instance);

        // default cpu affinity
        int set_cpu_affinity();

        // set cpu affinity via list
        int set_cpu_affinity(const std::vector<size_t>& cpu_list);

        rpd_ctrl *get_rpd_ctrl();

        //only set once, before create_inst
        int set_rpd_option(rpdoption opt);

    private:
        // Rapidnet is designed to be uncopyable and unassignable
        rapidnet(const rapidnet& other);
        rapidnet& operator=(const rapidnet & rhs);

        rpd_ctrl* rpd_ctrl_;
	};

}
#endif

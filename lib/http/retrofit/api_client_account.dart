import 'package:dio/dio.dart';
import 'package:ebank_mobile/data/source/model/city_for_country.dart';
import 'package:ebank_mobile/data/source/model/country_region_new_model.dart';
import 'package:ebank_mobile/data/source/model/face_sign_businessid.dart';
import 'package:ebank_mobile/data/source/model/getFeedback.dart';

import 'package:ebank_mobile/data/source/model/get_public_parameters.dart';
import 'package:ebank_mobile/data/source/model/open_account_get_data.dart';
import 'package:ebank_mobile/data/source/model/open_account_information_supplement_data.dart';
import 'package:ebank_mobile/data/source/model/open_account_quick_data.dart';
import 'package:ebank_mobile/data/source/model/open_account_quick_submit_data.dart';
import 'package:ebank_mobile/data/source/model/open_account_save_data.dart';
import 'package:ebank_mobile/data/source/model/open_account_signature_result.dart';
import 'package:retrofit/http.dart';
import 'package:retrofit/retrofit.dart';

import 'base_dio.dart';

part 'api_client_account.g.dart';

@RestApi(baseUrl: BaseDio.BASEURL)
abstract class ApiClientAccount {
  factory ApiClientAccount({Dio dio, String baseUrl}) {
    dio ??= BaseDio.getInstance().getDio();
    return _ApiClientAccount(dio, baseUrl: baseUrl);
  }

  /// 提交意见（意见反馈）
  @POST('platform/opinion/feedbackProblem')
  Future<GetFeedbackResp> feedBack(@Body() GetFeedBackReq req);
}

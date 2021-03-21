

import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';

import 'base_dio.dart';

part 'api_client.g.dart';

@RestApi(baseUrl: 'https://api.lishaoy.net')
abstract class ApiClient {
  factory ApiClient({Dio dio, String baseUrl}) {
    dio ??= BaseDio.getInstance().getDio();
    return _ApiClient(dio, baseUrl: baseUrl);
  }

  /**
   * 获取首页推荐文章
   */
  // @GET('/posts')
  // Future<PostModel> getPosts(
  //     @Query('pageIndex') String pageIndex, @Query('pageSize') String pageSize,
  //     {@Query('sort') String sort = 'recommend'});
}

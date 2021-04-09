import 'package:dio/dio.dart';
import 'package:ebank_mobile/util/small_data_store.dart';
import 'package:flutter/material.dart';
import 'package:ebank_mobile/http/hsg_http_exception.dart';
import 'package:shared_preferences/shared_preferences.dart';

typedef _FromJson<T> = T Function(dynamic data);

Future<T> request<T>(path, data, tag, _FromJson<T> fromJson) {
  return HsgHttp()
      .post(path: path, data: data, tag: tag)
      .then((value) => fromJson(value));
}

Future<T> requestFile<T>(path, data, filePath, tag, _FromJson<T> fromJson) {
  return HsgHttp()
      .postData(path: path, filePath: filePath, data: data, tag: tag)
      .then((value) => fromJson(value));
}

class HsgHttp {
  var _cancelTokens = Map<String, CancelToken>();

  static const int _CONNECT_TIMTOUT = 30000;
  static const int _RECEIVE_TIMTOUT = 30000;

  Dio _dio;
  // var _baseUrl = 'http://161.189.48.75:5040/'; //dev
  var _baseUrl = 'http://47.57.236.20:5040/'; //sit
  // var _baseUrl = 'http://47.242.2.219:5040'; //UAT
  //'http://52.82.42.59:5040/'; http://161.189.48.75:5040/ http://192.168.201.65:5041/

  static final _instance = HsgHttp._internal();

  factory HsgHttp() => _instance;

  // base request value store
  var _loginName = '';
  var _userId = '';

  HsgHttp._internal() {
    if (_dio == null) {
      final options = BaseOptions(
          baseUrl: _baseUrl,
          headers: {
            "x-kont-appkey": "6000000514984257"
          }, //企业手机银行 //{"x-kont-appkey": "6000000514984255"},//个人手机银行
          connectTimeout: _CONNECT_TIMTOUT,
          receiveTimeout: _RECEIVE_TIMTOUT);
      _dio = Dio(options);
      _dio.interceptors.add(InterceptorsWrapper(
        onRequest: (options) async {
          final prefs = await SharedPreferences.getInstance();
          final locale = prefs.getString(ConfigKey.LANGUAGE) ?? 'en';
          final token = prefs.getString(ConfigKey.NET_TOKEN) ?? '';

          _dio.interceptors.requestLock.lock();
          options.headers['x_kont_token'] = token;
          options.headers['x_kont_locale'] = locale;
          _dio.interceptors.requestLock.unlock();
          return options;
        },
      ));
      _dio.interceptors
          .add(LogInterceptor(requestBody: true, responseBody: true));
    }
  }

  Future postData({
    @required path,
    String method,
    var filePath,
    data,
    Options options,
    @required String tag,
  }) async {
    try {
      final cancelToken =
          _cancelTokens[tag] == null ? CancelToken() : _cancelTokens[tag];
      _cancelTokens[tag] = cancelToken;
      final baseRequest = await _createBaseRequest(data);
      Map dataMap = baseRequest.toJson();
      var name =
          filePath.substring(filePath.lastIndexOf("/") + 1, filePath.length);
      dataMap['file'] = await MultipartFile.fromFile(filePath, filename: name);

      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(filePath, filename: name),
      });

      final response = await _dio.post(
        path,
        data: formData, //dataMap, //baseRequest.toJson(),
        // options: options,
        // cancelToken: cancelToken,
      );
      final baseResponse = _BaseResponse.fromJson(response.data);
      if (baseResponse.msgCd == 'KONT0000') {
        if (baseResponse.token != null) {
          _saveToken(baseResponse.token);
        }
        return Future.value(baseResponse.body);
      } else {
        return Future.error(HsgHttpException(
            HsgHttpException.BUSINESS_ERROR,
            baseResponse.msgInfo == null
                ? baseResponse.msgCd
                : baseResponse.msgInfo));
      }
    } on DioError catch (e) {
      return Future.error(HsgHttpException.dioError(e));
    } catch (e) {
      return Future.error(
          HsgHttpException(HsgHttpException.UNKNOWN, '未知异常，请联系管理员'));
    }
  }

  Future post({
    @required path,
    String method,
    data,
    Options options,
    @required String tag,
  }) async {
    try {
      final cancelToken =
          _cancelTokens[tag] == null ? CancelToken() : _cancelTokens[tag];
      _cancelTokens[tag] = cancelToken;
      final baseRequest = await _createBaseRequest(data);
      final response = await _dio.post(path,
          data: baseRequest.toJson(),
          options: options,
          cancelToken: cancelToken);
      final baseResponse = _BaseResponse.fromJson(response.data);
      if (baseResponse.msgCd == '0000') {
        if (baseResponse.token != null) {
          _saveToken(baseResponse.token);
        }
        return Future.value(baseResponse.body);
      } else {
        return Future.error(HsgHttpException(
            HsgHttpException.BUSINESS_ERROR,
            baseResponse.msgInfo == null
                ? baseResponse.msgCd
                : baseResponse.msgInfo));
      }
    } on DioError catch (e) {
      return Future.error(HsgHttpException.dioError(e));
    } catch (e) {
      return Future.error(
          HsgHttpException(HsgHttpException.UNKNOWN, '未知异常，请联系管理员'));
    }
  }

  Future<BaseRequest> _createBaseRequest(data) async {
    if (_loginName.isEmpty || _userId.isEmpty) {
      final prefs = await SharedPreferences.getInstance();
      if (_loginName.isEmpty) {
        _loginName = prefs.getString(ConfigKey.USER_ACCOUNT) ?? '';
      }
      if (_userId.isEmpty) {
        _userId = prefs.getString(ConfigKey.USER_ID) ?? '';
      }
    }
    return BaseRequest(loginName: _loginName, userId: _userId, body: data);
  }

  _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(ConfigKey.NET_TOKEN, token);
  }

  //切换用户或者退出登录时需要清除缓存
  clearUserCache() {
    _loginName = '';
    _userId = '';
  }

  ///取消网络请求
  void cancel(String tag) {
    if (_cancelTokens.containsKey(tag)) {
      if (!_cancelTokens[tag].isCancelled) {
        _cancelTokens[tag].cancel();
      }
      _cancelTokens.remove(tag);
    }
  }
}

class BaseRequest {
  String loginName = "";
  String userId = "";
  dynamic body;

  BaseRequest(
      {@required this.loginName, @required this.userId, @required this.body});

  Map<String, dynamic> toJson() => {
        "loginname": loginName,
        "userId": userId,
        "body": body,
      };
}

class _BaseResponse {
  String msgCd;
  String msgInfo;
  String msgType;
  String token;
  dynamic body;

  _BaseResponse(this.msgCd, this.msgInfo, this.msgType, this.token, this.body);

  factory _BaseResponse.fromJson(Map<String, dynamic> json) {
    return _BaseResponse(json['msgCd'], json['msgInfo'], json['msgType'],
        json['token'], json['body']);
  }
}

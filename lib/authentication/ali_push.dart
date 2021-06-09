import 'package:ebank_mobile/data/model/push/ali_push_modal.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

class AliPush {
  static const _platform =
      const MethodChannel('com.hsg.bank.brillink/ali-push');

  static const _eventChannel =
      EventChannel('com.hsg.bank.brillink/ali-push-event');

  static final _instance = AliPush._internal();
  factory AliPush() => _instance;
  AliPush._internal();
  Future<ParametersResp> aliPushSetParameters(ParametersReq req) async {
    try {
      final result = await _platform.invokeMethod(
        'aliPushSetParameters',
        {"body": jsonEncode(req)},
      );
      final resultMap = jsonDecode(result);
      print(resultMap);
      return Future.value(ParametersResp.fromJson(resultMap));
    } on PlatformException catch (e) {
      return Future.error(e);
    }
  }

  Future<ParametersResp> aliPushCancelParameters(ParametersReq req) async {
    try {
      final result = await _platform.invokeMethod(
        'aliPushCancelParameters',
        {"body": jsonEncode(req)},
      );
      final resultMap = jsonDecode(result);
      return Future.value(ParametersResp.fromJson(resultMap));
    } on PlatformException catch (e) {
      return Future.error(e);
    }
  }

  void startListenAliPush() {
    //监听接收消息
    _eventChannel.receiveBroadcastStream().listen(_getData, onError: _getError);
  }

  //获得到消息
  void _getData(dynamic data) {
    //MessageResp NotificationResp
    print('>>>>>>>s  $data');
  }

  //获取到错误
  void _getError(Object err) {
    print('>>>>>>>e  $err');
  }
}

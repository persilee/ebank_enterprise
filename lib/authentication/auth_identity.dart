import 'package:ebank_mobile/data/model/auth_identity_bean.dart';

/// Copyright (c) 2021 深圳高阳寰球科技有限公司
///
/// Author: zhanggenhua
/// Date: 2021-03-15
///
import 'package:flutter/services.dart';
import 'dart:convert';

class AuthIdentity {
  static const _platform =
      const MethodChannel('com.hsg.bank.brillink/auth-identity');

  static final _instance = AuthIdentity._internal();
  factory AuthIdentity() => _instance;
  AuthIdentity._internal();

  Future<AuthIdentityResp> startAuth(AuthIdentityReq req) async {
    try {
      final result = await _platform.invokeMethod(
        'startAuth',
        {"body": jsonEncode(req)},
      );
      final resultMap = jsonDecode(result);
      return Future.value(AuthIdentityResp.fromJson(resultMap));
    } on PlatformException catch (e) {
      return Future.error("startAuth error: '${e.message}'");
    }
  }
}

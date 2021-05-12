import 'package:ebank_mobile/util/small_data_store.dart';
import 'package:flutter/material.dart';
import 'package:sp_util/sp_util.dart';

class BaseBody {
  String userId;
  String loginName;
  dynamic body;

  BaseBody({@required this.body, this.userId, this.loginName}) {
    this.userId = SpUtil.getString(ConfigKey.USER_ID);
    this.loginName = SpUtil.getString(ConfigKey.USER_ACCOUNT);
  }

  BaseBody.fromJson(dynamic json) {
    userId = json["userId"];
    loginName = json["loginName"];
    body = json["body"];
  }

  Map<String, dynamic> toJson() => {
        "loginName": loginName,
        "userId": userId,
        "body": body,
      };
}

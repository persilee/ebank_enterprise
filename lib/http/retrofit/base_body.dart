import 'package:ebank_mobile/http/hsg_http.dart';
import 'package:ebank_mobile/util/small_data_store.dart';
import 'package:flutter/material.dart';
import 'package:sp_util/sp_util.dart';

class BaseBody {
  String userId;
  String userAccount;
  dynamic body;

  BaseBody({@required this.body, this.userId, this.userAccount}) {
    this.userId = SpUtil.getString(ConfigKey.USER_ID);
    this.userAccount = SpUtil.getString(ConfigKey.USER_ACCOUNT);
  }

  BaseBody.fromJson(dynamic json) {
    userId = json["userId"];
    userAccount = json["userAccount"];
    body = json["body"];
  }

  Map<String, dynamic> toJson() => {
        "userAccount": userAccount,
        "userId": userId,
        "body": body,
      };
}

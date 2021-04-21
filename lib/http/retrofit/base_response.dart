/// token : ""
/// userId : "989185387615485977"
/// loginName : ""
/// body : null
/// msgCd : "0000"
/// msgInfo : "成功"
/// msgType : "N"

class BaseResponse {
  String _token;
  String _userId;
  String _loginName;
  dynamic _body;
  String _msgCd;
  String _msgInfo;
  String _msgType;

  String get token => _token;
  String get userId => _userId;
  String get loginName => _loginName;
  dynamic get body => _body;
  String get msgCd => _msgCd;
  String get msgInfo => _msgInfo;
  String get msgType => _msgType;

  BaseResponse(
      {String token,
      String userId,
      String loginName,
      dynamic body,
      String msgCd,
      String msgInfo,
      String msgType}) {
    _token = token;
    _userId = userId;
    _loginName = loginName;
    _body = body;
    _msgCd = msgCd;
    _msgInfo = msgInfo;
    _msgType = msgType;
  }

  BaseResponse.fromJson(dynamic json) {
    _token = json["token"];
    _userId = json["userId"];
    _loginName = json["loginName"];
    _body = json["body"];
    _msgCd = json["msgCd"];
    _msgInfo = json["msgInfo"];
    _msgType = json["msgType"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["token"] = _token;
    map["userId"] = _userId;
    map["loginName"] = _loginName;
    map["body"] = _body;
    map["msgCd"] = _msgCd;
    map["msgInfo"] = _msgInfo;
    map["msgType"] = _msgType;
    return map;
  }
}

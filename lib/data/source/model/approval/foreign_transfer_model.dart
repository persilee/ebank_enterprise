/// userId : "829378395983839232"
/// userName : "HSG15 Checker"
/// assignee : null
/// processTitle : "foreignTransferApprovalTitle"
/// processKey : "foreignTransferApproval"
/// businessKey : null
/// tenantId : null
/// operateBeforeValue : null
/// operateEndValue : {"prodCd":"FXSPTIBK","buyDac":"0001208000001428","buyAmt":"100","buyCcy":"CNY","sellCcy":"EUR","sellDac":"0001278000001418","sellAmt":"783.09","exRate":"0.1277","exTime":"102813","smsCode":"123456","payPassword":"OkDOYrdBTBcq36OKApyAlA=="}
/// servCtr : "hbs-ebank-general-service"
/// custId : null
/// commentList : []
/// result : true
/// taskKey : "TASK1"
/// taskCount : 1

class ForeignTransferModel {
  String _userId;
  String _userName;
  dynamic _assignee;
  String _processTitle;
  String _processKey;
  dynamic _businessKey;
  dynamic _tenantId;
  dynamic _operateBeforeValue;
  OperateEndValue _operateEndValue;
  String _servCtr;
  dynamic _custId;
  List<dynamic> _commentList;
  bool _result;
  String _taskKey;
  int _taskCount;

  String get userId => _userId;
  String get userName => _userName;
  dynamic get assignee => _assignee;
  String get processTitle => _processTitle;
  String get processKey => _processKey;
  dynamic get businessKey => _businessKey;
  dynamic get tenantId => _tenantId;
  dynamic get operateBeforeValue => _operateBeforeValue;
  OperateEndValue get operateEndValue => _operateEndValue;
  String get servCtr => _servCtr;
  dynamic get custId => _custId;
  List<dynamic> get commentList => _commentList;
  bool get result => _result;
  String get taskKey => _taskKey;
  int get taskCount => _taskCount;

  ForeignTransferModel({
      String userId, 
      String userName, 
      dynamic assignee, 
      String processTitle, 
      String processKey, 
      dynamic businessKey, 
      dynamic tenantId, 
      dynamic operateBeforeValue, 
      OperateEndValue operateEndValue, 
      String servCtr, 
      dynamic custId, 
      List<dynamic> commentList, 
      bool result, 
      String taskKey, 
      int taskCount}){
    _userId = userId;
    _userName = userName;
    _assignee = assignee;
    _processTitle = processTitle;
    _processKey = processKey;
    _businessKey = businessKey;
    _tenantId = tenantId;
    _operateBeforeValue = operateBeforeValue;
    _operateEndValue = operateEndValue;
    _servCtr = servCtr;
    _custId = custId;
    _commentList = commentList;
    _result = result;
    _taskKey = taskKey;
    _taskCount = taskCount;
}

  ForeignTransferModel.fromJson(dynamic json) {
    _userId = json["userId"];
    _userName = json["userName"];
    _assignee = json["assignee"];
    _processTitle = json["processTitle"];
    _processKey = json["processKey"];
    _businessKey = json["businessKey"];
    _tenantId = json["tenantId"];
    _operateBeforeValue = json["operateBeforeValue"];
    _operateEndValue = json["operateEndValue"] != null ? OperateEndValue.fromJson(json["operateEndValue"]) : null;
    _servCtr = json["servCtr"];
    _custId = json["custId"];
    if (json["commentList"] != null) {
      _commentList = [];
      json["commentList"].forEach((v) {
        // _commentList.add(dynamic.fromJson(v));
      });
    }
    _result = json["result"];
    _taskKey = json["taskKey"];
    _taskCount = json["taskCount"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["userId"] = _userId;
    map["userName"] = _userName;
    map["assignee"] = _assignee;
    map["processTitle"] = _processTitle;
    map["processKey"] = _processKey;
    map["businessKey"] = _businessKey;
    map["tenantId"] = _tenantId;
    map["operateBeforeValue"] = _operateBeforeValue;
    if (_operateEndValue != null) {
      map["operateEndValue"] = _operateEndValue.toJson();
    }
    map["servCtr"] = _servCtr;
    map["custId"] = _custId;
    if (_commentList != null) {
      map["commentList"] = _commentList.map((v) => v.toJson()).toList();
    }
    map["result"] = _result;
    map["taskKey"] = _taskKey;
    map["taskCount"] = _taskCount;
    return map;
  }

}

/// prodCd : "FXSPTIBK"
/// buyDac : "0001208000001428"
/// buyAmt : "100"
/// buyCcy : "CNY"
/// sellCcy : "EUR"
/// sellDac : "0001278000001418"
/// sellAmt : "783.09"
/// exRate : "0.1277"
/// exTime : "102813"
/// smsCode : "123456"
/// payPassword : "OkDOYrdBTBcq36OKApyAlA=="

class OperateEndValue {
  String _prodCd;
  String _buyDac;
  String _buyAmt;
  String _buyCcy;
  String _sellCcy;
  String _sellDac;
  String _sellAmt;
  String _exRate;
  String _exTime;
  String _smsCode;
  String _payPassword;

  String get prodCd => _prodCd;
  String get buyDac => _buyDac;
  String get buyAmt => _buyAmt;
  String get buyCcy => _buyCcy;
  String get sellCcy => _sellCcy;
  String get sellDac => _sellDac;
  String get sellAmt => _sellAmt;
  String get exRate => _exRate;
  String get exTime => _exTime;
  String get smsCode => _smsCode;
  String get payPassword => _payPassword;

  OperateEndValue({
      String prodCd, 
      String buyDac, 
      String buyAmt, 
      String buyCcy, 
      String sellCcy, 
      String sellDac, 
      String sellAmt, 
      String exRate, 
      String exTime, 
      String smsCode, 
      String payPassword}){
    _prodCd = prodCd;
    _buyDac = buyDac;
    _buyAmt = buyAmt;
    _buyCcy = buyCcy;
    _sellCcy = sellCcy;
    _sellDac = sellDac;
    _sellAmt = sellAmt;
    _exRate = exRate;
    _exTime = exTime;
    _smsCode = smsCode;
    _payPassword = payPassword;
}

  OperateEndValue.fromJson(dynamic json) {
    _prodCd = json["prodCd"];
    _buyDac = json["buyDac"];
    _buyAmt = json["buyAmt"];
    _buyCcy = json["buyCcy"];
    _sellCcy = json["sellCcy"];
    _sellDac = json["sellDac"];
    _sellAmt = json["sellAmt"];
    _exRate = json["exRate"];
    _exTime = json["exTime"];
    _smsCode = json["smsCode"];
    _payPassword = json["payPassword"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["prodCd"] = _prodCd;
    map["buyDac"] = _buyDac;
    map["buyAmt"] = _buyAmt;
    map["buyCcy"] = _buyCcy;
    map["sellCcy"] = _sellCcy;
    map["sellDac"] = _sellDac;
    map["sellAmt"] = _sellAmt;
    map["exRate"] = _exRate;
    map["exTime"] = _exTime;
    map["smsCode"] = _smsCode;
    map["payPassword"] = _payPassword;
    return map;
  }

}
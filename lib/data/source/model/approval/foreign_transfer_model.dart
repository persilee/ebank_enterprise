/// userId : "835838936357011456"
/// userName : "李家伟"
/// assigneeList : null
/// approverNumbers : 0
/// processTitle : "foreignTransferApprovalTitle"
/// processKey : "foreignTransferApproval"
/// businessKey : null
/// tenantId : null
/// operateBeforeValue : null
/// operateEndValue : {"buyCcy":"USD","prodCd":"FXSPTIBK","buyAmt":"1000","buyDac":"8011258000006258","smsCode":"","exRate":"1.2078","sellAmt":"827.95","exTime":"112010","sellCcy":"EUR","payPassword":"","sellDac":"8011258000006258","availableBalance":null}
/// servCtr : "hbs-ebank-general-service"
/// custId : null
/// amount : null
/// ccy : null
/// authModel : null
/// amountPosition : null
/// serviceType : null
/// authGroups : null
/// commentList : []
/// result : "2"
/// taskKey : null
/// taskCount : 1
/// optBefJsonValue : null
/// optEndJsonValue : null

class ForeignTransferModel {
  String _userId;
  String _userName;
  dynamic _assigneeList;
  int _approverNumbers;
  String _processTitle;
  String _processKey;
  dynamic _businessKey;
  dynamic _tenantId;
  dynamic _operateBeforeValue;
  OperateEndValue _operateEndValue;
  String _servCtr;
  dynamic _custId;
  dynamic _amount;
  dynamic _ccy;
  dynamic _authModel;
  dynamic _amountPosition;
  dynamic _serviceType;
  dynamic _authGroups;
  List<dynamic> _commentList;
  String _result;
  dynamic _taskKey;
  int _taskCount;
  dynamic _optBefJsonValue;
  dynamic _optEndJsonValue;

  String get userId => _userId;
  String get userName => _userName;
  dynamic get assigneeList => _assigneeList;
  int get approverNumbers => _approverNumbers;
  String get processTitle => _processTitle;
  String get processKey => _processKey;
  dynamic get businessKey => _businessKey;
  dynamic get tenantId => _tenantId;
  dynamic get operateBeforeValue => _operateBeforeValue;
  OperateEndValue get operateEndValue => _operateEndValue;
  String get servCtr => _servCtr;
  dynamic get custId => _custId;
  dynamic get amount => _amount;
  dynamic get ccy => _ccy;
  dynamic get authModel => _authModel;
  dynamic get amountPosition => _amountPosition;
  dynamic get serviceType => _serviceType;
  dynamic get authGroups => _authGroups;
  List<dynamic> get commentList => _commentList;
  String get result => _result;
  dynamic get taskKey => _taskKey;
  int get taskCount => _taskCount;
  dynamic get optBefJsonValue => _optBefJsonValue;
  dynamic get optEndJsonValue => _optEndJsonValue;

  ForeignTransferModel({
      String userId, 
      String userName, 
      dynamic assigneeList, 
      int approverNumbers, 
      String processTitle, 
      String processKey, 
      dynamic businessKey, 
      dynamic tenantId, 
      dynamic operateBeforeValue, 
      OperateEndValue operateEndValue, 
      String servCtr, 
      dynamic custId, 
      dynamic amount, 
      dynamic ccy, 
      dynamic authModel, 
      dynamic amountPosition, 
      dynamic serviceType, 
      dynamic authGroups, 
      List<dynamic> commentList, 
      String result, 
      dynamic taskKey, 
      int taskCount, 
      dynamic optBefJsonValue, 
      dynamic optEndJsonValue}){
    _userId = userId;
    _userName = userName;
    _assigneeList = assigneeList;
    _approverNumbers = approverNumbers;
    _processTitle = processTitle;
    _processKey = processKey;
    _businessKey = businessKey;
    _tenantId = tenantId;
    _operateBeforeValue = operateBeforeValue;
    _operateEndValue = operateEndValue;
    _servCtr = servCtr;
    _custId = custId;
    _amount = amount;
    _ccy = ccy;
    _authModel = authModel;
    _amountPosition = amountPosition;
    _serviceType = serviceType;
    _authGroups = authGroups;
    _commentList = commentList;
    _result = result;
    _taskKey = taskKey;
    _taskCount = taskCount;
    _optBefJsonValue = optBefJsonValue;
    _optEndJsonValue = optEndJsonValue;
}

  ForeignTransferModel.fromJson(dynamic json) {
    _userId = json["userId"];
    _userName = json["userName"];
    _assigneeList = json["assigneeList"];
    _approverNumbers = json["approverNumbers"];
    _processTitle = json["processTitle"];
    _processKey = json["processKey"];
    _businessKey = json["businessKey"];
    _tenantId = json["tenantId"];
    _operateBeforeValue = json["operateBeforeValue"];
    _operateEndValue = json["operateEndValue"] != null ? OperateEndValue.fromJson(json["operateEndValue"]) : null;
    _servCtr = json["servCtr"];
    _custId = json["custId"];
    _amount = json["amount"];
    _ccy = json["ccy"];
    _authModel = json["authModel"];
    _amountPosition = json["amountPosition"];
    _serviceType = json["serviceType"];
    _authGroups = json["authGroups"];
    if (json["commentList"] != null) {
      _commentList = [];
      json["commentList"].forEach((v) {
        // _commentList.add(dynamic.fromJson(v));
      });
    }
    _result = json["result"];
    _taskKey = json["taskKey"];
    _taskCount = json["taskCount"];
    _optBefJsonValue = json["optBefJsonValue"];
    _optEndJsonValue = json["optEndJsonValue"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["userId"] = _userId;
    map["userName"] = _userName;
    map["assigneeList"] = _assigneeList;
    map["approverNumbers"] = _approverNumbers;
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
    map["amount"] = _amount;
    map["ccy"] = _ccy;
    map["authModel"] = _authModel;
    map["amountPosition"] = _amountPosition;
    map["serviceType"] = _serviceType;
    map["authGroups"] = _authGroups;
    if (_commentList != null) {
      map["commentList"] = _commentList.map((v) => v.toJson()).toList();
    }
    map["result"] = _result;
    map["taskKey"] = _taskKey;
    map["taskCount"] = _taskCount;
    map["optBefJsonValue"] = _optBefJsonValue;
    map["optEndJsonValue"] = _optEndJsonValue;
    return map;
  }

}

/// buyCcy : "USD"
/// prodCd : "FXSPTIBK"
/// buyAmt : "1000"
/// buyDac : "8011258000006258"
/// smsCode : ""
/// exRate : "1.2078"
/// sellAmt : "827.95"
/// exTime : "112010"
/// sellCcy : "EUR"
/// payPassword : ""
/// sellDac : "8011258000006258"
/// availableBalance : null

class OperateEndValue {
  String _buyCcy;
  String _prodCd;
  String _buyAmt;
  String _buyDac;
  String _smsCode;
  String _exRate;
  String _sellAmt;
  String _exTime;
  String _sellCcy;
  String _payPassword;
  String _sellDac;
  dynamic _availableBalance;

  String get buyCcy => _buyCcy;
  String get prodCd => _prodCd;
  String get buyAmt => _buyAmt;
  String get buyDac => _buyDac;
  String get smsCode => _smsCode;
  String get exRate => _exRate;
  String get sellAmt => _sellAmt;
  String get exTime => _exTime;
  String get sellCcy => _sellCcy;
  String get payPassword => _payPassword;
  String get sellDac => _sellDac;
  dynamic get availableBalance => _availableBalance;

  OperateEndValue({
      String buyCcy, 
      String prodCd, 
      String buyAmt, 
      String buyDac, 
      String smsCode, 
      String exRate, 
      String sellAmt, 
      String exTime, 
      String sellCcy, 
      String payPassword, 
      String sellDac, 
      dynamic availableBalance}){
    _buyCcy = buyCcy;
    _prodCd = prodCd;
    _buyAmt = buyAmt;
    _buyDac = buyDac;
    _smsCode = smsCode;
    _exRate = exRate;
    _sellAmt = sellAmt;
    _exTime = exTime;
    _sellCcy = sellCcy;
    _payPassword = payPassword;
    _sellDac = sellDac;
    _availableBalance = availableBalance;
}

  OperateEndValue.fromJson(dynamic json) {
    _buyCcy = json["buyCcy"];
    _prodCd = json["prodCd"];
    _buyAmt = json["buyAmt"];
    _buyDac = json["buyDac"];
    _smsCode = json["smsCode"];
    _exRate = json["exRate"];
    _sellAmt = json["sellAmt"];
    _exTime = json["exTime"];
    _sellCcy = json["sellCcy"];
    _payPassword = json["payPassword"];
    _sellDac = json["sellDac"];
    _availableBalance = json["availableBalance"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["buyCcy"] = _buyCcy;
    map["prodCd"] = _prodCd;
    map["buyAmt"] = _buyAmt;
    map["buyDac"] = _buyDac;
    map["smsCode"] = _smsCode;
    map["exRate"] = _exRate;
    map["sellAmt"] = _sellAmt;
    map["exTime"] = _exTime;
    map["sellCcy"] = _sellCcy;
    map["payPassword"] = _payPassword;
    map["sellDac"] = _sellDac;
    map["availableBalance"] = _availableBalance;
    return map;
  }

}
/// userId : "989185387615485977"
/// userName : null
/// assignee : null
/// processTitle : "openTdContractApprovalTitle"
/// processKey : "openTdContractApproval"
/// businessKey : null
/// tenantId : null
/// operateBeforeValue : null
/// operateEndValue : {"ciNo":"818000000113","bppdCode":"TDCBCBSC","prodName":"CORPORATE - BASIC","tenor":"M001","auctCale":"1","accuPeriod":"2","depositType":"A","ccy":"USD","bal":"1000","settDdAc":"0101208000001528","oppAc":"0101208000001528","instCode":"1","payPassword":"","smsCode":"","annualInterestRate":"2.0"}
/// servCtr : "hbs-ebank-general-service"
/// custId : null
/// commentList : []
/// result : true
/// taskKey : "TASK1"
/// taskCount : 1

class OpenTdContractDetailModel {
  String _userId;
  dynamic _userName;
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
  dynamic get userName => _userName;
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

  OpenTdContractDetailModel({
      String userId, 
      dynamic userName, 
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

  OpenTdContractDetailModel.fromJson(dynamic json) {
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

/// ciNo : "818000000113"
/// bppdCode : "TDCBCBSC"
/// prodName : "CORPORATE - BASIC"
/// tenor : "M001"
/// auctCale : "1"
/// accuPeriod : "2"
/// depositType : "A"
/// ccy : "USD"
/// bal : "1000"
/// settDdAc : "0101208000001528"
/// oppAc : "0101208000001528"
/// instCode : "1"
/// payPassword : ""
/// smsCode : ""
/// annualInterestRate : "2.0"

class OperateEndValue {
  String _ciNo;
  String _bppdCode;
  String _prodName;
  String _tenor;
  String _auctCale;
  String _accuPeriod;
  String _depositType;
  String _ccy;
  String _bal;
  String _settDdAc;
  String _oppAc;
  String _instCode;
  String _payPassword;
  String _smsCode;
  String _annualInterestRate;

  String get ciNo => _ciNo;
  String get bppdCode => _bppdCode;
  String get prodName => _prodName;
  String get tenor => _tenor;
  String get auctCale => _auctCale;
  String get accuPeriod => _accuPeriod;
  String get depositType => _depositType;
  String get ccy => _ccy;
  String get bal => _bal;
  String get settDdAc => _settDdAc;
  String get oppAc => _oppAc;
  String get instCode => _instCode;
  String get payPassword => _payPassword;
  String get smsCode => _smsCode;
  String get annualInterestRate => _annualInterestRate;

  OperateEndValue({
      String ciNo, 
      String bppdCode, 
      String prodName, 
      String tenor, 
      String auctCale, 
      String accuPeriod, 
      String depositType, 
      String ccy, 
      String bal, 
      String settDdAc, 
      String oppAc, 
      String instCode, 
      String payPassword, 
      String smsCode, 
      String annualInterestRate}){
    _ciNo = ciNo;
    _bppdCode = bppdCode;
    _prodName = prodName;
    _tenor = tenor;
    _auctCale = auctCale;
    _accuPeriod = accuPeriod;
    _depositType = depositType;
    _ccy = ccy;
    _bal = bal;
    _settDdAc = settDdAc;
    _oppAc = oppAc;
    _instCode = instCode;
    _payPassword = payPassword;
    _smsCode = smsCode;
    _annualInterestRate = annualInterestRate;
}

  OperateEndValue.fromJson(dynamic json) {
    _ciNo = json["ciNo"];
    _bppdCode = json["bppdCode"];
    _prodName = json["prodName"];
    _tenor = json["tenor"];
    _auctCale = json["auctCale"];
    _accuPeriod = json["accuPeriod"];
    _depositType = json["depositType"];
    _ccy = json["ccy"];
    _bal = json["bal"];
    _settDdAc = json["settDdAc"];
    _oppAc = json["oppAc"];
    _instCode = json["instCode"];
    _payPassword = json["payPassword"];
    _smsCode = json["smsCode"];
    _annualInterestRate = json["annualInterestRate"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["ciNo"] = _ciNo;
    map["bppdCode"] = _bppdCode;
    map["prodName"] = _prodName;
    map["tenor"] = _tenor;
    map["auctCale"] = _auctCale;
    map["accuPeriod"] = _accuPeriod;
    map["depositType"] = _depositType;
    map["ccy"] = _ccy;
    map["bal"] = _bal;
    map["settDdAc"] = _settDdAc;
    map["oppAc"] = _oppAc;
    map["instCode"] = _instCode;
    map["payPassword"] = _payPassword;
    map["smsCode"] = _smsCode;
    map["annualInterestRate"] = _annualInterestRate;
    return map;
  }

}
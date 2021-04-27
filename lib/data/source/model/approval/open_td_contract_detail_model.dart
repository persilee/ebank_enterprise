/// userId : "829378395983839232"
/// userName : "HSG15 Checker"
/// assigneeList : null
/// approverNumbers : 0
/// processTitle : "openTdContractApprovalTitle"
/// processKey : "openTdContractApproval"
/// businessKey : null
/// tenantId : null
/// operateBeforeValue : null
/// operateEndValue : {"auctCale":"1","oppAc":"0001208000001428","bppdCode":"TDCBCBSC","settDdAc":"0001208000001428","smsCode":"","ciNo":"878000000678","intAc":"","bal":"1002","tenor":"D001","accuPeriod":"1","annualInterestRate":"0.2","prodName":"Time Deposit - Corporate - Basic","ccy":"USD","instCode":"6","payPassword":"","depositType":"A"}
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

class OpenTdContractDetailModel {
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

  OpenTdContractDetailModel({
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

  OpenTdContractDetailModel.fromJson(dynamic json) {
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

/// auctCale : "1"
/// oppAc : "0001208000001428"
/// bppdCode : "TDCBCBSC"
/// settDdAc : "0001208000001428"
/// smsCode : ""
/// ciNo : "878000000678"
/// intAc : ""
/// bal : "1002"
/// tenor : "D001"
/// accuPeriod : "1"
/// annualInterestRate : "0.2"
/// prodName : "Time Deposit - Corporate - Basic"
/// ccy : "USD"
/// instCode : "6"
/// payPassword : ""
/// depositType : "A"

class OperateEndValue {
  String _auctCale;
  String _oppAc;
  String _bppdCode;
  String _settDdAc;
  String _smsCode;
  String _ciNo;
  String _intAc;
  String _bal;
  String _tenor;
  String _accuPeriod;
  String _annualInterestRate;
  String _prodName;
  String _ccy;
  String _instCode;
  String _payPassword;
  String _depositType;

  String get auctCale => _auctCale;
  String get oppAc => _oppAc;
  String get bppdCode => _bppdCode;
  String get settDdAc => _settDdAc;
  String get smsCode => _smsCode;
  String get ciNo => _ciNo;
  String get intAc => _intAc;
  String get bal => _bal;
  String get tenor => _tenor;
  String get accuPeriod => _accuPeriod;
  String get annualInterestRate => _annualInterestRate;
  String get prodName => _prodName;
  String get ccy => _ccy;
  String get instCode => _instCode;
  String get payPassword => _payPassword;
  String get depositType => _depositType;

  OperateEndValue({
      String auctCale, 
      String oppAc, 
      String bppdCode, 
      String settDdAc, 
      String smsCode, 
      String ciNo, 
      String intAc, 
      String bal, 
      String tenor, 
      String accuPeriod, 
      String annualInterestRate, 
      String prodName, 
      String ccy, 
      String instCode, 
      String payPassword, 
      String depositType}){
    _auctCale = auctCale;
    _oppAc = oppAc;
    _bppdCode = bppdCode;
    _settDdAc = settDdAc;
    _smsCode = smsCode;
    _ciNo = ciNo;
    _intAc = intAc;
    _bal = bal;
    _tenor = tenor;
    _accuPeriod = accuPeriod;
    _annualInterestRate = annualInterestRate;
    _prodName = prodName;
    _ccy = ccy;
    _instCode = instCode;
    _payPassword = payPassword;
    _depositType = depositType;
}

  OperateEndValue.fromJson(dynamic json) {
    _auctCale = json["auctCale"];
    _oppAc = json["oppAc"];
    _bppdCode = json["bppdCode"];
    _settDdAc = json["settDdAc"];
    _smsCode = json["smsCode"];
    _ciNo = json["ciNo"];
    _intAc = json["intAc"];
    _bal = json["bal"];
    _tenor = json["tenor"];
    _accuPeriod = json["accuPeriod"];
    _annualInterestRate = json["annualInterestRate"];
    _prodName = json["prodName"];
    _ccy = json["ccy"];
    _instCode = json["instCode"];
    _payPassword = json["payPassword"];
    _depositType = json["depositType"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["auctCale"] = _auctCale;
    map["oppAc"] = _oppAc;
    map["bppdCode"] = _bppdCode;
    map["settDdAc"] = _settDdAc;
    map["smsCode"] = _smsCode;
    map["ciNo"] = _ciNo;
    map["intAc"] = _intAc;
    map["bal"] = _bal;
    map["tenor"] = _tenor;
    map["accuPeriod"] = _accuPeriod;
    map["annualInterestRate"] = _annualInterestRate;
    map["prodName"] = _prodName;
    map["ccy"] = _ccy;
    map["instCode"] = _instCode;
    map["payPassword"] = _payPassword;
    map["depositType"] = _depositType;
    return map;
  }

}
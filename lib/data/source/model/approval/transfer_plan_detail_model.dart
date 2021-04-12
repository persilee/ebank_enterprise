/// userId : "989185387615485978"
/// userName : "高阳寰球"
/// assignee : null
/// processTitle : "transferPlanApprovalTitle"
/// processKey : "transferPlanApproval"
/// businessKey : null
/// tenantId : null
/// operateBeforeValue : null
/// operateEndValue : {"planId":"827265810824167424","planName":"哈哈","frequency":"0","startDate":"2021-04-02","endDate":"2021-04-02","enabled":false,"payeeName":"测试银行","payeeCardNo":"0101208000001528","payeeBankCode":"AAAMFRP1XXX","amount":"100","debitCurrency":"CNY","creditCurrency":"CNY","payerCardNo":"0101208000001528","payerName":"","payerBankCode":"AAAMFRP1XXX","feeAmount":"0","transferType":"0","district":"","city":"","remitterAddress":"","payeeAddress":"","bankSwift":"","midBankSwift":"","remittancePurposes":"","costOptions":"","remark":"","payPassword":"L5o+WYWLFVSCqHbd0Szu4Q==","smsCode":"123456"}
/// servCtr : "hbs-ebank-general-service"
/// custId : null
/// commentList : []
/// result : true
/// taskKey : "TASK1"
/// taskCount : 1

class TransferPlanDetailModel {
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

  TransferPlanDetailModel({
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

  TransferPlanDetailModel.fromJson(dynamic json) {
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

/// planId : "827265810824167424"
/// planName : "哈哈"
/// frequency : "0"
/// startDate : "2021-04-02"
/// endDate : "2021-04-02"
/// enabled : false
/// payeeName : "测试银行"
/// payeeCardNo : "0101208000001528"
/// payeeBankCode : "AAAMFRP1XXX"
/// amount : "100"
/// debitCurrency : "CNY"
/// creditCurrency : "CNY"
/// payerCardNo : "0101208000001528"
/// payerName : ""
/// payerBankCode : "AAAMFRP1XXX"
/// feeAmount : "0"
/// transferType : "0"
/// district : ""
/// city : ""
/// remitterAddress : ""
/// payeeAddress : ""
/// bankSwift : ""
/// midBankSwift : ""
/// remittancePurposes : ""
/// costOptions : ""
/// remark : ""
/// payPassword : "L5o+WYWLFVSCqHbd0Szu4Q=="
/// smsCode : "123456"

class OperateEndValue {
  String _planId;
  String _planName;
  String _frequency;
  String _startDate;
  String _endDate;
  bool _enabled;
  String _payeeName;
  String _payeeCardNo;
  String _payeeBankCode;
  String _amount;
  String _debitCurrency;
  String _creditCurrency;
  String _payerCardNo;
  String _payerName;
  String _payerBankCode;
  String _feeAmount;
  String _transferType;
  String _district;
  String _city;
  String _remitterAddress;
  String _payeeAddress;
  String _bankSwift;
  String _midBankSwift;
  String _remittancePurposes;
  String _costOptions;
  String _remark;
  String _payPassword;
  String _smsCode;

  String get planId => _planId;
  String get planName => _planName;
  String get frequency => _frequency;
  String get startDate => _startDate;
  String get endDate => _endDate;
  bool get enabled => _enabled;
  String get payeeName => _payeeName;
  String get payeeCardNo => _payeeCardNo;
  String get payeeBankCode => _payeeBankCode;
  String get amount => _amount;
  String get debitCurrency => _debitCurrency;
  String get creditCurrency => _creditCurrency;
  String get payerCardNo => _payerCardNo;
  String get payerName => _payerName;
  String get payerBankCode => _payerBankCode;
  String get feeAmount => _feeAmount;
  String get transferType => _transferType;
  String get district => _district;
  String get city => _city;
  String get remitterAddress => _remitterAddress;
  String get payeeAddress => _payeeAddress;
  String get bankSwift => _bankSwift;
  String get midBankSwift => _midBankSwift;
  String get remittancePurposes => _remittancePurposes;
  String get costOptions => _costOptions;
  String get remark => _remark;
  String get payPassword => _payPassword;
  String get smsCode => _smsCode;

  OperateEndValue({
      String planId, 
      String planName, 
      String frequency, 
      String startDate, 
      String endDate, 
      bool enabled, 
      String payeeName, 
      String payeeCardNo, 
      String payeeBankCode, 
      String amount, 
      String debitCurrency, 
      String creditCurrency, 
      String payerCardNo, 
      String payerName, 
      String payerBankCode, 
      String feeAmount, 
      String transferType, 
      String district, 
      String city, 
      String remitterAddress, 
      String payeeAddress, 
      String bankSwift, 
      String midBankSwift, 
      String remittancePurposes, 
      String costOptions, 
      String remark, 
      String payPassword, 
      String smsCode}){
    _planId = planId;
    _planName = planName;
    _frequency = frequency;
    _startDate = startDate;
    _endDate = endDate;
    _enabled = enabled;
    _payeeName = payeeName;
    _payeeCardNo = payeeCardNo;
    _payeeBankCode = payeeBankCode;
    _amount = amount;
    _debitCurrency = debitCurrency;
    _creditCurrency = creditCurrency;
    _payerCardNo = payerCardNo;
    _payerName = payerName;
    _payerBankCode = payerBankCode;
    _feeAmount = feeAmount;
    _transferType = transferType;
    _district = district;
    _city = city;
    _remitterAddress = remitterAddress;
    _payeeAddress = payeeAddress;
    _bankSwift = bankSwift;
    _midBankSwift = midBankSwift;
    _remittancePurposes = remittancePurposes;
    _costOptions = costOptions;
    _remark = remark;
    _payPassword = payPassword;
    _smsCode = smsCode;
}

  OperateEndValue.fromJson(dynamic json) {
    _planId = json["planId"];
    _planName = json["planName"];
    _frequency = json["frequency"];
    _startDate = json["startDate"];
    _endDate = json["endDate"];
    _enabled = json["enabled"];
    _payeeName = json["payeeName"];
    _payeeCardNo = json["payeeCardNo"];
    _payeeBankCode = json["payeeBankCode"];
    _amount = json["amount"];
    _debitCurrency = json["debitCurrency"];
    _creditCurrency = json["creditCurrency"];
    _payerCardNo = json["payerCardNo"];
    _payerName = json["payerName"];
    _payerBankCode = json["payerBankCode"];
    _feeAmount = json["feeAmount"];
    _transferType = json["transferType"];
    _district = json["district"];
    _city = json["city"];
    _remitterAddress = json["remitterAddress"];
    _payeeAddress = json["payeeAddress"];
    _bankSwift = json["bankSwift"];
    _midBankSwift = json["midBankSwift"];
    _remittancePurposes = json["remittancePurposes"];
    _costOptions = json["costOptions"];
    _remark = json["remark"];
    _payPassword = json["payPassword"];
    _smsCode = json["smsCode"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["planId"] = _planId;
    map["planName"] = _planName;
    map["frequency"] = _frequency;
    map["startDate"] = _startDate;
    map["endDate"] = _endDate;
    map["enabled"] = _enabled;
    map["payeeName"] = _payeeName;
    map["payeeCardNo"] = _payeeCardNo;
    map["payeeBankCode"] = _payeeBankCode;
    map["amount"] = _amount;
    map["debitCurrency"] = _debitCurrency;
    map["creditCurrency"] = _creditCurrency;
    map["payerCardNo"] = _payerCardNo;
    map["payerName"] = _payerName;
    map["payerBankCode"] = _payerBankCode;
    map["feeAmount"] = _feeAmount;
    map["transferType"] = _transferType;
    map["district"] = _district;
    map["city"] = _city;
    map["remitterAddress"] = _remitterAddress;
    map["payeeAddress"] = _payeeAddress;
    map["bankSwift"] = _bankSwift;
    map["midBankSwift"] = _midBankSwift;
    map["remittancePurposes"] = _remittancePurposes;
    map["costOptions"] = _costOptions;
    map["remark"] = _remark;
    map["payPassword"] = _payPassword;
    map["smsCode"] = _smsCode;
    return map;
  }

}
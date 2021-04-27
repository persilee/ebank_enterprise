/// userId : "829378511096512512"
/// userName : "HSG16 Checker"
/// assigneeList : null
/// approverNumbers : 0
/// processTitle : "internationalTransferApprovalTitle"
/// processKey : "internationalTransferApproval"
/// businessKey : null
/// tenantId : null
/// operateBeforeValue : null
/// operateEndValue : {"payeeAddress4":null,"debitCurrency":"USD","payeeName4":null,"payeeName3":null,"payeeBankCode":"BRLPKZ20","smsCode":"","remark":"转账","payeeAddress2":null,"payeeAddress3":null,"payerBankCode":"","payeeName":"ting","exchangeRate":"1","custId":"878000000678","payerName":"玛丽","payerCardNo":"0001208000001428","payeeCardNo":"8011268000002688","costOptions":"O","bankSwift":"11","debitAmount":"666","payeeAddress":"11","opt":"S","phone":null,"district":"NI","payeeName2":null,"creditCurrency":"USD","creditAmount":"666","payPassword":""}
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

class InternationalTransferDetailModel {
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

  InternationalTransferDetailModel({
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

  InternationalTransferDetailModel.fromJson(dynamic json) {
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

/// payeeAddress4 : null
/// debitCurrency : "USD"
/// payeeName4 : null
/// payeeName3 : null
/// payeeBankCode : "BRLPKZ20"
/// smsCode : ""
/// remark : "转账"
/// payeeAddress2 : null
/// payeeAddress3 : null
/// payerBankCode : ""
/// payeeName : "ting"
/// exchangeRate : "1"
/// custId : "878000000678"
/// payerName : "玛丽"
/// payerCardNo : "0001208000001428"
/// payeeCardNo : "8011268000002688"
/// costOptions : "O"
/// bankSwift : "11"
/// debitAmount : "666"
/// payeeAddress : "11"
/// opt : "S"
/// phone : null
/// district : "NI"
/// payeeName2 : null
/// creditCurrency : "USD"
/// creditAmount : "666"
/// payPassword : ""

class OperateEndValue {
  dynamic _payeeAddress4;
  String _debitCurrency;
  dynamic _payeeName4;
  dynamic _payeeName3;
  String _payeeBankCode;
  String _smsCode;
  String _remark;
  dynamic _payeeAddress2;
  dynamic _payeeAddress3;
  String _payerBankCode;
  String _payeeName;
  String _exchangeRate;
  String _custId;
  String _payerName;
  String _payerCardNo;
  String _payeeCardNo;
  String _costOptions;
  String _bankSwift;
  String _debitAmount;
  String _payeeAddress;
  String _opt;
  dynamic _phone;
  String _district;
  dynamic _payeeName2;
  String _creditCurrency;
  String _creditAmount;
  String _payPassword;

  dynamic get payeeAddress4 => _payeeAddress4;
  String get debitCurrency => _debitCurrency;
  dynamic get payeeName4 => _payeeName4;
  dynamic get payeeName3 => _payeeName3;
  String get payeeBankCode => _payeeBankCode;
  String get smsCode => _smsCode;
  String get remark => _remark;
  dynamic get payeeAddress2 => _payeeAddress2;
  dynamic get payeeAddress3 => _payeeAddress3;
  String get payerBankCode => _payerBankCode;
  String get payeeName => _payeeName;
  String get exchangeRate => _exchangeRate;
  String get custId => _custId;
  String get payerName => _payerName;
  String get payerCardNo => _payerCardNo;
  String get payeeCardNo => _payeeCardNo;
  String get costOptions => _costOptions;
  String get bankSwift => _bankSwift;
  String get debitAmount => _debitAmount;
  String get payeeAddress => _payeeAddress;
  String get opt => _opt;
  dynamic get phone => _phone;
  String get district => _district;
  dynamic get payeeName2 => _payeeName2;
  String get creditCurrency => _creditCurrency;
  String get creditAmount => _creditAmount;
  String get payPassword => _payPassword;

  OperateEndValue({
      dynamic payeeAddress4, 
      String debitCurrency, 
      dynamic payeeName4, 
      dynamic payeeName3, 
      String payeeBankCode, 
      String smsCode, 
      String remark, 
      dynamic payeeAddress2, 
      dynamic payeeAddress3, 
      String payerBankCode, 
      String payeeName, 
      String exchangeRate, 
      String custId, 
      String payerName, 
      String payerCardNo, 
      String payeeCardNo, 
      String costOptions, 
      String bankSwift, 
      String debitAmount, 
      String payeeAddress, 
      String opt, 
      dynamic phone, 
      String district, 
      dynamic payeeName2, 
      String creditCurrency, 
      String creditAmount, 
      String payPassword}){
    _payeeAddress4 = payeeAddress4;
    _debitCurrency = debitCurrency;
    _payeeName4 = payeeName4;
    _payeeName3 = payeeName3;
    _payeeBankCode = payeeBankCode;
    _smsCode = smsCode;
    _remark = remark;
    _payeeAddress2 = payeeAddress2;
    _payeeAddress3 = payeeAddress3;
    _payerBankCode = payerBankCode;
    _payeeName = payeeName;
    _exchangeRate = exchangeRate;
    _custId = custId;
    _payerName = payerName;
    _payerCardNo = payerCardNo;
    _payeeCardNo = payeeCardNo;
    _costOptions = costOptions;
    _bankSwift = bankSwift;
    _debitAmount = debitAmount;
    _payeeAddress = payeeAddress;
    _opt = opt;
    _phone = phone;
    _district = district;
    _payeeName2 = payeeName2;
    _creditCurrency = creditCurrency;
    _creditAmount = creditAmount;
    _payPassword = payPassword;
}

  OperateEndValue.fromJson(dynamic json) {
    _payeeAddress4 = json["payeeAddress4"];
    _debitCurrency = json["debitCurrency"];
    _payeeName4 = json["payeeName4"];
    _payeeName3 = json["payeeName3"];
    _payeeBankCode = json["payeeBankCode"];
    _smsCode = json["smsCode"];
    _remark = json["remark"];
    _payeeAddress2 = json["payeeAddress2"];
    _payeeAddress3 = json["payeeAddress3"];
    _payerBankCode = json["payerBankCode"];
    _payeeName = json["payeeName"];
    _exchangeRate = json["exchangeRate"];
    _custId = json["custId"];
    _payerName = json["payerName"];
    _payerCardNo = json["payerCardNo"];
    _payeeCardNo = json["payeeCardNo"];
    _costOptions = json["costOptions"];
    _bankSwift = json["bankSwift"];
    _debitAmount = json["debitAmount"];
    _payeeAddress = json["payeeAddress"];
    _opt = json["opt"];
    _phone = json["phone"];
    _district = json["district"];
    _payeeName2 = json["payeeName2"];
    _creditCurrency = json["creditCurrency"];
    _creditAmount = json["creditAmount"];
    _payPassword = json["payPassword"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["payeeAddress4"] = _payeeAddress4;
    map["debitCurrency"] = _debitCurrency;
    map["payeeName4"] = _payeeName4;
    map["payeeName3"] = _payeeName3;
    map["payeeBankCode"] = _payeeBankCode;
    map["smsCode"] = _smsCode;
    map["remark"] = _remark;
    map["payeeAddress2"] = _payeeAddress2;
    map["payeeAddress3"] = _payeeAddress3;
    map["payerBankCode"] = _payerBankCode;
    map["payeeName"] = _payeeName;
    map["exchangeRate"] = _exchangeRate;
    map["custId"] = _custId;
    map["payerName"] = _payerName;
    map["payerCardNo"] = _payerCardNo;
    map["payeeCardNo"] = _payeeCardNo;
    map["costOptions"] = _costOptions;
    map["bankSwift"] = _bankSwift;
    map["debitAmount"] = _debitAmount;
    map["payeeAddress"] = _payeeAddress;
    map["opt"] = _opt;
    map["phone"] = _phone;
    map["district"] = _district;
    map["payeeName2"] = _payeeName2;
    map["creditCurrency"] = _creditCurrency;
    map["creditAmount"] = _creditAmount;
    map["payPassword"] = _payPassword;
    return map;
  }

}
/// userId : "829377988633034752"
/// userName : "HSG12 Checker"
/// assignee : null
/// processTitle : "internationalTransferApprovalTitle"
/// processKey : "internationalTransferApproval"
/// businessKey : null
/// tenantId : null
/// operateBeforeValue : null
/// operateEndValue : {"opt":"S","payerName":"Brillink Bank","payerBankCode":"BRLPKZ20","payerCardNo":"0001208000001428","payeeBankCode":"AAAMFRP1XXX","payeeCardNo":"8011278000002988","payeeName":"Smile Face","debitAmount":"3000","creditAmount":"3579000","remark":"","debitCurrency":"USD","creditCurrency":"HKD","payPassword":"OkDOYrdBTBcq36OKApyAlA==","smsCode":"123456","phone":null,"exchangeRate":"1193","payeeName2":null,"payeeName3":null,"payeeName4":null,"payeeAddress":"PARI","payeeAddress2":null,"payeeAddress3":null,"payeeAddress4":null,"bankSwift":"AAAMFRP1XXX","district":"US","custId":"878000000678","costOptions":""}
/// servCtr : "hbs-ebank-general-service"
/// custId : null
/// commentList : []
/// result : true
/// taskKey : "TASK1"
/// taskCount : 1

class InternationalTransferDetailModel {
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

  InternationalTransferDetailModel({
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

  InternationalTransferDetailModel.fromJson(dynamic json) {
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

/// opt : "S"
/// payerName : "Brillink Bank"
/// payerBankCode : "BRLPKZ20"
/// payerCardNo : "0001208000001428"
/// payeeBankCode : "AAAMFRP1XXX"
/// payeeCardNo : "8011278000002988"
/// payeeName : "Smile Face"
/// debitAmount : "3000"
/// creditAmount : "3579000"
/// remark : ""
/// debitCurrency : "USD"
/// creditCurrency : "HKD"
/// payPassword : "OkDOYrdBTBcq36OKApyAlA=="
/// smsCode : "123456"
/// phone : null
/// exchangeRate : "1193"
/// payeeName2 : null
/// payeeName3 : null
/// payeeName4 : null
/// payeeAddress : "PARI"
/// payeeAddress2 : null
/// payeeAddress3 : null
/// payeeAddress4 : null
/// bankSwift : "AAAMFRP1XXX"
/// district : "US"
/// custId : "878000000678"
/// costOptions : ""

class OperateEndValue {
  String _opt;
  String _payerName;
  String _payerBankCode;
  String _payerCardNo;
  String _payeeBankCode;
  String _payeeCardNo;
  String _payeeName;
  String _debitAmount;
  String _creditAmount;
  String _remark;
  String _debitCurrency;
  String _creditCurrency;
  String _payPassword;
  String _smsCode;
  dynamic _phone;
  String _exchangeRate;
  dynamic _payeeName2;
  dynamic _payeeName3;
  dynamic _payeeName4;
  String _payeeAddress;
  dynamic _payeeAddress2;
  dynamic _payeeAddress3;
  dynamic _payeeAddress4;
  String _bankSwift;
  String _district;
  String _custId;
  String _costOptions;

  String get opt => _opt;
  String get payerName => _payerName;
  String get payerBankCode => _payerBankCode;
  String get payerCardNo => _payerCardNo;
  String get payeeBankCode => _payeeBankCode;
  String get payeeCardNo => _payeeCardNo;
  String get payeeName => _payeeName;
  String get debitAmount => _debitAmount;
  String get creditAmount => _creditAmount;
  String get remark => _remark;
  String get debitCurrency => _debitCurrency;
  String get creditCurrency => _creditCurrency;
  String get payPassword => _payPassword;
  String get smsCode => _smsCode;
  dynamic get phone => _phone;
  String get exchangeRate => _exchangeRate;
  dynamic get payeeName2 => _payeeName2;
  dynamic get payeeName3 => _payeeName3;
  dynamic get payeeName4 => _payeeName4;
  String get payeeAddress => _payeeAddress;
  dynamic get payeeAddress2 => _payeeAddress2;
  dynamic get payeeAddress3 => _payeeAddress3;
  dynamic get payeeAddress4 => _payeeAddress4;
  String get bankSwift => _bankSwift;
  String get district => _district;
  String get custId => _custId;
  String get costOptions => _costOptions;

  OperateEndValue({
      String opt, 
      String payerName, 
      String payerBankCode, 
      String payerCardNo, 
      String payeeBankCode, 
      String payeeCardNo, 
      String payeeName, 
      String debitAmount, 
      String creditAmount, 
      String remark, 
      String debitCurrency, 
      String creditCurrency, 
      String payPassword, 
      String smsCode, 
      dynamic phone, 
      String exchangeRate, 
      dynamic payeeName2, 
      dynamic payeeName3, 
      dynamic payeeName4, 
      String payeeAddress, 
      dynamic payeeAddress2, 
      dynamic payeeAddress3, 
      dynamic payeeAddress4, 
      String bankSwift, 
      String district, 
      String custId, 
      String costOptions}){
    _opt = opt;
    _payerName = payerName;
    _payerBankCode = payerBankCode;
    _payerCardNo = payerCardNo;
    _payeeBankCode = payeeBankCode;
    _payeeCardNo = payeeCardNo;
    _payeeName = payeeName;
    _debitAmount = debitAmount;
    _creditAmount = creditAmount;
    _remark = remark;
    _debitCurrency = debitCurrency;
    _creditCurrency = creditCurrency;
    _payPassword = payPassword;
    _smsCode = smsCode;
    _phone = phone;
    _exchangeRate = exchangeRate;
    _payeeName2 = payeeName2;
    _payeeName3 = payeeName3;
    _payeeName4 = payeeName4;
    _payeeAddress = payeeAddress;
    _payeeAddress2 = payeeAddress2;
    _payeeAddress3 = payeeAddress3;
    _payeeAddress4 = payeeAddress4;
    _bankSwift = bankSwift;
    _district = district;
    _custId = custId;
    _costOptions = costOptions;
}

  OperateEndValue.fromJson(dynamic json) {
    _opt = json["opt"];
    _payerName = json["payerName"];
    _payerBankCode = json["payerBankCode"];
    _payerCardNo = json["payerCardNo"];
    _payeeBankCode = json["payeeBankCode"];
    _payeeCardNo = json["payeeCardNo"];
    _payeeName = json["payeeName"];
    _debitAmount = json["debitAmount"];
    _creditAmount = json["creditAmount"];
    _remark = json["remark"];
    _debitCurrency = json["debitCurrency"];
    _creditCurrency = json["creditCurrency"];
    _payPassword = json["payPassword"];
    _smsCode = json["smsCode"];
    _phone = json["phone"];
    _exchangeRate = json["exchangeRate"];
    _payeeName2 = json["payeeName2"];
    _payeeName3 = json["payeeName3"];
    _payeeName4 = json["payeeName4"];
    _payeeAddress = json["payeeAddress"];
    _payeeAddress2 = json["payeeAddress2"];
    _payeeAddress3 = json["payeeAddress3"];
    _payeeAddress4 = json["payeeAddress4"];
    _bankSwift = json["bankSwift"];
    _district = json["district"];
    _custId = json["custId"];
    _costOptions = json["costOptions"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["opt"] = _opt;
    map["payerName"] = _payerName;
    map["payerBankCode"] = _payerBankCode;
    map["payerCardNo"] = _payerCardNo;
    map["payeeBankCode"] = _payeeBankCode;
    map["payeeCardNo"] = _payeeCardNo;
    map["payeeName"] = _payeeName;
    map["debitAmount"] = _debitAmount;
    map["creditAmount"] = _creditAmount;
    map["remark"] = _remark;
    map["debitCurrency"] = _debitCurrency;
    map["creditCurrency"] = _creditCurrency;
    map["payPassword"] = _payPassword;
    map["smsCode"] = _smsCode;
    map["phone"] = _phone;
    map["exchangeRate"] = _exchangeRate;
    map["payeeName2"] = _payeeName2;
    map["payeeName3"] = _payeeName3;
    map["payeeName4"] = _payeeName4;
    map["payeeAddress"] = _payeeAddress;
    map["payeeAddress2"] = _payeeAddress2;
    map["payeeAddress3"] = _payeeAddress3;
    map["payeeAddress4"] = _payeeAddress4;
    map["bankSwift"] = _bankSwift;
    map["district"] = _district;
    map["custId"] = _custId;
    map["costOptions"] = _costOptions;
    return map;
  }

}
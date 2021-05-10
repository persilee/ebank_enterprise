/// userId : "829377175969857536"
/// userName : "HSG06 Maker"
/// assigneeList : null
/// approverNumbers : 0
/// processTitle : "oneToOneTransferApprovalTitle"
/// processKey : "oneToOneTransferApproval"
/// businessKey : null
/// tenantId : null
/// operateBeforeValue : null
/// operateEndValue : {"debitCurrency":"USD","payeeBankCode":"AAAMFRP1XXX","smsCode":"123456","remark":"","debitAmount":"602","payerBankCode":"","payeeName":"test0002","feeAmount":null,"opt":"S","phone":"","exchangeRate":"1","feeCode":null,"payerName":"MALI","creditCurrency":"USD","creditAmount":"602","payPassword":"M5OYX84cxGWrQ6RKvW5kVQ==","payerCardNo":"0001278000001418","payeeCardNo":"8011298000002818"}
/// servCtr : "hbs-ebank-general-service"
/// custId : null
/// amount : null
/// ccy : null
/// authModel : null
/// amountPosition : null
/// serviceType : null
/// authGroups : null
/// commentList : [{"userName":"829378163250298880","result":true,"comment":"1","time":"2021-05-10 15:42:51"}]
/// result : "1"
/// taskKey : null
/// taskCount : null
/// optBefJsonValue : null
/// optEndJsonValue : null

class OneToOneTransferDetailModel {
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
  List<CommentList> _commentList;
  String _result;
  dynamic _taskKey;
  dynamic _taskCount;
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
  List<CommentList> get commentList => _commentList;
  String get result => _result;
  dynamic get taskKey => _taskKey;
  dynamic get taskCount => _taskCount;
  dynamic get optBefJsonValue => _optBefJsonValue;
  dynamic get optEndJsonValue => _optEndJsonValue;

  OneToOneTransferDetailModel({
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
      List<CommentList> commentList, 
      String result, 
      dynamic taskKey, 
      dynamic taskCount, 
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

  OneToOneTransferDetailModel.fromJson(dynamic json) {
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
        _commentList.add(CommentList.fromJson(v));
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

/// userName : "829378163250298880"
/// result : true
/// comment : "1"
/// time : "2021-05-10 15:42:51"

class CommentList {
  String _userName;
  bool _result;
  String _comment;
  String _time;

  String get userName => _userName;
  bool get result => _result;
  String get comment => _comment;
  String get time => _time;

  CommentList({
      String userName, 
      bool result, 
      String comment, 
      String time}){
    _userName = userName;
    _result = result;
    _comment = comment;
    _time = time;
}

  CommentList.fromJson(dynamic json) {
    _userName = json["userName"];
    _result = json["result"];
    _comment = json["comment"];
    _time = json["time"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["userName"] = _userName;
    map["result"] = _result;
    map["comment"] = _comment;
    map["time"] = _time;
    return map;
  }

}

/// debitCurrency : "USD"
/// payeeBankCode : "AAAMFRP1XXX"
/// smsCode : "123456"
/// remark : ""
/// debitAmount : "602"
/// payerBankCode : ""
/// payeeName : "test0002"
/// feeAmount : null
/// opt : "S"
/// phone : ""
/// exchangeRate : "1"
/// feeCode : null
/// payerName : "MALI"
/// creditCurrency : "USD"
/// creditAmount : "602"
/// payPassword : "M5OYX84cxGWrQ6RKvW5kVQ=="
/// payerCardNo : "0001278000001418"
/// payeeCardNo : "8011298000002818"

class OperateEndValue {
  String _debitCurrency;
  String _payeeBankCode;
  String _smsCode;
  String _remark;
  String _debitAmount;
  String _payerBankCode;
  String _payeeName;
  dynamic _feeAmount;
  String _opt;
  String _phone;
  String _exchangeRate;
  dynamic _feeCode;
  String _payerName;
  String _creditCurrency;
  String _creditAmount;
  String _payPassword;
  String _payerCardNo;
  String _payeeCardNo;

  String get debitCurrency => _debitCurrency;
  String get payeeBankCode => _payeeBankCode;
  String get smsCode => _smsCode;
  String get remark => _remark;
  String get debitAmount => _debitAmount;
  String get payerBankCode => _payerBankCode;
  String get payeeName => _payeeName;
  dynamic get feeAmount => _feeAmount;
  String get opt => _opt;
  String get phone => _phone;
  String get exchangeRate => _exchangeRate;
  dynamic get feeCode => _feeCode;
  String get payerName => _payerName;
  String get creditCurrency => _creditCurrency;
  String get creditAmount => _creditAmount;
  String get payPassword => _payPassword;
  String get payerCardNo => _payerCardNo;
  String get payeeCardNo => _payeeCardNo;

  OperateEndValue({
      String debitCurrency, 
      String payeeBankCode, 
      String smsCode, 
      String remark, 
      String debitAmount, 
      String payerBankCode, 
      String payeeName, 
      dynamic feeAmount, 
      String opt, 
      String phone, 
      String exchangeRate, 
      dynamic feeCode, 
      String payerName, 
      String creditCurrency, 
      String creditAmount, 
      String payPassword, 
      String payerCardNo, 
      String payeeCardNo}){
    _debitCurrency = debitCurrency;
    _payeeBankCode = payeeBankCode;
    _smsCode = smsCode;
    _remark = remark;
    _debitAmount = debitAmount;
    _payerBankCode = payerBankCode;
    _payeeName = payeeName;
    _feeAmount = feeAmount;
    _opt = opt;
    _phone = phone;
    _exchangeRate = exchangeRate;
    _feeCode = feeCode;
    _payerName = payerName;
    _creditCurrency = creditCurrency;
    _creditAmount = creditAmount;
    _payPassword = payPassword;
    _payerCardNo = payerCardNo;
    _payeeCardNo = payeeCardNo;
}

  OperateEndValue.fromJson(dynamic json) {
    _debitCurrency = json["debitCurrency"];
    _payeeBankCode = json["payeeBankCode"];
    _smsCode = json["smsCode"];
    _remark = json["remark"];
    _debitAmount = json["debitAmount"];
    _payerBankCode = json["payerBankCode"];
    _payeeName = json["payeeName"];
    _feeAmount = json["feeAmount"];
    _opt = json["opt"];
    _phone = json["phone"];
    _exchangeRate = json["exchangeRate"];
    _feeCode = json["feeCode"];
    _payerName = json["payerName"];
    _creditCurrency = json["creditCurrency"];
    _creditAmount = json["creditAmount"];
    _payPassword = json["payPassword"];
    _payerCardNo = json["payerCardNo"];
    _payeeCardNo = json["payeeCardNo"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["debitCurrency"] = _debitCurrency;
    map["payeeBankCode"] = _payeeBankCode;
    map["smsCode"] = _smsCode;
    map["remark"] = _remark;
    map["debitAmount"] = _debitAmount;
    map["payerBankCode"] = _payerBankCode;
    map["payeeName"] = _payeeName;
    map["feeAmount"] = _feeAmount;
    map["opt"] = _opt;
    map["phone"] = _phone;
    map["exchangeRate"] = _exchangeRate;
    map["feeCode"] = _feeCode;
    map["payerName"] = _payerName;
    map["creditCurrency"] = _creditCurrency;
    map["creditAmount"] = _creditAmount;
    map["payPassword"] = _payPassword;
    map["payerCardNo"] = _payerCardNo;
    map["payeeCardNo"] = _payeeCardNo;
    return map;
  }

}
/// userId : "829377766448168960"
/// userName : "HSG10 Maker"
/// assignee : null
/// processTitle : "postRepaymentApprovalTitle"
/// processKey : "postRepaymentApproval"
/// businessKey : null
/// tenantId : null
/// operateBeforeValue : null
/// operateEndValue : {"payPassword":null,"acNo":"80131380030007880001","ccy":"USD","prin":"1000000","outBal":"1000000","repaymentMethod":null,"trValDate":null,"principalAmount":"5000","interestAmount":"0","penaltyAmount":null,"compoundAmount":null,"totalAmount":"5000","setMethod":null,"ddAc":"8011208000001258","suspeac":null,"nostrac":null,"setlCcy":null,"exRate":null,"eqAmt":null,"instalNo":null,"refNo":null,"rescheduleType":null,"repaymentAcType":null,"repaymentAcNo":null,"repaymentCiName":null,"dueAmount":null}
/// servCtr : "hbs-ebank-general-service"
/// custId : null
/// commentList : []
/// result : true
/// taskKey : "TASK1"
/// taskCount : 1

class PostRepaymentModel {
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

  PostRepaymentModel({
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

  PostRepaymentModel.fromJson(dynamic json) {
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

/// payPassword : null
/// acNo : "80131380030007880001"
/// ccy : "USD"
/// prin : "1000000"
/// outBal : "1000000"
/// repaymentMethod : null
/// trValDate : null
/// principalAmount : "5000"
/// interestAmount : "0"
/// penaltyAmount : null
/// compoundAmount : null
/// totalAmount : "5000"
/// setMethod : null
/// ddAc : "8011208000001258"
/// suspeac : null
/// nostrac : null
/// setlCcy : null
/// exRate : null
/// eqAmt : null
/// instalNo : null
/// refNo : null
/// rescheduleType : null
/// repaymentAcType : null
/// repaymentAcNo : null
/// repaymentCiName : null
/// dueAmount : null

class OperateEndValue {
  dynamic _payPassword;
  String _acNo;
  String _ccy;
  String _prin;
  String _outBal;
  dynamic _repaymentMethod;
  dynamic _trValDate;
  String _principalAmount;
  String _interestAmount;
  dynamic _penaltyAmount;
  dynamic _compoundAmount;
  String _totalAmount;
  dynamic _setMethod;
  String _ddAc;
  dynamic _suspeac;
  dynamic _nostrac;
  dynamic _setlCcy;
  dynamic _exRate;
  dynamic _eqAmt;
  dynamic _instalNo;
  dynamic _refNo;
  dynamic _rescheduleType;
  dynamic _repaymentAcType;
  dynamic _repaymentAcNo;
  dynamic _repaymentCiName;
  dynamic _dueAmount;

  dynamic get payPassword => _payPassword;
  String get acNo => _acNo;
  String get ccy => _ccy;
  String get prin => _prin;
  String get outBal => _outBal;
  dynamic get repaymentMethod => _repaymentMethod;
  dynamic get trValDate => _trValDate;
  String get principalAmount => _principalAmount;
  String get interestAmount => _interestAmount;
  dynamic get penaltyAmount => _penaltyAmount;
  dynamic get compoundAmount => _compoundAmount;
  String get totalAmount => _totalAmount;
  dynamic get setMethod => _setMethod;
  String get ddAc => _ddAc;
  dynamic get suspeac => _suspeac;
  dynamic get nostrac => _nostrac;
  dynamic get setlCcy => _setlCcy;
  dynamic get exRate => _exRate;
  dynamic get eqAmt => _eqAmt;
  dynamic get instalNo => _instalNo;
  dynamic get refNo => _refNo;
  dynamic get rescheduleType => _rescheduleType;
  dynamic get repaymentAcType => _repaymentAcType;
  dynamic get repaymentAcNo => _repaymentAcNo;
  dynamic get repaymentCiName => _repaymentCiName;
  dynamic get dueAmount => _dueAmount;

  OperateEndValue({
      dynamic payPassword, 
      String acNo, 
      String ccy, 
      String prin, 
      String outBal, 
      dynamic repaymentMethod, 
      dynamic trValDate, 
      String principalAmount, 
      String interestAmount, 
      dynamic penaltyAmount, 
      dynamic compoundAmount, 
      String totalAmount, 
      dynamic setMethod, 
      String ddAc, 
      dynamic suspeac, 
      dynamic nostrac, 
      dynamic setlCcy, 
      dynamic exRate, 
      dynamic eqAmt, 
      dynamic instalNo, 
      dynamic refNo, 
      dynamic rescheduleType, 
      dynamic repaymentAcType, 
      dynamic repaymentAcNo, 
      dynamic repaymentCiName, 
      dynamic dueAmount}){
    _payPassword = payPassword;
    _acNo = acNo;
    _ccy = ccy;
    _prin = prin;
    _outBal = outBal;
    _repaymentMethod = repaymentMethod;
    _trValDate = trValDate;
    _principalAmount = principalAmount;
    _interestAmount = interestAmount;
    _penaltyAmount = penaltyAmount;
    _compoundAmount = compoundAmount;
    _totalAmount = totalAmount;
    _setMethod = setMethod;
    _ddAc = ddAc;
    _suspeac = suspeac;
    _nostrac = nostrac;
    _setlCcy = setlCcy;
    _exRate = exRate;
    _eqAmt = eqAmt;
    _instalNo = instalNo;
    _refNo = refNo;
    _rescheduleType = rescheduleType;
    _repaymentAcType = repaymentAcType;
    _repaymentAcNo = repaymentAcNo;
    _repaymentCiName = repaymentCiName;
    _dueAmount = dueAmount;
}

  OperateEndValue.fromJson(dynamic json) {
    _payPassword = json["payPassword"];
    _acNo = json["acNo"];
    _ccy = json["ccy"];
    _prin = json["prin"];
    _outBal = json["outBal"];
    _repaymentMethod = json["repaymentMethod"];
    _trValDate = json["trValDate"];
    _principalAmount = json["principalAmount"];
    _interestAmount = json["interestAmount"];
    _penaltyAmount = json["penaltyAmount"];
    _compoundAmount = json["compoundAmount"];
    _totalAmount = json["totalAmount"];
    _setMethod = json["setMethod"];
    _ddAc = json["ddAc"];
    _suspeac = json["suspeac"];
    _nostrac = json["nostrac"];
    _setlCcy = json["setlCcy"];
    _exRate = json["exRate"];
    _eqAmt = json["eqAmt"];
    _instalNo = json["instalNo"];
    _refNo = json["refNo"];
    _rescheduleType = json["rescheduleType"];
    _repaymentAcType = json["repaymentAcType"];
    _repaymentAcNo = json["repaymentAcNo"];
    _repaymentCiName = json["repaymentCiName"];
    _dueAmount = json["dueAmount"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["payPassword"] = _payPassword;
    map["acNo"] = _acNo;
    map["ccy"] = _ccy;
    map["prin"] = _prin;
    map["outBal"] = _outBal;
    map["repaymentMethod"] = _repaymentMethod;
    map["trValDate"] = _trValDate;
    map["principalAmount"] = _principalAmount;
    map["interestAmount"] = _interestAmount;
    map["penaltyAmount"] = _penaltyAmount;
    map["compoundAmount"] = _compoundAmount;
    map["totalAmount"] = _totalAmount;
    map["setMethod"] = _setMethod;
    map["ddAc"] = _ddAc;
    map["suspeac"] = _suspeac;
    map["nostrac"] = _nostrac;
    map["setlCcy"] = _setlCcy;
    map["exRate"] = _exRate;
    map["eqAmt"] = _eqAmt;
    map["instalNo"] = _instalNo;
    map["refNo"] = _refNo;
    map["rescheduleType"] = _rescheduleType;
    map["repaymentAcType"] = _repaymentAcType;
    map["repaymentAcNo"] = _repaymentAcNo;
    map["repaymentCiName"] = _repaymentCiName;
    map["dueAmount"] = _dueAmount;
    return map;
  }

}
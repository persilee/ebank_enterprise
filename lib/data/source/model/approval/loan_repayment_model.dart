import 'find_user_application_task_detail.dart';

/// userId : "829378511096512512"
/// userName : "HSG16 Checker"
/// assigneeList : null
/// approverNumbers : 0
/// processTitle : "loanRepaymentApprovalTitle"
/// processKey : "loanRepaymentApproval"
/// businessKey : null
/// tenantId : null
/// operateBeforeValue : null
/// operateEndValue : {"repaymentMethod":null,"refNo":null,"repaymentAcNo":null,"instalNo":null,"principalAmount":"82952.08","outBal":"1000000","nostrac":null,"prin":"1000000","compoundAmount":null,"ccy":"USD","penaltyAmount":null,"rescheduleType":null,"repaymentAcType":null,"exRate":null,"trValDate":null,"interestAmount":"833.33","ddAc":"0001208000001428","acNo":"8013168003000798","repaymentCiName":null,"totalAmount":"84239.25","setMethod":null,"suspeac":null,"setlCcy":null,"dueAmount":null,"chgRat":null,"payPassword":"","eqAmt":null}
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

class LoanRepaymentModel {
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
  List<CommentList> get commentList => _commentList;
  String get result => _result;
  dynamic get taskKey => _taskKey;
  int get taskCount => _taskCount;
  dynamic get optBefJsonValue => _optBefJsonValue;
  dynamic get optEndJsonValue => _optEndJsonValue;

  LoanRepaymentModel(
      {String userId,
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
      int taskCount,
      dynamic optBefJsonValue,
      dynamic optEndJsonValue}) {
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

  LoanRepaymentModel.fromJson(dynamic json) {
    _userId = json["userId"];
    _userName = json["userName"];
    _assigneeList = json["assigneeList"];
    _approverNumbers = json["approverNumbers"];
    _processTitle = json["processTitle"];
    _processKey = json["processKey"];
    _businessKey = json["businessKey"];
    _tenantId = json["tenantId"];
    _operateBeforeValue = json["operateBeforeValue"];
    _operateEndValue = json["operateEndValue"] != null
        ? OperateEndValue.fromJson(json["operateEndValue"])
        : null;
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

/// repaymentMethod : null
/// refNo : null
/// repaymentAcNo : null
/// instalNo : null
/// principalAmount : "82952.08"
/// outBal : "1000000"
/// nostrac : null
/// prin : "1000000"
/// compoundAmount : null
/// ccy : "USD"
/// penaltyAmount : null
/// rescheduleType : null
/// repaymentAcType : null
/// exRate : null
/// trValDate : null
/// interestAmount : "833.33"
/// ddAc : "0001208000001428"
/// acNo : "8013168003000798"
/// repaymentCiName : null
/// totalAmount : "84239.25"
/// setMethod : null
/// suspeac : null
/// setlCcy : null
/// dueAmount : null
/// chgRat : null
/// payPassword : ""
/// eqAmt : null

class OperateEndValue {
  dynamic _repaymentMethod;
  dynamic _refNo;
  dynamic _repaymentAcNo;
  dynamic _instalNo;
  String _principalAmount;
  String _outBal;
  dynamic _nostrac;
  String _prin;
  dynamic _compoundAmount;
  String _ccy;
  dynamic _penaltyAmount;
  dynamic _rescheduleType;
  dynamic _repaymentAcType;
  dynamic _exRate;
  dynamic _trValDate;
  String _interestAmount;
  String _ddAc;
  String _acNo;
  dynamic _repaymentCiName;
  String _totalAmount;
  dynamic _setMethod;
  dynamic _suspeac;
  dynamic _setlCcy;
  dynamic _dueAmount;
  dynamic _chgRat;
  String _payPassword;
  dynamic _eqAmt;

  dynamic get repaymentMethod => _repaymentMethod;
  dynamic get refNo => _refNo;
  dynamic get repaymentAcNo => _repaymentAcNo;
  dynamic get instalNo => _instalNo;
  String get principalAmount => _principalAmount;
  String get outBal => _outBal;
  dynamic get nostrac => _nostrac;
  String get prin => _prin;
  dynamic get compoundAmount => _compoundAmount;
  String get ccy => _ccy;
  dynamic get penaltyAmount => _penaltyAmount;
  dynamic get rescheduleType => _rescheduleType;
  dynamic get repaymentAcType => _repaymentAcType;
  dynamic get exRate => _exRate;
  dynamic get trValDate => _trValDate;
  String get interestAmount => _interestAmount;
  String get ddAc => _ddAc;
  String get acNo => _acNo;
  dynamic get repaymentCiName => _repaymentCiName;
  String get totalAmount => _totalAmount;
  dynamic get setMethod => _setMethod;
  dynamic get suspeac => _suspeac;
  dynamic get setlCcy => _setlCcy;
  dynamic get dueAmount => _dueAmount;
  dynamic get chgRat => _chgRat;
  String get payPassword => _payPassword;
  dynamic get eqAmt => _eqAmt;

  OperateEndValue(
      {dynamic repaymentMethod,
      dynamic refNo,
      dynamic repaymentAcNo,
      dynamic instalNo,
      String principalAmount,
      String outBal,
      dynamic nostrac,
      String prin,
      dynamic compoundAmount,
      String ccy,
      dynamic penaltyAmount,
      dynamic rescheduleType,
      dynamic repaymentAcType,
      dynamic exRate,
      dynamic trValDate,
      String interestAmount,
      String ddAc,
      String acNo,
      dynamic repaymentCiName,
      String totalAmount,
      dynamic setMethod,
      dynamic suspeac,
      dynamic setlCcy,
      dynamic dueAmount,
      dynamic chgRat,
      String payPassword,
      dynamic eqAmt}) {
    _repaymentMethod = repaymentMethod;
    _refNo = refNo;
    _repaymentAcNo = repaymentAcNo;
    _instalNo = instalNo;
    _principalAmount = principalAmount;
    _outBal = outBal;
    _nostrac = nostrac;
    _prin = prin;
    _compoundAmount = compoundAmount;
    _ccy = ccy;
    _penaltyAmount = penaltyAmount;
    _rescheduleType = rescheduleType;
    _repaymentAcType = repaymentAcType;
    _exRate = exRate;
    _trValDate = trValDate;
    _interestAmount = interestAmount;
    _ddAc = ddAc;
    _acNo = acNo;
    _repaymentCiName = repaymentCiName;
    _totalAmount = totalAmount;
    _setMethod = setMethod;
    _suspeac = suspeac;
    _setlCcy = setlCcy;
    _dueAmount = dueAmount;
    _chgRat = chgRat;
    _payPassword = payPassword;
    _eqAmt = eqAmt;
  }

  OperateEndValue.fromJson(dynamic json) {
    _repaymentMethod = json["repaymentMethod"];
    _refNo = json["refNo"];
    _repaymentAcNo = json["repaymentAcNo"];
    _instalNo = json["instalNo"];
    _principalAmount = json["principalAmount"];
    _outBal = json["outBal"];
    _nostrac = json["nostrac"];
    _prin = json["prin"];
    _compoundAmount = json["compoundAmount"];
    _ccy = json["ccy"];
    _penaltyAmount = json["penaltyAmount"];
    _rescheduleType = json["rescheduleType"];
    _repaymentAcType = json["repaymentAcType"];
    _exRate = json["exRate"];
    _trValDate = json["trValDate"];
    _interestAmount = json["interestAmount"];
    _ddAc = json["ddAc"];
    _acNo = json["acNo"];
    _repaymentCiName = json["repaymentCiName"];
    _totalAmount = json["totalAmount"];
    _setMethod = json["setMethod"];
    _suspeac = json["suspeac"];
    _setlCcy = json["setlCcy"];
    _dueAmount = json["dueAmount"];
    _chgRat = json["chgRat"];
    _payPassword = json["payPassword"];
    _eqAmt = json["eqAmt"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["repaymentMethod"] = _repaymentMethod;
    map["refNo"] = _refNo;
    map["repaymentAcNo"] = _repaymentAcNo;
    map["instalNo"] = _instalNo;
    map["principalAmount"] = _principalAmount;
    map["outBal"] = _outBal;
    map["nostrac"] = _nostrac;
    map["prin"] = _prin;
    map["compoundAmount"] = _compoundAmount;
    map["ccy"] = _ccy;
    map["penaltyAmount"] = _penaltyAmount;
    map["rescheduleType"] = _rescheduleType;
    map["repaymentAcType"] = _repaymentAcType;
    map["exRate"] = _exRate;
    map["trValDate"] = _trValDate;
    map["interestAmount"] = _interestAmount;
    map["ddAc"] = _ddAc;
    map["acNo"] = _acNo;
    map["repaymentCiName"] = _repaymentCiName;
    map["totalAmount"] = _totalAmount;
    map["setMethod"] = _setMethod;
    map["suspeac"] = _suspeac;
    map["setlCcy"] = _setlCcy;
    map["dueAmount"] = _dueAmount;
    map["chgRat"] = _chgRat;
    map["payPassword"] = _payPassword;
    map["eqAmt"] = _eqAmt;
    return map;
  }
}

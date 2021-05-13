import 'package:ebank_mobile/data/source/model/approval/find_user_application_task_detail.dart';

/// userId : "829378641161879552"
/// userName : "HSG17 Checker"
/// assigneeList : null
/// approverNumbers : 0
/// processTitle : "loanWithDrawalApprovalTitle"
/// processKey : "loanWithDrawalApproval"
/// businessKey : null
/// tenantId : null
/// operateBeforeValue : null
/// operateEndValue : {"onRate":"1.34335353","inRate":"2.34335353","repType":"4","intRat":"1","setPerd":"1","matuDt":"2022-06-30","amt":"1234","ddAc":"0001208000001428","loanAmount":"1000000","fltNmth":"1","fPaydt":"2021-09-01","iratTm":"M012","repDay":1,"intNper":"0","lnac":"8013168003000798","insType":"1","setUnit":"M","ccy":"USD","loanPurpose":"1","iratCd":"TC0","totalInt":"6.76"}
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

class LoanWithDrawalModel {
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

  LoanWithDrawalModel(
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

  LoanWithDrawalModel.fromJson(dynamic json) {
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

/// onRate : "1.34335353"
/// inRate : "2.34335353"
/// repType : "4"
/// intRat : "1"
/// setPerd : "1"
/// matuDt : "2022-06-30"
/// amt : "1234"
/// ddAc : "0001208000001428"
/// loanAmount : "1000000"
/// fltNmth : "1"
/// fPaydt : "2021-09-01"
/// iratTm : "M012"
/// repDay : 1
/// intNper : "0"
/// lnac : "8013168003000798"
/// insType : "1"
/// setUnit : "M"
/// ccy : "USD"
/// loanPurpose : "1"
/// iratCd : "TC0"
/// totalInt : "6.76"

class OperateEndValue {
  String _onRate;
  String _inRate;
  String _repType;
  String _intRat;
  String _setPerd;
  String _matuDt;
  String _amt;
  String _ddAc;
  String _loanAmount;
  String _fltNmth;
  String _fPaydt;
  String _iratTm;
  int _repDay;
  String _intNper;
  String _lnac;
  String _insType;
  String _setUnit;
  String _ccy;
  String _loanPurpose;
  String _iratCd;
  String _totalInt;

  String get onRate => _onRate;
  String get inRate => _inRate;
  String get repType => _repType;
  String get intRat => _intRat;
  String get setPerd => _setPerd;
  String get matuDt => _matuDt;
  String get amt => _amt;
  String get ddAc => _ddAc;
  String get loanAmount => _loanAmount;
  String get fltNmth => _fltNmth;
  String get fPaydt => _fPaydt;
  String get iratTm => _iratTm;
  int get repDay => _repDay;
  String get intNper => _intNper;
  String get lnac => _lnac;
  String get insType => _insType;
  String get setUnit => _setUnit;
  String get ccy => _ccy;
  String get loanPurpose => _loanPurpose;
  String get iratCd => _iratCd;
  String get totalInt => _totalInt;

  OperateEndValue(
      {String onRate,
      String inRate,
      String repType,
      String intRat,
      String setPerd,
      String matuDt,
      String amt,
      String ddAc,
      String loanAmount,
      String fltNmth,
      String fPaydt,
      String iratTm,
      int repDay,
      String intNper,
      String lnac,
      String insType,
      String setUnit,
      String ccy,
      String loanPurpose,
      String iratCd,
      String totalInt}) {
    _onRate = onRate;
    _inRate = inRate;
    _repType = repType;
    _intRat = intRat;
    _setPerd = setPerd;
    _matuDt = matuDt;
    _amt = amt;
    _ddAc = ddAc;
    _loanAmount = loanAmount;
    _fltNmth = fltNmth;
    _fPaydt = fPaydt;
    _iratTm = iratTm;
    _repDay = repDay;
    _intNper = intNper;
    _lnac = lnac;
    _insType = insType;
    _setUnit = setUnit;
    _ccy = ccy;
    _loanPurpose = loanPurpose;
    _iratCd = iratCd;
    _totalInt = totalInt;
  }

  OperateEndValue.fromJson(dynamic json) {
    _onRate = json["onRate"];
    _inRate = json["inRate"];
    _repType = json["repType"];
    _intRat = json["intRat"];
    _setPerd = json["setPerd"];
    _matuDt = json["matuDt"];
    _amt = json["amt"];
    _ddAc = json["ddAc"];
    _loanAmount = json["loanAmount"];
    _fltNmth = json["fltNmth"];
    _fPaydt = json["fPaydt"];
    _iratTm = json["iratTm"];
    _repDay = json["repDay"];
    _intNper = json["intNper"];
    _lnac = json["lnac"];
    _insType = json["insType"];
    _setUnit = json["setUnit"];
    _ccy = json["ccy"];
    _loanPurpose = json["loanPurpose"];
    _iratCd = json["iratCd"];
    _totalInt = json["totalInt"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["onRate"] = _onRate;
    map["inRate"] = _inRate;
    map["repType"] = _repType;
    map["intRat"] = _intRat;
    map["setPerd"] = _setPerd;
    map["matuDt"] = _matuDt;
    map["amt"] = _amt;
    map["ddAc"] = _ddAc;
    map["loanAmount"] = _loanAmount;
    map["fltNmth"] = _fltNmth;
    map["fPaydt"] = _fPaydt;
    map["iratTm"] = _iratTm;
    map["repDay"] = _repDay;
    map["intNper"] = _intNper;
    map["lnac"] = _lnac;
    map["insType"] = _insType;
    map["setUnit"] = _setUnit;
    map["ccy"] = _ccy;
    map["loanPurpose"] = _loanPurpose;
    map["iratCd"] = _iratCd;
    map["totalInt"] = _totalInt;
    return map;
  }
}

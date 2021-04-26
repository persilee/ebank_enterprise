/// userId : "829378511096512512"
/// userName : "HSG16 Checker"
/// assignee : null
/// processTitle : "loanWithDrawalApprovalTitle"
/// processKey : "loanWithDrawalApproval"
/// businessKey : null
/// tenantId : null
/// operateBeforeValue : null
/// operateEndValue : {"lnac":"8013168003000798","ccy":"USD","amt":"10000","matuDt":"2022-06-30","iratCd":"TC0","iratTm":"M012","intRat":"1","fltNmth":"1","onRate":"1.34335353","intNper":"0","inRate":"2.34335353","ddAc":"0001208000001428","repType":"4","insType":"1","setPerd":"1","setUnit":"M","fPaydt":"2021-08-21","repDay":-21}
/// servCtr : "hbs-ebank-general-service"
/// custId : null
/// commentList : []
/// result : true
/// taskKey : "TASK1"
/// taskCount : 1

class LoanWithDrawalModel {
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

  LoanWithDrawalModel({
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

  LoanWithDrawalModel.fromJson(dynamic json) {
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

/// lnac : "8013168003000798"
/// ccy : "USD"
/// amt : "10000"
/// matuDt : "2022-06-30"
/// iratCd : "TC0"
/// iratTm : "M012"
/// intRat : "1"
/// fltNmth : "1"
/// onRate : "1.34335353"
/// intNper : "0"
/// inRate : "2.34335353"
/// ddAc : "0001208000001428"
/// repType : "4"
/// insType : "1"
/// setPerd : "1"
/// setUnit : "M"
/// fPaydt : "2021-08-21"
/// repDay : -21

class OperateEndValue {
  String _lnac;
  String _ccy;
  String _amt;
  String _matuDt;
  String _iratCd;
  String _iratTm;
  String _intRat;
  String _fltNmth;
  String _onRate;
  String _intNper;
  String _inRate;
  String _ddAc;
  String _repType;
  String _insType;
  String _setPerd;
  String _setUnit;
  String _fPaydt;
  int _repDay;

  String get lnac => _lnac;
  String get ccy => _ccy;
  String get amt => _amt;
  String get matuDt => _matuDt;
  String get iratCd => _iratCd;
  String get iratTm => _iratTm;
  String get intRat => _intRat;
  String get fltNmth => _fltNmth;
  String get onRate => _onRate;
  String get intNper => _intNper;
  String get inRate => _inRate;
  String get ddAc => _ddAc;
  String get repType => _repType;
  String get insType => _insType;
  String get setPerd => _setPerd;
  String get setUnit => _setUnit;
  String get fPaydt => _fPaydt;
  int get repDay => _repDay;

  OperateEndValue({
      String lnac, 
      String ccy, 
      String amt, 
      String matuDt, 
      String iratCd, 
      String iratTm, 
      String intRat, 
      String fltNmth, 
      String onRate, 
      String intNper, 
      String inRate, 
      String ddAc, 
      String repType, 
      String insType, 
      String setPerd, 
      String setUnit, 
      String fPaydt, 
      int repDay}){
    _lnac = lnac;
    _ccy = ccy;
    _amt = amt;
    _matuDt = matuDt;
    _iratCd = iratCd;
    _iratTm = iratTm;
    _intRat = intRat;
    _fltNmth = fltNmth;
    _onRate = onRate;
    _intNper = intNper;
    _inRate = inRate;
    _ddAc = ddAc;
    _repType = repType;
    _insType = insType;
    _setPerd = setPerd;
    _setUnit = setUnit;
    _fPaydt = fPaydt;
    _repDay = repDay;
}

  OperateEndValue.fromJson(dynamic json) {
    _lnac = json["lnac"];
    _ccy = json["ccy"];
    _amt = json["amt"];
    _matuDt = json["matuDt"];
    _iratCd = json["iratCd"];
    _iratTm = json["iratTm"];
    _intRat = json["intRat"];
    _fltNmth = json["fltNmth"];
    _onRate = json["onRate"];
    _intNper = json["intNper"];
    _inRate = json["inRate"];
    _ddAc = json["ddAc"];
    _repType = json["repType"];
    _insType = json["insType"];
    _setPerd = json["setPerd"];
    _setUnit = json["setUnit"];
    _fPaydt = json["fPaydt"];
    _repDay = json["repDay"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["lnac"] = _lnac;
    map["ccy"] = _ccy;
    map["amt"] = _amt;
    map["matuDt"] = _matuDt;
    map["iratCd"] = _iratCd;
    map["iratTm"] = _iratTm;
    map["intRat"] = _intRat;
    map["fltNmth"] = _fltNmth;
    map["onRate"] = _onRate;
    map["intNper"] = _intNper;
    map["inRate"] = _inRate;
    map["ddAc"] = _ddAc;
    map["repType"] = _repType;
    map["insType"] = _insType;
    map["setPerd"] = _setPerd;
    map["setUnit"] = _setUnit;
    map["fPaydt"] = _fPaydt;
    map["repDay"] = _repDay;
    return map;
  }

}
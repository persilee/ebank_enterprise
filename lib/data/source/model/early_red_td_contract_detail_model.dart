/// userId : "989185387615485956"
/// userName : null
/// assignee : null
/// processTitle : "earlyRedTdContractApprovalTitle"
/// processKey : "earlyRedTdContractApproval"
/// businessKey : null
/// tenantId : null
/// operateBeforeValue : null
/// operateEndValue : {"conNo":"01018580000007680002","mainAc":"0101858000000768","transferAc":"0101208000001528","settBal":"0","eryRate":"0","eryInt":"0","hdlFee":"0","pnltFee":"0","settDdAc":"0101238000001758","matAmt":"0","bal":null,"ccy":null,"tenor":null,"status":null,"valueDate":null,"dueDate":null}
/// servCtr : "hbs-ebank-general-service"
/// custId : null
/// commentList : []
/// result : true
/// taskKey : "TASK1"
/// taskCount : 1

class EarlyRedTdContractDetailModel {
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

  EarlyRedTdContractDetailModel({
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

  EarlyRedTdContractDetailModel.fromJson(dynamic json) {
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

/// conNo : "01018580000007680002"
/// mainAc : "0101858000000768"
/// transferAc : "0101208000001528"
/// settBal : "0"
/// eryRate : "0"
/// eryInt : "0"
/// hdlFee : "0"
/// pnltFee : "0"
/// settDdAc : "0101238000001758"
/// matAmt : "0"
/// bal : null
/// ccy : null
/// tenor : null
/// status : null
/// valueDate : null
/// dueDate : null

class OperateEndValue {
  String _conNo;
  String _mainAc;
  String _transferAc;
  String _settBal;
  String _eryRate;
  String _eryInt;
  String _hdlFee;
  String _pnltFee;
  String _settDdAc;
  String _matAmt;
  dynamic _bal;
  dynamic _ccy;
  dynamic _tenor;
  dynamic _status;
  dynamic _valueDate;
  dynamic _dueDate;

  String get conNo => _conNo;
  String get mainAc => _mainAc;
  String get transferAc => _transferAc;
  String get settBal => _settBal;
  String get eryRate => _eryRate;
  String get eryInt => _eryInt;
  String get hdlFee => _hdlFee;
  String get pnltFee => _pnltFee;
  String get settDdAc => _settDdAc;
  String get matAmt => _matAmt;
  dynamic get bal => _bal;
  dynamic get ccy => _ccy;
  dynamic get tenor => _tenor;
  dynamic get status => _status;
  dynamic get valueDate => _valueDate;
  dynamic get dueDate => _dueDate;

  OperateEndValue({
      String conNo, 
      String mainAc, 
      String transferAc, 
      String settBal, 
      String eryRate, 
      String eryInt, 
      String hdlFee, 
      String pnltFee, 
      String settDdAc, 
      String matAmt, 
      dynamic bal, 
      dynamic ccy, 
      dynamic tenor, 
      dynamic status, 
      dynamic valueDate, 
      dynamic dueDate}){
    _conNo = conNo;
    _mainAc = mainAc;
    _transferAc = transferAc;
    _settBal = settBal;
    _eryRate = eryRate;
    _eryInt = eryInt;
    _hdlFee = hdlFee;
    _pnltFee = pnltFee;
    _settDdAc = settDdAc;
    _matAmt = matAmt;
    _bal = bal;
    _ccy = ccy;
    _tenor = tenor;
    _status = status;
    _valueDate = valueDate;
    _dueDate = dueDate;
}

  OperateEndValue.fromJson(dynamic json) {
    _conNo = json["conNo"];
    _mainAc = json["mainAc"];
    _transferAc = json["transferAc"];
    _settBal = json["settBal"];
    _eryRate = json["eryRate"];
    _eryInt = json["eryInt"];
    _hdlFee = json["hdlFee"];
    _pnltFee = json["pnltFee"];
    _settDdAc = json["settDdAc"];
    _matAmt = json["matAmt"];
    _bal = json["bal"];
    _ccy = json["ccy"];
    _tenor = json["tenor"];
    _status = json["status"];
    _valueDate = json["valueDate"];
    _dueDate = json["dueDate"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["conNo"] = _conNo;
    map["mainAc"] = _mainAc;
    map["transferAc"] = _transferAc;
    map["settBal"] = _settBal;
    map["eryRate"] = _eryRate;
    map["eryInt"] = _eryInt;
    map["hdlFee"] = _hdlFee;
    map["pnltFee"] = _pnltFee;
    map["settDdAc"] = _settDdAc;
    map["matAmt"] = _matAmt;
    map["bal"] = _bal;
    map["ccy"] = _ccy;
    map["tenor"] = _tenor;
    map["status"] = _status;
    map["valueDate"] = _valueDate;
    map["dueDate"] = _dueDate;
    return map;
  }

}
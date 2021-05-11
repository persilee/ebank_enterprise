import '../find_user_application_task_detail.dart';

/// userId : "835838936357011456"
/// userName : "李家伟"
/// assigneeList : null
/// approverNumbers : 0
/// processTitle : "earlyRedTdContractApprovalTitle"
/// processKey : "earlyRedTdContractApproval"
/// businessKey : null
/// tenantId : null
/// operateBeforeValue : null
/// operateEndValue : {"eryRate":"0","matBal":null,"conNo":"80118080000009980006","matAmt":"0","settBal":"0","settDdAc":"8011258000006258","clsRate":null,"transferAc":"0101208000001528","dueDate":null,"valueDate":null,"bal":null,"type":null,"tenor":null,"clsInt":null,"mainAc":"8011808000000998","pnltFee":"0","ccy":null,"eryInt":"0","hdlFee":"0","status":null}
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

class EarlyRedTdContractDetailModel {
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

  EarlyRedTdContractDetailModel({
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

  EarlyRedTdContractDetailModel.fromJson(dynamic json) {
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

/// eryRate : "0"
/// matBal : null
/// conNo : "80118080000009980006"
/// matAmt : "0"
/// settBal : "0"
/// settDdAc : "8011258000006258"
/// clsRate : null
/// transferAc : "0101208000001528"
/// dueDate : null
/// valueDate : null
/// bal : null
/// type : null
/// tenor : null
/// clsInt : null
/// mainAc : "8011808000000998"
/// pnltFee : "0"
/// ccy : null
/// eryInt : "0"
/// hdlFee : "0"
/// status : null

class OperateEndValue {
  String _eryRate;
  dynamic _matBal;
  String _conNo;
  String _matAmt;
  String _settBal;
  String _settDdAc;
  dynamic _clsRate;
  String _transferAc;
  dynamic _dueDate;
  dynamic _valueDate;
  dynamic _bal;
  dynamic _type;
  dynamic _tenor;
  dynamic _clsInt;
  String _mainAc;
  String _pnltFee;
  dynamic _ccy;
  String _eryInt;
  String _hdlFee;
  dynamic _status;

  String get eryRate => _eryRate;
  dynamic get matBal => _matBal;
  String get conNo => _conNo;
  String get matAmt => _matAmt;
  String get settBal => _settBal;
  String get settDdAc => _settDdAc;
  dynamic get clsRate => _clsRate;
  String get transferAc => _transferAc;
  dynamic get dueDate => _dueDate;
  dynamic get valueDate => _valueDate;
  dynamic get bal => _bal;
  dynamic get type => _type;
  dynamic get tenor => _tenor;
  dynamic get clsInt => _clsInt;
  String get mainAc => _mainAc;
  String get pnltFee => _pnltFee;
  dynamic get ccy => _ccy;
  String get eryInt => _eryInt;
  String get hdlFee => _hdlFee;
  dynamic get status => _status;

  OperateEndValue({
      String eryRate, 
      dynamic matBal, 
      String conNo, 
      String matAmt, 
      String settBal, 
      String settDdAc, 
      dynamic clsRate, 
      String transferAc, 
      dynamic dueDate, 
      dynamic valueDate, 
      dynamic bal, 
      dynamic type, 
      dynamic tenor, 
      dynamic clsInt, 
      String mainAc, 
      String pnltFee, 
      dynamic ccy, 
      String eryInt, 
      String hdlFee, 
      dynamic status}){
    _eryRate = eryRate;
    _matBal = matBal;
    _conNo = conNo;
    _matAmt = matAmt;
    _settBal = settBal;
    _settDdAc = settDdAc;
    _clsRate = clsRate;
    _transferAc = transferAc;
    _dueDate = dueDate;
    _valueDate = valueDate;
    _bal = bal;
    _type = type;
    _tenor = tenor;
    _clsInt = clsInt;
    _mainAc = mainAc;
    _pnltFee = pnltFee;
    _ccy = ccy;
    _eryInt = eryInt;
    _hdlFee = hdlFee;
    _status = status;
}

  OperateEndValue.fromJson(dynamic json) {
    _eryRate = json["eryRate"];
    _matBal = json["matBal"];
    _conNo = json["conNo"];
    _matAmt = json["matAmt"];
    _settBal = json["settBal"];
    _settDdAc = json["settDdAc"];
    _clsRate = json["clsRate"];
    _transferAc = json["transferAc"];
    _dueDate = json["dueDate"];
    _valueDate = json["valueDate"];
    _bal = json["bal"];
    _type = json["type"];
    _tenor = json["tenor"];
    _clsInt = json["clsInt"];
    _mainAc = json["mainAc"];
    _pnltFee = json["pnltFee"];
    _ccy = json["ccy"];
    _eryInt = json["eryInt"];
    _hdlFee = json["hdlFee"];
    _status = json["status"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["eryRate"] = _eryRate;
    map["matBal"] = _matBal;
    map["conNo"] = _conNo;
    map["matAmt"] = _matAmt;
    map["settBal"] = _settBal;
    map["settDdAc"] = _settDdAc;
    map["clsRate"] = _clsRate;
    map["transferAc"] = _transferAc;
    map["dueDate"] = _dueDate;
    map["valueDate"] = _valueDate;
    map["bal"] = _bal;
    map["type"] = _type;
    map["tenor"] = _tenor;
    map["clsInt"] = _clsInt;
    map["mainAc"] = _mainAc;
    map["pnltFee"] = _pnltFee;
    map["ccy"] = _ccy;
    map["eryInt"] = _eryInt;
    map["hdlFee"] = _hdlFee;
    map["status"] = _status;
    return map;
  }

}
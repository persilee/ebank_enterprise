/// requestId : "202103260939370000191925"
/// msgId : "202103260939370000159477"
/// spanId : "c740136b5b324c158f086c877281e4a9"
/// parentSpanId : null
/// accDate : "2021-01-23"
/// startDateTime : "2021-03-26 09:39:37"
/// endDateTime : "2021-03-26 09:39:37"
/// locale : "zh_HK"
/// routeInfo : "hbs-ebank-wkfl-service"
/// userId : "989185387615485958"
/// clientIp : "218.17.136.70"
/// source : "hbs-ebank-gateway-service"
/// channel : ""
/// business : null
/// uri : "/wkfl/processTask/findToDoTaskDetail"
/// token : null
/// loginName : null
/// trBr : null
/// serviceId : null
/// sourceChannel : null
/// seq : 1
/// body : {"userId":"989185387615485956","userName":null,"assignee":null,"processTitle":"openTdContractApprovalTitle","processKey":"openTdContractApproval","businessKey":null,"tenantId":null,"operateBeforeValue":null,"operateEndValue":{"conNo":"01018580000007680001","mainAc":"0101858000000768","transferAc":"0101208000001528","settBal":"0","eryRate":"0","eryInt":"0","hdlFee":"0","pnltFee":"0","settDdAc":"0101238000001538","matAmt":"0","ciNo":"818000000113","bppdCode":"TDRBCBNF","tenor":"M001","auctCale":"1","accuPeriod":"2","depositType":"A","ccy":"USD","bal":"5000","oppAc":"0101208000001528","instCode":"1","payPassword":"","smsCode":""},"servCtr":"hbs-ebank-general-service","custId":null,"commentList":[],"result":true,"taskKey":"TASK1","taskCount":1}
/// msgCd : "0000"
/// msgInfo : "Success"
/// msgType : "N"

class FindToDoTaskDetailContractModel {
  String _requestId;
  String _msgId;
  String _spanId;
  dynamic _parentSpanId;
  String _accDate;
  String _startDateTime;
  String _endDateTime;
  String _locale;
  String _routeInfo;
  String _userId;
  String _clientIp;
  String _source;
  String _channel;
  dynamic _business;
  String _uri;
  dynamic _token;
  dynamic _loginName;
  dynamic _trBr;
  dynamic _serviceId;
  dynamic _sourceChannel;
  int _seq;
  DataBody _body;
  String _msgCd;
  String _msgInfo;
  String _msgType;

  String get requestId => _requestId;
  String get msgId => _msgId;
  String get spanId => _spanId;
  dynamic get parentSpanId => _parentSpanId;
  String get accDate => _accDate;
  String get startDateTime => _startDateTime;
  String get endDateTime => _endDateTime;
  String get locale => _locale;
  String get routeInfo => _routeInfo;
  String get userId => _userId;
  String get clientIp => _clientIp;
  String get source => _source;
  String get channel => _channel;
  dynamic get business => _business;
  String get uri => _uri;
  dynamic get token => _token;
  dynamic get loginName => _loginName;
  dynamic get trBr => _trBr;
  dynamic get serviceId => _serviceId;
  dynamic get sourceChannel => _sourceChannel;
  int get seq => _seq;
  DataBody get body => _body;
  String get msgCd => _msgCd;
  String get msgInfo => _msgInfo;
  String get msgType => _msgType;

  FindToDoTaskDetailContractModel({
      String requestId, 
      String msgId, 
      String spanId, 
      dynamic parentSpanId, 
      String accDate, 
      String startDateTime, 
      String endDateTime, 
      String locale, 
      String routeInfo, 
      String userId, 
      String clientIp, 
      String source, 
      String channel, 
      dynamic business, 
      String uri, 
      dynamic token, 
      dynamic loginName, 
      dynamic trBr, 
      dynamic serviceId, 
      dynamic sourceChannel, 
      int seq, 
      DataBody body,
      String msgCd, 
      String msgInfo, 
      String msgType}){
    _requestId = requestId;
    _msgId = msgId;
    _spanId = spanId;
    _parentSpanId = parentSpanId;
    _accDate = accDate;
    _startDateTime = startDateTime;
    _endDateTime = endDateTime;
    _locale = locale;
    _routeInfo = routeInfo;
    _userId = userId;
    _clientIp = clientIp;
    _source = source;
    _channel = channel;
    _business = business;
    _uri = uri;
    _token = token;
    _loginName = loginName;
    _trBr = trBr;
    _serviceId = serviceId;
    _sourceChannel = sourceChannel;
    _seq = seq;
    _body = body;
    _msgCd = msgCd;
    _msgInfo = msgInfo;
    _msgType = msgType;
}

  FindToDoTaskDetailContractModel.fromJson(dynamic json) {
    _requestId = json["requestId"];
    _msgId = json["msgId"];
    _spanId = json["spanId"];
    _parentSpanId = json["parentSpanId"];
    _accDate = json["accDate"];
    _startDateTime = json["startDateTime"];
    _endDateTime = json["endDateTime"];
    _locale = json["locale"];
    _routeInfo = json["routeInfo"];
    _userId = json["userId"];
    _clientIp = json["clientIp"];
    _source = json["source"];
    _channel = json["channel"];
    _business = json["business"];
    _uri = json["uri"];
    _token = json["token"];
    _loginName = json["loginName"];
    _trBr = json["trBr"];
    _serviceId = json["serviceId"];
    _sourceChannel = json["sourceChannel"];
    _seq = json["seq"];
    _body = json["body"] != null ? DataBody.fromJson(json["body"]) : null;
    _msgCd = json["msgCd"];
    _msgInfo = json["msgInfo"];
    _msgType = json["msgType"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["requestId"] = _requestId;
    map["msgId"] = _msgId;
    map["spanId"] = _spanId;
    map["parentSpanId"] = _parentSpanId;
    map["accDate"] = _accDate;
    map["startDateTime"] = _startDateTime;
    map["endDateTime"] = _endDateTime;
    map["locale"] = _locale;
    map["routeInfo"] = _routeInfo;
    map["userId"] = _userId;
    map["clientIp"] = _clientIp;
    map["source"] = _source;
    map["channel"] = _channel;
    map["business"] = _business;
    map["uri"] = _uri;
    map["token"] = _token;
    map["loginName"] = _loginName;
    map["trBr"] = _trBr;
    map["serviceId"] = _serviceId;
    map["sourceChannel"] = _sourceChannel;
    map["seq"] = _seq;
    if (_body != null) {
      map["body"] = _body.toJson();
    }
    map["msgCd"] = _msgCd;
    map["msgInfo"] = _msgInfo;
    map["msgType"] = _msgType;
    return map;
  }

}

/// userId : "989185387615485956"
/// userName : null
/// assignee : null
/// processTitle : "openTdContractApprovalTitle"
/// processKey : "openTdContractApproval"
/// businessKey : null
/// tenantId : null
/// operateBeforeValue : null
/// operateEndValue : {"conNo":"01018580000007680001","mainAc":"0101858000000768","transferAc":"0101208000001528","settBal":"0","eryRate":"0","eryInt":"0","hdlFee":"0","pnltFee":"0","settDdAc":"0101238000001538","matAmt":"0","ciNo":"818000000113","bppdCode":"TDRBCBNF","tenor":"M001","auctCale":"1","accuPeriod":"2","depositType":"A","ccy":"USD","bal":"5000","oppAc":"0101208000001528","instCode":"1","payPassword":"","smsCode":""}
/// servCtr : "hbs-ebank-general-service"
/// custId : null
/// commentList : []
/// result : true
/// taskKey : "TASK1"
/// taskCount : 1

class DataBody {
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

  DataBody({
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

  DataBody.fromJson(dynamic json) {
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

/// conNo : "01018580000007680001"
/// mainAc : "0101858000000768"
/// transferAc : "0101208000001528"
/// settBal : "0"
/// eryRate : "0"
/// eryInt : "0"
/// hdlFee : "0"
/// pnltFee : "0"
/// settDdAc : "0101238000001538"
/// matAmt : "0"
/// ciNo : "818000000113"
/// bppdCode : "TDRBCBNF"
/// tenor : "M001"
/// auctCale : "1"
/// accuPeriod : "2"
/// depositType : "A"
/// ccy : "USD"
/// bal : "5000"
/// oppAc : "0101208000001528"
/// instCode : "1"
/// payPassword : ""
/// smsCode : ""

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
  String _ciNo;
  String _bppdCode;
  String _tenor;
  String _auctCale;
  String _accuPeriod;
  String _depositType;
  String _ccy;
  String _bal;
  String _oppAc;
  String _instCode;
  String _payPassword;
  String _smsCode;

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
  String get ciNo => _ciNo;
  String get bppdCode => _bppdCode;
  String get tenor => _tenor;
  String get auctCale => _auctCale;
  String get accuPeriod => _accuPeriod;
  String get depositType => _depositType;
  String get ccy => _ccy;
  String get bal => _bal;
  String get oppAc => _oppAc;
  String get instCode => _instCode;
  String get payPassword => _payPassword;
  String get smsCode => _smsCode;

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
      String ciNo, 
      String bppdCode, 
      String tenor, 
      String auctCale, 
      String accuPeriod, 
      String depositType, 
      String ccy, 
      String bal, 
      String oppAc, 
      String instCode, 
      String payPassword, 
      String smsCode}){
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
    _ciNo = ciNo;
    _bppdCode = bppdCode;
    _tenor = tenor;
    _auctCale = auctCale;
    _accuPeriod = accuPeriod;
    _depositType = depositType;
    _ccy = ccy;
    _bal = bal;
    _oppAc = oppAc;
    _instCode = instCode;
    _payPassword = payPassword;
    _smsCode = smsCode;
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
    _ciNo = json["ciNo"];
    _bppdCode = json["bppdCode"];
    _tenor = json["tenor"];
    _auctCale = json["auctCale"];
    _accuPeriod = json["accuPeriod"];
    _depositType = json["depositType"];
    _ccy = json["ccy"];
    _bal = json["bal"];
    _oppAc = json["oppAc"];
    _instCode = json["instCode"];
    _payPassword = json["payPassword"];
    _smsCode = json["smsCode"];
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
    map["ciNo"] = _ciNo;
    map["bppdCode"] = _bppdCode;
    map["tenor"] = _tenor;
    map["auctCale"] = _auctCale;
    map["accuPeriod"] = _accuPeriod;
    map["depositType"] = _depositType;
    map["ccy"] = _ccy;
    map["bal"] = _bal;
    map["oppAc"] = _oppAc;
    map["instCode"] = _instCode;
    map["payPassword"] = _payPassword;
    map["smsCode"] = _smsCode;
    return map;
  }

}
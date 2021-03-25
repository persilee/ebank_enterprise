/// requestId : "202103240924080000137146"
/// msgId : "202103240924080000113414"
/// spanId : "6d73a6fd1b8744d9bbff7083c9b6ff32"
/// parentSpanId : null
/// accDate : "2021-01-23"
/// startDateTime : "2021-03-24 09:24:08"
/// endDateTime : "2021-03-24 09:24:08"
/// locale : "zh_CN"
/// routeInfo : "hbs-ebank-wkfl-service|hbs-ebank-customer-service"
/// userId : "989185387615485958"
/// clientIp : "218.17.136.70"
/// source : "hbs-ebank-gateway-service"
/// channel : ""
/// business : null
/// uri : "/wkfl/processTask/findUserTodoTask"
/// token : null
/// loginName : null
/// trBr : null
/// serviceId : null
/// sourceChannel : null
/// seq : 1
/// body : {"sort":null,"page":1,"pageSize":10,"count":4,"totalPage":1,"rows":[{"processId":"145105","processKey":"oneToOneTransferApproval","processTitle":"oneToOneTransferApprovalTitle","taskId":"145122","taskName":"Interanal Transfer Approval","assign":null,"owner":null,"startUser":null,"createTime":"2021-03-23 20:54:05","result":"1","businessKey":"818000000113","tenantId":"EB"},{"processId":"147586","processKey":"openTdContractApproval","processTitle":"openTdContractApprovalTitle","taskId":"147603","taskName":"Open Time Deposit Contract Approval","assign":null,"owner":null,"startUser":null,"createTime":"2021-03-23 20:59:18","result":"1","businessKey":"818000000113","tenantId":"EB"},{"processId":"147625","processKey":"openTdContractApproval","processTitle":"openTdContractApprovalTitle","taskId":"147642","taskName":"Open Time Deposit Contract Approval","assign":null,"owner":null,"startUser":null,"createTime":"2021-03-23 21:05:19","result":"1","businessKey":"818000000113","tenantId":"EB"},{"processId":"147647","processKey":"oneToOneTransferApproval","processTitle":"oneToOneTransferApprovalTitle","taskId":"147664","taskName":"Interanal Transfer Approval","assign":null,"owner":null,"startUser":null,"createTime":"2021-03-24 09:23:29","result":"1","businessKey":"818000000113","tenantId":"EB"}]}
/// msgCd : "0000"
/// msgInfo : "成功"
/// msgType : "N"

class FindUserTodoTaskModel {
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

  FindUserTodoTaskModel({
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

  FindUserTodoTaskModel.fromJson(dynamic json) {
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

/// sort : null
/// page : 1
/// pageSize : 10
/// count : 4
/// totalPage : 1
/// rows : [{"processId":"145105","processKey":"oneToOneTransferApproval","processTitle":"oneToOneTransferApprovalTitle","taskId":"145122","taskName":"Interanal Transfer Approval","assign":null,"owner":null,"startUser":null,"createTime":"2021-03-23 20:54:05","result":"1","businessKey":"818000000113","tenantId":"EB"},{"processId":"147586","processKey":"openTdContractApproval","processTitle":"openTdContractApprovalTitle","taskId":"147603","taskName":"Open Time Deposit Contract Approval","assign":null,"owner":null,"startUser":null,"createTime":"2021-03-23 20:59:18","result":"1","businessKey":"818000000113","tenantId":"EB"},{"processId":"147625","processKey":"openTdContractApproval","processTitle":"openTdContractApprovalTitle","taskId":"147642","taskName":"Open Time Deposit Contract Approval","assign":null,"owner":null,"startUser":null,"createTime":"2021-03-23 21:05:19","result":"1","businessKey":"818000000113","tenantId":"EB"},{"processId":"147647","processKey":"oneToOneTransferApproval","processTitle":"oneToOneTransferApprovalTitle","taskId":"147664","taskName":"Interanal Transfer Approval","assign":null,"owner":null,"startUser":null,"createTime":"2021-03-24 09:23:29","result":"1","businessKey":"818000000113","tenantId":"EB"}]

class DataBody {
  dynamic _sort;
  int _page;
  int _pageSize;
  int _count;
  int _totalPage;
  List<Rows> _rows;

  dynamic get sort => _sort;
  int get page => _page;
  int get pageSize => _pageSize;
  int get count => _count;
  int get totalPage => _totalPage;
  List<Rows> get rows => _rows;

  DataBody({
      dynamic sort, 
      int page, 
      int pageSize, 
      int count, 
      int totalPage, 
      List<Rows> rows}){
    _sort = sort;
    _page = page;
    _pageSize = pageSize;
    _count = count;
    _totalPage = totalPage;
    _rows = rows;
}

  DataBody.fromJson(dynamic json) {
    _sort = json["sort"];
    _page = json["page"];
    _pageSize = json["pageSize"];
    _count = json["count"];
    _totalPage = json["totalPage"];
    if (json["rows"] != null) {
      _rows = [];
      json["rows"].forEach((v) {
        _rows.add(Rows.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["sort"] = _sort;
    map["page"] = _page;
    map["pageSize"] = _pageSize;
    map["count"] = _count;
    map["totalPage"] = _totalPage;
    if (_rows != null) {
      map["rows"] = _rows.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// processId : "145105"
/// processKey : "oneToOneTransferApproval"
/// processTitle : "oneToOneTransferApprovalTitle"
/// taskId : "145122"
/// taskName : "Interanal Transfer Approval"
/// assign : null
/// owner : null
/// startUser : null
/// createTime : "2021-03-23 20:54:05"
/// result : "1"
/// businessKey : "818000000113"
/// tenantId : "EB"

class Rows {
  String _processId;
  String _processKey;
  String _processTitle;
  String _taskId;
  String _taskName;
  dynamic _assign;
  dynamic _owner;
  dynamic _startUser;
  String _createTime;
  String _result;
  String _businessKey;
  String _tenantId;

  String get processId => _processId;
  String get processKey => _processKey;
  String get processTitle => _processTitle;
  String get taskId => _taskId;
  String get taskName => _taskName;
  dynamic get assign => _assign;
  dynamic get owner => _owner;
  dynamic get startUser => _startUser;
  String get createTime => _createTime;
  String get result => _result;
  String get businessKey => _businessKey;
  String get tenantId => _tenantId;

  Rows({
      String processId, 
      String processKey, 
      String processTitle, 
      String taskId, 
      String taskName, 
      dynamic assign, 
      dynamic owner, 
      dynamic startUser, 
      String createTime, 
      String result, 
      String businessKey, 
      String tenantId}){
    _processId = processId;
    _processKey = processKey;
    _processTitle = processTitle;
    _taskId = taskId;
    _taskName = taskName;
    _assign = assign;
    _owner = owner;
    _startUser = startUser;
    _createTime = createTime;
    _result = result;
    _businessKey = businessKey;
    _tenantId = tenantId;
}

  Rows.fromJson(dynamic json) {
    _processId = json["processId"];
    _processKey = json["processKey"];
    _processTitle = json["processTitle"];
    _taskId = json["taskId"];
    _taskName = json["taskName"];
    _assign = json["assign"];
    _owner = json["owner"];
    _startUser = json["startUser"];
    _createTime = json["createTime"];
    _result = json["result"];
    _businessKey = json["businessKey"];
    _tenantId = json["tenantId"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["processId"] = _processId;
    map["processKey"] = _processKey;
    map["processTitle"] = _processTitle;
    map["taskId"] = _taskId;
    map["taskName"] = _taskName;
    map["assign"] = _assign;
    map["owner"] = _owner;
    map["startUser"] = _startUser;
    map["createTime"] = _createTime;
    map["result"] = _result;
    map["businessKey"] = _businessKey;
    map["tenantId"] = _tenantId;
    return map;
  }

}
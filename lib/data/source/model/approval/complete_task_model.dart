/// msgType : "N"
/// sourceChannel : null
/// channel : null
/// msgId : null
/// source : null
/// locale : null
/// body : null
/// spanId : null
/// requestId : null
/// loginName : null
/// trBr : null
/// serviceId : null
/// msgInfo : null
/// seq : null
/// business : null
/// endDateTime : null
/// parentSpanId : null
/// userId : null
/// uri : null
/// routeInfo : null
/// token : null
/// accDate : null
/// startDateTime : null
/// clientIp : null
/// msgCd : "0000"

class CompleteTaskModel {
  String _msgType;
  dynamic _sourceChannel;
  dynamic _channel;
  dynamic _msgId;
  dynamic _source;
  dynamic _locale;
  dynamic _body;
  dynamic _spanId;
  dynamic _requestId;
  dynamic _loginName;
  dynamic _trBr;
  dynamic _serviceId;
  dynamic _msgInfo;
  dynamic _seq;
  dynamic _business;
  dynamic _endDateTime;
  dynamic _parentSpanId;
  dynamic _userId;
  dynamic _uri;
  dynamic _routeInfo;
  dynamic _token;
  dynamic _accDate;
  dynamic _startDateTime;
  dynamic _clientIp;
  String _msgCd;

  String get msgType => _msgType;
  dynamic get sourceChannel => _sourceChannel;
  dynamic get channel => _channel;
  dynamic get msgId => _msgId;
  dynamic get source => _source;
  dynamic get locale => _locale;
  dynamic get body => _body;
  dynamic get spanId => _spanId;
  dynamic get requestId => _requestId;
  dynamic get loginName => _loginName;
  dynamic get trBr => _trBr;
  dynamic get serviceId => _serviceId;
  dynamic get msgInfo => _msgInfo;
  dynamic get seq => _seq;
  dynamic get business => _business;
  dynamic get endDateTime => _endDateTime;
  dynamic get parentSpanId => _parentSpanId;
  dynamic get userId => _userId;
  dynamic get uri => _uri;
  dynamic get routeInfo => _routeInfo;
  dynamic get token => _token;
  dynamic get accDate => _accDate;
  dynamic get startDateTime => _startDateTime;
  dynamic get clientIp => _clientIp;
  String get msgCd => _msgCd;

  CompleteTaskModel({
      String msgType, 
      dynamic sourceChannel, 
      dynamic channel, 
      dynamic msgId, 
      dynamic source, 
      dynamic locale, 
      dynamic body, 
      dynamic spanId, 
      dynamic requestId, 
      dynamic loginName, 
      dynamic trBr, 
      dynamic serviceId, 
      dynamic msgInfo, 
      dynamic seq, 
      dynamic business, 
      dynamic endDateTime, 
      dynamic parentSpanId, 
      dynamic userId, 
      dynamic uri, 
      dynamic routeInfo, 
      dynamic token, 
      dynamic accDate, 
      dynamic startDateTime, 
      dynamic clientIp, 
      String msgCd}){
    _msgType = msgType;
    _sourceChannel = sourceChannel;
    _channel = channel;
    _msgId = msgId;
    _source = source;
    _locale = locale;
    _body = body;
    _spanId = spanId;
    _requestId = requestId;
    _loginName = loginName;
    _trBr = trBr;
    _serviceId = serviceId;
    _msgInfo = msgInfo;
    _seq = seq;
    _business = business;
    _endDateTime = endDateTime;
    _parentSpanId = parentSpanId;
    _userId = userId;
    _uri = uri;
    _routeInfo = routeInfo;
    _token = token;
    _accDate = accDate;
    _startDateTime = startDateTime;
    _clientIp = clientIp;
    _msgCd = msgCd;
}

  CompleteTaskModel.fromJson(dynamic json) {
    _msgType = json["msgType"];
    _sourceChannel = json["sourceChannel"];
    _channel = json["channel"];
    _msgId = json["msgId"];
    _source = json["source"];
    _locale = json["locale"];
    _body = json["body"];
    _spanId = json["spanId"];
    _requestId = json["requestId"];
    _loginName = json["loginName"];
    _trBr = json["trBr"];
    _serviceId = json["serviceId"];
    _msgInfo = json["msgInfo"];
    _seq = json["seq"];
    _business = json["business"];
    _endDateTime = json["endDateTime"];
    _parentSpanId = json["parentSpanId"];
    _userId = json["userId"];
    _uri = json["uri"];
    _routeInfo = json["routeInfo"];
    _token = json["token"];
    _accDate = json["accDate"];
    _startDateTime = json["startDateTime"];
    _clientIp = json["clientIp"];
    _msgCd = json["msgCd"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["msgType"] = _msgType;
    map["sourceChannel"] = _sourceChannel;
    map["channel"] = _channel;
    map["msgId"] = _msgId;
    map["source"] = _source;
    map["locale"] = _locale;
    map["body"] = _body;
    map["spanId"] = _spanId;
    map["requestId"] = _requestId;
    map["loginName"] = _loginName;
    map["trBr"] = _trBr;
    map["serviceId"] = _serviceId;
    map["msgInfo"] = _msgInfo;
    map["seq"] = _seq;
    map["business"] = _business;
    map["endDateTime"] = _endDateTime;
    map["parentSpanId"] = _parentSpanId;
    map["userId"] = _userId;
    map["uri"] = _uri;
    map["routeInfo"] = _routeInfo;
    map["token"] = _token;
    map["accDate"] = _accDate;
    map["startDateTime"] = _startDateTime;
    map["clientIp"] = _clientIp;
    map["msgCd"] = _msgCd;
    return map;
  }

}
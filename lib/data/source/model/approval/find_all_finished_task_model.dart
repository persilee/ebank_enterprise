/// sort : null
/// page : 1
/// pageSize : 10
/// count : 1
/// totalPage : 1
/// rows : [{"processId":"200986","processKey":"transferPlanApproval","processTitle":"transferPlanApprovalTitle","taskId":"201004","taskName":"Schedule Transfer Approval","assign":null,"owner":null,"applicantId":"989185387615485978","applicantName":"高阳寰球","createTime":null,"result":"1","businessKey":"0101268000001878","tenantId":null}]

class FindAllFinishedTaskModel {
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

  FindAllFinishedTaskModel({
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

  FindAllFinishedTaskModel.fromJson(dynamic json) {
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

/// processId : "200986"
/// processKey : "transferPlanApproval"
/// processTitle : "transferPlanApprovalTitle"
/// taskId : "201004"
/// taskName : "Schedule Transfer Approval"
/// assign : null
/// owner : null
/// applicantId : "989185387615485978"
/// applicantName : "高阳寰球"
/// createTime : null
/// result : "1"
/// businessKey : "0101268000001878"
/// tenantId : null

class Rows {
  String _processId;
  String _processKey;
  String _processTitle;
  String _taskId;
  String _taskName;
  dynamic _assign;
  dynamic _owner;
  String _applicantId;
  String _applicantName;
  dynamic _createTime;
  String _result;
  String _businessKey;
  dynamic _tenantId;

  String get processId => _processId;
  String get processKey => _processKey;
  String get processTitle => _processTitle;
  String get taskId => _taskId;
  String get taskName => _taskName;
  dynamic get assign => _assign;
  dynamic get owner => _owner;
  String get applicantId => _applicantId;
  String get applicantName => _applicantName;
  dynamic get createTime => _createTime;
  String get result => _result;
  String get businessKey => _businessKey;
  dynamic get tenantId => _tenantId;

  Rows({
      String processId, 
      String processKey, 
      String processTitle, 
      String taskId, 
      String taskName, 
      dynamic assign, 
      dynamic owner, 
      String applicantId, 
      String applicantName, 
      dynamic createTime, 
      String result, 
      String businessKey, 
      dynamic tenantId}){
    _processId = processId;
    _processKey = processKey;
    _processTitle = processTitle;
    _taskId = taskId;
    _taskName = taskName;
    _assign = assign;
    _owner = owner;
    _applicantId = applicantId;
    _applicantName = applicantName;
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
    _applicantId = json["applicantId"];
    _applicantName = json["applicantName"];
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
    map["applicantId"] = _applicantId;
    map["applicantName"] = _applicantName;
    map["createTime"] = _createTime;
    map["result"] = _result;
    map["businessKey"] = _businessKey;
    map["tenantId"] = _tenantId;
    return map;
  }

}
/// page : 1
/// pageSize : 10
/// processId : ""
/// processKey : ""
/// processTitle : ""
/// sort : ""
/// startUser : ""
/// taskId : ""
/// taskName : ""
/// tenantId : "EB"
/// custId : "818000000113"

class FindUserTodoTaskBody {
  int _page;
  int _pageSize;
  String _processId;
  String _processKey;
  String _processTitle;
  String _sort;
  String _startUser;
  String _taskId;
  String _taskName;
  String _tenantId;
  String _custId;

  int get page => _page;
  int get pageSize => _pageSize;
  String get processId => _processId;
  String get processKey => _processKey;
  String get processTitle => _processTitle;
  String get sort => _sort;
  String get startUser => _startUser;
  String get taskId => _taskId;
  String get taskName => _taskName;
  String get tenantId => _tenantId;
  String get custId => _custId;

  FindUserTodoTaskBody({
      int page, 
      int pageSize, 
      String processId, 
      String processKey, 
      String processTitle, 
      String sort, 
      String startUser, 
      String taskId, 
      String taskName, 
      String tenantId, 
      String custId}){
    _page = page;
    _pageSize = pageSize;
    _processId = processId;
    _processKey = processKey;
    _processTitle = processTitle;
    _sort = sort;
    _startUser = startUser;
    _taskId = taskId;
    _taskName = taskName;
    _tenantId = tenantId;
    _custId = custId;
}

  FindUserTodoTaskBody.fromJson(dynamic json) {
    _page = json["page"];
    _pageSize = json["pageSize"];
    _processId = json["processId"];
    _processKey = json["processKey"];
    _processTitle = json["processTitle"];
    _sort = json["sort"];
    _startUser = json["startUser"];
    _taskId = json["taskId"];
    _taskName = json["taskName"];
    _tenantId = json["tenantId"];
    _custId = json["custId"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["page"] = _page;
    map["pageSize"] = _pageSize;
    map["processId"] = _processId;
    map["processKey"] = _processKey;
    map["processTitle"] = _processTitle;
    map["sort"] = _sort;
    map["startUser"] = _startUser;
    map["taskId"] = _taskId;
    map["taskName"] = _taskName;
    map["tenantId"] = _tenantId;
    map["custId"] = _custId;
    return map;
  }

}
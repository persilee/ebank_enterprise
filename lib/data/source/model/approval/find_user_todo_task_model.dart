/// sort : null
/// page : 3
/// pageSize : 10
/// count : 32
/// totalPage : 4
/// rows : [{"processId":"185652","processKey":"oneToOneTransferApproval","processTitle":"oneToOneTransferApprovalTitle","taskId":"185669","taskName":"Interanal Transfer Approval","assign":null,"owner":null,"applicantId":"789537104068608000","applicantName":null,"createTime":"2021-03-27 15:07:41","result":"1","businessKey":"0101238000001758","tenantId":"EB"},{"processId":"185504","processKey":"oneToOneTransferApproval","processTitle":"oneToOneTransferApprovalTitle","taskId":"185521","taskName":"Interanal Transfer Approval","assign":null,"owner":null,"applicantId":"789537104068608000","applicantName":null,"createTime":"2021-03-27 11:39:11","result":"1","businessKey":"0101208000001528","tenantId":"EB"},{"processId":"185310","processKey":"oneToOneTransferApproval","processTitle":"oneToOneTransferApprovalTitle","taskId":"185327","taskName":"Interanal Transfer Approval","assign":null,"owner":null,"applicantId":"989185387615485957","applicantName":null,"createTime":"2021-03-26 19:20:16","result":"1","businessKey":"0101208000001528","tenantId":"EB"},{"processId":"185291","processKey":"oneToOneTransferApproval","processTitle":"oneToOneTransferApprovalTitle","taskId":"185308","taskName":"Interanal Transfer Approval","assign":null,"owner":null,"applicantId":"989185387615485957","applicantName":null,"createTime":"2021-03-26 19:19:50","result":"1","businessKey":"0101268000001878","tenantId":"EB"},{"processId":"185272","processKey":"oneToOneTransferApproval","processTitle":"oneToOneTransferApprovalTitle","taskId":"185289","taskName":"Interanal Transfer Approval","assign":null,"owner":null,"applicantId":"989185387615485957","applicantName":null,"createTime":"2021-03-26 19:18:32","result":"1","businessKey":"0101238000001758","tenantId":"EB"},{"processId":"185253","processKey":"oneToOneTransferApproval","processTitle":"oneToOneTransferApprovalTitle","taskId":"185270","taskName":"Interanal Transfer Approval","assign":null,"owner":null,"applicantId":"989185387615485960","applicantName":null,"createTime":"2021-03-26 19:15:04","result":"1","businessKey":"0101238000001538","tenantId":"EB"},{"processId":"185152","processKey":"earlyRedTdContractApproval","processTitle":"earlyRedTdContractApprovalTitle","taskId":"185169","taskName":"Time Deposit Withdrawal Approval","assign":null,"owner":null,"applicantId":"989185387615485956","applicantName":null,"createTime":"2021-03-26 17:50:50","result":"1","businessKey":"01018580000007680002","tenantId":"EB"},{"processId":"185133","processKey":"earlyRedTdContractApproval","processTitle":"earlyRedTdContractApprovalTitle","taskId":"185150","taskName":"Time Deposit Withdrawal Approval","assign":null,"owner":null,"applicantId":"989185387615485956","applicantName":null,"createTime":"2021-03-26 17:50:42","result":"1","businessKey":"01018580000007680001","tenantId":"EB"},{"processId":"185095","processKey":"openTdContractApproval","processTitle":"openTdContractApprovalTitle","taskId":"185112","taskName":"Open Time Deposit Contract Approval","assign":null,"owner":null,"applicantId":"989185387615485956","applicantName":null,"createTime":"2021-03-26 17:49:55","result":"1","businessKey":"0101238000001758","tenantId":"EB"},{"processId":"185076","processKey":"earlyRedTdContractApproval","processTitle":"earlyRedTdContractApprovalTitle","taskId":"185093","taskName":"Time Deposit Withdrawal Approval","assign":null,"owner":null,"applicantId":"989185387615485956","applicantName":null,"createTime":"2021-03-26 17:45:03","result":"1","businessKey":"01018580000007680001","tenantId":"EB"}]

class FindUserTodoTaskModel {
  dynamic _sort;
  int _page;
  int _pageSize;
  int _count;
  int _totalPage;
  List<ApprovalTask> _rows;

  dynamic get sort => _sort;
  int get page => _page;
  int get pageSize => _pageSize;
  int get count => _count;
  int get totalPage => _totalPage;
  List<ApprovalTask> get rows => _rows;

  FindUserTodoTaskModel({
      dynamic sort, 
      int page, 
      int pageSize, 
      int count, 
      int totalPage, 
      List<ApprovalTask> rows}){
    _sort = sort;
    _page = page;
    _pageSize = pageSize;
    _count = count;
    _totalPage = totalPage;
    _rows = rows;
}

  FindUserTodoTaskModel.fromJson(dynamic json) {
    _sort = json["sort"];
    _page = json["page"];
    _pageSize = json["pageSize"];
    _count = json["count"];
    _totalPage = json["totalPage"];
    if (json["rows"] != null) {
      _rows = [];
      json["rows"].forEach((v) {
        _rows.add(ApprovalTask.fromJson(v));
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

/// processId : "185652"
/// processKey : "oneToOneTransferApproval"
/// processTitle : "oneToOneTransferApprovalTitle"
/// taskId : "185669"
/// taskName : "Interanal Transfer Approval"
/// assign : null
/// owner : null
/// applicantId : "789537104068608000"
/// applicantName : null
/// createTime : "2021-03-27 15:07:41"
/// result : "1"
/// businessKey : "0101238000001758"
/// tenantId : "EB"

class ApprovalTask {
  String _processId;
  String _processKey;
  String _processTitle;
  String _taskId;
  String _taskName;
  dynamic _assign;
  dynamic _owner;
  String _applicantId;
  dynamic _applicantName;
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
  String get applicantId => _applicantId;
  dynamic get applicantName => _applicantName;
  String get createTime => _createTime;
  String get result => _result;
  String get businessKey => _businessKey;
  String get tenantId => _tenantId;

  ApprovalTask({
      String processId, 
      String processKey, 
      String processTitle, 
      String taskId, 
      String taskName, 
      dynamic assign, 
      dynamic owner, 
      String applicantId, 
      dynamic applicantName, 
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
    _applicantId = applicantId;
    _applicantName = applicantName;
    _createTime = createTime;
    _result = result;
    _businessKey = businessKey;
    _tenantId = tenantId;
}

  ApprovalTask.fromJson(dynamic json) {
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
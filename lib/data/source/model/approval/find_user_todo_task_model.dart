/// sort : null
/// page : 1
/// pageSize : 10
/// count : 94
/// totalPage : 10
/// rows : [{"processId":"338131","processKey":"internationalTransferApproval","processTitle":"internationalTransferApprovalTitle","taskId":"338250","taskName":"International Transfer","assign":"829378511096512512","owner":null,"applicantId":"829379514709573632","applicantName":"HSG19 Checker","createTime":"2021-05-29 10:39:57","result":"2","businessKey":"8011218000003938","tenantId":"EB","endTime":null,"amount":"258","ccy":"USD"},{"processId":"335470","processKey":"internationalTransferApproval","processTitle":"internationalTransferApprovalTitle","taskId":"335589","taskName":"International Transfer","assign":"829378511096512512","owner":null,"applicantId":"829378163250298880","applicantName":"HSG13 Checker","createTime":"2021-05-27 11:37:50","result":"2","businessKey":"8011218000003938","tenantId":"EB","endTime":null,"amount":"20","ccy":"USD"},{"processId":"335243","processKey":"oneToOneTransferApproval","processTitle":"oneToOneTransferApprovalTitle","taskId":"335362","taskName":"Internal Transfer","assign":"829378511096512512","owner":null,"applicantId":"829378163250298880","applicantName":"HSG13 Checker","createTime":"2021-05-27 11:32:57","result":"2","businessKey":"8011218000003938","tenantId":"EB","endTime":null,"amount":"10","ccy":"USD"},{"processId":"328174","processKey":"internationalTransferApproval","processTitle":"internationalTransferApprovalTitle","taskId":"328288","taskName":"International Transfer","assign":"829378511096512512","owner":null,"applicantId":"829377766448168960","applicantName":"HSG10 Maker","createTime":"2021-05-24 20:05:21","result":"2","businessKey":"0001208000001428","tenantId":"EB","endTime":null,"amount":"111","ccy":"USD"},{"processId":"325664","processKey":"loanWithDrawalApproval","processTitle":"loanWithDrawalApprovalTitle","taskId":"325778","taskName":"Loan Drawdown","assign":"829378511096512512","owner":null,"applicantId":"829378511096512512","applicantName":"HSG16 Checker","createTime":"2021-05-21 11:39:53","result":"2","businessKey":"0001208000001428","tenantId":"EB","endTime":null,"amount":"2525","ccy":"USD"},{"processId":"325443","processKey":"oneToOneTransferApproval","processTitle":"oneToOneTransferApprovalTitle","taskId":"325557","taskName":"Internal Transfer","assign":"829378511096512512","owner":null,"applicantId":"829377766448168960","applicantName":"HSG10 Maker","createTime":"2021-05-21 10:52:40","result":"2","businessKey":"0001208000001428","tenantId":"EB","endTime":null,"amount":"255","ccy":"USD"},{"processId":"324916","processKey":"postRepaymentApproval","processTitle":"postRepaymentApprovalTitle","taskId":"325030","taskName":"Prepayment","assign":"829378511096512512","owner":null,"applicantId":"829377766448168960","applicantName":"HSG10 Maker","createTime":"2021-05-20 16:41:51","result":"2","businessKey":"80131680030007980001","tenantId":"EB","endTime":null,"amount":"83071.66","ccy":"USD"},{"processId":"323316","processKey":"loanRepaymentApproval","processTitle":"loanRepaymentApprovalTitle","taskId":"323430","taskName":"Loan Repayment","assign":"829378511096512512","owner":null,"applicantId":"829378511096512512","applicantName":"HSG16 Checker","createTime":"2021-05-20 09:53:18","result":"2","businessKey":"8013168003000798","tenantId":"EB","endTime":null,"amount":"84281.14","ccy":"USD"},{"processId":"322963","processKey":"loanRepaymentApproval","processTitle":"loanRepaymentApprovalTitle","taskId":"323073","taskName":"Loan Repayment","assign":"829378511096512512","owner":null,"applicantId":"829378511096512512","applicantName":"HSG16 Checker","createTime":"2021-05-19 17:00:35","result":"2","businessKey":"8013168003000798","tenantId":"EB","endTime":null,"amount":"84241.58","ccy":"USD"},{"processId":"322647","processKey":"loanRepaymentApproval","processTitle":"loanRepaymentApprovalTitle","taskId":"322757","taskName":"Loan Repayment","assign":"829378511096512512","owner":null,"applicantId":"829378511096512512","applicantName":"HSG16 Checker","createTime":"2021-05-19 16:54:15","result":"2","businessKey":"8013168003000798","tenantId":"EB","endTime":null,"amount":"84241.58","ccy":"USD"}]

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

  FindUserTodoTaskModel(
      {dynamic sort,
      int page,
      int pageSize,
      int count,
      int totalPage,
      List<ApprovalTask> rows}) {
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

/// processId : "338131"
/// processKey : "internationalTransferApproval"
/// processTitle : "internationalTransferApprovalTitle"
/// taskId : "338250"
/// taskName : "International Transfer"
/// assign : "829378511096512512"
/// owner : null
/// applicantId : "829379514709573632"
/// applicantName : "HSG19 Checker"
/// createTime : "2021-05-29 10:39:57"
/// result : "2"
/// businessKey : "8011218000003938"
/// tenantId : "EB"
/// endTime : null
/// amount : "258"
/// ccy : "USD"

class ApprovalTask {
  String _processId;
  String _processKey;
  String _processTitle;
  String _taskId;
  String _taskName;
  String _assign;
  dynamic _owner;
  String _applicantId;
  String _applicantName;
  String _createTime;
  String _result;
  String _businessKey;
  String _tenantId;
  dynamic _endTime;
  String _amount;
  String _ccy;

  String get processId => _processId;
  String get processKey => _processKey;
  String get processTitle => _processTitle;
  String get taskId => _taskId;
  String get taskName => _taskName;
  String get assign => _assign;
  dynamic get owner => _owner;
  String get applicantId => _applicantId;
  String get applicantName => _applicantName;
  String get createTime => _createTime;
  String get result => _result;
  String get businessKey => _businessKey;
  String get tenantId => _tenantId;
  dynamic get endTime => _endTime;
  String get amount => _amount;
  String get ccy => _ccy;

  ApprovalTask(
      {String processId,
      String processKey,
      String processTitle,
      String taskId,
      String taskName,
      String assign,
      dynamic owner,
      String applicantId,
      String applicantName,
      String createTime,
      String result,
      String businessKey,
      String tenantId,
      dynamic endTime,
      String amount,
      String ccy}) {
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
    _endTime = endTime;
    _amount = amount;
    _ccy = ccy;
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
    _endTime = json["endTime"];
    _amount = json["amount"];
    _ccy = json["ccy"];
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
    map["endTime"] = _endTime;
    map["amount"] = _amount;
    map["ccy"] = _ccy;
    return map;
  }
}

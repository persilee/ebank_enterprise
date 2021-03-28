/// data : [{"index":1,"taskName":"预约转账","type":"transferPlanApproval","startUser":"0703658789","createTime":"2021-03-26 11:12:30","status":"完成"},{"index":2,"taskName":"开立定期存单","type":"openTdContractApproval","startUser":"0703658663","createTime":"2021-03-26 09:17:38","status":"完成"},{"index":3,"taskName":"行内转账","type":"oneToOneTransferApproval","startUser":"0703658789","createTime":"2021-03-25 18:36:10","status":"完成"},{"index":4,"taskName":"国际汇款","type":"internationalTransferApproval","startUser":"0703658789","createTime":"2021-03-25 20:42:39","status":"完成"},{"index":5,"taskName":"定期提前结清","type":"earlyRedTdContractApproval","startUser":"0703658663","createTime":"2021-03-24 12:26:56","status":"完成"},{"index":6,"taskName":"定期提前结清","type":"earlyRedTdContractApproval","startUser":"0703658663","createTime":"2021-03-24 09:16:27","status":"完成"},{"index":7,"taskName":"预约转账","type":"transferPlanApproval","startUser":"0703658789","createTime":"2021-03-23 18:06:18","status":"完成"},{"index":8,"taskName":"开立定期存单","type":"openTdContractApproval","startUser":"0703658663","createTime":"2021-03-23 14:16:08","status":"完成"},{"index":9,"taskName":"行内转账","type":"oneToOneTransferApproval","startUser":"0703658789","createTime":"2021-03-21 19:08:48","status":"完成"},{"index":10,"taskName":"国际汇款","type":"internationalTransferApproval","startUser":"0703658789","createTime":"2021-03-21 11:28:42","status":"完成"},{"index":11,"taskName":"定期提前结清","type":"earlyRedTdContractApproval","startUser":"0703658663","createTime":"2021-03-21 09:46:13","status":"完成"},{"index":12,"taskName":"预约转账","type":"transferPlanApproval","startUser":"0703658789","createTime":"2021-03-19 16:26:18","status":"完成"},{"index":13,"taskName":"预约转账","type":"transferPlanApproval","startUser":"0703658789","createTime":"2021-03-19 11:36:42","status":"完成"},{"index":14,"taskName":"行内转账","type":"oneToOneTransferApproval","startUser":"0703658789","createTime":"2021-03-18 21:32:12","status":"完成"},{"index":15,"taskName":"定期提前结清","type":"earlyRedTdContractApproval","startUser":"0703658663","createTime":"2021-03-18 15:22:34","status":"完成"}]

class MyApprovalData {
  List<Data> _data;

  List<Data> get data => _data;

  MyApprovalData({
      List<Data> data}){
    _data = data;
}

  MyApprovalData.fromJson(dynamic json) {
    if (json["data"] != null) {
      _data = [];
      json["data"].forEach((v) {
        _data.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (_data != null) {
      map["data"] = _data.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// index : 1
/// taskName : "预约转账"
/// type : "transferPlanApproval"
/// startUser : "0703658789"
/// createTime : "2021-03-26 11:12:30"
/// status : "完成"

class Data {
  int _index;
  String _taskName;
  String _type;
  String _startUser;
  String _createTime;
  String _status;

  int get index => _index;
  String get taskName => _taskName;
  String get type => _type;
  String get startUser => _startUser;
  String get createTime => _createTime;
  String get status => _status;

  Data({
      int index, 
      String taskName, 
      String type, 
      String startUser, 
      String createTime, 
      String status}){
    _index = index;
    _taskName = taskName;
    _type = type;
    _startUser = startUser;
    _createTime = createTime;
    _status = status;
}

  Data.fromJson(dynamic json) {
    _index = json["index"];
    _taskName = json["taskName"];
    _type = json["type"];
    _startUser = json["startUser"];
    _createTime = json["createTime"];
    _status = json["status"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["index"] = _index;
    map["taskName"] = _taskName;
    map["type"] = _type;
    map["startUser"] = _startUser;
    map["createTime"] = _createTime;
    map["status"] = _status;
    return map;
  }

}
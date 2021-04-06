/// approveResult : false
/// comment : "同意"
/// rejectToStart : false
/// taskId : "210067"

class CompleteTaskBody {
  bool _approveResult;
  String _comment;
  bool _rejectToStart;
  String _taskId;

  bool get approveResult => _approveResult;
  String get comment => _comment;
  bool get rejectToStart => _rejectToStart;
  String get taskId => _taskId;

  CompleteTaskBody({
      bool approveResult, 
      String comment, 
      bool rejectToStart, 
      String taskId}){
    _approveResult = approveResult;
    _comment = comment;
    _rejectToStart = rejectToStart;
    _taskId = taskId;
}

  CompleteTaskBody.fromJson(dynamic json) {
    _approveResult = json["approveResult"];
    _comment = json["comment"];
    _rejectToStart = json["rejectToStart"];
    _taskId = json["taskId"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["approveResult"] = _approveResult;
    map["comment"] = _comment;
    map["rejectToStart"] = _rejectToStart;
    map["taskId"] = _taskId;
    return map;
  }

}
/// processId : "147647"

class FindTodoTaskDetailBody {
  String _processId;

  String get processId => _processId;

  FindTodoTaskDetailBody({
      String processId}){
    _processId = processId;
}

  FindTodoTaskDetailBody.fromJson(dynamic json) {
    _processId = json["processId"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["processId"] = _processId;
    return map;
  }

}
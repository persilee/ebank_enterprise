/// endDate : "2021-04-16"
/// startDate : "2021-04-01"

class StatementQueryListBody {
  String _endDate;
  String _startDate;

  String get endDate => _endDate;
  String get startDate => _startDate;

  StatementQueryListBody({
      String endDate, 
      String startDate}){
    _endDate = endDate;
    _startDate = startDate;
}

  StatementQueryListBody.fromJson(dynamic json) {
    _endDate = json["endDate"];
    _startDate = json["startDate"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["endDate"] = _endDate;
    map["startDate"] = _startDate;
    return map;
  }

}
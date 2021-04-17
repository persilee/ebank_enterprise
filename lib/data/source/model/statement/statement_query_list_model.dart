/// statementDTOS : [{"internalId":"20200917-C-P-8100000567-01-D-20210401-161946_pdf","reportCode":"20200917-C-P-8100000567-01-D","reportName":"测试数据","instId":null,"ciNo":"878000000678","acNo":"","contractNo":null,"reportDate":"2021-04-16","reportStartDate":"2021-04-13","reportEndDate":"2021-04-20","printTimes":3,"reportFilesize":30}]

class StatementQueryListModel {
  List<StatementDTOS> _statementDTOS;

  List<StatementDTOS> get statementDTOS => _statementDTOS;

  StatementQueryListModel({
      List<StatementDTOS> statementDTOS}){
    _statementDTOS = statementDTOS;
}

  StatementQueryListModel.fromJson(dynamic json) {
    if (json["statementDTOS"] != null) {
      _statementDTOS = [];
      json["statementDTOS"].forEach((v) {
        _statementDTOS.add(StatementDTOS.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (_statementDTOS != null) {
      map["statementDTOS"] = _statementDTOS.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// internalId : "20200917-C-P-8100000567-01-D-20210401-161946_pdf"
/// reportCode : "20200917-C-P-8100000567-01-D"
/// reportName : "测试数据"
/// instId : null
/// ciNo : "878000000678"
/// acNo : ""
/// contractNo : null
/// reportDate : "2021-04-16"
/// reportStartDate : "2021-04-13"
/// reportEndDate : "2021-04-20"
/// printTimes : 3
/// reportFilesize : 30

class StatementDTOS {
  String _internalId;
  String _reportCode;
  String _reportName;
  dynamic _instId;
  String _ciNo;
  String _acNo;
  dynamic _contractNo;
  String _reportDate;
  String _reportStartDate;
  String _reportEndDate;
  int _printTimes;
  int _reportFilesize;

  String get internalId => _internalId;
  String get reportCode => _reportCode;
  String get reportName => _reportName;
  dynamic get instId => _instId;
  String get ciNo => _ciNo;
  String get acNo => _acNo;
  dynamic get contractNo => _contractNo;
  String get reportDate => _reportDate;
  String get reportStartDate => _reportStartDate;
  String get reportEndDate => _reportEndDate;
  int get printTimes => _printTimes;
  int get reportFilesize => _reportFilesize;

  StatementDTOS({
      String internalId, 
      String reportCode, 
      String reportName, 
      dynamic instId, 
      String ciNo, 
      String acNo, 
      dynamic contractNo, 
      String reportDate, 
      String reportStartDate, 
      String reportEndDate, 
      int printTimes, 
      int reportFilesize}){
    _internalId = internalId;
    _reportCode = reportCode;
    _reportName = reportName;
    _instId = instId;
    _ciNo = ciNo;
    _acNo = acNo;
    _contractNo = contractNo;
    _reportDate = reportDate;
    _reportStartDate = reportStartDate;
    _reportEndDate = reportEndDate;
    _printTimes = printTimes;
    _reportFilesize = reportFilesize;
}

  StatementDTOS.fromJson(dynamic json) {
    _internalId = json["internalId"];
    _reportCode = json["reportCode"];
    _reportName = json["reportName"];
    _instId = json["instId"];
    _ciNo = json["ciNo"];
    _acNo = json["acNo"];
    _contractNo = json["contractNo"];
    _reportDate = json["reportDate"];
    _reportStartDate = json["reportStartDate"];
    _reportEndDate = json["reportEndDate"];
    _printTimes = json["printTimes"];
    _reportFilesize = json["reportFilesize"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["internalId"] = _internalId;
    map["reportCode"] = _reportCode;
    map["reportName"] = _reportName;
    map["instId"] = _instId;
    map["ciNo"] = _ciNo;
    map["acNo"] = _acNo;
    map["contractNo"] = _contractNo;
    map["reportDate"] = _reportDate;
    map["reportStartDate"] = _reportStartDate;
    map["reportEndDate"] = _reportEndDate;
    map["printTimes"] = _printTimes;
    map["reportFilesize"] = _reportFilesize;
    return map;
  }

}
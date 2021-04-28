/// sort : null
/// page : 1
/// pageSize : 10
/// count : 4
/// totalPage : 1
/// rows : [{"prodType":"TD","bppdCode":"TDCBCBSC","engName":"Time Deposit - Corporate - Basic","lclName":"定期产品1","chName":"定期產品1","remark":"","minAmt":"10000","ccy":"USD","minAuctCale":"1","minAccuPeriod":"1","maxAuctCale":"5","maxAccuPeriod":"5","minRate":"2.3","maxRate":"4.5","depositType":"A","erstFlg":"Y","id":1,"delFlg":"N","statusNo":"0","insTr":null,"maxTerm":"Y005","minTerm":"D001"},{"prodType":"TD","bppdCode":"TDCBCMIW","engName":"Time Deposit - Corporate - Monthly Interest Withdrawal","lclName":"定期产品2","chName":"定期產品2","remark":"","minAmt":"100000","ccy":"HKD","minAuctCale":"3","minAccuPeriod":"2","maxAuctCale":"1","maxAccuPeriod":"5","minRate":"2.3","maxRate":"4.5","depositType":"A","erstFlg":"Y","id":2,"delFlg":"N","statusNo":"0","insTr":null,"maxTerm":"Y001","minTerm":"M003"},{"prodType":"TD","bppdCode":"TDCBCELA","engName":"Time Deposit - Corporate - Extra Large Amount","lclName":"定期产品3","chName":"定期產品3","remark":"","minAmt":"100000000","ccy":"CNY","minAuctCale":"1","minAccuPeriod":"1","maxAuctCale":"1","maxAccuPeriod":"5","minRate":"1.2","maxRate":"4.1","depositType":"A","erstFlg":"Y","id":3,"delFlg":"N","statusNo":"0","insTr":null,"maxTerm":"Y001","minTerm":"D001"},{"prodType":"TD","bppdCode":"TDCBCTMD","engName":"Time Deposit - Corporate - Tailor-Made Deposit","lclName":"定期产品4","chName":"定期產品4","remark":"","minAmt":"1000000","ccy":"EUR","minAuctCale":"1","minAccuPeriod":"1","maxAuctCale":"1","maxAccuPeriod":"5","minRate":"0.2","maxRate":"3.4","depositType":"A","erstFlg":"Y","id":4,"delFlg":"N","statusNo":"0","insTr":null,"maxTerm":"Y001","minTerm":"D001"}]

class TdepProductsModel {
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

  TdepProductsModel({
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

  TdepProductsModel.fromJson(dynamic json) {
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

/// prodType : "TD"
/// bppdCode : "TDCBCBSC"
/// engName : "Time Deposit - Corporate - Basic"
/// lclName : "定期产品1"
/// chName : "定期產品1"
/// remark : ""
/// minAmt : "10000"
/// ccy : "USD"
/// minAuctCale : "1"
/// minAccuPeriod : "1"
/// maxAuctCale : "5"
/// maxAccuPeriod : "5"
/// minRate : "2.3"
/// maxRate : "4.5"
/// depositType : "A"
/// erstFlg : "Y"
/// id : 1
/// delFlg : "N"
/// statusNo : "0"
/// insTr : null
/// maxTerm : "Y005"
/// minTerm : "D001"

class Rows {
  String _prodType;
  String _bppdCode;
  String _engName;
  String _lclName;
  String _chName;
  String _remark;
  String _minAmt;
  String _ccy;
  String _minAuctCale;
  String _minAccuPeriod;
  String _maxAuctCale;
  String _maxAccuPeriod;
  String _minRate;
  String _maxRate;
  String _depositType;
  String _erstFlg;
  int _id;
  String _delFlg;
  String _statusNo;
  dynamic _insTr;
  String _maxTerm;
  String _minTerm;

  String get prodType => _prodType;
  String get bppdCode => _bppdCode;
  String get engName => _engName;
  String get lclName => _lclName;
  String get chName => _chName;
  String get remark => _remark;
  String get minAmt => _minAmt;
  String get ccy => _ccy;
  String get minAuctCale => _minAuctCale;
  String get minAccuPeriod => _minAccuPeriod;
  String get maxAuctCale => _maxAuctCale;
  String get maxAccuPeriod => _maxAccuPeriod;
  String get minRate => _minRate;
  String get maxRate => _maxRate;
  String get depositType => _depositType;
  String get erstFlg => _erstFlg;
  int get id => _id;
  String get delFlg => _delFlg;
  String get statusNo => _statusNo;
  dynamic get insTr => _insTr;
  String get maxTerm => _maxTerm;
  String get minTerm => _minTerm;

  Rows({
      String prodType, 
      String bppdCode, 
      String engName, 
      String lclName, 
      String chName, 
      String remark, 
      String minAmt, 
      String ccy, 
      String minAuctCale, 
      String minAccuPeriod, 
      String maxAuctCale, 
      String maxAccuPeriod, 
      String minRate, 
      String maxRate, 
      String depositType, 
      String erstFlg, 
      int id, 
      String delFlg, 
      String statusNo, 
      dynamic insTr, 
      String maxTerm, 
      String minTerm}){
    _prodType = prodType;
    _bppdCode = bppdCode;
    _engName = engName;
    _lclName = lclName;
    _chName = chName;
    _remark = remark;
    _minAmt = minAmt;
    _ccy = ccy;
    _minAuctCale = minAuctCale;
    _minAccuPeriod = minAccuPeriod;
    _maxAuctCale = maxAuctCale;
    _maxAccuPeriod = maxAccuPeriod;
    _minRate = minRate;
    _maxRate = maxRate;
    _depositType = depositType;
    _erstFlg = erstFlg;
    _id = id;
    _delFlg = delFlg;
    _statusNo = statusNo;
    _insTr = insTr;
    _maxTerm = maxTerm;
    _minTerm = minTerm;
}

  Rows.fromJson(dynamic json) {
    _prodType = json["prodType"];
    _bppdCode = json["bppdCode"];
    _engName = json["engName"];
    _lclName = json["lclName"];
    _chName = json["chName"];
    _remark = json["remark"];
    _minAmt = json["minAmt"];
    _ccy = json["ccy"];
    _minAuctCale = json["minAuctCale"];
    _minAccuPeriod = json["minAccuPeriod"];
    _maxAuctCale = json["maxAuctCale"];
    _maxAccuPeriod = json["maxAccuPeriod"];
    _minRate = json["minRate"];
    _maxRate = json["maxRate"];
    _depositType = json["depositType"];
    _erstFlg = json["erstFlg"];
    _id = json["id"];
    _delFlg = json["delFlg"];
    _statusNo = json["statusNo"];
    _insTr = json["insTr"];
    _maxTerm = json["maxTerm"];
    _minTerm = json["minTerm"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["prodType"] = _prodType;
    map["bppdCode"] = _bppdCode;
    map["engName"] = _engName;
    map["lclName"] = _lclName;
    map["chName"] = _chName;
    map["remark"] = _remark;
    map["minAmt"] = _minAmt;
    map["ccy"] = _ccy;
    map["minAuctCale"] = _minAuctCale;
    map["minAccuPeriod"] = _minAccuPeriod;
    map["maxAuctCale"] = _maxAuctCale;
    map["maxAccuPeriod"] = _maxAccuPeriod;
    map["minRate"] = _minRate;
    map["maxRate"] = _maxRate;
    map["depositType"] = _depositType;
    map["erstFlg"] = _erstFlg;
    map["id"] = _id;
    map["delFlg"] = _delFlg;
    map["statusNo"] = _statusNo;
    map["insTr"] = _insTr;
    map["maxTerm"] = _maxTerm;
    map["minTerm"] = _minTerm;
    return map;
  }

}
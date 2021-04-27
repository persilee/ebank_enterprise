/// accuPeriod : ""
/// ccy : ""
/// minAmt : ""
/// page : 1
/// pageSize : 100
/// sort : ""

class TdepProductsBody {
  String _accuPeriod;
  String _ccy;
  String _minAmt;
  int _page;
  int _pageSize;
  String _sort;

  String get accuPeriod => _accuPeriod;
  String get ccy => _ccy;
  String get minAmt => _minAmt;
  int get page => _page;
  int get pageSize => _pageSize;
  String get sort => _sort;

  TdepProductsBody({
      String accuPeriod, 
      String ccy, 
      String minAmt, 
      int page, 
      int pageSize, 
      String sort}){
    _accuPeriod = accuPeriod;
    _ccy = ccy;
    _minAmt = minAmt;
    _page = page;
    _pageSize = pageSize;
    _sort = sort;
}

  TdepProductsBody.fromJson(dynamic json) {
    _accuPeriod = json["accuPeriod"];
    _ccy = json["ccy"];
    _minAmt = json["minAmt"];
    _page = json["page"];
    _pageSize = json["pageSize"];
    _sort = json["sort"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["accuPeriod"] = _accuPeriod;
    map["ccy"] = _ccy;
    map["minAmt"] = _minAmt;
    map["page"] = _page;
    map["pageSize"] = _pageSize;
    map["sort"] = _sort;
    return map;
  }

}
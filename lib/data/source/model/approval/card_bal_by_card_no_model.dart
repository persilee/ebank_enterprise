/// cardNo : "0001208000001428"
/// totalAmt : "100682152.77"
/// defaultCcy : null
/// cardListBal : [{"accountType":null,"cardNo":"0001208000001428","ccy":"CNY","currBal":"269015.29","avaBal":"269015.29","freezeBal":"0","intBal":null,"equAmt":null},{"accountType":null,"cardNo":"0001208000001428","ccy":"JPY","currBal":"155015.74","avaBal":"155015.74","freezeBal":"0","intBal":null,"equAmt":null},{"accountType":null,"cardNo":"0001208000001428","ccy":"USD","currBal":"100258121.74","avaBal":"100239616.57","freezeBal":"18505.17","intBal":null,"equAmt":null}]

class CardBalByCardNoModel {
  String _cardNo;
  String _totalAmt;
  dynamic _defaultCcy;
  List<CardListBal> _cardListBal;

  String get cardNo => _cardNo;
  String get totalAmt => _totalAmt;
  dynamic get defaultCcy => _defaultCcy;
  List<CardListBal> get cardListBal => _cardListBal;

  CardBalByCardNoModel({
      String cardNo, 
      String totalAmt, 
      dynamic defaultCcy, 
      List<CardListBal> cardListBal}){
    _cardNo = cardNo;
    _totalAmt = totalAmt;
    _defaultCcy = defaultCcy;
    _cardListBal = cardListBal;
}

  CardBalByCardNoModel.fromJson(dynamic json) {
    _cardNo = json["cardNo"];
    _totalAmt = json["totalAmt"];
    _defaultCcy = json["defaultCcy"];
    if (json["cardListBal"] != null) {
      _cardListBal = [];
      json["cardListBal"].forEach((v) {
        _cardListBal.add(CardListBal.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["cardNo"] = _cardNo;
    map["totalAmt"] = _totalAmt;
    map["defaultCcy"] = _defaultCcy;
    if (_cardListBal != null) {
      map["cardListBal"] = _cardListBal.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// accountType : null
/// cardNo : "0001208000001428"
/// ccy : "CNY"
/// currBal : "269015.29"
/// avaBal : "269015.29"
/// freezeBal : "0"
/// intBal : null
/// equAmt : null

class CardListBal {
  dynamic _accountType;
  String _cardNo;
  String _ccy;
  String _currBal;
  String _avaBal;
  String _freezeBal;
  dynamic _intBal;
  dynamic _equAmt;

  dynamic get accountType => _accountType;
  String get cardNo => _cardNo;
  String get ccy => _ccy;
  String get currBal => _currBal;
  String get avaBal => _avaBal;
  String get freezeBal => _freezeBal;
  dynamic get intBal => _intBal;
  dynamic get equAmt => _equAmt;

  CardListBal({
      dynamic accountType, 
      String cardNo, 
      String ccy, 
      String currBal, 
      String avaBal, 
      String freezeBal, 
      dynamic intBal, 
      dynamic equAmt}){
    _accountType = accountType;
    _cardNo = cardNo;
    _ccy = ccy;
    _currBal = currBal;
    _avaBal = avaBal;
    _freezeBal = freezeBal;
    _intBal = intBal;
    _equAmt = equAmt;
}

  CardListBal.fromJson(dynamic json) {
    _accountType = json["accountType"];
    _cardNo = json["cardNo"];
    _ccy = json["ccy"];
    _currBal = json["currBal"];
    _avaBal = json["avaBal"];
    _freezeBal = json["freezeBal"];
    _intBal = json["intBal"];
    _equAmt = json["equAmt"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["accountType"] = _accountType;
    map["cardNo"] = _cardNo;
    map["ccy"] = _ccy;
    map["currBal"] = _currBal;
    map["avaBal"] = _avaBal;
    map["freezeBal"] = _freezeBal;
    map["intBal"] = _intBal;
    map["equAmt"] = _equAmt;
    return map;
  }

}
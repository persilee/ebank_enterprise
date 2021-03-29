/// transferList : [{"index":1,"dAc":"50006147456464","dAcName":"MIKE","oppAc":"50006147456464","oppAcName":"MIKE","bal":"1500.00","ccy":"USD","postscript":"转账"},{"index":3,"dAc":"50006147456464","dAcName":"MIKE","oppAc":"50006147456464","oppAcName":"MIKE","bal":"1500.00","ccy":"USD","postscript":"转账"},{"index":4,"dAc":"50006147456464","dAcName":"MIKE","oppAc":"50006147456464","oppAcName":"MIKE","bal":"1500.00","ccy":"USD","postscript":"转账"},{"index":7,"dAc":"50006147456464","dAcName":"MIKE","oppAc":"50006147456464","oppAcName":"MIKE","bal":"1500.00","ccy":"USD","postscript":"转账"},{"index":9,"dAc":"50006147456464","dAcName":"MIKE","oppAc":"50006147456464","oppAcName":"MIKE","bal":"1500.00","ccy":"USD","postscript":"转账"},{"index":10,"dAc":"50006147456464","dAcName":"MIKE","oppAc":"50006147456464","oppAcName":"MIKE","bal":"1500.00","ccy":"USD","postscript":"转账"},{"index":12,"dAc":"50006147456464","dAcName":"MIKE","oppAc":"50006147456464","oppAcName":"MIKE","bal":"1500.00","ccy":"USD","postscript":"转账"},{"index":13,"dAc":"50006147456464","dAcName":"MIKE","oppAc":"50006147456464","oppAcName":"MIKE","bal":"1500.00","ccy":"USD","postscript":"转账"},{"index":14,"dAc":"50006147456464","dAcName":"MIKE","oppAc":"50006147456464","oppAcName":"MIKE","bal":"1500.00","ccy":"USD","postscript":"转账"}]

class TransferDetailData {
  List<TransferList> _transferList;

  List<TransferList> get transferList => _transferList;

  TransferDetailData({
      List<TransferList> transferList}){
    _transferList = transferList;
}

  TransferDetailData.fromJson(dynamic json) {
    if (json["transferList"] != null) {
      _transferList = [];
      json["transferList"].forEach((v) {
        _transferList.add(TransferList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (_transferList != null) {
      map["transferList"] = _transferList.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// index : 1
/// dAc : "50006147456464"
/// dAcName : "MIKE"
/// oppAc : "50006147456464"
/// oppAcName : "MIKE"
/// bal : "1500.00"
/// ccy : "USD"
/// postscript : "转账"

class TransferList {
  int _index;
  String _dAc;
  String _dAcName;
  String _oppAc;
  String _oppAcName;
  String _bal;
  String _ccy;
  String _postscript;

  int get index => _index;
  String get dAc => _dAc;
  String get dAcName => _dAcName;
  String get oppAc => _oppAc;
  String get oppAcName => _oppAcName;
  String get bal => _bal;
  String get ccy => _ccy;
  String get postscript => _postscript;

  TransferList({
      int index, 
      String dAc, 
      String dAcName, 
      String oppAc, 
      String oppAcName, 
      String bal, 
      String ccy, 
      String postscript}){
    _index = index;
    _dAc = dAc;
    _dAcName = dAcName;
    _oppAc = oppAc;
    _oppAcName = oppAcName;
    _bal = bal;
    _ccy = ccy;
    _postscript = postscript;
}

  TransferList.fromJson(dynamic json) {
    _index = json["index"];
    _dAc = json["dAc"];
    _dAcName = json["dAcName"];
    _oppAc = json["oppAc"];
    _oppAcName = json["oppAcName"];
    _bal = json["bal"];
    _ccy = json["ccy"];
    _postscript = json["postscript"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["index"] = _index;
    map["dAc"] = _dAc;
    map["dAcName"] = _dAcName;
    map["oppAc"] = _oppAc;
    map["oppAcName"] = _oppAcName;
    map["bal"] = _bal;
    map["ccy"] = _ccy;
    map["postscript"] = _postscript;
    return map;
  }

}
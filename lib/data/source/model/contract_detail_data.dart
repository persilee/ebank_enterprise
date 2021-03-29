/// contractList : [{"index":2,"name":"颜氏基本新基金","tenor":"1-3月","bal":"1500.00","rate":"1.32%","ccy":"USD","inst":"等待客户指示","dAc":"0101238000001758","oppAc":"0101238000001758"},{"index":5,"name":"颜氏基本新基金","tenor":"1-3月","bal":"1500.00","rate":"1.32%","ccy":"USD","inst":"等待客户指示","dAc":"0101238000001758","oppAc":"0101238000001758"},{"index":5,"name":"颜氏基本新基金","tenor":"1-3月","bal":"1500.00","rate":"1.32%","ccy":"USD","inst":"等待客户指示","dAc":"0101238000001758","oppAc":"0101238000001758"},{"index":8,"name":"颜氏基本新基金","tenor":"1-3月","bal":"1500.00","rate":"1.32%","ccy":"USD","inst":"等待客户指示","dAc":"0101238000001758","oppAc":"0101238000001758"},{"index":11,"name":"颜氏基本新基金","tenor":"1-3月","bal":"1500.00","rate":"1.32%","ccy":"USD","inst":"等待客户指示","dAc":"0101238000001758","oppAc":"0101238000001758"},{"index":15,"name":"颜氏基本新基金","tenor":"1-3月","bal":"1500.00","rate":"1.32%","ccy":"USD","inst":"等待客户指示","dAc":"0101238000001758","oppAc":"0101238000001758"}]

class ContractDetailData {
  List<ContractList> _contractList;

  List<ContractList> get contractList => _contractList;

  ContractDetailData({
      List<ContractList> contractList}){
    _contractList = contractList;
}

  ContractDetailData.fromJson(dynamic json) {
    if (json["contractList"] != null) {
      _contractList = [];
      json["contractList"].forEach((v) {
        _contractList.add(ContractList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (_contractList != null) {
      map["contractList"] = _contractList.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// index : 2
/// name : "颜氏基本新基金"
/// tenor : "1-3月"
/// bal : "1500.00"
/// rate : "1.32%"
/// ccy : "USD"
/// inst : "等待客户指示"
/// dAc : "0101238000001758"
/// oppAc : "0101238000001758"

class ContractList {
  int _index;
  String _name;
  String _tenor;
  String _bal;
  String _rate;
  String _ccy;
  String _inst;
  String _dAc;
  String _oppAc;

  int get index => _index;
  String get name => _name;
  String get tenor => _tenor;
  String get bal => _bal;
  String get rate => _rate;
  String get ccy => _ccy;
  String get inst => _inst;
  String get dAc => _dAc;
  String get oppAc => _oppAc;

  ContractList({
      int index, 
      String name, 
      String tenor, 
      String bal, 
      String rate, 
      String ccy, 
      String inst, 
      String dAc, 
      String oppAc}){
    _index = index;
    _name = name;
    _tenor = tenor;
    _bal = bal;
    _rate = rate;
    _ccy = ccy;
    _inst = inst;
    _dAc = dAc;
    _oppAc = oppAc;
}

  ContractList.fromJson(dynamic json) {
    _index = json["index"];
    _name = json["name"];
    _tenor = json["tenor"];
    _bal = json["bal"];
    _rate = json["rate"];
    _ccy = json["ccy"];
    _inst = json["inst"];
    _dAc = json["dAc"];
    _oppAc = json["oppAc"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["index"] = _index;
    map["name"] = _name;
    map["tenor"] = _tenor;
    map["bal"] = _bal;
    map["rate"] = _rate;
    map["ccy"] = _ccy;
    map["inst"] = _inst;
    map["dAc"] = _dAc;
    map["oppAc"] = _oppAc;
    return map;
  }

}
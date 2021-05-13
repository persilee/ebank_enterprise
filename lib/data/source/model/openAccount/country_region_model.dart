import 'package:azlistview/azlistview.dart';

/// nameEN : "Andorra"
/// flZh : "A"
/// code : "376"
/// countryCode : "AD"
/// flEN : "A"
/// nameZhCN : "安哥拉"
/// nameZhHK : "安哥拉"

class CountryRegionModel extends ISuspensionBean {
  String nameEN;
  String flZh;
  String code;
  String countryCode;
  String flEN;
  String nameZhCN;
  String nameZhHK;
  String tagIndex;
  String namePinyin;

  CountryRegionModel({
    this.nameEN,
    this.flZh,
    this.code,
    this.countryCode,
    this.flEN,
    this.nameZhCN,
    this.nameZhHK,
    this.tagIndex,
    this.namePinyin,
  });

  CountryRegionModel.fromJson(Map<String, dynamic> json)
      : nameEN = json["nameEN"] == null ? "" : json["nameEN"],
        flZh = json["flZh"] == null ? "" : json["flZh"],
        code = json["code"] == null ? "" : json["code"],
        countryCode = json["countryCode"] == null ? "" : json["countryCode"],
        flEN = json["flEN"] == null ? "" : json["flEN"],
        nameZhCN = json["nameZhCN"] == null ? "" : json["nameZhCN"],
        nameZhHK = json["nameZhHK"] == null ? "" : json["nameZhHK"],
        tagIndex = json["tagIndex"] == null ? "" : json["tagIndex"],
        namePinyin = json["namePinyin"] == null ? "" : json["namePinyin"];

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["nameEN"] = nameEN;
    map["flZh"] = flZh;
    map["code"] = code;
    map["countryCode"] = countryCode;
    map["flEN"] = flEN;
    map["nameZhCN"] = nameZhCN;
    map["nameZhHK"] = nameZhHK;
    map["tagIndex"] = tagIndex;
    map["namePinyin"] = namePinyin;
    map["isShowSuspension"] = isShowSuspension;
    return map;
  }

  @override
  String getSuspensionTag() => tagIndex;
}

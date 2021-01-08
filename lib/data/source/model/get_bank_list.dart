import 'package:json_annotation/json_annotation.dart';

part 'get_bank_list.g.dart';

@JsonSerializable()
class GetBankListReq extends Object {
  @JsonKey(name: 'page')
  int page;

  @JsonKey(name: 'pageSize')
  int pageSize;

  GetBankListReq(
    this.page,
    this.pageSize,
  );

  factory GetBankListReq.fromJson(Map<String, dynamic> srcJson) =>
      _$GetBankListReqFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GetBankListReqToJson(this);
}

@JsonSerializable()
class GetBankListResp extends Object {
  @JsonKey(name: 'page')
  int page;

  @JsonKey(name: 'pageSize')
  int pageSize;

  @JsonKey(name: 'count')
  int count;

  @JsonKey(name: 'totalPage')
  int totalPage;

  @JsonKey(name: 'rows')
  List<Banks> banks;

  GetBankListResp(
    this.page,
    this.pageSize,
    this.count,
    this.totalPage,
    this.banks,
  );

  factory GetBankListResp.fromJson(Map<String, dynamic> srcJson) =>
      _$GetBankListRespFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GetBankListRespToJson(this);
}

@JsonSerializable()
class Banks extends Object {
  @JsonKey(name: 'bankCode')
  String bankCode;

  @JsonKey(name: 'bankType')
  String bankType;

  @JsonKey(name: 'localName')
  String localName;

  @JsonKey(name: 'englishName')
  String englishName;

  @JsonKey(name: 'bankSwift')
  String bankSwift;

  @JsonKey(name: 'intermediateBankSwift')
  String intermediateBankSwift;

  @JsonKey(name: 'bankIcon')
  String bankIcon;

  @JsonKey(name: 'bankDesc')
  String bankDesc;

  @JsonKey(name: 'createBy')
  String createBy;

  @JsonKey(name: 'modifyBy')
  String modifyBy;

  @JsonKey(name: 'createTime')
  String createTime;

  @JsonKey(name: 'modifyTime')
  String modifyTime;

  Banks(
    this.bankCode,
    this.bankType,
    this.localName,
    this.englishName,
    this.bankSwift,
    this.intermediateBankSwift,
    this.bankIcon,
    this.bankDesc,
    this.createBy,
    this.modifyBy,
    this.createTime,
    this.modifyTime,
  );

  factory Banks.fromJson(Map<String, dynamic> srcJson) =>
      _$BanksFromJson(srcJson);

  Map<String, dynamic> toJson() => _$BanksToJson(this);
}

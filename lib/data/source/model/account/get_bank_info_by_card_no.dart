import 'package:json_annotation/json_annotation.dart';

part 'get_bank_info_by_card_no.g.dart';

@JsonSerializable()
class GetBankInfoByCardNo extends Object {
  @JsonKey(name: 'cardNo')
  String cardNo;

  GetBankInfoByCardNo(
    this.cardNo,
  );

  factory GetBankInfoByCardNo.fromJson(Map<String, dynamic> srcJson) =>
      _$GetBankInfoByCardNoFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GetBankInfoByCardNoToJson(this);
}

@JsonSerializable()
class BankInfoByCardNoResp extends Object {
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

  @JsonKey(name: 'bankIcon')
  String bankIcon;

  @JsonKey(name: 'completeUrl')
  String completeUrl;

  @JsonKey(name: 'createBy')
  String createBy;

  @JsonKey(name: 'modifyBy')
  String modifyBy;

  @JsonKey(name: 'bankDesc')
  String bankDesc;

  @JsonKey(name: 'ebankPlatformCardBinDTO')
  EbankPlatformCardBinDTO ebankPlatformCardBinDTO;

  BankInfoByCardNoResp(
    this.bankCode,
    this.bankType,
    this.localName,
    this.englishName,
    this.bankSwift,
    this.bankIcon,
    this.completeUrl,
    this.createBy,
    this.modifyBy,
    this.bankDesc,
    this.ebankPlatformCardBinDTO,
  );

  factory BankInfoByCardNoResp.fromJson(Map<String, dynamic> srcJson) =>
      _$BankInfoByCardNoRespFromJson(srcJson);
  Map<String, dynamic> toJson() => _$BankInfoByCardNoRespToJson(this);
}

@JsonSerializable()
class EbankPlatformCardBinDTO extends Object {
  @JsonKey(name: 'cardBin')
  String cardBin;

  @JsonKey(name: 'bankCode')
  String bankCode;

  @JsonKey(name: 'localName')
  String localName;

  @JsonKey(name: 'englishName')
  String englishName;

  @JsonKey(name: 'binLength')
  int binLength;

  @JsonKey(name: 'cardType')
  String cardType;

  @JsonKey(name: 'createBy')
  String createBy;

  @JsonKey(name: 'modifyBy')
  String modifyBy;

  @JsonKey(name: 'createTime')
  String createTime;

  @JsonKey(name: 'modifyTime')
  String modifyTime;

  EbankPlatformCardBinDTO(
    this.cardBin,
    this.bankCode,
    this.localName,
    this.englishName,
    this.binLength,
    this.cardType,
    this.createBy,
    this.modifyBy,
    this.createTime,
    this.modifyTime,
  );

  factory EbankPlatformCardBinDTO.fromJson(Map<String, dynamic> srcJson) =>
      _$EbankPlatformCardBinDTOFromJson(srcJson);
  Map<String, dynamic> toJson() => _$EbankPlatformCardBinDTOToJson(this);
}

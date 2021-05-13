import 'package:json_annotation/json_annotation.dart';

part 'open_account_signature_result.g.dart';

@JsonSerializable()
class OpenAccountSignatureResultReq extends Object {
  ///证件识别方式
  @JsonKey(name: 'idDocu')
  String idDocu;

  ///手机号
  @JsonKey(name: 'phone')
  String phone;

  ///面签码
  @JsonKey(name: 'sigCode')
  String sigCode;

  OpenAccountSignatureResultReq(
    this.idDocu,
    this.phone,
    this.sigCode,
  );

  factory OpenAccountSignatureResultReq.fromJson(
          Map<String, dynamic> srcJson) =>
      _$OpenAccountSignatureResultReqFromJson(srcJson);

  Map<String, dynamic> toJson() => _$OpenAccountSignatureResultReqToJson(this);
}

@JsonSerializable()
class OpenAccountSignatureResultResp extends Object {
  OpenAccountSignatureResultResp();

  factory OpenAccountSignatureResultResp.fromJson(
          Map<String, dynamic> srcJson) =>
      _$OpenAccountSignatureResultRespFromJson(srcJson);

  Map<String, dynamic> toJson() => _$OpenAccountSignatureResultRespToJson(this);
}

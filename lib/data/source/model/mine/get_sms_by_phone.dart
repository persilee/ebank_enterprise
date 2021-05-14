import 'package:json_annotation/json_annotation.dart';

part 'get_sms_by_phone.g.dart';

@JsonSerializable()
class GetSmsByPhone extends Object {
  @JsonKey(name: 'phoneNumber')
  String phoneNumber;

  @JsonKey(name: 'smsType')
  String smsType;

  GetSmsByPhone(
    this.phoneNumber,
    this.smsType,
  );

  factory GetSmsByPhone.fromJson(Map<String, dynamic> srcJson) =>
      _$GetSmsByPhoneFromJson(srcJson);
  Map<String, dynamic> toJson() => _$GetSmsByPhoneToJson(this);
}

@JsonSerializable()
class SmsByPhoneResp extends Object {
  SmsByPhoneResp();

  factory SmsByPhoneResp.fromJson(Map<String, dynamic> srcJson) =>
      _$SmsByPhoneRespFromJson(srcJson);
  Map<String, dynamic> toJson() => _$SmsByPhoneRespToJson(this);
}

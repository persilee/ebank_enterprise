import 'package:json_annotation/json_annotation.dart';

part 'check_phone.g.dart';

@JsonSerializable()
class CheckPhoneReq extends Object {
  @JsonKey(name: 'userPhone')
  String userPhone;

  @JsonKey(name: 'userType')
  String userType;

  CheckPhoneReq(
    this.userPhone,
    this.userType,
  );

  factory CheckPhoneReq.fromJson(Map<String, dynamic> srcJson) =>
      _$CheckPhoneReqFromJson(srcJson);

  Map<String, dynamic> toJson() => _$CheckPhoneReqToJson(this);
}

@JsonSerializable()
class CheckPhoneResp extends Object {
  @JsonKey(name: 'register')
  bool register;

  @JsonKey(name: 'userAccount')
  String userAccount;

  CheckPhoneResp(
    this.register,
    this.userAccount,
  );

  factory CheckPhoneResp.fromJson(Map<String, dynamic> srcJson) =>
      _$CheckPhoneRespFromJson(srcJson);

  Map<String, dynamic> toJson() => _$CheckPhoneRespToJson(this);
}

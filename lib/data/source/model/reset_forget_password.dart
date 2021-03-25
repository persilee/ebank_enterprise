import 'package:json_annotation/json_annotation.dart';

part 'reset_forget_password.g.dart';

@JsonSerializable()
class ResetForgetPassword extends Object {
  @JsonKey(name: 'confirmNewPassword')
  String confirmNewPassword;

  @JsonKey(name: 'newPassword')
  String newPassword;

  @JsonKey(name: 'userPhone')
  String userPhone;

  @JsonKey(name: 'userId')
  String userId;

  ResetForgetPassword(
    this.confirmNewPassword,
    this.newPassword,
    this.userPhone,
    this.userId,
  );
  Map<String, dynamic> toJson() => _$ResetForgetPasswordToJson(this);
  factory ResetForgetPassword.fromJson(Map<String, dynamic> srcJson) =>
      _$ResetForgetPasswordFromJson(srcJson);
}

@JsonSerializable()
class ResetForgetPasswordResp extends Object {
  @JsonKey(name: 'password')
  String password;

  ResetForgetPasswordResp(
    this.password,
  );
  Map<String, dynamic> toJson() => _$ResetForgetPasswordRespToJson(this);
  factory ResetForgetPasswordResp.fromJson(Map<String, dynamic> srcJson) =>
      _$ResetForgetPasswordRespFromJson(srcJson);
}

import 'package:json_annotation/json_annotation.dart';
part 'face_sign_businessid.g.dart';

@JsonSerializable()
class FaceSignIDReq extends Object {
  //请求
  @JsonKey(name: 'phone')
  String phone;

  @JsonKey(name: 'areaCode')
  String areaCode;

  @JsonKey(name: 'sigCode')
  String sigCode;

  @JsonKey(name: 'userId')
  String userId;

  FaceSignIDReq(
    this.phone,
    this.areaCode,
    this.sigCode,
    this.userId,
  );

  factory FaceSignIDReq.fromJson(Map<String, dynamic> srcJson) =>
      _$FaceSignIDReqFromJson(srcJson);
  Map<String, dynamic> toJson() => _$FaceSignIDReqToJson(this);
}

@JsonSerializable()
class FaceSignIDRespons extends Object {
  //响应
  @JsonKey(name: 'businessId')
  String businessId;

  //是否命中董事法人，董事法人需要签署协议
  @JsonKey(name: 'is_legShare')
  bool is_legShare;

  FaceSignIDRespons(
    this.businessId,
    this.is_legShare,
  );

  factory FaceSignIDRespons.fromJson(Map<String, dynamic> srcJson) =>
      _$FaceSignIDResponsFromJson(srcJson);
  Map<String, dynamic> toJson() => _$FaceSignIDResponsToJson(this);
}

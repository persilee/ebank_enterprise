/// Copyright (c) 2020 深圳高阳寰球科技有限公司
/// 获取用户协议
/// Author: CaiTM
/// Date: 2020-12-25
import 'package:json_annotation/json_annotation.dart';

part 'get_user_agreement.g.dart';

@JsonSerializable()
class FindPactListReq {
  @JsonKey(name: 'pactId')
  String pactId;
  @JsonKey(name: 'pactNameCn')
  String pactNameCn;
  @JsonKey(name: 'pactNameEn')
  String pactNameEn;
  @JsonKey(name: 'pageSize')
  int pageSize;
  @JsonKey(name: 'page')
  int page;

  FindPactListReq({
    this.pactId = '',
    this.pactNameCn = '',
    this.pactNameEn = '',
    this.pageSize = 100,
    this.page = 0,
  });

  @override
  String toString() {
    return toJson().toString();
  }

  factory FindPactListReq.fromJson(Map<String, dynamic> srcJson) =>
      _$FindPactListReqFromJson(srcJson);

  Map<String, dynamic> toJson() => _$FindPactListReqToJson(this);
}

@JsonSerializable()
class FindPactListResp {
  @JsonKey(name: 'rows')
  List<UserAgreement> rows;

  FindPactListResp(
    this.rows,
  );

  @override
  String toString() {
    return toJson().toString();
  }

  factory FindPactListResp.fromJson(Map<String, dynamic> srcJson) =>
      _$FindPactListRespFromJson(srcJson);

  Map<String, dynamic> toJson() => _$FindPactListRespToJson(this);
}

@JsonSerializable()
class UserAgreement {
  @JsonKey(name: 'pactId')
  String pactId;
  @JsonKey(name: 'detailCnLink')
  String detailCnLink;
  @JsonKey(name: 'detailEnLink')
  String detailEnLink;

  UserAgreement(
    this.pactId,
    this.detailCnLink,
    this.detailEnLink,
  );

  @override
  String toString() {
    return toJson().toString();
  }

  factory UserAgreement.fromJson(Map<String, dynamic> srcJson) =>
      _$UserAgreementFromJson(srcJson);

  Map<String, dynamic> toJson() => _$UserAgreementToJson(this);
}

@JsonSerializable()
class GetUserAgreementReq {
  @JsonKey(name: 'pactId')
  String pactId;

  GetUserAgreementReq(
    this.pactId,
  );

  @override
  String toString() {
    return toJson().toString();
  }

  factory GetUserAgreementReq.fromJson(Map<String, dynamic> srcJson) =>
      _$GetUserAgreementReqFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GetUserAgreementReqToJson(this);
}

@JsonSerializable()
class GetUserAgreementResp {
  @JsonKey(name: 'pactId')
  String pactId;
  @JsonKey(name: 'detailCnLink')
  String detailCnLink;

  @JsonKey(name: 'detailEnLink')
  String detailEnLink;

  @JsonKey(name: 'detailLocalLink')
  String detailLocalLink;

  @JsonKey(name: 'pactNameCn')
  String pactNameCn;

  @JsonKey(name: 'pactNameEn')
  String pactNameEn;

  @JsonKey(name: 'pactNameLocal')
  String pactNameLocal;
  GetUserAgreementResp(
    this.pactId,
    this.detailCnLink,
    this.detailEnLink,
    this.detailLocalLink,
    this.pactNameCn,
    this.pactNameEn,
    this.pactNameLocal,
  );

  @override
  String toString() {
    return toJson().toString();
  }

  factory GetUserAgreementResp.fromJson(Map<String, dynamic> srcJson) =>
      _$GetUserAgreementRespFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GetUserAgreementRespToJson(this);
}

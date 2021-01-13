import 'package:json_annotation/json_annotation.dart';

part 'get_branch_list.g.dart';

@JsonSerializable()
class GetBranchListReq extends Object {
  @JsonKey(name: 'page')
  int page;

  @JsonKey(name: 'pageSize')
  int pageSize;

  GetBranchListReq(
    this.page,
    this.pageSize,
  );

  factory GetBranchListReq.fromJson(Map<String, dynamic> srcJson) =>
      _$GetBranchListReqFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GetBranchListReqToJson(this);
}

@JsonSerializable()
class GetBranchListResp extends Object {
  @JsonKey(name: 'page')
  int page;

  @JsonKey(name: 'pageSize')
  int pageSize;

  @JsonKey(name: 'count')
  int count;

  @JsonKey(name: 'totalPage')
  int totalPage;

  @JsonKey(name: 'rows')
  List<Branches> branches;

  GetBranchListResp(
    this.page,
    this.pageSize,
    this.count,
    this.totalPage,
    this.branches,
  );

  factory GetBranchListResp.fromJson(Map<String, dynamic> srcJson) =>
      _$GetBranchListRespFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GetBranchListRespToJson(this);
}

@JsonSerializable()
class Branches extends Object {
  @JsonKey(name: 'modifyTime')
  String modifyTime;

  @JsonKey(name: 'createTime')
  String createTime;

  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'enFullName')
  String enFullName;

  @JsonKey(name: 'localFullName')
  String localFullName;

  @JsonKey(name: 'enShortName')
  String enShortName;

  @JsonKey(name: 'localShortName')
  String localShortName;

  @JsonKey(name: 'branchType')
  String branchType;

  @JsonKey(name: 'phone')
  String phone;

  @JsonKey(name: 'email')
  String email;

  @JsonKey(name: 'postCode')
  String postCode;

  @JsonKey(name: 'firstLevelDistrict')
  String firstLevelDistrict;

  @JsonKey(name: 'secondLevelDistrict')
  String secondLevelDistrict;

  @JsonKey(name: 'thirdLevelDistrict')
  String thirdLevelDistrict;

  @JsonKey(name: 'address')
  String address;

  @JsonKey(name: 'longitude')
  String longitude;

  @JsonKey(name: 'latitude')
  String latitude;

  @JsonKey(name: 'remark')
  String remark;

  @JsonKey(name: 'opentime')
  String opentime;

  Branches(
    this.modifyTime,
    this.createTime,
    this.id,
    this.enFullName,
    this.localFullName,
    this.enShortName,
    this.localShortName,
    this.branchType,
    this.phone,
    this.email,
    this.postCode,
    this.firstLevelDistrict,
    this.secondLevelDistrict,
    this.thirdLevelDistrict,
    this.address,
    this.longitude,
    this.latitude,
    this.remark,
    this.opentime,
  );

  factory Branches.fromJson(Map<String, dynamic> srcJson) =>
      _$BranchesFromJson(srcJson);

  Map<String, dynamic> toJson() => _$BranchesToJson(this);
}

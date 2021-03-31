import 'package:ebank_mobile/data/source/model/country_region_model.dart';
import 'package:ebank_mobile/data/source/model/get_public_parameters.dart';

/// Copyright (c) 2021 深圳高阳寰球科技有限公司
/// 快速开户上传公司信息模型（第一次数据提交）
/// Author: 李家伟
/// Date: 2021-03-23

import 'package:json_annotation/json_annotation.dart';

part 'open_account_quick_submit_data.g.dart';

@JsonSerializable()
class OpenAccountQuickSubmitDataReq {
  ///商业/行业性质
  @JsonKey(name: 'corporatinAttributes')
  String corporatinAttributes;

  ///公司类别
  @JsonKey(name: 'custCategory')
  String custCategory;

  ///客户名称(英文)
  @JsonKey(name: 'custNameEng')
  String custNameEng;

  ///客户名称(本地)
  @JsonKey(name: 'custNameLoc')
  String custNameLoc;

  ///证件签发国家
  @JsonKey(name: 'idIssuePlace')
  String idIssuePlace;

  ///证件号
  @JsonKey(name: 'idNo')
  String idNo;

  ///证件类型
  @JsonKey(name: 'idType')
  String idType;

  ///其他证件类型，选择其他后才需要输入
  @JsonKey(name: 'otherCategory')
  String otherCategory;

  ///地址信息列表
  @JsonKey(name: 'addressList')
  List<Address> addressList;

  ///办事处电话号码区号
  @JsonKey(name: 'telCountryCode')
  String telCountryCode;

  ///办事处电话号码
  @JsonKey(name: 'telNumber')
  String telNumber;

  ///相关人士信息列表
  @JsonKey(name: 'partnerList')
  List<Partner> partnerList;

  ///自定义字段，用来上传保存数据下载显示用
  ///商业/行业性质辅助字段
  @JsonKey(name: 'corporatinAttributesIdType')
  IdType corporatinAttributesIdType;

  ///公司类别辅助字段
  @JsonKey(name: 'custCategoryIdType')
  IdType custCategoryIdType;

  ///证件签发国家辅助字段
  @JsonKey(name: 'idIssuePlaceCountryRegionModel')
  CountryRegionModel idIssuePlaceCountryRegionModel;

  ///证件类型辅助字段
  @JsonKey(name: 'idTypeIdType')
  IdType idTypeIdType;

  OpenAccountQuickSubmitDataReq({
    this.corporatinAttributes,
    this.custCategory,
    this.custNameEng,
    this.custNameLoc,
    this.idIssuePlace,
    this.idNo,
    this.idType,
    this.otherCategory,
    this.addressList,
    this.telCountryCode,
    this.telNumber,
    this.partnerList,
    this.corporatinAttributesIdType,
    this.custCategoryIdType,
    this.idIssuePlaceCountryRegionModel,
    this.idTypeIdType,
  });

  @override
  String toString() {
    return toJson().toString();
  }

  factory OpenAccountQuickSubmitDataReq.fromJson(
          Map<String, dynamic> srcJson) =>
      _$OpenAccountQuickSubmitDataReqFromJson(srcJson);

  Map<String, dynamic> toJson() => _$OpenAccountQuickSubmitDataReqToJson(this);
}

///地址信息列表
@JsonSerializable()
class Address {
  ///商业/行业性质
  ///R:Registered Office Addres 注册公司地址
  ///P:Principal Business Address 主要营业地址
  ///C:Correspondence Address  通讯地址
  @JsonKey(name: 'addressType')
  String addressType;

  ///国家
  @JsonKey(name: 'country')
  String country;

  ///省
  @JsonKey(name: 'province')
  String province;

  ///市
  @JsonKey(name: 'city')
  String city;

  ///地址详情
  @JsonKey(name: 'detail')
  String detail;

  ///邮编
  @JsonKey(name: 'postCode')
  String postCode;

  ///自定义字段，用来上传保存数据下载显示用
  ///国家省市显示的字段
  @JsonKey(name: 'addressCityShowString')
  String addressCityShowString;

  ///国家省市选择
  @JsonKey(name: 'addressCitySelectList')
  List<int> addressCitySelectList;

  Address({
    this.addressType,
    this.country,
    this.province,
    this.city,
    this.detail,
    this.postCode,
    this.addressCityShowString,
    this.addressCitySelectList,
  });

  @override
  String toString() {
    return toJson().toString();
  }

  factory Address.fromJson(Map<String, dynamic> srcJson) =>
      _$AddressFromJson(srcJson);

  Map<String, dynamic> toJson() => _$AddressToJson(this);
}

///相关人士信息列表
@JsonSerializable()
class Partner {
  ///称呼
  @JsonKey(name: 'appellation')
  String appellation;

  ///证件类型
  @JsonKey(name: 'idType')
  String idType;

  ///国籍
  @JsonKey(name: 'nationality')
  String nationality;

  ///类别
  @JsonKey(name: 'partnerType')
  String partnerType;

  ///手机号
  @JsonKey(name: 'phone')
  String phone;

  ///名称（中文）
  @JsonKey(name: 'fullNameLoc')
  String fullNameLoc;

  ///名称（英文）
  @JsonKey(name: 'fullNameEng')
  String fullNameEng;

  ///证件号码
  @JsonKey(name: 'idNo')
  String idNo;

  ///自定义字段，用来上传保存数据下载显示用
  ///证件类型
  @JsonKey(name: 'idTypeIdType')
  IdType idTypeIdType;

  ///国籍辅助字段
  @JsonKey(name: 'nationalityCountryRegionModel')
  CountryRegionModel nationalityCountryRegionModel;

  ///类别
  @JsonKey(name: 'partnerTypeIdType')
  IdType partnerTypeIdType;

  ///称呼
  @JsonKey(name: 'appellationIdType')
  IdType appellationIdType;

  Partner({
    this.appellation,
    this.idType,
    this.nationality,
    this.partnerType,
    this.phone,
    // this.fullNameLoc,
    // this.fullNameEng,
    // this.idNo,
    this.idTypeIdType,
    this.nationalityCountryRegionModel,
    this.partnerTypeIdType,
    this.appellationIdType,
  });

  @override
  String toString() {
    return toJson().toString();
  }

  factory Partner.fromJson(Map<String, dynamic> srcJson) =>
      _$PartnerFromJson(srcJson);

  Map<String, dynamic> toJson() => _$PartnerToJson(this);
}

@JsonSerializable()
class OpenAccountQuickSubmitDataResp {
  ///业务编号
  @JsonKey(name: 'businessId')
  String businessId;

  OpenAccountQuickSubmitDataResp(
    this.businessId,
  );

  factory OpenAccountQuickSubmitDataResp.fromJson(
          Map<String, dynamic> srcJson) =>
      _$OpenAccountQuickSubmitDataRespFromJson(srcJson);

  Map<String, dynamic> toJson() => _$OpenAccountQuickSubmitDataRespToJson(this);
}

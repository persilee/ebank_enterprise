/*
 * Created Date: Wednesday, December 9th 2020, 3:37:33 pm
 * Author: pengyikang
 * 
 * Copyright (c) 2020 深圳高阳寰球科技有限公司
 */
import 'package:json_annotation/json_annotation.dart';

part 'get_deposit_by_card_no.g.dart';

@JsonSerializable()
class DepositByCardReq extends Object {
  @JsonKey(name: 'ccy')
  String ccy;

  @JsonKey(name: 'ciNo')
  String ciNo;

  @JsonKey(name: 'userId')
  String userId;

  DepositByCardReq(
    this.ccy,
    this.ciNo,
    this.userId,
  );

  factory DepositByCardReq.fromJson(Map<String, dynamic> srcJson) =>
      _$DepositByCardReqFromJson(srcJson);
  Map<String, dynamic> toJson() => _$DepositByCardReqToJson(this);
}

@JsonSerializable()
class DepositByCardResp extends Object {
  @JsonKey(name: 'totalAmt')
  String totalAmt;

  @JsonKey(name: 'totalContractAmtDTOList')
  List<TotalContractAmtDTOList> totalContractAmtDTOList;

  DepositByCardResp(
    this.totalAmt,
    this.totalContractAmtDTOList,
  );

  factory DepositByCardResp.fromJson(Map<String, dynamic> srcJson) =>
      _$DepositByCardRespFromJson(srcJson);

  Map<String, dynamic> toJson() => _$DepositByCardRespToJson(this);
}

@JsonSerializable()
class TotalContractAmtDTOList extends Object {
  @JsonKey(name: 'acNo')
  String acNo;

  @JsonKey(name: 'totalContractAmt')
  String totalContractAmt;

  TotalContractAmtDTOList(
    this.acNo,
    this.totalContractAmt,
  );

  factory TotalContractAmtDTOList.fromJson(Map<String, dynamic> srcJson) =>
      _$TotalContractAmtDTOListFromJson(srcJson);

  Map<String, dynamic> toJson() => _$TotalContractAmtDTOListToJson(this);
}

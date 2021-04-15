/// Copyright (c) 2020 深圳高阳寰球科技有限公司
/// 外汇买卖
/// Author: CaiTM
/// Date: 2020-12-21

import 'package:json_annotation/json_annotation.dart';

part 'forex_trading.g.dart';

// 查询账户可用余额
@JsonSerializable()
class GetCardBalReq {
  @JsonKey(name: 'cardNo')
  String cardNo;

  GetCardBalReq({
    this.cardNo,
  });

  factory GetCardBalReq.fromJson(Map<String, dynamic> srcJson) =>
      _$GetCardBalReqFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GetCardBalReqToJson(this);
}

@JsonSerializable()
class GetCardBalResp {
  @JsonKey(name: 'cardNo')
  String cardNo;
  @JsonKey(name: 'sellCcy')
  String sellCcy;
  @JsonKey(name: 'totalAmt')
  String totalAmt;
  @JsonKey(name: 'cardListBal')
  List<CardListBal> cardListBal;

  GetCardBalResp(
    this.cardNo,
    this.sellCcy,
    this.totalAmt,
    this.cardListBal,
  );

  @override
  String toString() {
    return toJson().toString();
  }

  factory GetCardBalResp.fromJson(Map<String, dynamic> srcJson) =>
      _$GetCardBalRespFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GetCardBalRespToJson(this);
}

@JsonSerializable()
class CardListBal {
  @JsonKey(name: 'cardNo')
  String cardNo;
  @JsonKey(name: 'avaBal')
  String avaBal;
  @JsonKey(name: 'ccy')
  String ccy;
  @JsonKey(name: 'currBal')
  String currBal;
  @JsonKey(name: 'equAmt')
  String equAmt;

  CardListBal(
    this.cardNo,
    this.avaBal,
    this.ccy,
    this.currBal,
    this.equAmt,
  );

  @override
  String toString() {
    return toJson().toString();
  }

  factory CardListBal.fromJson(Map<String, dynamic> srcJson) =>
      _$CardListBalFromJson(srcJson);

  Map<String, dynamic> toJson() => _$CardListBalToJson(this);
}

//汇率计算
@JsonSerializable()
class TransferTrialReq {
  @JsonKey(name: 'opt')
  String opt;
  @JsonKey(name: 'buyCcy')
  String buyCcy;
  @JsonKey(name: 'sellCcy')
  String sellCcy;
  @JsonKey(name: 'buyAmount')
  String buyAmount;
  @JsonKey(name: 'sellAmount')
  String sellAmount;

  TransferTrialReq({
    this.opt,
    this.buyCcy,
    this.sellCcy,
    this.buyAmount,
    this.sellAmount,
  });

  factory TransferTrialReq.fromJson(Map<String, dynamic> srcJson) =>
      _$TransferTrialReqFromJson(srcJson);

  Map<String, dynamic> toJson() => _$TransferTrialReqToJson(this);
}

@JsonSerializable()
class TransferTrialResp {
  @JsonKey(name: 'optExRate')
  String optExRate;
  @JsonKey(name: 'optExAmt')
  String optExAmt;

  TransferTrialResp(
    this.optExRate,
    this.optExAmt,
  );

  @override
  String toString() {
    return toJson().toString();
  }

  factory TransferTrialResp.fromJson(Map<String, dynamic> srcJson) =>
      _$TransferTrialRespFromJson(srcJson);

  Map<String, dynamic> toJson() => _$TransferTrialRespToJson(this);
}

//外汇买卖
@JsonSerializable()
class DoTransferAccoutReq {
  @JsonKey(name: 'opt')
  String opt;
  @JsonKey(name: 'creditCurrency')
  String creditCurrency;
  @JsonKey(name: 'debitCurrency')
  String debitCurrency;
  @JsonKey(name: 'payeeCardNo')
  String payeeCardNo;
  @JsonKey(name: 'payerCardNo')
  String payerCardNo;
  @JsonKey(name: 'payeeName')
  String payeeName;
  @JsonKey(name: 'payeeBankCode')
  String payeeBankCode;

  DoTransferAccoutReq(
    this.opt,
    this.creditCurrency,
    this.debitCurrency,
    this.payeeCardNo,
    this.payerCardNo,
    this.payeeName,
    this.payeeBankCode,
  );

  @override
  String toString() {
    return toJson().toString();
  }

  factory DoTransferAccoutReq.fromJson(Map<String, dynamic> srcJson) =>
      _$DoTransferAccoutReqFromJson(srcJson);

  Map<String, dynamic> toJson() => _$DoTransferAccoutReqToJson(this);
}

@JsonSerializable()
class DoTransferAccoutResp {
  DoTransferAccoutResp();

  factory DoTransferAccoutResp.fromJson(Map<String, dynamic> srcJson) =>
      _$DoTransferAccoutRespFromJson(srcJson);

  Map<String, dynamic> toJson() => _$DoTransferAccoutRespToJson(this);
}

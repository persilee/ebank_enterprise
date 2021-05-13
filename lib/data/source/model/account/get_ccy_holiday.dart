import 'package:json_annotation/json_annotation.dart';

part 'get_ccy_holiday.g.dart';

@JsonSerializable()
class GetCcyHolidayReq extends Object {
  @JsonKey(name: 'ccy')
  String ccy;

  @JsonKey(name: 'date')
  String date;

  GetCcyHolidayReq(
    this.ccy,
    this.date,
  );

  factory GetCcyHolidayReq.fromJson(Map<String, dynamic> srcJson) =>
      _$GetCcyHolidayReqFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GetCcyHolidayReqToJson(this);
}

@JsonSerializable()
class GetCcyHolidayResp extends Object {
  @JsonKey(name: 'holidayFlg')
  String holidayFlg;

  @JsonKey(name: 'nextWd')
  String nextWd;

  GetCcyHolidayResp(
    this.holidayFlg,
    this.nextWd,
  );

  factory GetCcyHolidayResp.fromJson(Map<String, dynamic> srcJson) =>
      _$GetCcyHolidayRespFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GetCcyHolidayRespToJson(this);
}

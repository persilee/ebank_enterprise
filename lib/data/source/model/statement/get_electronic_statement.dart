import 'package:json_annotation/json_annotation.dart';
part 'get_electronic_statement.g.dart';

@JsonSerializable()
class GetFilePathReq {
  @JsonKey(name: 'filePath')
  String filePath;

  GetFilePathReq({
    this.filePath = 'kont/ebank/tmp_statement.pdf',
  });

  factory GetFilePathReq.fromJson(Map<String, dynamic> srcJson) =>
      _$GetFilePathReqFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GetFilePathReqToJson(this);
}

@JsonSerializable()
class GetFilePathResp extends Object {
  @JsonKey(name: 'filePath')
  String filePath;

  GetFilePathResp(
    this.filePath,
  );

  factory GetFilePathResp.fromJson(Map<String, dynamic> srcJson) =>
      _$GetFilePathRespFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GetFilePathRespToJson(this);
}

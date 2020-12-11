import 'package:json_annotation/json_annotation.dart';
part 'get_electronic_statement.g.dart';

@JsonSerializable()
class GetFilePathReq {
  @JsonKey(name: 'filePath')
  String filePath;
}

@JsonSerializable()
class GetFilePathResp extends Object {
  @JsonKey(name: 'filePath')
  String filePath;

  GetFilePathResp({
    this.filePath = 'kont/ebank/tmp_statement.pdf',
  });

  factory GetFilePathResp.fromJson(Map<String, dynamic> srcJson) =>
      _$GetFilePathRespFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GetFilePathRespToJson(this);
}

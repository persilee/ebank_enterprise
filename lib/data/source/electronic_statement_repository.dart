import 'package:ebank_mobile/http/hsg_http.dart';
import 'model/get_electronic_statement.dart';

class RlectronicStatementRepository {
  Future<GetFilePathResp> getFilePath(GetFilePathReq req, String tag) {
    return request('cust/minio/getFilePath', req, tag,
        (data) => GetFilePathResp.fromJson(data));
  }

  static final _instance = RlectronicStatementRepository._internal();
  factory RlectronicStatementRepository() => _instance;

  RlectronicStatementRepository._internal();
}

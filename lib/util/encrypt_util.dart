import 'package:encrypt/encrypt.dart';

class EncryptUtil {
  static const String kKeyStringAES = "A-16-Byte-keyVal";
  static const String kIVStringAES = "A-16-Byte-String";

  //aes加密
  static String aesEncode(String content) {
    try {
      final key = Key.fromUtf8(kKeyStringAES);
      final iv = IV.fromUtf8(kIVStringAES);

      final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
      final encrypted = encrypter.encrypt('123456', iv: iv);

      return encrypted.base64;
    } catch (err) {
      print("aes encode error:$err");
      return content;
    }
  }

  //aes解密
  static String aesDecode(String content) {
    try {
      final key = Key.fromUtf8(kKeyStringAES);
      final iv = IV.fromUtf8(kIVStringAES);

      final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
      final decrypted = encrypter.decrypt64(content, iv: iv);

      return decrypted;
    } catch (err) {
      print("aes decode error:$err");
      return content;
    }
  }
}

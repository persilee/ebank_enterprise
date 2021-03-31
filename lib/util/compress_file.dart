// // 1. compress file and get Uint8List
//   import 'dart:io';
// import 'dart:typed_data';

// Future<Uint8List> testCompressFile(File file) async {
//     var result = await FlutterImageCompress.compressWithFile(
//       file.absolute.path,
//       minWidth: 2300,
//       minHeight: 1500,
//       quality: 94,
//       rotate: 90,
//     );
//     print(file.lengthSync());
//     print(result.length);
//     return result;
//   }

//   // 2. compress file and get file.
//   Future<File> testCompressAndGetFile(File file, String targetPath) async {
//     var result = await FlutterImageCompress.compressAndGetFile(
//         file.absolute.path, targetPath,
//         quality: 88,
//         rotate: 180,
//       );

//     print(file.lengthSync());
//     print(result.lengthSync());

//     return result;
//   }

//   // 3. compress asset and get Uint8List.
//   Future<Uint8List> testCompressAsset(String assetName) async {
//     var list = await FlutterImageCompress.compressAssetImage(
//       assetName,
//       minHeight: 1920,
//       minWidth: 1080,
//       quality: 96,
//       rotate: 180,
//     );

//     return list;
//   }

//   // 4. compress Uint8List and get another Uint8List.
//   Future<Uint8List> testComporessList(Uint8List list) async {
//     var result = await FlutterImageCompress.compressWithList(
//       list,
//       minHeight: 1920,
//       minWidth: 1080,
//       quality: 96,
//       rotate: 135,
//     );
//     print(list.length);
//     print(result.length);
//     return result;
//   }
// ————————————————
// 版权声明：本文为CSDN博主「xudailong_blog」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
// 原文链接：https://blog.csdn.net/xudailong_blog/article/details/110357419

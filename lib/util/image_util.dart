

import 'dart:typed_data';
import 'dart:ui';
import 'dart:io';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_editor/image_editor.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

Future<File> cropImageDataWithNativeLibrary(
    {ExtendedImageEditorState state}) async {
  print('native library start cropping');

  final Rect cropRect = state.getCropRect();
  final EditActionDetails action = state.editAction;

  final int rotateAngle = action.rotateAngle.toInt();
  final bool flipHorizontal = action.flipY;
  final bool flipVertical = action.flipX;
  final Uint8List img = state.rawImageData;

  final ImageEditorOption option = ImageEditorOption();

  if (action.needCrop) {
    option.addOption(ClipOption.fromRect(cropRect));
  }

  if (action.needFlip) {
    option.addOption(
        FlipOption(horizontal: flipHorizontal, vertical: flipVertical));
  }

  if (action.hasRotateAngle) {
    option.addOption(RotateOption(rotateAngle));
  }

  final DateTime start = DateTime.now();
  final File result = await ImageEditor.editImageAndGetFile(
    image: img,
    imageEditorOption: option,
  );

  print('${DateTime.now().difference(start)} ：total time');
  return result;
}

Future<bool> saveNetworkImageToPhoto(String url, {bool useCache = true}) async {
  if (kIsWeb) {
    return false;
  }
  final Uint8List data = await getNetworkImageData(url, useCache: useCache);
  final AssetEntity imageEntity = await PhotoManager.editor.saveImage(data);

  return imageEntity != null;
}

Future<Uint8List> pickImage(BuildContext context) async {
  List<AssetEntity> assets = <AssetEntity>[];
  final List<AssetEntity> result = await AssetPicker.pickAssets(
    context,
    maxAssets: 1,
    pathThumbSize: 84,
    gridCount: 3,
    pageSize: 300,
    selectedAssets: assets,
    requestType: RequestType.image,
    textDelegate: PickerTextDelegate(),
  );
  if (result != null) {
    assets = List<AssetEntity>.from(result);
    return assets.first.originBytes;
  }
  return null;
}

class ImageSaver {
  static Future<String> save(String name, Uint8List fileData) async {
    final AssetEntity imageEntity =
    await PhotoManager.editor.saveImage(fileData);
    final File file = await imageEntity.file;
    return file.path;
  }
}

class PickerTextDelegate implements AssetsPickerTextDelegate {
  factory PickerTextDelegate() => _instance;

  PickerTextDelegate._internal();

  static final PickerTextDelegate _instance = PickerTextDelegate._internal();

  @override
  String confirm = 'OK';

  @override
  String cancel = 'Cancel';

  @override
  String edit = 'Edit';

  @override
  String emptyPlaceHolder = 'empty';

  @override
  String gifIndicator = 'GIF';

  @override
  String heicNotSupported = 'not support HEIC yet';

  @override
  String loadFailed = 'load failed';

  @override
  String original = 'Original';

  @override
  String preview = 'Preview';

  @override
  String select = 'Select';

  @override
  String unSupportedAssetType = 'not support yet';

  @override
  String durationIndicatorBuilder(Duration duration) {
    const String separator = ':';
    final String minute = duration.inMinutes.toString().padLeft(2, '0');
    final String second =
    ((duration - Duration(minutes: duration.inMinutes)).inSeconds)
        .toString()
        .padLeft(2, '0');
    return '$minute$separator$second';
  }
}
import 'dart:typed_data';
import 'dart:io';

import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/http/retrofit/api/api_client.dart';
import 'package:ebank_mobile/http/retrofit/base_body.dart';
import 'package:ebank_mobile/util/image_util.dart';
import 'package:ebank_mobile/widget/custom_button.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ImageEditorPage extends StatefulWidget {
  final Uint8List imageData;

  const ImageEditorPage({Key key, this.imageData}) : super(key: key);

  @override
  _ImageEditorPageState createState() => _ImageEditorPageState();
}

class _ImageEditorPageState extends State<ImageEditorPage> {
  final GlobalKey<ExtendedImageEditorState> editorKey =
      GlobalKey<ExtendedImageEditorState>();
  ExtendedImageCropLayerCornerPainter _cornerPainter;
  bool _cropping = false;

  @override
  void initState() {
    _cornerPainter = const ExtendedImageCropLayerPainterNinetyDegreesCorner(
        color: Color(0xff3A9ED1), cornerSize: Size(26.0, 3.0));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: ExtendedImage.memory(
              widget.imageData,
              fit: BoxFit.contain,
              mode: ExtendedImageMode.editor,
              enableLoadState: true,
              extendedImageEditorKey: editorKey,
              colorBlendMode: BlendMode.color,
              initEditorConfigHandler: (ExtendedImageState state) {
                return EditorConfig(
                  maxScale: 8.0,
                  cropRectPadding: EdgeInsets.all(26.0),
                  hitTestSize: 20.0,
                  cornerPainter: _cornerPainter,
                  initCropRectType: InitCropRectType.layoutRect,
                  cropAspectRatio: CropAspectRatios.ratio1_1,
                  editorMaskColorHandler:
                      (BuildContext context, bool pointerDown) {
                    return pointerDown
                        ? Colors.white.withOpacity(0.36)
                        : Colors.black;
                  },
                );
              },
            ),
          ),
          Positioned(
            bottom: 16.0,
            left: 10.0,
            right: 6.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    S.current.cancel,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.rotate_right,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    editorKey.currentState.rotate(right: true);
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.rotate_left,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    editorKey.currentState.rotate(right: false);
                  },
                ),
                CustomButton(
                  height: 32.0,
                  text: Text(
                    S.current.confirm,
                    style: TextStyle(color: Colors.white, fontSize: 14.0),
                  ),
                  clickCallback: () => cropImage(),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<void> cropImage() async {
    if (_cropping) {
      return;
    }
    File file =
        await cropImageDataWithNativeLibrary(state: editorKey.currentState);
    Navigator.pop(context, file);
    _cropping = false;
  }
}

import 'dart:io';

import 'package:camera/camera.dart';
import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class CameraPage extends StatefulWidget {
  CameraPage({Key key}) : super(key: key);

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  List<CameraDescription> _cameras;
  CameraDescription _camera;
  CameraController _cameraController;
  Future<void> _initializeControllerFuture;

  @override
  void initState() {
    _getCameras();
    super.initState();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  Future<void> _getCameras() async {
    final cameras = await availableCameras();
    setState(() {
      _cameras = cameras;
      _camera = _cameras.length > 0 ? _cameras[0] : CameraDescription();
      _cameraController = CameraController(_camera, ResolutionPreset.medium);
      _initializeControllerFuture = _cameraController.initialize();
    });
  }

  Widget _getTipW() {
    return Center(
        child: Text(
      'No Cameras',
      style: TextStyle(
        color: HsgColors.firstDegreeText,
        fontSize: 15,
      ),
    ));
  }

  Widget _getCameraW(BuildContext context) {
    return Column(
      children: <Widget>[
        FutureBuilder<void>(
          future: _initializeControllerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              // If the Future is complete, display the preview.
              return Container(
                child: CameraPreview(_cameraController),
                width: 400,
                height: 300,
              );
            } else {
              // Otherwise, display a loading indicator.
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
        SizedBox(height: 30),
        RaisedButton(
          child: Icon(Icons.camera),
          onPressed: () async {
            try {
              await _initializeControllerFuture;
              final dateTime = DateTime.now();
              final path = join((await getApplicationDocumentsDirectory()).path,
                  '${dateTime.millisecondsSinceEpoch}.png');
              await _cameraController.takePicture();

              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => DisplayPictureScreen(imagePath: path),
              ));
              Scaffold.of(context).showSnackBar(SnackBar(content: Text(path)));
            } catch (err, stack) {
              print(err);
            }
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _cameras.length > 0 ? _getCameraW(context) : _getTipW(),
    );
  }
}

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;
  const DisplayPictureScreen({Key key, this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Picture'),
      ),
      body: Center(
        child: Image.file(File(imagePath)),
      ),
    );
  }
}

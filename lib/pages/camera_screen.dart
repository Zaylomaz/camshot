import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? controller;
  List<CameraDescription>? cameras;
  String? token;


  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    cameras = await availableCameras();
    if (cameras == null || cameras!.isEmpty) {
      print('No cameras available');
      return;
    }
    controller = CameraController(cameras![0], ResolutionPreset.max);
    await controller!.initialize();
    setState(() {});
  }

  Future<void> _takePictureAndUpload() async {
    if (controller == null || !controller!.value.isInitialized) {
      print('Camera not ready');
      return;
    }

    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${appDocDir.path}/Pictures';
    await Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/${DateTime.now().millisecondsSinceEpoch}.jpg';

    final XFile? picture = await controller!.takePicture();
    if (picture != null) {
      await picture.saveTo(filePath);
      print('Photo saved: $filePath');
      _uploadPhoto(filePath);
    } else {
      print('Error: Failed to capture image');
    }
  }
  Future<void> _uploadPhoto(String filePath) async {
    var file = File(filePath);
    if (!await file.exists()) {
      print('File not found at path: $filePath');
      return;
    }

    var uri = Uri.parse("http://dev.adsmap.kr.ua/api/v1/reports");
    var request = http.Request('POST', uri);
    request.headers.addAll({
      'Content-Type': 'multipart/form-data',
      'Authorization': 'Bearer $token'
    });

    var multipartFile = await http.MultipartFile.fromPath(
      'photo',
      filePath,
      contentType: MediaType('image', 'jpg'),
    );
    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        print('Uploaded!');
      } else {
        print('Failed to upload');
      }
    } catch (e) {
      print('Error uploading file: $e');
    }
  }


  Future<void> _uploadAllPhotos(String dirPath) async {
    var dir = Directory(dirPath);
    var files = dir.listSync().where((element) => element is File).cast<File>();

    for (var file in files) {
      await _uploadPhoto(file.path);
      if (await file.exists()) {
        await http.post(file as Uri, headers: {
          'Content-Type': 'multipart/form-data','Authorization': 'Bearer $token', 'encoding': 'Encoding.getByName(utf-8)'}, body: file.readAsBytesSync(),);
      }
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null || !controller!.value.isInitialized) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      body: Stack(
        children: [
          Expanded(child: CameraPreview(controller!)),
          Padding(
              padding: MediaQuery.of(context).padding,
              child: Container(
                  alignment: Alignment.bottomCenter,
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      side: BorderSide(width: 2, color: Colors.white)

                    ),
                    onPressed: _takePictureAndUpload,
                    child: Icon(Icons.camera_alt),
                  )))
        ],
      ),
    );
  }
}
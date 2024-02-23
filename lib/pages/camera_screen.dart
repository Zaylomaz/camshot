import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path_provider/path_provider.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? controller;
  List<CameraDescription>? cameras;
  IconData flashIcon = Icons.flash_on;
  IconData focusIcon = Icons.center_focus_weak;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    cameras = await availableCameras();
    if (cameras != null && cameras!.isNotEmpty) {
      controller = CameraController(cameras![0], ResolutionPreset.medium);
      controller!.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});
      });
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
      return Container();
    }
    return GestureDetector(
      onTapDown: (details) {
        if (controller != null && controller!.value.isInitialized) {
          controller!.lockCaptureOrientation();
          controller!.setFocusPoint(details.localPosition);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Take a Picture'),
        ),
        body: Stack(
          children: [
            CameraPreview(controller!),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.1),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    FloatingActionButton(
                      onPressed: _toggleFlash,
                      tooltip: 'Toggle Flash',
                      child: Icon(flashIcon),
                    ),
                    Container(
                      height: 90.0,
                      width: 90.0,
                      child: FloatingActionButton(
                        onPressed: () async {
                          await _captureImage();
                          await _uploadImages();
                        },
                        tooltip: 'Process Image',
                        child: Icon(Icons.camera, size: 32.0),
                      ),
                    ),
                    FloatingActionButton(
                      onPressed: _toggleAutoFocus,
                      tooltip: 'Toggle AutoFocus',
                      child: Icon(focusIcon),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<String> _captureImage() async {
    final image = await controller!.takePicture();
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/${DateTime.now()}.jpeg';
    final imageFile = File(path);
    // await imageFile.copy(path);
    await imageFile.writeAsBytes(await image.readAsBytes());
    return path;
  }

  Future<void> _uploadImage() async {
    final directory = await getApplicationDocumentsDirectory();
    final images = directory
        .listSync()
        .where((file) => file.path.endsWith('.jpeg'))
        .toList();

    for (var imageFile in images) {
      final imagePart = await http.MultipartFile.fromPath(
        'image',
        imageFile.path,
        contentType: MediaType('image', 'jpeg'),
      );
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('http://34.159.33.19:5005/upload'),
      );
      request.files.add(imagePart);
      final response = await request.send();
      if (response.statusCode == 200) {
        print('Image uploaded successfully');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Изображение успешно загружено'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );
      } else {
        print('Image upload failed with status: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ашипка'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

  void _toggleFlash() {
    if (controller == null || !controller!.value.isInitialized) {
      return;
    }

    final flashMode = controller!.value.flashMode;

    if (flashMode == FlashMode.off) {
      controller!.setFlashMode(FlashMode.torch);
      setState(() {
        flashIcon = Icons.highlight;
      });
    } else if (flashMode == FlashMode.torch) {
      controller!.setFlashMode(FlashMode.always);
      setState(() {
        flashIcon = Icons.flash_on;
      });
    } else {
      controller!.setFlashMode(FlashMode.off);
      setState(() {
        flashIcon = Icons.flash_off;
      });
    }
  }

  void _toggleAutoFocus() {
    if (controller == null || !controller!.value.isInitialized) {
      return;
    }
    final isAutoFocusOn = controller!.value.focusMode == FocusMode.auto;
    controller!.setFocusMode(isAutoFocusOn ? FocusMode.locked : FocusMode.auto);
    setState(() {
      focusIcon =
          isAutoFocusOn ? Icons.center_focus_strong : Icons.center_focus_weak;
    });
  }

  Future<void> _uploadImages() async {
    final directory = await getApplicationDocumentsDirectory();
    final images = directory
        .listSync()
        .where((file) => file.path.endsWith('.jpeg'))
        .toList();
    for (var imageFile in images) {
      final imagePart = await http.MultipartFile.fromPath(
        'image',
        imageFile.path,
        contentType: MediaType('image', 'jpeg'),
      );
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('http://192.168.3.66:5000/upload'),
      );
      request.files.add(imagePart);
      final response = await request.send();
      if (response.statusCode == 200) {
        print('Image uploaded successfully');
      } else {
        print('Image upload failed with status: ${response.statusCode}');
      }
    }
  }
}

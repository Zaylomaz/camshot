import 'dart:io';
import 'package:camera/camera.dart';
import 'package:camshot/utils/file_utils.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:camshot/utils/ws.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key}) : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? controller;
  List<CameraDescription>? cameras;
  IconData flashIcon = Icons.flash_on;
  IconData focusIcon = Icons.center_focus_weak;
  final WebSocketService wsService = WebSocketService(
      'ws://95.158.11.210:6666/upload_image');

  @override
  void initState() {
    super.initState();
    _initCamera();
    wsService.sendAllImages();
  }

  Future<void> _initCamera() async {
    cameras = await availableCameras();
    if (cameras == null || cameras!.isEmpty) {
      print('No cameras available');
      return;
    }

    controller = CameraController(cameras![0], ResolutionPreset.medium);
    controller!.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  Future<String> takePicture(CameraController cameraController) async {
    if (!cameraController.value.isInitialized) {
      throw Exception('Camera controller is not initialized');
    }

    final isCameraPermissionGranted = await Permission.camera.request().isGranted;
    if (!isCameraPermissionGranted) {
      throw Exception('Camera permission is not granted');
    }

    final isStoragePermissionGranted = await Permission.storage.request().isGranted;
    if (!isStoragePermissionGranted) {
      throw Exception('Storage permission is not granted');
    }

    final XFile tempFile = await cameraController.takePicture();
    final directory = await getExternalStorageDirectory();
    if (directory == null) {
      throw Exception('Could not get external storage directory');
    }

    final String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
    final String newPath = path.join(
      directory.path,
      'DCIM',
      'Images_to_send',
      fileName,
    );

    final Directory newDirectory = Directory(path.dirname(newPath));
    if (!await newDirectory.exists()) {
      await newDirectory.create(recursive: true);
    }

    await tempFile.saveTo(newPath);
    return newPath;
  }



  Future<String> _captureImage() async {
    try {
      final imagePath = await takePicture(_CameraScreenState().controller!);
      return imagePath;
      // Теперь imagePath содержит путь к изображению, которое можно отправить
      // Вызов wsService.sendAllImages() может произойти здесь, если он принимает imagePath
      // wsService.sendAllImages(imagePath);
    } catch (e) {
      // Обработка ошибок
      print(e);
      throw Exception('Error capturing image'); // Example of adding a throw statement
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
    });}


  @override
  Widget build(BuildContext context) {

    if (controller == null || !controller!.value.isInitialized) {
      return Container();
    }
    return GestureDetector(
      onTapDown: (details) {
        if (controller != null && controller!.value.isInitialized) {
          controller!.lockCaptureOrientation();
        }
      },

      child: Scaffold(
        appBar: AppBar(
          title:Text('Отправка изображений')
    ),
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height*0.7,
              width: MediaQuery.of(context).size.width,
              child: CameraPreview(controller!),), // Replace with CameraPreview(controller) to display camera preview
            Align(
              alignment: Alignment.bottomCenter,

              child: Padding(
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    FloatingActionButton(
                      onPressed: _toggleFlash,
                      tooltip: 'Toggle Flash',
                      child: Icon(flashIcon),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height*0.08,
                      width: MediaQuery.of(context).size.height*0.08,
                      child: FloatingActionButton(
                        onPressed: () async {
                          await _captureImage().then((value) => wsService.sendAllImages());
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
}
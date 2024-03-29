import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:camshot/utils/ws.dart';

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
  final WebSocketService wsService = WebSocketService('ws://95.158.11.210:6666/upload_image');

  @override
  void initState() {
    super.initState();
    _initCamera();
    wsService.connect();
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
      if (!controller!.value.isInitialized) {
        print('Failed to initialize camera');
        return;
      }
      setState(() {});
    }).catchError((e) {
      print('Error initializing camera: $e');
    });
  }

  Future<String> _captureImage() async {
    final image = await controller!.takePicture();
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/${DateTime.now()}.jpeg';
    final imageFile = File(path);
    await imageFile.writeAsBytes(await image.readAsBytes());
    return imageFile.path;
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
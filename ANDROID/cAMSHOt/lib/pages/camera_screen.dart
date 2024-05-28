import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:camshot/pages/profile_page.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? controller;
  List<CameraDescription>? cameras;
  String? token;
  Geolocator geolocator = Geolocator();
  bool _flashMode = false;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _uploadPhoto(String filePath) async {
    var file = File(filePath);
    if (!await file.exists()) {
      print('File not found: $filePath');
      return;
    }
    var uri = Uri.parse("https://dev.adsmap.kr.ua/api/v1/reports");
    var request = http.MultipartRequest('POST', uri);
    var position = await Geolocator.getCurrentPosition();
    request.fields['latitude'] = position.latitude.toString();
    request.fields['longitude'] = position.longitude.toString();
    request.fields['created_at'] = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
    request.files.add(await http.MultipartFile.fromPath('photo', filePath));
    request.headers.addAll({
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json; charset=UTF-8',
    });
    var response = await request.send();
      if (response.statusCode == 201) {
      Fluttertoast.showToast(
        msg: "Фото загружено.",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
    } else {
      Fluttertoast.showToast(
        msg: "Неизвестная ошибка при отправке отчета.",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }

    if (response.statusCode == 422) {
      showErrorToast(jsonDecode(await response.stream.bytesToString())['data']);
      print('__________________________________________________________________>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
      print(jsonDecode(await response.stream.bytesToString()));
    }
  }

  void showErrorToast(Map<String, dynamic> errorData) {
    List<String> errorMessages = [];

    errorData.forEach((key, value) {
      errorMessages.addAll(value.map<String>((error) => '$key: $error'));
    });
    String errorMessage = errorMessages.join('\n');

    Fluttertoast.showToast(
      msg: errorMessage.isNotEmpty
          ? errorMessage
          : "Неизвестная ошибка при отправке отчета.",
      toastLength: Toast.LENGTH_SHORT,
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
  }

  Future<void> _initCamera() async {
    token = await const FlutterSecureStorage().read(key:"authToken");
    print(token);
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
    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${appDocDir.path}/Pictures';
    await Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/${DateTime
        .now()
        .millisecondsSinceEpoch}.jpg';

    final XFile picture = await controller!.takePicture();
    await picture.saveTo(filePath);

    print('Photo saved: $filePath');
    try {
      await _uploadPhoto(filePath);
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Data sending failed",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
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
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
        appBar: AppBar(title: const Text('Камера'), actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage(userDataFuture: Future.value({'url': Uri.parse('https://dev.adsmap.kr.ua/api/auth/user')}))),
              );
            },
          ),
        ]),
        body: Stack(
            children: [
              Expanded(child: CameraPreview(controller!)),
              Padding(
                  padding: MediaQuery.of(context).padding,
                  child: Container(
                      alignment: Alignment.bottomCenter,
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            IconButton(
                                icon: Icon(_flashMode ? Icons.flash_on : Icons.flash_off),
                                onPressed: () {
                                  setState(() {
                                    _flashMode = !_flashMode;
                                  });
                                }),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.grey[40], backgroundColor: Colors.deepPurple, // use 'onPrimary' instead of 'foregroundColor'
                              ),
                              onPressed: _takePictureAndUpload,
                              child: const Icon(Icons.camera_alt),
                            ),
                          ])))
            ]));
  }
}
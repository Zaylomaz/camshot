import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:camshot/pages/profile_page.dart';
import 'dart:convert';
import 'package:camera/camera.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
    request.fields['created_at'] =
        DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
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
      print(
          '__________________________________________________________________>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
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
    token = await const FlutterSecureStorage().read(key: "authToken");
    print(token);
    cameras = await availableCameras();
    if (cameras == null || cameras!.isEmpty) {
      print('Нет доступа к камере');
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
    final String filePath =
        '$dirPath/${DateTime.now().millisecondsSinceEpoch}${Geolocator.getCurrentPosition.toString}.jpg';

    final XFile picture = await controller!.takePicture();
    await picture.saveTo(filePath);

    print('Photo saved: $filePath');
    try {
      await _uploadPhoto(filePath);
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Ошибка при отправке отчета.",
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
    _flashMode = false;
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null || !controller!.value.isInitialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
        body: Stack(children: [
      Container(
          child: CameraPreview(controller!),
          height: MediaQuery.of(context).size.height * 0.8),
      Positioned(
        left: MediaQuery.of(context).size.width *
            0.01, // Расстояние от левого края
        top: MediaQuery.of(context).size.height *
            0.02, // Расстояние от верхнего края
        child: IconButton(
            icon: Icon(_flashMode ? Icons.flash_on : Icons.flash_off),
            onPressed: _flashMode
                ? () {
                    controller!.setFlashMode(FlashMode.off);
                    setState(() {
                      _flashMode = false;
                    });
                  }
                : () {
                    controller!.setFlashMode(FlashMode.torch);
                    setState(() {
                      _flashMode = true;
                    });
                  }),
      ),
      Padding(
          padding: MediaQuery.of(context).padding,
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
              alignment: Alignment.bottomCenter,
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.deepPurple,
                ),
                onPressed: _takePictureAndUpload,
                child: const Icon(Icons.camera_alt),
              ),
            )
          ]))
    ]));
  }
// class CameraScreen extends StatefulWidget {
//   @override
//   _ReportScreenState createState() => _ReportScreenState();
// }
//
// class _ReportScreenState extends State<CameraScreen> {
//   final ImagePicker _picker = ImagePicker();
//   File? _image;
//   LocationData? _locationData;
//   final Location location = new Location();
//
//   Future<void> _getImageAndLocation() async {
//     final pickedFile = await _picker.pickImage(source: ImageSource.camera);
//     _locationData = await location.getLocation();
//
//     setState(() {
//       if (pickedFile != null) {
//         _image = File(pickedFile.path);
//       }
//     });
//   }
//
//   Future<void> _sendReport() async {
//     if (_image == null || _locationData == null) {
//       ScaffoldMessenger.of(context)
//           .showSnackBar(SnackBar(content: Text('All fields are required')));
//       return;
//     }
//
//     try {
//       var request = http.MultipartRequest(
//           'POST', Uri.parse('https://yourapi.com/api/v1/reports'))
//         ..fields['latitude'] = _locationData!.latitude.toString()
//         ..fields['longitude'] = _locationData!.longitude.toString()
//         ..fields['created_at'] = DateTime.now().toIso8601String()
//         ..files.add(await http.MultipartFile.fromPath('photo', _image!.path));
//
//       var response = await request.send();
//
//       if (response.statusCode == 201) {
//         ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('Report successfully uploaded')));
//       } else {
//         ScaffoldMessenger.of(context)
//             .showSnackBar(SnackBar(content: Text('Failed to upload report')));
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context)
//           .showSnackBar(SnackBar(content: Text('Error: $e')));
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Create Report'),
//       ),
//       body: Column(
//         children: <Widget>[
//           Container(
//             constraints: BoxConstraints(
//               maxHeight: MediaQuery.of(context).size.height / 2,
//               maxWidth: MediaQuery.of(context).size.width,
//             ),
//             child: _image != null ? Image.file(_image!) : Container(),
//           ),
//           ElevatedButton(
//             onPressed: _getImageAndLocation,
//             child: Text('Take Photo'),
//           ),
//           ElevatedButton(
//             onPressed: _sendReport,
//             child: Text('Send Report'),
//           ),
//         ],
//       ),
//     );
}

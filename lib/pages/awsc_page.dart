// import 'dart:async';
// import 'dart:core';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:camerawesome/camerawesome_plugin.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:media_store_plus/media_store_plus.dart';
//
// class CameraAwesome extends StatelessWidget {
//   const CameraAwesome({super.key, required Size Function(List<Size> availableSizes) selectDefaultSize, required bool testMode});
//
//   Future<void> addMetadataToFile(File file, Map<String, String> metadata) async {
//     // TODO: Implement the function that adds metadata to the file
//   }
//
//   Future<void> capturePhoto() async {
//     // Request necessary permissions
//     var status = await Permission.camera.status;
//     if (!status.isGranted) {
//       status = await Permission.camera.request();
//       if (!status.isGranted) {
//         return;
//       }
//     }
//     else{
//       print("Camera permission granted");
//     }
//     status = await Permission.storage.status;
//     if (!status.isGranted) {
//       status = await Permission.storage.request();
//       if (!status.isGranted) {
//         return;
//       }
//     }
//
//     // Set up the camera
//     final camera = CameraAwesome(
//       selectDefaultSize: (List<Size> availableSizes) => Size(1920, 1080),
//       testMode: false,
//     );
//     // Capture the photo
//     // TODO: Modify the capturePhoto method to return the photo data
//     var photoData1 = await camera.capturePhoto();
//     final photoData = await camera.capturePhoto();
//
//     // Get the directory to save the photo
//     final extDir = await getExternalStorageDirectory();
//     final testDir = await Directory('${extDir}/DCIM/Reports_to_Send').create(recursive: true);
//     // Save the photo to the directory
//     final file = File('${testDir}/${DateTime.now().millisecondsSinceEpoch}.jpg');
//     // await file.writeAsBytes(photoData);
//
//     // Add metadata to the photo
//     final googleUser = await GoogleSignIn().signIn();
//     if (googleUser != null) {
//       final metadata = {'location': 'placeholder', 'user_id': googleUser.id};
//       await addMetadataToFile(file, metadata);
//     }
//   }
//   @override
//   Widget build(BuildContext context) {
//
//     return const MaterialApp(
//       title: '',
//
//       home: CameraPage(),
//     );
//   }
// }
//
// Future<void> onMediaTap(event) async {
//   if (event.status == MediaCaptureStatus.capturing) {
//     if (event.isPicture && !event.isVideo) {
//       debugPrint('Capturing picture...');
//     } else if (!event.isPicture && event.isVideo) {
//       debugPrint('Capturing video...');
//     }
//   } else if (event.status == MediaCaptureStatus.success) {
//     event.captureRequest.when(
//       single: (single) {
//         if (event.isPicture && !event.isVideo) {
//           debugPrint('Picture saved: ${single.file?.path}');
//         } else if (!event.isPicture && event.isVideo) {
//           debugPrint('Video saved: ${single.file?.path}');
//         }
//       },
//       multiple: (multiple) {
//         multiple.fileBySensor.forEach((key, value) {
//           if (event.isPicture && !event.isVideo) {
//             debugPrint('Multiple pictures taken: $key ${value?.path}');
//           } else if (!event.isPicture && event.isVideo) {
//             debugPrint('Multiple videos taken: $key ${value?.path}');
//           }
//         });
//       },
//     );
//   } else if (event.status == MediaCaptureStatus.failure) {
//     if (event.isPicture && !event.isVideo) {
//       debugPrint('Failed to capture picture: ${event.exception}');
//     } else if (!event.isPicture && event.isVideo) {
//       debugPrint('Failed to capture video: ${event.exception}');
//     }
//   } else {
//     debugPrint('Unknown event: $event');
//   }
// }
//
//
// class CameraPage extends StatelessWidget {
//   const CameraPage({super.key});
//
//
//   @override
//   Widget build(BuildContext context) {
//     final camera = CameraAwesome(
//       selectDefaultSize: (List<Size> availableSizes) => Size(1920, 1080),
//       testMode: false,);
//
//     return Scaffold(
//       body: Container(
//         color: Colors.white,
//         child: Stack(
//           children: [
//             CameraAwesomeBuilder.custom(
//               saveConfig: SaveConfig.photoAndVideo(),
//               builder: (cameraState, previewSize) {
//                 // Return your UI (a Widget)
//                 return cameraState.when(
//                   onPreparingCamera: (state) =>
//                   const Center(child: CircularProgressIndicator()),
//                   onPhotoMode: (state) => Text('TakePhotoUI Placeholder'),
//                   onVideoMode: (state) => Text('RecordVideoUI Placeholder'),
//                   onVideoRecordingMode: (state) =>
//                       Text('RecordVideoUI Placeholder'),
//                 );
//               },
//             ),
//             Positioned(
//               bottom: 16.0,
//               right: 0,
//               left: 0,
//               child: FloatingActionButton(
//                   onPressed: () {
//                     camera.capturePhoto();
//                   },
//                   child: Icon(Icons.camera)
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
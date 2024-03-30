// import 'dart:ffi';
// import 'dart:io';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:image_picker/image_picker.dart';
//
// import '../pages/awsc_page.dart';
//
// Future<void> capturePhoto() async {
//   // Request necessary permissions
//   var status = await Permission.camera.status;
//   if (!status.isGranted) {
//     status = await Permission.camera.request();
//     if (!status.isGranted) {
//       return;
//     }
//   }
//   status = await Permission.storage.status;
//   if (!status.isGranted) {
//     status = await Permission.storage.request();
//     if (!status.isGranted) {
//       return;
//     }
//   }
//   Future<void> saveImage() async {
//     final picker = ImagePicker();
//     final pickedFile = await picker.pickImage(source: ImageSource.camera);
//
//     if (pickedFile != null) {
//       final File image = File(pickedFile.path);
//       final Directory directory = await getApplicationDocumentsDirectory();
//       final String path = directory?.path;
//       final File newImage = await image.copy('$path/image1.png');
//     } else {
//       print('No image selected.');
//     }
//   }
//   // Set up the camera
//   final camera = CameraAwesome(
//     testMode: false,
//     selectDefaultSize: (List<Size> availableSizes) => Size(1920, 1080),
//     onPermissionsResult: (bool result) {},
//     onCameraStarted: () {},
//     onOrientationChanged: (CameraOrientations orientation) {},
//   );
//
//   // Capture the photo
//   camera.capturePhoto();
//
//   // Get the directory to save the photo
//   final extDir = await getExternalStorageDirectory();
//   final testDir = await Directory('${extDir?.path}/DCIM/Reports_to_Send').create(recursive: true);
//
//   // Save the photo to the directory
//   final file = File('${testDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg');
//   // photoData is not used because capturePhoto() is a void method
//
//   // Add metadata to the photo
//   // This is a placeholder. You need to replace this with the actual implementation
//   // that adds the location and user_id to the photo's metadata.
//   final googleUser = await GoogleSignIn().signIn();
//   final metadata = {'location': 'placeholder', 'user_id': googleUser?.id};
//   // addMetadataToFile method needs to be defined or imported from a library
// }
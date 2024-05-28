// import 'package:flutter/material.dart';
// import 'package:camshot/components/app_bar.dart';
// import 'package:camshot/components/text_field.dart';
// import 'package:camshot/components/user_avatar.dart';
// import 'package:camshot/styles/app_colors.dart';
// import 'package:camshot/styles/app_text.dart';
//
//
// enum Gender {
//   male,
//   female,
//   other,
//   none,
// }
//
// class EditProfile extends StatefulWidget {
//   const EditProfile({super.key});
//
//   @override
//   State<EditProfile> createState() => _EditProfileState();
// }
//
// class _EditProfileState extends State<EditProfile> {
//   final firstnameController = TextEditingController();
//   final lastnameController = TextEditingController();
//   final phoneController = TextEditingController();
//   final locationController = TextEditingController();
//   final birthdayController = TextEditingController();
//   var gender = Gender.none;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: const ToolBar(title: 'Edit Profile'),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Column(children: [
//             Stack(
//               children: [
//                 const Padding(
//                   padding: EdgeInsets.all(8.0),
//                   child: Center(
//                     child: UserAvatar(
//                       imageUrl: _currentUser?.photoUrl ?? 'default_image_url',
//                       size: 50,
//                     ),
//                   ),
//                 ),
//                 Positioned(
//                     bottom: 0,
//                     right: 0,
//                     child: Container(
//                         padding: const EdgeInsets.all(3),
//                         decoration: const BoxDecoration(
//                             color: AppColors.primary,
//                             borderRadius: BorderRadius.all(Radius.circular(6))),
//                         child: const Icon(
//                           Icons.edit,
//                           size: 20,
//                           color: Colors.black,
//                         ))),
//               ],
//             ),
//             const SizedBox(
//               height: 50,
//             ),
//             AppTextField(
//               hint: 'First Name',
//               controllerName: firstnameController,
//             ),
//             const SizedBox(
//               height: 16,
//             ),
//             AppTextField(
//               hint: 'Last Name',
//               controllerName: lastnameController,
//             ),
//             const SizedBox(
//               height: 16,
//             ),
//             AppTextField(
//               hint: 'Phone Number',
//               controllerName: phoneController,
//             ),
//             const SizedBox(
//               height: 16,
//             ),
//             AppTextField(
//               hint: 'Location',
//               controllerName: locationController,
//             ),
//             const SizedBox(
//               height: 16,
//             ),
//             AppTextField(
//               hint: 'BirthDay',
//               controllerName: birthdayController,
//             ),
//             const SizedBox(
//               height: 16,
//             ),
//             Container(
//               padding: const EdgeInsets.only(left: 12, right: 12, top: 6),
//               decoration: BoxDecoration(
//                   color: AppColors.white,
//                   borderRadius: const BorderRadius.all(Radius.circular(12))),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "Gender",
//                     style: AppText.body1.copyWith(
//                       fontSize: 12,
//                     ),
//                   ),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: RadioListTile(
//                             title: const Text('Male'),
//                             value: Gender.male,
//                             visualDensity: const VisualDensity(
//                                 horizontal: VisualDensity.minimumDensity,
//                                 vertical: VisualDensity.minimumDensity),
//                             contentPadding: EdgeInsets.zero,
//                             groupValue: gender,
//                             onChanged: (value) {
//                               setState(() {
//                                 gender = Gender.male;
//                               });
//                             }),
//                       ),
//                       Expanded(
//                         child: RadioListTile(
//                             title: const Text("Female"),
//                             value: Gender.female,
//                             visualDensity: const VisualDensity(
//                                 horizontal: VisualDensity.minimumDensity,
//                                 vertical: VisualDensity.minimumDensity),
//                             contentPadding: EdgeInsets.zero,
//                             groupValue: gender,
//                             onChanged: (value) {
//                               setState(() {
//                                 gender = Gender.female;
//                               });
//                             }),
//                       ),
//                       Expanded(
//                         child: RadioListTile(
//                             title: const Text("Other"),
//                             value: Gender.other,
//                             visualDensity: const VisualDensity(
//                                 horizontal: VisualDensity.minimumDensity,
//                                 vertical: VisualDensity.minimumDensity),
//                             contentPadding: EdgeInsets.zero,
//                             groupValue: gender,
//                             onChanged: (value) {
//                               setState(() {
//                                 gender = Gender.other;
//                               });
//                             }),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             )
//           ]),
//         ),
//       ),
//     );
//   }
// }

import 'package:ads_hotmap/src/screens/profile_page_screen.dart';
import 'package:flutter/material.dart';
import 'package:ads_hotmap/src/screens/login_screen.dart';
import 'package:ads_hotmap/src/screens/camera_screen.dart';
import 'package:ads_hotmap/src/screens/registration_step_one.dart';
import 'package:ads_hotmap/src/screens/registration_step_two.dart';
import 'package:ads_hotmap/src/screens/confirmation_screen.dart';
import 'package:ads_hotmap/src/screens/faq_list_screen.dart';
import 'package:ads_hotmap/src/screens/faq_detail_screen.dart';
import 'package:ads_hotmap/src/models/user.dart';
import 'package:ads_hotmap/src/screens/main_screen.dart';
import 'package:ads_hotmap/src/screens/map_screen.dart';
import 'package:ads_hotmap/src/screens/register_screen.dart';

class AppRoutes {
  static final pages = {
    login: (context) => LoginPage(),
    camera: (context) => CameraScreen(),
    registerStepOne: (context) => RegistrationStepOne(),
    registerStepTwo: (context) => RegistrationStepTwo(
        user: ModalRoute.of(context)!.settings.arguments as User),
    confirmationScreen: (context) => ConfirmationScreen(),
    faqList: (context) => FAQListScreen(),
    main: (context) => MainScreen(),
    map: (context) => MapScreen(),
    profile: (context) => ProfilePageScreen(),
    // register: (context) => RegisterPage(),
  };
  static const String login = '/login';
  static const String camera = '/camera';
  static const String registerStepOne = '/registerStepOne';
  static const String registerStepTwo = '/registerStepTwo';
  static const String confirmationScreen = '/confirmationScreen';
  static const String faqList = '/faqList';
  static const String faqDetail = '/faqDetail';
  static const String profile = '/profile';
  static const String map = '/map';
  static const String main = '/main';
  static const String register = '/register';
}

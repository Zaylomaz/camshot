import 'package:camshot/pages/edit_profile.dart';
import 'package:camshot/pages/files_page.dart';
import 'package:camshot/pages/home_page.dart';
import 'package:camshot/pages/login_page.dart';
import 'package:camshot/pages/main_page.dart';
import 'package:camshot/pages/nearby_page.dart';
import 'package:camshot/pages/start_page.dart';
import 'package:camshot/pages/camera_screen.dart';
import 'package:camshot/pages/map.dart';
import 'package:camshot/pages/chat.dart';
import 'package:flutter/material.dart';
import 'package:camshot/pages/awsc_page.dart';
import 'package:camshot/pages/signUP_page.dart';
import 'package:camshot/pages/faq_page.dart';
import '../pages/signUP_page.dart';

class AppRoutes {
  static final pages = {
    login: (context) => const LoginPage(),
    home: (context) => HomePage(),
    main: (context) => MainPage(),
    // editProfile: (context) => const EditProfile(),
    nearbyPage: (context) => const NearbyPage(),
    startPage: (context) => const Start_Page(),
    camera: (context) => CameraScreen(),
    map: (context) => Map(),
    // chat: (context) => Chat(),
    files: (context) => FilesPage(),
    // awCam : (context) => CameraPage(),
    signUp: (context) => const SignUpPage(),
    faq: (context) => FaqPage(),

  };

  static const login = '/';
  static const home = '/home';
  static const main = '/main';
  static const editProfile = '/edit_profile';
  static const nearbyPage = '/nearby';
  static const startPage = '/start';
  static const camera = '/camera';
  static const profile = '/profile';
  static const map = '/map';
  static const chat = '/chat';
  static const files = '/files';
  static const awCam = '/awCam';
  static const signUp = '/signUp';
  static const faq = '/faq';
}

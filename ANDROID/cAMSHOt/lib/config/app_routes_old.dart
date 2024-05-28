import 'package:camshot/pages/files_page.dart';
import 'package:camshot/pages/home_page.dart';
import 'package:camshot/pages/login_page.dart';
import 'package:camshot/pages/main_page.dart';
import 'package:camshot/pages/nearby_page.dart';
import 'package:camshot/pages/profile_page.dart';
import 'package:camshot/pages/start_page.dart';
import 'package:camshot/pages/camera_screen.dart';
import 'package:camshot/pages/map.dart';
import 'package:camshot/pages/register_page.dart';

class AppRoutes {
  static final pages = {
    login: (context) => const LoginPage(),
    home: (context) => const HomePage(),
    main: (context) => const MainPage(),
    editProfile: (context) => ProfilePage(userDataFuture: Future.value(null)),
    nearbyPage: (context) => const NearbyPage(),
    startPage: (context) => const Start_Page(),
    camera: (context) => const CameraScreen(), // Use CameraScreen as a class
    map: (context) => const Map(),
    files: (context) => const FilesPage(),
    register: (context) => const RegisterPage(),

    // faq: (context) => FaqPage(), // Commented out as FaqPage is not defined
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
  static const register = '/register';
  static const faq = '/faq'; // Commented out as FaqPage is not defined
}

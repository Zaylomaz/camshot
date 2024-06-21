import 'package:camshot/src/services/background_service.dart';
import 'package:flutter/material.dart';
import 'package:camshot/src/screens/camera_screen.dart';
import 'package:camshot/src/screens/faq_list_screen.dart';
import 'package:camshot/src/screens/profile_page_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:camshot/src/services/authentication_service.dart';
import 'package:camshot/src/screens/map_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  final List<Widget> _widgetOptions = [
    FAQListScreen(),
    CameraScreen(),
    MapScreen(),
  ];

  void _onItemTapped(int index) {
    _pageController.jumpToPage(index);
  }

  void navigatetoProfilePageScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProfilePageScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false, actions: <Widget>[
        IconButton(
          icon: Icon(Icons.arrow_upward),
          onPressed: () {
            BackgroundService.uploadPendingFiles();
          },
        ),
        IconButton(
          icon: Icon(Icons.person),
          style: ButtonStyle(
              iconSize: MaterialStateProperty.all<double>(30),
              padding: MaterialStateProperty.all<EdgeInsets>(
                  const EdgeInsets.all(10.0))),
          onPressed: navigatetoProfilePageScreen,
        ),
        IconButton(
          icon: Icon(Icons.logout),
          onPressed: () {
            Provider.of<AuthenticationService>(context, listen: false).logout();
            Navigator.pushReplacementNamed(context, '/login');
            GoogleSignIn().signOut();
          },
        ),
      ]),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: _widgetOptions,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.question_answer),
            label: 'FAQ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt),
            label: 'Camera',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Map',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.deepPurple,
        onTap: _onItemTapped,
      ),
    );
  }
}

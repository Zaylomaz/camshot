import 'package:camshot/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:camshot/src/screens/camera_screen.dart';
import 'package:camshot/pages/profile_page.dart'; // Corrected import statement
import 'package:camshot/src/screens/faq_list_screen.dart';
import 'package:camshot/src/screens/profile_page_screen.dart';
import 'package:provider/provider.dart';
import 'package:camshot/src/services/authentication_service.dart';
import 'package:camshot/src/screens/map_screen.dart';
import 'package:camshot/src/screens/profile_page_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  final List<Widget> _widgetOptions = [
    MapScreen(),
    CameraScreen(),
    FAQListScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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
          icon: Icon(Icons.account_circle),
          onPressed: () {
            navigatetoProfilePageScreen();
          },
        ),
        IconButton(
          icon: Icon(Icons.logout),
          onPressed: () {
            Provider.of<AuthenticationService>(context, listen: false).logout();
            Navigator.pushReplacementNamed(context, '/login');
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
            icon: Icon(Icons.map),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt),
            label: 'Camera',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.question_answer),
            label: 'FAQ',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}

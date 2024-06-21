import 'package:ads_hotmap/src/services/background_service.dart';
import 'package:flutter/material.dart';
import 'package:ads_hotmap/src/screens/camera_screen.dart';
import 'package:ads_hotmap/src/screens/faq_list_screen.dart';
import 'package:ads_hotmap/src/screens/profile_page_screen.dart';
import 'package:provider/provider.dart';
import 'package:ads_hotmap/src/services/authentication_service.dart';
import 'package:ads_hotmap/src/screens/map_screen.dart';
import 'package:permission_handler/permission_handler.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  final List<Widget> _widgetOptions = [
    FAQListScreen(),
    const CameraScreen(),
    MapScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
  }

  void _checkLocationPermission() async {
    var status = await Permission.location.status;
    if (status.isDenied) {
      _showLocationPermissionDialog();
    } else if (status.isGranted) {
      _startLocationUpdates();
    }
  }

  void _showLocationPermissionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Разрешение на использование данных о местоположении'),
          content: Text(
              'Приложению необходимо ваше разрешение для доступа к данным о местоположении для предоставления точных сервисов.'),
          actions: <Widget>[
            TextButton(
              child: Text('Отклонить'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Разрешить'),
              onPressed: () async {
                Navigator.of(context).pop();
                var status = await Permission.location.request();
                if (status.isGranted) {
                  _startLocationUpdates(); // Вызов логики работы с местоположением
                } else {
                  // Разрешение отклонено
                  // Показываем сообщение пользователю или выполняем другую логику
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _startLocationUpdates() {
    // Логика для обновления данных о местоположении
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
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfilePageScreen()),
            );
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
        onTap: (index) {
          _pageController.jumpToPage(index);
        },
      ),
    );
  }
}

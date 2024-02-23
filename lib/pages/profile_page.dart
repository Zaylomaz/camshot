import 'package:flutter/material.dart';
import 'package:camshot/components/app_bar.dart';
import 'package:camshot/components/user_avatar.dart';
import 'package:camshot/config/app_routes.dart';
import 'package:camshot/styles/app_text.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:location/location.dart';
import 'package:path/path.dart';

enum ProfileMenu { edit, logout }

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _currentUser;
  LocationData? _currentLocation;
  Location location = Location();

  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      setState(() {
        _currentUser = account;
      });
    });
    _googleSignIn.signInSilently();
    _getLocation();
  }

  Future<void> _getLocation() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _currentLocation = await location.getLocation();
  }

  void _handleSignOut() => _googleSignIn.disconnect();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          PopupMenuButton<ProfileMenu>(
            onSelected: (value) {
              switch (value) {
                case ProfileMenu.edit:
                  Navigator.of(context).pushNamed(AppRoutes.editProfile);
                  break;
                case ProfileMenu.logout:
                  _handleSignOut();
                  Navigator.of(context).pushNamed(AppRoutes.login);
                  break;
              }
            },
            itemBuilder: (context) {
              return [
                const PopupMenuItem(
                  value: ProfileMenu.edit,
                  child: Row(
                    children: [
                      Icon(Icons.edit),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: ProfileMenu.logout,
                  child: Row(
                    children: [
                      Icon(Icons.logout),
                    ],
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: UserAvatar(
              imageUrl: _currentUser?.photoUrl ?? 'default_image_url',
              size: 50,
            ),
          ),
          Center(
            child: Text(
              _currentUser?.email ?? 'Email',
              style: AppText.header1,
            ),
          ),
          Center(
            child: Text(_currentUser?.displayName ?? 'Username', style: AppText.header1),
          ),
          Center(
            child: Text(_currentUser?.id ?? 'ID', style: AppText.subtitle1),
          ),
          Center(
            child: Text(_currentLocation!= null
                ? _currentLocation!.latitude.toString() + ', ' + _currentLocation!.longitude.toString()
                : 'Location',
              style: AppText.subtitle1,
            ),
          ),
          // остальной код
        ],
      ),
    );
  }
}
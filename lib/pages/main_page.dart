import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:camshot/config/image_assets.dart';
import 'package:camshot/pages/home_page.dart';
import 'package:camshot/pages/profile_page.dart';
import 'package:camshot/components/bottom_navigation.dart';
import 'package:camshot/config/app_routes.dart';
import 'package:camshot/pages/map.dart';
import 'package:camshot/pages/chat.dart';


class MainPage extends StatefulWidget {
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Menus currentIndex = Menus.home;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: pages[currentIndex.index],
      bottomNavigationBar: MyButtonNavigation(
        currentIndex: currentIndex,
        onTap: (value) => setState(() => currentIndex = value),
      ),
    );
  }

  final pages = [
    HomePage(),
    const Map(),
    const Center(child: Text('Add Post')),
    const Chat(), // replace someClient with your StreamChatClient instance
    const ProfilePage(),
  ];
}

enum Menus { home, mapPage, add, chat, user, }

class MyButtonNavigation extends StatelessWidget {
  final Menus currentIndex;
  final ValueChanged<Menus> onTap;

  const MyButtonNavigation({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 85,
      margin: const EdgeInsets.all(24),
      child: Stack(
        children: [
          Positioned(
            right: 0, left: 0, top: 17,
            child: Container(
              height: 70,
              decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(25))),
              child: Row(children: [
                _buildNavItem(Menus.home, AppImages.ic_home),
                _buildNavItem(Menus.mapPage, AppImages.ic_map),
                const Spacer(),
                _buildNavItem(Menus.chat, AppImages.ic_messages),
                _buildNavItem(Menus.user, AppImages.ic_user),
              ]),
            ),
          ),
          Positioned(
            left: 0, right: 0, top: 0,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pushNamed(AppRoutes.camera),
              child: Container(
                padding: const EdgeInsets.all(16),
                width: 64, height: 64,
                decoration: const BoxDecoration(color: Colors.amber, shape: BoxShape.circle),
                child: SvgPicture.asset(
                  AppImages.ic_add,
                  colorFilter: ColorFilter.mode(currentIndex == Menus.add ? Colors.blue : Colors.black, BlendMode.srcIn),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildNavItem(Menus menu, String icon) {
    return Expanded(
      child: BottomNavigationItem(
        onPressed: () => onTap(menu),
        icon: icon,
        currentItem: currentIndex,
        name: menu,
      ),
    );
  }
}
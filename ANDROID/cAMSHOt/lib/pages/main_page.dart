import 'package:camshot/pages/camera_screen.dart';
import 'package:camshot/pages/faq_page.dart';
import 'package:flutter/material.dart';
import 'package:camshot/config/image_assets.dart';
import 'package:camshot/components/bottom_navigation.dart';
import 'package:camshot/config/app_routes_old.dart';
import 'package:camshot/pages/map.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Menus currentIndex = Menus.mapPage;

  final pageController = PageController();
  final pages = [
    const Map(),
    const CameraScreen(),
    const FaqPage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: PageView(
        controller: pageController,
        onPageChanged: (index) {
          setState(() {
            currentIndex = Menus.values[index];
          });
        },
        children: pages,
      ),
      bottomNavigationBar: MyButtonNavigation(
        currentIndex: currentIndex,
        onTap: (value) {
          pageController.jumpToPage(value.index);
          setState(() => currentIndex = value);
        },
      ),
    );
  }
}

enum Menus { mapPage, cam, faq }

class MyButtonNavigation extends StatelessWidget {
  final Menus currentIndex;

  final ValueChanged<Menus> onTap;

  const MyButtonNavigation(
      {super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    AppBar appBar = AppBar();
    double appBarHeight =
        MediaQuery.of(context).padding.top + appBar.preferredSize.height;
    double bottomPadding = MediaQuery.of(context).padding.bottom;
    double bottomBarHeight = 85 + bottomPadding;
    double bottomBarTop = MediaQuery.of(context).size.height - bottomBarHeight;
    double bottomBarWidth = MediaQuery.of(context).size.width;
    double bottomBarHeightWithPadding = bottomBarHeight + bottomPadding;

    Widget buildNavItem(Menus menu, String icon) {
      return Expanded(
        child: BottomNavigationItem(
          onPressed: () => onTap(menu),
          icon: icon,
          currentItem: currentIndex,
          name: menu,
        ),
      );
    }

    return SizedBox(
      height: 85,
      child: Stack(
        children: [
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.01,
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.05,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              child: Row(children: [
                buildNavItem(Menus.mapPage, AppImages.ic_map),
                buildNavItem(Menus.cam, AppImages.ic_add),
                buildNavItem(Menus.faq, AppImages.ic_question),
              ]),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pushNamed(AppRoutes.camera),
              child: Container(
                padding: const EdgeInsets.all(1),
                width: MediaQuery.of(context).size.width * 0.95,
                height: MediaQuery.of(context).size.height * 0.05,
              ),
            ),
          ),
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

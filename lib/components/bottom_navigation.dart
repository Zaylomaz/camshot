import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:camshot/pages/main_page.dart';

class BottomNavigationItem extends StatelessWidget {
  final Menus name;
  final Menus currentItem;
  final VoidCallback onPressed;
  final String icon;

  const BottomNavigationItem({
    required this.name,
    required this.currentItem,
    required this.onPressed,
    required this.icon
     });

  @override
  Widget build(BuildContext context) {
    final bool isSelected = name == currentItem;

    return GestureDetector(
      onTap: onPressed,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SvgPicture.asset(
            icon,
            color: isSelected ? Colors.deepPurple : Colors.black,
            width: MediaQuery.of(context).size.width * 0.05,
          ),
          Text(
            name.name,
            style: TextStyle(
              color: isSelected ? Colors.deepPurple : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
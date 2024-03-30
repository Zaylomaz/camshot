import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:camshot/pages/main_page.dart';

class BottomNavigationItem extends StatelessWidget {
  final Menus name;
  final Menus currentItem;
  final VoidCallback onPressed;
  final String icon;
  final bool isCenterItem; // новый параметр

  const BottomNavigationItem({
    required this.name,
    required this.currentItem,
    required this.onPressed,
    required this.icon,
    this.isCenterItem = false, // значение по умолчанию
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
            width: MediaQuery.of(context).size.width * 0.05, // изменяем размер для центрального элемента
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
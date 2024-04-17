import 'package:flutter/material.dart';
import 'package:camshot/styles/app_colors.dart';
import 'package:camshot/styles/app_text.dart';


class ToolBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  const ToolBar({super.key, required this.title, this.actions});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.background,
      centerTitle: false,
      title: Text(
        title,
        style: AppText.header2,
      ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(64);
}

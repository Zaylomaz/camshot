import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  final double size;
  final String imageUrl;

  const UserAvatar({super.key, this.size = 90, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(16)),
      child: Image.network(imageUrl, width: size, height: size),
    );
  }
}

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camshot/styles/app_text.dart';
import 'package:path/path.dart' as path;

class PostItem extends StatelessWidget {
  final File imageFile;
  const PostItem({super.key, required this.imageFile});

  @override
  Widget build(BuildContext context) {
    MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Center(
            child: Image.file(
              imageFile,
              width: MediaQuery.of(context).size.width * 0.8, // 80% of screen width
              height: MediaQuery.of(context).size.height * 0.4, // 40% of screen height
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Text(
            path.basename(imageFile.path),
            style: AppText.subtitle3,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
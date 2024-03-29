import 'package:flutter/material.dart';
import 'package:camshot/components/app_bar.dart';
import 'package:camshot/components/post_item.dart';
import 'package:camshot/config/app_routes.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';


class HomePage extends StatefulWidget {HomePage({super.key});
@override
_HomePageState createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  final List<File> users = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            return PostItem(
              imageFile: users[index],
            );
          },
        ),
      ),
    );
}
    Future<void> _refresh() async {
      users.clear();
      setState(() {});
    }
}
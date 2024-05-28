import 'package:flutter/material.dart';
import 'package:camshot/components/post_item.dart';
import 'dart:io';


class HomePage extends StatefulWidget {const HomePage({super.key});
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
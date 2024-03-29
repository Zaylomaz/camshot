import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class FilesPage extends StatefulWidget {
  @override
  _FilesPageState createState() => _FilesPageState();
}

class _FilesPageState extends State<FilesPage> {
  late Future<List<FileSystemEntity>> _futureFiles;

  @override
  void initState() {
    super.initState();
    _futureFiles = _getFiles();
  }

  Future<List<FileSystemEntity>> _getFiles() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.listSync();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Files'),
      ),
      body: FutureBuilder<List<FileSystemEntity>>(
        future: _futureFiles,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final files = snapshot.data!;
            return ListView.builder(
              itemCount: files.length,
              itemBuilder: (context, index) {
                final file = files[index];
                return ListTile(
                  title: Text(file.path),
                  onTap: () => _openFile(file.path),
                );
              },
            );
          }
        },
      ),
    );
  }

  Future<void> _openFile(String path) async {
    final file = File(path);
    if (await file.exists()) {
      if (await canLaunch(path)) {
        await launch(path);
      } else {
        throw 'Could not launch $path';
      }
    } else {
      throw 'File does not exist at $path';
    }
  }
}
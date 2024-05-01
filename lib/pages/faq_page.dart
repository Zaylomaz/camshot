import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:camshot/services/api_service.dart';

class FaqPage extends StatefulWidget {
  @override
  _FaqPageState createState() => _FaqPageState();
}

class _FaqPageState extends State<FaqPage> {
  final ApiService apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("FAQ"),
      ),
      body: StreamBuilder<List<dynamic>>(
        stream: apiService.fetchFaqSections(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  var section = snapshot.data![index];
                  return ExpansionTile(
                    title: Text(section['title']),
                    children: [
                      StreamBuilder<String>(
                        stream: apiService.fetchFaqContent(section['id']).asBroadcastStream(),
                        builder: (context, detailSnapshot) {
                          if (detailSnapshot.connectionState == ConnectionState.done) {
                            if (detailSnapshot.hasData) {
                              return Container(
                                height: 200,
                                child: WebView(
                                  initialUrl: Uri.dataFromString(detailSnapshot.data!, mimeType: 'html').toString(),
                                  javascriptMode: JavascriptMode.unrestricted,
                                ),
                              );
                            } else if (detailSnapshot.hasError) {
                              return Text("Ошибка: ${detailSnapshot.error}");
                            }
                          }
                          return Center(child: CircularProgressIndicator());
                        },
                      )
                    ],
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Text("Ошибка: ${snapshot.error}");
            }
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
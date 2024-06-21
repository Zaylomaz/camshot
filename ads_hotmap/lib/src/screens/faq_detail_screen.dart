import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ads_hotmap/src/models/faq.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:ads_hotmap/src/services/faq_service.dart';

class FAQDetailScreen extends StatefulWidget {
  final int id;
  final String title;

  FAQDetailScreen({required this.id, required this.title});

  @override
  _FAQDetailScreenState createState() => _FAQDetailScreenState();
}

class _FAQDetailScreenState extends State<FAQDetailScreen> {
  final _faqService = FAQService(); // Add this line

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.title), // Use the title passed from the previous screen
      ),
      body: StreamBuilder<String>(
        stream: _faqService.fetchFaqContent(widget.id).asBroadcastStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(child: Text("An error occurred"));
            }
            if (snapshot.hasData) {
              return LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: WebView(
                      initialUrl: Uri.dataFromString(
                        snapshot.data!
                            .replaceAll('src="//www', 'src="https://www'),
                        mimeType: 'text/html',
                        encoding: Encoding.getByName('utf-8'),
                      ).toString(),
                      javascriptMode: JavascriptMode.unrestricted,
                      onWebViewCreated:
                          (WebViewController webViewController) {},
                      zoomEnabled: true,
                      gestureNavigationEnabled: true,
                      allowsInlineMediaPlayback: true,
                    ),
                  );
                },
              );
            }
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

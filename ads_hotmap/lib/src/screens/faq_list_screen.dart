import 'package:flutter/material.dart';
import 'package:ads_hotmap/src/models/faq.dart';
import 'package:ads_hotmap/src/services/faq_service.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:ads_hotmap/src/services/faq_service.dart';

class FAQListScreen extends StatefulWidget {
  @override
  _FAQListScreenState createState() => _FAQListScreenState();
}

class _FAQListScreenState extends State<FAQListScreen> {
  final FAQService faqService = FAQService();
  late Future<List<FAQ>> _faqs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Инструктаж"),
      ),
      body: StreamBuilder<List<dynamic>>(
        stream: faqService.fetchFaqSections(),
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
                        stream: faqService
                            .fetchFaqContent(section['id'])
                            .asBroadcastStream(),
                        builder: (context, detailSnapshot) {
                          if (detailSnapshot.connectionState ==
                              ConnectionState.done) {
                            if (detailSnapshot.hasData) {
                              return SizedBox(
                                height: 200,
                                child: WebView(
                                  initialUrl: Uri.dataFromString(
                                          detailSnapshot.data!,
                                          mimeType: 'text/html')
                                      .toString(),
                                  javascriptMode: JavascriptMode.unrestricted,
                                ),
                              );
                            } else if (detailSnapshot.hasError) {
                              return Text("Ошибка: ${detailSnapshot.error}");
                            }
                          }
                          return const Center(
                              child: CircularProgressIndicator());
                        },
                      ),
                    ],
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Text("Ошибка: ${snapshot.error}");
            }
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:camshot/src/models/faq.dart';
import 'package:camshot/src/services/faq_service.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

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
                      SizedBox(
                          height: 200,
                          child: StreamBuilder<String>(
                            stream: faqService
                                .fetchFaqContent(section['id'])
                                .asBroadcastStream(),
                            builder: (context, detailSnapshot) {
                              if (detailSnapshot.connectionState ==
                                  ConnectionState.done) {
                                if (detailSnapshot.hasData) {
                                  return InAppWebView(
                                    initialOptions: InAppWebViewGroupOptions(
                                      android: AndroidInAppWebViewOptions(),
                                    ),
                                    initialData: InAppWebViewInitialData(
                                        data: Uri.dataFromString(
                                                detailSnapshot.data!,
                                                mimeType: 'text/html')
                                            .toString()),
                                    // gestureRecognizers: {
                                    //   Factory<VerticalDragGestureRecognizer>(
                                    //       () => VerticalDragGestureRecognizer())
                                    // },
                                  );
                                } else if (detailSnapshot.hasError) {
                                  return Text(
                                      "Ошибка: ${detailSnapshot.error}");
                                }
                              }
                              return const Center(
                                  child: CircularProgressIndicator());
                            },
                          ))
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

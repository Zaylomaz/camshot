import 'package:flutter/material.dart';
import '../models/faq.dart';
import '../services/faq_service.dart';

class FAQDetailScreen extends StatefulWidget {
  final int id;

  FAQDetailScreen({required this.id});

  @override
  _FAQDetailScreenState createState() => _FAQDetailScreenState();
}

class _FAQDetailScreenState extends State<FAQDetailScreen> {
  final FAQService _faqService = FAQService();
  late Future<FAQ> _faqDetail;

  @override
  void initState() {
    super.initState();
    _faqDetail = _faqService.fetchFAQDetail(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("FAQ Detail")),
      body: FutureBuilder<FAQ>(
        future: _faqDetail,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(child: Text("An error occurred"));
            }
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(snapshot.data!.title,
                        style: Theme.of(context).textTheme.headline6),
                    SizedBox(height: 10),
                    Text(snapshot.data!.content ?? "No content available",
                        style: Theme.of(context).textTheme.bodyText1),
                  ],
                ),
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

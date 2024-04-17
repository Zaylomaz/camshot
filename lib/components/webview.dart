import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class UniversalWebView extends StatefulWidget {
  final String? html;
  final String? url;

  UniversalWebView(Future<String> faq, String s, {this.html, this.url});

  @override
  _UniversalWebViewState createState() => _UniversalWebViewState();
}

class _UniversalWebViewState extends State<UniversalWebView> {
  late WebViewController _controller;

  @override
  Widget build(BuildContext context) {
    return WebView(
      initialUrl: widget.url,
      onWebViewCreated: (WebViewController webViewController) {
        _controller = webViewController;
        if (widget.html != null) {
          _controller.loadUrl(Uri.dataFromString(widget.html!,
              mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
              .toString());
        }
      },
    );
  }
}
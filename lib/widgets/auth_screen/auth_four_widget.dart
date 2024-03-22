import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AuthFourWidget extends StatelessWidget {
  const AuthFourWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WebView Example'),
      ),
      body: WebViewWidget(
        
        controller: WebViewController(),
      )
    );
  }
}
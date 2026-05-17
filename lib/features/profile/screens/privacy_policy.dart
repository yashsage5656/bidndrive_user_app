import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PrivacyWebViewScreen extends StatefulWidget {
  const PrivacyWebViewScreen({super.key});

  @override
  State<PrivacyWebViewScreen> createState() => _PrivacyWebViewScreenState();
}

class _PrivacyWebViewScreenState extends State<PrivacyWebViewScreen> {
  late final WebViewController controller;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            setState(() => isLoading = true);
          },
          onPageFinished: (url) {
            setState(() => isLoading = false);
          },
        ),
      )
      ..loadRequest(Uri.parse("https://bidndrive.in/privacy"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Privacy Policy"),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: controller),

          if (isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class About extends StatefulWidget {
  const About({super.key});

  @override
  State<About> createState() => _About();
}

class _About extends State<About> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..loadRequest(
        Uri.parse('https://doc-hosting.flycricket.io/ligtas-about/a9ebbb5b-6864-4311-869d-109da1eadd6e/other'),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        title: Text("About Ligtas",
            style: Theme.of(context).textTheme.headlineSmall),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.chevron_left),
            color: Colors.black54),
      ),
      body: WebViewWidget(
        controller: controller,
      ),
    );
  }
}
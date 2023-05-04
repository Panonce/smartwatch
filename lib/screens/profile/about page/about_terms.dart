import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TandC extends StatefulWidget {
  const TandC({super.key});

  @override
  State<TandC> createState() => _TandC();
}

class _TandC extends State<TandC> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..loadRequest(
        Uri.parse('https://doc-hosting.flycricket.io/ligtas-terms-of-use/a7a0576a-dd25-4880-bdb8-d24110268d79/terms'),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        title: Text("Terms and Conditions",
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
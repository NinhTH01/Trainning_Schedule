import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:native_dialog/native_dialog.dart';

void main() {
  runApp(const MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _nativeDialogPlugin = NativeDialog();

  @override
  void initState() {
    super.initState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: Center(
        child: TextButton(
            onPressed: () {
              if (Platform.isAndroid) {
                _nativeDialogPlugin.showAchievementInAndroid(
                    context: context, totalDistance: 100);
              } else {
                _nativeDialogPlugin.showAchievementIniOS(
                    context: context, totalDistance: 100);
              }
            },
            child: const Text('Running on:')),
      ),
    );
  }
}

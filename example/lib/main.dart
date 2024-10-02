import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:volume_info/volume_info.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _volumeInfoPlugin = VolumeInfo();
  double _volumeSpaceTotalInGB = 0.0;
  double _volumeSpaceFreeInGB = 0.0;
  double _volumeSpaceUsedInGB = 0.0;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    double volumeSpaceTotalInGB;
    double volumeSpaceFreeInGB;
    double volumeSpaceUsedInGB;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      volumeSpaceTotalInGB =
          await _volumeInfoPlugin.getVolumeSpaceTotalInGB() ?? 0;
    } on PlatformException {
      volumeSpaceTotalInGB = -1;
    }

    try {
      volumeSpaceFreeInGB =
          await _volumeInfoPlugin.getVolumeSpaceFreeInGB() ?? 0;
    } on PlatformException {
      volumeSpaceFreeInGB = -1;
    }

    try {
      volumeSpaceUsedInGB =
          await _volumeInfoPlugin.getVolumeSpaceUsedInGB() ?? 0;
    } on PlatformException {
      volumeSpaceUsedInGB = -1;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _volumeSpaceTotalInGB = volumeSpaceTotalInGB;
      _volumeSpaceFreeInGB = volumeSpaceFreeInGB;
      _volumeSpaceUsedInGB = volumeSpaceUsedInGB;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin volume_info example app',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Center(
          child:
            Column(
              children: [
                Text('Storage: ${_volumeSpaceTotalInGB.toStringAsFixed(0)} GB\n',
                  style: TextStyle(
                    color: Colors.orangeAccent,
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                  ),),
                Text('Frei: ${_volumeSpaceFreeInGB.toStringAsFixed(0)} GB\n',
                  style: TextStyle(
                    color: Colors.orangeAccent,
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                  ),),
                Text('Belegt: ${_volumeSpaceUsedInGB.toStringAsFixed(0)} GB\n',
                  style: TextStyle(
                    color: Colors.orangeAccent,
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                  ),),
              ],
            )
        ),
      ),
    );
  }
}

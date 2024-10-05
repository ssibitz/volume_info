import 'dart:collection';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:volume_info/volume_info.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class VolumeSizes {
  double total = 0.0;
  double free = 0.0;
  double used = 0.0;
}

class _MyAppState extends State<MyApp> {
  late VolumeInfo _volumeInfoPlugin;
  late List<String>? _volumes;
  late HashMap<String, bool> _primaryvolumes;
  late HashMap<String, VolumeSizes> _volumesizes;

  bool _inited = false;

  @override
  void initState() {
    initPlatformState();
    super.initState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    _volumeInfoPlugin = VolumeInfo();
    Future<List<dynamic>?> futureOfList = _volumeInfoPlugin.getVolumesAbsolutePaths(true, true);
    _volumes = (await futureOfList)!.cast<String>();

    _primaryvolumes = HashMap<String, bool>();
    _volumesizes = HashMap<String, VolumeSizes>();
    for (var absolutePath in _volumes!) {
      var isPrimaryVolume = await _volumeInfoPlugin.isVolumePrimary(absolutePath);
      _primaryvolumes[absolutePath] = isPrimaryVolume!;
      var volumeSpaceInGB = await _volumeInfoPlugin.getVolumeSpaceInGB(absolutePath);

    }
    setState(() {
      _inited = true;
    });
  }

  Widget details()  {
    if (_inited == false) {
      return const Column(
        children: [
          Text(
            "Please wait..."
          )
        ],
      );
    }
    // Build a list of information
    List<Widget> children = [];
    for (var absolutePath in _volumes!) {
      children.add(
          Text("Volume: $absolutePath")
      );
      if (_primaryvolumes[absolutePath] == true) {
        children.add(
          const Text("Primary volume")
        );
      } else {
        children.add(
            const Text("Other volume")
        );
      }
      /*
      HashMap<String, double> volumeSpace = HashMap<String, double>();
      _volumeInfoPlugin.getVolumeSpaceInGB(absolutePath).then((data) {
        volumeSpace = data!;
      });
      children.add(
          Text("Total: ${volumeSpace['total']}")
      );
      children.add(
          Text("Free: ${volumeSpace['free']}")
      );
      children.add(
          Text("Used: ${volumeSpace['used']}")
      );
       */
      children.add(
          const Text("---------------------------------")
      );
    }
    var isVolumeAvailable = false;
    _volumeInfoPlugin.isVolumeAvailable("absolutePath").then((data) {
      isVolumeAvailable = data!;
    });
    if (isVolumeAvailable == true) {
      children.add(
          const Text("Special volume has been detected")
      );
    }
    return Column(
      children: children,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar:
          AppBar(
            title: const Text('Plugin volume_info example app',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
        ),
        body:
          Center(
            child: details(),
          ),
        ),
    );
  }
}

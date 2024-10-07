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
  VolumeSizes(double total, double free, double used) {
    this.total = total;
    this.free = free;
    this.used = used;
  }
}

class _MyAppState extends State<MyApp> {
  final VolumeInfo _volumeInfoPlugin = VolumeInfo();
  late List<String>? _volumes;
  late Map<String, bool> _primaryvolumes = Map<String, bool>();
  late Map<String, VolumeSizes> _volumesizes = Map<String, VolumeSizes>();
  bool _inited = false;

  @override
  void initState() {
    initPlatformState();
    super.initState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    _inited = false;
    await loadVolumes();
    setState(() {
      _inited = true;
    });
  }

  Future<List<String>?> loadVolumes() async {
    _volumesizes.clear();
    _primaryvolumes.clear();
    Future<List<dynamic>?> futureOfList = _volumeInfoPlugin.getVolumesAbsolutePaths(true, true);
    for (var absolutePath in _volumes!) {
      var isPrimaryVolume = await _volumeInfoPlugin.isVolumePrimary(absolutePath);
      _primaryvolumes[absolutePath] = isPrimaryVolume!;
      Map? volumeSpaceInGB = await _volumeInfoPlugin.getVolumeSpaceInGB(absolutePath);
      if (volumeSpaceInGB != null) {
        _volumesizes[absolutePath] = VolumeSizes
          (
          volumeSpaceInGB[SpaceTotal],
          volumeSpaceInGB[SpaceFree],
          volumeSpaceInGB[SpaceUsed],
        );
      }
    }
    _volumes = (await futureOfList)!.cast<String>();
    return _volumes;
  }

  Future<bool?> volumeExists(String absolutePath) async {
    return await _volumeInfoPlugin.isVolumeAvailable(absolutePath);
  }

  Widget check4Volume() {
    final String Volume2Check = "/storage/10F0-371C";
    return Column(
      children: [
        FutureBuilder(
          future: volumeExists(Volume2Check),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    '${snapshot.error} occurred',
                    style: TextStyle(fontSize: 18),
                  ),
                );
              } else if (snapshot.hasData) {
                final data = snapshot.data as bool;
                if (data == true) {
                  return Center(
                    child: Text(
                      "Volume is available",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.lightGreen
                      ),
                    ),
                  );
                } else {
                  return Center(
                    child: Text(
                      "Volume does not exist",
                      style: TextStyle(
                          fontSize: 20,
                        color: Colors.redAccent
                      ),
                    ),
                  );
                }
              }
            }
            // Displaying LoadingSpinner to indicate waiting state
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ],
    );
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
      VolumeSizes? volumeSize = _volumesizes[absolutePath];
      if (volumeSize != null) {
        children.add(
            Text("Total: ${volumeSize.total.round()} GB")
        );
        children.add(
            Text("Free: ${volumeSize.free.round()} GB")
        );
        children.add(
            Text("Used: ${volumeSize.used.round()} GB")
        );
      }
      children.add(
          const Text("---------------------------------")
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
            SingleChildScrollView(
              child: Column(
                children: <Widget> [
                  details(),
                  check4Volume(),
                ],
              ),
            ),
        ),
    );
  }
}

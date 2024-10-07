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

class VolumeInfoDetails {
  late bool isVolumePrimary;
  late bool isVolumeRemoveable;
  late String volumeState;
  late String volumeDirectory;
  late VolumeSpace volumeSpace;
  VolumeInfoDetails(bool isVolumePrimary, bool isVolumeRemoveable, String volumeState, String volumeDirectory, VolumeSpace volumeSpace) {
    this.isVolumePrimary = isVolumePrimary;
    this.isVolumeRemoveable = isVolumeRemoveable;
    this.volumeState = volumeState;
    this.volumeDirectory = volumeDirectory;
    this.volumeSpace = volumeSpace;
  }
}

class _MyAppState extends State<MyApp> {
  final VolumeInfo _volumeInfoPlugin = VolumeInfo();
  late final Map<String, VolumeInfoDetails> _volumesDetails = <String, VolumeInfoDetails>{};

  @override
  void initState() {
    loadVolumes();
    super.initState();
  }

  Future<void> loadVolumes() async {
    _volumesDetails.clear();
    List<String>? volumes = await _volumeInfoPlugin.getVolumesUUIDs(true, true);
    for (var uuid in volumes!) {
      bool isVolumePrimary = (await _volumeInfoPlugin.isVolumePrimary(uuid))!;
      bool isVolumeRemoveable = (await _volumeInfoPlugin.isRemoveable(uuid))!;
      String volumeState = (await _volumeInfoPlugin.getVolumeState(uuid))!;
      String volumeDirectory = (await _volumeInfoPlugin.getVolumeAbsolutePath(uuid))!;
      VolumeSpace volumeSpace = (await _volumeInfoPlugin.getVolumeSpaceInGB(uuid))!;
      // Store all information(s) into a map
      _volumesDetails[uuid] = VolumeInfoDetails(isVolumePrimary, isVolumeRemoveable, volumeState, volumeDirectory, volumeSpace);
    }
    setState(() {});
  }

  Future<bool?> volumeExists(String uuid) async {
    return await _volumeInfoPlugin.isVolumeAvailable(uuid);
  }

  Widget check4Volume() {
    if (_volumesDetails.isEmpty) {
      return const Column(
        children: [
          Text(
              "Detecting removeable volume..."
          )
        ],
      );
    }
    // Use first removeable volume for check
    String volume2Check = "";
    for (var uuid in _volumesDetails.keys) {
      if (_volumesDetails[uuid]!.isVolumeRemoveable) {
        volume2Check = uuid;
        break;
      }
    }
    return Column(
      children: [
        FutureBuilder(
          future: volumeExists(volume2Check),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    '${snapshot.error} occurred',
                    style: const TextStyle(fontSize: 18),
                  ),
                );
              } else if (snapshot.hasData) {
                final data = snapshot.data as bool;
                if (data == true) {
                  return const Center(
                    child: Text(
                      "Removeable volume is available",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.lightGreen
                      ),
                    ),
                  );
                } else {
                  return const Center(
                    child: Text(
                      "Removeable volume does not exist",
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
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ],
    );
  }

  Widget details()  {
    if (_volumesDetails.isEmpty) {
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
    for (var uuid in _volumesDetails.keys) {
      children.add(
          Text("Volumes UUID: $uuid")
      );
      children.add(
          Text("Path: ${_volumesDetails[uuid]!.volumeDirectory}")
      );
      children.add(
          Text("State: ${_volumesDetails[uuid]!.volumeState}")
      );
      if (_volumesDetails[uuid]!.isVolumePrimary == true) {
        children.add(
          const Text("Primary volume")
        );
      } else {
        children.add(
            const Text("Other volume")
        );
      }
      if (_volumesDetails[uuid]!.isVolumeRemoveable == true) {
        children.add(
            const Text("Removeable volume")
        );
      } else {
        children.add(
            const Text("Non removeable volume")
        );
      }
      VolumeSpace? volumeSpace = _volumesDetails[uuid]!.volumeSpace;
      children.add(
          Text("Total: ${volumeSpace.totalInGB.round()} GB")
      );
      children.add(
          Text("Free: ${volumeSpace.freeInGB.round()} GB")
      );
      children.add(
          Text("Used: ${volumeSpace.usedInGB.round()} GB")
      );
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

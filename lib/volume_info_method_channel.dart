import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:volume_info/volume_info.dart';
import 'volume_info_platform_interface.dart';

class VolumeSpaceType {
  static String get uuid => "uuid";
  static String get absolutePath => "absolutePath";
  static String get state => "state";
  static String get isAvailable => "isAvailable";
  static String get isRemoveable => "isRemoveable";
  static String get isPrimary => "isPrimary";
  static String get totalInGB => "total";
  static String get freeInGB => "free";
  static String get usedInGB => "used";
}

/// An implementation of [VolumeInfoPlatform] that uses method channels.
class MethodChannelVolumeInfo extends VolumeInfoPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('volume_info');

  @override
  Future<List<String>?> getVolumesUUIDs(bool includePrimary, bool includeRemoveable) async {
    List<dynamic>? futureOfList = await methodChannel.invokeMethod<List<dynamic>?>(
        'getVolumesUUIDs',  {'includePrimary': includePrimary, 'includeRemoveable': includeRemoveable}
    );
    return (futureOfList)!.cast<String>();
  }

  @override
  Future<bool?> isVolumeAvailable(String uuid) async {
    return await methodChannel.invokeMethod<bool?>(
        'isVolumeAvailable',  {'uuid': uuid}
    );
  }

  @override
  Future<bool?> isVolumePrimary(String uuid) async {
    return await methodChannel.invokeMethod<bool?>(
        'isVolumePrimary',  {'uuid': uuid}
    );
  }

  @override
  Future<bool?> isRemoveable(String uuid) async {
    return await methodChannel.invokeMethod<bool?>(
        'isRemoveable',  {'uuid': uuid}
    );
  }

  @override
  Future<String?> getVolumeState(String uuid) async {
    return await methodChannel.invokeMethod<String?>(
        'getVolumeState',  {'uuid': uuid}
    );
  }

  @override
  Future<String?> getVolumeAbsolutePath(String uuid) async {
    return await methodChannel.invokeMethod<String?>(
        'getVolumeAbsolutePath',  {'uuid': uuid}
    );
  }

  @override
  Future<VolumeSpace?> getVolumeSpace(String uuid) async {
    Map? volumeSpace = await methodChannel.invokeMethod<Map<dynamic, dynamic>?>(
        'getVolumeSpace',  {'uuid': uuid}
    );
    return _getVolumeSpaceFromMap(volumeSpace);
  }

  @override
  Future<VolumeSpace?> getVolumeSpacePrimary() async {
    Map? volumeSpace = await methodChannel.invokeMethod<Map<dynamic, dynamic>?>(
        'getVolumeSpacePrimary'
    );
    return _getVolumeSpaceFromMap(volumeSpace);
  }

  @override
  Future<String?> getVolumeAbsolutePathPrimary() async {
    return await methodChannel.invokeMethod<String?>(
        'getVolumeAbsolutePathPrimary'
    );
  }

  @override
  Future<String?> getVolumeUUIDPrimary() async {
    return await methodChannel.invokeMethod<String?>(
        'getVolumeUUIDPrimary'
    );
  }

  VolumeSpace? _getVolumeSpaceFromMap(Map? volumeSpaceInGB) {
    // Advanced information
    String uuid = "";
    String absolutePath = "";
    String state = "";
    bool isAvailable = false;
    bool isRemoveable = false;
    bool isPrimary = false;
    // Volume space information
    double totalInGB = 0.0;
    double freeInGB = 0.0;
    double usedInGB = 0.0;
    // Get data from map
    if (volumeSpaceInGB != null) {
      if (volumeSpaceInGB.containsKey(VolumeSpaceType.uuid)) {
        uuid = volumeSpaceInGB[VolumeSpaceType.uuid];
      }
      if (volumeSpaceInGB.containsKey(VolumeSpaceType.absolutePath)) {
        absolutePath = volumeSpaceInGB[VolumeSpaceType.absolutePath];
      }
      if (volumeSpaceInGB.containsKey(VolumeSpaceType.state)) {
        state = volumeSpaceInGB[VolumeSpaceType.state];
      }
      if (volumeSpaceInGB.containsKey(VolumeSpaceType.isAvailable)) {
        isAvailable = (volumeSpaceInGB[VolumeSpaceType.isAvailable]).toString().toLowerCase() == "true";
      }
      if (volumeSpaceInGB.containsKey(VolumeSpaceType.isRemoveable)) {
        isRemoveable = (volumeSpaceInGB[VolumeSpaceType.isRemoveable]).toString().toLowerCase() == "true";
      }
      if (volumeSpaceInGB.containsKey(VolumeSpaceType.isPrimary)) {
        isPrimary = (volumeSpaceInGB[VolumeSpaceType.isPrimary]).toString().toLowerCase() == "true";
      }
      if (volumeSpaceInGB.containsKey(VolumeSpaceType.totalInGB)) {
        totalInGB = double.parse(volumeSpaceInGB[VolumeSpaceType.totalInGB].toString());
      }
      if (volumeSpaceInGB.containsKey(VolumeSpaceType.freeInGB)) {
        freeInGB = double.parse(volumeSpaceInGB[VolumeSpaceType.freeInGB].toString());
      }
      if (volumeSpaceInGB.containsKey(VolumeSpaceType.usedInGB)) {
        usedInGB = double.parse(volumeSpaceInGB[VolumeSpaceType.usedInGB].toString());
      }
    }
    // Assign volume space to result and calc percentage
    VolumeSpace? result = VolumeSpace(totalInGB, freeInGB, usedInGB);
    // Add advanced information
    result.uuid = uuid;
    result.absolutePath = absolutePath;
    result.state = state;
    result.isAvailable = isAvailable;
    result.isRemoveable = isRemoveable;
    result.isPrimary = isPrimary;
    return result;
  }
}

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
  Future<VolumeSpaceInfo?> getVolumeInfo(String uuid) async {
    Map? volumeInfo = await methodChannel.invokeMethod<Map<dynamic, dynamic>?>(
        'getVolumeInfo',  {'uuid': uuid}
    );
    return _getVolumeInfoFromMap(volumeInfo);
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

  // Advanced information
  VolumeSpaceInfo? _getVolumeInfoFromMap(Map? volumeSpaceInfoMap) {
    VolumeSpaceInfo? result = VolumeSpaceInfo();
    if (volumeSpaceInfoMap != null) {
      if (volumeSpaceInfoMap.containsKey(VolumeSpaceType.uuid)) {
        result.uuid = volumeSpaceInfoMap[VolumeSpaceType.uuid];
      }
      if (volumeSpaceInfoMap.containsKey(VolumeSpaceType.absolutePath)) {
        result.absolutePath = volumeSpaceInfoMap[VolumeSpaceType.absolutePath];
      }
      if (volumeSpaceInfoMap.containsKey(VolumeSpaceType.state)) {
        result.state = volumeSpaceInfoMap[VolumeSpaceType.state];
      }
      if (volumeSpaceInfoMap.containsKey(VolumeSpaceType.isAvailable)) {
        result.isAvailable = (volumeSpaceInfoMap[VolumeSpaceType.isAvailable]).toString().toLowerCase() == "true";
      }
      if (volumeSpaceInfoMap.containsKey(VolumeSpaceType.isRemoveable)) {
        result.isRemoveable = (volumeSpaceInfoMap[VolumeSpaceType.isRemoveable]).toString().toLowerCase() == "true";
      }
      if (volumeSpaceInfoMap.containsKey(VolumeSpaceType.isPrimary)) {
        result.isPrimary = (volumeSpaceInfoMap[VolumeSpaceType.isPrimary]).toString().toLowerCase() == "true";
      }
    }
    return result;
  }

  VolumeSpace? _getVolumeSpaceFromMap(Map? volumeSpaceMap) {
    VolumeSpace? result = VolumeSpace();
    // Get data from map
    if (volumeSpaceMap != null) {
      if (volumeSpaceMap.containsKey(VolumeSpaceType.freeInGB)) {
        result.freeInGB = double.parse(volumeSpaceMap[VolumeSpaceType.freeInGB].toString());
      }
      if (volumeSpaceMap.containsKey(VolumeSpaceType.usedInGB)) {
        result.usedInGB = double.parse(volumeSpaceMap[VolumeSpaceType.usedInGB].toString());
      }
      if (volumeSpaceMap.containsKey(VolumeSpaceType.totalInGB)) {
        result.totalInGB = double.parse(volumeSpaceMap[VolumeSpaceType.totalInGB].toString());
      }
    }
    // Assign volume space to result and calc percentage
    VolumeSpaceInfo? volumeSpaceInfo = _getVolumeInfoFromMap(volumeSpaceMap);
    if (volumeSpaceInfo != null) {
      result.volumeSpaceInfo = volumeSpaceInfo;
    }
    return result;
  }
}

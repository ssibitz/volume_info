import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:volume_info/volume_info.dart';
import 'volume_info_platform_interface.dart';

class VolumeSpaceType {
  static String get SpaceTotal => "total";
  static String get SpaceFree => "free";
  static String get SpaceUsed => "used";
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
  Future<VolumeSpace?> getVolumeSpaceInGB(String uuid) async {
    Map? volumeSpaceInGB = await methodChannel.invokeMethod<Map<dynamic, dynamic>?>(
        'getVolumeSpaceInGB',  {'uuid': uuid}
    );
    return _getVolumeSpaceFromMap(volumeSpaceInGB);
  }

  @override
  Future<VolumeSpace?> getVolumeSpacePrimary() async {
    Map? volumeSpaceInGB = await methodChannel.invokeMethod<Map<dynamic, dynamic>?>(
        'getVolumeSpacePrimary'
    );
    return _getVolumeSpaceFromMap(volumeSpaceInGB);
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
    VolumeSpace? result = VolumeSpace(0.0, 0.0, 0.0);
    if (volumeSpaceInGB != null) {
      if (volumeSpaceInGB.containsKey(VolumeSpaceType.SpaceTotal)) {
        result.totalInGB = volumeSpaceInGB[VolumeSpaceType.SpaceTotal];
      }
      if (volumeSpaceInGB.containsKey(VolumeSpaceType.SpaceFree)) {
        result.freeInGB = volumeSpaceInGB[VolumeSpaceType.SpaceFree];
      }
      if (volumeSpaceInGB.containsKey(VolumeSpaceType.SpaceUsed)) {
        result.usedInGB = volumeSpaceInGB[VolumeSpaceType.SpaceUsed];
      }
    }
    return result;
  }
}

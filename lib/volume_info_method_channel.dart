import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'volume_info_platform_interface.dart';

/// An implementation of [VolumeInfoPlatform] that uses method channels.
class MethodChannelVolumeInfo extends VolumeInfoPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('volume_info');

  @override
  Future<List<dynamic>?> getVolumesAbsolutePaths(bool includePrimary, bool includeRemoveable) async {
    return await methodChannel.invokeMethod<List<dynamic>?>(
        'getVolumesAbsolutePaths',  {'includePrimary': includePrimary, 'includeRemoveable': includeRemoveable,}
    );
  }

  @override
  Future<bool?> isVolumeAvailable(String absolutePath) async {
    return await methodChannel.invokeMethod<bool?>(
        'isVolumeAvailable',  {'absolutePath': absolutePath}
    );
  }

  @override
  Future<bool?> isVolumePrimary(String absolutePath) async {
    return await methodChannel.invokeMethod<bool?>(
        'isVolumePrimary',  {'absolutePath': absolutePath}
    );
  }

  @override
  Future<Map<dynamic, dynamic>?> getVolumeSpaceInGB(String absolutePath) async {
    return await methodChannel.invokeMethod<Map<dynamic, dynamic>?>(
        'getVolumeSpaceInGB',  {'absolutePath': absolutePath}
    );
  }

  @override
  Future<Map<dynamic, dynamic>?> getVolumeSpacePrimary() async {
    return await methodChannel.invokeMethod<Map<dynamic, dynamic>?>('getVolumeSpacePrimary');
  }
}

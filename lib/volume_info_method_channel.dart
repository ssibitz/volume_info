import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'volume_info_platform_interface.dart';

/// An implementation of [VolumeInfoPlatform] that uses method channels.
class MethodChannelVolumeInfo extends VolumeInfoPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('volume_info');

  @override
  Future<double?> getVolumeSpaceTotalInGB() async {
    return await methodChannel.invokeMethod<double>('getVolumeSpaceTotalInGB');
  }

  @override
  Future<double?> getVolumeSpaceFreeInGB() async {
    return await methodChannel.invokeMethod<double>('getVolumeSpaceFreeInGB');
  }

  @override
  Future<double?> getVolumeSpaceUsedInGB() async {
    return await methodChannel.invokeMethod<double>('getVolumeSpaceUsedInGB');
  }

  @override
  Future<double?> getVolumeSpaceExtTotalInGB() async {
    return await methodChannel.invokeMethod<double>('getVolumeSpaceExtTotalInGB');
  }

  @override
  Future<double?> getVolumeSpaceExtFreeInGB() async {
    return await methodChannel.invokeMethod<double>('getVolumeSpaceExtFreeInGB');
  }

  @override
  Future<double?> getVolumeSpaceExtUsedInGB() async {
    return await methodChannel.invokeMethod<double>('getVolumeSpaceExtUsedInGB');
  }


}

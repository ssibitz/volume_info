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
    final space = await methodChannel.invokeMethod<double>('getVolumeSpaceTotalInGB');
    return space;
  }

  @override
  Future<double?> getVolumeSpaceFreeInGB() async {
    final space = await methodChannel.invokeMethod<double>('getVolumeSpaceFreeInGB');
    return space;
  }

  @override
  Future<double?> getVolumeSpaceUsedInGB() async {
    final space = await methodChannel.invokeMethod<double>('getVolumeSpaceUsedInGB');
    return space;
  }

}

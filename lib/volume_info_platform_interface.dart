import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'volume_info_method_channel.dart';

abstract class VolumeInfoPlatform extends PlatformInterface {
  /// Constructs a VolumeInfoPlatform.
  VolumeInfoPlatform() : super(token: _token);

  static final Object _token = Object();

  static VolumeInfoPlatform _instance = MethodChannelVolumeInfo();

  /// The default instance of [VolumeInfoPlatform] to use.
  ///
  /// Defaults to [MethodChannelVolumeInfo].
  static VolumeInfoPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [VolumeInfoPlatform] when
  /// they register themselves.
  static set instance(VolumeInfoPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<double?> getVolumeSpaceTotalInGB() {
    throw UnimplementedError('getVolumeSpaceTotalInGB() has not been implemented.');
  }

  Future<double?> getVolumeSpaceFreeInGB() {
    throw UnimplementedError('getVolumeSpaceFreeInGB() has not been implemented.');
  }

  Future<double?> getVolumeSpaceUsedInGB() {
    throw UnimplementedError('getVolumeSpaceUsedInGB() has not been implemented.');
  }

}

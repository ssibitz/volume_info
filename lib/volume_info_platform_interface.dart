import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'volume_info_method_channel.dart';
import 'volume_info.dart';

abstract class VolumeInfoPlatform extends PlatformInterface {
  VolumeInfoPlatform() : super(token: _token);

  static final Object _token = Object();
  static VolumeInfoPlatform _instance = MethodChannelVolumeInfo();
  static VolumeInfoPlatform get instance => _instance;

  static set instance(VolumeInfoPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<List<String>?> getVolumesUUIDs(bool includePrimary, bool includeRemoveable) {
    throw UnimplementedError('getVolumesUUIDs() has not been implemented.');
  }

  Future<bool?> isVolumeAvailable(String uuid) {
    throw UnimplementedError('isVolumeAvailable() has not been implemented.');
  }

  Future<bool?> isVolumePrimary(String uuid) {
    throw UnimplementedError('isVolumePrimary() has not been implemented.');
  }

  Future<bool?> isRemoveable(String uuid) {
    throw UnimplementedError('isRemoveable() has not been implemented.');
  }

  Future<String?> getVolumeState(String uuid) {
    throw UnimplementedError('getVolumeState() has not been implemented.');
  }

  Future<String?> getVolumeAbsolutePath(String uuid) {
    throw UnimplementedError('getVolumeAbsolutePath() has not been implemented.');
  }

  Future<VolumeSpace?> getVolumeSpace(String uuid) {
    throw UnimplementedError('getVolumeSpace() has not been implemented.');
  }

  Future<VolumeSpace?> getVolumeSpacePrimary() {
    throw UnimplementedError('getVolumeSpacePrimary() has not been implemented.');
  }

  Future<String?> getVolumeAbsolutePathPrimary() {
    throw UnimplementedError('getVolumeAbsolutePathPrimary() has not been implemented.');
  }

  Future<String?> getVolumeUUIDPrimary() {
    throw UnimplementedError('getVolumeUUIDPrimary() has not been implemented.');
  }
}

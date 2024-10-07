import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'volume_info_method_channel.dart';

abstract class VolumeInfoPlatform extends PlatformInterface {
  VolumeInfoPlatform() : super(token: _token);

  static final Object _token = Object();
  static VolumeInfoPlatform _instance = MethodChannelVolumeInfo();
  static VolumeInfoPlatform get instance => _instance;

  static set instance(VolumeInfoPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<List<dynamic>?> getVolumesAbsolutePaths(bool includePrimary, bool includeRemoveable) {
    throw UnimplementedError('getVolumesAbsolutePaths() has not been implemented.');
  }

  Future<bool?> isVolumeAvailable(String absolutePath) {
    throw UnimplementedError('isVolumeAvailable() has not been implemented.');
  }

  Future<bool?> isVolumePrimary(String absolutePath) {
    throw UnimplementedError('isVolumePrimary() has not been implemented.');
  }

  Future<Map<dynamic, dynamic>?> getVolumeSpaceInGB(String absolutePath) {
    throw UnimplementedError('getVolumeSpaceInGB() has not been implemented.');
  }

  Future<Map<dynamic, dynamic>?> getVolumeSpacePrimary() {
    throw UnimplementedError('getVolumeSpacePrimary() has not been implemented.');
  }
}

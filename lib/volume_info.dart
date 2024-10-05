import 'volume_info_platform_interface.dart';
import 'dart:collection';

class VolumeInfo {
  Future<bool?> isVolumeAvailable(String absolutePath) {
    return VolumeInfoPlatform.instance.isVolumeAvailable(absolutePath);
  }

  Future<bool?> isVolumePrimary(String absolutePath) {
    return VolumeInfoPlatform.instance.isVolumePrimary(absolutePath);
  }

  Future<Map<dynamic, dynamic>?> getVolumeSpaceInGB(String absolutePath) {
    return VolumeInfoPlatform.instance.getVolumeSpaceInGB(absolutePath);
  }

  Future<List<dynamic>?> getVolumesAbsolutePaths(bool includePrimary, bool includeRemoveable) {
    return VolumeInfoPlatform.instance.getVolumesAbsolutePaths(includePrimary, includeRemoveable);
  }

  Future<Map<dynamic, dynamic>?> getVolumeSpacePrimary() {
    return VolumeInfoPlatform.instance.getVolumeSpacePrimary();
  }
}

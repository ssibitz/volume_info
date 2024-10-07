import 'volume_info_platform_interface.dart';

class VolumeSpace {
  late double totalInGB;
  late double freeInGB;
  late double usedInGB;
  VolumeSpace(double totalInGB, double freeInGB, double usedInGB) {
    this.totalInGB = totalInGB;
    this.freeInGB = freeInGB;
    this.usedInGB = usedInGB;
  }
}

class VolumeInfo {
  Future<List<String>?> getVolumesUUIDs(bool includePrimary, bool includeRemoveable) {
    return VolumeInfoPlatform.instance.getVolumesUUIDs(includePrimary, includeRemoveable);
  }

  Future<bool?> isVolumeAvailable(String uuid) {
    return VolumeInfoPlatform.instance.isVolumeAvailable(uuid);
  }

  Future<bool?> isVolumePrimary(String uuid) {
    return VolumeInfoPlatform.instance.isVolumePrimary(uuid);
  }

  Future<bool?> isRemoveable(String uuid) {
    return VolumeInfoPlatform.instance.isRemoveable(uuid);
  }

  Future<String?> getVolumeState(String uuid) {
    return VolumeInfoPlatform.instance.getVolumeState(uuid);
  }

  Future<String?> getVolumeAbsolutePath(String uuid) {
    return VolumeInfoPlatform.instance.getVolumeAbsolutePath(uuid);
  }

  Future<VolumeSpace?> getVolumeSpaceInGB(String uuid) {
    return VolumeInfoPlatform.instance.getVolumeSpaceInGB(uuid);
  }

  Future<VolumeSpace?> getVolumeSpacePrimary() {
    return VolumeInfoPlatform.instance.getVolumeSpacePrimary();
  }

  Future<String?> getVolumeAbsolutePathPrimary() {
    return VolumeInfoPlatform.instance.getVolumeAbsolutePathPrimary();
  }

  Future<String?> getVolumeUUIDPrimary() {
    return VolumeInfoPlatform.instance.getVolumeUUIDPrimary();
  }

}

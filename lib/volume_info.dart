import 'volume_info_platform_interface.dart';

class VolumeSpace {
  // Volume space information
  double totalInGB = 0.0;
  double freeInGB = 0.0;
  double usedInGB = 0.0;
  double freeInPercent = 0.0;
  double usedInPercent = 0.0;
  // Advanced information
  String uuid = "";
  String absolutePath = "";
  String state = "";
  bool isAvailable = false;
  bool isRemoveable = false;
  bool isPrimary = false;
  VolumeSpace(double totalInGB, double freeInGB, double usedInGB) {
    this.totalInGB = totalInGB;
    this.freeInGB = freeInGB;
    this.usedInGB = usedInGB;
    // Transform to percent
    if (this.totalInGB > 0.0) {
      this.usedInPercent = this.usedInGB / this.totalInGB;
      if (this.usedInPercent<0.0 || this.usedInPercent>1.0) {
        this.usedInPercent = 0.0;
      }
      this.freeInPercent = this.freeInGB / this.totalInGB;
      if (this.freeInPercent<0.0 || this.freeInPercent>1.0) {
        this.freeInPercent = 0.0;
      }
    }
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

  Future<VolumeSpace?> getVolumeSpace(String uuid) {
    return VolumeInfoPlatform.instance.getVolumeSpace(uuid);
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

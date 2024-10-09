import 'volume_info_platform_interface.dart';

// Advanced information
class VolumeSpaceInfo {
  String uuid = "";
  String absolutePath = "";
  String state = "";
  bool isAvailable = false;
  bool isRemoveable = false;
  bool isPrimary = false;
}

// Volume space information
class VolumeSpace extends VolumeSpaceInfo {
  double totalInGB = 0.0;
  double freeInGB = 0.0;
  double usedInGB = 0.0;
  double freeInPercent = 0.0;
  double usedInPercent = 0.0;
  VolumeSpace(this.totalInGB, this.freeInGB, this.usedInGB) {
    calcPercentages();
  }
  void calcPercentages() {
    if (totalInGB > 0.0) {
      usedInPercent = usedInGB / totalInGB;
      if (usedInPercent<0.0 || usedInPercent>1.0) {
        usedInPercent = 0.0;
      }
      freeInPercent = freeInGB / totalInGB;
      if (freeInPercent<0.0 || freeInPercent>1.0) {
        freeInPercent = 0.0;
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

  Future<VolumeSpaceInfo?> getVolumeInfo(String uuid) {
    return VolumeInfoPlatform.instance.getVolumeInfo(uuid);
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

import 'volume_info_platform_interface.dart';

// Advanced information
class VolumeSpaceInfo {
  String uuid;
  String absolutePath;
  String state;
  bool isAvailable;
  bool isRemoveable;
  bool isPrimary;
  bool hasMarker;
  VolumeSpaceInfo({this.uuid = "", this.absolutePath = "", this.state = "", this.isAvailable = false, this.isRemoveable = false, this.isPrimary = false, this.hasMarker = false});
}

// Volume space information
class VolumeSpace {
  double _freeInGB = 0.0;
  double _usedInGB = 0.0;
  double _totalInGB = 0.0;
  double freeInPercent = 0.0;
  double usedInPercent = 0.0;
  VolumeSpaceInfo volumeSpaceInfo = VolumeSpaceInfo();

  VolumeSpace({freeInGB = 0.0, usedInGB = 0.0, totalInGB = 0.0});

  double get totalInGB => _totalInGB;
  double get freeInGB => _freeInGB;
  double get usedInGB => _usedInGB;

  // Volume space info detail
  String get uuid => volumeSpaceInfo.uuid;
  String get absolutePath => volumeSpaceInfo.absolutePath;
  String get state => volumeSpaceInfo.state;
  bool get isAvailable => volumeSpaceInfo.isAvailable;
  bool get isRemoveable => volumeSpaceInfo.isRemoveable;
  bool get isPrimary => volumeSpaceInfo.isPrimary;
  bool get hasMarker => volumeSpaceInfo.hasMarker;

  set totalInGB(double value) {
    _totalInGB = value;
    _calcPercentages();
  }

  set freeInGB(double value) {
    _freeInGB = value;
    _calcPercentages();
  }

  set usedInGB(double value) {
    usedInGB = value;
    _calcPercentages();
  }

  void _calcPercentages() {
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

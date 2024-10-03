
import 'volume_info_platform_interface.dart';

class VolumeInfo {
  Future<double?> getVolumeSpaceTotalInGB() {
    return VolumeInfoPlatform.instance.getVolumeSpaceTotalInGB();
  }
  Future<double?> getVolumeSpaceFreeInGB() {
    return VolumeInfoPlatform.instance.getVolumeSpaceFreeInGB();
  }
  Future<double?> getVolumeSpaceUsedInGB() {
    return VolumeInfoPlatform.instance.getVolumeSpaceUsedInGB();
  }
  Future<double?> getVolumeSpaceExtTotalInGB() {
    return VolumeInfoPlatform.instance.getVolumeSpaceExtTotalInGB();
  }
  Future<double?> getVolumeSpaceExtFreeInGB() {
    return VolumeInfoPlatform.instance.getVolumeSpaceExtFreeInGB();
  }
  Future<double?> getVolumeSpaceExtUsedInGB() {
    return VolumeInfoPlatform.instance.getVolumeSpaceExtUsedInGB();
  }
}

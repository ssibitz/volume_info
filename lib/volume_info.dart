
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
}

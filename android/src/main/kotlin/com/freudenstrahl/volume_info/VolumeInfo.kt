import android.annotation.TargetApi
import android.app.usage.StorageStatsManager
import android.content.Context
import android.os.Build
import android.os.storage.StorageManager
import android.os.storage.StorageVolume
import kotlin.math.round

const val KiB = 1_024L
const val MiB = KiB * KiB
const val GiB = KiB * KiB * KiB

class VolumeInfo(var context: Context) {

    @TargetApi(Build.VERSION_CODES.R)
    public fun isVolumeAvailable(absolutePath: String): Boolean? {
        return this.getStorageVolumeByAbsolutePath(absolutePath) != null
    }

    @TargetApi(Build.VERSION_CODES.R)
    public fun isVolumePrimary(absolutePath: String): Boolean? {
        var result = false
        var storageVolume = this.getStorageVolumeByAbsolutePath(absolutePath)
        if (storageVolume != null) {
            result = storageVolume.isPrimary
        }
        return result
    }

    @TargetApi(Build.VERSION_CODES.R)
    public fun getVolumesAbsolutePaths(includePrimary: Boolean, includeRemoveable: Boolean):List<String>? {
        var result = mutableListOf<String>()
        for (storageVolume in this.getStorageVolumes()) {
            if ((!includePrimary && storageVolume.isPrimary) || (!includeRemoveable && storageVolume.isRemovable)) {
                continue
            }
            val dir = storageVolume.directory
            if (dir != null) {
                result.add(dir.getAbsolutePath())
            }
        }
        return result
    }

    @TargetApi(Build.VERSION_CODES.R)
    public fun getVolumeSpacePrimary(): MutableMap<String, Double>? {
        var result = getEmptyVolumeSpaceInGB()
        val volumes = getVolumesAbsolutePaths(true, false)
        if (volumes != null) {
            if (volumes.isNotEmpty()) {
                result = getVolumeSpaceInGB(volumes[0])!!
            }
        }
        return result
    }

    @TargetApi(Build.VERSION_CODES.R)
    public fun getVolumeSpaceInGB(absolutePath: String): MutableMap<String, Double>? {
        var result = getEmptyVolumeSpaceInGB()
        val storageVolume = this.getStorageVolumeByAbsolutePath(absolutePath)
        if (storageVolume != null) {
            var volumeSpaceTotal = 0.0
            var volumeSpaceFree = 0.0
            var volumeSpaceUsed = 0.0
            if (storageVolume.isPrimary) {
                val mStorageStatsManager = context.getSystemService(Context.STORAGE_STATS_SERVICE) as StorageStatsManager
                if (mStorageStatsManager != null) {
                    val totalSpace: Long = (mStorageStatsManager.getTotalBytes(StorageManager.UUID_DEFAULT) / 1_000_000_000) * GiB
                    val usedSpace: Long = totalSpace - mStorageStatsManager.getFreeBytes(StorageManager.UUID_DEFAULT)
                    volumeSpaceTotal = round(totalSpace.toDouble()/GiB.toDouble())
                    volumeSpaceFree = round(usedSpace.toDouble()/GiB.toDouble())
                    volumeSpaceUsed = round((totalSpace-usedSpace).toDouble()/GiB.toDouble())
                }
            } else {
                val dir = storageVolume.getDirectory()
                if (dir != null) {
                    volumeSpaceTotal = dir.totalSpace.toDouble() / GiB
                    volumeSpaceFree = dir.freeSpace.toDouble() / GiB
                    volumeSpaceUsed = volumeSpaceTotal - volumeSpaceFree
                }
            }
            result.put("total", volumeSpaceTotal)
            result.put("free", volumeSpaceFree)
            result.put("used", volumeSpaceUsed)
        }
        return result
    }

    private fun getEmptyVolumeSpaceInGB(): MutableMap<String, Double> {
        var result = mutableMapOf<String, Double>()
        result.put("total", 0.0)
        result.put("free", 0.0)
        result.put("used", 0.0)
        return result
    }

    @TargetApi(Build.VERSION_CODES.R)
    private fun getStorageVolumes():List<StorageVolume> {
        var result = mutableListOf<StorageVolume>()
        val mStorageManager = context.getSystemService(Context.STORAGE_SERVICE) as StorageManager
        if (mStorageManager != null) {
            result = mStorageManager.storageVolumes
        }
        return result
    }

    @TargetApi(Build.VERSION_CODES.R)
    private fun getStorageVolumeByAbsolutePath(absolutePath: String): StorageVolume? {
        var result: StorageVolume? = null;
        for (storageVolume in getStorageVolumes()) {
            val dir = storageVolume.getDirectory()
            if (dir != null) {
                val volumePath = dir.getAbsolutePath()
                if (volumePath == absolutePath) {
                    result = storageVolume
                    break
                }
            }
        }
        return result
    }
}
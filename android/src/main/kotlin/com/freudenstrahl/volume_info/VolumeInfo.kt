import android.annotation.SuppressLint
import kotlin.math.round
import android.content.Context
import android.app.usage.StorageStatsManager
import android.os.storage.StorageManager
import android.os.storage.StorageVolume

const val KiB = 1_024L
const val MiB = KiB * KiB
const val GiB = KiB * KiB * KiB

class VolumeInfo {

    private var volumeSpaceTotalPrimary: Double = 0.0
    private var volumeSpaceUsedPrimary: Double = 0.0
    private var volumeSpaceFreePrimary: Double = 0.0
    private var volumeSpaceTotalExternal: Double = 0.0
    private var volumeSpaceUsedExternal: Double = 0.0
    private var volumeSpaceFreeExternal: Double = 0.0

    constructor(context: Context) {
        getVolumeStorageStats(context)
    }

    @SuppressLint("NewApi")
    public fun getVolumeStorageStats(context: Context) {
        val uuid = StorageManager.UUID_DEFAULT
        val storageStatsManager = context.getSystemService(Context.STORAGE_STATS_SERVICE) as StorageStatsManager
        var totalSpace: Long = (storageStatsManager.getTotalBytes(uuid) / 1_000_000_000) * GiB
        var usedSpace: Long = totalSpace - storageStatsManager.getFreeBytes(uuid)
        // Calc space (Primary)
        volumeSpaceTotalPrimary = round(totalSpace.toDouble()/GiB.toDouble())
        volumeSpaceUsedPrimary = round(usedSpace.toDouble()/GiB.toDouble())
        volumeSpaceFreePrimary = round((totalSpace-usedSpace).toDouble()/GiB.toDouble())
        // Calc space (External)
        try {
            var totalSpace: Long = 0L
            var usedSpace: Long = 0L
            val mStorageManager = context.getSystemService(Context.STORAGE_SERVICE) as StorageManager
            val extDirs = context.getExternalFilesDirs(null)
            var found = false
            extDirs.forEach { file ->
                val storageVolume: StorageVolume? = mStorageManager.getStorageVolume(file)
                if (storageVolume != null) {
                    if (storageVolume.isPrimary == false) {
                        found = true
                        totalSpace = file.totalSpace
                        usedSpace = totalSpace - file.freeSpace
                    }
                }
            }
            if (found) {
                volumeSpaceTotalExternal = round(totalSpace.toDouble() / GiB.toDouble())
                volumeSpaceUsedExternal = round(usedSpace.toDouble() / GiB.toDouble())
                volumeSpaceFreeExternal = round((totalSpace - usedSpace).toDouble() / GiB.toDouble())
            } else {
                // No external storage found
                volumeSpaceTotalExternal = -1.0
                volumeSpaceUsedExternal = -1.0
                volumeSpaceFreeExternal = -1.0
            }
        } catch (e: Exception) {
            // Ignore
        }
    }

    public fun getVolumeSpaceTotalInGB():Double {
        return volumeSpaceTotalPrimary
    }

    public fun getVolumeSpaceFreeInGB():Double {
        return volumeSpaceFreePrimary
    }

    public fun getVolumeSpaceUsedInGB():Double {
        return volumeSpaceUsedPrimary
    }

    public fun getVolumeSpaceExtTotalInGB():Double {
        return volumeSpaceTotalExternal
    }

    public fun getVolumeSpaceExtFreeInGB():Double {
        return volumeSpaceFreeExternal
    }

    public fun getVolumeSpaceExtUsedInGB():Double {
        return volumeSpaceUsedExternal
    }


}
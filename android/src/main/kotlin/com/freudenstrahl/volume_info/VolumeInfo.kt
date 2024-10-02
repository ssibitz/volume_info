import kotlin.math.round
import android.content.Context
import android.os.storage.StorageManager
import android.app.usage.StorageStatsManager

const val KiB = 1_024L
const val MiB = KiB * KiB
const val GiB = KiB * KiB * KiB

class VolumeInfo {

    private var volumeSpaceTotal: Double = 0.0
    private var volumeSpaceFree: Double = 0.0
    private var volumeSpaceUsed: Double = 0.0

    constructor(context: Context) {
        getVolumeStorageStats(context)
    }

    public fun getVolumeStorageStats(context: Context) {
        val uuid = StorageManager.UUID_DEFAULT
        val storageStatsManager = context.getSystemService(Context.STORAGE_STATS_SERVICE) as StorageStatsManager
        var totalSpace: Long = (storageStatsManager.getTotalBytes(uuid) / 1_000_000_000) * GiB
        var usedSpace: Long = totalSpace - storageStatsManager.getFreeBytes(uuid)
        // Calc space
        volumeSpaceTotal = round(totalSpace.toDouble()/GiB.toDouble())
        volumeSpaceUsed = round(usedSpace.toDouble()/GiB.toDouble())
        volumeSpaceFree = round((totalSpace-usedSpace).toDouble()/GiB.toDouble())
    }

    public fun getVolumeSpaceTotalInGB():Double {
        return volumeSpaceTotal
    }

    public fun getVolumeSpaceFreeInGB():Double {
        return volumeSpaceFree
    }

    public fun getVolumeSpaceUsedInGB():Double {
        return volumeSpaceUsed
    }

}
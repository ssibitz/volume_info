import java.util.UUID
import java.util.Locale
import kotlin.math.round
import android.content.Context
import android.os.storage.StorageManager
import android.app.usage.StorageStatsManager

class VolumeInfo {

    private var volumeSpaceTotal: Double = 0.0
    private var volumeSpaceFree: Double = 0.0
    private var volumeSpaceUsed: Double = 0.0
    private lateinit var allVolumeNames: List<String>

    constructor(context: Context) {
        getVolumeStorageStats(context)
    }

    public fun getVolumeStorageStats(context: Context) {
        volumeSpaceTotal = 0.0
        volumeSpaceFree = 0.0
        volumeSpaceUsed = 0.0
        // Access storage manager to get information
        val storageManager = context.getSystemService(Context.STORAGE_SERVICE) as StorageManager
        val storageStatsManager = context.getSystemService(Context.STORAGE_STATS_SERVICE) as StorageStatsManager
        val storageVolumes = storageManager.storageVolumes
        var totalBytes = 0L
        var freeBytes = 0L
        for (volume in storageVolumes) {
            val uuid = volume.uuid?.let { UUID.fromString(it) } ?: StorageManager.UUID_DEFAULT
            totalBytes += storageStatsManager.getTotalBytes(uuid)
            freeBytes += storageStatsManager.getFreeBytes(uuid)
        }
        volumeSpaceTotal = round(totalBytes.toDouble() / 1000.0 / 1000.0 / 1000.0)
        volumeSpaceFree = round(freeBytes.toDouble() / 1000.0 / 1000.0 / 1000.0)
        volumeSpaceUsed = round(volumeSpaceTotal - volumeSpaceFree)
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
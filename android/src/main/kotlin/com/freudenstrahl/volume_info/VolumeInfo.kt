package com.freudenstrahl.volume_info

import android.app.usage.StorageStatsManager
import android.content.Context
import android.os.Environment
import android.os.storage.StorageManager
import android.os.storage.StorageVolume
import java.io.File
import kotlin.math.round

// Constants
const val KiB = 1_024L
const val GiB = KiB * KiB * KiB
// Volume space information
const val VolumeTotal = "total"
const val VolumeFree = "free"
const val VolumeUsed = "used"
// Advanced volume information
const val VolumeUUID = "uuid"
const val VolumeAbsolutePath = "absolutePath"
const val VolumeState = "state"
const val VolumeIsAvailable = "isAvailable"
const val VolumeIsRemoveable = "isRemoveable"
const val VolumeIsPrimary = "isPrimary"
// Storage path prefix
const val StoragePrefix = "/storage"

@Suppress("MemberVisibilityCanBePrivate", "unused")
class VolumeInfo(private var context: Context) {

    fun getVolumesUUIDs(includePrimary: Boolean, includeRemoveable: Boolean): List<String> {
        val result = mutableListOf<String>()
        for (storageVolume in this.getStorageVolumes()) {
            if ((!includePrimary && storageVolume.isPrimary) || (!includeRemoveable && storageVolume.isRemovable)) {
                continue
            }
            if (storageVolume.uuid == null) {
                result.add(getVolumeUUIDPrimary())
            } else {
                result.add(storageVolume.uuid!!)
            }
        }
        return result
    }

    fun isVolumeAvailable(uuid: String): Boolean {
        return this.getStorageVolumeByUUID(uuid)?.state == Environment.MEDIA_MOUNTED
    }

    fun isVolumePrimary(uuid: String): Boolean {
        return this.getStorageVolumeByUUID(uuid)?.isPrimary?:false
    }

    fun isRemoveable(uuid: String): Boolean {
        return this.getStorageVolumeByUUID(uuid)?.isRemovable?:false
    }

    fun getVolumeState(uuid: String): String {
        return this.getStorageVolumeByUUID(uuid)?.state?:""
    }

    fun getVolumeAbsolutePath(uuid: String): String {
        return this.getVolumeDirectory(uuid)?.absolutePath?:""
    }

    fun getVolumeInfo(uuid: String): MutableMap<String, String> {
        return getAdvancedInfo(uuid, this.getStorageVolumeByUUID(uuid))
    }

    fun getVolumeSpace(uuid: String): MutableMap<String, String> {
        val result = getEmptyVolumeSpace()
        val storageVolume = this.getStorageVolumeByUUID(uuid)
        if (storageVolume != null) {
            if (storageVolume.isPrimary) {
                val mStorageStatsManager = context.getSystemService(Context.STORAGE_STATS_SERVICE) as StorageStatsManager
                val totalSpace: Long = (mStorageStatsManager.getTotalBytes(StorageManager.UUID_DEFAULT) / 1_000_000_000) * GiB
                val usedSpace: Long = totalSpace - mStorageStatsManager.getFreeBytes(StorageManager.UUID_DEFAULT)
                result.putAll(getVolumeSpacesMap(totalSpace.toDouble(), usedSpace.toDouble()))
            } else {
                val dir = this.getVolumeDirectory(uuid)
                if (dir != null) {
                    result.putAll(getVolumeSpacesMap(dir.totalSpace.toDouble(), dir.freeSpace.toDouble()))
                }
            }
            // Advanced volume information
            result.putAll(getAdvancedInfo(uuid, storageVolume))
        }
        return result
    }

    fun getVolumeSpacePrimary(): MutableMap<String, String> {
        return getVolumeSpace(getVolumeUUIDPrimary())
    }

    fun getVolumeAbsolutePathPrimary(): String {
        return getVolumeAbsolutePath(getVolumeUUIDPrimary())
    }

    fun getVolumeUUIDPrimary(): String {
        return StorageManager.UUID_DEFAULT.toString()
    }

    /* ------------------------------------------------------------------------------------------
     *  Private methods
     * ------------------------------------------------------------------------------------------ */

    private fun getStorageVolumes():List<StorageVolume> {
        val mStorageManager = context.getSystemService(Context.STORAGE_SERVICE) as StorageManager
        return mStorageManager.storageVolumes
    }

    private fun getAdvancedInfo(uuid: String, storageVolume: StorageVolume?): MutableMap<String, String> {
        val result = getEmptyVolumeInfo()
        if (storageVolume != null) {
            // Advanced volume information
            result[VolumeUUID] = uuid
            result[VolumeIsAvailable] = ((storageVolume.state) == Environment.MEDIA_MOUNTED).toString()
            result[VolumeIsRemoveable] = (storageVolume.isRemovable).toString()
            result[VolumeIsPrimary] = (storageVolume.isPrimary).toString()
            result[VolumeState] = (storageVolume.state).toString()
            result[VolumeAbsolutePath] = getVolumeAbsolutePath(uuid)
        }
        return result
    }

    private fun getEmptyVolumeInfo(): MutableMap<String, String> {
        val result = mutableMapOf<String, String>()
        // Advanced volume information
        result[VolumeUUID] = ""
        result[VolumeAbsolutePath] = ""
        result[VolumeState] = ""
        result[VolumeIsAvailable] = (false).toString()
        result[VolumeIsRemoveable] = (false).toString()
        result[VolumeIsPrimary] = (false).toString()
        return result
    }

    private fun getEmptyVolumeSpace(): MutableMap<String, String> {
        val result = mutableMapOf<String, String>()
        // Volume space information
        result[VolumeTotal] = (0.0).toString()
        result[VolumeFree] = (0.0).toString()
        result[VolumeUsed] = (0.0).toString()
        // Advanced volume information
        result.putAll(getEmptyVolumeInfo())
        return result
    }

    private fun getStorageVolumeByUUID(uuid: String): StorageVolume? {
        var result: StorageVolume? = null
        for (storageVolume in getStorageVolumes()) {
            if (storageVolume.uuid == null) {
                if (uuid == getVolumeUUIDPrimary()) {
                    result = storageVolume
                    break
                }
            } else {
                if (uuid == storageVolume.uuid) {
                    result = storageVolume
                    break
                }
            }
        }
        return result
    }

    private fun getVolumeSpacesMap(volumeSpaceTotal: Double, volumeSpaceFree: Double): MutableMap<String, String>  {
        val result = getEmptyVolumeSpace()
        val volumeSpaceTotalGB = round(volumeSpaceTotal / GiB.toDouble())
        val volumeSpaceFreeGB = round(volumeSpaceFree / GiB.toDouble())
        val volumeSpaceUsedGB = round((volumeSpaceTotalGB-volumeSpaceFreeGB) / GiB.toDouble())
        result[VolumeTotal] = volumeSpaceTotalGB.toString()
        result[VolumeFree] = volumeSpaceFreeGB.toString()
        result[VolumeUsed] = volumeSpaceUsedGB.toString()
        return result
    }



    private fun getVolumeDirectory(uuid: String): File? {
        var result: File? = null
        if (uuid == getVolumeUUIDPrimary()) {
            result = File("${StoragePrefix}/emulated/0")
        } else {
            val mStorageManager = context.getSystemService(Context.STORAGE_SERVICE) as StorageManager
            val externalDir = File("${StoragePrefix}/$uuid")
            val storageVolume = mStorageManager.getStorageVolume(externalDir)
            if (storageVolume != null && storageVolume.uuid == uuid) {
                result = externalDir
            }
        }
        return result
    }
}
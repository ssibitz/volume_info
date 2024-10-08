package com.freudenstrahl.volume_info

import android.app.usage.StorageStatsManager
import android.content.Context
import android.os.storage.StorageManager
import android.os.storage.StorageVolume
import kotlin.math.round

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
        var result = false
        if (this.getStorageVolumeByUUID(uuid) != null) {
            result = true
        }
        return result
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
        val dir = this.getStorageVolumeByUUID(uuid)?.directory
        return dir?.absolutePath?:""
    }

    fun getVolumeSpace(uuid: String): MutableMap<String, String> {
        val result = getEmptyVolumeSpace()
        val storageVolume = this.getStorageVolumeByUUID(uuid)
        if (storageVolume != null) {
            var volumeSpaceTotal = 0.0
            var volumeSpaceFree = 0.0
            var volumeSpaceUsed = 0.0
            if (storageVolume.isPrimary) {
                val mStorageStatsManager = context.getSystemService(Context.STORAGE_STATS_SERVICE) as StorageStatsManager
                val totalSpace: Long = (mStorageStatsManager.getTotalBytes(StorageManager.UUID_DEFAULT) / 1_000_000_000) * GiB
                val usedSpace: Long = totalSpace - mStorageStatsManager.getFreeBytes(StorageManager.UUID_DEFAULT)
                volumeSpaceTotal = round(totalSpace.toDouble()/ GiB.toDouble())
                volumeSpaceFree = round(usedSpace.toDouble()/ GiB.toDouble())
                volumeSpaceUsed = round((totalSpace-usedSpace).toDouble()/ GiB.toDouble())
            } else {
                val dir = storageVolume.directory
                if (dir != null) {
                    volumeSpaceTotal = round(dir.totalSpace.toDouble() / GiB)
                    volumeSpaceFree = round(dir.freeSpace.toDouble() / GiB)
                    volumeSpaceUsed = volumeSpaceTotal - volumeSpaceFree
                }
            }
            // Volume space information
            result[VolumeTotal] = volumeSpaceTotal.toString()
            result[VolumeFree] = volumeSpaceFree.toString()
            result[VolumeUsed] = volumeSpaceUsed.toString()
            // Advanced volume information
            result[VolumeUUID] = uuid
            result[VolumeAbsolutePath] = getVolumeAbsolutePath(uuid)
            result[VolumeState] = getVolumeState(uuid)
            result[VolumeIsAvailable] = (true).toString()
            result[VolumeIsRemoveable] = (storageVolume.isRemovable).toString()
            result[VolumeIsPrimary] = (storageVolume.isPrimary).toString()
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

    private fun getStorageVolumes():List<StorageVolume> {
        val mStorageManager = context.getSystemService(Context.STORAGE_SERVICE) as StorageManager
        return mStorageManager.storageVolumes
    }

    private fun getEmptyVolumeSpace(): MutableMap<String, String> {
        val result = mutableMapOf<String, String>()
        // Volume space information
        result[VolumeTotal] = (0.0).toString()
        result[VolumeFree] = (0.0).toString()
        result[VolumeUsed] = (0.0).toString()
        // Advanced volume information
        result[VolumeUUID] = ""
        result[VolumeAbsolutePath] = ""
        result[VolumeState] = ""
        result[VolumeIsAvailable] = (false).toString()
        result[VolumeIsRemoveable] = (false).toString()
        result[VolumeIsPrimary] = (false).toString()
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
}
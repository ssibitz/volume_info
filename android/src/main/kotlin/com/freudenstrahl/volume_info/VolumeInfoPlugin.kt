package com.freudenstrahl.volume_info

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

class VolumeInfoPlugin: FlutterPlugin, MethodCallHandler {
  private lateinit var channel : MethodChannel
  private lateinit var volumeInfo: VolumeInfo

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "volume_info")
    channel.setMethodCallHandler(this)
    volumeInfo = VolumeInfo(flutterPluginBinding.applicationContext)
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    // Get parameters
    val includePrimary = call.argument<Boolean>("includePrimary")
    val includeRemoveable = call.argument<Boolean>("includeRemoveable")
    val uuid = call.argument<String>("uuid")
    // Return result by method name
    if (call.method == "getVolumesUUIDs") {
      result.success(volumeInfo.getVolumesUUIDs(includePrimary?:true, includeRemoveable?:true))
    } else if (call.method == "isVolumeAvailable") {
      result.success(volumeInfo.isVolumeAvailable(uuid?:""))
    } else if (call.method == "isVolumePrimary") {
      result.success(volumeInfo.isVolumePrimary(uuid?:""))
    } else if (call.method == "isRemoveable") {
      result.success(volumeInfo.isRemoveable(uuid?:""))
    } else if (call.method == "getVolumeState") {
      result.success(volumeInfo.getVolumeState(uuid?:""))
    } else if (call.method == "getVolumeAbsolutePath") {
      result.success(volumeInfo.getVolumeAbsolutePath(uuid?:""))
    } else if (call.method == "getVolumeSpaceInGB") {
      result.success(volumeInfo.getVolumeSpaceInGB(uuid?:""))
    } else if (call.method == "getVolumeSpacePrimary") {
      result.success(volumeInfo.getVolumeSpacePrimary())
    } else if (call.method == "getVolumeAbsolutePathPrimary") {
      result.success(volumeInfo.getVolumeAbsolutePathPrimary())
    } else if (call.method == "getVolumeUUIDPrimary") {
      result.success(volumeInfo.getVolumeUUIDPrimary())
    } else {
      result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}

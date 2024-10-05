package com.freudenstrahl.volume_info

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import VolumeInfo

class VolumeInfoPlugin: FlutterPlugin, MethodCallHandler {
  private lateinit var channel : MethodChannel
  private lateinit var volumeInfo: VolumeInfo

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "volume_info")
    channel.setMethodCallHandler(this)
    volumeInfo = VolumeInfo(flutterPluginBinding.applicationContext)
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    if (call.method == "isVolumeAvailable") {
      val absolutePath = call.argument<String>("absolutePath")
      result.success(volumeInfo.isVolumeAvailable(absolutePath?:""))
    } else if (call.method == "isVolumePrimary") {
      val absolutePath = call.argument<String>("absolutePath")
      result.success(volumeInfo.isVolumePrimary(absolutePath?:""))
    } else if (call.method == "getVolumeSpaceInGB") {
      val absolutePath = call.argument<String>("absolutePath")
      result.success(volumeInfo.getVolumeSpaceInGB(absolutePath?:""))
    } else if (call.method == "getVolumesAbsolutePaths") {
      val includePrimary = call.argument<Boolean>("includePrimary")
      val includeRemoveable = call.argument<Boolean>("includeRemoveable")
      result.success(volumeInfo.getVolumesAbsolutePaths(includePrimary?:true, includeRemoveable?:true))
    } else if (call.method == "getVolumeSpacePrimary") {
      result.success(volumeInfo.getVolumeSpacePrimary())
    } else {
      result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}

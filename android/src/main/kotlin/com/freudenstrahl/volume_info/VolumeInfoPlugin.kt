package com.freudenstrahl.volume_info

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import android.content.Context
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
    if (call.method == "getVolumeSpaceTotalInGB") {
      result.success(volumeInfo.getVolumeSpaceTotalInGB())
    } else if (call.method == "getVolumeSpaceFreeInGB") {
        result.success(volumeInfo.getVolumeSpaceFreeInGB())
    } else if (call.method == "getVolumeSpaceUsedInGB") {
      result.success(volumeInfo.getVolumeSpaceUsedInGB())
    } else {
      result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}

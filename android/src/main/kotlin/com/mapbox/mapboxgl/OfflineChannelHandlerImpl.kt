//package com.mapbox.mapboxgl
//
//import com.google.gson.Gson
//import io.flutter.plugin.common.BinaryMessenger
//import io.flutter.plugin.common.EventChannel
//import io.flutter.plugin.common.EventChannel.EventSink
//import java.util.*
//
//class OfflineChannelHandlerImpl internal constructor(messenger: BinaryMessenger?, channelName: String?) : EventChannel.StreamHandler {
//    private var sink: EventSink? = null
//    private val gson = Gson()
//    override fun onListen(arguments: Any, events: EventSink) {
//        sink = events
//    }
//
//    override fun onCancel(arguments: Any) {
//        sink = null
//    }
//
//    fun onError(errorCode: String?, errorMessage: String?, errorDetails: Any?) {
//        if (sink == null) return
//        sink!!.error(errorCode, errorMessage, errorDetails)
//    }
//
//    fun onSuccess() {
//        if (sink == null) return
//        val body: MutableMap<String, Any> = HashMap()
//        body.put("status", "success")
//        sink!!.success(gson.toJson(body))
//    }
//
//    fun onStart() {
//        if (sink == null) return
//        val body: MutableMap<String, Any> = HashMap()
//        body.put("status", "start")
//        sink!!.success(gson.toJson(body))
//    }
//
//    fun onProgress(progress: Double) {
//        if (sink == null) return
//        val body: MutableMap<String, Any> = HashMap()
//        body.put("status", "progress")
//        body.put("progress", progress)
//        sink!!.success(gson.toJson(body))
//    }
//
//    init {
//        val eventChannel = EventChannel(messenger, channelName)
//        eventChannel.setStreamHandler(this)
//    }
//}
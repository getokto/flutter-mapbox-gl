package com.mapbox.mapboxgl

import android.content.Context
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

class MapboxMapFactory(private val messenger: BinaryMessenger, private val lifecycleProvider: LifecycleProvider) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {
    override fun create(context: Context, id: Int, args: Any): PlatformView {
        val params = args as Map<String, Any>

        return MapboxMapController(
                id,
                context,
                messenger,
                params,
                lifecycleProvider
        );
    }
}
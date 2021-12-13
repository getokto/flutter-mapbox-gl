package com.mapbox.mapboxgl

import android.content.Context
import com.mapbox.mapboxgl.MapboxMapsPlugin.LifecycleProvider
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

class MapboxMapFactory(private val messenger: BinaryMessenger, private val lifecycleProvider: LifecycleProvider) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {
    override fun create(context: Context, id: Int, args: Any): PlatformView {
        val params = args as Map<String, Any>
        val builder = MapboxMapBuilder()
        Convert.interpretMapboxMapOptions(params["options"], builder)
        if (params.containsKey("initialCameraPosition")) {
            val position = Convert.toCameraPosition(params["initialCameraPosition"])
            builder.setInitialCameraPosition(position)
        }
        if (params.containsKey("annotationOrder")) {
            val annotations = Convert.toAnnotationOrder(params["annotationOrder"])
            builder.setAnnotationOrder(annotations)
        }
        if (params.containsKey("annotationConsumeTapEvents")) {
            val annotations = Convert.toAnnotationConsumeTapEvents(params["annotationConsumeTapEvents"])
            builder.setAnnotationConsumeTapEvents(annotations)
        }
        return builder.build(id, context, messenger, lifecycleProvider, params["accessToken"] as String?)
    }
}
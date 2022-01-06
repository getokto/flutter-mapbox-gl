package com.mapbox.mapboxgl

import android.animation.ValueAnimator
import android.location.Location
import android.os.Build
import com.mapbox.geojson.Point
import com.mapbox.maps.MapView
import com.mapbox.maps.plugin.locationcomponent.location
import io.flutter.plugin.common.EventChannel
import java.util.*

class UserPositionStreamHandler(
        client: MapView
) : EventChannel.StreamHandler {
    private var events: EventChannel.EventSink? = null
    private val client: MapView = client

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        (arguments as Map<String, Any?>?)?.let {
            client.location.getLocationProvider()?.registerLocationConsumer(locationConsumer = object:CustomLocationConsumer {
                override fun onExtendedLocationUpdated(
                    location: Location,
                    options: (ValueAnimator.() -> Unit)?
                ) {
                    if (!client.location.enabled) { return }
                    events?.let { events ->
                        val userLocation: MutableMap<String, Any?> = HashMap(6)
                        userLocation["position"] =
                            doubleArrayOf(location.latitude, location.longitude)
                        userLocation["speed"] = location.speed
                        userLocation["altitude"] = location.altitude
                        userLocation["bearing"] = location.bearing
                        userLocation["horizontalAccuracy"] = location.accuracy
                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                            userLocation["verticalAccuracy"] =
                                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) location.verticalAccuracyMeters else null
                        }
                        userLocation["timestamp"] = location.time
                        val arguments: MutableMap<String, Any> = HashMap(1)
                        arguments["userLocation"] = userLocation
                        events.success(arguments)
                    }
                }

                override fun onBearingUpdated(vararg bearing: Double, options: (ValueAnimator.() -> Unit)?) {}

                override fun onLocationUpdated(vararg location: Point, options: (ValueAnimator.() -> Unit)?) {}

                override fun onPuckBearingAnimatorDefaultOptionsUpdated(options: ValueAnimator.() -> Unit) {}

                override fun onPuckLocationAnimatorDefaultOptionsUpdated(options: ValueAnimator.() -> Unit) {}

            })
        }
    }

    override fun onCancel(arguments: Any?) {
        this.events = null
    }
}
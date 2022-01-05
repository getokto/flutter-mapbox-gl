// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
package com.mapbox.mapboxgl

import com.mapbox.geojson.Point
import com.mapbox.geojson.Polygon
import com.mapbox.maps.CameraOptions
import com.mapbox.maps.CameraState
import com.mapbox.maps.MapboxMap
import java.util.*

/**
 * Conversions between JSON-like values and MapboxMaps data types.
 */
internal object Convert {
    private const val TAG = "Convert"

    private fun toBoolean(o: Any): Boolean {
        return o as Boolean
    }

    fun toCameraPosition(o: Any?): CameraOptions {
        val data = toMap(o)
        val builder = CameraOptions.Builder()
        data?.let { data ->
            builder.bearing(data["bearing"] as Double?)
            (data["target"] as List<Double>?)?.let { center ->
                builder.center(Point.fromLngLat(center[1], center[0]))
            }

            builder.pitch(data["tilt"] as Double?)
            builder.zoom(data["zoom"] as Double?)
        }
        return builder.build()
    }

    fun toAnnotationOrder(o: Any?): List<String?> {
        val data = toList(o)
        val annotations: MutableList<String?> = arrayListOf();
        for (index in data!!.indices) {
            annotations.add(toString(data!![index]!!))
        }
        return annotations
    }

    fun toCameraUpdate(o: Any?, mapboxMap: MapboxMap): CameraOptions? {
        val data = toList(o)
        var action = toString(data!![0]!!);

        var cameraOptions = CameraOptions.Builder();

        return when (action) {
            "newCameraPosition" -> toCameraPosition(data[1])
//            "newLatLng" -> CameraUpdateFactory.newLatLng(toLatLng(data[1]))
//            "newLatLngBounds" -> CameraUpdateFactory.newLatLngBounds(toLatLngBounds(data[1])!!, toPixels(data[2]!!, density),
//                    toPixels(data[3]!!, density), toPixels(data[4]!!, density), toPixels(data[5]!!, density))
//            "newLatLngZoom" -> CameraUpdateFactory.newLatLngZoom(toLatLng(data[1]), toFloat(data[2]).toDouble())
//            "scrollBy" -> {
//                mapboxMap!!.scrollBy(
//                        toFractionalPixels(data[1]!!, density),
//                        toFractionalPixels(data[2]!!, density)
//                )
//                null
//            }
//            "zoomBy" -> if (data.size == 2) {
//                CameraUpdateFactory.zoomBy(toFloat(data[1]).toDouble())
//            } else {
//                CameraUpdateFactory.zoomBy(toFloat(data[1]).toDouble(), toPoint(data[2]!!, density))
//            }
            "zoomIn" -> cameraOptions.zoom(mapboxMap.cameraState.zoom + 1).build()
            "zoomOut" -> cameraOptions.zoom(mapboxMap.cameraState.zoom - 1).build()
            "zoomTo" -> cameraOptions.zoom(data[1] as Double).build()
            "bearingTo" -> cameraOptions.bearing(data[1] as Double).build()
            "pitchTo" -> cameraOptions.pitch(data[1] as Double).build()
            else -> throw IllegalArgumentException("Cannot interpret $o as CameraUpdate")
        }
    }

    private fun toDouble(o: Any): Double {
        return (o as Number).toDouble()
    }

    private fun toFloat(o: Any?): Float {
        return (o as Number?)?.toFloat() ?: (0.0).toFloat()
    }

    private fun toInt(o: Any): Int {
        return (o as Number).toInt()
    }

    fun toJson(position: CameraState?): Any? {
        if (position == null) {
            return null
        }
        val data: MutableMap<String, Any> = HashMap()
        data["bearing"] = position.bearing
        data["target"] = toJson(position.center)
        data["pitch"] = position.pitch
        data["zoom"] = position.zoom
        return data
    }

    private fun toJson(latLng: Point): Any {
        return listOf(latLng.latitude(), latLng.longitude())
    }

//    private fun toLatLng(o: Any?): LatLng {
//        val data = toList(o)
//        return LatLng(toDouble(data!![0]!!), toDouble(data[1]!!))
//    }
//
//    private fun toLatLngBounds(o: Any?): LatLngBounds? {
//        if (o == null) {
//            return null
//        }
//        val data = toList(o)
//        val boundsArray = arrayOf(toLatLng(data!![0]), toLatLng(data[1]))
//        val bounds = listOf(*boundsArray)
//        val builder = LatLngBounds.Builder()
//        for(bound in bounds) {
//            builder.include(bound)
//        }
//        return builder.build()
//    }

    private fun toList(o: Any?): List<*>? {
        return o as List<*>?
    }

    fun toMap(o: Any?): Map<*, *>? {
        return o as Map<*, *>?
    }

    private fun toFractionalPixels(o: Any, density: Float): Float {
        return toFloat(o) * density
    }

    fun toPixels(o: Any, density: Float): Int {
        return toFractionalPixels(o, density).toInt()
    }

    private fun toPoint(o: Any, density: Float): android.graphics.Point {
        val data = toList(o)
        return android.graphics.Point(toPixels(data!![0]!!, density), toPixels(data[1]!!, density))
    }

    private fun toString(o: Any): String {
        return o as String
    }

    fun interpretMapboxMapOptions(o: Map<String, Any?>, sink: MapboxMapOptionsSink) {
        toMap(o)?.let { data ->
//            val cameraTargetBounds = data["cameraTargetBounds"]
//            if (cameraTargetBounds != null) {
//                val targetData = toList(cameraTargetBounds)
//                sink.setCameraTargetBounds(toLatLngBounds(targetData!![0]))
//            }
            val compassEnabled = data["compassEnabled"]
            if (compassEnabled != null) {
                sink.setCompassEnabled(toBoolean(compassEnabled))
            }
            val scaleBarEnabled = data["scaleBarEnabled"]
            if (scaleBarEnabled != null) {
                sink.setScaleBarEnabled(toBoolean(scaleBarEnabled))
            }
            val styleString = data["styleString"]
            if (styleString != null) {
                sink.setStyleString(toString(styleString))
            }
            val minMaxZoomPreference = data["minMaxZoomPreference"]
            if (minMaxZoomPreference != null) {
                val zoomPreferenceData = toList(minMaxZoomPreference)!!
                sink.setMinMaxZoomPreference( //
                    zoomPreferenceData[0] as Double?,
                    zoomPreferenceData[1] as Double?
                )
            }
            val minMaxPitchPreference = data["minMaxPitchPreference"]
            if (minMaxPitchPreference != null) {
                val pitchPreferenceData = toList(minMaxPitchPreference)!!
                sink.setMinMaxPitchPreference( //
                    pitchPreferenceData[0] as Double?,
                    pitchPreferenceData[1] as Double?
                )
            }
            val rotateGesturesEnabled = data["rotateGesturesEnabled"]
            if (rotateGesturesEnabled != null) {
                sink.setRotateGesturesEnabled(toBoolean(rotateGesturesEnabled))
            }
            val scrollGesturesEnabled = data["scrollGesturesEnabled"]
            if (scrollGesturesEnabled != null) {
                sink.setScrollGesturesEnabled(toBoolean(scrollGesturesEnabled))
            }
            val tiltGesturesEnabled = data["tiltGesturesEnabled"]
            if (tiltGesturesEnabled != null) {
                sink.setPitchGesturesEnabled(toBoolean(tiltGesturesEnabled))
            }
            val trackCameraPosition = data["trackCameraPosition"]
            if (trackCameraPosition != null) {
                sink.setTrackCameraPosition(toBoolean(trackCameraPosition))
            }
            val zoomGesturesEnabled = data["zoomGesturesEnabled"]
            if (zoomGesturesEnabled != null) {
                sink.setZoomGesturesEnabled(toBoolean(zoomGesturesEnabled))
            }
            val myLocationEnabled = data["myLocationEnabled"]
            if (myLocationEnabled != null) {
                sink.setMyLocationEnabled(toBoolean(myLocationEnabled))
            }
            val myLocationTrackingMode = data["myLocationTrackingMode"]
            if (myLocationTrackingMode != null) {
                sink.setMyLocationTrackingMode(toInt(myLocationTrackingMode))
            }
            val myLocationRenderMode = data["myLocationRenderMode"]
            if (myLocationRenderMode != null) {
                sink.setMyLocationRenderMode(toInt(myLocationRenderMode))
            }
            val logoPosition = data["logoViewPosition"]
            if (logoPosition != null) {
                sink.setLogoPosition(toInt(logoPosition))
            }
            val logoViewMargins = data["logoViewMargins"]
            if (logoViewMargins != null) {
                val logoViewMarginsData = toList(logoViewMargins)
                sink.setLogoViewMargins(toInt(logoViewMarginsData!![0]!!), toInt(logoViewMarginsData[1]!!))
            }
            val compassPosition = data["compassViewPosition"]
            if (compassPosition != null) {
                sink.setCompassViewPosition(toInt(compassPosition))
            }
            val compassViewMargins = data["compassViewMargins"]
            if (compassViewMargins != null) {
                val compassViewMarginsData = toList(compassViewMargins)
                sink.setCompassViewMargins(toInt(compassViewMarginsData!![0]!!), toInt(compassViewMarginsData[1]!!))
            }
            val attributionButtonPosition = data["attributionButtonPosition"]
            if (attributionButtonPosition != null) {
                sink.setAttributionButtonPosition(toInt(attributionButtonPosition))
            }
            val attributionButtonMargins = data["attributionButtonMargins"]
            if (attributionButtonMargins != null) {
                val attributionButtonMarginsData = toList(attributionButtonMargins)
                sink.setAttributionButtonMargins(toInt(attributionButtonMarginsData!![0]!!), toInt(attributionButtonMarginsData[1]!!))
            }
        }
    }
}
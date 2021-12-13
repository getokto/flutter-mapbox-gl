//// Copyright 2018 The Chromium Authors. All rights reserved.
//// Use of this source code is governed by a BSD-style license that can be
//// found in the LICENSE file.
//package com.mapbox.mapboxgl
//
//import android.content.Context
//import android.util.Log
//import android.view.Gravity
//import com.google.android.gms.maps.model.CameraPosition
//import com.google.android.gms.maps.model.LatLngBounds
//import com.mapbox.mapboxgl.MapboxMapsPlugin.LifecycleProvider
//import com.mapbox.maps.MapOptions
//import com.mapbox.maps.Style
//import io.flutter.plugin.common.BinaryMessenger
//import java.util.*
//
//internal class MapboxMapBuilder : MapboxMapOptionsSink {
//    val TAG: String = javaClass.getSimpleName()
////    private val options = MapOptions.Builder();
//    private var trackCameraPosition = false
//    private var myLocationEnabled = false
//    private var myLocationTrackingMode = 0
//    private var myLocationRenderMode = 0
//    private var styleString: String? = Style.MAPBOX_STREETS
//    private var annotationOrder: List<String?>? = arrayListOf()
//    private var annotationConsumeTapEvents: List<String?>? = arrayListOf()
//    fun build(
//            id: Int,
//            context: Context,
//            messenger: BinaryMessenger?,
//            lifecycleProvider: LifecycleProvider,
//            accessToken: String?
//    ): MapboxMapController {
//        val controller = MapboxMapController(
//                id,
//                context,
//                messenger,
//                accessToken,
//                styleString,
//        )
//        controller.init()
//        controller.setMyLocationEnabled(myLocationEnabled)
//        controller.setMyLocationTrackingMode(myLocationTrackingMode)
//        controller.setMyLocationRenderMode(myLocationRenderMode)
//        controller.setTrackCameraPosition(trackCameraPosition)
//        return controller
//    }
//
//    fun setInitialCameraPosition(position: CameraPosition?) {
//        //options.camera(position)
//    }
//
//    override fun setCompassEnabled(compassEnabled: Boolean) {
//        //options.compassEnabled(compassEnabled)
//    }
//
//    override fun setCameraTargetBounds(bounds: LatLngBounds?) {
//        Log.e(TAG, "setCameraTargetBounds is supported only after map initiated.")
//        //throw new UnsupportedOperationException("setCameraTargetBounds is supported only after map initiated.");
//        //options.latLngBoundsForCameraTarget(bounds);
//    }
//
//    override fun setStyleString(styleString: String?) {
//        this.styleString = styleString
//        //options. styleString(styleString);
//    }
//
//    override fun setMinMaxZoomPreference(min: Float?, max: Float?) {
//        options.c
//        if (min != null) {
//
//            //options.minZoomPreference(min.toDouble())
//        }
//        if (max != null) {
//            //options.maxZoomPreference(max.toDouble())
//        }
//    }
//
//    override fun setTrackCameraPosition(trackCameraPosition: Boolean) {
//        this.trackCameraPosition = trackCameraPosition
//    }
//
//    override fun setRotateGesturesEnabled(rotateGesturesEnabled: Boolean) {
////        options.rotateGesturesEnabled(rotateGesturesEnabled)
//    }
//
//    override fun setScrollGesturesEnabled(scrollGesturesEnabled: Boolean) {
////        options.scrollGesturesEnabled(scrollGesturesEnabled)
//    }
//
//    override fun setTiltGesturesEnabled(tiltGesturesEnabled: Boolean) {
////        options.tiltGesturesEnabled(tiltGesturesEnabled)
//    }
//
//    override fun setZoomGesturesEnabled(zoomGesturesEnabled: Boolean) {
////        options.zoomGesturesEnabled(zoomGesturesEnabled)
//    }
//
//    override fun setMyLocationEnabled(myLocationEnabled: Boolean) {
//        this.myLocationEnabled = myLocationEnabled
//    }
//
//    override fun setMyLocationTrackingMode(myLocationTrackingMode: Int) {
//        this.myLocationTrackingMode = myLocationTrackingMode
//    }
//
//    override fun setMyLocationRenderMode(myLocationRenderMode: Int) {
//        this.myLocationRenderMode = myLocationRenderMode
//    }
//
//    override fun setLogoViewMargins(x: Int, y: Int) {
////        options.logoMargins(intArrayOf(
////                x,  //left
////                0,  //top
////                0,  //right
////                y))
//    }
//
//    override fun setCompassGravity(gravity: Int) {
////        when (gravity) {
////            0 -> options.compassGravity(Gravity.TOP or Gravity.START)
////            1 -> options.compassGravity(Gravity.TOP or Gravity.END)
////            2 -> options.compassGravity(Gravity.BOTTOM or Gravity.START)
////            3 -> options.compassGravity(Gravity.BOTTOM or Gravity.END)
////            else -> options.compassGravity(Gravity.TOP or Gravity.END)
////        }
//    }
//
//    override fun setCompassViewMargins(x: Int, y: Int) {
////        when (options.compassGravity) {
////            Gravity.TOP or Gravity.START -> options.compassMargins(intArrayOf(x, y, 0, 0))
////            Gravity.TOP or Gravity.END -> options.compassMargins(intArrayOf(0, y, x, 0))
////            Gravity.BOTTOM or Gravity.START -> options.compassMargins(intArrayOf(x, 0, 0, y))
////            Gravity.BOTTOM or Gravity.END -> options.compassMargins(intArrayOf(0, 0, x, y))
////            else -> options.compassMargins(intArrayOf(0, y, x, 0))
////        }
//    }
//
//    override fun setAttributionButtonMargins(x: Int, y: Int) {
////        options.attributionMargins(intArrayOf(
////                x,  //left
////                0,  //top
////                0,  //right
////                y))
//    }
//
//    fun setAnnotationOrder(annotations: List<String?>?) {
//        annotationOrder = annotations
//    }
//
//    fun setAnnotationConsumeTapEvents(annotations: List<String?>?) {
//        annotationConsumeTapEvents = annotations
//    }
//}
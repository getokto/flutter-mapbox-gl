// This file is generated.
// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
package com.mapbox.mapboxgl

import android.graphics.Color
import com.mapbox.geojson.Point
import com.mapbox.mapboxsdk.geometry.LatLng
import com.mapbox.mapboxsdk.plugins.annotation.Circle
import com.mapbox.mapboxsdk.plugins.annotation.CircleManager

/** Controller of a single Circle on the map.  */
internal class CircleController(circle: Circle?, consumeTapEvents: Boolean, onTappedListener: OnCircleTappedListener?) : CircleOptionsSink {
    val circle: Circle
    private val onTappedListener: OnCircleTappedListener?
    private val consumeTapEvents: Boolean
    fun onTap(): Boolean {
        onTappedListener?.onCircleTapped(circle)
        return consumeTapEvents
    }

    fun remove(circleManager: CircleManager?) {
        circleManager!!.delete(circle)
    }

    override fun setCircleRadius(circleRadius: Float) {
        circle.circleRadius = circleRadius
    }

    override fun setCircleColor(circleColor: String?) {
        circle.setCircleColor(Color.parseColor(circleColor))
    }

    override fun setCircleBlur(circleBlur: Float) {
        circle.circleBlur = circleBlur
    }

    override fun setCircleOpacity(circleOpacity: Float) {
        circle.circleOpacity = circleOpacity
    }

    override fun setCircleStrokeWidth(circleStrokeWidth: Float) {
        circle.circleStrokeWidth = circleStrokeWidth
    }

    override fun setCircleStrokeColor(circleStrokeColor: String?) {
        circle.setCircleStrokeColor(Color.parseColor(circleStrokeColor))
    }

    override fun setCircleStrokeOpacity(circleStrokeOpacity: Float) {
        circle.circleStrokeOpacity = circleStrokeOpacity
    }

    override fun setGeometry(geometry: LatLng) {
        circle.geometry = Point.fromLngLat(geometry.longitude, geometry.latitude)
    }

    fun getGeometry(): LatLng {
        val point = circle.geometry
        return LatLng(point.latitude(), point.longitude())
    }

    override fun setDraggable(draggable: Boolean) {
        circle.isDraggable = draggable
    }

    fun update(circleManager: CircleManager?) {
        circleManager!!.update(circle)
    }

    init {
        this.circle = circle!!
        this.consumeTapEvents = consumeTapEvents
        this.onTappedListener = onTappedListener
    }
}
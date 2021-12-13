// This file is generated.
// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
package com.mapbox.mapboxgl

import com.mapbox.geojson.Point
import com.mapbox.mapboxsdk.geometry.LatLng
import com.mapbox.mapboxsdk.plugins.annotation.Circle
import com.mapbox.mapboxsdk.plugins.annotation.CircleManager
import com.mapbox.mapboxsdk.plugins.annotation.CircleOptions

internal class CircleBuilder(private val circleManager: CircleManager?) : CircleOptionsSink {
    val circleOptions: CircleOptions
    fun build(): Circle {
        return circleManager!!.create(circleOptions)
    }

    override fun setCircleRadius(circleRadius: Float) {
        circleOptions.withCircleRadius(circleRadius)
    }

    override fun setCircleColor(circleColor: String?) {
        circleOptions.withCircleColor(circleColor)
    }

    override fun setCircleBlur(circleBlur: Float) {
        circleOptions.withCircleBlur(circleBlur)
    }

    override fun setCircleOpacity(circleOpacity: Float) {
        circleOptions.withCircleOpacity(circleOpacity)
    }

    override fun setCircleStrokeWidth(circleStrokeWidth: Float) {
        circleOptions.withCircleStrokeWidth(circleStrokeWidth)
    }

    override fun setCircleStrokeColor(circleStrokeColor: String?) {
        circleOptions.withCircleStrokeColor(circleStrokeColor)
    }

    override fun setCircleStrokeOpacity(circleStrokeOpacity: Float) {
        circleOptions.withCircleStrokeOpacity(circleStrokeOpacity)
    }

    override fun setGeometry(geometry: LatLng) {
        circleOptions.withGeometry(Point.fromLngLat(geometry.longitude, geometry.latitude))
    }

    override fun setDraggable(draggable: Boolean) {
        circleOptions.withDraggable(draggable)
    }

    init {
        circleOptions = CircleOptions()
    }
}
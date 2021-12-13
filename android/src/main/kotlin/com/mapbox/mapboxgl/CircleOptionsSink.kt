// This file is generated.
// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
package com.mapbox.mapboxgl

import com.mapbox.mapboxsdk.geometry.LatLng

/** Receiver of Circle configuration options.  */
internal interface CircleOptionsSink {
    fun setCircleRadius(circleRadius: Float)
    fun setCircleColor(circleColor: String?)
    fun setCircleBlur(circleBlur: Float)
    fun setCircleOpacity(circleOpacity: Float)
    fun setCircleStrokeWidth(circleStrokeWidth: Float)
    fun setCircleStrokeColor(circleStrokeColor: String?)
    fun setCircleStrokeOpacity(circleStrokeOpacity: Float)
    fun setGeometry(geometry: LatLng)
    fun setDraggable(draggable: Boolean)
}
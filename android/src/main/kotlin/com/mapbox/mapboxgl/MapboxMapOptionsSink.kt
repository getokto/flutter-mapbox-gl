// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
package com.mapbox.mapboxgl

import com.google.android.gms.maps.model.LatLngBounds

/**
 * Receiver of MapboxMap configuration options.
 */
internal interface MapboxMapOptionsSink {
    fun setCameraTargetBounds(bounds: LatLngBounds?) //todo: dddd replace with CameraPosition.Builder target
    fun setCompassEnabled(enabled: Boolean)
    fun setScaleBarEnabled(enabled: Boolean)

    // TODO: styleString is not actually a part of options. consider moving
    fun setStyleString(styleString: String?)
    fun setMinMaxZoomPreference(min: Double, max: Double)
    fun setMinMaxPitchPreference(min: Double, max: Double)
    fun setRotateGesturesEnabled(enabled: Boolean)
    fun setScrollGesturesEnabled(enabled: Boolean)
    fun setPitchGesturesEnabled(enabled: Boolean)
    fun setTrackCameraPosition(trackCameraPosition: Boolean)
    fun setZoomGesturesEnabled(enabled: Boolean)
    fun setMyLocationEnabled(enabled: Boolean)
    fun setMyLocationTrackingMode(myLocationTrackingMode: Int)
    fun setMyLocationRenderMode(myLocationRenderMode: Int)
    fun setLogoPosition(gravity: Int)
    fun setLogoViewMargins(x: Int, y: Int)
    fun setCompassViewPosition(gravity: Int)
    fun setCompassViewMargins(x: Int, y: Int)
    fun setAttributionButtonPosition(gravity: Int)
    fun setAttributionButtonMargins(x: Int, y: Int)
}
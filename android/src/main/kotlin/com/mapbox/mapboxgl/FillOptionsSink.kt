// This file is generated.
// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
package com.mapbox.mapboxgl

import com.mapbox.mapboxsdk.geometry.LatLng

/** Receiver of Fill configuration options.  */
internal interface FillOptionsSink {
    fun setFillOpacity(fillOpacity: Float)
    fun setFillColor(fillColor: String?)
    fun setFillOutlineColor(fillOutlineColor: String?)
    fun setFillPattern(fillPattern: String?)
    fun setGeometry(geometry: List<List<LatLng>?>?)
    fun setDraggable(draggable: Boolean)
}
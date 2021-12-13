// This file is generated.
// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
package com.mapbox.mapboxgl

import com.mapbox.mapboxsdk.geometry.LatLng
import com.mapbox.mapboxsdk.plugins.annotation.Fill
import com.mapbox.mapboxsdk.plugins.annotation.FillManager
import com.mapbox.mapboxsdk.plugins.annotation.FillOptions

internal class FillBuilder(private val fillManager: FillManager?) : FillOptionsSink {
    val fillOptions: FillOptions
    fun build(): Fill {
        return fillManager!!.create(fillOptions)
    }

    override fun setFillOpacity(fillOpacity: Float) {
        fillOptions.withFillOpacity(fillOpacity)
    }

    override fun setFillColor(fillColor: String?) {
        fillOptions.withFillColor(fillColor)
    }

    override fun setFillOutlineColor(fillOutlineColor: String?) {
        fillOptions.withFillOutlineColor(fillOutlineColor)
    }

    override fun setFillPattern(fillPattern: String?) {
        fillOptions.withFillPattern(fillPattern)
    }

    override fun setGeometry(geometry: List<List<LatLng>?>?) {
        fillOptions.withGeometry(Convert.interpretListLatLng(geometry))
    }

    override fun setDraggable(draggable: Boolean) {
        fillOptions.withDraggable(draggable)
    }

    init {
        fillOptions = FillOptions()
    }
}
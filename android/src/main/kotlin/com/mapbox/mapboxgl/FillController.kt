// This file is generated.
// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
package com.mapbox.mapboxgl

import android.graphics.Color
import com.mapbox.mapboxsdk.geometry.LatLng
import com.mapbox.mapboxsdk.plugins.annotation.Fill
import com.mapbox.mapboxsdk.plugins.annotation.FillManager

/**
 * Controller of a single Fill on the map.
 */
internal class FillController(fill: Fill?, consumeTapEvents: Boolean, onTappedListener: OnFillTappedListener?) : FillOptionsSink {
    val fill: Fill
    private val onTappedListener: OnFillTappedListener?
    private val consumeTapEvents: Boolean
    fun onTap(): Boolean {
        onTappedListener?.onFillTapped(fill)
        return consumeTapEvents
    }

    fun remove(fillManager: FillManager?) {
        fillManager!!.delete(fill)
    }

    override fun setFillOpacity(fillOpacity: Float) {
        fill.fillOpacity = fillOpacity
    }

    override fun setFillColor(fillColor: String?) {
        fill.setFillColor(Color.parseColor(fillColor))
    }

    override fun setFillOutlineColor(fillOutlineColor: String?) {
        fill.setFillOutlineColor(Color.parseColor(fillOutlineColor))
    }

    override fun setFillPattern(fillPattern: String?) {
        fill.fillPattern = fillPattern
    }

    override fun setGeometry(geometry: List<List<LatLng>?>?) {
        fill.geometry = Convert.interpretListLatLng(geometry)
    }

    override fun setDraggable(draggable: Boolean) {
        fill.isDraggable = draggable
    }

    fun update(fillManager: FillManager?) {
        fillManager!!.update(fill)
    }

    init {
        this.fill = fill!!
        this.consumeTapEvents = consumeTapEvents
        this.onTappedListener = onTappedListener
    }
}
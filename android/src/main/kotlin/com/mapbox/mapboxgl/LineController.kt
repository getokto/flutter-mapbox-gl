// This file is generated.
// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
package com.mapbox.mapboxgl

import com.mapbox.mapboxsdk.geometry.LatLng
import com.mapbox.mapboxsdk.plugins.annotation.Line
import com.mapbox.mapboxsdk.plugins.annotation.LineManager
import com.mapbox.mapboxsdk.utils.ColorUtils
import java.util.*

/**
 * Controller of a single Line on the map.
 */
internal class LineController(line: Line?, consumeTapEvents: Boolean, onTappedListener: OnLineTappedListener?) : LineOptionsSink {
    val line: Line
    private val onTappedListener: OnLineTappedListener?
    private val consumeTapEvents: Boolean
    fun onTap(): Boolean {
        onTappedListener?.onLineTapped(line)
        return consumeTapEvents
    }

    fun remove(lineManager: LineManager?) {
        lineManager!!.delete(line)
    }

    override fun setLineJoin(lineJoin: String?) {
        line.lineJoin = lineJoin
    }

    override fun setLineOpacity(lineOpacity: Float) {
        line.lineOpacity = lineOpacity
    }

    override fun setLineColor(lineColor: String?) {
        line.setLineColor(ColorUtils.rgbaToColor(lineColor!!))
    }

    override fun setLineWidth(lineWidth: Float) {
        line.lineWidth = lineWidth
    }

    override fun setLineGapWidth(lineGapWidth: Float) {
        line.lineGapWidth = lineGapWidth
    }

    override fun setLineOffset(lineOffset: Float) {
        line.lineOffset = lineOffset
    }

    override fun setLineBlur(lineBlur: Float) {
        line.lineBlur = lineBlur
    }

    override fun setLinePattern(linePattern: String?) {
        line.linePattern = linePattern
    }

    override fun setGeometry(geometry: List<LatLng>?) {
        line.setLatLngs(geometry)
    }

    fun getGeometry(): List<LatLng> {
        val points = line.geometry.coordinates()
        val latLngs: MutableList<LatLng> = ArrayList()
        for (point in points) {
            latLngs.add(LatLng(point.latitude(), point.longitude()))
        }
        return latLngs
    }

    override fun setDraggable(draggable: Boolean) {
        line.isDraggable = draggable
    }

    fun update(lineManager: LineManager?) {
        lineManager!!.update(line)
    }

    init {
        this.line = line!!
        this.consumeTapEvents = consumeTapEvents
        this.onTappedListener = onTappedListener
    }
}
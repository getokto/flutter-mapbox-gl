//// This file is generated.
//// Copyright 2018 The Chromium Authors. All rights reserved.
//// Use of this source code is governed by a BSD-style license that can be
//// found in the LICENSE file.
//package com.mapbox.mapboxgl
//
//
//internal class LineBuilder(private val lineManager: LineManager?) : LineOptionsSink {
//    val lineOptions: LineOptions
//    fun build(): Line {
//        return lineManager!!.create(lineOptions)
//    }
//
//    override fun setLineJoin(lineJoin: String?) {
//        lineOptions.withLineJoin(lineJoin)
//    }
//
//    override fun setLineOpacity(lineOpacity: Float) {
//        lineOptions.withLineOpacity(lineOpacity)
//    }
//
//    override fun setLineColor(lineColor: String?) {
//        lineOptions.withLineColor(lineColor)
//    }
//
//    override fun setLineWidth(lineWidth: Float) {
//        lineOptions.withLineWidth(lineWidth)
//    }
//
//    override fun setLineGapWidth(lineGapWidth: Float) {
//        lineOptions.withLineGapWidth(lineGapWidth)
//    }
//
//    override fun setLineOffset(lineOffset: Float) {
//        lineOptions.withLineOffset(lineOffset)
//    }
//
//    override fun setLineBlur(lineBlur: Float) {
//        lineOptions.withLineBlur(lineBlur)
//    }
//
//    override fun setLinePattern(linePattern: String?) {
//        lineOptions.withLinePattern(linePattern)
//    }
//
//    override fun setGeometry(geometry: List<LatLng>?) {
//        lineOptions.withLatLngs(geometry)
//    }
//
//    override fun setDraggable(draggable: Boolean) {
//        lineOptions.withDraggable(draggable)
//    }
//
//    init {
//        lineOptions = LineOptions()
//    }
//}
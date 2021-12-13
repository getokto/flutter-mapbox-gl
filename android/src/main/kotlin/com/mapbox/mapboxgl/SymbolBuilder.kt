// This file is generated.
// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
package com.mapbox.mapboxgl

import com.mapbox.geojson.Point
import com.mapbox.mapboxsdk.geometry.LatLng
import com.mapbox.mapboxsdk.plugins.annotation.SymbolOptions

internal class SymbolBuilder : SymbolOptionsSink {
    val symbolOptions: SymbolOptions
    override fun setIconSize(iconSize: Float) {
        symbolOptions.withIconSize(iconSize)
    }

    override fun setIconImage(iconImage: String?) {
        symbolOptions.withIconImage(iconImage)
    }

    override fun setIconRotate(iconRotate: Float) {
        symbolOptions.withIconRotate(iconRotate)
    }

    override fun setIconOffset(iconOffset: FloatArray) {
        symbolOptions.withIconOffset(arrayOf(iconOffset[0], iconOffset[1]))
    }

    override fun setIconAnchor(iconAnchor: String?) {
        symbolOptions.withIconAnchor(iconAnchor)
    }

    override fun setFontNames(fontNames: Array<String?>?) {
        symbolOptions.withTextFont(fontNames)
    }

    override fun setTextField(textField: String?) {
        symbolOptions.withTextField(textField)
    }

    override fun setTextSize(textSize: Float) {
        symbolOptions.withTextSize(textSize)
    }

    override fun setTextMaxWidth(textMaxWidth: Float) {
        symbolOptions.withTextMaxWidth(textMaxWidth)
    }

    override fun setTextLetterSpacing(textLetterSpacing: Float) {
        symbolOptions.withTextLetterSpacing(textLetterSpacing)
    }

    override fun setTextJustify(textJustify: String?) {
        symbolOptions.withTextJustify(textJustify)
    }

    override fun setTextAnchor(textAnchor: String?) {
        symbolOptions.withTextAnchor(textAnchor)
    }

    override fun setTextRotate(textRotate: Float) {
        symbolOptions.withTextRotate(textRotate)
    }

    override fun setTextTransform(textTransform: String?) {
        symbolOptions.withTextTransform(textTransform)
    }

    override fun setTextOffset(textOffset: FloatArray) {
        symbolOptions.withTextOffset(arrayOf(textOffset[0], textOffset[1]))
    }

    override fun setIconOpacity(iconOpacity: Float) {
        symbolOptions.withIconOpacity(iconOpacity)
    }

    override fun setIconColor(iconColor: String?) {
        symbolOptions.withIconColor(iconColor)
    }

    override fun setIconHaloColor(iconHaloColor: String?) {
        symbolOptions.withIconHaloColor(iconHaloColor)
    }

    override fun setIconHaloWidth(iconHaloWidth: Float) {
        symbolOptions.withIconHaloWidth(iconHaloWidth)
    }

    override fun setIconHaloBlur(iconHaloBlur: Float) {
        symbolOptions.withIconHaloBlur(iconHaloBlur)
    }

    override fun setTextOpacity(textOpacity: Float) {
        symbolOptions.withTextOpacity(textOpacity)
    }

    override fun setTextColor(textColor: String?) {
        symbolOptions.withTextColor(textColor)
    }

    override fun setTextHaloColor(textHaloColor: String?) {
        symbolOptions.withTextHaloColor(textHaloColor)
    }

    override fun setTextHaloWidth(textHaloWidth: Float) {
        symbolOptions.withTextHaloWidth(textHaloWidth)
    }

    override fun setTextHaloBlur(textHaloBlur: Float) {
        symbolOptions.withTextHaloBlur(textHaloBlur)
    }

    override fun setGeometry(geometry: LatLng) {
        symbolOptions.withGeometry(Point.fromLngLat(geometry.longitude, geometry.latitude))
    }

    override fun setSymbolSortKey(symbolSortKey: Float) {
        symbolOptions.withSymbolSortKey(symbolSortKey)
    }

    override fun setDraggable(draggable: Boolean) {
        symbolOptions.withDraggable(draggable)
    }

    val customImage: Boolean = false

    companion object {
        private const val customImage = false
    }

    init {
        symbolOptions = SymbolOptions()
    }
}
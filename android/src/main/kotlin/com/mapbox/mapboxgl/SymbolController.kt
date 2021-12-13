// This file is generated.
// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
package com.mapbox.mapboxgl

import android.graphics.Color
import android.graphics.PointF
import com.mapbox.geojson.Point
import com.mapbox.mapboxsdk.geometry.LatLng
import com.mapbox.mapboxsdk.plugins.annotation.Symbol
import com.mapbox.mapboxsdk.plugins.annotation.SymbolManager

/**
 * Controller of a single Symbol on the map.
 */
internal class SymbolController(val symbol: Symbol, private val consumeTapEvents: Boolean, private val onTappedListener: OnSymbolTappedListener?) : SymbolOptionsSink {
    fun onTap(): Boolean {
        onTappedListener?.onSymbolTapped(symbol)
        return consumeTapEvents
    }

    fun remove(symbolManager: SymbolManager) {
        symbolManager.delete(symbol)
    }

    override fun setIconSize(iconSize: Float) {
        symbol.iconSize = iconSize
    }

    override fun setIconImage(iconImage: String?) {
        symbol.iconImage = iconImage
    }

    override fun setIconRotate(iconRotate: Float) {
        symbol.iconRotate = iconRotate
    }

    override fun setIconOffset(iconOffset: FloatArray) {
        symbol.iconOffset = PointF(iconOffset[0], iconOffset[1])
    }

    override fun setIconAnchor(iconAnchor: String?) {
        symbol.iconAnchor = iconAnchor
    }

    override fun setFontNames(fontNames: Array<String?>?) {
        symbol.textFont = fontNames
    }

    override fun setTextField(textField: String?) {
        symbol.textField = textField
    }

    override fun setTextSize(textSize: Float) {
        symbol.textSize = textSize
    }

    override fun setTextMaxWidth(textMaxWidth: Float) {
        symbol.textMaxWidth = textMaxWidth
    }

    override fun setTextLetterSpacing(textLetterSpacing: Float) {
        symbol.textLetterSpacing = textLetterSpacing
    }

    override fun setTextJustify(textJustify: String?) {
        symbol.textJustify = textJustify
    }

    override fun setTextAnchor(textAnchor: String?) {
        symbol.textAnchor = textAnchor
    }

    override fun setTextRotate(textRotate: Float) {
        symbol.textRotate = textRotate
    }

    override fun setTextTransform(textTransform: String?) {
        symbol.textTransform = textTransform
    }

    override fun setTextOffset(textOffset: FloatArray) {
        symbol.textOffset = PointF(textOffset[0], textOffset[1])
    }

    override fun setIconOpacity(iconOpacity: Float) {
        symbol.iconOpacity = iconOpacity
    }

    override fun setIconColor(iconColor: String?) {
        symbol.setIconColor(Color.parseColor(iconColor))
    }

    override fun setIconHaloColor(iconHaloColor: String?) {
        symbol.setIconHaloColor(Color.parseColor(iconHaloColor))
    }

    override fun setIconHaloWidth(iconHaloWidth: Float) {
        symbol.iconHaloWidth = iconHaloWidth
    }

    override fun setIconHaloBlur(iconHaloBlur: Float) {
        symbol.iconHaloBlur = iconHaloBlur
    }

    override fun setTextOpacity(textOpacity: Float) {
        symbol.textOpacity = textOpacity
    }

    override fun setTextColor(textColor: String?) {
        symbol.setTextColor(Color.parseColor(textColor))
    }

    override fun setTextHaloColor(textHaloColor: String?) {
        symbol.setTextHaloColor(Color.parseColor(textHaloColor))
    }

    override fun setTextHaloWidth(textHaloWidth: Float) {
        symbol.textHaloWidth = textHaloWidth
    }

    override fun setTextHaloBlur(textHaloBlur: Float) {
        symbol.textHaloBlur = textHaloBlur
    }

    override fun setSymbolSortKey(symbolSortKey: Float) {
        symbol.symbolSortKey = symbolSortKey
    }

    override fun setGeometry(geometry: LatLng) {
        symbol.geometry = Point.fromLngLat(geometry.longitude, geometry.latitude)
    }

    fun getGeometry(): LatLng {
        val point = symbol.geometry
        return LatLng(point.latitude(), point.longitude())
    }

    override fun setDraggable(draggable: Boolean) {
        symbol.isDraggable = draggable
    }

    fun update(symbolManager: SymbolManager?) {
        symbolManager!!.update(symbol)
    }
}
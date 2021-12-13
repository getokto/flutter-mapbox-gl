// This file is generated.
// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
package com.mapbox.mapboxgl

import com.mapbox.mapboxsdk.geometry.LatLng

/**
 * Receiver of Symbol configuration options.
 */
internal interface SymbolOptionsSink {
    fun setIconSize(iconSize: Float)
    fun setIconImage(iconImage: String?)
    fun setIconRotate(iconRotate: Float)
    fun setIconOffset(iconOffset: FloatArray)
    fun setIconAnchor(iconAnchor: String?)
    fun setFontNames(fontNames: Array<String?>?)
    fun setTextField(textField: String?)
    fun setTextSize(textSize: Float)
    fun setTextMaxWidth(textMaxWidth: Float)
    fun setTextLetterSpacing(textLetterSpacing: Float)
    fun setTextJustify(textJustify: String?)
    fun setTextAnchor(textAnchor: String?)
    fun setTextRotate(textRotate: Float)
    fun setTextTransform(textTransform: String?)
    fun setTextOffset(textOffset: FloatArray)
    fun setIconOpacity(iconOpacity: Float)
    fun setIconColor(iconColor: String?)
    fun setIconHaloColor(iconHaloColor: String?)
    fun setIconHaloWidth(iconHaloWidth: Float)
    fun setIconHaloBlur(iconHaloBlur: Float)
    fun setTextOpacity(textOpacity: Float)
    fun setTextColor(textColor: String?)
    fun setTextHaloColor(textHaloColor: String?)
    fun setTextHaloWidth(textHaloWidth: Float)
    fun setTextHaloBlur(textHaloBlur: Float)
    fun setGeometry(geometry: LatLng)
    fun setSymbolSortKey(symbolSortKey: Float)
    fun setDraggable(draggable: Boolean)
}
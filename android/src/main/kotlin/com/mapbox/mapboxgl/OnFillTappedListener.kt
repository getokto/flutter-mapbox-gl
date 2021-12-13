package com.mapbox.mapboxgl

import com.mapbox.mapboxsdk.plugins.annotation.Fill

interface OnFillTappedListener {
    fun onFillTapped(fill: Fill)
}
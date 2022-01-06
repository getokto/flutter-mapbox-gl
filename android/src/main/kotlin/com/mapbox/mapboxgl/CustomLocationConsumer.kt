package com.mapbox.mapboxgl

import android.animation.ValueAnimator
import android.location.Location
import com.mapbox.maps.plugin.locationcomponent.LocationConsumer

interface CustomLocationConsumer : LocationConsumer {
    fun onExtendedLocationUpdated(location: Location, options: (ValueAnimator.() -> Unit)? = null)
}
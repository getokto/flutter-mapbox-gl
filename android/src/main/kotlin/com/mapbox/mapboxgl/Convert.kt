// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
package com.mapbox.mapboxgl

import com.google.android.gms.maps.model.CameraPosition
import com.google.android.gms.maps.model.LatLng
import com.google.android.gms.maps.model.LatLngBounds
import com.google.gson.GsonBuilder
import com.google.gson.JsonParser
import com.mapbox.geojson.Point
import com.mapbox.geojson.Polygon
import com.mapbox.maps.MapboxMap
import java.util.*

/**
 * Conversions between JSON-like values and MapboxMaps data types.
 */
internal object Convert {
    private const val TAG = "Convert"

    //  private static BitmapDescriptor toBitmapDescriptor(Object o) {
    //    final List<?> data = toList(o);
    //    switch (toString(data.get(0))) {
    //      case "defaultMarker":
    //        if (data.size() == 1) {
    //          return BitmapDescriptorFactory.defaultMarker();
    //        } else {
    //          return BitmapDescriptorFactory.defaultMarker(toFloat(data.get(1)));
    //        }
    //      case "fromAsset":
    //        if (data.size() == 2) {
    //          return BitmapDescriptorFactory.fromAsset(
    //              FlutterMain.getLookupKeyForAsset(toString(data.get(1))));
    //        } else {
    //          return BitmapDescriptorFactory.fromAsset(
    //              FlutterMain.getLookupKeyForAsset(toString(data.get(1)), toString(data.get(2))));
    //        }
    //      default:
    //        throw new IllegalArgumentException("Cannot interpret " + o + " as BitmapDescriptor");
    //    }
    //  }
    private fun toBoolean(o: Any): Boolean {
        return o as Boolean
    }

    fun toCameraPosition(o: Any?): CameraPosition {
        val data = toMap(o)
        val builder = CameraPosition.Builder()
        builder.bearing(toFloat(data!!.get("bearing")))
        builder.target(toLatLng(data.get("target")))
        builder.tilt(toFloat(data.get("tilt")))
        builder.zoom(toFloat(data.get("zoom")))
        return builder.build()
    }

    fun toAnnotationOrder(o: Any?): List<String?> {
        val data = toList(o)
        val annotations: MutableList<String?> = arrayListOf();
        for (index in data!!.indices) {
            annotations.add(toString(data!![index]!!))
        }
        return annotations
    }

    fun toAnnotationConsumeTapEvents(o: Any?): List<String?> {
        return toAnnotationOrder(o)
    }

    fun isScrollByCameraUpdate(o: Any?): Boolean {
        return toString(toList(o)!![0]!!) == "scrollBy"
    }

//    fun toCameraUpdate(o: Any?, mapboxMap: MapboxMap?, density: Float): CameraUpdate? {
//        val data = toList(o)
//        return when (toString(data!![0]!!)) {
//            "newCameraPosition" -> CameraUpdateFactory.newCameraPosition(toCameraPosition(data[1]))
//            "newLatLng" -> CameraUpdateFactory.newLatLng(toLatLng(data[1]))
//            "newLatLngBounds" -> CameraUpdateFactory.newLatLngBounds(toLatLngBounds(data[1])!!, toPixels(data[2]!!, density),
//                    toPixels(data[3]!!, density), toPixels(data[4]!!, density), toPixels(data[5]!!, density))
//            "newLatLngZoom" -> CameraUpdateFactory.newLatLngZoom(toLatLng(data[1]), toFloat(data[2]).toDouble())
//            "scrollBy" -> {
//                mapboxMap!!.scrollBy(
//                        toFractionalPixels(data[1]!!, density),
//                        toFractionalPixels(data[2]!!, density)
//                )
//                null
//            }
//            "zoomBy" -> if (data.size == 2) {
//                CameraUpdateFactory.zoomBy(toFloat(data[1]).toDouble())
//            } else {
//                CameraUpdateFactory.zoomBy(toFloat(data[1]).toDouble(), toPoint(data[2]!!, density))
//            }
//            "zoomIn" -> CameraUpdateFactory.zoomIn()
//            "zoomOut" -> CameraUpdateFactory.zoomOut()
//            "zoomTo" -> CameraUpdateFactory.zoomTo(toFloat(data[1]).toDouble())
//            "bearingTo" -> CameraUpdateFactory.bearingTo(toFloat(data[1]).toDouble())
//            "pitchTo" -> CameraUpdateFactory.tiltTo(toFloat(data[1]).toDouble())
//            else -> throw IllegalArgumentException("Cannot interpret $o as CameraUpdate")
//        }
//    }

    private fun toDouble(o: Any): Double {
        return (o as Number).toDouble()
    }

    private fun toFloat(o: Any?): Float {
        return (o as Number?)?.toFloat() ?: (0.0).toFloat()
    }

    private fun toFloatWrapper(o: Any?): Float? {
        return if (o == null) null else toFloat(o)
    }

    fun toInt(o: Any): Int {
        return (o as Number).toInt()
    }

//    fun toJson(position: CameraPosition?): Any? {
//        if (position == null) {
//            return null
//        }
//        val data: MutableMap<String, Any> = HashMap()
//        data.put("bearing", position.bearing)
//        data.put("target", toJson(position.target))
//        data.put("pitch", position.tilt)
//        data.put("zoom", position.zoom)
//        return data
//    }

    private fun toJson(latLng: LatLng): Any {
        return Arrays.asList(latLng.latitude, latLng.longitude)
    }

    private fun toLatLng(o: Any?): LatLng {
        val data = toList(o)
        return LatLng(toDouble(data!![0]!!), toDouble(data[1]!!))
    }

    private fun toLatLngBounds(o: Any?): LatLngBounds? {
        if (o == null) {
            return null
        }
        val data = toList(o)
        val boundsArray = arrayOf(toLatLng(data!![0]), toLatLng(data[1]))
        val bounds = listOf(*boundsArray)
        val builder = LatLngBounds.Builder()
        for(bound in bounds) {
            builder.include(bound)
        }
        return builder.build()
    }

    fun toLatLngList(o: Any?): List<LatLng>? {
        if (o == null) {
            return null
        }
        val data = toList(o)
        val latLngList: MutableList<LatLng> = ArrayList()
        for (i in data!!.indices) {
            val coords = toList(data!![i])
            latLngList.add(LatLng(toDouble(coords!![0]!!), toDouble(coords[1]!!)))
        }
        return latLngList
    }

    private fun toLatLngListList(o: Any?): List<List<LatLng>?>? {
        if (o == null) {
            return null
        }
        val data = toList(o)
        val latLngListList: MutableList<List<LatLng>?> = ArrayList()
        for (i in data!!.indices) {
            val latLngList = toLatLngList(data!![i])
            latLngListList.add(latLngList)
        }
        return latLngListList
    }

    fun interpretListLatLng(geometry: List<List<LatLng>?>?): Polygon {
        val points: MutableList<List<Point>> = ArrayList(geometry!!.size)
        for (innerGeometry in geometry) {
            val innerPoints: MutableList<Point> = ArrayList(innerGeometry!!.size)
            for (latLng in innerGeometry) {
                innerPoints.add(Point.fromLngLat(latLng.longitude, latLng.latitude))
            }
            points.add(innerPoints)
        }
        return Polygon.fromLngLats(points)
    }

    private fun toList(o: Any?): List<*>? {
        return o as List<*>?
    }

    fun toLong(o: Any): Long {
        return (o as Number).toLong()
    }

    fun toMap(o: Any?): Map<*, *>? {
        return o as Map<*, *>?
    }

    private fun toFractionalPixels(o: Any, density: Float): Float {
        return toFloat(o) * density
    }

    fun toPixels(o: Any, density: Float): Int {
        return toFractionalPixels(o, density).toInt()
    }

    private fun toPoint(o: Any, density: Float): android.graphics.Point {
        val data = toList(o)
        return android.graphics.Point(toPixels(data!![0]!!, density), toPixels(data[1]!!, density))
    }

    private fun toString(o: Any): String {
        return o as String
    }

    fun interpretMapboxMapOptions(o: Any?, sink: MapboxMapOptionsSink) {
        val data = toMap(o)
        val cameraTargetBounds = data!!.get("cameraTargetBounds")
        if (cameraTargetBounds != null) {
            val targetData = toList(cameraTargetBounds)
            sink.setCameraTargetBounds(toLatLngBounds(targetData!![0]))
        }
        val compassEnabled = data.get("compassEnabled")
        if (compassEnabled != null) {
            sink.setCompassEnabled(toBoolean(compassEnabled))
        }
        val styleString = data.get("styleString")
        if (styleString != null) {
            sink.setStyleString(toString(styleString))
        }
        val minMaxZoomPreference = data.get("minMaxZoomPreference")
        if (minMaxZoomPreference != null) {
            val zoomPreferenceData = toList(minMaxZoomPreference)
            sink.setMinMaxZoomPreference( //
                    toFloatWrapper(zoomPreferenceData!![0]),  //
                    toFloatWrapper(zoomPreferenceData[1]))
        }
        val rotateGesturesEnabled = data.get("rotateGesturesEnabled")
        if (rotateGesturesEnabled != null) {
            sink.setRotateGesturesEnabled(toBoolean(rotateGesturesEnabled))
        }
        val scrollGesturesEnabled = data.get("scrollGesturesEnabled")
        if (scrollGesturesEnabled != null) {
            sink.setScrollGesturesEnabled(toBoolean(scrollGesturesEnabled))
        }
        val tiltGesturesEnabled = data.get("tiltGesturesEnabled")
        if (tiltGesturesEnabled != null) {
            sink.setTiltGesturesEnabled(toBoolean(tiltGesturesEnabled))
        }
        val trackCameraPosition = data.get("trackCameraPosition")
        if (trackCameraPosition != null) {
            sink.setTrackCameraPosition(toBoolean(trackCameraPosition))
        }
        val zoomGesturesEnabled = data.get("zoomGesturesEnabled")
        if (zoomGesturesEnabled != null) {
            sink.setZoomGesturesEnabled(toBoolean(zoomGesturesEnabled))
        }
        val myLocationEnabled = data.get("myLocationEnabled")
        if (myLocationEnabled != null) {
            sink.setMyLocationEnabled(toBoolean(myLocationEnabled))
        }
        val myLocationTrackingMode = data.get("myLocationTrackingMode")
        if (myLocationTrackingMode != null) {
            sink.setMyLocationTrackingMode(toInt(myLocationTrackingMode))
        }
        val myLocationRenderMode = data.get("myLocationRenderMode")
        if (myLocationRenderMode != null) {
            sink.setMyLocationRenderMode(toInt(myLocationRenderMode))
        }
        val logoViewMargins = data.get("logoViewMargins")
        if (logoViewMargins != null) {
            val logoViewMarginsData = toList(logoViewMargins)
            sink.setLogoViewMargins(toInt(logoViewMarginsData!![0]!!), toInt(logoViewMarginsData[1]!!))
        }
        val compassGravity = data.get("compassViewPosition")
        if (compassGravity != null) {
            sink.setCompassGravity(toInt(compassGravity))
        }
        val compassViewMargins = data.get("compassViewMargins")
        if (compassViewMargins != null) {
            val compassViewMarginsData = toList(compassViewMargins)
            sink.setCompassViewMargins(toInt(compassViewMarginsData!![0]!!), toInt(compassViewMarginsData[1]!!))
        }
        val attributionButtonMargins = data.get("attributionButtonMargins")
        if (attributionButtonMargins != null) {
            val attributionButtonMarginsData = toList(attributionButtonMargins)
            sink.setAttributionButtonMargins(toInt(attributionButtonMarginsData!![0]!!), toInt(attributionButtonMarginsData[1]!!))
        }
    }

//    fun interpretSymbolOptions(o: Any?, sink: SymbolOptionsSink) {
//        val data = toMap(o)
//        val iconSize = data!!.get("iconSize")
//        if (iconSize != null) {
//            sink.setIconSize(toFloat(iconSize))
//        }
//        val iconImage = data.get("iconImage")
//        if (iconImage != null) {
//            sink.setIconImage(toString(iconImage))
//        }
//        val iconRotate = data.get("iconRotate")
//        if (iconRotate != null) {
//            sink.setIconRotate(toFloat(iconRotate))
//        }
//        val iconOffset = data.get("iconOffset")
//        if (iconOffset != null) {
//            sink.setIconOffset(floatArrayOf(toFloat(toList(iconOffset)!![0]), toFloat(toList(iconOffset)!![1])))
//        }
//        val iconAnchor = data.get("iconAnchor")
//        if (iconAnchor != null) {
//            sink.setIconAnchor(toString(iconAnchor))
//        }
//        val fontNames = data.get("fontNames") as ArrayList<*>?
//        if (fontNames != null) {
//            sink.setFontNames(fontNames.toTypedArray() as Array<String?>?)
//        }
//        val textField = data.get("textField")
//        if (textField != null) {
//            sink.setTextField(toString(textField))
//        }
//        val textSize = data.get("textSize")
//        if (textSize != null) {
//            sink.setTextSize(toFloat(textSize))
//        }
//        val textMaxWidth = data.get("textMaxWidth")
//        if (textMaxWidth != null) {
//            sink.setTextMaxWidth(toFloat(textMaxWidth))
//        }
//        val textLetterSpacing = data.get("textLetterSpacing")
//        if (textLetterSpacing != null) {
//            sink.setTextLetterSpacing(toFloat(textLetterSpacing))
//        }
//        val textJustify = data.get("textJustify")
//        if (textJustify != null) {
//            sink.setTextJustify(toString(textJustify))
//        }
//        val textAnchor = data.get("textAnchor")
//        if (textAnchor != null) {
//            sink.setTextAnchor(toString(textAnchor))
//        }
//        val textRotate = data.get("textRotate")
//        if (textRotate != null) {
//            sink.setTextRotate(toFloat(textRotate))
//        }
//        val textTransform = data.get("textTransform")
//        if (textTransform != null) {
//            sink.setTextTransform(toString(textTransform))
//        }
//        val textOffset = data.get("textOffset")
//        if (textOffset != null) {
//            sink.setTextOffset(floatArrayOf(toFloat(toList(textOffset)!![0]), toFloat(toList(textOffset)!![1])))
//        }
//        val iconOpacity = data.get("iconOpacity")
//        if (iconOpacity != null) {
//            sink.setIconOpacity(toFloat(iconOpacity))
//        }
//        val iconColor = data.get("iconColor")
//        if (iconColor != null) {
//            sink.setIconColor(toString(iconColor))
//        }
//        val iconHaloColor = data.get("iconHaloColor")
//        if (iconHaloColor != null) {
//            sink.setIconHaloColor(toString(iconHaloColor))
//        }
//        val iconHaloWidth = data.get("iconHaloWidth")
//        if (iconHaloWidth != null) {
//            sink.setIconHaloWidth(toFloat(iconHaloWidth))
//        }
//        val iconHaloBlur = data.get("iconHaloBlur")
//        if (iconHaloBlur != null) {
//            sink.setIconHaloBlur(toFloat(iconHaloBlur))
//        }
//        val textOpacity = data.get("textOpacity")
//        if (textOpacity != null) {
//            sink.setTextOpacity(toFloat(textOpacity))
//        }
//        val textColor = data.get("textColor")
//        if (textColor != null) {
//            sink.setTextColor(toString(textColor))
//        }
//        val textHaloColor = data.get("textHaloColor")
//        if (textHaloColor != null) {
//            sink.setTextHaloColor(toString(textHaloColor))
//        }
//        val textHaloWidth = data.get("textHaloWidth")
//        if (textHaloWidth != null) {
//            sink.setTextHaloWidth(toFloat(textHaloWidth))
//        }
//        val textHaloBlur = data.get("textHaloBlur")
//        if (textHaloBlur != null) {
//            sink.setTextHaloBlur(toFloat(textHaloBlur))
//        }
//        val geometry = data.get("geometry")
//        if (geometry != null) {
//            sink.setGeometry(toLatLng(geometry))
//        }
//        val symbolSortKey = data.get("zIndex")
//        if (symbolSortKey != null) {
//            sink.setSymbolSortKey(toFloat(symbolSortKey))
//        }
//        val draggable = data.get("draggable")
//        if (draggable != null) {
//            sink.setDraggable(toBoolean(draggable))
//        }
//    }

//    fun interpretCircleOptions(o: Any?, sink: CircleOptionsSink) {
//        val data = toMap(o)
//        val circleRadius = data!!.get("circleRadius")
//        if (circleRadius != null) {
//            sink.setCircleRadius(toFloat(circleRadius))
//        }
//        val circleColor = data.get("circleColor")
//        if (circleColor != null) {
//            sink.setCircleColor(toString(circleColor))
//        }
//        val circleBlur = data.get("circleBlur")
//        if (circleBlur != null) {
//            sink.setCircleBlur(toFloat(circleBlur))
//        }
//        val circleOpacity = data.get("circleOpacity")
//        if (circleOpacity != null) {
//            sink.setCircleOpacity(toFloat(circleOpacity))
//        }
//        val circleStrokeWidth = data.get("circleStrokeWidth")
//        if (circleStrokeWidth != null) {
//            sink.setCircleStrokeWidth(toFloat(circleStrokeWidth))
//        }
//        val circleStrokeColor = data.get("circleStrokeColor")
//        if (circleStrokeColor != null) {
//            sink.setCircleStrokeColor(toString(circleStrokeColor))
//        }
//        val circleStrokeOpacity = data.get("circleStrokeOpacity")
//        if (circleStrokeOpacity != null) {
//            sink.setCircleStrokeOpacity(toFloat(circleStrokeOpacity))
//        }
//        val geometry = data.get("geometry")
//        if (geometry != null) {
//            sink.setGeometry(toLatLng(geometry))
//        }
//        val draggable = data.get("draggable")
//        if (draggable != null) {
//            sink.setDraggable(toBoolean(draggable))
//        }
//    }
//
//    fun interpretLineOptions(o: Any?, sink: LineOptionsSink) {
//        val data = toMap(o)
//        val lineJoin = data!!.get("lineJoin")
//        if (lineJoin != null) {
//            Logger.e(TAG, "setLineJoin$lineJoin")
//            sink.setLineJoin(toString(lineJoin))
//        }
//        val lineOpacity = data.get("lineOpacity")
//        if (lineOpacity != null) {
//            Logger.e(TAG, "setLineOpacity$lineOpacity")
//            sink.setLineOpacity(toFloat(lineOpacity))
//        }
//        val lineColor = data.get("lineColor")
//        if (lineColor != null) {
//            Logger.e(TAG, "setLineColor$lineColor")
//            sink.setLineColor(toString(lineColor))
//        }
//        val lineWidth = data.get("lineWidth")
//        if (lineWidth != null) {
//            Logger.e(TAG, "setLineWidth$lineWidth")
//            sink.setLineWidth(toFloat(lineWidth))
//        }
//        val lineGapWidth = data.get("lineGapWidth")
//        if (lineGapWidth != null) {
//            Logger.e(TAG, "setLineGapWidth$lineGapWidth")
//            sink.setLineGapWidth(toFloat(lineGapWidth))
//        }
//        val lineOffset = data.get("lineOffset")
//        if (lineOffset != null) {
//            Logger.e(TAG, "setLineOffset$lineOffset")
//            sink.setLineOffset(toFloat(lineOffset))
//        }
//        val lineBlur = data.get("lineBlur")
//        if (lineBlur != null) {
//            Logger.e(TAG, "setLineBlur$lineBlur")
//            sink.setLineBlur(toFloat(lineBlur))
//        }
//        val linePattern = data.get("linePattern")
//        if (linePattern != null) {
//            Logger.e(TAG, "setLinePattern$linePattern")
//            sink.setLinePattern(toString(linePattern))
//        }
//        val geometry = data.get("geometry")
//        if (geometry != null) {
//            Logger.e(TAG, "SetGeometry")
//            sink.setGeometry(toLatLngList(geometry))
//        }
//        val draggable = data.get("draggable")
//        if (draggable != null) {
//            Logger.e(TAG, "SetDraggable")
//            sink.setDraggable(toBoolean(draggable))
//        }
//    }
//
//    fun interpretFillOptions(o: Any?, sink: FillOptionsSink) {
//        val data = toMap(o)
//        val fillOpacity = data!!.get("fillOpacity")
//        if (fillOpacity != null) {
//            sink.setFillOpacity(toFloat(fillOpacity))
//        }
//        val fillColor = data.get("fillColor")
//        if (fillColor != null) {
//            sink.setFillColor(toString(fillColor))
//        }
//        val fillOutlineColor = data.get("fillOutlineColor")
//        if (fillOutlineColor != null) {
//            sink.setFillOutlineColor(toString(fillOutlineColor))
//        }
//        val fillPattern = data.get("fillPattern")
//        if (fillPattern != null) {
//            sink.setFillPattern(toString(fillPattern))
//        }
//        val geometry = data.get("geometry")
//        if (geometry != null) {
//            sink.setGeometry(toLatLngListList(geometry))
//        }
//        val draggable = data.get("draggable")
//        if (draggable != null) {
//            sink.setDraggable(toBoolean(draggable))
//        }
//    }

//    fun interpretSymbolLayerProperties(o: Any?): Array<PropertyValue<*>> {
//        val data = toMap(o) as Map<String, Map<String, *>>?
//        val properties: MutableList<PropertyValue<*>> = mutableListOf(); //  LinkedList<Any?>()
//        val gson = GsonBuilder().setPrettyPrinting().create()
//        for ((_, value) in data!!) {
//            for ((key, value1) in value.entries) {
//                val jsonValue = gson.toJson(value1)
//                val jsonElement = JsonParser.parseString(jsonValue)
//                val expression = Expression.Converter.convert(jsonElement)
//                when (key) {
//                    "icon-allow-overlap" -> properties.add(PropertyFactory.iconAllowOverlap(expression))
//                    "icon-anchor" -> properties.add(PropertyFactory.iconAnchor(expression))
//                    "icon-color" -> properties.add(PropertyFactory.iconColor(expression))
//                    "icon-halo-blur" -> properties.add(PropertyFactory.iconHaloBlur(expression))
//                    "icon-halo-color" -> properties.add(PropertyFactory.iconHaloColor(expression))
//                    "icon-halo-width" -> properties.add(PropertyFactory.iconHaloWidth(expression))
//                    "icon-ignore-placement" -> properties.add(PropertyFactory.iconIgnorePlacement(expression))
//                    "icon-image" -> properties.add(PropertyFactory.iconImage(expression))
//                    "icon-keep-upright" -> properties.add(PropertyFactory.iconKeepUpright(expression))
//                    "icon-offset" -> properties.add(PropertyFactory.iconOffset(expression))
//                    "icon-opacity" -> properties.add(PropertyFactory.iconOpacity(expression))
//                    "icon-optional" -> properties.add(PropertyFactory.iconOptional(expression))
//                    "icon-padding" -> properties.add(PropertyFactory.iconPadding(expression))
//                    "icon-pitch-alignment" -> properties.add(PropertyFactory.iconPitchAlignment(expression))
//                    "icon-rotate" -> properties.add(PropertyFactory.iconRotate(expression))
//                    "icon-rotation-alignment" -> properties.add(PropertyFactory.iconRotationAlignment(expression))
//                    "icon-size" -> properties.add(PropertyFactory.iconSize(expression))
//                    "icon-text-fit" -> properties.add(PropertyFactory.iconTextFit(expression))
//                    "icon-text-fit-padding" -> properties.add(PropertyFactory.iconTextFitPadding(expression))
//                    "icon-translate" -> properties.add(PropertyFactory.iconTranslate(expression))
//                    "icon-translate-anchor" -> properties.add(PropertyFactory.iconTranslateAnchor(expression))
//                    "symbol-avoid-edges" -> properties.add(PropertyFactory.symbolAvoidEdges(expression))
//                    "symbol-placement" -> properties.add(PropertyFactory.symbolPlacement(expression))
//                    "symbol-sort-key" -> properties.add(PropertyFactory.symbolSortKey(expression))
//                    "symbol-spacing" -> properties.add(PropertyFactory.symbolSpacing(expression))
//                    "symbol-z-order" -> properties.add(PropertyFactory.symbolZOrder(expression))
//                    "text-allow-overlap" -> properties.add(PropertyFactory.textAllowOverlap(expression))
//                    "text-anchor" -> properties.add(PropertyFactory.textAnchor(expression))
//                    "text-color" -> properties.add(PropertyFactory.textColor(expression))
//                    "text-field" -> properties.add(PropertyFactory.textField(expression))
//                    "text-font" -> properties.add(PropertyFactory.textFont(expression))
//                    "text-halo-blur" -> properties.add(PropertyFactory.textHaloBlur(expression))
//                    "text-halo-color" -> properties.add(PropertyFactory.textHaloColor(expression))
//                    "text-halo-width" -> properties.add(PropertyFactory.textHaloWidth(expression))
//                    "text-ignore-placement" -> properties.add(PropertyFactory.textIgnorePlacement(expression))
//                    "text-justify" -> properties.add(PropertyFactory.textJustify(expression))
//                    "text-keep-upright" -> properties.add(PropertyFactory.textKeepUpright(expression))
//                    "text-letter-spacing" -> properties.add(PropertyFactory.textLetterSpacing(expression))
//                    "text-line-height" -> properties.add(PropertyFactory.textLineHeight(expression))
//                    "text-max-angle" -> properties.add(PropertyFactory.textMaxAngle(expression))
//                    "text-max-width" -> properties.add(PropertyFactory.textMaxWidth(expression))
//                    "text-offset" -> properties.add(PropertyFactory.textOffset(expression))
//                    "text-opacity" -> properties.add(PropertyFactory.textOpacity(expression))
//                    "text-optional" -> properties.add(PropertyFactory.textOptional(expression))
//                    "text-padding" -> properties.add(PropertyFactory.textPadding(expression))
//                    "text-pitch-alignment" -> properties.add(PropertyFactory.textPitchAlignment(expression))
//                    "text-radial-offset" -> properties.add(PropertyFactory.textRadialOffset(expression))
//                    "text-rotate" -> properties.add(PropertyFactory.textRotate(expression))
//                    "text-rotation-alignment" -> properties.add(PropertyFactory.textRotationAlignment(expression))
//                    "text-size" -> properties.add(PropertyFactory.textSize(expression))
//                    "text-transform" -> properties.add(PropertyFactory.textTransform(expression))
//                    "text-translate" -> properties.add(PropertyFactory.textTranslate(expression))
//                    "text-translate-anchor" -> properties.add(PropertyFactory.textTranslateAnchor(expression))
//                    "text-variable-anchor" -> properties.add(PropertyFactory.textVariableAnchor(expression))
//                    "text-writing-mode" -> properties.add(PropertyFactory.textWritingMode(expression))
//                    else -> {
//                    }
//                }
//            }
//        }
//        return properties.toTypedArray()
//    }
//
//    fun interpretLineLayerProperties(o: Any?): Array<PropertyValue<*>> {
//        val data = toMap(o) as Map<String, Map<String, *>>?
//        val properties: MutableList<PropertyValue<*>> = mutableListOf(); // LinkedList<Any?>()
//        val gson = GsonBuilder().setPrettyPrinting().create()
//        for ((_, value) in data!!) {
//            for ((key, value1) in value.entries) {
//                val jsonValue = gson.toJson(value1)
//                val jsonElement = JsonParser.parseString(jsonValue)
//                val expression = Expression.Converter.convert(jsonElement)
//                when (key) {
//                    "line-blur" -> properties.add(PropertyFactory.lineBlur(expression))
//                    "line-cap" -> properties.add(PropertyFactory.lineCap(expression))
//                    "line-color" -> properties.add(PropertyFactory.lineColor(expression))
//                    "line-dasharray" -> properties.add(PropertyFactory.lineDasharray(expression))
//                    "line-gap-width" -> properties.add(PropertyFactory.lineGapWidth(expression))
//                    "line-gradient" -> properties.add(PropertyFactory.lineGradient(expression))
//                    "line-join" -> properties.add(PropertyFactory.lineJoin(expression))
//                    "line-miter-limit" -> properties.add(PropertyFactory.lineMiterLimit(expression))
//                    "line-offset" -> properties.add(PropertyFactory.lineOffset(expression))
//                    "line-pattern" -> properties.add(PropertyFactory.linePattern(expression))
//                    "line-round-limit" -> properties.add(PropertyFactory.lineRoundLimit(expression))
//                    "line-translate" -> properties.add(PropertyFactory.lineTranslate(expression))
//                    "line-translate-anchor" -> properties.add(PropertyFactory.lineTranslateAnchor(expression))
//                    "line-width" -> properties.add(PropertyFactory.lineWidth(expression))
//                    else -> {
//                    }
//                }
//            }
//        }
//        return properties.toTypedArray()
//    }
}
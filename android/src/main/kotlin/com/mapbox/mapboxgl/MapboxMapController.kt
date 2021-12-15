// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
package com.mapbox.mapboxgl

import android.Manifest
import android.annotation.SuppressLint
import android.content.Context
import android.content.pm.PackageManager
import android.graphics.BitmapFactory
import android.os.Process
import android.view.Gravity
import android.view.View
import androidx.lifecycle.DefaultLifecycleObserver
import androidx.lifecycle.LifecycleOwner
import app.loup.streams_channel.StreamsChannel
import com.google.gson.Gson
import com.google.gson.reflect.TypeToken
import com.mapbox.bindgen.Value
import com.mapbox.geojson.Point
import com.mapbox.maps.*
import com.mapbox.maps.extension.observable.eventdata.StyleLoadedEventData
import com.mapbox.maps.extension.style.sources.addSource
import com.mapbox.maps.extension.style.sources.generated.GeoJsonSource
import com.mapbox.maps.plugin.animation.MapAnimationOptions
import com.mapbox.maps.plugin.animation.flyTo
import com.mapbox.maps.plugin.attribution.attribution
import com.mapbox.maps.plugin.compass.compass
import com.mapbox.maps.plugin.delegates.listeners.OnStyleLoadedListener
import com.mapbox.maps.plugin.gestures.OnMapClickListener
import com.mapbox.maps.plugin.gestures.gestures
import com.mapbox.maps.plugin.logo.logo
import com.mapbox.maps.plugin.scalebar.scalebar
import io.flutter.Log
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.platform.PlatformView
import org.json.JSONObject
import java.util.*


/**
 * Controller of a single MapboxMaps MapView instance.
 */
@SuppressLint("MissingPermission")
internal class MapboxMapController(
        id: Int,
        context: Context,
        messenger: BinaryMessenger?,
        params: Map<String, Any>) : DefaultLifecycleObserver, OnMapClickListener, OnStyleLoadedListener, MapboxMapOptionsSink, MethodCallHandler, PlatformView {
    private val id: Int = id
    private var methodChannel: MethodChannel
    private var streamChannel: StreamsChannel

    private var mapView: MapView
    private var trackCameraPosition = false
    private var myLocationEnabled = false
    private var myLocationTrackingMode = 0
    private var myLocationRenderMode = 0
    private var disposed = false
    private var eventChannel: EventChannel? = null
    private val density: Float = context.resources.displayMetrics.density
    private val context: Context = context

    private val tappableLayers = HashSet<String>()
    override fun getView(): View {
        return mapView
    }


    override fun setStyleString(styleString: String?) {
        mapView.getMapboxMap().apply {
            // Check if json, url, absolute path or asset path:
            if (styleString == null || styleString.isEmpty()) {
                Log.e(TAG, "setStyleString - string empty or null")
            } else if (styleString.startsWith("{") || styleString.startsWith("[")) {
                loadStyleJson(styleString, onStyleLoaded = null);
                // setStyle(Style.Builder().fromJson(styleString), onStyleLoadedCallback)
            } else if (styleString.startsWith("/")) {
                // Absolute path
                loadStyleUri("file://$styleString")
            } else if (!styleString.startsWith("http://") &&
                    !styleString.startsWith("https://") &&
                    !styleString.startsWith("mapbox://")) {
                // We are assuming that the style will be loaded from an asset here.
                val key: String = MapboxMapsPlugin.flutterAssets!!.getAssetFilePathByName(styleString)
                loadStyleUri("asset://$key")
            } else {
                loadStyleUri(styleString)
            }
        }
    }


    private fun addGeoJsonSource(sourceName: String, geoJson: String) {
        mapView.getMapboxMap().getStyle()?.let { style ->
            val sourceBuilder = GeoJsonSource.Builder(sourceName)
            sourceBuilder.data(geoJson)
            style.addSource(sourceBuilder.build())
        }
    }

    private fun addVectorSource(sourceName: String, properties: HashMap<String, *>) {

        mapView.getMapboxMap().getStyle()?.let { style ->
            val sourceJson = JSONObject(properties).toString()

            val sourceValue = Value.fromJson(sourceJson)

            style.addStyleSource(sourceName, sourceValue.value!!)
        }
    }

    private fun updateLayer(layerName: String,
                            properties: HashMap<String, Any?>) {
        mapView.getMapboxMap().getStyle()?.let { style ->
            val json = JSONObject(properties).toString()
            val layerValue = Value.fromJson(json)
            style.setStyleLayerProperties(layerName, layerValue.value!!)
        }
    }

    private fun addSymbolLayer(layerName: String,
                               sourceName: String,
                               sourceLayer: String?,
                               properties: HashMap<String, Any?>) {
        mapView.getMapboxMap().getStyle()?.let { style ->
            val map: HashMap<String, Any> = hashMapOf(
                    "id" to layerName,
                    "type" to "symbol",
                    "source" to sourceName,
                    "source-layer" to (sourceLayer ?: "")
            )

            val json = JSONObject(map + properties).toString()
            val layerValue = Value.fromJson(json)
            style.addStyleLayer(layerValue.value!!, null)
        }
    }

    private fun addLineLayer(layerName: String,
                             sourceName: String,
                             sourceLayer: String?,
                             properties: HashMap<String, Any?>) {

        mapView.getMapboxMap().getStyle()?.let { style ->
            val map: HashMap<String, Any> = hashMapOf(
                    "id" to layerName,
                    "type" to "line",
                    "source" to sourceName,
                    "source-layer" to (sourceLayer ?: "")
            )

            val json = JSONObject(map + properties).toString()
            val layerValue = Value.fromJson(json)
            style.addStyleLayer(layerValue.value!!, null)
        }
    }

    private fun addCircleLayer(layerName: String,
                               sourceName: String,
                               sourceLayer: String?,
                               properties: HashMap<String, Any?>) {

        mapView.getMapboxMap().getStyle()?.let { style ->
            val map: HashMap<String, Any> = hashMapOf(
                    "id" to layerName,
                    "type" to "circle",
                    "source" to sourceName,
                    "source-layer" to (sourceLayer ?: "")
            )

            val json = JSONObject(map + properties).toString()
            val layerValue = Value.fromJson(json)
            style.addStyleLayer(layerValue.value!!, null)
        }
    }


    private fun addImage(name: String, bytes: ByteArray, length: Int, sdf: Boolean = false) {
        mapView.getMapboxMap().getStyle()?.let { style ->
            val bitmap = BitmapFactory.decodeByteArray(bytes, 0, length)
            style.addImage(name, bitmap, sdf)
        }
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "map#waitForMap" -> {
                result.success(null)
            }
            "map#update" -> {
                Convert.interpretMapboxMapOptions(call.argument<HashMap<String, Any?>>("options")!!, this)
                result.success(Convert.toJson(mapView.getMapboxMap().cameraState))
            }
//            "map#updateMyLocationTrackingMode" -> {
//                val myLocationTrackingMode = call.argument<Int>("mode")!!
//                setMyLocationTrackingMode(myLocationTrackingMode)
//                result.success(null)
//            }
//            "map#matchMapLanguageWithDeviceDefault" -> {
//                try {
//                    localizationPlugin!!.matchMapLanguageWithDeviceDefault()
//                    result.success(null)
//                } catch (exception: RuntimeException) {
//                    Log.d(TAG, exception.toString())
//                    result.error("MAPBOX LOCALIZATION PLUGIN ERROR", exception.toString(), null)
//                }
//            }
//            "map#setMapLanguage" -> {
//                val language = call.argument<String>("language")
//                try {
//                    localizationPlugin!!.setMapLanguage(language)
//                    result.success(null)
//                } catch (exception: RuntimeException) {
//                    Log.d(TAG, exception.toString())
//                    result.error("MAPBOX LOCALIZATION PLUGIN ERROR", exception.toString(), null)
//                }
//            }
//            "map#getVisibleRegion" -> {
//                val reply: MutableMap<String, Any> = HashMap()
//                val visibleRegion = mapboxMap!!.projection.visibleRegion
//                reply.put("sw", Arrays.asList(visibleRegion.nearLeft.latitude, visibleRegion.nearLeft.longitude))
//                reply.put("ne", Arrays.asList(visibleRegion.farRight.latitude, visibleRegion.farRight.longitude))
//                result.success(reply)
//            }
//            "map#toScreenLocation" -> {
//                val reply: MutableMap<String, Any> = HashMap()
//                val pointf = mapboxMap!!.projection.toScreenLocation(LatLng(call.argument("latitude")!!, call.argument("longitude")!!))
//                reply.put("x", pointf.x)
//                reply.put("y", pointf.y)
//                result.success(reply)
//            }
//            "map#toScreenLocationBatch" -> {
//                val param = call.argument<Any>("coordinates") as DoubleArray?
//                val reply = DoubleArray(param!!.size)
//                var i = 0
//                while (i < param.size) {
//                    val pointf = mapboxMap!!.projection.toScreenLocation(LatLng(param[i], param[i + 1]))
//                    reply[i] = pointf.x.toDouble()
//                    reply[i + 1] = pointf.y.toDouble()
//                    i += 2
//                }
//                result.success(reply)
//            }
//            "map#toLatLng" -> {
//                val reply: MutableMap<String, Any> = HashMap()
//                val latlng = mapboxMap!!.projection.fromScreenLocation(PointF((call.argument<Any>("x") as Double?)!!.toFloat(), (call.argument<Any>("y") as Double?)!!.toFloat()))
//                reply.put("latitude", latlng.latitude)
//                reply.put("longitude", latlng.longitude)
//                result.success(reply)
//            }
//            "map#getMetersPerPixelAtLatitude" -> {
//                val reply: MutableMap<String, Any> = HashMap()
//                val retVal = mapboxMap!!.projection.getMetersPerPixelAtLatitude((call.argument<Any>("latitude") as Double?)!!)
//                reply.put("metersperpixel", retVal)
//                result.success(reply)
//            }
            "camera#move" -> {
                val cameraUpdate = Convert.toCameraUpdate(call.argument("cameraUpdate"), mapView.getMapboxMap())

                cameraUpdate?.let {
                    mapView.getMapboxMap().setCamera(cameraUpdate)
                    result.success(true)
                } ?: result.success(false)
            }
            "camera#animate" -> {
                val cameraUpdate = Convert.toCameraUpdate(call.argument("cameraUpdate"), mapView.getMapboxMap())
                val durationTime = call.argument<Long?>("duration") ?: 300
                cameraUpdate?.let {
                    mapView.getMapboxMap().flyTo(cameraUpdate, MapAnimationOptions.mapAnimationOptions {
                        duration(durationTime)
                    })
                    result.success(true)
                } ?: result.success(false)


            }
//            "map#queryRenderedFeatures" -> {
//                val reply: MutableMap<String, Any> = HashMap()
//                val features: List<Feature>
//                val layerIds: Array<String> = (call.argument<Any>("layerIds") as List<String>).toTypedArray<String>()
//                val filter = call.argument<List<Any>>("filter")
//                val jsonElement = if (filter == null) null else Gson().toJsonTree(filter)
//                var jsonArray: JsonArray? = null
//                if (jsonElement != null && jsonElement.isJsonArray) {
//                    jsonArray = jsonElement.asJsonArray
//                }
//                val filterExpression = if (jsonArray == null) null else Expression.Converter.convert(jsonArray)
//                features = if (call.hasArgument("x")) {
//                    val x = call.argument<Double>("x")
//                    val y = call.argument<Double>("y")
//                    val pixel = PointF(x!!.toFloat(), y!!.toFloat())
//                    mapboxMap!!.queryRenderedFeatures(pixel, filterExpression, *layerIds)
//                } else {
//                    val left = call.argument<Double>("left")
//                    val top = call.argument<Double>("top")
//                    val right = call.argument<Double>("right")
//                    val bottom = call.argument<Double>("bottom")
//                    val rectF = RectF(left!!.toFloat(), top!!.toFloat(), right!!.toFloat(), bottom!!.toFloat())
//                    mapboxMap!!.queryRenderedFeatures(rectF, filterExpression, *layerIds)
//                }
//                val featuresJson: MutableList<String> = ArrayList()
//                for (feature in features) {
//                    featuresJson.add(feature.toJson())
//                }
//                reply.put("features", featuresJson)
//                result.success(reply)
//            }
//            "map#setTelemetryEnabled" -> {
//                val enabled = call.argument<Boolean>("enabled")!!
//                Mapbox.getTelemetry()!!.setUserTelemetryRequestState(enabled)
//                result.success(null)
//            }
//            "map#getTelemetryEnabled" -> {
//                val telemetryState = TelemetryEnabler.retrieveTelemetryStateFromPreferences()
//                result.success(telemetryState == TelemetryEnabler.State.ENABLED)
//            }
//            "map#invalidateAmbientCache" -> {
//                val fileSource = OfflineManager.getInstance(context)
//                fileSource.invalidateAmbientCache(object : FileSourceCallback {
//                    override fun onSuccess() {
//                        result.success(null)
//                    }
//
//                    override fun onError(message: String) {
//                        result.error("MAPBOX CACHE ERROR", message, null)
//                    }
//                })
//            }
//            "symbols#addAll" -> {
//                val newSymbolIds: MutableList<String> = ArrayList()
//                val options = call.argument<List<Any>>("options")
//                val symbolOptionsList: MutableList<SymbolOptions?> = ArrayList()
//                if (options != null) {
//                    var symbolBuilder: SymbolBuilder
//                    for (o in options) {
//                        symbolBuilder = SymbolBuilder()
//                        Convert.interpretSymbolOptions(o, symbolBuilder)
//                        symbolOptionsList.add(symbolBuilder.symbolOptions)
//                    }
//                    if (!symbolOptionsList.isEmpty()) {
//                        val newSymbols = symbolManager!!.create(symbolOptionsList)
//                        var symbolId: String
//                        for (symbol in newSymbols) {
//                            symbolId = symbol.id.toString()
//                            newSymbolIds.add(symbolId)
//                            symbols.put(symbolId, SymbolController(symbol, annotationConsumeTapEvents!!.contains("AnnotationType.symbol"), this))
//                        }
//                    }
//                }
//                result.success(newSymbolIds)
//            }
//            "symbols#removeAll" -> {
//                val symbolIds = call.argument<ArrayList<String>>("ids")!!
//                var symbolController: SymbolController?
//                val symbolList: MutableList<Symbol?> = ArrayList()
//                for (symbolId in symbolIds) {
//                    symbolController = symbols.remove(symbolId)
//                    if (symbolController != null) {
//                        symbolList.add(symbolController.symbol)
//                    }
//                }
//                if (!symbolList.isEmpty()) {
//                    symbolManager!!.delete(symbolList)
//                }
//                result.success(null)
//            }
//            "symbol#update" -> {
//                val symbolId = call.argument<String>("symbol")
//                val symbol = symbol(symbolId)
//                Convert.interpretSymbolOptions(call.argument("options"), symbol)
//                symbol.update(symbolManager)
//                result.success(null)
//            }
//            "symbol#getGeometry" -> {
//                run {
//                    val symbolId = call.argument<String>("symbol")
//                    val symbol = symbol(symbolId)
//                    val symbolLatLng = symbol.getGeometry()
//                    val hashMapLatLng: MutableMap<String, Double> = HashMap()
//                    hashMapLatLng.put("latitude", symbolLatLng!!.latitude)
//                    hashMapLatLng.put("longitude", symbolLatLng!!.longitude)
//                    result.success(hashMapLatLng)
//                }
//                run {
//                    val value = call.argument<Boolean>("iconAllowOverlap")
//                    symbolManager!!.iconAllowOverlap = value
//                    result.success(null)
//                }
//            }
//            "symbolManager#iconAllowOverlap" -> {
//                val value = call.argument<Boolean>("iconAllowOverlap")
//                symbolManager!!.iconAllowOverlap = value
//                result.success(null)
//            }
//            "symbolManager#iconIgnorePlacement" -> {
//                val value = call.argument<Boolean>("iconIgnorePlacement")
//                symbolManager!!.iconIgnorePlacement = value
//                result.success(null)
//            }
//            "symbolManager#textAllowOverlap" -> {
//                val value = call.argument<Boolean>("textAllowOverlap")
//                symbolManager!!.textAllowOverlap = value
//                result.success(null)
//            }
//            "symbolManager#textIgnorePlacement" -> {
//                val iconAllowOverlap = call.argument<Boolean>("textIgnorePlacement")
//                symbolManager!!.textIgnorePlacement = iconAllowOverlap
//                result.success(null)
//            }
//            "line#add" -> {
//                val lineBuilder = newLineBuilder()
//                Convert.interpretLineOptions(call.argument("options"), lineBuilder)
//                val line = lineBuilder.build()
//                val lineId = line!!.id.toString()
//                lines.put(lineId, LineController(line, annotationConsumeTapEvents!!.contains("AnnotationType.line"), this))
//                result.success(lineId)
//            }
//            "line#remove" -> {
//                val lineId = call.argument<String>("line")
//                removeLine(lineId)
//                result.success(null)
//            }
//            "line#addAll" -> {
//                val newIds: MutableList<String> = ArrayList()
//                val options = call.argument<List<Any>>("options")
//                val optionList: MutableList<LineOptions?> = ArrayList()
//                if (options != null) {
//                    var builder: LineBuilder
//                    for (o in options) {
//                        builder = newLineBuilder()
//                        Convert.interpretLineOptions(o, builder)
//                        optionList.add(builder.lineOptions)
//                    }
//                    if (!optionList.isEmpty()) {
//                        val newLines = lineManager!!.create(optionList)
//                        var id: String
//                        for (line in newLines) {
//                            id = line.id.toString()
//                            newIds.add(id)
//                            lines.put(id, LineController(line, true, this))
//                        }
//                    }
//                }
//                result.success(newIds)
//            }
//            "line#removeAll" -> {
//                val ids = call.argument<ArrayList<String>>("ids")!!
//                var lineController: LineController?
//                val toBeRemoved: MutableList<Line?> = ArrayList()
//                for (id in ids) {
//                    lineController = lines.remove(id)
//                    if (lineController != null) {
//                        toBeRemoved.add(lineController.line)
//                    }
//                }
//                if (!toBeRemoved.isEmpty()) {
//                    lineManager!!.delete(toBeRemoved)
//                }
//                result.success(null)
//            }
//            "line#update" -> {
//                val lineId = call.argument<String>("line")
//                val line = line(lineId)
//                Convert.interpretLineOptions(call.argument("options"), line)
//                line.update(lineManager)
//                result.success(null)
//            }
//            "line#getGeometry" -> {
//                val lineId = call.argument<String>("line")
//                val line = line(lineId)
//                val lineLatLngs = line.getGeometry()
//                val resultList: MutableList<Any> = ArrayList()
//                for (latLng in lineLatLngs!!) {
//                    val hashMapLatLng: MutableMap<String, Double> = HashMap()
//                    hashMapLatLng.put("latitude", latLng!!.latitude)
//                    hashMapLatLng.put("longitude", latLng!!.longitude)
//                    resultList.add(hashMapLatLng)
//                }
//                result.success(resultList)
//            }
//            "circle#add" -> {
//                val circleBuilder = newCircleBuilder()
//                Convert.interpretCircleOptions(call.argument("options"), circleBuilder)
//                val circle = circleBuilder.build()
//                val circleId = circle!!.id.toString()
//                circles.put(circleId, CircleController(circle, annotationConsumeTapEvents!!.contains("AnnotationType.circle"), this))
//                result.success(circleId)
//            }
//            "circle#addAll" -> {
//                val newIds: MutableList<String> = ArrayList()
//                val options = call.argument<List<Any>>("options")
//                val optionList: MutableList<CircleOptions?> = ArrayList()
//                if (options != null) {
//                    var builder: CircleBuilder
//                    for (o in options) {
//                        builder = newCircleBuilder()
//                        Convert.interpretCircleOptions(o, builder)
//                        optionList.add(builder.circleOptions)
//                    }
//                    if (!optionList.isEmpty()) {
//                        val newCircles = circleManager!!.create(optionList)
//                        var id: String
//                        for (circle in newCircles) {
//                            id = circle.id.toString()
//                            newIds.add(id)
//                            circles.put(id, CircleController(circle, true, this))
//                        }
//                    }
//                }
//                result.success(newIds)
//            }
//            "circle#removeAll" -> {
//                val ids = call.argument<ArrayList<String>>("ids")!!
//                var circleController: CircleController?
//                val toBeRemoved: MutableList<Circle?> = ArrayList()
//                for (id in ids) {
//                    circleController = circles.remove(id)
//                    if (circleController != null) {
//                        toBeRemoved.add(circleController.circle)
//                    }
//                }
//                if (!toBeRemoved.isEmpty()) {
//                    circleManager!!.delete(toBeRemoved)
//                }
//                result.success(null)
//            }
//            "circle#remove" -> {
//                val circleId = call.argument<String>("circle")
//                removeCircle(circleId)
//                result.success(null)
//            }
//            "circle#update" -> {
//                Log.e(TAG, "update circle")
//                val circleId = call.argument<String>("circle")
//                val circle = circle(circleId)
//                Convert.interpretCircleOptions(call.argument("options"), circle)
//                circle.update(circleManager)
//                result.success(null)
//            }
//            "circle#getGeometry" -> {
//                val circleId = call.argument<String>("circle")
//                val circle = circle(circleId)
//                val circleLatLng = circle.getGeometry()
//                val hashMapLatLng: MutableMap<String, Double> = HashMap()
//                hashMapLatLng.put("latitude", circleLatLng!!.latitude)
//                hashMapLatLng.put("longitude", circleLatLng!!.longitude)
//                result.success(hashMapLatLng)
//            }
//            "fill#add" -> {
//                val fillBuilder = newFillBuilder()
//                Convert.interpretFillOptions(call.argument("options"), fillBuilder)
//                val fill = fillBuilder.build()
//                val fillId = fill!!.id.toString()
//                fills.put(fillId, FillController(fill, annotationConsumeTapEvents!!.contains("AnnotationType.fill"), this))
//                result.success(fillId)
//            }
//            "fill#addAll" -> {
//                val newIds: MutableList<String> = ArrayList()
//                val options = call.argument<List<Any>>("options")
//                val optionList: MutableList<FillOptions?> = ArrayList()
//                if (options != null) {
//                    var builder: FillBuilder
//                    for (o in options) {
//                        builder = newFillBuilder()
//                        Convert.interpretFillOptions(o, builder)
//                        optionList.add(builder.fillOptions)
//                    }
//                    if (!optionList.isEmpty()) {
//                        val newFills = fillManager!!.create(optionList)
//                        var id: String
//                        for (fill in newFills) {
//                            id = fill.id.toString()
//                            newIds.add(id)
//                            fills.put(id, FillController(fill, true, this))
//                        }
//                    }
//                }
//                result.success(newIds)
//            }
//            "fill#removeAll" -> {
//                val ids = call.argument<ArrayList<String>>("ids")!!
//                var fillController: FillController?
//                val toBeRemoved: MutableList<Fill?> = ArrayList()
//                for (id in ids) {
//                    fillController = fills.remove(id)
//                    if (fillController != null) {
//                        toBeRemoved.add(fillController.fill)
//                    }
//                }
//                if (!toBeRemoved.isEmpty()) {
//                    fillManager!!.delete(toBeRemoved)
//                }
//                result.success(null)
//            }
//            "fill#remove" -> {
//                val fillId = call.argument<String>("fill")
//                removeFill(fillId)
//                result.success(null)
//            }
//            "fill#update" -> {
//                Log.e(TAG, "update fill")
//                val fillId = call.argument<String>("fill")
//                val fill = fill(fillId)
//                Convert.interpretFillOptions(call.argument("options"), fill)
//                fill.update(fillManager)
//                result.success(null)
//            }
            "style#vectorSourceAdd" -> {
                val sourceId = call.argument<String>("sourceId")!!
                val properties = call.argument<HashMap<String, Any?>>("properties")!!
                addVectorSource(sourceId, properties)
                result.success(null)
            }
            "style#geoJsonSourceAdd" -> {
                val sourceId = call.argument<String>("sourceId")!!
                val geoJson = call.argument<String>("geojson")!!
                addGeoJsonSource(sourceId, geoJson)
                result.success(null)
            }
            "style#symbolLayerAdd" -> {
                val sourceId = call.argument<String>("source")!!
                val layerId = call.argument<String>("id")!!
                val sourceLayerId = call.argument<String>("source-layer")
                val tappable = call.argument<Boolean>("tappable")!!
                val properties = call.argument<HashMap<String, Any?>>("properties")!!
                addSymbolLayer(layerId, sourceId, sourceLayerId, properties)
                if (tappable) {
                    tappableLayers.add(layerId)
                } else {
                    tappableLayers.remove(layerId)
                }
                result.success(null)
            }
            "style#symbolLayerUpdate" -> {
                val layerId = call.argument<String>("id")!!
                val properties = call.argument<HashMap<String, Any?>>("properties")!!
                updateLayer(layerId, properties)
                result.success(null)
            }
            "style#lineLayerAdd" -> {
                val sourceId = call.argument<String>("source")!!
                val layerId = call.argument<String>("id")!!
                val sourceLayerId = call.argument<String?>("source-layer")
                val tappable = call.argument<Boolean>("tappable")!!
                val properties = call.argument<HashMap<String, Any?>>("properties")!!
                //val properties = Convert.interpretLineLayerProperties(call.argument("properties"))

                addLineLayer(layerId, sourceId, sourceLayerId, properties)
                if (tappable!!) {
                    tappableLayers.add(layerId)
                } else {
                    tappableLayers.remove(layerId)
                }
                result.success(null)
            }
            "style#lineLayerUpdate" -> {
                val layerId = call.argument<String>("id")!!
                val properties = call.argument<HashMap<String, Any?>>("properties")!!
                updateLayer(layerId, properties)
                result.success(null)
            }
            "style#circleLayerAdd" -> {
                val sourceId = call.argument<String>("source")!!
                val layerId = call.argument<String>("id")!!
                val sourceLayerId = call.argument<String?>("source-layer")
                val tappable = call.argument<Boolean>("tappable")!!
                val properties = call.argument<HashMap<String, Any?>>("properties")!!
                //val properties = Convert.interpretLineLayerProperties(call.argument("properties"))

                addCircleLayer(layerId, sourceId, sourceLayerId, properties)
                if (tappable!!) {
                    tappableLayers.add(layerId)
                } else {
                    tappableLayers.remove(layerId)
                }
                result.success(null)
            }
            "style#circleLayerUpdate" -> {
                val layerId = call.argument<String>("id")!!
                val properties = call.argument<HashMap<String, Any?>>("properties")!!
                updateLayer(layerId, properties)
                result.success(null)
            }
            "style#addImage" -> {
                val name: String = call.argument<String>("name")!!
                val length: Int = call.argument<Int>("length")!!
                val bytes: ByteArray = call.argument<ByteArray>("bytes")!!
                val sdf: Boolean = call.argument<Boolean?>("sdf") ?: false

                addImage(name, bytes, length, sdf)

                result.success(null)
            }
//            "style#addImageSource" -> {
//                if (style == null) {
//                    result.error("STYLE IS NULL", "The style is null. Has onStyleLoaded() already been invoked?", null)
//                }
//                val coordinates = Convert.toLatLngList(call.argument("coordinates"))
//                style!!.addSource(ImageSource(call.argument("imageSourceId"), LatLngQuad(coordinates!![0], coordinates[1], coordinates[2], coordinates[3]), BitmapFactory.decodeByteArray(call.argument("bytes"), 0, call.argument("length")!!)))
//                result.success(null)
//            }
//            "style#removeImageSource" -> {
//                if (style == null) {
//                    result.error("STYLE IS NULL", "The style is null. Has onStyleLoaded() already been invoked?", null)
//                }
//                style!!.removeSource((call.argument<Any>("imageSourceId") as String?)!!)
//                result.success(null)
//            }
//            "style#addLayer" -> {
//                if (style == null) {
//                    result.error("STYLE IS NULL", "The style is null. Has onStyleLoaded() already been invoked?", null)
//                }
//                style!!.addLayer(RasterLayer(call.argument("imageLayerId"), call.argument("imageSourceId")))
//                result.success(null)
//            }
//            "style#addLayerBelow" -> {
//                if (style == null) {
//                    result.error("STYLE IS NULL", "The style is null. Has onStyleLoaded() already been invoked?", null)
//                }
//                style!!.addLayerBelow(RasterLayer(call.argument("imageLayerId"), call.argument("imageSourceId")), call.argument("belowLayerId")!!)
//                result.success(null)
//            }
//            "style#removeLayer" -> {
//                if (style == null) {
//                    result.error("STYLE IS NULL", "The style is null. Has onStyleLoaded() already been invoked?", null)
//                }
//                style!!.removeLayer((call.argument<Any>("imageLayerId") as String?)!!)
//                result.success(null)
//            }
            else -> result.notImplemented()
        }
    }


    override fun dispose() {
        if (disposed) {
            return
        }
        disposed = true
        methodChannel.setMethodCallHandler(null)
        destroyMapViewIfNecessary()
    }

    private fun destroyMapViewIfNecessary() {
        if (mapView == null) {
            return
        }
        stopListeningForLocationUpdates()
        mapView.onDestroy()
    }

    override fun onCreate(owner: LifecycleOwner) {
        if (disposed) {
            return
        }
    }

    override fun onStart(owner: LifecycleOwner) {
        if (disposed) {
            return
        }
        mapView.onStart()
    }

    override fun onResume(owner: LifecycleOwner) {
        if (disposed) {
            return
        }
        if (myLocationEnabled) {
            startListeningForLocationUpdates()
        }
    }

    override fun onPause(owner: LifecycleOwner) {
        if (disposed) {
            return
        }
    }

    override fun onStop(owner: LifecycleOwner) {
        if (disposed) {
            return
        }
        mapView.onStop()
    }

    override fun onDestroy(owner: LifecycleOwner) {
        owner.lifecycle.removeObserver(this)
        if (disposed) {
            return
        }
//        destroyMapViewIfNecessary()
    }

    // MapboxMapOptionsSink methods

    override fun setCompassEnabled(enabled: Boolean) {
        mapView.compass.enabled = enabled
    }

    override fun setScaleBarEnabled(enabled: Boolean) {
        mapView.scalebar.enabled = enabled
    }

    override fun setTrackCameraPosition(trackCameraPosition: Boolean) {
        this.trackCameraPosition = trackCameraPosition
    }

    override fun setRotateGesturesEnabled(enabled: Boolean) {
        mapView.gestures.rotateEnabled = enabled
    }

    override fun setScrollGesturesEnabled(enabled: Boolean) {
        mapView.gestures.scrollEnabled = enabled
    }

    override fun setPitchGesturesEnabled(enabled: Boolean) {
        mapView.gestures.pitchEnabled = enabled
    }

    override fun setMinMaxZoomPreference(min: Double, max: Double) {
        val builder = CameraBoundsOptions.Builder()
        builder.minZoom(min)
        builder.maxZoom(min)
        mapView.getMapboxMap().setBounds(builder.build())
    }


    override fun setMinMaxPitchPreference(min: Double, max: Double) {
        val builder = CameraBoundsOptions.Builder()
        builder.minPitch(min)
        builder.maxPitch(min)
        mapView.getMapboxMap().setBounds(builder.build())
    }

    override fun setZoomGesturesEnabled(enabled: Boolean) {
        mapView.gestures.pinchToZoomEnabled = enabled
    }

    override fun setMyLocationEnabled(enabled: Boolean) {
//        if (this.myLocationEnabled == myLocationEnabled) {
//            return
//        }
//        this.myLocationEnabled = myLocationEnabled
//        if (mapboxMap != null) {
//            updateMyLocationEnabled()
//        }
    }

    override fun setMyLocationTrackingMode(myLocationTrackingMode: Int) {
//        if (this.myLocationTrackingMode == myLocationTrackingMode) {
//            return
//        }
//        this.myLocationTrackingMode = myLocationTrackingMode
//        if (mapboxMap != null && locationComponent != null) {
//            updateMyLocationTrackingMode()
//        }
    }

    override fun setMyLocationRenderMode(myLocationRenderMode: Int) {
//        if (this.myLocationRenderMode == myLocationRenderMode) {
//            return
//        }
//        this.myLocationRenderMode = myLocationRenderMode
//        if (mapboxMap != null && locationComponent != null) {
//            updateMyLocationRenderMode()
//        }
    }

    override fun setLogoPosition(gravity: Int) {
        mapView.logo.apply {
            position = when (position) {
                0 -> Gravity.TOP or Gravity.START
                1 -> Gravity.TOP or Gravity.END
                2 -> Gravity.BOTTOM or Gravity.START
                3 -> Gravity.BOTTOM or Gravity.END
                else -> Gravity.TOP or Gravity.END
            }
        }

    }

    override fun setLogoViewMargins(x: Int, y: Int) {
        mapView.logo.apply {
            when (position) {
                Gravity.TOP or Gravity.START -> {
                    marginLeft = x.toFloat()
                    marginTop = y.toFloat()
                    marginRight = 0f
                    marginBottom = 0f
                }
                Gravity.TOP or Gravity.END -> {
                    marginLeft = 0f
                    marginTop = y.toFloat()
                    marginRight = x.toFloat()
                    marginBottom = 0f
                }
                Gravity.BOTTOM or Gravity.START -> {
                    marginLeft = x.toFloat()
                    marginTop = 0f
                    marginRight = 0f
                    marginBottom = y.toFloat()
                }
                Gravity.BOTTOM or Gravity.END -> {
                    marginLeft = 0f
                    marginTop = 0f
                    marginRight = x.toFloat()
                    marginBottom = y.toFloat()
                }
                else -> {
                    marginLeft = 0f
                    marginTop = y.toFloat()
                    marginRight = x.toFloat()
                    marginBottom = 0f
                }
            }
        }
    }

    override fun setCompassViewPosition(gravity: Int) {
        mapView.compass.apply {
            position = when (position) {
                0 -> Gravity.TOP or Gravity.START
                1 -> Gravity.TOP or Gravity.END
                2 -> Gravity.BOTTOM or Gravity.START
                3 -> Gravity.BOTTOM or Gravity.END
                else -> Gravity.TOP or Gravity.END
            }
        }
    }

    override fun setCompassViewMargins(x: Int, y: Int) {
        mapView.compass.apply {
            when (position) {
                Gravity.TOP or Gravity.START -> {
                    marginLeft = x.toFloat()
                    marginTop = y.toFloat()
                    marginRight = 0f
                    marginBottom = 0f
                }
                Gravity.TOP or Gravity.END -> {
                    marginLeft = 0f
                    marginTop = y.toFloat()
                    marginRight = x.toFloat()
                    marginBottom = 0f
                }
                Gravity.BOTTOM or Gravity.START -> {
                    marginLeft = x.toFloat()
                    marginTop = 0f
                    marginRight = 0f
                    marginBottom = y.toFloat()
                }
                Gravity.BOTTOM or Gravity.END -> {
                    marginLeft = 0f
                    marginTop = 0f
                    marginRight = x.toFloat()
                    marginBottom = y.toFloat()
                }
                else -> {
                    marginLeft = 0f
                    marginTop = y.toFloat()
                    marginRight = x.toFloat()
                    marginBottom = 0f
                }
            }
        }
    }

    override fun setAttributionButtonPosition(gravity: Int) {
        mapView.attribution.apply {
            position = when (position) {
                0 -> Gravity.TOP or Gravity.START
                1 -> Gravity.TOP or Gravity.END
                2 -> Gravity.BOTTOM or Gravity.START
                3 -> Gravity.BOTTOM or Gravity.END
                else -> Gravity.TOP or Gravity.END
            }
        }
    }

    override fun setAttributionButtonMargins(x: Int, y: Int) {
        mapView.attribution.apply {
            when (position) {
                Gravity.TOP or Gravity.START -> {
                    marginLeft = x.toFloat()
                    marginTop = y.toFloat()
                    marginRight = 0f
                    marginBottom = 0f
                }
                Gravity.TOP or Gravity.END -> {
                    marginLeft = 0f
                    marginTop = y.toFloat()
                    marginRight = x.toFloat()
                    marginBottom = 0f
                }
                Gravity.BOTTOM or Gravity.START -> {
                    marginLeft = x.toFloat()
                    marginTop = 0f
                    marginRight = 0f
                    marginBottom = y.toFloat()
                }
                Gravity.BOTTOM or Gravity.END -> {
                    marginLeft = 0f
                    marginTop = 0f
                    marginRight = x.toFloat()
                    marginBottom = y.toFloat()
                }
                else -> {
                    marginLeft = 0f
                    marginTop = y.toFloat()
                    marginRight = x.toFloat()
                    marginBottom = 0f
                }
            }
        }
    }

    private fun updateMyLocationEnabled() {
//        if (locationComponent == null && myLocationEnabled) {
//            enableLocationComponent(mapboxMap!!.style!!)
//        }
//        if (myLocationEnabled) {
//            startListeningForLocationUpdates()
//        } else {
//            stopListeningForLocationUpdates()
//        }
//        locationComponent!!.isLocationComponentEnabled = myLocationEnabled
    }

    private fun startListeningForLocationUpdates() {
//        var _locationEngineCallback = locationEngineCallback;
//
//        if (_locationEngineCallback == null && locationComponent != null && locationComponent!!.locationEngine != null) {
//            _locationEngineCallback = object : LocationEngineCallback<LocationEngineResult> {
//                override fun onSuccess(result: LocationEngineResult) {
//                    onUserLocationUpdate(result.lastLocation)
//                }
//
//                override fun onFailure(exception: Exception) {}
//            }
//            locationComponent!!.locationEngine!!.requestLocationUpdates(locationComponent!!.locationEngineRequest, _locationEngineCallback, null)
//        }
    }

    private fun stopListeningForLocationUpdates() {
//        if (locationEngineCallback != null && locationComponent != null && locationComponent!!.locationEngine != null) {
//            locationComponent!!.locationEngine!!.removeLocationUpdates(locationEngineCallback!!)
//            locationEngineCallback = null
//        }
    }

    private fun updateMyLocationTrackingMode() {
//        val mapboxTrackingModes = intArrayOf(CameraMode.NONE, CameraMode.TRACKING, CameraMode.TRACKING_COMPASS, CameraMode.TRACKING_GPS)
//        locationComponent!!.cameraMode = mapboxTrackingModes[myLocationTrackingMode]
    }

    private fun updateMyLocationRenderMode() {
//        val mapboxRenderModes = intArrayOf(RenderMode.NORMAL, RenderMode.COMPASS, RenderMode.GPS)
//        locationComponent!!.renderMode = mapboxRenderModes[myLocationRenderMode]
    }

    private fun hasLocationPermission(): Boolean {
        return (checkSelfPermission(Manifest.permission.ACCESS_FINE_LOCATION)
                == PackageManager.PERMISSION_GRANTED
                || checkSelfPermission(Manifest.permission.ACCESS_COARSE_LOCATION)
                == PackageManager.PERMISSION_GRANTED)
    }

    private fun checkSelfPermission(permission: String?): Int {
        requireNotNull(permission) { "permission is null" }
        return context.checkPermission(
                permission, Process.myPid(), Process.myUid())
    }

    override fun onStyleLoaded(eventData: StyleLoadedEventData) {
        methodChannel.invokeMethod("map#onStyleLoaded", null)
    }

    override fun onMapClick(point: Point): Boolean {
        mapView.getMapboxMap().apply {
            val pixel = pixelForCoordinate(point);
            methodChannel.invokeMethod("map#onMapClick", mapOf(
                    "x" to pixel.x / density,
                    "y" to pixel.y / density,
                    "lng" to point.longitude(),
                    "lat" to point.latitude()

            ))

            if (tappableLayers.isNotEmpty()) {
                val qOptions = RenderedQueryOptions(tappableLayers.distinct(), Value.nullValue())

                val boxModifier = 24 * density
                val screenBox = ScreenBox(
                        ScreenCoordinate(pixel.x - boxModifier, pixel.y - boxModifier),
                        ScreenCoordinate(pixel.x + boxModifier, pixel.y + boxModifier)
                )
                queryRenderedFeatures(screenBox, qOptions, QueryFeaturesCallback { result ->
                    if (!result.isError && result.isValue && result.value!!.isNotEmpty()) {
                        result.value!!.first { qFeature ->
                            (qFeature.feature.geometry() as Point?)?.let { point ->
                                val data = qFeature.feature.properties()
                                val dataMap: Map<String, Any> = Gson().fromJson(
                                        data.toString(),
                                        object : TypeToken<HashMap<String?, Any?>?>() {}.type
                                )

                                methodChannel.invokeMethod("map#onLayerTap", mapOf(
                                        "source" to qFeature.source,
                                        "sourceLayer" to qFeature.sourceLayer as Any,
                                        "x" to pixel.x / density,
                                        "y" to pixel.y / density,
                                        "lng" to point.longitude(),
                                        "lat" to point.latitude(),
                                        "data" to dataMap

                                ))
                            }
                            return@QueryFeaturesCallback
                        }

                    }
                })
            }
            return true

        }
    }


    companion object {
        private const val TAG = "MapboxMapController"
    }

    init {
        val mapOptions = MapOptions.Builder()
                .pixelRatio(density);

        val resourceOptions = ResourceOptions.Builder()
        (params["accessToken"] as String?)?.let { accessToken ->
            resourceOptions.accessToken(accessToken)
        }

        val initialCameraOptions = CameraOptions.Builder()
        val cameraBoundsOptions = CameraBoundsOptions.Builder()



        (params["initialCameraPosition"] as? Map<String, Any>)?.let { position ->

            (position["bearing"] as Double?)?.let { bearing ->
                initialCameraOptions.bearing(bearing)
            }

            (position["zoom"] as Double?)?.let { zoom ->
                initialCameraOptions.zoom(zoom)
            }

            (position["pitch"] as Double?)?.let { pitch ->
                initialCameraOptions.pitch(pitch)
            }

            (position["target"] as List<Double>?)?.let { center ->
                initialCameraOptions.center(Point.fromLngLat(center[1], center[0]))
            }

        }

        (params.containsKey("minMaxZoomPreferences") as? List<Double>)?.let { value ->
            if (value.count() == 2) {
                cameraBoundsOptions.minZoom(value[0])
                cameraBoundsOptions.maxZoom(value[1])
            }
        }

        (params.containsKey("minMaxPitchPreferences") as? List<Double>)?.let { value ->
            if (value.count() == 2) {
                cameraBoundsOptions.minPitch(value[0])
                cameraBoundsOptions.maxPitch(value[1])
            }
        }

        val mapInitOptions = MapInitOptions(
                context,
                resourceOptions.build(),
                mapOptions.build(),
                cameraOptions = initialCameraOptions.build(),
                textureView = false
        )

        mapView = MapView(context, mapInitOptions)

        // set all options
        (params["options"] as Map<String, Any>?)?.let { options ->
            Convert.interpretMapboxMapOptions(options, this)
        }

        mapView.getMapboxMap().addOnStyleLoadedListener(this)
        mapView.gestures.addOnMapClickListener(this)

        methodChannel = MethodChannel(messenger, "plugins.flutter.io/mapbox_maps_$id")

        streamChannel = StreamsChannel(messenger, "plugins.flutter.io/mapbox_maps_event_stream")

        val streamHandlerFactory = object : StreamsChannel.StreamHandlerFactory {
            override fun create(arguments: Any?): EventChannel.StreamHandler? {
                (arguments as Map<String, Any>?)?.let { args ->
                    val source = args["source"] as String
                    (args["handler"] as String?)?.let { handlerName ->
                        when (handlerName) {
                            "dataChanged" -> {
                                return FeaturesStreamHandler(
                                        mapView,
                                        source,
                                        args["source-layers"] as List<String>?,
                                        args["filter"]
                                )
                            }
                            else -> {
                                return null
                            }
                        }
                    }
                }
                return null
            }
        }

        streamChannel.setStreamHandlerFactory(streamHandlerFactory)


        methodChannel.setMethodCallHandler(this)
    }

}
// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
package com.mapbox.mapboxgl

import android.Manifest
import android.annotation.SuppressLint
import android.content.Context
import android.content.pm.PackageManager
import android.graphics.BitmapFactory
import android.graphics.PointF
import android.graphics.RectF
import android.location.Location
import android.os.Build
import android.os.Process
import android.util.Log
import android.view.View
import androidx.lifecycle.DefaultLifecycleObserver
import androidx.lifecycle.LifecycleOwner
import com.google.android.gms.maps.CameraUpdate
import com.google.android.gms.maps.model.LatLngBounds
import com.google.gson.Gson
import com.google.gson.JsonArray
import com.mapbox.android.core.location.LocationEngine
import com.mapbox.android.core.location.LocationEngineCallback
import com.mapbox.android.core.location.LocationEngineProvider
import com.mapbox.android.core.location.LocationEngineResult
import com.mapbox.geojson.Feature
import com.mapbox.geojson.Point
import com.mapbox.mapboxgl.MapboxMapController
import com.mapbox.mapboxgl.MapboxMapsPlugin.LifecycleProvider
import com.mapbox.maps.*
import com.mapbox.maps.plugin.Plugin
import com.mapbox.maps.plugin.animation.camera
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.localization.LocalizationPlugin
import io.flutter.plugin.platform.PlatformView
import java.io.UnsupportedEncodingException
import java.net.URLDecoder
import java.util.*

/**
 * Controller of a single MapboxMaps MapView instance.
 */
@SuppressLint("MissingPermission")
internal class MapboxMapController(
        id: Int,
        context: Context,
        messenger: BinaryMessenger?,
        params: Map<String, Any>) : DefaultLifecycleObserver,  MapboxMapOptionsSink, MethodCallHandler, PlatformView {
    private val id: Int = id
    private lateinit var methodChannel: MethodChannel

    //    private val lifecycleProvider: LifecycleProvider
    private lateinit var mapView: MapView
    private var mapboxMap: MapboxMap? = null

//    private val symbols: MutableMap<String?, SymbolController>
//    private val lines: MutableMap<String?, LineController>
//    private val circles: MutableMap<String?, CircleController>
//    private val fills: MutableMap<String?, FillController>
//    private var symbolManager: SymbolManager? = null
//    private var lineManager: LineManager? = null
//    private var circleManager: CircleManager? = null
//    private var fillManager: FillManager? = null
    private var trackCameraPosition = false
    private var myLocationEnabled = false
    private var myLocationTrackingMode = 0
    private var myLocationRenderMode = 0
    private var disposed = false

    //    private val density: Float
//    private var mapReadyResult: MethodChannel.Result? = null
    private val context: Context = context

    //    private var locationComponent: LocationComponent? = null
//    private var locationEngine: LocationEngine? = null
//    private var locationEngineCallback: LocationEngineCallback<LocationEngineResult>? = null
//    private var localizationPlugin: LocalizationPlugin? = null
    private var style: Style? = null

    //    private val annotationOrder: List<String?>?
//    private val annotationConsumeTapEvents: List<String?>?
    private val tappableLayers = HashSet<String?>()
    override fun getView(): View {
        return mapView
    }

    fun init() {
//        lifecycleProvider.getLifecycle()!!.addObserver(this)
//        mapView.getMapAsync(this)
    }

    private fun moveCamera(cameraUpdate: CameraUpdate) {
//        mapboxMap!!.moveCamera(cameraUpdate)
    }

    private fun animateCamera(cameraUpdate: CameraUpdate) {
//        mapboxMap!!.animateCamera(cameraUpdate)
    }

    private val cameraPosition: CameraOptions?
        private get() = if (trackCameraPosition) mapboxMap!!.cameraState.toCameraOptions() else null
//
//    private fun symbol(symbolId: String?): SymbolController {
//        return symbols[symbolId]
//                ?: throw IllegalArgumentException("Unknown symbol: $symbolId")
//    }

//    private fun newLineBuilder(): LineBuilder {
//        return LineBuilder(lineManager)
//    }

//    private fun removeLine(lineId: String?) {
//        val lineController = lines.remove(lineId)
//        lineController?.remove(lineManager)
//    }
//
//    private fun line(lineId: String?): LineController {
//        return lines[lineId] ?: throw IllegalArgumentException("Unknown line: $lineId")
//    }
//
//    private fun newCircleBuilder(): CircleBuilder {
//        return CircleBuilder(circleManager)
//    }
//
//    private fun removeCircle(circleId: String?) {
//        val circleController = circles.remove(circleId)
//        circleController?.remove(circleManager)
//    }
//
//    private fun circle(circleId: String?): CircleController {
//        return circles[circleId]
//                ?: throw IllegalArgumentException("Unknown circle: $circleId")
//    }
//
//    private fun newFillBuilder(): FillBuilder {
//        return FillBuilder(fillManager)
//    }
//
//    private fun removeFill(fillId: String?) {
//        val fillController = fills.remove(fillId)
//        fillController?.remove(fillManager)
//    }
//
//    private fun fill(fillId: String?): FillController {
//        return fills[fillId] ?: throw IllegalArgumentException("Unknown fill: $fillId")
//    }

//    fun onMapReady(mapboxMap: MapboxMap) {
//        this.mapboxMap = mapboxMap
//        if (mapReadyResult != null) {
//            mapReadyResult!!.success(null)
//            mapReadyResult = null
//        }
//        mapboxMap.addOnCameraMoveStartedListener(this)
//        mapboxMap.addOnCameraMoveListener(this)
//        mapboxMap.addOnCameraIdleListener(this)
//        mapView.addOnStyleImageMissingListener { id: String ->
//            val displayMetrics = context.resources.displayMetrics
//            val bitmap = getScaledImage(id, displayMetrics.density)
//            if (bitmap != null) {
//                mapboxMap.style!!.addImage(id, bitmap)
//            }
//        }
//        setStyleString(styleStringInitial)
//        // updateMyLocationEnabled();
//    }

    override fun setStyleString(styleString: String?) {
//        // Check if json, url, absolute path or asset path:
//        if (styleString == null || styleString.isEmpty()) {
//            Log.e(TAG, "setStyleString - string empty or null")
//        } else if (styleString.startsWith("{") || styleString.startsWith("[")) {
//            mapboxMap!!.setStyle(Style.Builder().fromJson(styleString), onStyleLoadedCallback)
//        } else if (styleString.startsWith("/")) {
//            // Absolute path
//            mapboxMap!!.setStyle(Style.Builder().fromUri("file://$styleString"), onStyleLoadedCallback)
//        } else if (!styleString.startsWith("http://") &&
//                !styleString.startsWith("https://") &&
//                !styleString.startsWith("mapbox://")) {
//            // We are assuming that the style will be loaded from an asset here.
//            val key: String = MapboxMapsPlugin.Companion.flutterAssets!!.getAssetFilePathByName(styleString)
//            mapboxMap!!.setStyle(Style.Builder().fromUri("asset://$key"), onStyleLoadedCallback)
//        } else {
//            mapboxMap!!.setStyle(Style.Builder().fromUri(styleString), onStyleLoadedCallback)
//        }
    }

//    var onStyleLoadedCallback = OnStyleLoaded { nextStyle ->
//        style = nextStyle
//        for (annotationType in annotationOrder!!) {
//            when (annotationType) {
//                "AnnotationType.fill" -> enableFillManager(style!!)
//                "AnnotationType.line" -> enableLineManager(style!!)
//                "AnnotationType.circle" -> enableCircleManager(style!!)
//                "AnnotationType.symbol" -> enableSymbolManager(style!!)
//                else -> throw IllegalArgumentException("Unknown annotation type: $annotationType, must be either 'fill', 'line', 'circle' or 'symbol'")
//            }
//        }
//        if (myLocationEnabled) {
//            enableLocationComponent(style!!)
//        }
//        // needs to be placed after SymbolManager#addClickListener,
//        // is fixed with 0.6.0 of annotations plugin
//        mapboxMap!!.addOnMapClickListener(this@MapboxMapController)
//        mapboxMap!!.addOnMapLongClickListener(this@MapboxMapController)
//
//        mapView.let {
//            localizationPlugin = LocalizationPlugin(mapView, mapboxMap!!, style!!)
//            methodChannel.invokeMethod("map#onStyleLoaded", null)
//        }
//
//
//    }

    private fun enableLocationComponent(style: Style) {
//        if (hasLocationPermission()) {
//            locationEngine = LocationEngineProvider.getBestLocationEngine(context)
//            val locationComponentOptions = LocationComponentOptions.builder(context)
//                    .trackingGesturesManagement(true)
//                    .build()
//            locationComponent = mapboxMap!!.locationComponent
//            locationComponent!!.activateLocationComponent(context, style, locationComponentOptions)
//            locationComponent!!.isLocationComponentEnabled = true
//            // locationComponent.setRenderMode(RenderMode.COMPASS); // remove or keep default?
//            locationComponent!!.locationEngine = locationEngine
//            locationComponent!!.setMaxAnimationFps(30)
//            updateMyLocationTrackingMode()
//            setMyLocationTrackingMode(myLocationTrackingMode)
//            updateMyLocationRenderMode()
//            setMyLocationRenderMode(myLocationRenderMode)
//            locationComponent!!.addOnCameraTrackingChangedListener(this)
//        } else {
//            Log.e(TAG, "missing location permissions")
//        }
    }

    private fun onUserLocationUpdate(location: Location?) {
//        if (location == null) {
//            return
//        }
//        val userLocation: MutableMap<String, Any?> = HashMap(6)
//        userLocation.put("position", doubleArrayOf(location.latitude, location.longitude))
//        userLocation.put("altitude", location.altitude)
//        userLocation.put("bearing", location.bearing)
//        userLocation.put("horizontalAccuracy", location.accuracy)
//        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
//            userLocation.put("verticalAccuracy", if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) location.verticalAccuracyMeters else null)
//        }
//        userLocation.put("timestamp", location.time)
//        val arguments: MutableMap<String, Any> = HashMap(1)
//        arguments.put("userLocation", userLocation)
//        methodChannel.invokeMethod("map#onUserLocationUpdated", arguments)
    }

    private fun addGeoJsonSource(sourceName: String?, geojson: String?) {
//        val featureCollection = FeatureCollection.fromJson(geojson!!)
//        val geoJsonSource = GeoJsonSource(sourceName, featureCollection)
//        style!!.addSource(geoJsonSource)
    }

//    private fun addVectorSource(sourceName: String?, properties: HashMap<String, *>) {
//        Log.d("MapBoxController_$id", "addVectorSource, idx: 4")
//        if (properties.containsKey("url")) {
//            val vectorSource = VectorSource(sourceName, properties["url"] as String?)
//            style!!.addSource(vectorSource)
//            val a: Number = 1
//        } else {
//            var tileVersion = properties["tileVersion"] as String?
//            if (tileVersion == null) {
//                tileVersion = "2.2.0"
//            }
//            val tilesObjectArray: Array<Any> = (properties["tiles"] as ArrayList<*>).toTypedArray()
//            val tileUrls = Arrays.copyOf<String, Any>(tilesObjectArray, tilesObjectArray.size, Array<String>::class.java)
//            var i = 0
//            while (i < tileUrls.size) {
//                try {
//                    tileUrls[i] = URLDecoder.decode(tileUrls[i], "UTF-8")
//                    val tileSet = TileSet(
//                            tileVersion,
//                            *tileUrls
//                    )
//                    val minZoom = properties["minZoom"] as Number?
//                    if (minZoom != null) {
//                        tileSet.minZoom = minZoom.toFloat()
//                    }
//                    val maxZoom = properties["maxZoom"] as Number?
//                    if (maxZoom != null) {
//                        tileSet.maxZoom = maxZoom.toFloat()
//                    }
//                    val vectorSource = VectorSource(sourceName, tileSet)
//                    style!!.addSource(vectorSource)
//                } catch (e: UnsupportedEncodingException) {
//                }
//                i = i + 1
//            }
//            val a: Number = 1
//        }
//    }
//
//    private fun addSymbolLayer(layerName: String?,
//                               sourceName: String?,
//                               sourceLayer: String?,
//                               properties: Array<PropertyValue<*>>?) {
//        val symbolLayer = SymbolLayer(layerName, sourceName)
//        if (sourceLayer != null) {
//            symbolLayer.sourceLayer = sourceLayer
//        }
//        symbolLayer.setProperties(*properties!!)
//        style!!.addLayer(symbolLayer)
//    }
//
//    private fun updateSymbolLayer(layerName: String?,
//                                  properties: Array<PropertyValue<*>>?) {
//        val lineLayer = style!!.getLayerAs<LineLayer>(layerName!!)
//        lineLayer!!.setProperties(*properties!!)
//    }
//
//    private fun addLineLayer(layerName: String?,
//                             sourceName: String?,
//                             sourceLayer: String?,
//                             properties: Array<PropertyValue<*>>?) {
//        val lineLayer = LineLayer(layerName, sourceName)
//        if (sourceLayer != null) {
//            lineLayer.sourceLayer = sourceLayer
//        }
//        lineLayer.setProperties(*properties!!)
//        style!!.addLayer(lineLayer)
//    }
//
//    private fun updateLineLayer(layerName: String?,
//                                properties: Array<PropertyValue<*>>?) {
//        val lineLayer = style!!.getLayerAs<LineLayer>(layerName!!)
//        lineLayer!!.setProperties(*properties!!)
//    }

//    private fun enableSymbolManager(style: Style) {
//        if (symbolManager == null) {
//            symbolManager = SymbolManager(mapView, mapboxMap!!, style)
//            symbolManager!!.iconAllowOverlap = true
//            symbolManager!!.iconIgnorePlacement = true
//            symbolManager!!.textAllowOverlap = true
//            symbolManager!!.textIgnorePlacement = true
//            //symbolManager!!.addClickListener(OnSymbolClickListener { annotation: com.mapbox.mapboxsdk.plugins.annotation.Annotation<*> -> this@MapboxMapController.onAnnotationClick(annotation) })
//        }
//    }

//    private fun enableLineManager(style: Style) {
//        if (lineManager == null) {
//            lineManager = LineManager(mapView, mapboxMap!!, style)
//            //lineManager!!.addClickListener(OnLineClickListener { annotation: com.mapbox.mapboxsdk.plugins.annotation.Annotation<*> -> this@MapboxMapController.onAnnotationClick(annotation) })
//        }
//    }
//
//    private fun enableCircleManager(style: Style) {
//        if (circleManager == null) {
//            circleManager = CircleManager(mapView, mapboxMap!!, style)
//            // circleManager!!.addClickListener(OnCircleClickListener { annotation: com.mapbox.mapboxsdk.plugins.annotation.Annotation<*> -> this@MapboxMapController.onAnnotationClick(annotation) })
//        }
//    }
//
//    private fun enableFillManager(style: Style) {
//        if (fillManager == null) {
//            fillManager = FillManager(mapView, mapboxMap!!, style)
//            // fillManager!!.addClickListener(OnFillClickListener { annotation: com.mapbox.mapboxsdk.plugins.annotation.Annotation<*> -> this@MapboxMapController.onAnnotationClick(annotation) })
//        }
//    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "map#waitForMap" -> {
                if (mapboxMap != null) {
                    result.success(null)
                    return
                }
//                mapReadyResult = result
            }
//            "map#update" -> {
//                Convert.interpretMapboxMapOptions(call.argument("options"), this)
//                result.success(Convert.toJson(cameraPosition))
//            }
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
//            "camera#move" -> {
//                val cameraUpdate = Convert.toCameraUpdate(call.argument("cameraUpdate"), mapboxMap, density)
//                if (cameraUpdate != null) {
//                    // camera transformation not handled yet
//                    mapboxMap!!.moveCamera(cameraUpdate, object : OnCameraMoveFinishedListener() {
//                        override fun onFinish() {
//                            super.onFinish()
//                            result.success(true)
//                        }
//
//                        override fun onCancel() {
//                            super.onCancel()
//                            result.success(false)
//                        }
//                    })
//
//                    // moveCamera(cameraUpdate);
//                } else {
//                    result.success(false)
//                }
//            }
//            "camera#animate" -> {
//                val cameraUpdate = Convert.toCameraUpdate(call.argument("cameraUpdate"), mapboxMap, density)
//                val duration = call.argument<Int>("duration")
//                val onCameraMoveFinishedListener: OnCameraMoveFinishedListener = object : OnCameraMoveFinishedListener() {
//                    override fun onFinish() {
//                        super.onFinish()
//                        result.success(true)
//                    }
//
//                    override fun onCancel() {
//                        super.onCancel()
//                        result.success(false)
//                    }
//                }
//                if (cameraUpdate != null && duration != null) {
//                    // camera transformation not handled yet
//                    mapboxMap!!.animateCamera(cameraUpdate, duration, onCameraMoveFinishedListener)
//                } else if (cameraUpdate != null) {
//                    // camera transformation not handled yet
//                    mapboxMap!!.animateCamera(cameraUpdate, onCameraMoveFinishedListener)
//                } else {
//                    result.success(false)
//                }
//            }
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
//            "vectorSource#add" -> {
//                val sourceId = call.argument<String>("sourceId")
//                val properties = call.argument<HashMap<String, *>>("properties")!!
//                addVectorSource(sourceId, properties)
//                result.success(null)
//            }
//            "geoJsonSource#add" -> {
//                val sourceId = call.argument<String>("sourceId")
//                val geoJson = call.argument<String>("geojson")
//                addGeoJsonSource(sourceId, geoJson)
//                result.success(null)
//            }
//            "symbolLayer#add" -> {
//                val sourceId = call.argument<String>("source")
//                val layerId = call.argument<String>("id")
//                val sourceLayerId = call.argument<String>("source-layer")
//                val tappable = call.argument<Boolean>("tappable")
//                val properties = Convert.interpretSymbolLayerProperties(call.argument("properties"))
//                addSymbolLayer(layerId, sourceId, sourceLayerId, properties)
//                if (tappable!!) {
//                    tappableLayers.add(layerId)
//                } else {
//                    tappableLayers.remove(layerId)
//                }
//                result.success(null)
//            }
//            "symbolLayer#update" -> {
//                val layerId = call.argument<String>("id")
//                val properties = Convert.interpretSymbolLayerProperties(call.argument("properties"))
//                updateSymbolLayer(layerId, properties)
//                result.success(null)
//            }
//            "lineLayer#add" -> {
//                val sourceId = call.argument<String>("source")
//                val layerId = call.argument<String>("id")
//                val sourceLayerId = call.argument<String>("source-layer")
//                val tappable = call.argument<Boolean>("tappable")
//                val properties = Convert.interpretLineLayerProperties(call.argument("properties"))
//                addLineLayer(layerId, sourceId, sourceLayerId, properties)
//                if (tappable!!) {
//                    tappableLayers.add(layerId)
//                } else {
//                    tappableLayers.remove(layerId)
//                }
//                result.success(null)
//            }
//            "lineLayer#update" -> {
//                val layerId = call.argument<String>("id")
//                val properties = Convert.interpretLineLayerProperties(call.argument("properties"))
//                updateLineLayer(layerId, properties)
//                result.success(null)
//            }
//            "locationComponent#getLastLocation" -> {
//                Log.e(TAG, "location component: getLastLocation")
//                if (myLocationEnabled && locationComponent != null && locationEngine != null) {
//                    val reply: MutableMap<String, Any> = HashMap()
//                    locationEngine!!.getLastLocation(object : LocationEngineCallback<LocationEngineResult> {
//                        override fun onSuccess(locationEngineResult: LocationEngineResult) {
//                            val lastLocation = locationEngineResult.lastLocation
//                            if (lastLocation != null) {
//                                reply.put("latitude", lastLocation.latitude)
//                                reply.put("longitude", lastLocation.longitude)
//                                reply.put("altitude", lastLocation.altitude)
//                                result.success(reply)
//                            } else {
//                                result.error("", "", null) // ???
//                            }
//                        }
//
//                        override fun onFailure(exception: Exception) {
//                            result.error("", "", null) // ???
//                        }
//                    })
//                }
//            }
//            "style#addImage" -> {
//                if (style == null) {
//                    result.error("STYLE IS NULL", "The style is null. Has onStyleLoaded() already been invoked?", null)
//                }
//                style!!.addImage(call.argument("name")!!, BitmapFactory.decodeByteArray(call.argument("bytes"), 0, call.argument("length")!!), call.argument("sdf")!!)
//                result.success(null)
//            }
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

//    fun onCameraMoveStarted(reason: Int) {
//        val arguments: MutableMap<String, Any> = HashMap(2)
//        val isGesture = reason == OnCameraMoveStartedListener.REASON_API_GESTURE
//        arguments.put("isGesture", isGesture)
//        methodChannel.invokeMethod("camera#onMoveStarted", arguments)
//    }
//
//    fun onCameraMove() {
//        if (!trackCameraPosition) {
//            return
//        }
//        val arguments: MutableMap<String, Any?> = HashMap(2)
//        arguments.put("position", Convert.toJson(mapboxMap!!.cameraPosition))
//        methodChannel.invokeMethod("camera#onMove", arguments)
//    }
//
//    fun onCameraIdle() {
//        val arguments: MutableMap<String, Any?> = HashMap(2)
//        if (trackCameraPosition) {
//            arguments.put("position", Convert.toJson(mapboxMap!!.cameraPosition))
//        }
//        methodChannel.invokeMethod("camera#onIdle", arguments)
//    }
//
//    fun onCameraTrackingChanged(currentMode: Int) {
//        val arguments: MutableMap<String, Any> = HashMap(2)
//        arguments.put("mode", currentMode)
//        methodChannel.invokeMethod("map#onCameraTrackingChanged", arguments)
//    }
//
//    override fun onCameraTrackingDismissed() {
//        myLocationTrackingMode = 0
//        methodChannel.invokeMethod("map#onCameraTrackingDismissed", HashMap<Any, Any>())
//    }
//
//    override fun onAnnotationClick(annotation: com.mapbox.mapboxsdk.plugins.annotation.Annotation<*>): Boolean {
//        if (annotation is Symbol) {
//            val symbolController = symbols[annotation.getId().toString()]
//            if (symbolController != null) {
//                return symbolController.onTap()
//            }
//        }
//        if (annotation is Line) {
//            val lineController = lines[annotation.getId().toString()]
//            if (lineController != null) {
//                return lineController.onTap()
//            }
//        }
//        if (annotation is Circle) {
//            val circleController = circles[annotation.getId().toString()]
//            if (circleController != null) {
//                return circleController.onTap()
//            }
//        }
//        if (annotation is Fill) {
//            val fillController = fills[annotation.getId().toString()]
//            if (fillController != null) {
//                return fillController.onTap()
//            }
//        }
//        return false
//    }
//
//    override fun onSymbolTapped(symbol: Symbol) {
//        val arguments: MutableMap<String, Any> = HashMap(2)
//        arguments.put("symbol", symbol.id.toString())
//        methodChannel.invokeMethod("symbol#onTap", arguments)
//    }
//
//    override fun onLineTapped(line: Line) {
//        val arguments: MutableMap<String, Any> = HashMap(2)
//        arguments.put("line", line.id.toString())
//        methodChannel.invokeMethod("line#onTap", arguments)
//    }
//
//    override fun onCircleTapped(circle: Circle) {
//        val arguments: MutableMap<String, Any> = HashMap(2)
//        arguments.put("circle", circle.id.toString())
//        methodChannel.invokeMethod("circle#onTap", arguments)
//    }
//
//    override fun onFillTapped(fill: Fill) {
//        val arguments: MutableMap<String, Any> = HashMap(2)
//        arguments.put("fill", fill.id.toString())
//        methodChannel.invokeMethod("fill#onTap", arguments)
//    }
//
//    override fun onMapClick(point: LatLng): Boolean {
//        val pointf = mapboxMap!!.projection.toScreenLocation(point)
//        for (tappableLayer in tappableLayers) {
//            val features = mapboxMap!!.queryRenderedFeatures(pointf, tappableLayer)
//            for (feature in features) {
//                val fArguments: MutableMap<String, Any?> = HashMap(5)
//                fArguments.put("layerId", tappableLayer)
//                fArguments.put("x", pointf.x)
//                fArguments.put("y", pointf.y)
//                fArguments.put("lng", (feature.geometry() as Point?)!!.longitude())
//                fArguments.put("lat", (feature.geometry() as Point?)!!.latitude())
//                methodChannel.invokeMethod("map#onLayerTap", fArguments)
//                return true
//            }
//        }
//        val arguments: MutableMap<String, Any> = HashMap(5)
//        arguments.put("x", pointf.x)
//        arguments.put("y", pointf.y)
//        arguments.put("lng", point.longitude)
//        arguments.put("lat", point.latitude)
//        methodChannel.invokeMethod("map#onMapClick", arguments)
//        return true
//    }
//
//    override fun onMapLongClick(point: LatLng): Boolean {
//        val pointf = mapboxMap!!.projection.toScreenLocation(point)
//        val arguments: MutableMap<String, Any> = HashMap(5)
//        arguments.put("x", pointf.x)
//        arguments.put("y", pointf.y)
//        arguments.put("lng", point.longitude)
//        arguments.put("lat", point.latitude)
//        methodChannel.invokeMethod("map#onMapLongClick", arguments)
//        return true
//    }

    override fun dispose() {
        if (disposed) {
            return
        }
        disposed = true
        methodChannel.setMethodCallHandler(null)
//        destroyMapViewIfNecessary()
//        val lifecycle = lifecycleProvider.getLifecycle()
//        lifecycle?.removeObserver(this)
    }

//    private fun destroyMapViewIfNecessary() {
//        if (mapView == null) {
//            return
//        }
//        if (locationComponent != null) {
//            locationComponent!!.isLocationComponentEnabled = false
//        }
//        if (symbolManager != null) {
//            symbolManager!!.onDestroy()
//        }
//        if (lineManager != null) {
//            lineManager!!.onDestroy()
//        }
//        if (circleManager != null) {
//            circleManager!!.onDestroy()
//        }
//        if (fillManager != null) {
//            fillManager!!.onDestroy()
//        }
//        stopListeningForLocationUpdates()
//        mapView.onDestroy()
//    }

    override fun onCreate(owner: LifecycleOwner) {
        if (disposed) {
            return
        }
//        mapView.onCreate(null)
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
//        mapView.onResume()
        if (myLocationEnabled) {
            startListeningForLocationUpdates()
        }
    }

    override fun onPause(owner: LifecycleOwner) {
        if (disposed) {
            return
        }
//        mapView.onResume()
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
    override fun setCameraTargetBounds(bounds: LatLngBounds?) {
//        mapboxMap!!.setLatLngBoundsForCameraTarget(bounds)
    }

    override fun setCompassEnabled(compassEnabled: Boolean) {
//        mapboxMap!!.uiSettings.isCompassEnabled = compassEnabled
    }

    override fun setTrackCameraPosition(trackCameraPosition: Boolean) {
        this.trackCameraPosition = trackCameraPosition
    }

    override fun setRotateGesturesEnabled(rotateGesturesEnabled: Boolean) {
//        mapboxMap!!.uiSettings.isRotateGesturesEnabled = rotateGesturesEnabled
    }

    override fun setScrollGesturesEnabled(scrollGesturesEnabled: Boolean) {
//        mapboxMap!!.uiSettings.isScrollGesturesEnabled = scrollGesturesEnabled
    }

    override fun setTiltGesturesEnabled(tiltGesturesEnabled: Boolean) {
//        mapboxMap!!.uiSettings.isTiltGesturesEnabled = tiltGesturesEnabled
    }

    override fun setMinMaxZoomPreference(min: Float?, max: Float?) {
//        mapboxMap!!.setMinZoomPreference((min ?: MapboxConstants.MINIMUM_ZOOM).toDouble())
//        mapboxMap!!.setMaxZoomPreference((max ?: MapboxConstants.MAXIMUM_ZOOM).toDouble())
    }

    override fun setZoomGesturesEnabled(zoomGesturesEnabled: Boolean) {
//        mapboxMap!!.uiSettings.isZoomGesturesEnabled = zoomGesturesEnabled
    }

    override fun setMyLocationEnabled(myLocationEnabled: Boolean) {
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

    override fun setLogoViewMargins(x: Int, y: Int) {
//        mapboxMap!!.uiSettings.setLogoMargins(x, 0, 0, y)
    }

    override fun setCompassGravity(gravity: Int) {
//        when (gravity) {
//            0 -> mapboxMap!!.uiSettings.compassGravity = Gravity.TOP or Gravity.START
//            1 -> mapboxMap!!.uiSettings.compassGravity = Gravity.TOP or Gravity.END
//            2 -> mapboxMap!!.uiSettings.compassGravity = Gravity.BOTTOM or Gravity.START
//            3 -> mapboxMap!!.uiSettings.compassGravity = Gravity.BOTTOM or Gravity.END
//            else -> mapboxMap!!.uiSettings.compassGravity = Gravity.TOP or Gravity.END
//        }
    }

    override fun setCompassViewMargins(x: Int, y: Int) {
//        when (mapboxMap!!.uiSettings.compassGravity) {
//            Gravity.TOP or Gravity.START -> mapboxMap!!.uiSettings.setCompassMargins(x, y, 0, 0)
//            Gravity.TOP or Gravity.END -> mapboxMap!!.uiSettings.setCompassMargins(0, y, x, 0)
//            Gravity.BOTTOM or Gravity.START -> mapboxMap!!.uiSettings.setCompassMargins(x, 0, 0, y)
//            Gravity.BOTTOM or Gravity.END -> mapboxMap!!.uiSettings.setCompassMargins(0, 0, x, y)
//            else -> mapboxMap!!.uiSettings.setCompassMargins(0, y, x, 0)
//        }
    }

    override fun setAttributionButtonMargins(x: Int, y: Int) {
//        mapboxMap!!.uiSettings.setAttributionMargins(0, 0, x, y)
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
        kotlin.requireNotNull(permission) { "permission is null" }
        return context.checkPermission(
                permission, Process.myPid(), Process.myUid())
    }

    /**
     * Tries to find highest scale image for display type
     * @param imageId
     * @param density
     * @return
     */
//    private fun getScaledImage(imageId: String, density: Float): Bitmap? {
//        var assetFileDescriptor: AssetFileDescriptor
//
//        // Split image path into parts.
//        val imagePathList = Arrays.asList<String>(*imageId.split("/").toTypedArray())
//        val assetPathList: MutableList<String> = ArrayList()
//
//        // "On devices with a device pixel ratio of 1.8, the asset .../2.0x/my_icon.png would be chosen.
//        // For a device pixel ratio of 2.7, the asset .../3.0x/my_icon.png would be chosen."
//        // Source: https://flutter.dev/docs/development/ui/assets-and-images#resolution-aware
//        for (i in Math.ceil(density.toDouble()).toInt() downTo 1) {
//            var assetPath: String
//            assetPath = if (i == 1) {
//                // If density is 1.0x then simply take the default asset path
//                MapboxMapsPlugin.Companion.flutterAssets!!.getAssetFilePathByName(imageId)
//            } else {
//                // Build a resolution aware asset path as follows:
//                // <directory asset>/<ratio>/<image name>
//                // where ratio is 1.0x, 2.0x or 3.0x.
//                val stringBuilder = StringBuilder()
//                for (j in 0 until imagePathList.size - 1) {
//                    stringBuilder.append(imagePathList[j])
//                    stringBuilder.append("/")
//                }
//                stringBuilder.append((i as Float).toString() + "x")
//                stringBuilder.append("/")
//                stringBuilder.append(imagePathList[imagePathList.size - 1])
//                MapboxMapsPlugin.Companion.flutterAssets!!.getAssetFilePathByName(stringBuilder.toString())
//            }
//            // Build up a list of resolution aware asset paths.
//            assetPathList.add(assetPath)
//        }
//
//        // Iterate over asset paths and get the highest scaled asset (as a bitmap).
//        var bitmap: Bitmap? = null
//        for (assetPath in assetPathList) {
//            try {
//                // Read path (throws exception if doesn't exist).
//                assetFileDescriptor = mapView.context.assets.openFd(assetPath)
//                val assetStream: InputStream = assetFileDescriptor.createInputStream()
//                bitmap = BitmapFactory.decodeStream(assetStream)
//                assetFileDescriptor.close() // Close for memory
//                break // If exists, break
//            } catch (e: IOException) {
//                // Skip
//            }
//        }
//        return bitmap
//    }

    /**
     * Simple Listener to listen for the status of camera movements.
     */
//    open inner class OnCameraMoveFinishedListener : CancelableCallback {
//        override fun onFinish() {}
//        override fun onCancel() {}
//    }

    companion object {
        private const val TAG = "MapboxMapController"
    }

    init {
        val mapOptions = MapOptions.Builder()

        val resourceOptions =  ResourceOptions.Builder()


        val initialCameraOptions = CameraOptions.Builder()
                .center(Point.fromLngLat(-122.4194, 37.7749))
                .zoom(9.0)

                .bearing(120.0)
        val cameraBoundsOptions = CameraBoundsOptions.Builder()


        (params["accessToken"] as String?)?.let { accessToken ->
            resourceOptions.accessToken(accessToken)
        }


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
            listOf(),
            initialCameraOptions.build(),
            true
        )

        mapView = MapView(context,  mapInitOptions)

        (params["options"] as Map<String, Any>?)?.let { options ->
            (options["styleString"] as String?)?.let { styleString ->
                mapView.getMapboxMap().loadStyleUri(styleString)
            }
        }

        methodChannel = MethodChannel(messenger, "plugins.flutter.io/mapbox_maps_$id")
        methodChannel.setMethodCallHandler(this)
    }
}


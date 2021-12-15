package com.mapbox.mapboxgl

import com.google.gson.Gson
import com.google.gson.reflect.TypeToken
import com.mapbox.bindgen.Value
import com.mapbox.maps.MapView
import com.mapbox.maps.QueriedFeature
import com.mapbox.maps.QueryFeaturesCallback
import com.mapbox.maps.SourceQueryOptions
import com.mapbox.maps.extension.observable.eventdata.SourceDataLoadedEventData
import com.mapbox.maps.plugin.delegates.listeners.OnSourceDataLoadedListener
import io.flutter.plugin.common.EventChannel
import java.util.HashMap

class FeaturesStreamHandler(
        client: MapView,
        source: String,
        sourceLayers: List<String>?,
        filter: Any?
) : EventChannel.StreamHandler, OnSourceDataLoadedListener {
    private var events: EventChannel.EventSink? = null
    private val client: MapView = client
    private val source: String = source
    private val sourceLayers: List<String>? = sourceLayers
    private val filter: Any? = filter
    private var layerId: String? = null
    private val gson = Gson()

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        (arguments as Map<String, Any?>?)?.let { args ->
            layerId = args["layerId"] as String?
            this.events = events;

            client.getMapboxMap().addOnSourceDataLoadedListener(this)

            dispatchFeatures();
        }
    }

    override fun onCancel(arguments: Any?) {
        this.events = null
    }

    private fun getFilter(): Value {
        if (filter is Double) {
            return Value.valueOf(filter)
        }
        if (filter is Long) {
            return Value.valueOf(filter)
        }
        if (filter is Boolean) {
            return Value.valueOf(filter)
        }
        if (filter is List<*> || filter is HashMap<*, *> ) {
            val json = gson.toJson(filter);
            val expected = Value.fromJson(json)
            if (expected.isValue) {
                return expected.value!!
            }
        }

        return Value.nullValue()
    }

    private fun dispatchFeatures() {
        val queryOptions = SourceQueryOptions(sourceLayers, getFilter())

        this.events?.let { events ->

            client.getMapboxMap().querySourceFeatures(source, queryOptions, QueryFeaturesCallback { result ->

                ( result.value as List<QueriedFeature>?)?.let { qFeatures ->
                    val rawFeaturess = qFeatures.map<QueriedFeature, Map<String, Any>> {  feature ->
                        val json = gson.toJson(feature.feature);

                        return@map gson.fromJson(
                                json,
                                object : TypeToken<HashMap<String?, Any?>?>() {}.type
                        );
                    }
                    events.success(rawFeaturess )

                }
            })

        }

    }
    override fun onSourceDataLoaded(eventData: SourceDataLoadedEventData) {
        if (eventData.id == source) {
            dispatchFeatures()
        }
    }

}
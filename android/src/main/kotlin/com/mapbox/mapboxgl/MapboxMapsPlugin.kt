// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
package com.mapbox.mapboxgl

import androidx.lifecycle.Lifecycle
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterAssets
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.embedding.engine.plugins.lifecycle.FlutterLifecycleAdapter
import io.flutter.plugin.common.MethodChannel

/**
 * Plugin for controlling a set of MapboxMap views to be shown as overlays on top of the Flutter
 * view. The overlay should be hidden during transformations or while Flutter is rendering on top of
 * the map. A Texture drawn using MapboxMap bitmap snapshots can then be shown instead of the
 * overlay.
 */
class MapboxMapsPlugin : FlutterPlugin, ActivityAware, LifecycleProvider {
    private var lifecycle: Lifecycle? = null

    // New Plugin APIs
    override fun onAttachedToEngine(binding: FlutterPluginBinding) {
        flutterAssets = binding.flutterAssets
        val methodChannel = MethodChannel(binding.binaryMessenger, "plugins.flutter.io/mapbox_gl")
        methodChannel.setMethodCallHandler(GlobalMethodHandler(binding))
        binding
                .platformViewRegistry
                .registerViewFactory(
                        "plugins.flutter.io/mapbox_gl", MapboxMapFactory(binding.binaryMessenger, this))
    }

    override fun onDetachedFromEngine(binding: FlutterPluginBinding) {
        // no-op
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        lifecycle = FlutterLifecycleAdapter.getActivityLifecycle(binding)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        onDetachedFromActivity()
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        onAttachedToActivity(binding)
    }

    override fun onDetachedFromActivity() {
        lifecycle = null
    }


    companion object {
        private const val VIEW_TYPE = "plugins.flutter.io/mapbox_gl"
        var flutterAssets: FlutterAssets? = null

    }

    override fun getLifecycle(): Lifecycle? {
        return lifecycle
    }
}

interface LifecycleProvider {
    fun getLifecycle(): Lifecycle?
}
package com.mapbox.mapboxgl

import android.content.Context
import android.content.pm.PackageManager
import android.util.Log
import com.mapbox.mapboxsdk.Mapbox

internal object MapBoxUtils {
    private const val TAG = "MapboxMapController"
    fun getMapbox(context: Context, accessToken: String?): Mapbox {
        return Mapbox.getInstance(context, accessToken ?: getAccessToken(context))
    }

    private fun getAccessToken(context: Context): String? {
        try {
            val ai = context.packageManager
                    .getApplicationInfo(context.packageName, PackageManager.GET_META_DATA)
            val bundle = ai.metaData
            val token = bundle.getString("com.mapbox.token")
            if (token == null || token.isEmpty()) {
                throw NullPointerException()
            }
            return token
        } catch (e: Exception) {
            Log.e(TAG, "Failed to find an Access Token in the Application meta-data. Maps may not load correctly. " +
                    "Please refer to the installation guide at https://github.com/tobrun/flutter-mapbox-gl#mapbox-access-token " +
                    "for troubleshooting advice." + e.message)
        }
        return null
    }
}
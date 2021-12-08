
import MapboxMaps

protocol MapboxMapOptionsSink {
    func setCameraTargetBounds(bounds: CoordinateBounds?)
    func setCompassEnabled(enabled: Bool)
    func setStyleString(styleString: String)
    func setMinMaxZoomPreference(min: Double, max: Double)
    func setMinMaxPitchPreference(min: Double, max: Double)
    func setRotateGesturesEnabled(enabled: Bool)
    func setScrollGesturesEnabled(enabled: Bool)
    func setTiltGesturesEnabled(enabled: Bool)
    func setTrackCameraPosition(trackCameraPosition: Bool)
    func setZoomGesturesEnabled(enabled: Bool)
    func setMyLocationEnabled(enabled: Bool)
    func setMyLocationTrackingMode(myLocationTrackingMode: MyLocationTrackingMode)
    //func setMyLocationRenderMode(renderMode: MyLocationRenderMode)
    func setLogoViewMargins(x: Double, y: Double)
    func setCompassViewPosition(position: OrnamentPosition)
    func setCompassViewMargins(x: Double, y: Double)
    func setAttributionButtonMargins(x: Double, y: Double)
}

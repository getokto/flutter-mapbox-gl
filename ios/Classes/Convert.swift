import MapboxMaps
import Foundation

class Convert {
    class func interpretMapboxMapOptions(options: Any?, delegate: MapboxMapOptionsSink) {
        guard let options = options as? [String: Any] else { return }
        if let cameraTargetBounds = options["cameraTargetBounds"] as? [[[Double]]] {
            delegate.setCameraTargetBounds(bounds: CoordinateBounds.fromArray(cameraTargetBounds[0]))
        }
        if let compassEnabled = options["compassEnabled"] as? Bool {
            delegate.setCompassEnabled(enabled: compassEnabled)
        }
        if let minMaxZoomPreference = options["minMaxZoomPreference"] as? [Double] {
            delegate.setMinMaxZoomPreference(min: minMaxZoomPreference[0], max: minMaxZoomPreference[1])
        }
        if let minMaxPitchPreference = options["minMaxPitchPreference"] as? [Double] {
            delegate.setMinMaxPitchPreference(min: minMaxPitchPreference[0], max: minMaxPitchPreference[1])
        }
        if let styleString = options["styleString"] as? String {
            delegate.setStyleString(styleString: styleString)
        }
        if let rotateGesturesEnabled = options["rotateGesturesEnabled"] as? Bool {
            delegate.setRotateGesturesEnabled(enabled: rotateGesturesEnabled)
        }
        if let scrollGesturesEnabled = options["scrollGesturesEnabled"] as? Bool {
            delegate.setScrollGesturesEnabled(enabled: scrollGesturesEnabled)
        }
        if let tiltGesturesEnabled = options["tiltGesturesEnabled"] as? Bool {
            delegate.setTiltGesturesEnabled(enabled: tiltGesturesEnabled)
        }
        if let trackCameraPosition = options["trackCameraPosition"] as? Bool {
            delegate.setTrackCameraPosition(trackCameraPosition: trackCameraPosition)
        }
        if let zoomGesturesEnabled = options["zoomGesturesEnabled"] as? Bool {
            delegate.setZoomGesturesEnabled(enabled: zoomGesturesEnabled)
        }
        if let myLocationEnabled = options["myLocationEnabled"] as? Bool {
            delegate.setMyLocationEnabled(enabled: myLocationEnabled)
        }
        if let myLocationTrackingMode = options["myLocationTrackingMode"] as? UInt, let trackingMode = MyLocationTrackingMode(rawValue: myLocationTrackingMode) {
            delegate.setMyLocationTrackingMode(myLocationTrackingMode: trackingMode)
        }
//        if let myLocationRenderMode = options["myLocationRenderMode"] as? Int, let renderMode = MyLocationRenderMode(rawValue: myLocationRenderMode) {
//            delegate.setMyLocationRenderMode(renderMode: renderMode)
//        }
        if let logoViewMargins = options["logoViewMargins"] as? [Double] {
            delegate.setLogoViewMargins(x: logoViewMargins[0], y: logoViewMargins[1])
        }
//        if let compassViewPosition = options["compassViewPosition"] as? UInt, let position = MGLOrnamentPosition(rawValue: compassViewPosition) {
//            delegate.setCompassViewPosition(position: position)
//        }
        if let compassViewMargins = options["compassViewMargins"] as? [Double] {
            delegate.setCompassViewMargins(x: compassViewMargins[0], y: compassViewMargins[1])
        }
        if let attributionButtonMargins = options["attributionButtonMargins"] as? [Double] {
            delegate.setAttributionButtonMargins(x: attributionButtonMargins[0], y: attributionButtonMargins[1])
        }
    }
    
    
    class func toPolygons(geometry: [[[Double]]]) -> [Polygon] {
        var polygons:[Polygon] = []
        for lineString in geometry {
            var linearRing: [CLLocationCoordinate2D] = []
            for coordinate in lineString {
                linearRing.append(CLLocationCoordinate2DMake(coordinate[0], coordinate[1]))
            }
            let polygon = Polygon([linearRing])
            polygons.append(polygon)
        }
        return polygons
    }
    
    class func serializeJSON(from object:Any) -> String? {
        do {
            let isArray = object is NSArray
            let isDictionary = object is NSDictionary
            if ( !isArray && !isDictionary ) {
                return nil
            }

            guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
                return nil
            }
            return String(data: data, encoding: String.Encoding.utf8)
        } catch {
            return nil
        }
    }
    
    class func deserializeJSON(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    class func getVectorURLTemplated( properties: [String: Any]) -> [String] {
        var urls: [String] = []
        for (propertyName, propertyValue) in properties {
            switch propertyName {
                case "tiles":
                    let uriList = propertyValue as? [String]
                    if uriList != nil {
                        for uri in uriList! {
                            urls.append(uri.removingPercentEncoding!);
                        }
                    }
                    
                default:
                    break
            }
        }
        return urls
    }
}

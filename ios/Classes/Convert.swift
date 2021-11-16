import MapboxMaps
import Foundation

class Convert {
    class func interpretMapboxMapOptions(options: Any?, delegate: MapboxMapOptionsSink) {
        guard let options = options as? [String: Any] else { return }
        if let cameraTargetBounds = options["cameraTargetBounds"] as? [[[Double]]] {
            delegate.setCameraTargetBounds(bounds: CoordinateBounds.fromArray(cameraTargetBounds[0]))
        }
        if let compassEnabled = options["compassEnabled"] as? Bool {
            delegate.setCompassEnabled(compassEnabled: compassEnabled)
        }
        if let minMaxZoomPreference = options["minMaxZoomPreference"] as? [Double] {
            delegate.setMinMaxZoomPreference(min: minMaxZoomPreference[0], max: minMaxZoomPreference[1])
        }
        if let styleString = options["styleString"] as? String {
            delegate.setStyleString(styleString: styleString)
        }
        if let rotateGesturesEnabled = options["rotateGesturesEnabled"] as? Bool {
            delegate.setRotateGesturesEnabled(rotateGesturesEnabled: rotateGesturesEnabled)
        }
        if let scrollGesturesEnabled = options["scrollGesturesEnabled"] as? Bool {
            delegate.setScrollGesturesEnabled(scrollGesturesEnabled: scrollGesturesEnabled)
        }
        if let tiltGesturesEnabled = options["tiltGesturesEnabled"] as? Bool {
            delegate.setTiltGesturesEnabled(tiltGesturesEnabled: tiltGesturesEnabled)
        }
        if let trackCameraPosition = options["trackCameraPosition"] as? Bool {
            delegate.setTrackCameraPosition(trackCameraPosition: trackCameraPosition)
        }
        if let zoomGesturesEnabled = options["zoomGesturesEnabled"] as? Bool {
            delegate.setZoomGesturesEnabled(zoomGesturesEnabled: zoomGesturesEnabled)
        }
        if let myLocationEnabled = options["myLocationEnabled"] as? Bool {
            delegate.setMyLocationEnabled(myLocationEnabled: myLocationEnabled)
        }
//        if let myLocationTrackingMode = options["myLocationTrackingMode"] as? UInt, let trackingMode = UserTrackingMode(rawValue: myLocationTrackingMode) {
//            delegate.setMyLocationTrackingMode(myLocationTrackingMode: trackingMode)
//        }
        if let myLocationRenderMode = options["myLocationRenderMode"] as? Int, let renderMode = MyLocationRenderMode(rawValue: myLocationRenderMode) {
            delegate.setMyLocationRenderMode(myLocationRenderMode: renderMode)
        }
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
    
    class func parseCameraUpdate(cameraUpdate: [Any], mapView: MapView) -> CameraBoundsOptions? {
//        guard let type = cameraUpdate[0] as? String else { return nil }
//        switch (type) {
//        case "newCameraPosition":
//            guard let cameraPosition = cameraUpdate[1] as? [String: Any] else { return nil }
//            return MGLMapCamera.fromDict(cameraPosition, mapView: mapView)
//        case "newLatLng":
//            guard let coordinate = cameraUpdate[1] as? [Double] else { return nil }
//            let camera = mapView.camera
//            camera.centerCoordinate = CLLocationCoordinate2D.fromArray(coordinate)
//            return camera
//        case "newLatLngBounds":
//            guard let bounds = cameraUpdate[1] as? [[Double]] else { return nil }
//            guard let paddingLeft = cameraUpdate[2] as? CGFloat else { return nil }
//            guard let paddingTop = cameraUpdate[3] as? CGFloat else { return nil }
//            guard let paddingRight = cameraUpdate[4] as? CGFloat else { return nil }
//            guard let paddingBottom = cameraUpdate[5] as? CGFloat else { return nil }
//            return mapView.cameraThatFitsCoordinateBounds(MGLCoordinateBounds.fromArray(bounds), edgePadding: UIEdgeInsets.init(top: paddingTop, left: paddingLeft, bottom: paddingBottom, right: paddingRight))
//        case "newLatLngZoom":
//            guard let coordinate = cameraUpdate[1] as? [Double] else { return nil }
//            guard let zoom = cameraUpdate[2] as? Double else { return nil }
//            let camera = mapView.camera
//            camera.centerCoordinate = CLLocationCoordinate2D.fromArray(coordinate)
//            let altitude = getAltitude(zoom: zoom, mapView: mapView)
//            return MGLMapCamera(lookingAtCenter: camera.centerCoordinate, altitude: altitude, pitch: camera.pitch, heading: camera.heading)
//        case "scrollBy":
//            guard let x = cameraUpdate[1] as? CGFloat else { return nil }
//            guard let y = cameraUpdate[2] as? CGFloat else { return nil }
//            let camera = mapView.camera
//            let mapPoint = mapView.convert(camera.centerCoordinate, toPointTo: mapView)
//            let movedPoint = CGPoint(x: mapPoint.x + x, y: mapPoint.y + y)
//            camera.centerCoordinate = mapView.convert(movedPoint, toCoordinateFrom: mapView)
//            return camera
//        case "zoomBy":
//            guard let zoomBy = cameraUpdate[1] as? Double else { return nil }
//            let camera = mapView.camera
//            let zoom = getZoom(mapView: mapView)
//            let altitude = getAltitude(zoom: zoom+zoomBy, mapView: mapView)
//            camera.altitude = altitude
//            if (cameraUpdate.count == 2) {
//                return camera
//            } else {
//                guard let point = cameraUpdate[2] as? [CGFloat], point.count == 2 else { return nil }
//                let movedPoint = CGPoint(x: point[0], y: point[1])
//                camera.centerCoordinate = mapView.convert(movedPoint, toCoordinateFrom: mapView)
//                return camera
//            }
//        case "zoomIn":
//            let camera = mapView.camera
//            let zoom = getZoom(mapView: mapView)
//            let altitude = getAltitude(zoom: zoom + 1, mapView: mapView)
//            camera.altitude = altitude
//            return camera
//        case "zoomOut":
//            let camera = mapView.camera
//            let zoom = getZoom(mapView: mapView)
//            let altitude = getAltitude(zoom: zoom - 1, mapView: mapView)
//            camera.altitude = altitude
//            return camera
//        case "zoomTo":
//            guard let zoom = cameraUpdate[1] as? Double else { return nil }
//            let camera = mapView.camera
//            let altitude = getAltitude(zoom: zoom, mapView: mapView)
//            camera.altitude = altitude
//            return camera
//        case "bearingTo":
//            guard let bearing = cameraUpdate[1] as? Double else { return nil }
//            let camera = mapView.camera
//            camera.heading = bearing
//            return camera
//        case "tiltTo":
//            guard let tilt = cameraUpdate[1] as? CGFloat else { return nil }
//            let camera = mapView.camera
//            camera.pitch = tilt
//            return camera
//        default:
//            print("\(type) not implemented!")
//        }
        return nil
    }
    
    class func getZoom(mapView: MapView) -> Double {
        return mapView.mapboxMap.cameraState.zoom;
        
//        return MGLZoomLevelForAltitude(mapView.camera.altitude, mapView.camera.pitch, mapView.camera.centerCoordinate.latitude, mapView.frame.size)
    }
    
//    class func getAltitude(zoom: Double, mapView: MapView) -> Double {
//        return mapView.mapboxMap.cameraState.a
//        return MGLAltitudeForZoomLevel(zoom, mapView.camera.pitch, mapView.camera.centerCoordinate.latitude, mapView.frame.size)
//    }

//    class func interpretSymbolOptions(options: Any?, delegate: SymbolStyleAnnotation) {
//        guard let options = options as? [String: Any] else { return }
//        if let iconSize = options["iconSize"] as? CGFloat {
//            delegate.iconScale = iconSize
//        }
//        if let iconImage = options["iconImage"] as? String {
//            delegate.iconImageName = iconImage
//        }
//        if let iconRotate = options["iconRotate"] as? CGFloat {
//            delegate.iconRotation = iconRotate
//        }
//        if let iconOffset = options["iconOffset"] as? [Double] {
//            delegate.iconOffset = CGVector(dx: iconOffset[0], dy: iconOffset[1])
//        }
//        if let iconAnchorStr = options["iconAnchor"] as? String {
//            if let iconAnchor = Constants.symbolIconAnchorMapping[iconAnchorStr] {
//                delegate.iconAnchor = iconAnchor
//            } else {
//                delegate.iconAnchor = IconAnchor.center
//            }
//        }
//        if let iconOpacity = options["iconOpacity"] as? CGFloat {
//            delegate.iconOpacity = iconOpacity
//        }
//        if let iconColor = options["iconColor"] as? String {
//            delegate.iconColor = UIColor(hexString: iconColor) ?? UIColor.black
//        }
//        if let iconHaloColor = options["iconHaloColor"] as? String {
//            delegate.iconHaloColor = UIColor(hexString: iconHaloColor) ?? UIColor.white
//        }
//        if let iconHaloWidth = options["iconHaloWidth"] as? CGFloat {
//            delegate.iconHaloWidth = iconHaloWidth
//        }
//        if let iconHaloBlur = options["iconHaloBlur"] as? CGFloat {
//            delegate.iconHaloBlur = iconHaloBlur
//        }
//        if let fontNames = options["fontNames"] as? [String] {
//            delegate.fontNames = fontNames
//        }
//        if let textField = options["textField"] as? String {
//            delegate.text = textField
//        }
//        if let textSize = options["textSize"] as? CGFloat {
//            delegate.textFontSize = textSize
//        }
//        if let textMaxWidth = options["textMaxWidth"] as? CGFloat {
//            delegate.maximumTextWidth = textMaxWidth
//        }
//        if let textLetterSpacing = options["textLetterSpacing"] as? CGFloat {
//            delegate.textLetterSpacing = textLetterSpacing
//        }
//        if let textJustify = options["textJustify"] as? String {
//            if let textJustifaction = Constants.symbolTextJustificationMapping[textJustify] {
//                delegate.textJustification = textJustifaction
//            } else {
//                delegate.textJustification = TextJustify.center
//            }
//        }
//        if let textRadialOffset = options["textRadialOffset"] as? CGFloat {
//            delegate.textRadialOffset = textRadialOffset
//        }
//        if let textAnchorStr = options["textAnchor"] as? String {
//            if let textAnchor = Constants.symbolTextAnchorMapping[textAnchorStr] {
//                delegate.textAnchor = textAnchor
//            } else {
//                delegate.textAnchor = TextAnchor.center
//            }
//        }
//        if let textRotate = options["textRotate"] as? CGFloat {
//            delegate.textRotation = textRotate
//        }
//        if let textTransform = options["textTransform"] as? String {
//            if let textTransformation = Constants.symbolTextTransformationMapping[textTransform] {
//                delegate.textTransform = textTransformation
//            } else {
//                delegate.textTransform = TextTransform.none
//            }
//        }
//        if let textTranslate = options["textTranslate"] as? [Double] {
//            delegate.textTranslation = CGVector(dx: textTranslate[0], dy: textTranslate[1])
//        }
//        if let textOffset = options["textOffset"] as? [Double] {
//            delegate.textOffset = CGVector(dx: textOffset[0], dy: textOffset[1])
//        }
//        if let textOpacity = options["textOpacity"] as? CGFloat {
//            delegate.textOpacity = textOpacity
//        }
//        if let textColor = options["textColor"] as? String {
//            delegate.textColor = UIColor(hexString: textColor) ?? UIColor.black
//        }
//        if let textHaloColor = options["textHaloColor"] as? String {
//            delegate.textHaloColor = UIColor(hexString: textHaloColor) ?? UIColor.white
//        }
//        if let textHaloWidth = options["textHaloWidth"] as? CGFloat {
//            delegate.textHaloWidth = textHaloWidth
//        }
//        if let textHaloBlur = options["textHaloBlur"] as? CGFloat {
//            delegate.textHaloBlur = textHaloBlur
//        }
//        if let geometry = options["geometry"] as? [Double] {
//            // We cannot set the geometry directy on the annotation so calculate
//            // the difference and update the coordinate using the delta.
//            let currCoord = delegate.feature.coordinate
//            let newCoord = CLLocationCoordinate2DMake(geometry[0], geometry[1])
//            let delta = CGVector(dx: newCoord.longitude - currCoord.longitude, dy: newCoord.latitude - currCoord.latitude)
//            delegate.updateGeometryCoordinates(withDelta: delta)
//        }
//        if let zIndex = options["zIndex"] as? Int {
//            delegate.symbolSortKey = zIndex
//        }
//        if let draggable = options["draggable"] as? Bool {
//            delegate.isDraggable = draggable
//        }
//    }
//    
//    class func interpretCircleOptions(options: Any?, delegate: MGLCircleStyleAnnotation) {
//        guard let options = options as? [String: Any] else { return }
//        if let circleRadius = options["circleRadius"] as? CGFloat {
//            delegate.circleRadius = circleRadius
//        }
//        if let circleColor = options["circleColor"] as? String {
//            delegate.circleColor = UIColor(hexString: circleColor) ?? UIColor.black
//        }
//        if let circleBlur = options["circleBlur"] as? CGFloat {
//            delegate.circleBlur = circleBlur
//        }
//        if let circleOpacity = options["circleOpacity"] as? CGFloat {
//            delegate.circleOpacity = circleOpacity
//        }
//        if let circleStrokeWidth = options["circleStrokeWidth"] as? CGFloat {
//            delegate.circleStrokeWidth = circleStrokeWidth
//        }
//        if let circleStrokeColor = options["circleStrokeColor"] as? String {
//            delegate.circleStrokeColor = UIColor(hexString: circleStrokeColor) ?? UIColor.black
//        }
//        if let circleStrokeOpacity = options["circleStrokeOpacity"] as? CGFloat {
//            delegate.circleStrokeOpacity = circleStrokeOpacity
//        }
//        if let geometry = options["geometry"] as? [Double] {
//            delegate.center = CLLocationCoordinate2DMake(geometry[0], geometry[1])
//        }
//        if let draggable = options["draggable"] as? Bool {
//            delegate.isDraggable = draggable
//        }
//    }
//
//    class func interpretLineOptions(options: Any?, delegate: MGLLineStyleAnnotation) {
//        guard let options = options as? [String: Any] else { return }
//        if let lineJoinStr = options["lineJoin"] as? String {
//            if let lineJoin = Constants.lineJoinMapping[lineJoinStr] {
//                delegate.lineJoin = lineJoin
//            } else {
//                delegate.lineJoin = MGLLineJoin.miter
//            }
//        }
//        if let lineOpacity = options["lineOpacity"] as? CGFloat {
//            delegate.lineOpacity = lineOpacity
//        }
//        if let lineColor = options["lineColor"] as? String {
//            delegate.lineColor = UIColor(hexString: lineColor) ?? UIColor.black
//        }
//        if let lineWidth = options["lineWidth"] as? CGFloat {
//            delegate.lineWidth = lineWidth
//        }
//        if let lineGapWidth = options["lineGapWidth"] as? CGFloat {
//            delegate.lineGapWidth = lineGapWidth
//        }
//        if let lineOffset = options["lineOffset"] as? CGFloat {
//            delegate.lineOffset = lineOffset
//        }
//        if let lineBlur = options["lineBlur"] as? CGFloat {
//            delegate.lineBlur = lineBlur
//        }
//        if let linePattern = options["linePattern"] as? String {
//            delegate.linePattern = linePattern
//        }
//        if let draggable = options["draggable"] as? Bool {
//            delegate.isDraggable = draggable
//        }
//    }
//
//    class func interpretFillOptions(options: Any?, delegate: MGLPolygonStyleAnnotation) {
//        guard let options = options as? [String: Any] else { return }
//        if let fillOpacity = options["fillOpacity"] as? CGFloat {
//            delegate.fillOpacity = fillOpacity
//        }
//        if let fillColor = options["fillColor"] as? String {
//            delegate.fillColor = UIColor(hexString: fillColor) ?? UIColor.black
//        }
//        if let fillOutlineColor = options["fillOutlineColor"] as? String {
//            delegate.fillOutlineColor = UIColor(hexString: fillOutlineColor) ?? UIColor.black
//        }
//        if let fillPattern = options["fillPattern"] as? String {
//            delegate.fillPattern = fillPattern
//        }
//        if let draggable = options["draggable"] as? Bool {
//            delegate.isDraggable = draggable
//        }
//    }

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
    
    class func parseExpression<T: Decodable>(data: Any, model: T.Type? = nil) -> Value<T> {
        let jsonString = serializeJSON(from: data)

        if jsonString != nil,
           let expression = try? JSONDecoder().decode(Expression.self, from: jsonString!.data(using: .utf8)!) {
            
            return .expression(expression)
        }
        
        if data is String && model != nil {
//            let datadata = (data as! String).data(using: .utf8)!
               
            
            
            
//            let decoder = JSONDecoder();
//            let container = try decoder.container(keyedBy: RootCodingKeys.self)
            
            
            
            
//            container.decodeIfPresent(<#T##Bool#>, forKey: <#T##KeyedDecodingContainer<K>#>)
//            let nextValue = try? JSONDecoder().decode(model!.self, from: datadata)
//            if (nextValue != nil) {
//                return .constant(nextValue as! T)
//            }

        }
        return .constant(data as! T)
        
    }
    
    class func addSymbolProperties(symbolLayer: SymbolLayer, properties: [String: Any]) {
        var _symbolLayer = symbolLayer
        for (_, propertyTypeValue) in properties {
            for (propertyName, propertyValue) in propertyTypeValue as! [String: Any] {
                /*
                //let expr = NSExpression(mglJSONObject: propertyValue)
                let jsonString = serializeJSON(from: propertyValue)
                
                let exp = jsonString != nil
                    ? JSONDecoder().decode(Expression.self, from: jsonString.data(using: .utf8)!)
                    : Expression(
                
                let data = jsonString.data(using: .utf8)
                
*/
                switch propertyName {
                    case "icon-allow-overlap":
                    
                    _symbolLayer.iconAllowOverlap = parseExpression(data: propertyValue)
                    //symbolLayer.iconAllowsOverlap = expr
                    case "icon-anchor":
                        _symbolLayer.iconAnchor = parseExpression(data: propertyValue)
                    case "icon-color":
                        _symbolLayer.iconColor = parseExpression(data: propertyValue)
                    case "icon-halo-blur":
                        _symbolLayer.iconHaloBlur = parseExpression(data: propertyValue)
                    case "icon-halo-color":
                        _symbolLayer.iconHaloColor = parseExpression(data: propertyValue)
                    case "icon-halo-width":
                        _symbolLayer.iconHaloWidth = parseExpression(data: propertyValue)
                    case "icon-ignore-placement":
                        _symbolLayer.iconIgnorePlacement = parseExpression(data: propertyValue)
                    case "icon-image":
                        _symbolLayer.iconImage = parseExpression(data: propertyValue)
                    case "icon-keep-upright":
                        _symbolLayer.iconKeepUpright = parseExpression(data: propertyValue)
                    case "icon-offset":
                        _symbolLayer.iconOffset = parseExpression(data: propertyValue)
                    case "icon-opacity":
                        _symbolLayer.iconOpacity = parseExpression(data: propertyValue)
                    case "icon-optional":
                        _symbolLayer.iconOptional = parseExpression(data: propertyValue)
                    case "icon-padding":
                        _symbolLayer.iconPadding = parseExpression(data: propertyValue)
                    case "icon-pitch-alignment":
                        _symbolLayer.iconPitchAlignment = parseExpression(data: propertyValue)
                    case "icon-rotate":
                        _symbolLayer.iconRotate = parseExpression(data: propertyValue)
                    case "icon-rotation-alignment":
                        _symbolLayer.iconRotationAlignment = parseExpression(data: propertyValue)
                    case "icon-size":
                        _symbolLayer.iconSize = parseExpression(data: propertyValue)
                    case "icon-text-fit":
                        _symbolLayer.iconTextFit = parseExpression(data: propertyValue)
                    case "icon-text-fit-padding":
                        _symbolLayer.iconTextFitPadding = parseExpression(data: propertyValue)
                    case "icon-translate":
                        _symbolLayer.iconTranslate = parseExpression(data: propertyValue)
                    case "icon-translate-anchor":
                        _symbolLayer.iconTranslateAnchor = parseExpression(data: propertyValue)
                    case "symbol-avoid-edges":
                        _symbolLayer.symbolAvoidEdges = parseExpression(data: propertyValue)
                    case "symbol-placement":
                        _symbolLayer.symbolPlacement = parseExpression(data: propertyValue)
                    case "symbol-sort-key":
                        _symbolLayer.symbolSortKey = parseExpression(data: propertyValue)
                    case "symbol-spacing":
                        _symbolLayer.symbolSpacing = parseExpression(data: propertyValue)
                    case "symbol-z-order":
                        _symbolLayer.symbolZOrder = parseExpression(data: propertyValue)
                    case "text-allow-overlap":
                        _symbolLayer.textAllowOverlap = parseExpression(data: propertyValue)
                    case "text-anchor":
                        _symbolLayer.textAnchor = parseExpression(data: propertyValue)
                    case "text-color":
                        _symbolLayer.textColor = parseExpression(data: propertyValue)
                    case "text-field":
                        _symbolLayer.textField = parseExpression(data: propertyValue)
                    case "text-font":
                        _symbolLayer.textFont = parseExpression(data: propertyValue)
                    case "text-halo-blur":
                        _symbolLayer.textHaloBlur = parseExpression(data: propertyValue)
                    case "text-halo-color":
                        _symbolLayer.textHaloColor = parseExpression(data: propertyValue)
                    case "text-halo-width":
                        _symbolLayer.textHaloWidth = parseExpression(data: propertyValue)
                    case "text-ignore-placement":
                        _symbolLayer.textIgnorePlacement = parseExpression(data: propertyValue)
                    case "text-justify":
                        _symbolLayer.textJustify = parseExpression(data: propertyValue)
                    case "text-keep-upright":
                        _symbolLayer.textKeepUpright = parseExpression(data: propertyValue)
                    case "text-letter-spacing":
                        _symbolLayer.textLetterSpacing = parseExpression(data: propertyValue)
                    case "text-line-height":
                        _symbolLayer.textLineHeight = parseExpression(data: propertyValue)
                    case "text-max-angle":
                        _symbolLayer.textMaxAngle = parseExpression(data: propertyValue)
                    case "text-max-width":
                        _symbolLayer.textMaxWidth = parseExpression(data: propertyValue)
                    case "text-offset":
                        _symbolLayer.textOffset = parseExpression(data: propertyValue)
                    case "text-opacity":
                        _symbolLayer.textOpacity = parseExpression(data: propertyValue)
                    case "text-optional":
                        _symbolLayer.textOptional = parseExpression(data: propertyValue)
                    case "text-padding":
                        _symbolLayer.textPadding = parseExpression(data: propertyValue)
                    case "text-pitch-alignment":
                        _symbolLayer.textPitchAlignment = parseExpression(data: propertyValue)
                    case "text-radial-offset":
                        _symbolLayer.textRadialOffset = parseExpression(data: propertyValue)
                    case "text-rotate":
                        _symbolLayer.textRotate = parseExpression(data: propertyValue)
                    case "text-rotation-alignment":
                        _symbolLayer.textRotationAlignment = parseExpression(data: propertyValue)
                    case "text-size":
                        _symbolLayer.textSize = parseExpression(data: propertyValue)
                    case "text-transform":
                        _symbolLayer.textTransform = parseExpression(data: propertyValue)
                    case "text-translate":
                        _symbolLayer.textTranslate = parseExpression(data: propertyValue)
                    case "text-translate-anchor":
                        _symbolLayer.textTranslateAnchor = parseExpression(data: propertyValue)
                    case "text-variable-anchor":
                        _symbolLayer.textVariableAnchor = parseExpression(data: propertyValue)
                    case "text-writing-mode":
                        _symbolLayer.textWritingMode = parseExpression(data: propertyValue)
                    default:
                        break
                }
            }
        }
    }

    class func addLineProperties(lineLayer: LineLayer, properties: [String: Any]) {
        var _lineLayer = lineLayer
        

        let jsonString = serializeJSON(from: properties)
        
        let lineLayer = try? JSONDecoder().decode(LineLayer.self, from: jsonString!.data(using: .utf8)!)
        
        
        for (_, propertyTypeValue) in properties {
            
            for (propertyName, propertyValue) in propertyTypeValue as! [String: Any] {
                switch propertyName {
                    case "line-blur":
                        _lineLayer.lineBlur = parseExpression(data: propertyValue)
                    case "line-cap":
                        _lineLayer.lineCap = parseExpression(data: propertyValue)
                    case "line-color":
                        _lineLayer.lineColor = parseExpression(data: propertyValue)
                    case "line-dasharray":
                        _lineLayer.lineDasharray = parseExpression(data: propertyValue)
                    case "line-gap-width":
                        _lineLayer.lineGapWidth = parseExpression(data: propertyValue)
                    case "line-gradient":
                        _lineLayer.lineGradient = parseExpression(data: propertyValue)
                    case "line-join":
                        _lineLayer.lineJoin = parseExpression(data: propertyValue)
                    case "line-miter-limit":
                        _lineLayer.lineMiterLimit = parseExpression(data: propertyValue)
                    case "line-offset":
                        _lineLayer.lineOffset = parseExpression(data: propertyValue)
                    case "line-pattern":
                        _lineLayer.linePattern = parseExpression(data: propertyValue)
                    case "line-round-limit":
                        _lineLayer.lineRoundLimit = parseExpression(data: propertyValue)
                    case "line-translate":
                        _lineLayer.lineTranslate = parseExpression(data: propertyValue)
                    case "line-translate-anchor":
                        _lineLayer.lineTranslateAnchor = parseExpression(data: propertyValue)
                    case "line-width":
                        _lineLayer.lineWidth = parseExpression(data: propertyValue)
                    default:
                        break
                }
            }
        }
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
    
//    class func getVectorSourceOptions( properties: [String: Any]) -> [MGLTileSourceOption: Any] {
//        var options: [MGLTileSourceOption: Any] = [:]
//        for (propertyName, propertyValue) in properties {
//            switch propertyName {
//                case "maxZoom":
//                    options[.maximumZoomLevel] = propertyValue
//                case "minZoom":
//                    options[.minimumZoomLevel] = propertyValue
//                default:
//                    break
//            }
//        }
//        return options
//    }
//
//    class func getGeoJsonSourceOptions( properties: [String: Any]) -> [MGLShapeSourceOption: Any] {
//        var options: [MGLShapeSourceOption: Any] = [:]
//        for (propertyName, propertyValue) in properties {
//            switch propertyName {
//                case "maxZoom":
//                    options[.maximumZoomLevel] = propertyValue
//                case "buffer":
//                    options[.buffer] = propertyValue
//                case "cluster":
//                    options[.clustered] = propertyValue
//                case "clusterMaxZoom":
//                    options[.maximumZoomLevelForClustering] = propertyValue
//                case "clusterProperties":
//                    options[.clusterProperties] = propertyValue
//                case "clusterRadius":
//                    options[.clusterRadius] = propertyValue
//                case "lineMetrics":
//                    options[.lineDistanceMetrics] = propertyValue
//                case "tolerance":
//                    options[.simplificationTolerance] = propertyValue
//                default:
//                    break
//            }
//        }
//        return options
//    }
}

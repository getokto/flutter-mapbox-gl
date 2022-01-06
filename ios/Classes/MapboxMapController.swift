import Flutter
import UIKit
import MapboxMaps
import streams_channel3

public class CameraLocationConsumer: LocationConsumer {
    let duration: Double
    let onLocationUpdate: (Location) -> ()
    
    init(duration: Double, onLocationUpdate: @escaping (Location) -> ()) {
        self.duration = duration
        self.onLocationUpdate = onLocationUpdate
    }

    public func locationUpdate(newLocation: Location) {
        onLocationUpdate(newLocation)
    }
}


enum MyLocationTrackingMode: UInt, CaseIterable {
  case None
  case Tracking
  case TrackingCompass
  case TrackingGPS
}

class MapboxMapController: NSObject, FlutterPlatformView, MapboxMapOptionsSink, LocationPermissionsDelegate, GestureManagerDelegate {

    private var registrar: FlutterPluginRegistrar
    private var channel: FlutterMethodChannel?
    private var streamChannel: FlutterStreamsChannel?
    
    private var mapView: MapView
    private var isMapReady = false
    private var mapReadyResult: FlutterResult?
    
    private var initialPitch: CGFloat?
    private var cameraTargetBounds: CoordinateBounds?
    private var trackCameraPosition = false
    private var myLocationEnabled = false


    private var annotationOrder = [String]()
    private var annotationConsumeTapEvents = [String]()
    
    private var cameraLocationConsumer: CameraLocationConsumer? = nil


    func view() -> UIView {
        return mapView
    }
    
    init(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?, registrar: FlutterPluginRegistrar) {
        var cameraOptions: CameraOptions?
        var styleUri: String?
        var cameraBoundsOptions = CameraBoundsOptions()
        var myLocationEnabled = false
        var myLocationTrackingMode = MyLocationTrackingMode.None
        if let args = args as? [String: Any] {
            if let token = args["accessToken"] as? String {
                ResourceOptionsManager.default.resourceOptions.accessToken = token
            }
            
            if let initialCameraPosition = args["initialCameraPosition"] as? [String: Any] {
                cameraOptions = CameraOptions.fromDict(initialCameraPosition)
            }
            
            if let options = args["options"] as? [String: Any] {
                if let styleString = options["styleString"] as? String {
                    styleUri = styleString
                }

            }
            
            if let minMaxPitch = args["minMaxPitchPreferences"] as? [Double?], minMaxPitch.count == 2 {
                if let min = minMaxPitch[0] as? Double {
                    cameraBoundsOptions.minPitch = min
                }
                
                if let max = minMaxPitch[1] as? Double {
                    cameraBoundsOptions.maxPitch = max
                }
            }
            
            if let minMaxZoom = args["minMaxZoomPreferences"] as? [Double?], minMaxZoom.count == 2 {
                if let min = minMaxZoom[0] as? Double {
                    cameraBoundsOptions.minZoom = min
                }
                
                if let max = minMaxZoom[1] as? Double {
                    cameraBoundsOptions.maxZoom = max
                }
            }
            if let _myLocationTrackingMode = args["myLocationTrackingMode"] as? UInt,
               let trackingMode = MyLocationTrackingMode(rawValue: _myLocationTrackingMode) {
                myLocationTrackingMode = trackingMode
            }
            
            if let _myLocationEnabled = args["myLocationEnabled"] as? Bool {
               myLocationEnabled = _myLocationEnabled
            }
        }
                
        let initOptions = MapInitOptions(
            cameraOptions: cameraOptions,
            styleURI: styleUri != nil ? StyleURI(rawValue: styleUri!) : nil
        )
        
        
        mapView = MapView(frame: frame, mapInitOptions: initOptions)
        

                
        
        try? mapView.mapboxMap.setCameraBounds(with: cameraBoundsOptions)
       
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.registrar = registrar
        
        super.init()
        
        cameraLocationConsumer = CameraLocationConsumer(duration: 1.3, onLocationUpdate: handleUserLocationChange)

        mapView.gestures.delegate = self
        
        mapView.mapboxMap.onNext(.mapLoaded) { _ in
            self.setMyLocationEnabled(enabled: myLocationEnabled)
            self.setMyLocationTrackingMode(myLocationTrackingMode: myLocationTrackingMode)
        }
        
        mapView.mapboxMap.onNext(.styleDataLoaded, handler: onMapStyleLoaded)
        
        channel = FlutterMethodChannel(name: "plugins.flutter.io/mapbox_maps_\(viewId)", binaryMessenger: registrar.messenger())
        channel!.setMethodCallHandler{ [weak self] in self?.onMethodCall(methodCall: $0, result: $1) }
        
        streamChannel = FlutterStreamsChannel(name: "plugins.flutter.io/mapbox_maps_event_stream", binaryMessenger: registrar.messenger())
        
        streamChannel?.setStreamHandlerFactory { arguments in
            if (!(arguments is Dictionary<String, Any>)){
                return nil
            }

           
            if let args = arguments as? Dictionary<String, Any> {
                if let handlerName = args["handler"] as? String {
                    let source = args["source"] as? String
                    switch(handlerName){
                    case "dataChanged":
                        return FeaturesStreamHandler(
                            client: self.mapView,
                            source: source!,
                            sourceLayers: args["source-layers"] as? [String],
                            filter: args["filter"] as Any
                        );
                    
                    default:
                        return nil
                    }
                }
            }
            
            
            return nil;
        }

        
        
        mapView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleMapTap)))
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleMapLongPress))
        for recognizer in mapView.gestureRecognizers! where recognizer is UILongPressGestureRecognizer {
            longPress.require(toFail: recognizer)
        }
        mapView.addGestureRecognizer(longPress)

        if let args = args as? [String: Any] {
            Convert.interpretMapboxMapOptions(options: args["options"], delegate: self)
            if let annotationOrderArg = args["annotationOrder"] as? [String] {
                annotationOrder = annotationOrderArg
            }
            if let annotationConsumeTapEventsArg = args["annotationConsumeTapEvents"] as? [String] {
                annotationConsumeTapEvents = annotationConsumeTapEventsArg
            }
//            if let onAttributionClickOverride = args["onAttributionClickOverride"] as? Bool {
//                if  onAttributionClickOverride {
//                    setupAttribution(mapView)
//                }
//            }
        }
    }
    
    func onMapStyleLoaded(event: Event) {
        isMapReady = true
        //mapReadyResult?(nil)
        initLocationComponent();
        channel?.invokeMethod("map#onStyleLoaded", arguments: nil)
    }
//    func removeAllForController(controller: MGLAnnotationController, ids: [String]){
//        let idSet = Set(ids)
//        let annotations = controller.styleAnnotations()
//        controller.removeStyleAnnotations(annotations.filter { idSet.contains($0.identifier) })
//    }
    
    func onMethodCall(methodCall: FlutterMethodCall, result: @escaping FlutterResult) {
        switch(methodCall.method) {
        case "map#waitForMap":
            /*if isMapReady {
                result(nil)
            } else {
                mapReadyResult = result
            }*/
            
            result(nil)
        case "map#update":
            guard let arguments = methodCall.arguments as? [String: Any] else { return }
            Convert.interpretMapboxMapOptions(options: arguments["options"], delegate: self)
            if let camera = getCamera() {
                result(camera.toDict())
            } else {
                result(nil)
            }
            result(nil)
//        case "map#invalidateAmbientCache":
//            MGLOfflineStorage.shared.invalidateAmbientCache{
//                (error) in
//                if let error = error {
//                    result(error)
//                } else{
//                    result(nil)
//                }
//            }
        case "map#updateMyLocationTrackingMode":
            guard let arguments = methodCall.arguments as? [String: Any] else { return }
            if let myLocationTrackingMode = arguments["mode"] as? UInt, let trackingMode = MyLocationTrackingMode(rawValue: myLocationTrackingMode) {
                setMyLocationTrackingMode(myLocationTrackingMode: trackingMode)
            }
            result(nil)
//        case "map#matchMapLanguageWithDeviceDefault":
//            if let style = mapView.style {
//                style.localizeLabels(into: nil)
//            }
//            result(nil)
//        case "map#updateContentInsets":
//            guard let arguments = methodCall.arguments as? [String: Any] else { return }
//
//            if let bounds = arguments["bounds"] as? [String: Any],
//                let top = bounds["top"] as? CGFloat,
//                let left = bounds["left"]  as? CGFloat,
//                let bottom = bounds["bottom"] as? CGFloat,
//                let right = bounds["right"] as? CGFloat,
//                let animated = arguments["animated"] as? Bool {
//                mapView.setContentInset(UIEdgeInsets(top: top, left: left, bottom: bottom, right: right), animated: animated) {
//                    result(nil)
//                }
//            } else {
//                result(nil)
//            }
        // case "map#setMapLanguage":
        //     guard let arguments = methodCall.arguments as? [String: Any] else { return }
        //     if let localIdentifier = arguments["language"] as? String, let style = mapView.style {
        //         let locale = Locale(identifier: localIdentifier)
        //         style.localizeLabels(into: locale)
        //     }
        //     result(nil)
        // case "map#queryRenderedFeatures":
        //     guard let arguments = methodCall.arguments as? [String: Any] else { return }
        //     let layerIds = arguments["layerIds"] as? Set<String>
        //     var filterExpression: NSPredicate?
        //     if let filter = arguments["filter"] as? [Any] {
        //         filterExpression = NSPredicate(mglJSONObject: filter)
        //     }
        //     var reply = [String: NSObject]()
        //     var features:[MGLFeature] = []
        //     if let x = arguments["x"] as? Double, let y = arguments["y"] as? Double {
        //         features = mapView.visibleFeatures(at: CGPoint(x: x, y: y), styleLayerIdentifiers: layerIds, predicate: filterExpression)
        //     }
        //     if  let top = arguments["top"] as? Double,
        //         let bottom = arguments["bottom"] as? Double,
        //         let left = arguments["left"] as? Double,
        //         let right = arguments["right"] as? Double {
        //         features = mapView.visibleFeatures(in: CGRect(x: left, y: top, width: right, height: bottom), styleLayerIdentifiers: layerIds, predicate: filterExpression)
        //     }
        //     var featuresJson = [String]()
        //     for feature in features {
        //         let dictionary = feature.geoJSONDictionary()
        //         if  let theJSONData = try? JSONSerialization.data(withJSONObject: dictionary, options: []),
        //             let theJSONText = String(data: theJSONData, encoding: .ascii) {
        //             featuresJson.append(theJSONText)
        //         }
        //     }
        //     reply["features"] = featuresJson as NSObject
        //     result(reply)
        // case "map#setTelemetryEnabled":
        //     guard let arguments = methodCall.arguments as? [String: Any] else { return }
        //     let telemetryEnabled = arguments["enabled"] as? Bool
        //     UserDefaults.standard.set(telemetryEnabled, forKey: "MGLMapboxMetricsEnabled")
        //     result(nil)
        // case "map#getTelemetryEnabled":
        //     let telemetryEnabled = UserDefaults.standard.bool(forKey: "MGLMapboxMetricsEnabled")
        //     result(telemetryEnabled)
        // case "map#getVisibleRegion":
        //     var reply = [String: NSObject]()
        //     let visibleRegion = mapView.visibleCoordinateBounds
        //     reply["sw"] = [visibleRegion.sw.latitude, visibleRegion.sw.longitude] as NSObject
        //     reply["ne"] = [visibleRegion.ne.latitude, visibleRegion.ne.longitude] as NSObject
        //     result(reply)
        // case "map#toScreenLocation":
        //     guard let arguments = methodCall.arguments as? [String: Any] else { return }
        //     guard let latitude = arguments["latitude"] as? Double else { return }
        //     guard let longitude = arguments["longitude"] as? Double else { return }
        //     let latlng = CLLocationCoordinate2DMake(latitude, longitude)
        //     let returnVal = mapView.convert(latlng, toPointTo: mapView)
        //     var reply = [String: NSObject]()
        //     reply["x"] = returnVal.x as NSObject
        //     reply["y"] = returnVal.y as NSObject
        //     result(reply)
        // case "map#toScreenLocationBatch":
        //     guard let arguments = methodCall.arguments as? [String: Any] else { return }
        //     guard let data = arguments["coordinates"] as? FlutterStandardTypedData else { return }
        //     let latLngs = data.data.withUnsafeBytes {
        //         Array(
        //             UnsafeBufferPointer(
        //                 start: $0.baseAddress!.assumingMemoryBound(to: Double.self),
        //                 count:Int(data.elementCount))
        //         )
        //     }
        //     var reply: [Double] = Array(repeating: 0.0, count: latLngs.count)
        //     for i in stride(from: 0, to: latLngs.count, by: 2) {
        //         let coordinate = CLLocationCoordinate2DMake(latLngs[i], latLngs[i + 1])
        //         let returnVal = mapView.convert(coordinate, toPointTo: mapView)
        //         reply[i] = Double(returnVal.x)
        //         reply[i + 1] = Double(returnVal.y)
        //     }
        //     result(FlutterStandardTypedData(
        //             float64: Data(bytes: &reply, count: reply.count * 8) ))
        // case "map#getMetersPerPixelAtLatitude":
        //      guard let arguments = methodCall.arguments as? [String: Any] else { return }
        //      var reply = [String: NSObject]()
        //      guard let latitude = arguments["latitude"] as? Double else { return }
        //      let returnVal = mapView.metersPerPoint(atLatitude:latitude)
        //      reply["metersperpixel"] = returnVal as NSObject
        //      result(reply)
        // case "map#toLatLng":
        //     guard let arguments = methodCall.arguments as? [String: Any] else { return }
        //     guard let x = arguments["x"] as? Double else { return }
        //     guard let y = arguments["y"] as? Double else { return }
        //     let screenPoint: CGPoint = CGPoint(x: x, y:y)
        //     let coordinates: CLLocationCoordinate2D = mapView.convert(screenPoint, toCoordinateFrom: mapView)
        //     var reply = [String: NSObject]()
        //     reply["latitude"] = coordinates.latitude as NSObject
        //     reply["longitude"] = coordinates.longitude as NSObject
        //     result(reply)
        case "camera#move":
            guard let arguments = methodCall.arguments as? [String: Any] else { return }
            guard let cameraUpdate = arguments["cameraUpdate"] as? [Any] else { return }
            if let camera = Convert.parseCameraUpdate(cameraUpdate: cameraUpdate, mapView: mapView) {
                mapView.mapboxMap.setCamera(to: camera)
            }
            result(nil)
         case "camera#animate":
            guard let arguments = methodCall.arguments as? [String: Any] else { return }
            guard let cameraUpdate = arguments["cameraUpdate"] as? [Any] else { return }
            if let cameraOptions = Convert.parseCameraUpdate(cameraUpdate: cameraUpdate, mapView: mapView) {
                 if let duration = arguments["duration"] as? TimeInterval {
                     mapView.camera.fly(to: cameraOptions, duration: duration) { position in
                         result(nil)
                     }
                 } else {
                     mapView.camera.fly(to: cameraOptions, duration: nil) { position in
                         result(nil)
                     }
                 }                
            }
             //result(nil)
        // case "symbols#addAll":
        //     guard let symbolAnnotationController = symbolAnnotationController else { return }
        //     guard let arguments = methodCall.arguments as? [String: Any] else { return }

        //     if let options = arguments["options"] as? [[String: Any]] {
        //         var symbols: [MGLSymbolStyleAnnotation] = [];
        //         for o in options {
        //             if let symbol = getSymbolForOptions(options: o)  {
        //                 symbols.append(symbol)
        //             }
        //         }
        //         if !symbols.isEmpty {
        //             symbolAnnotationController.addStyleAnnotations(symbols)
        //             symbolAnnotationController.annotationsInteractionEnabled = annotationConsumeTapEvents.contains("AnnotationType.symbol")
        //         }

        //         result(symbols.map { $0.identifier })
        //     } else {
        //         result(nil)
        //     }
        // case "symbol#update":
        //     guard let symbolAnnotationController = symbolAnnotationController else { return }
        //     guard let arguments = methodCall.arguments as? [String: Any] else { return }
        //     guard let symbolId = arguments["symbol"] as? String else { return }

        //     for symbol in symbolAnnotationController.styleAnnotations(){
        //         if symbol.identifier == symbolId {
        //             Convert.interpretSymbolOptions(options: arguments["options"], delegate: symbol as! MGLSymbolStyleAnnotation)
        //             // Load (updated) icon image from asset if an icon name is supplied.
        //             if let options = arguments["options"] as? [String: Any],
        //                 let iconImage = options["iconImage"] as? String {
        //                 addIconImageToMap(iconImageName: iconImage)
        //             }
        //             symbolAnnotationController.updateStyleAnnotation(symbol)
        //             break;
        //         }
        //     }
        //     result(nil)
        // case "symbols#removeAll":
        //     guard let symbolAnnotationController = symbolAnnotationController else { return }
        //     guard let arguments = methodCall.arguments as? [String: Any] else { return }
        //     guard let symbolIds = arguments["ids"] as? [String] else { return }

        //     removeAllForController(controller:symbolAnnotationController, ids:symbolIds)
        //     result(nil)

        // case "symbol#getGeometry":
        //     guard let symbolAnnotationController = symbolAnnotationController else { return }
        //     guard let arguments = methodCall.arguments as? [String: Any] else { return }
        //     guard let symbolId = arguments["symbol"] as? String else { return }

        //     var reply: [String:Double]? = nil
        //     for symbol in symbolAnnotationController.styleAnnotations(){
        //         if symbol.identifier == symbolId {
        //             if let geometry = symbol.geoJSONDictionary["geometry"] as? [String: Any],
        //                 let coordinates = geometry["coordinates"] as? [Double] {
        //                 reply = ["latitude": coordinates[1], "longitude": coordinates[0]]
        //             }
        //             break;
        //         }
        //     }
        //     result(reply)
        // case "symbolManager#iconAllowOverlap":
        //     guard let symbolAnnotationController = symbolAnnotationController else { return }
        //     guard let arguments = methodCall.arguments as? [String: Any] else { return }
        //     guard let iconAllowOverlap = arguments["iconAllowOverlap"] as? Bool else { return }

        //     symbolAnnotationController.iconAllowsOverlap = iconAllowOverlap
        //     result(nil)
        // case "symbolManager#iconIgnorePlacement":
        //     guard let symbolAnnotationController = symbolAnnotationController else { return }
        //     guard let arguments = methodCall.arguments as? [String: Any] else { return }
        //     guard let iconIgnorePlacement = arguments["iconIgnorePlacement"] as? Bool else { return }

        //     symbolAnnotationController.iconIgnoresPlacement = iconIgnorePlacement
        //     result(nil)
        // case "symbolManager#textAllowOverlap":
        //     guard let symbolAnnotationController = symbolAnnotationController else { return }
        //     guard let arguments = methodCall.arguments as? [String: Any] else { return }
        //     guard let textAllowOverlap = arguments["textAllowOverlap"] as? Bool else { return }

        //     symbolAnnotationController.textAllowsOverlap = textAllowOverlap
        //     result(nil)
        // case "symbolManager#textIgnorePlacement":
        //     result(FlutterMethodNotImplemented)
        // case "circle#add":
        //     guard let circleAnnotationController = circleAnnotationController else { return }
        //     guard let arguments = methodCall.arguments as? [String: Any] else { return }
        //     // Parse geometry
        //     if let options = arguments["options"] as? [String: Any],
        //         let geometry = options["geometry"] as? [Double] {
        //         // Convert geometry to coordinate and create circle.
        //         let coordinate = CLLocationCoordinate2DMake(geometry[0], geometry[1])
        //         let circle = MGLCircleStyleAnnotation(center: coordinate)
        //         Convert.interpretCircleOptions(options: arguments["options"], delegate: circle)
        //         circleAnnotationController.addStyleAnnotation(circle)
        //         circleAnnotationController.annotationsInteractionEnabled = annotationConsumeTapEvents.contains("AnnotationType.circle")
        //         result(circle.identifier)
        //     } else {
        //         result(nil)
        //     }

        // case "circle#addAll":
        //     guard let circleAnnotationController = circleAnnotationController else { return }
        //     guard let arguments = methodCall.arguments as? [String: Any] else { return }
        //     // Parse geometry
        //     var identifier: String? = nil
        //     if let allOptions = arguments["options"] as? [[String: Any]]{
        //         var circles: [MGLCircleStyleAnnotation] = [];

        //         for options in allOptions {
        //             if let geometry = options["geometry"] as? [Double] {
        //                 guard geometry.count > 0 else { break }

        //                 let coordinate = CLLocationCoordinate2DMake(geometry[0], geometry[1])
        //                 let circle = MGLCircleStyleAnnotation(center: coordinate)
        //                 Convert.interpretCircleOptions(options: options, delegate: circle)
        //                 circles.append(circle)
        //             }
        //         }
        //         if !circles.isEmpty {
        //             circleAnnotationController.addStyleAnnotations(circles)
        //         }
        //         result(circles.map { $0.identifier })
        //     }
        //     else {
        //         result(nil)
        //     }
  
        // case "circle#update":
        //     guard let circleAnnotationController = circleAnnotationController else { return }
        //     guard let arguments = methodCall.arguments as? [String: Any] else { return }
        //     guard let circleId = arguments["circle"] as? String else { return }
            
        //     for circle in circleAnnotationController.styleAnnotations() {
        //         if circle.identifier == circleId {
        //             Convert.interpretCircleOptions(options: arguments["options"], delegate: circle as! MGLCircleStyleAnnotation)
        //             circleAnnotationController.updateStyleAnnotation(circle)
        //             break;
        //         }
        //     }
        //     result(nil)
        // case "circle#remove":
        //     guard let circleAnnotationController = circleAnnotationController else { return }
        //     guard let arguments = methodCall.arguments as? [String: Any] else { return }
        //     guard let circleId = arguments["circle"] as? String else { return }
            
        //     for circle in circleAnnotationController.styleAnnotations() {
        //         if circle.identifier == circleId {
        //             circleAnnotationController.removeStyleAnnotation(circle)
        //             break;
        //         }
        //     }
        //     result(nil)

        // case "circle#removeAll":
        //     guard let circleAnnotationController = circleAnnotationController else { return }
        //     guard let arguments = methodCall.arguments as? [String: Any] else { return }
        //     guard let ids = arguments["ids"] as? [String] else { return }

        //     removeAllForController(controller:circleAnnotationController, ids:ids)
        //     result(nil)

        
        // case "line#add":
        //     guard let lineAnnotationController = lineAnnotationController else { return }
        //     guard let arguments = methodCall.arguments as? [String: Any] else { return }
        //     // Parse geometry
        //     if let options = arguments["options"] as? [String: Any],
        //         let geometry = options["geometry"] as? [[Double]] {
        //         // Convert geometry to coordinate and create a line.
        //         var lineCoordinates: [CLLocationCoordinate2D] = []
        //         for coordinate in geometry {
        //             lineCoordinates.append(CLLocationCoordinate2DMake(coordinate[0], coordinate[1]))
        //         }
        //         let line = MGLLineStyleAnnotation(coordinates: lineCoordinates, count: UInt(lineCoordinates.count))
        //         Convert.interpretLineOptions(options: arguments["options"], delegate: line)
        //         lineAnnotationController.addStyleAnnotation(line)
        //         lineAnnotationController.annotationsInteractionEnabled = annotationConsumeTapEvents.contains("AnnotationType.line")
        //         result(line.identifier)
        //     } else {
        //         result(nil)
        //     }
        
        // case "line#addAll":
        //     guard let lineAnnotationController = lineAnnotationController else { return }
        //     guard let arguments = methodCall.arguments as? [String: Any] else { return }
        //     // Parse geometry
        //     var identifier: String? = nil
        //     if let allOptions = arguments["options"] as? [[String: Any]]{
        //         var lines: [MGLLineStyleAnnotation] = [];

        //         for options in allOptions {
        //             if let geometry = options["geometry"] as? [[Double]] {
        //                 guard geometry.count > 0 else { break }
        //                 // Convert geometry to coordinate and create a line.
        //                 var lineCoordinates: [CLLocationCoordinate2D] = []
        //                 for coordinate in geometry {
        //                     lineCoordinates.append(CLLocationCoordinate2DMake(coordinate[0], coordinate[1]))
        //                 }
        //                 let line = MGLLineStyleAnnotation(coordinates: lineCoordinates, count: UInt(lineCoordinates.count))
        //                 Convert.interpretLineOptions(options: options, delegate: line)
        //                 lines.append(line)
        //             }
        //         }
        //         if !lines.isEmpty {
        //             lineAnnotationController.addStyleAnnotations(lines)
        //         }
        //         result(lines.map { $0.identifier })
        //     }
        //     else {
        //         result(nil)
        //     }
  

        // case "line#update":
        //     guard let lineAnnotationController = lineAnnotationController else { return }
        //     guard let arguments = methodCall.arguments as? [String: Any] else { return }
        //     guard let lineId = arguments["line"] as? String else { return }
            
        //     for line in lineAnnotationController.styleAnnotations() {
        //         if line.identifier == lineId {
        //             Convert.interpretLineOptions(options: arguments["options"], delegate: line as! MGLLineStyleAnnotation)
        //             lineAnnotationController.updateStyleAnnotation(line)
        //             break;
        //         }
        //     }
        //     result(nil)
        // case "line#remove":
        //     guard let lineAnnotationController = lineAnnotationController else { return }
        //     guard let arguments = methodCall.arguments as? [String: Any] else { return }
        //     guard let lineId = arguments["line"] as? String else { return }
            
        //     for line in lineAnnotationController.styleAnnotations() {
        //         if line.identifier == lineId {
        //             lineAnnotationController.removeStyleAnnotation(line)
        //             break;
        //         }
        //     }
        //     result(nil)

        // case "line#removeAll":
        //     guard let lineAnnotationController = lineAnnotationController else { return }
        //     guard let arguments = methodCall.arguments as? [String: Any] else { return }
        //     guard let ids = arguments["ids"] as? [String] else { return }

        //     removeAllForController(controller:lineAnnotationController, ids:ids)
        //     result(nil)

         case "style#geoJsonSourceAdd":
             guard let arguments = methodCall.arguments as? [String: Any] else { return }
             guard let sourceId = arguments["sourceId"] as? String else { return }
             guard let geojson = arguments["geojson"] as? String else { return }
             let properties = arguments["properties"] as? [String: Any] ?? [:]

             addGeoJsonSource(sourceId: sourceId, geojson: geojson, properties: properties)

             result(nil)
         case "style#vectorSourceAdd":
             guard let arguments = methodCall.arguments as? [String: Any] else { return }
             guard let sourceId = arguments["sourceId"] as? String else { return }
             guard let properties = arguments["properties"] as? [String: Any] else { return }

             addVectorSource(sourceId: sourceId, properties: properties)

             result(nil)
         case "style#symbolLayerAdd":
             guard let arguments = methodCall.arguments as? [String: Any] else { return }
             guard let sourceId = arguments["source"] as? String else { return }
             guard let layerId = arguments["id"] as? String else { return }
             guard let tappable = arguments["tappable"] as? Bool else { return }
             guard let properties = arguments["properties"] as? [String: Any] else { return }
             let sourceLayerId = arguments["source-layer"] as? String
            
             addSymbolLayer(sourceId: sourceId, layerId: layerId, sourceLayerId: sourceLayerId, properties: properties)
            
             if tappable {
                 tappableLayers.insert(layerId)
             } else {
                 tappableLayers.remove(layerId)
             }
           
             result(nil)
            
         case "style#lineLayerAdd":
             guard let arguments = methodCall.arguments as? [String: Any] else { return }
             guard let sourceId = arguments["source"] as? String else { return }
             guard let layerId = arguments["id"] as? String else { return }
             guard let tappable = arguments["tappable"] as? Bool else { return }
             guard let properties = arguments["properties"] as? [String: Any] else { return }
             let sourceLayerId = arguments["source-layer"] as? String
            
             addLineLayer(sourceId: sourceId, layerId: layerId, sourceLayerId: sourceLayerId, properties: properties)

             if tappable {
                 tappableLayers.insert(layerId)
             } else {
                 tappableLayers.remove(layerId)
             }
            
             result(nil)
        case "style#circleLayerAdd":
            guard let arguments = methodCall.arguments as? [String: Any] else { return }
            guard let sourceId = arguments["source"] as? String else { return }
            guard let layerId = arguments["id"] as? String else { return }
            guard let tappable = arguments["tappable"] as? Bool else { return }
            guard let properties = arguments["properties"] as? [String: Any] else { return }
            let sourceLayerId = arguments["source-layer"] as? String
           
            addCircleLayer(sourceId: sourceId, layerId: layerId, sourceLayerId: sourceLayerId, properties: properties)

            if tappable {
                tappableLayers.insert(layerId)
            } else {
                tappableLayers.remove(layerId)
            }
           
            result(nil)
        case "style#fillLayerAdd":
            guard let arguments = methodCall.arguments as? [String: Any] else { return }
            guard let sourceId = arguments["source"] as? String else { return }
            guard let layerId = arguments["id"] as? String else { return }
            guard let tappable = arguments["tappable"] as? Bool else { return }
            guard let properties = arguments["properties"] as? [String: Any] else { return }
            let sourceLayerId = arguments["source-layer"] as? String
           
            addFillLayer(sourceId: sourceId, layerId: layerId, sourceLayerId: sourceLayerId, properties: properties)

            if tappable {
                tappableLayers.insert(layerId)
            } else {
                tappableLayers.remove(layerId)
            }
           
            result(nil)
        case "style#lineLayerUpdate": fallthrough
        case "style#symbolLayerUpdate": fallthrough
        case "style#circleLayerUpdate": fallthrough
        case "style#fillLayerUpdate": fallthrough
        case "style#layerUpdate":
             guard let arguments = methodCall.arguments as? [String: Any] else { return }
             guard let layerId = arguments["id"] as? String else { return }
             guard let properties = arguments["properties"] as? [String: Any] else { return }
            
            updateLayer(layerId: layerId, properties: properties)
                       
             result(nil)
        case "style#lineLayerRemove": fallthrough
        case "style#symbolLayerRemove": fallthrough
        case "style#circleLayerRemove": fallthrough
        case "style#fillLayerRemove": fallthrough
        case "style#layerRemove":
             guard let arguments = methodCall.arguments as? [String: Any] else { return }
             guard let layerId = arguments["id"] as? String else { return }
            
            removeLayer(layerId: layerId)
            tappableLayers.remove(layerId)
                       
            result(nil)
        // case "line#getGeometry":
        //     guard let lineAnnotationController = lineAnnotationController else { return }
        //     guard let arguments = methodCall.arguments as? [String: Any] else { return }
        //     guard let lineId = arguments["line"] as? String else { return }

        //     var reply: [Any]? = nil
        //     for line in lineAnnotationController.styleAnnotations() {
        //         if line.identifier == lineId {
        //             if let geometry = line.geoJSONDictionary["geometry"] as? [String: Any],
        //                 let coordinates = geometry["coordinates"] as? [[Double]] {
        //                 reply = coordinates.map { [ "latitude": $0[1], "longitude": $0[0] ] }
        //             }
        //             break;
        //         }
        //     }
        //     result(reply)
        // case "fill#add":
        //     guard let fillAnnotationController = fillAnnotationController else { return }
        //     guard let arguments = methodCall.arguments as? [String: Any] else { return }
        //     // Parse geometry
        //     var identifier: String? = nil
        //     if let options = arguments["options"] as? [String: Any],
        //         let geometry = options["geometry"] as? [[[Double]]] {
        //         guard geometry.count > 0 else { break }
        //         // Convert geometry to coordinate and interior polygonc.
        //         var fillCoordinates: [CLLocationCoordinate2D] = []
        //         for coordinate in geometry[0] {
        //             fillCoordinates.append(CLLocationCoordinate2DMake(coordinate[0], coordinate[1]))
        //         }
        //         let polygons = Convert.toPolygons(geometry: geometry.tail)
        //         let fill = MGLPolygonStyleAnnotation(coordinates: fillCoordinates, count: UInt(fillCoordinates.count), interiorPolygons: polygons)
        //         Convert.interpretFillOptions(options: arguments["options"], delegate: fill)
        //         fillAnnotationController.addStyleAnnotation(fill)
        //         fillAnnotationController.annotationsInteractionEnabled = annotationConsumeTapEvents.contains("AnnotationType.fill")
        //         identifier = fill.identifier
        //     }

        //     result(identifier)

        // case "fill#addAll":
        //     guard let fillAnnotationController = fillAnnotationController else { return }
        //     guard let arguments = methodCall.arguments as? [String: Any] else { return }
        //     // Parse geometry
        //     var identifier: String? = nil
        //     if let allOptions = arguments["options"] as? [[String: Any]]{
        //         var fills: [MGLPolygonStyleAnnotation] = [];

        //         for options in allOptions{
        //             if let geometry = options["geometry"] as? [[[Double]]] {
        //                 guard geometry.count > 0 else { break }
        //                 // Convert geometry to coordinate and interior polygonc.
        //                 var fillCoordinates: [CLLocationCoordinate2D] = []
        //                 for coordinate in geometry[0] {
        //                     fillCoordinates.append(CLLocationCoordinate2DMake(coordinate[0], coordinate[1]))
        //                 }
        //                 let polygons = Convert.toPolygons(geometry: geometry.tail)
        //                 let fill = MGLPolygonStyleAnnotation(coordinates: fillCoordinates, count: UInt(fillCoordinates.count), interiorPolygons: polygons)
        //                 Convert.interpretFillOptions(options: options, delegate: fill)
        //                 fills.append(fill)
        //             }
        //         }
        //         if !fills.isEmpty {
        //             fillAnnotationController.addStyleAnnotations(fills)
        //         }
        //         result(fills.map { $0.identifier })
        //     }
        //     else {
        //         result(nil)
        //     }

        // case "fill#update":
        //     guard let fillAnnotationController = fillAnnotationController else { return }
        //     guard let arguments = methodCall.arguments as? [String: Any] else { return }
        //     guard let fillId = arguments["fill"] as? String else { return }
        
        //     for fill in fillAnnotationController.styleAnnotations() {
        //         if fill.identifier == fillId {
        //             Convert.interpretFillOptions(options: arguments["options"], delegate: fill as! MGLPolygonStyleAnnotation)
        //             fillAnnotationController.updateStyleAnnotation(fill)
        //             break;
        //         }
        //     }
            
        //     result(nil)
        // case "fill#remove":
        //     guard let fillAnnotationController = fillAnnotationController else { return }
        //     guard let arguments = methodCall.arguments as? [String: Any] else { return }
        //     guard let fillId = arguments["fill"] as? String else { return }
        
        //     for fill in fillAnnotationController.styleAnnotations() {
        //         if fill.identifier == fillId {
        //             fillAnnotationController.removeStyleAnnotation(fill)
        //             break;
        //         }
        //     }
        //     result(nil)

        // case "fill#removeAll":
        //     guard let fillAnnotationController = fillAnnotationController else { return }
        //     guard let arguments = methodCall.arguments as? [String: Any] else { return }
        //     guard let ids = arguments["ids"] as? [String] else { return }

        //     removeAllForController(controller:fillAnnotationController, ids:ids)
        //     result(nil)

         case "style#addImage":
            guard let arguments = methodCall.arguments as? [String: Any] else { return }
            guard let name = arguments["name"] as? String else { return }
            guard let bytes = arguments["bytes"] as? FlutterStandardTypedData else { return }
            guard let sdf = arguments["sdf"] as? Bool else { return }
            guard let image = UIImage(data: bytes.data) else { return }
            if let style = mapView.mapboxMap.style as? Style {
                try? style.addImage(
                    image,
                    id: name,
                    sdf: sdf,
                    stretchX: [],
                    stretchY: []
                 )
            }
             result(nil)

            
        // case "style#addImageSource":
        //     guard let arguments = methodCall.arguments as? [String: Any] else { return }
        //     guard let imageSourceId = arguments["imageSourceId"] as? String else { return }
        //     guard let bytes = arguments["bytes"] as? FlutterStandardTypedData else { return }
        //     guard let data = bytes.data as? Data else { return }
        //     guard let image = UIImage(data: data) else { return }
            
        //     guard let coordinates = arguments["coordinates"] as? [[Double]] else { return };
        //     let quad = MGLCoordinateQuad(
        //         topLeft: CLLocationCoordinate2D(latitude: coordinates[0][0], longitude: coordinates[0][1]),
        //         bottomLeft: CLLocationCoordinate2D(latitude: coordinates[3][0], longitude: coordinates[3][1]),
        //         bottomRight: CLLocationCoordinate2D(latitude: coordinates[2][0], longitude: coordinates[2][1]),
        //         topRight: CLLocationCoordinate2D(latitude: coordinates[1][0], longitude: coordinates[1][1])
        //     )
            
        //     //Check for duplicateSource error
        //     if (self.mapView.style?.source(withIdentifier:  imageSourceId) != nil) {
        //         result(FlutterError(code: "duplicateSource", message: "Source with imageSourceId \(imageSourceId) already exists", details: "Can't add duplicate source with imageSourceId: \(imageSourceId)" ))
        //         return
        //     }
            
        //     let source = MGLImageSource(identifier: imageSourceId, coordinateQuad: quad, image: image)
        //     self.mapView.style?.addSource(source)
            
        //     result(nil)
        // case "style#removeImageSource":
        //     guard let arguments = methodCall.arguments as? [String: Any] else { return }
        //     guard let imageSourceId = arguments["imageSourceId"] as? String else { return }
        //     guard let source = self.mapView.style?.source(withIdentifier: imageSourceId) else { return }
        //     self.mapView.style?.removeSource(source)
        //     result(nil)
        // case "style#addLayer":
        //     guard let arguments = methodCall.arguments as? [String: Any] else { return }
        //     guard let imageLayerId = arguments["imageLayerId"] as? String else { return }
        //     guard let imageSourceId = arguments["imageSourceId"] as? String else { return }
            
        //     //Check for duplicateLayer error
        //     if (self.mapView.style?.layer(withIdentifier: imageLayerId)) != nil {
        //         result(FlutterError(code: "duplicateLayer", message: "Layer already exists", details: "Can't add duplicate layer with imageLayerId: \(imageLayerId)" ))
        //         return
        //     }
        //     //Check for noSuchSource error
        //     guard let source = self.mapView.style?.source(withIdentifier: imageSourceId) else {
        //         result(FlutterError(code: "noSuchSource", message: "No source found with imageSourceId \(imageSourceId)", details: "Can't add add layer for imageSourceId \(imageLayerId), as the source does not exist." ))
        //         return
        //     }
            
        //     let layer = MGLRasterStyleLayer(identifier: imageLayerId, source: source)
        //     self.mapView.style?.addLayer(layer)
        //     result(nil)
        // case "style#addLayerBelow":
        //     guard let arguments = methodCall.arguments as? [String: Any] else { return }
        //     guard let imageLayerId = arguments["imageLayerId"] as? String else { return }
        //     guard let imageSourceId = arguments["imageSourceId"] as? String else { return }
        //     guard let belowLayerId = arguments["belowLayerId"] as? String else { return }
            
        //     //Check for duplicateLayer error
        //     if (self.mapView.style?.layer(withIdentifier: imageLayerId)) != nil {
        //         result(FlutterError(code: "duplicateLayer", message: "Layer already exists", details: "Can't add duplicate layer with imageLayerId: \(imageLayerId)" ))
        //         return
        //     }
        //     //Check for noSuchSource error
        //     guard let source = self.mapView.style?.source(withIdentifier: imageSourceId) else {
        //         result(FlutterError(code: "noSuchSource", message: "No source found with imageSourceId \(imageSourceId)", details: "Can't add add layer for imageSourceId \(imageLayerId), as the source does not exist." ))
        //         return
        //     }
        //     //Check for noSuchLayer error
        //     guard let belowLayer = self.mapView.style?.layer(withIdentifier: belowLayerId) else {
        //         result(FlutterError(code: "noSuchLayer", message: "No layer found with layerId \(belowLayerId)", details: "Can't insert layer below layer with id \(belowLayerId), as no such layer exists." ))
        //         return
        //     }
        //     let layer = MGLRasterStyleLayer(identifier: imageLayerId, source: source)
        //     self.mapView.style?.insertLayer(layer, below: belowLayer)
        //     result(nil)
        // case "style#removeLayer":
        //     guard let arguments = methodCall.arguments as? [String: Any] else { return }
        //     guard let imageLayerId = arguments["imageLayerId"] as? String else { return }
        //     guard let layer = self.mapView.style?.layer(withIdentifier: imageLayerId) else { return }
        //     self.mapView.style?.removeLayer(layer)
        //     result(nil)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
//    private func getSymbolForOptions(options: [String: Any]) -> MGLSymbolStyleAnnotation? {
//        // Parse geometry
//        if let geometry = options["geometry"] as? [Double] {
//            // Convert geometry to coordinate and create symbol.
//            let coordinate = CLLocationCoordinate2DMake(geometry[0], geometry[1])
//            let symbol = MGLSymbolStyleAnnotation(coordinate: coordinate)
//            Convert.interpretSymbolOptions(options: options, delegate: symbol)
//            // Load icon image from asset if an icon name is supplied.
//            if let iconImage = options["iconImage"] as? String {
//                addIconImageToMap(iconImageName: iconImage)
//            }
//            return symbol
//        }
//        return nil
//    }

//    private func addIconImageToMap(iconImageName: String) {
//        // Check if the image has already been added to the map.
//        if self.mapView.style?.image(forName: iconImageName) == nil {
//            // Build up the full path of the asset.
//            // First find the last '/' ans split the image name in the asset directory and the image file name.
//            if let range = iconImageName.range(of: "/", options: [.backwards]) {
//                let directory = String(iconImageName[..<range.lowerBound])
//                let assetPath = registrar.lookupKey(forAsset: "\(directory)/")
//                let fileName = String(iconImageName[range.upperBound...])
//                // If we can load the image from file then add it to the map.
//                if let imageFromAsset = UIImage.loadFromFile(imagePath: assetPath, imageName: fileName) {
//                    self.mapView.style?.setImage(imageFromAsset, forName: iconImageName)
//                }
//            }
//        }
//    }


    private func initLocationComponent() {
        if let cameraLocationConsumer = cameraLocationConsumer {
            mapView.location.addLocationConsumer(newConsumer: cameraLocationConsumer as LocationConsumer)
        }

    }

    func setMyLocationTrackingMode(myLocationTrackingMode: MyLocationTrackingMode) {
        /*if let cameraLocationConsumer = cameraLocationConsumer {
            switch myLocationTrackingMode {
            case .None:
                mapView.location.removeLocationConsumer(consumer: cameraLocationConsumer as LocationConsumer)
            case .Tracking:fallthrough
            case .TrackingCompass:fallthrough
            case .TrackingGPS:
                mapView.location.addLocationConsumer(newConsumer: cameraLocationConsumer as LocationConsumer)
            }
            
            
            if let channel = channel {
                channel.invokeMethod("map#onCameraTrackingChanged", arguments: ["mode": myLocationTrackingMode.rawValue])
                if myLocationTrackingMode == .None {
                    channel.invokeMethod("map#onCameraTrackingDismissed", arguments: [])
                }
            }
        }*/

    }
    
    private func getCamera() -> CameraState? {
        return trackCameraPosition ? mapView.cameraState : nil
        
    }
    
    private var tappableLayers: Set<String> = Set<String>()
    
    
    private func getJsonStringFromObject(json: JSONObject?) -> String? {
        let jsonEncoder = JSONEncoder()
        if let jsonData = try? jsonEncoder.encode(json){
            return String(data: jsonData, encoding: String.Encoding.utf16)
        }
        return nil;
    }
    
    
    private func handleUserLocationChange(userLocation: Location)  {
        if let channel = self.channel {
            let location = userLocation.location
            channel.invokeMethod("map#onUserLocationUpdated", arguments: [
                "userLocation": location.toDict(),
                "heading": userLocation.heading?.toDict(),
            ])
        }
    }
    
    /*
    *  UITapGestureRecognizer
    *  On tap invoke the map#onMapClick callback.
    */
    @objc @IBAction func handleMapTap(_ sender: UITapGestureRecognizer) {
        guard sender.state == .ended else { return }
        // Get the CGPoint where the user tapped.
        let point = sender.location(in: mapView)
        let coordinate = mapView.mapboxMap.coordinate(for: point)
        
        channel?.invokeMethod("map#onMapClick", arguments: [
           "x": point.x,
           "y": point.y,
           "lng": coordinate.longitude,
           "lat": coordinate.latitude,
        ])

        if sender.state == .ended && tappableLayers.count > 0 {
              
           let qOptions = RenderedQueryOptions.init(layerIds: Array(tappableLayers), filter: nil)
           
           mapView.mapboxMap.queryRenderedFeatures(at: point, options: qOptions, completion: { [weak self] result in
                if case .success(let queriedfeatures) = result {
                    if let qFearture = queriedfeatures.first,
                       let feature = queriedfeatures.first?.feature,
                       case .point(let featurePoint) = feature.geometry {
                                                   
                        self?.channel?.invokeMethod("map#onLayerTap", arguments: [
                            "source": qFearture.source,
                            "sourceLayer": qFearture.sourceLayer as Any,
                            "x":  point.x,
                            "y": point.y,
                            "lng": featurePoint.coordinates.longitude,
                            "lat": featurePoint.coordinates.latitude,
                            "data": feature.properties?.rawValue ?? [:]
                        ])
                    }
                }

            })
        }
    }
    
    /*
    *  UILongPressGestureRecognizer
    *  After a long press invoke the map#onMapLongClick callback.
    */
    @objc @IBAction func handleMapLongPress(sender: UILongPressGestureRecognizer) {
       // Fire when the long press starts
       if (sender.state == .began) {
         // Get the CGPoint where the user tapped.
           let point = sender.location(in: mapView)
           let coordinate = mapView.mapboxMap.coordinate(for: point)
           channel?.invokeMethod("map#onMapLongClick", arguments: [
                         "x": point.x,
                         "y": point.y,
                         "lng": coordinate.longitude,
                         "lat": coordinate.latitude,
                     ])
       }
        
    }
    
    
    
    /*
     *  MGLAnnotationControllerDelegate
     */
//    func annotationController(_ annotationController: MGLAnnotationController, didSelect styleAnnotation: MGLStyleAnnotation) {
//        DispatchQueue.main.async {
//            // Remove tint color overlay from selected annotation by
//            // deselecting. This is not handled correctly if requested
//            // synchronously from the callback.
//            annotationController.deselectStyleAnnotation(styleAnnotation)
//        }
//
//        guard let channel = channel else {
//            return
//        }
//
//        if let symbol = styleAnnotation as? MGLSymbolStyleAnnotation {
//            channel.invokeMethod("symbol#onTap", arguments: ["symbol" : "\(symbol.identifier)"])
//        } else if let circle = styleAnnotation as? MGLCircleStyleAnnotation {
//            channel.invokeMethod("circle#onTap", arguments: ["circle" : "\(circle.identifier)"])
//        } else if let line = styleAnnotation as? MGLLineStyleAnnotation {
//            channel.invokeMethod("line#onTap", arguments: ["line" : "\(line.identifier)"])
//        } else if let fill = styleAnnotation as? MGLPolygonStyleAnnotation {
//            channel.invokeMethod("fill#onTap", arguments: ["fill" : "\(fill.identifier)"])
//        }
//    }
    
    // This is required in order to hide the default Maps SDK pin
//    func mapView(_ mapView: MapView, viewFor annotation: Annotation) -> Annotation? {
//        if annotation is UserLocation {
//            return nil
//        }
//        return MGLAnnotationView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
//    }

    /*
     * Override the attribution button's click target to handle the event locally.
     * Called if the application supplies an onAttributionClick handler.
     */
//    func setupAttribution(_ mapView: MapView) {
//        mapView.attributionButton.removeTarget(mapView, action: #selector(mapView.showAttribution), for: .touchUpInside)
//        mapView.attributionButton.addTarget(self, action: #selector(showAttribution), for: UIControl.Event.touchUpInside)
//    }

    /*
     * Custom click handler for the attribution button. This callback is bound when
     * the application specifies an onAttributionClick handler.
     */
    @objc func showAttribution() {
        channel?.invokeMethod("map#onAttributionClick", arguments: [])
    }

    /*
     *  MGLMapViewDelegate
     */
//    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
//        isMapReady = true
//        updateMyLocationEnabled()
//
//        if let initialTilt = initialTilt {
//            let camera = mapView.camera
//            camera.pitch = initialTilt
//            mapView.setCamera(camera, animated: false)
//        }
//
//        for annotationType in annotationOrder {
//            switch annotationType {
//            case "AnnotationType.fill":
//                fillAnnotationController = MGLPolygonAnnotationController(mapView: self.mapView)
//                fillAnnotationController!.annotationsInteractionEnabled = true
//                fillAnnotationController?.delegate = self
//            case "AnnotationType.line":
//                lineAnnotationController = MGLLineAnnotationController(mapView: self.mapView)
//                lineAnnotationController!.annotationsInteractionEnabled = true
//                lineAnnotationController?.delegate = self
//            case "AnnotationType.circle":
//                circleAnnotationController = MGLCircleAnnotationController(mapView: self.mapView)
//                circleAnnotationController!.annotationsInteractionEnabled = true
//                circleAnnotationController?.delegate = self
//            case "AnnotationType.symbol":
//                symbolAnnotationController = MGLSymbolAnnotationController(mapView: self.mapView)
//                symbolAnnotationController!.annotationsInteractionEnabled = true
//                symbolAnnotationController?.delegate = self
//            default:
//                print("Unknown annotation type: \(annotationType), must be either 'fill', 'line', 'circle' or 'symbol'")
//            }
//        }
//
//        mapReadyResult?(nil)
//        if let channel = channel {
//            channel.invokeMethod("map#onStyleLoaded", arguments: nil)
//        }
//    }
//
//    func mapView(_ mapView: MGLMapView, shouldChangeFrom oldCamera: MGLMapCamera, to newCamera: MGLMapCamera) -> Bool {
//        guard let bbox = cameraTargetBounds else { return true }
//
//        // Get the current camera to restore it after.
//        let currentCamera = mapView.camera
//
//        // From the new camera obtain the center to test if it’s inside the boundaries.
//        let newCameraCenter = newCamera.centerCoordinate
//
//        // Set the map’s visible bounds to newCamera.
//        mapView.camera = newCamera
//        let newVisibleCoordinates = mapView.visibleCoordinateBounds
//
//        // Revert the camera.
//        mapView.camera = currentCamera
//
//        // Test if the newCameraCenter and newVisibleCoordinates are inside bbox.
//        let inside = MGLCoordinateInCoordinateBounds(newCameraCenter, bbox)
//        let intersects = MGLCoordinateInCoordinateBounds(newVisibleCoordinates.ne, bbox) && MGLCoordinateInCoordinateBounds(newVisibleCoordinates.sw, bbox)
//
//        return inside && intersects
//    }
    
//    func mapView(_ mapView: MGLMapView, imageFor annotation: MGLAnnotation) -> MGLAnnotationImage? {
//        // Only for Symbols images should loaded.
//        guard let symbol = annotation as? Symbol,
//            let iconImageFullPath = symbol.iconImage else {
//                return nil
//        }
//        // Reuse existing annotations for better performance.
//        var annotationImage = mapView.dequeueReusableAnnotationImage(withIdentifier: iconImageFullPath)
//        if annotationImage == nil {
//            // Initialize the annotation image (from predefined assets symbol folder).
//            if let range = iconImageFullPath.range(of: "/", options: [.backwards]) {
//                let directory = String(iconImageFullPath[..<range.lowerBound])
//                let assetPath = registrar.lookupKey(forAsset: "\(directory)/")
//                let iconImageName = String(iconImageFullPath[range.upperBound...])
//                let image = UIImage.loadFromFile(imagePath: assetPath, imageName: iconImageName)
//                if let image = image {
//                    annotationImage = MGLAnnotationImage(image: image, reuseIdentifier: iconImageFullPath)
//                }
//            }
//        }
//        return annotationImage
//    }
    
    // On tap invoke the symbol#onTap callback.
//    func mapView(_ mapView: MGLMapView, didSelect annotation: MGLAnnotation) {
//
//       if let symbol = annotation as? Symbol {
//            channel?.invokeMethod("symbol#onTap", arguments: ["symbol" : "\(symbol.id)"])
//        }
//    }
    
    // Allow callout view to appear when an annotation is tapped.
//    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
//        return true
//    }

//    func mapView(_ mapView: MGLMapView, didUpdate userLocation: MGLUserLocation?) {
//        if let channel = channel, let userLocation = userLocation, let location = userLocation.location {
//            channel.invokeMethod("map#onUserLocationUpdated", arguments: [
//                "userLocation": location.toDict(),
//                "heading": userLocation.heading?.toDict()
//            ]);
//       }
//   }
    
   
//    func mapView(_ mapView: MGLMapView, didChange mode: MGLUserTrackingMode, animated: Bool) {
//        if let channel = channel {
//            channel.invokeMethod("map#onCameraTrackingChanged", arguments: ["mode": mode.rawValue])
//            if mode == .none {
//                channel.invokeMethod("map#onCameraTrackingDismissed", arguments: [])
//            }
//        }
//    }
    
    func addGeoJsonSource(sourceId: String, geojson: String, properties: [String: Any]) {
        if let sourceData = try? JSONDecoder().decode(GeoJSONSourceData.self, from: geojson.data(using: .utf8)!) {
            var source = GeoJSONSource()
            source.data = sourceData
            try? mapView.mapboxMap.style.addSource(source, id: sourceId)
        }
    }
    
    func addVectorSource(sourceId: String, properties: [String: Any]) {
        if let style = mapView.mapboxMap.style as? Style {
            
            let jsonString = Convert.serializeJSON(from: properties)
            
            if let source = try? JSONDecoder().decode(VectorSource.self, from: jsonString!.data(using: .utf8)!) {
                do {
                    try style.addSource(source, id: sourceId)
                } catch {
                    var a = 1;
                }
            }
        }
        
    }
    
    private func getDefaultLayerType<T>(type: T.Type) -> LayerType? where T:Layer {
        if T.self == LineLayer.self {
            return LayerType.line
        }
        if T.self == SymbolLayer.self {
            return LayerType.symbol
        }
        if T.self == CircleLayer.self {
            return LayerType.circle
        }
        if T.self == FillLayer.self {
            return LayerType.fill
        }
        return nil;
    }
    
    private func addLayer<T>(sourceId: String, layerId: String, sourceLayerId: String?, properties: [String: Any], type: T.Type) where T:Layer {
        if let style = mapView.mapboxMap.style as? Style {
            
            let map = [
                "id": layerId,
                "type": getDefaultLayerType(type: type)?.rawValue,
                "source": sourceId,
                "source-layer": sourceLayerId
            ].merging(properties) { (_, new) in new };
            
            let jsonString = Convert.serializeJSON(from: map)
            
            if var layer: T = try? JSONDecoder().decode(type, from: jsonString!.data(using: .utf8)!) {
                do {
                    try? style.addLayer(layer)
                } catch {
                    var a = 1;
                }
            }
        }
    }
    
    private func updateLayer(layerId: String, properties: [String: Any]) {
        if let style = mapView.mapboxMap.style as? Style {
            try? style.setLayerProperties(for: layerId, properties: properties)
        }
    }
    
    private func removeLayer(layerId: String) {
        if let style = mapView.mapboxMap.style as? Style {
            try? style.removeLayer(withId: layerId)
        }
    }
    
    private func addSymbolLayer(sourceId: String, layerId: String, sourceLayerId: String?, properties: [String: Any]) {
        addLayer(sourceId: sourceId, layerId: layerId, sourceLayerId: sourceLayerId, properties: properties, type: SymbolLayer.self);
    }
 
    private func addLineLayer(sourceId: String, layerId: String, sourceLayerId: String?, properties: [String: Any]) {
        addLayer(sourceId: sourceId, layerId: layerId, sourceLayerId: sourceLayerId, properties: properties, type: LineLayer.self);
    }
    
    private func addCircleLayer(sourceId: String, layerId: String, sourceLayerId: String?, properties: [String: Any]) {
        addLayer(sourceId: sourceId, layerId: layerId, sourceLayerId: sourceLayerId, properties: properties, type: CircleLayer.self);
    }
    
    private func addFillLayer(sourceId: String, layerId: String, sourceLayerId: String?, properties: [String: Any]) {
        addLayer(sourceId: sourceId, layerId: layerId, sourceLayerId: sourceLayerId, properties: properties, type: FillLayer.self);
    }
    
   

    
    /*
    func mapViewDidBecomeIdle(_ mapView: MapView) {
        if let channel = channel {
            channel.invokeMethod("map#onIdle", arguments: []);
        }
    }*/
    
//    func mapView(_ mapView: MGLMapView, regionWillChangeAnimated animated: Bool) {
//        if let channel = channel {
//            channel.invokeMethod("camera#onMoveStarted", arguments: []);
//        }
//    }
    
//    func mapViewRegionIsChanging(_ mapView: MGLMapView) {
//        if !trackCameraPosition { return };
//        if let channel = channel {
//            channel.invokeMethod("camera#onMove", arguments: [
//                "position": getCamera()?.toDict(mapView: mapView)
//            ]);
//        }
//    }
    
//    func mapView(_ mapView: MGLMapView, regionDidChangeAnimated animated: Bool) {
//        let arguments = trackCameraPosition ? [
//            "position": getCamera()?.toDict(mapView: mapView)
//        ] : [:];
//        if let channel = channel {
//            channel.invokeMethod("camera#onIdle", arguments: arguments);
//        }
//    }
    
    /*
     * GestureManagerDelegate
     */
    
    func gestureManager(_ gestureManager: GestureManager, didBegin gestureType: GestureType) {
        if (gestureType != GestureType.pan) { return }
        
        let nextTrackingMode = MyLocationTrackingMode.None;
        
        // if we start a pan gesture we should cancel tracking
        self.setMyLocationTrackingMode(myLocationTrackingMode: nextTrackingMode)

    }

    func gestureManager(_ gestureManager: GestureManager, didEnd gestureType: GestureType, willAnimate: Bool) {
        
    }

    func gestureManager(_ gestureManager: GestureManager, didEndAnimatingFor gestureType: GestureType) {
        
    }
    
    /*
     *  MapboxMapOptionsSink
     */
    func setCameraTargetBounds(bounds: CoordinateBounds?) {
        cameraTargetBounds = bounds
    }
    func setCompassEnabled(enabled: Bool) {
        mapView.ornaments.options.compass.visibility = enabled ? OrnamentVisibility.visible : OrnamentVisibility.hidden;
    }
    
    func setScaleBarEnabled (enabled: Bool){
        mapView.ornaments.options.scaleBar.visibility = enabled ? OrnamentVisibility.visible : OrnamentVisibility.hidden;
    }
    
    func setMinMaxZoomPreference(min: Double, max: Double) {
        try? mapView.mapboxMap.setCameraBounds(with: CameraBoundsOptions(
            maxZoom: min,
            minZoom: max
        ))
    }
    
    func setMinMaxPitchPreference(min: Double, max: Double) {
        try? mapView.mapboxMap.setCameraBounds(with: CameraBoundsOptions(
            maxPitch: min,
            minPitch: max
        ))
    }
    
    func setStyleString(styleString: String) {
       // Check if json, url, absolute path or asset path:
       if styleString.isEmpty {
           NSLog("setStyleString - string empty")
       } else if (styleString.hasPrefix("{") || styleString.hasPrefix("[")) {
           // Currently the iOS Mapbox SDK does not have a builder for json.
           NSLog("setStyleString - JSON style currently not supported")
       } else if (styleString.hasPrefix("/")) {
           // Absolute path

           mapView.mapboxMap.style.uri = StyleURI(url: URL(fileURLWithPath: styleString, isDirectory: false))
       } else if (
           !styleString.hasPrefix("http://") &&
           !styleString.hasPrefix("https://") &&
           !styleString.hasPrefix("mapbox://")) {
           // We are assuming that the style will be loaded from an asset here.
           let assetPath = registrar.lookupKey(forAsset: styleString)
           mapView.mapboxMap.style.uri = StyleURI(url: URL(string: assetPath, relativeTo: Bundle.main.resourceURL)!)


       } else {
           mapView.mapboxMap.style.uri = StyleURI(url: URL(string: styleString)!)
       }
    }
    func setRotateGesturesEnabled(enabled: Bool) {
        mapView.gestures.options.pinchRotateEnabled = enabled
    }
    func setScrollGesturesEnabled(enabled: Bool) {
        
//        mapView.allowsScrolling = scrollGesturesEnabled
    }
    func setTiltGesturesEnabled(enabled: Bool) {
        mapView.gestures.options.pitchEnabled = enabled
    }
    func setTrackCameraPosition(trackCameraPosition: Bool) {
        self.trackCameraPosition = trackCameraPosition
    }
    func setZoomGesturesEnabled(enabled: Bool) {
        mapView.gestures.options.quickZoomEnabled = enabled
    }
    func setMyLocationEnabled(enabled: Bool) {
        if enabled {
            mapView.location.options.puckType = .puck2D()
        } else {
            mapView.location.options.puckType = nil
        }
    }

    func setMyLocationRenderMode(renderMode: MyLocationRenderMode) {
//        switch myLocationRenderMode {
//        case .Normal:
//            mapView.showsUserHeadingIndicator = false
//        case .Compass:
//            mapView.showsUserHeadingIndicator = true
//        case .Gps:
//            NSLog("RenderMode.GPS currently not supported")
//        }
    }
    func setLogoViewMargins(x: Double, y: Double) {
        mapView.ornaments.options.logo.margins = CGPoint(x: x, y: y)
    }
    func setCompassViewPosition(position: OrnamentPosition) {
        mapView.ornaments.options.compass.position = position
    }
    func setCompassViewMargins(x: Double, y: Double) {
        mapView.ornaments.options.compass.margins = CGPoint(x: x, y: y)
    }
    func setAttributionButtonMargins(x: Double, y: Double) {
        mapView.ornaments.options.attributionButton.margins = CGPoint(x: x, y: y)
    }
}

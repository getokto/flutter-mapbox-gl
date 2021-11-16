//
//  FeaturesStreamHandler.swift
//  mapbox_gl
//
//  Created by Bjarte Bore on 15/11/2021.
//

import Foundation
import MapboxMaps




class FeaturesStreamHandler : NSObject, FlutterStreamHandler {
    // private var observer: MGLObserver?
    var client: MapView
    var events: FlutterEventSink?
    var layerId: String?
    
    init(client: MapView) {
        self.client = client
    }

    
    
    func dispatchFeatures() {
//        let features = client.visibleFeatures(in: UIScreen.main.bounds, styleLayerIdentifiers: [layerId!])
//
//        let geojson = features.map { feature in
//            return feature.geoJSONDictionary()
//        }
//
//        events!(geojson)
    }
    
    func onListen(withArguments arguments: Any?,
                  eventSink events: @escaping FlutterEventSink) -> FlutterError? {
//        let args = arguments as! Dictionary<String, Any>
//
//        layerId = args["layerId"] as? String
//
//        self.events = events;
//
//        client.subscribe(for: self, event: MGLEventType.resourceRequest)
//
//        dispatchFeatures()
        
        return nil
    }
    
    
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        //self.watcher.close()
        
//        client.unsubscribe(for: self)
        self.events = nil
        
        return nil;
    }
}

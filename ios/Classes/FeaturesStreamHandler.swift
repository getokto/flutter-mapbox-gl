//
//  FeaturesStreamHandler.swift
//  mapbox_gl
//
//  Created by Bjarte Bore on 15/11/2021.
//

import Foundation
import MapboxMaps


class FeaturesStreamHandler : NSObject, FlutterStreamHandler {
    var client: MapView
    var events: FlutterEventSink?
    var source: String
    var sourceLayers: [String]?
    var filter: Any
    var layerId: String?
    
    init(client: MapView, source: String, sourceLayers: [String]?, filter: Any) {
        self.client = client
        self.source = source
        self.sourceLayers = sourceLayers
        self.filter = filter
    }

    func dispatchFeatures() {
        let queryOptions = SourceQueryOptions(sourceLayerIds: sourceLayers, filter: filter)
        
        client.mapboxMap.querySourceFeatures(for: source, options: queryOptions) {
            result in
            
            if case .success(let features) = result,
               features.count > 0 {
                let rawFeatures = features.map { feature in
                    return feature.feature;
                }
                if let data = try? JSONEncoder().encode(rawFeatures) {
                    let result = String(data: data, encoding: String.Encoding.utf8);
                    self.events?(result)
                }
            }
       }
    }
        
    
    func onMapDataLoaded(event: Event) {
        if let data = event.data as? [String: Any] {
            if let id = data["id"] as? String {
                if(id == self.source) {
                    dispatchFeatures()
                }
            }
        }
    }
    
    func onListen(withArguments arguments: Any?,
                  eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        
        let args = arguments as! Dictionary<String, Any>

        layerId = args["layerId"] as? String

        self.events = events;
        
        client.mapboxMap.onEvery(.sourceDataLoaded, handler: onMapDataLoaded)

        dispatchFeatures()
        
        return nil
    }
    
    
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        self.events = nil
        
        return nil;
    }
}

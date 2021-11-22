//
//  FeaturesStreamHandler.swift
//  mapbox_gl
//
//  Created by Bjarte Bore on 15/11/2021.
//

import Foundation
import Mapbox




class FeaturesStreamHandler : MGLObserver, FlutterStreamHandler, Throttable {
    // private var observer: MGLObserver?
    var client: MGLMapView
    var events: FlutterEventSink?
    var layerId: String?
    
    init(client: MGLMapView) {
        self.client = client
    }
    
    override func notify(with event: MGLEvent) {
        
        if let data = event.data as? [String: Any] {
            if let request = data["request"] as? [String: Any],
               let response = data["response"] as? [String: Any] {
                let isTile = request["kind"] as? String == "tile"
                let isSource = (request["url"] as? String)?.contains("oktoservices") ?? false
                let isCancelled = data["cancelled"] as? Bool ?? true
                
                if (isTile && isSource && !isCancelled) {
                    dispatchFeatures()
                }
            }
        }

    }
    
    lazy var dispatchFeatures = perform(with: 0.0016) {
        let features = self.client.visibleFeatures(in: UIScreen.main.bounds, styleLayerIdentifiers: [self.layerId!])
        
        
        let geojson = features.map { feature in
            return feature.geoJSONDictionary()
        }
        
        self.events!(geojson)
    }
    
    func dispatchFeatures2() {
        let l = layerId
        let r = UIScreen.main.bounds
        let features = client.visibleFeatures(in: UIScreen.main.bounds, styleLayerIdentifiers: [layerId!])
        
        
        let geojson = features.map { feature in
            return feature.geoJSONDictionary()
        }
        
        events!(geojson)
    }
    
    func onListen(withArguments arguments: Any?,
                  eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        let args = arguments as! Dictionary<String, Any>
        
        layerId = args["layerId"] as? String
        
        self.events = events;
               
        client.subscribe(for: self, event: MGLEventType.resourceRequest)
        
        dispatchFeatures()
        
        return nil
    }
    
    
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        //self.watcher.close()
        
        client.unsubscribe(for: self)
        self.events = nil
        
        return nil;
    }
}

protocol Throttable {
    func perform(with delay: TimeInterval,
                 in queue: DispatchQueue,
                 block completion: @escaping () -> Void) -> () -> Void
}

extension Throttable {
    func perform(with delay: TimeInterval,
                 in queue: DispatchQueue = DispatchQueue.main,
                 block completion: @escaping () -> Void) -> () -> Void {
        
        var workItem: DispatchWorkItem?
        
        return {
            workItem?.cancel()
            workItem = DispatchWorkItem(block: completion)
            queue.asyncAfter(deadline: .now() + delay, execute: workItem!)
        }
    }
}

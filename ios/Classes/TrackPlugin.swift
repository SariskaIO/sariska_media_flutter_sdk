//
//  TrackPlugin.swift
//  sariska_media_flutter_sdk
//
//  Created by Dipak Sisodiya on 24/11/23.
//

import Foundation
import sariska
import Flutter

public class TrackPlugin: NSObject, FlutterPlugin, FlutterStreamHandler{
    
    var manager: TrackManager?
    
    private var eventSink: FlutterEventSink? = nil
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let methodChannel = FlutterMethodChannel(name: "track", binaryMessenger: registrar.messenger())
        let instance = TrackPlugin()
        
        registrar.addMethodCallDelegate(instance, channel: methodChannel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if(manager == nil){
            manager = TrackManager()
        }
        
        if let params = call.arguments {
            // if there are parameters
            let selectorString = call.method + ":"
            let selector = Selector(selectorString)
            if manager?.responds(to: selector) != nil{
                manager?.perform(selector, with: params)
            }
        } else {
            // if there are no parameters
            let selectorString = call.method
            let selector = Selector(selectorString)
            if manager?.responds(to: selector) != nil{
                manager?.perform(selector)
            }
        }
    }
    
    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        eventSink = events
        return nil
    }
    
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        eventSink = nil
        return nil
    }
}

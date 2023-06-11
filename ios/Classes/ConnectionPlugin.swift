//
//  ConnectionPlugin.swift
//  sariska_media_transport_flutter
//
//  Created by Dipak Sisodiya on 10/06/23.
//

import Foundation
import Flutter

public class ConnectionPlugin: NSObject, FlutterPlugin{
    public static func register(with registrar: FlutterPluginRegistrar) {
        let methodChannel = FlutterMethodChannel(name: "sariska_connection", binaryMessenger: registrar.messenger())
        let instance = ConnectionPlugin()
        registrar.addMethodCallDelegate(instance, channel: methodChannel)
        print("Inside Connection Plugin")
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let params = call.arguments as? NSDictionary {
            let selector = NSSelectorFromString(call.method + "::")
//            if manager.responds(to: selector) {
//                manager.perform(selector, with: params)
//                return
//            }
        } else {
            let selector = NSSelectorFromString(call.method + ":")
//            if manager.responds(to: selector) {
//                manager.perform(selector)
//                return
//            }
        }
        result(FlutterMethodNotImplemented)
    }


}

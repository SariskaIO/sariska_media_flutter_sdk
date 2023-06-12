//
//  ConnectionPlugin.swift
//  sariska_media_transport_flutter
//
//  Created by Dipak Sisodiya on 10/06/23.
//

import Foundation
import Flutter

public class ConnectionPlugin: NSObject, FlutterPlugin{

    var manager: ConnectionManager?

    public static func register(with registrar: FlutterPluginRegistrar) {
        let methodChannel = FlutterMethodChannel(name: "connection", binaryMessenger: registrar.messenger())
        let instance = ConnectionPlugin()
        registrar.addMethodCallDelegate(instance, channel: methodChannel)
        print("Inside Connection Plugin")
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if(manager == nil){
            manager = ConnectionManager()
        }
        switch call.method {
        case "createConnection":
            if let arguments = call.arguments as? [String: Any] {
                manager?.createConnection(arguments);
            } else {
                result(FlutterError(code: "ARGUMENT_ERROR", message: "Invalid argument types", details: nil))
            }
        case "connect":
            manager?.connect()
        case "disconnect":
            manager?.disconnect()
        case "addConnectionListeners":
            if let arguments = call.arguments as? [String: Any] {
                manager?.addEventListener(arguments)
            } else {
                result(FlutterError(code: "ARGUMENT_ERROR", message: "Invalid argument types", details: nil))
            }

        default:
            result(FlutterMethodNotImplemented)
        }
    }
}

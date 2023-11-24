//
//  ConnectionPlugin.swift
//  sariska_media_transport_flutter
//
//  Created by Dipak Sisodiya on 10/06/23.
//

import Foundation
import Flutter
import sariska

public class ConnectionPlugin: NSObject, FlutterPlugin, FlutterStreamHandler{
    var manager: ConnectionManager?
    private var eventSink: FlutterEventSink? = nil

    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        eventSink = events
        return nil
    }

    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        eventSink = nil
        return nil
    }

    public static func register(with registrar: FlutterPluginRegistrar) {
        let methodChannel = FlutterMethodChannel(name: "connection", binaryMessenger: registrar.messenger())
        let eventChannel = FlutterEventChannel(name: "connectionevent", binaryMessenger: registrar.messenger())
        let instance = ConnectionPlugin()
        registrar.addMethodCallDelegate(instance, channel: methodChannel)
        eventChannel.setStreamHandler(instance)
        print("Inside Connection Plugin")
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if(manager == nil) {
            manager = ConnectionManager() { [weak self] action, m in
                self?.emit(action, m)
            }
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

//        switch call.method {
//        case "createConnection":
//            if let arguments = call.arguments as? [String: Any] {
//                manager?.createConnection(arguments);
//            } else {
//                result(FlutterError(code: "ARGUMENT_ERROR", message: "Invalid argument types", details: nil))
//            }
//        case "connect":
//            manager?.connect()
//        case "disconnect":
//            manager?.disconnect()
//        case "addConnectionListeners":
//            if let arguments = call.arguments as? [String: Any] {
//                manager?.addEventListener(arguments)
//            } else {
//                result(FlutterError(code: "ARGUMENT_ERROR", message: "Invalid argument types", details: nil))
//            }
//        case "addFeature":
//            if let arguments = call.arguments as? [String: Any] {
//                manager?.addFeature(arguments)
//            } else {
//                result(FlutterError(code: "ARGUMENT_ERROR", message: "Invalid argument types", details: nil))
//            }
//        case "release":
//            manager?.release()
//        case "removeFeature":
//            if let arguments = call.arguments as? [String: Any] {
//                manager?.removeFeature(arguments)
//            } else {
//                result(FlutterError(code: "ARGUMENT_ERROR", message: "Invalid argument types", details: nil))
//            }
//        case "destroy":
//            manager?.destroy()
//        case "setToken":
//            if let arguments = call.arguments as? String {
//                manager?.setToken(token: arguments)
//            } else {
//                result(FlutterError(code: "ARGUMENT_ERROR", message: "Invalid argument types", details: nil))
//            }
//        case "removeConnectionListeners":
//            if let arguments = call.arguments as? String {
//                manager?.removeEventListener(event: arguments)
//            } else {
//                result(FlutterError(code: "ARGUMENT_ERROR", message: "Invalid argument types", details: nil))
//            }
//        default:
//            result(FlutterMethodNotImplemented)
//        }
    }

    private func emit(_ action: String, _ m: Dictionary<String, Any?>?) {
        print(action)
        var event: Dictionary<String, Any?> = ["action": action]
        if let `m` = m {
            event.merge(m) { (current, _) in
                current
            }
        }
        eventSink?(event)
    }

}

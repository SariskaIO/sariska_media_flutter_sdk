//
//  ConferencePlugin.swift
//  sariska_media_transport_flutter
//
//  Created by Dipak Sisodiya on 10/06/23.
//

import Foundation
import Flutter

public class ConferencePlugin:  NSObject, FlutterPlugin, FlutterStreamHandler{

    var manager: ConferenceManager?
    private var eventSink: FlutterEventSink? = nil
    public class func register(with registrar: FlutterPluginRegistrar) {
        let methodChannel = FlutterMethodChannel(name: "conference", binaryMessenger: registrar.messenger())
        let eventChannel = FlutterEventChannel(name: "conferencevent", binaryMessenger: registrar.messenger())
        let instance = ConferencePlugin()
        registrar.addMethodCallDelegate(instance, channel: methodChannel)
        eventChannel.setStreamHandler(instance)
        registrar.register(SariskaSurfaceViewFactory(registrar.messenger()), withId: "SariskaSurfaceView")
    }

    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        eventSink = events
        return nil
    }

    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        eventSink = nil
        return nil
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if(manager == nil) {
            manager = ConferenceManager() { [weak self] action, m in
                self?.emit(action, m)
            }
        }

        switch call.method{
        case "createConference":
            manager?.createConference();

        case "addEventListeners":
            if let arguments = call.arguments as? [String: Any] {
                manager?.addEventListeners(arguments)
            } else {
                result(FlutterError(code: "ARGUMENT_ERROR", message: "Invalid argument types", details: nil))
            }

        case "join":
            manager?.join()

        default:
            result(FlutterMethodNotImplemented)
        }
    }

    private func emit(_ action: String, _ m: Dictionary<String, Any?>?) {
        var event: Dictionary<String, Any?> =
                ["action": action]
        event["m"] = m
        eventSink?(event)
    }
}

import Flutter
import UIKit
import sariska

public class SariskaMediaTransportFlutterPlugin: NSObject, FlutterPlugin, FlutterStreamHandler {
    private var eventSink: FlutterEventSink? = nil
    public static var localTrack: JitsiLocalTrack? = nil

    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        eventSink = events
        return nil
    }

    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        eventSink = nil
        return nil
    }

    private var connectionPlugin: ConnectionPlugin?
    private var conferencePlugin: ConferencePlugin?
    
  public static func register(with registrar: FlutterPluginRegistrar) {
      let channel = FlutterMethodChannel(name: "sariska_media_transport_flutter", binaryMessenger: registrar.messenger())
      let eventChannel = FlutterEventChannel(name: "sariskaMediaTransportEvent", binaryMessenger: registrar.messenger())
      let instance = SariskaMediaTransportFlutterPlugin()
      ConnectionPlugin.register(with: registrar)
      ConferencePlugin.register(with: registrar)
      eventChannel.setStreamHandler(instance)
      registrar.addMethodCallDelegate(instance, channel: channel)
      registrar.register(SariskaSurfaceViewFactory(messenger: registrar.messenger()), withId: "SariskaSurfaceView")
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
        result("iOS " + UIDevice.current.systemVersion)
    case "initializeSdk":
        SariskaMediaTransport.initializeSdk()
    case "createLocalTracks":
        // Handle the method call and extract the arguments
        if let arguments = call.arguments as? [String: Any] {
            SariskaMediaTransport.createLocalTracks(arguments) { [self] tracks in
                print("Inside create local")
                var trackList  = [Any]()
                for track in (tracks) {
                    let sometrack = track as! JitsiLocalTrack
                    if(sometrack.getType() == "video"){
                        print("video ssss")
                        SariskaMediaTransportFlutterPlugin.localTrack = track as? JitsiLocalTrack
                    }
                        var event = [String:Any]()
                        event["type"] = sometrack.getType()
                        event["participantId"] = sometrack.getParticipantId()
                        print("participantId: ", sometrack.getParticipantId())
                        event["deviceId"] = sometrack.getDeviceId()
                        event["muted"] = sometrack.isMuted()
                        event["streamURL"] = sometrack.getStreamURL()
                        event["id"] = sometrack.getId()
                        trackList.append(event)
                }
                emit("CREATE_LOCAL_TRACKS", trackList)
            }
        } else {
            result(FlutterError(code: "ARGUMENT_ERROR", message: "Invalid argument types", details: nil))
        }
    default:
      result(FlutterMethodNotImplemented)
    }
  }

    private func emit(_ methodName: String, _ data: [Any]?) {
        var event: Dictionary<String, Any?> = ["action": methodName]
        event["m"] = data
        eventSink?(event)
    }
}

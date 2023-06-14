import Flutter
import UIKit
import sariska

public class SariskaMediaTransportFlutterPlugin: NSObject, FlutterPlugin {
    private var connectionPlugin: ConnectionPlugin?
    private var conferencePlugin: ConferencePlugin?
    
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "sariska_media_transport_flutter", binaryMessenger: registrar.messenger())
    let instance = SariskaMediaTransportFlutterPlugin()
      ConnectionPlugin.register(with: registrar)
      ConferencePlugin.register(with: registrar)
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
        print("get platform version")
        result("iOS " + UIDevice.current.systemVersion)
    case "initializeSdk":
        print("initialize SDk")
        SariskaMediaTransport.initializeSdk()
    case "createLocalTracks":
        // Handle the method call and extract the arguments
        if let arguments = call.arguments as? [String: Any] {
            SariskaMediaTransport.createLocalTracks(arguments) { tracks in
                print("inside create local tracks")
            }
        } else {
            result(FlutterError(code: "ARGUMENT_ERROR", message: "Invalid argument types", details: nil))
        }
        print("Creating Local Tracks in Swift")
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}

//
// Created by Dipak Sisodiya on 15/06/23.
//

import Foundation
import Flutter
import sariska

public class SariskaSurfaceViewFactory: NSObject, FlutterPlatformViewFactory{
    private final weak var messager: FlutterBinaryMessenger?

    init(_ messager: FlutterBinaryMessenger) {
        self.messager = messager
    }

    public func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        FlutterStandardMessageCodec.sharedInstance()
    }

    public func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> FlutterPlatformView {
        return SariskaSurfaceView(messager!, frame, viewId, args as? Dictionary<String, Any?>)
    }
}

class SariskaSurfaceView: NSObject, FlutterPlatformView {
    private let _view: RTCVideoView
    private let channel: FlutterMethodChannel

    init(_ messager: FlutterBinaryMessenger, _ frame: CGRect, _ viewId: Int64, _ args: Dictionary<String, Any?>?) {
        self._view = RTCVideoView()
        self.channel = FlutterMethodChannel(name: "sariska_media_transport/surface_view_\(viewId)", binaryMessenger: messager)
        super.init()
        if let map = args {
            //setStreamURL(map["streamURL"] as! String)
            setObjectFit(map["objectFit"] as! Int)
            setMirror(map["mirror"] as! Bool)
        }

        channel.setMethodCallHandler { [weak self] (call, result) in
            var args = [String: Any?]()
            if let arguments = call.arguments {
                args = arguments as! Dictionary<String, Any?>
            }
            switch call.method {
            case "setStreamURL":
                print("nothing")
//                self?.render(args["streamURL"] as! String)
            case "setMirror":
                self?.setMirror(args["mirror"] as! Bool)
            case "setObjectFit":
                self?.setObjectFit(args["objectFit"] as! Int)
            default:
                result(FlutterMethodNotImplemented)
            }
        }
    }

    func view() -> RTCVideoView {
        return _view
    }

    deinit {
        channel.setMethodCallHandler(nil)
    }

//    func setStreamURL(_ streamURL: String) {
//        _view.setStreamURL(streamURL)
//    }

    func setMirror(_ mirror: Bool) {
        _view.setMirror(mirror)
    }

    func setObjectFit(_ objectFit: Int) {
        _view.setObjectFit("cover")
    }

    func view() -> UIView {
        fatalError("view() has not been implemented")
    }
}
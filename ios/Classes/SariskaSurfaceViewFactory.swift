//
// Created by Dipak Sisodiya on 15/06/23.
//

import Foundation
import Flutter
import sariska

class SariskaSurfaceViewFactory: NSObject, FlutterPlatformViewFactory {
    private var messenger: FlutterBinaryMessenger

    init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
        super.init()
    }

    func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        FlutterStandardMessageCodec.sharedInstance()
    }

    func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> FlutterPlatformView {
        return SariskaSurfaceView(frame: frame, viewIdentifier: viewId, arguments: args, binaryMessenger: messenger)
    }
}

class SariskaSurfaceView :NSObject, FlutterPlatformView{
    private var _view: RTCVideoView
    init(frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?, binaryMessenger messenger: FlutterBinaryMessenger?) {
        _view = RTCVideoView()
        super.init()
        let map = args
        var track = JitsiLocalTrack.init(options: map as! [AnyHashable: Any])
        createNativeView(track: track)
    }

    func view() -> UIView {
        return _view
    }

    func createNativeView(track: JitsiLocalTrack){
        _view = track.render()
    }
}

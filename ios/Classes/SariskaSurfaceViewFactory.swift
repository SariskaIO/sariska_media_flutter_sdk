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

    func create(
            withFrame frame: CGRect,
            viewIdentifier viewId: Int64,
            arguments args: Any?
    ) -> FlutterPlatformView {
        return SariskaSurfaceView(
                frame: frame,
                viewIdentifier: viewId,
                arguments: args,
                binaryMessenger: messenger)
    }
}

class SariskaSurfaceView :NSObject, FlutterPlatformView{
    private var _view: RTCVideoView
    init(frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?, binaryMessenger messenger: FlutterBinaryMessenger?) {
        _view = RTCVideoView()
        print("args")
        print(args)
        super.init()
        let map = args
        var track = JitsiLocalTrack.init(options: map as! [AnyHashable: Any])
        createNativeView(view: _view, track: track)
    }

    func view() -> UIView {
        return _view
    }

    func createNativeView(view _rapidview: RTCVideoView, track: JitsiLocalTrack){
        _view = track.render()
        _view.accessibilityLabel = SariskaMediaTransportFlutterPlugin.localTrack?.getId()
        _view.heightAnchor.constraint(equalToConstant: 480).isActive = true
        _view.widthAnchor.constraint(equalToConstant: 360).isActive = true
        _view.setMirror(true)
        _view.layoutIfNeeded()
    }
}

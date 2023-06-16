import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:sariska_media_flutter_sdk/JitsiLocalTrack.dart';

final Map<int, MethodChannel> _channels = {};

class WebRTCView extends StatefulWidget {

  final JitsiLocalTrack localTrack;

  final bool mirror;

  final String objectFit;

  final int zOrder;

  final PlatformViewCreatedCallback? onPlatformViewCreated;

  final Set<Factory<OneSequenceGestureRecognizer>>? gestureRecognizers;

  WebRTCView({
    Key? key,
    required this.localTrack,
    this.mirror = false,
    this.zOrder = 0,
    this.objectFit = "contain",
    this.onPlatformViewCreated,
    this.gestureRecognizers,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _RtcSurfaceViewState(localTrack);
  }
}

class _RtcSurfaceViewState extends State<WebRTCView> {
  JitsiLocalTrack? track;
  int? _id;
  String? _streamURL;
  bool? _mirror;
  String? _objectFit;
  int? _zOrder;

  _RtcSurfaceViewState(this.track);

  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        child: AndroidView(
          viewType: 'SariskaSurfaceView',
          onPlatformViewCreated: onPlatformViewCreated,
          hitTestBehavior: PlatformViewHitTestBehavior.opaque,
          creationParams: {
            'streamURL': _streamURL,
            'mirror': _mirror,
            'objectFit': _objectFit,
            'zOrder': _zOrder
          },
          creationParamsCodec: const StandardMessageCodec(),
          gestureRecognizers: widget.gestureRecognizers,
        ),
      );
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        child: UiKitView(
          viewType: 'SariskaSurfaceView',
          onPlatformViewCreated: onPlatformViewCreated,
          /*
          trackId = m[@"id"];
    muted = !!m[@"muted"];
    type = m[@"type"];
    streamURL = m[@"streamURL"];
    deviceId = m[@"deviceId"];
    participantId = m[@"participantId"];
           */
          creationParams: {
            'streamURL': track?.getStreamURL(),
            'mirror': _mirror,
            'objectFit': _objectFit,
            'trackId': track?.getId(),
            'muted': track?.isMuted(),
            'type': track?.getType(),
            'deviceId': track?.getDeviceId(),
            'participantId': track?.getParticipantId()
          },
          creationParamsCodec: const StandardMessageCodec(),
          gestureRecognizers: widget.gestureRecognizers,
        ),
      );
    }
    return Text('$defaultTargetPlatform is not yet supported by the plugin');
  }

  @override
  void initState() {
    super.initState();
    _mirror = widget.mirror;
    _objectFit = widget.objectFit;
    _zOrder = widget.zOrder;
  }

  @override
  void didUpdateWidget(WebRTCView oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.mirror != widget.mirror) {
      setMirror();
    }

    if (oldWidget.objectFit != widget.objectFit) {
      setObjectFit();
    }

    if (defaultTargetPlatform == TargetPlatform.android) {
      if (oldWidget.zOrder != widget.zOrder) {
        setZOrder();
      }
    }
  }


  @override
  void dispose() {
    super.dispose();
    _channels.remove(_id);
  }

  void setObjectFit() {
    _channels[_id]?.invokeMethod('setObjectFit', {'objectFit': widget.objectFit});
  }

  void setMirror() {
    _channels[_id]?.invokeMethod('setMirror', {'mirror': widget.mirror});
  }

  void setZOrder() {
    _channels[_id]?.invokeMethod('setZOrder', {'zOrder': widget.zOrder});
  }


  Future<void> onPlatformViewCreated(int id) async {
    _id = id;
    if (!_channels.containsKey(id)) {
      _channels[id] = MethodChannel('sariska_media_transport_surface_view_$id');
    }
    widget.onPlatformViewCreated?.call(id);
  }
}
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:sariska_media_flutter_sdk/Track.dart';

final Map<int, MethodChannel> _channels = {};

class WebRTCView extends StatefulWidget {

  final Track localTrack;

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
  Track? track;
  int? _id;
  String? _streamURL;
  bool? _mirror;
  String? _objectFit;
  int? _zOrder;

  _RtcSurfaceViewState(this.track);

  @override
  Widget build(BuildContext context) {

    const String viewType = 'SariskaSurfaceView';

    return PlatformViewLink(
      viewType: viewType,
      surfaceFactory:
          (context, controller) {
        return AndroidViewSurface(
          controller: controller as AndroidViewController,
          gestureRecognizers: const <Factory<OneSequenceGestureRecognizer>>{},
          hitTestBehavior: PlatformViewHitTestBehavior.opaque,
        );
      },
      onCreatePlatformView: (params) {
        return PlatformViewsService.initSurfaceAndroidView(
          id: params.id,
          viewType: viewType,
          layoutDirection: TextDirection.ltr,
          creationParams: {
            'streamURL': track?.getStreamURL(),
            'mirror': _mirror,
            'objectFit': _objectFit,
            'trackId': track?.getId(),
            'muted': track?.isMuted(),
            'type': track?.getType(),
            '_zOrder': _zOrder
//            'deviceId': track?.getDeviceId(),
//            'participantId': track?.getParticipantId()
          },
          creationParamsCodec: const StandardMessageCodec(),
          onFocus: () {
            params.onFocusChanged(true);
          },
        )
          ..addOnPlatformViewCreatedListener(params.onPlatformViewCreated)
          ..create();
      },
    );
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
    _channels.remove(_id);
    super.dispose();
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
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'JitsiLocalTrack.dart';
import 'SariskaMediaTransportInterface.dart';
typedef void LocalTrackCallback(List<JitsiLocalTrack> tracks);
class SariskaMediaTransportMethodChannel extends SariskaMediaTransportInterface {

  static late LocalTrackCallback localTrackCallback;
  List<JitsiLocalTrack> localTracks = [];
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  static const methodChannel = const MethodChannel('sariska_media_flutter_sdk');
  static const eventChannel = const EventChannel('sariskaMediaTransportEvent');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  // Initialize Sariska Media Transport SDK
  @override
  void initializeSdk(){

    _invokeMethod('initializeSdk');

    eventChannel.receiveBroadcastStream().listen((event) {
      print('Inside SMT receive broadcast stream');
      //final eventMap = Map<String, dynamic>.from(event);
      final action = event['action'] as String;
      final m = event['m'] as List<dynamic>;
      switch (action) {
        case "CREATE_LOCAL_TRACKS":
          localTracks = [];
          for (dynamic track in m) {
            Map<String, Object> map = new Map();
            map["type"] = track["type"];
            map["participantId"] = track["participantId"];
            map["deviceId"] =track["deviceId"];
            map["muted"]= track["muted"];
            map["streamURL"] = track["streamURL"];
            map["id"]=track["id"];
            localTracks.add(new JitsiLocalTrack(map));
          }
          localTrackCallback(localTracks);
          break;
        default:
      }
    });
  }

  static Future<T?> _invokeMethod<T>(String method, [Map<String, dynamic>? arguments]) {
    return methodChannel.invokeMethod(method, arguments);
  }

  // Create Local Tracks
  @override
  void createLocalTracks(Map<String, dynamic> options, LocalTrackCallback callback) {
    localTrackCallback = callback;
    _invokeMethod('createLocalTracks', {
      'audio': true,
      'video': true
    });
  }

}


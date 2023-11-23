import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:sariska_media_flutter_sdk/Connection.dart';
import 'JitsiLocalTrack.dart';
import 'SariskaMediaTransportInterface.dart';

typedef void LocalTrackCallback(List<JitsiLocalTrack> tracks);

/// A class implementing the SariskaMediaTransportInterface.
class SariskaMediaTransportMethodChannel extends SariskaMediaTransportInterface {
  /// Callback function for receiving local tracks.
  static late LocalTrackCallback localTrackCallback;
  List<JitsiLocalTrack> localTracks = [];

  /// The method channel used to interact with the native platform.
  @visibleForTesting
  static const methodChannel = const MethodChannel('sariska_media_transport_flutter');
  static const eventChannel = const EventChannel('sariskaMediaTransportEvent');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  /// Initializes the Sariska Media Transport SDK.
  @override
  void initializeSdk() {
    _invokeMethod('initializeSdk');
    eventChannel.receiveBroadcastStream().listen((event) {
      print('Inside SMT receive broadcast stream');
      final action = event['action'] as String;
      print(action);
      final m = event['m'] as List<dynamic>;
      print(m);
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

  /// Creates local tracks with the given options and invokes the callback function.
  @override
  void createLocalTracks(Map<String, dynamic> options, LocalTrackCallback callback) {
    localTrackCallback = callback;
    _invokeMethod('createLocalTracks', {
      'audio': true,
      'video': true
    });
  }

  @override
  String getName() {
    return "SariskaMediaTransport";
  }

  @override
  Connection jitsiConnection(String token, String roomName, bool isNightly) {
    return Connection(token, roomName, isNightly);
  }
}
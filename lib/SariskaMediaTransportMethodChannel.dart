import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:sariska_media_flutter_sdk/Connection.dart';
import 'JitsiLocalTrack.dart';
import 'SariskaMediaTransportInterface.dart';

typedef LocalTrackCallback = void Function(List<JitsiLocalTrack> tracks);

/// A class implementing the SariskaMediaTransportInterface.
class SariskaMediaTransportMethodChannel extends SariskaMediaTransportInterface {
  /// Callback function for receiving local tracks.
  static late LocalTrackCallback localTrackCallback;
  List<JitsiLocalTrack> localTracks = [];

  /// The method channel used to interact with the native platform.
  @visibleForTesting
  static const methodChannel = MethodChannel('sariska_media_transport_flutter');
  static const eventChannel = EventChannel('sariskaMediaTransportEvent');
  static var initialized = false;

  @override
  Future<String?> getPlatformVersion() async {
    try {
      final version =
          await methodChannel.invokeMethod<String>('getPlatformVersion');
      return version;
    } on PlatformException catch (e) {
      print('Failed to get platform version: ${e.message}');
      return null;
    }
  }

  /// Initializes the Sariska Media Transport SDK.
  @override
  void initializeSdk() {
    try {
      if (initialized == false) {
        _invokeMethod('initializeSdk');
        initialized = true;
      }
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
              map["deviceId"] = track["deviceId"];
              map["muted"] = track["muted"];
              map["streamURL"] = track["streamURL"];
              map["id"] = track["id"];
              localTracks.add(JitsiLocalTrack(map));
            }
            localTrackCallback(localTracks);
            break;
          default:
        }
      });
    } on MissingPluginException catch (e) {
      print('Failed to initialize SDK: ${e.message}');
    }
  }

  static Future<T?> _invokeMethod<T>(String method,
      [Map<String, dynamic>? arguments]) {
    return methodChannel.invokeMethod(method, arguments);
  }

  /// Creates local tracks with the given options and invokes the callback function.
  @override
  void createLocalTracks(Map<String, dynamic> options, LocalTrackCallback callback) {
    localTrackCallback = callback;
    _invokeMethod('createLocalTracks',
        {'audio': options['audio'], 'video': options['video']});
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
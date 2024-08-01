import 'package:flutter/services.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:sariska_media_flutter_sdk/Connection.dart';
import 'JitsiLocalTrack.dart';
import 'SariskaMediaTransportMethodChannel.dart';

/// A platform interface for Sariska Media Transport.
abstract class SariskaMediaTransportInterface extends PlatformInterface {
  /// Constructs a SariskaMediaTransportInterface.
  SariskaMediaTransportInterface() : super(token: _token);

  static final Object _token = Object();

  static SariskaMediaTransportInterface _instance =
  SariskaMediaTransportMethodChannel();

  /// The default instance of [SariskaMediaTransportInterface] to use.
  /// Defaults to [SariskaMediaTransportMethodChannel].
  static SariskaMediaTransportInterface get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [SariskaMediaTransportInterface] when
  /// they register themselves.
  static set instance(SariskaMediaTransportInterface instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Retrieves the platform version.
  Future<String?> getPlatformVersion() async {
    const platform = MethodChannel('samples.flutter.dev/platform');
    try {
      final String? version = await platform.invokeMethod('getPlatformVersion');
      print("Platform Version: $version");
      return version;
    } on PlatformException catch (e) {
      print("Failed to get platform version: '${e.message}'.");
      return null;
    }
  }

  /// Initializes the Sariska Media SDK.
  void initializeSdk() {
    try {} on MissingPluginException catch (e) {
      print("Failed to initialize SDK: '${e.message}'.");
    }
  }

  /// Creates local tracks based on the provided options.
  ///
  /// The [options] parameter specifies the configuration options for creating
  /// the local tracks.
  /// The [callback] parameter is a callback function that receives a list of
  /// [JitsiLocalTrack] instances created by the SDK.
  void createLocalTracks(Map<String, dynamic> options, LocalTrackCallback callback) {
    throw UnimplementedError('createLocalTracks(Map<String, dynamic> options) has not been implemented.');
  }

  /// Creates a connection to the Jitsi server.
  ///
  /// The [token] parameter is the JWT token for authentication.
  /// The [roomName] parameter is the name of the Jitsi conference room.
  /// The [isNightly] parameter specifies whether the connection is for a nightly build.
  /// Returns a [Connection] object representing the connection to the Jitsi server.
  Connection jitsiConnection(String token, String roomName, bool isNightly) {
    throw UnimplementedError('jitsiConnection() has not been implemented.');
  }

  /// Retrieves the name of the Sariska Media Transport implementation.
  String getName() {
    throw UnimplementedError('getName() has not been implemented.');
  }
}
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'SariskaMediaTransportInterface.dart';

/// An implementation of [SariskaMediaTransportInterface] that uses method channels.
class SariskaMediaTransportMethodChannel extends SariskaMediaTransportInterface {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('sariska_media_flutter_sdk');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  // Initialize Sariska Media Transport SDK
  @override
  void initializeSdk(){
    methodChannel.invokeMethod('initializeSdk');
  }

  // Create Local Tracks
  @override
  void createLocalTracks(Map<String, dynamic> options) {
    methodChannel.invokeMethod('createLocalTracks', {'options': options});
  }

}


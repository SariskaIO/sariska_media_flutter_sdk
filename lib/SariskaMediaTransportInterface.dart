import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'SariskaMediaTransportMethodChannel.dart';

abstract class SariskaMediaTransportInterface extends PlatformInterface {
  /// Constructs a SariskaMediaFlutterSdkPlatform.
  SariskaMediaTransportInterface() : super(token: _token);

  static final Object _token = Object();

  static SariskaMediaTransportInterface _instance = SariskaMediaTransportMethodChannel();

  /// The default instance of [SariskaMediaTransportInterface] to use.
  ///
  /// Defaults to [SariskaMediaTransportMethodChannel].
  static SariskaMediaTransportInterface get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [SariskaMediaTransportInterface] when
  /// they register themselves.
  static set instance(SariskaMediaTransportInterface instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  void initializeSdk(){
    throw UnimplementedError('initializeSdk() has not been implemented.');
  }

  void createLocalTracks(Map<String, dynamic> options){
    throw UnimplementedError('createLocalTracks(Map<String, dynamic> options) has not been implemented.');
  }

}

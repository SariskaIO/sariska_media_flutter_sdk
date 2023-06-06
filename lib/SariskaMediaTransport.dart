
import 'SariskaMediaTransportInterface.dart';

class SariskaMediaTransport {
  Future<String?> getPlatformVersion() {
    return SariskaMediaTransportInterface.instance.getPlatformVersion();
  }

  Future<void> initializeSdk() async {
    SariskaMediaTransportInterface.instance.initializeSdk();
  }

  void createLocalTracks(Map<String, dynamic> options){
    SariskaMediaTransportInterface.instance.createLocalTracks(options);
  }

}

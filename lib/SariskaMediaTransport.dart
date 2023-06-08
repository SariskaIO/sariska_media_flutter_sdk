
import 'JitsiLocalTrack.dart';
import 'SariskaMediaTransportInterface.dart';
typedef void LocalTrackCallback(List<JitsiLocalTrack> tracks);

class SariskaMediaTransport {

  static late LocalTrackCallback localTrackCallback;

  Future<String?> getPlatformVersion() {
    return SariskaMediaTransportInterface.instance.getPlatformVersion();
  }

  Future<void> initializeSdk() async {
    SariskaMediaTransportInterface.instance.initializeSdk();
  }

  void createLocalTracks(Map<String, dynamic> options, LocalTrackCallback callback){
    SariskaMediaTransportInterface.instance.createLocalTracks(options, callback);
  }
}

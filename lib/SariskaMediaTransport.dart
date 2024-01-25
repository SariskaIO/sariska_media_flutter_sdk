
import 'package:sariska_media_flutter_sdk/Connection.dart';

import 'JitsiLocalTrack.dart';
import 'SariskaMediaTransportInterface.dart';
typedef LocalTrackCallback = void Function(List<JitsiLocalTrack> tracks);

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

  String getName(){
    return SariskaMediaTransportInterface.instance.getName();
  }

  Connection jitsiConnection(String token, String roomName, bool isNightly){
    return SariskaMediaTransportInterface.instance.jitsiConnection(token, roomName, isNightly);
  }

}

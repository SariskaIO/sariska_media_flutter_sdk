
class Track {
  String type = '';

  String id = '';

  bool muted = false;

  String streamURL = '';

  Track(Map<dynamic, dynamic> map) {
    type = map["type"];
    id = map["id"];
    muted = map["muted"];
    streamURL = map["streamURL"];
  }

  String getType() {
    return type;
  }

  String getStreamURL() {
    return streamURL;
  }

  String getId() {
    return id;
  }

  bool isMuted() {
    return muted;
  }

  bool isLocal() {
    return false;
  }

  void setMuted(bool mute) {
    muted = mute;
  }
}

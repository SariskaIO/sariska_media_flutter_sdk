import 'dart:async';
import 'package:flutter/services.dart';

class JitsiLocalTrack {

  String id = '';

  String type= '';

  String participantId = '';

  String deviceId = '';

  bool muted = false;

  String streamURL = '';

  static const MethodChannel _methodChannel = MethodChannel('track');

  JitsiLocalTrack(Map<String, dynamic> map) {
    this.type = map['type'];
    this.participantId = map['participantId'];
    this.deviceId = map['deviceId'];
    this.id = map['id'];
    this.muted = map['muted'];
    this.streamURL = map['streamURL'];
  }

  static Future<T?> _invokeMethod<T>(String method, [Map<String, dynamic>? arguments]) {
    return _methodChannel.invokeMethod(method, arguments);
  }

  bool isLocal() {
    return true;
  }

  bool isMuted() {
    return this.muted;
  }

  String getStreamURL() {
    return this.streamURL;
  }

  String getType() {
    return this.type;
  }

  String getId() {
    return this.id;
  }

  String getDeviceId() {
    return this.deviceId;
  }

  String getParticipantId() {
    return this.participantId;
  }

  void switchCamera() {
    if (this.type == "video") {
      _invokeMethod("switchCamera", {'trackId': this.getId()});
    }
  }

  void mute() {
    _invokeMethod("mute", {'trackId': this.getId()});
  }

  void unmute() {
    _invokeMethod("unmute", {'trackId': this.getId()});
  }

  void dispose() {
    _invokeMethod("dispose", {'trackId': this.getId()});
  }
}
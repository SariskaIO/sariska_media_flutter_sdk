import 'dart:async';
import 'package:flutter/services.dart';
import 'package:sariska_media_flutter_sdk/Track.dart';

class JitsiLocalTrack extends Track{

  String participantId = '';

  String deviceId = '';

  static const MethodChannel _methodChannel = MethodChannel('track');

  JitsiLocalTrack(Map<String, dynamic> map) : super(map) {
    this.participantId = map['participantId'];
    this.deviceId = map['deviceId'];
  }

  static Future<T?> _invokeMethod<T>(String method, [Map<String, dynamic>? arguments]) {
    return _methodChannel.invokeMethod(method, arguments);
  }

  bool isLocal() {
    return true;
  }

  String getDeviceId() {
    return deviceId;
  }

  String getParticipantId() {
    return participantId;
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
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:sariska_media_flutter_sdk/Track.dart';

class JitsiLocalTrack extends Track{

  String participantId = '';

  String deviceId = '';

  static const MethodChannel _methodChannel = MethodChannel('track');

  JitsiLocalTrack(Map<String, dynamic> map) : super(map) {
    participantId = map['participantId'];
    deviceId = map['deviceId'];
  }

  static Future<T?> _invokeMethod<T>(String method, [Map<String, dynamic>? arguments]) {
    return _methodChannel.invokeMethod(method, arguments);
  }

  @override
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
    if (type == "video") {
      _invokeMethod("switchCamera", {'trackId': getId()});
    }
  }

  void mute() {
    _invokeMethod("mute", {'trackId': getId()});
  }

  void unmute() {
    _invokeMethod("unmute", {'trackId': getId()});
  }

  void dispose() {
    _invokeMethod("dispose", {'trackId': getId()});
  }

  void toggleSpeaker(bool onSpeaker){
    _invokeMethod("toggleSpeaker", {'onSpeaker': onSpeaker});
  }
}
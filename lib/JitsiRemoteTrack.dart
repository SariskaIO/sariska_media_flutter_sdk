import 'dart:async';
import 'package:flutter/services.dart';
import 'WebRTCView.dart';

class JitsiRemoteTrack {

  String type = '';

  String participantId = '';

  String id = '';

  bool muted = false;

  String streamURL = '';

  JitsiRemoteTrack(Map<dynamic, dynamic> map) {
    this.type = map["type"];
    this.participantId = map["participantId"];
    this.id = map["id"];
    this.muted = map["muted"];
    this.streamURL = map["streamURL"];
  }

  String getType() {
    return this.type;
  }

  String getStreamURL() {
    return this.streamURL;
  }

  String getId() {
    return this.id;
  }

  bool isMuted() {
    return this.muted;
  }

  String getParticipantId() {
    return this.participantId;
  }

  bool isLocal() {
    return false;
  }

  void setMuted(bool mute){
    this.muted = mute;
  }

}
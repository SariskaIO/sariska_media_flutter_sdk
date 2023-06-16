import 'dart:async';
import 'package:flutter/services.dart';
import 'Track.dart';
import 'WebRTCView.dart';

class JitsiRemoteTrack extends Track {

  String participantId = '';
  
  JitsiRemoteTrack(Map<dynamic, dynamic> map) : super(map) {
    this.participantId = map["participantId"];
  }
  
  String getParticipantId() {
    return this.participantId;
  }

  bool isLocal() {
    return false;
  }
}
import 'dart:async';
import 'package:flutter/services.dart';
import 'JitsiLocalTrack.dart';
import 'JitsiRemoteTrack.dart';
import 'Participant.dart';

typedef void ConferenceCallbackParam0();

typedef void ConferenceCallbackParam1<W>(W w);

typedef void ConferenceCallbackParam2<W, X>(W w, X x);

typedef void ConferenceCallbackParam3<W, X, Y>(W w, X x, Y y);

typedef void ConferenceCallbackParam4<W, X, Y, Z>(W w, X x, Y y, Z z);

class ConferenceBinding<T> {
  String event;
  T callback;

  ConferenceBinding(this.event, T this.callback) {
    this.event = event;
    this.callback = callback;
  }

  String getEvent() {
    return this.event;
  }

  T getCallback() {
    return this.callback;
  }
}

class Conference {
  static var _bindings = <ConferenceBinding>[];
  static var remoteTracks = <JitsiRemoteTrack>[];
  static var localTracks = <JitsiLocalTrack>[];
  static var participants = <Participant>[];
  static const MethodChannel _methodChannel = MethodChannel('conference');
  static const EventChannel _eventChannel = EventChannel('conferencevent');
  static String userId = '';
  static String role = '';
  static bool hidden = false;
  static bool dtmf = false;
  static String name = '';
  static String email = '';
  static String avatar = '';

  Conference() {
    _invokeMethod('createConference');
    _eventChannel.receiveBroadcastStream().listen((event) {
      print("Event Channel invoked");
      final eventMap = Map<String, dynamic>.from(event);
      final action = eventMap['action'] as String;
      final m = Map<String, dynamic>.from(eventMap['m']);
      for (var i = 0; i < _bindings.length; i++) {
        if (_bindings[i].getEvent() == action) {
          switch (action) {
            case "CONFERENCE_LEFT":
            case "CONFERENCE_FAILED":
            case "CONFERENCE_ERROR":
            case "BEFORE_STATISTICS_DISPOSED":
            case "TALK_WHILE_MUTED":
            case "NO_AUDIO_INPUT":
            case "AUDIO_INPUT_STATE_CHANGE":
            case "NOISY_MIC":
              (_bindings[i].getCallback() as ConferenceCallbackParam0)();
              break;
            case "CONFERENCE_JOINED":
              (_bindings[i].getCallback() as ConferenceCallbackParam0)();
              break;
            case "LOCAL_STATS_UPDATED":
              (_bindings[i].getCallback()
              as ConferenceCallbackParam1)(m["statsObject"]);
              break;
            case 'DOMINANT_SPEAKER_CHANGED':
              (_bindings[i].getCallback() as ConferenceCallbackParam1)(m["id"]);
              break;
            case 'SUBJECT_CHANGED':
              (_bindings[i].getCallback()
              as ConferenceCallbackParam1)(m["subject"]);
              break;
            case 'CONFERENCE_UNIQUE_ID_SET':
              (_bindings[i].getCallback()
              as ConferenceCallbackParam1)(m["meetingId"]);
              break;
            case 'DTMF_SUPPORT_CHANGED':
              dtmf = m["support"];
              (_bindings[i].getCallback()
              as ConferenceCallbackParam1)(m["support"]);
              break;
            case 'TRACK_ADDED':
              JitsiRemoteTrack track = new JitsiRemoteTrack(m);
              remoteTracks.add(track);
              (_bindings[i].getCallback() as ConferenceCallbackParam1)(track);
              break;
            case 'TRACK_REMOVED':
              JitsiRemoteTrack track =
              remoteTracks.firstWhere((t) => t.id == m["id"]);
              (_bindings[i].getCallback() as ConferenceCallbackParam1)(track);
              break;
            case 'TRACK_MUTE_CHANGED':
              JitsiRemoteTrack track =
              remoteTracks.firstWhere((t) => t.id == m["id"]);
              track.setMuted(m["muted"]);
              (_bindings[i].getCallback() as ConferenceCallbackParam1)(track);
              break;
            case 'TRACK_AUDIO_LEVEL_CHANGED':
              (_bindings[i].getCallback() as ConferenceCallbackParam2)(
                  m["id"], m["audioLevel"]);
              break;
            case 'USER_JOINED':
              Participant participant = new Participant(m);
              participants.add(participant);
              (_bindings[i].getCallback() as ConferenceCallbackParam2)(
                  m["id"], participant);
              break;
            case 'USER_LEFT':
              Participant participant =
              participants.firstWhere((p) => p.id == m["id"]);
              (_bindings[i].getCallback() as ConferenceCallbackParam2)(
                  m["id"], participant);
              break;
            case 'DISPLAY_NAME_CHANGED':
              (_bindings[i].getCallback() as ConferenceCallbackParam2)(
                  m["id"], m["displayName"]);
              break;
            case "LAST_N_ENDPOINTS_CHANGED":
              (_bindings[i].getCallback() as ConferenceCallbackParam2)(
                  m["enterArrayIds"], m["leavingArrayIds"]);
              break;
            case "USER_ROLE_CHANGED":
              role = m["role"];
              (_bindings[i].getCallback() as ConferenceCallbackParam2)(
                  m["id"], m["role"]);
              break;
            case "USER_STATUS_CHANGED":
              (_bindings[i].getCallback() as ConferenceCallbackParam2)(
                  m["id"], m["status"]);
              break;
            case "KICKED":
              Participant participant = participants
                  .firstWhere((p) => p.id == m["participant"]["id"]);
              (_bindings[i].getCallback() as ConferenceCallbackParam2)(
                  participant, m["reason"]);
              break;
            case "START_MUTED_POLICY_CHANGED":
              (_bindings[i].getCallback() as ConferenceCallbackParam2)(
                  m["audio"], m["video"]);
              break;
            case "STARTED_MUTED":
              (_bindings[i].getCallback() as ConferenceCallbackParam2)(
                  m["audio"], m["video"]);
              break;
            case "ENDPOINT_MESSAGE_RECEIVED":
              Participant participant = participants
                  .firstWhere((p) => p.id == m["participant"]["id"]);
              (_bindings[i].getCallback() as ConferenceCallbackParam2)(
                  participant, m["message"]);
              break;
            case "REMOTE_STATS_UPDATED":
              (_bindings[i].getCallback() as ConferenceCallbackParam2)(
                  m["id"], m["statsObject"]);
              break;
            case "AUTH_STATUS_CHANGED":
              (_bindings[i].getCallback() as ConferenceCallbackParam2)(
                  m["isAuthEnabled"], m["authIdentity"]);
              break;
            case "MESSAGE_RECEIVED":
              (_bindings[i].getCallback() as ConferenceCallbackParam3)(
                  m["id"], m["text"], m["ts"]);
              break;
            case "PARTICIPANT_KICKED":
              Participant kicked = participants
                  .firstWhere((p) => p.id == m["kickedParticipant"]["id"]);
              Participant actor = participants
                  .firstWhere((p) => p.id == m["actorParticipant"]["id"]);
              (_bindings[i].getCallback() as ConferenceCallbackParam3)(
                  actor, kicked, m["reason"]);
              break;
            default:
          }
        }
      }
    });
  }

  static Future<T?> _invokeMethod<T>(String method,
      [Map<String, dynamic>? arguments]) {
    return _methodChannel.invokeMethod(method, arguments);
  }

  bool isHidden() {
    return hidden;
  }

  bool isDTMFSupported() {
    return dtmf;
  }

  String getUserId() {
    return userId;
  }

  String getUserRole() {
    return role;
  }

  String getUserEmail() {
    return email;
  }

  String getUserAvatar() {
    return avatar;
  }

  String getUserName() {
    return userId;
  }

  void join([String password = '']) {
    if (password != '') {
      _invokeMethod('join', {'password': password});
    } else {
      _invokeMethod('join');
    }
  }

  void grantOwner(String id) {
    _invokeMethod('grantOwner', {'id': id});
  }

  void setStartMutedPolicy(Map<String, bool> policy) {
    _invokeMethod('setStartMutedPolicy', {'policy': policy});
  }

  void setReceiverVideoConstraint(int resolution) {
    _invokeMethod('setReceiverVideoConstraint', {'resolution': resolution});
  }

  void setSenderVideoConstraint(int resolution) {
    _invokeMethod('setSenderVideoConstraint', {'resolution': resolution});
  }

  void sendMessage(String message, [String to = '']) {
    if (to != '') {
      _invokeMethod('sendMessage', {message: 'message', 'to': to});
    } else {
      _invokeMethod('sendMessage', {message: 'message'});
    }
  }

  void setLastN(int num) {
    _invokeMethod('setLastN', {'num': num});
  }

  void muteParticipant(String id, String mediaType) {
    if (mediaType != "") {
      _invokeMethod('muteParticipant', {'id': id, 'mediaType': mediaType});
    } else {
      _invokeMethod('muteParticipant', {'id': id});
    }
  }

  void setDisplayName(String displayName) {
    _invokeMethod('displayName', {'displayName': displayName});
  }

  void addTrack(JitsiLocalTrack track) {
    _invokeMethod('addTrack', {'trackId': track.getId()});
  }

  void removeTrack(JitsiLocalTrack track) {
    _invokeMethod('removeTrack', {'trackId': track.getId()});
  }

  void replaceTrack(JitsiLocalTrack oldTrack, JitsiLocalTrack newTrack) {
    _invokeMethod('replaceTrack',
        {'oldTrackId': oldTrack.getId(), 'newTrackId': newTrack.getId()});
  }

  void lock(String password) {
    _invokeMethod('lock', {'password': password});
  }

  void setSubject(String subject) {
    _invokeMethod('setSubject', {'subject': subject});
  }

  void unlock() {
    _invokeMethod('unlock');
  }

  void kickParticipant(String id) {
    _invokeMethod('kickParticipant', {'id': id});
  }

  void pinParticipant(String id) {
    _invokeMethod('pinParticipant', {'id': id});
  }

  void selectParticipant(String id) {
    _invokeMethod('selectParticipant', {'id': id});
  }

  void startTranscriber() {
    _invokeMethod('startTranscriber');
  }

  void stopTranscriber() {
    _invokeMethod('stopTranscriber');
  }

  void revokeOwner(String id) {
    _invokeMethod('startRecording', {'id': id});
  }

  void startRecording(Map<String, dynamic> options) {
    _invokeMethod('startRecording', {'options': options});
  }

  void stopRecording(String sessionID) {
    _invokeMethod('stopRecording', {'sessionID': sessionID});
  }

  void setLocalParticipantProperty(String propertyKey, String propertyValue) {
    _invokeMethod('setLocalParticipantProperty',
        {'propertyKey': propertyKey, 'propertyValue': propertyValue});
  }

  void sendFeedback(String overallFeedback, String detailedFeedback) {
    _invokeMethod('sendFeedback', {
      'overallFeedback': overallFeedback,
      'detailedFeedback': detailedFeedback
    });
  }

  void leave() {
    _invokeMethod('leave');
  }

  void removeLocalParticipantProperty(String name) {
    _invokeMethod('removeLocalParticipantProperty', {'name': name});
  }

  void dial(int number) {
    _invokeMethod('dial', {
      'number': number,
    });
  }

  void selectParticipants(List<String> participantIds) {
    _invokeMethod('selectParticipants', {
      'participantIds': participantIds,
    });
  }

  int getParticipantCount(bool hidden) {
    var total = 0;
    for (var participant in participants) {
      if (participant.isHidden()) {
        total++;
      }
    }
    if (!hidden) {
      return participants.length - total + 1;
    } else {
      return participants.length + 1;
    }
  }

  List<Participant> getParticipants(bool hidden) {
    return participants;
  }

  List<JitsiLocalTrack> getLocalTracks(bool hidden) {
    return localTracks;
  }

  List<JitsiRemoteTrack> getRemoteTracks(bool hidden) {
    return remoteTracks;
  }

  void addEventListener(String event, dynamic callback) {
    _bindings.add(new ConferenceBinding(event, callback));
    Map<String, dynamic> arguments = {
      'event': event,
    };
    _invokeMethod('addConferenceListeners', arguments);
  }

  void removeEventListener(event) {
    _bindings = _bindings.where((binding) => binding.event != event).toList();
  }
}
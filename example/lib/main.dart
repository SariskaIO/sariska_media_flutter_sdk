import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:sariska_media_flutter_sdk/Conference.dart';
import 'package:sariska_media_flutter_sdk/Connection.dart';
import 'package:sariska_media_flutter_sdk/JitsiLocalTrack.dart';
import 'package:sariska_media_flutter_sdk/JitsiRemoteTrack.dart';
import 'package:sariska_media_flutter_sdk/SariskaMediaTransport.dart';
import 'package:sariska_media_flutter_sdk/Track.dart';
import 'package:sariska_media_flutter_sdk/WebRTCView.dart';

import 'GenerateToken.dart';

typedef void LocalTrackCallback(List<JitsiLocalTrack> tracks);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();

  static late LocalTrackCallback localTrackCallback;
}

class _MyAppState extends State<MyApp> {
  final _sariskaMediaTransport = SariskaMediaTransport();
  String token = 'unknown';
  String streamURL = '';
  List<JitsiLocalTrack> localtracks = [];

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    token = "sadasdsa";
    _sariskaMediaTransport.initializeSdk();
    setupLocalStream();
    if (!mounted) return;
  }

  void setupLocalStream() {
    Map<String, dynamic> options = new Map();
    options["audio"] = true;
    options["video"] = true;


    _sariskaMediaTransport.createLocalTracks(options, (tracks) {
      print("Inside Create Local Tracks");
      localtracks = tracks;
      for (JitsiLocalTrack track in localtracks) {
        if (track.getType() == "video") {
          replaceChild(track);
        }
      }
    });

    startConnection();
  }

  void startConnection() async {
    token = await generateToken();
    Connection _connection =
    _sariskaMediaTransport.jitsiConnection(token, "ramdon", false);

    _connection.addEventListener("CONNECTION_ESTABLISHED", () {

      Conference _conference = _connection.initJitsiConference();

      _conference.addEventListener("CONFERENCE_JOINED", () {
        print("Conference Joined sdasdsa");
        print("track id" + localtracks[1].getType());
        _conference.addTrack(localtracks[1]);
      });

      _conference.addEventListener("TRACK_ADDED", (track) {
        JitsiRemoteTrack remoteTrack = track;
        if (remoteTrack.getStreamURL() == streamURL) {
          return;
        }
        if (remoteTrack.getType() == "audio") {
          return;
        }
        streamURL = remoteTrack.getStreamURL();
        replaceChild(remoteTrack);
      });

      _conference.join();
    });

    _connection.addEventListener("CONNECTION_FAILED", () {
      print("Connection Failed");
    });

    _connection.addEventListener("CONNECTION_DISCONNECTED", () {
      print("Connection Disconnected");
    });

    _connection.connect();
  }

  Widget _currentChild = VideoView(isLocal: true);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Sariska Media Flutter Demo'),
          ),
          body: Column(
            children: [
              Expanded(child: _currentChild),
            ],
          )),
    );
  }

  void replaceChild(Track localTrack) {
    setState(() {
      _currentChild = UpdatedChildWidget(track: localTrack);
    });
  }
}

class VideoView extends StatelessWidget {
  final bool isLocal;
  const VideoView({required this.isLocal});
  @override
  Widget build(BuildContext context) {
    // Add your video view implementation here
    return Container(
      color: isLocal ? Colors.blueGrey : Colors.black,
      child: Center(
        child: Text(
          isLocal ? 'Local Video View' : 'Remote Video View',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

class UpdatedChildWidget extends StatelessWidget {
  final Track track;
  const UpdatedChildWidget({required this.track});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: buildWebRTCView(),
      ),
    );
  }

  WebRTCView buildWebRTCView() {
    return WebRTCView(
      localTrack: track,
      mirror: true,
      objectFit: 'cover',
    );
  }
}

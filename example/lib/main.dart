import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:sariska_media_flutter_sdk/Conference.dart';
import 'package:sariska_media_flutter_sdk/Connection.dart';
import 'package:sariska_media_flutter_sdk/JitsiLocalTrack.dart';
import 'package:sariska_media_flutter_sdk/JitsiRemoteTrack.dart';
import 'package:sariska_media_flutter_sdk/SariskaMediaTransport.dart';
import 'package:sariska_media_flutter_sdk/WebRTCView.dart';
import 'package:sariska_media_flutter_sdk_example/GenerateToken.dart';

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
  String _platformVersion = 'Unknown';
  final _sariskaMediaTransport = SariskaMediaTransport();
  String token = 'unknown';
  String streamURL = '';


  @override
  void initState() {
    super.initState();
    initPlatformState();
  }


  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;

    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      token = await generateToken();
      // For makeing sure bridge is working fine.
      platformVersion = await _sariskaMediaTransport.getPlatformVersion() ?? 'Unknown platform version';

      // Initialize Sariska Media Tranasport
      _sariskaMediaTransport.initializeSdk();

      setupLocalStream();

      //Create Connection
      final _connection = Connection(token, "dipak", false);

      _connection.addEventListener("CONNECTION_ESTABLISHED", () {
        Conference _conference = _connection.initJitsiConference();

        _conference.addEventListener("CONFERENCE_JOINED", (){
          print("Conference Joined");
        });

        _conference.addEventListener("TRACK_ADDED", (track){
          JitsiRemoteTrack remoteTrack = track;
          if(remoteTrack.getStreamURL() == streamURL){
            return;
          }
          if(remoteTrack.getType() == "audio"){
            return;
          }
          streamURL = remoteTrack.getStreamURL();
          replaceChild(streamURL);
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

    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  void setupLocalStream(){
    Map<String, dynamic> options = new Map();
    options["audio"] = true;
    options["video"] = true;
    List<JitsiLocalTrack> localtracks = [];
    _sariskaMediaTransport.createLocalTracks(options, (tracks){
      print("Inside Create Local Tracks");
      localtracks = tracks;
      for(JitsiLocalTrack track in localtracks){
        if(track.getType() == "video"){
          streamURL = track.getStreamURL();
          //replaceChild(streamURL);
        }
      }
    });
  }

  Widget _currentChild = PlaceholderWidget();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: _currentChild,
      ),
    );
  }


  void replaceChild(String streamUrl) {
    setState(() {
      _currentChild = UpdatedChildWidget(streamUrl: streamURL);
    });
  }
}
class PlaceholderWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Placeholder Widget'),
    );
  }
}

class UpdatedChildWidget extends StatelessWidget {
  final String streamUrl;
  const UpdatedChildWidget({required this.streamUrl});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 300,
        height: 200,
        child: buildWebRTCView(),
      ),
    );
  }
  WebRTCView buildWebRTCView() {
    return WebRTCView(
      streamURL: streamUrl,
      mirror: true,
      objectFit: 'cover',
    );
  }
}


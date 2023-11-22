import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:ui';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter/services.dart';
import 'package:sariska_media_flutter_sdk/Conference.dart';
import 'package:sariska_media_flutter_sdk/Connection.dart';
import 'package:sariska_media_flutter_sdk/JitsiLocalTrack.dart';
import 'package:sariska_media_flutter_sdk/JitsiRemoteTrack.dart';
import 'package:sariska_media_flutter_sdk/SariskaMediaTransport.dart';
import 'package:sariska_media_flutter_sdk/Track.dart';
import 'package:sariska_media_flutter_sdk/WebRTCView.dart';
import 'package:sariska_media_flutter_sdk_example/GenerateToken.dart';
import 'package:get/get.dart';

typedef void LocalTrackCallback(List<JitsiLocalTrack> tracks);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
  static late LocalTrackCallback localTrackCallback;
}

class _MyAppState extends State<MyApp> {
  final _sariskaMediaTransport = SariskaMediaTransport();
  String token = 'unknown';
  String streamURL = '';
  List<JitsiRemoteTrack> remoteTracks = [];
  List<JitsiLocalTrack> localtracks = [];
  JitsiLocalTrack? localTrack;
  bool isAudioOn = true;
  bool isVideoOn = true;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Demo App'),
          foregroundColor: Colors.white,
          backgroundColor: Colors.deepPurple,
          elevation: 25,
          shadowColor: Colors.black,
        ),
        body: Column(
          children: [
            Flexible(
              flex: 2,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemCount: remoteTracks.length,
                itemBuilder: (BuildContext context, int index) {
                  return Stack(
                    children: [
                      Center(
                        child: SizedBox(
                          width: 360,
                          height: 240,
                          child: AspectRatio(
                            aspectRatio:
                                16 / 9, // Adjust the aspect ratio as needed
                            child: WebRTCView(
                              localTrack: remoteTracks[index],
                              mirror: true,
                              objectFit: 'cover',
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            if (localTrack != null)
              Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  width: 150,
                  height: 180,
                  child: WebRTCView(
                    localTrack: localTrack!,
                    mirror: true,
                    objectFit: 'cover',
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: InkWell(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(30),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 20,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      buildCustomButton(
                        onPressed: () {
                          setState(() {
                            for (JitsiLocalTrack track in localtracks) {
                              if (track.getType() == "audio") {
                                if (isAudioOn) {
                                  track.mute();
                                  isAudioOn = !isAudioOn;
                                } else {
                                  track.unmute();
                                  isAudioOn = !isAudioOn;
                                }
                                break;
                              }
                            }
                          });
                        },
                        icon: isAudioOn
                            ? IconlyLight.voice
                            : Icons.mic_off_outlined,
                        color: Colors.transparent,
                      ),
                      buildEndCallButton(
                        onPressed: () {
                          Get.offAll(const MyApp());
                        },
                      ),
                      buildCustomButton(
                        onPressed: () {
                          setState(() {
                            for (JitsiLocalTrack track in localtracks) {
                              if (track.getType() == "video") {
                                if (isVideoOn) {
                                  track.mute();
                                  isVideoOn = !isVideoOn;
                                } else {
                                  track.unmute();
                                  isVideoOn = !isVideoOn;
                                }
                                break;
                              }
                            }
                          });
                        },
                        icon: isVideoOn
                            ? IconlyLight.video
                            : Icons.videocam_off_outlined,
                        color: Colors.transparent,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.deepPurple,
      ),
    );
  }

  Future<void> initPlatformState() async {
    try {
      token = await generateToken();
      String platformVersion =
          await _sariskaMediaTransport.getPlatformVersion() ??
              'Unknown platform version';

      _sariskaMediaTransport.initializeSdk();
      setupLocalStream();

      final _connection = Connection(token, "random", false);

      _connection.addEventListener("CONNECTION_ESTABLISHED", () {
        Conference _conference = _connection.initJitsiConference();

        _conference.addEventListener("CONFERENCE_JOINED", () {
          print("Conference joined from Swift and Android");
          print("Local Track length: "+ localtracks.length.toString());
          for (JitsiLocalTrack track in localtracks) {
            _conference.addTrack(track);
          }
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

      setState(() {

      });
    } on PlatformException {
      print("Failed to get platform version.");
    }
  }

  void setupLocalStream() {
    Map<String, dynamic> options = {};
    options["audio"] = true;
    options["video"] = true;

    _sariskaMediaTransport.createLocalTracks(options, (tracks) {
      localtracks = tracks;
      for (JitsiLocalTrack track in localtracks) {
        if (track.getType() == "video") {
          setState(() {
            localTrack = track;
          });
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

  void replaceChild(JitsiRemoteTrack remoteTrack) {
    setState(() {
      remoteTracks.add(remoteTrack);
    });
  }

  Widget buildCustomButton({
    required VoidCallback onPressed,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.transparent,
      ),
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 30,
          ),
        ),
      ),
    );
  }

  Widget buildEndCallButton({required VoidCallback onPressed}) {
    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.red,
      ),
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        child: Container(
          padding: const EdgeInsets.all(15),
          child: const Icon(
            Icons.call_end,
            color: Colors.white,
            size: 40,
          ),
        ),
      ),
    );
  }
}

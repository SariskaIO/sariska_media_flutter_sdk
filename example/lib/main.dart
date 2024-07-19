import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_audio_output/flutter_audio_output.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sariska_media_flutter_sdk/Conference.dart';
import 'package:sariska_media_flutter_sdk/Connection.dart';
import 'package:sariska_media_flutter_sdk/JitsiLocalTrack.dart';
import 'package:sariska_media_flutter_sdk/JitsiRemoteTrack.dart';
import 'package:sariska_media_flutter_sdk/SariskaMediaTransport.dart';
import 'package:sariska_media_flutter_sdk/WebRTCView.dart';
import 'package:sariska_media_flutter_sdk_example/GenerateToken.dart';

typedef LocalTrackCallback = void Function(List<JitsiLocalTrack> tracks);
const Color themeColor = Color(0xff4050B5);

void main() {
  runApp(const MaterialApp(
    home: RoomNamePage(),
    debugShowCheckedModeBanner: true,
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key, required this.roomName}) : super(key: key);

  final String roomName;

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
  List<Map<String ,String>> lobbyUsers = []; 
  JitsiLocalTrack? localTrack;
  bool isAudioOn = true;
  bool isVideoOn = true;

  late Conference _conference;
  late Connection _connection;

  @override
  void initState() {
    super.initState();
    initPlatformState();
    init();
  }

  late AudioInput _currentInput = const AudioInput("unknown", 0);
  bool isSpeakerOn = false;
  bool isCameraSwitch = false;

  Future<void> init() async {
    FlutterAudioOutput.setListener(() async {
      await _getInput();
      setState(() {});
    });

    await _getInput();
    if (!mounted) return;
    setState(() {});
  }

  _getInput() async {
    _currentInput = await FlutterAudioOutput.getCurrentOutput();
  }

  late BuildContext currentContext;

  @override
  Widget build(BuildContext context) {
    currentContext = context;
    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: [
            if (localTrack != null && isVideoOn)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                bottom: 0,
                child: WebRTCView(
                  localTrack: localTrack!,
                  mirror: true,
                  objectFit: 'cover',
                ),
              ),
            if (localTrack != null && !isVideoOn)
              const Positioned(
                top: 0,
                left: 0,
                right: 0,
                bottom: 0,
                child: Center(
                  child: Icon(
                    IconlyLight.profile,
                    size: 100,
                    color: Colors.white, // Customize color as needed
                  ),
                ),
              ),
            Positioned(
              bottom: 140,
              left: 0,
              right: 0,
              child: SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: remoteTracks.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 2.0, right: 2.0),
                      child: Container(
                        width: 120,
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: WebRTCView(
                          localTrack: remoteTracks[index],
                          mirror: true,
                          objectFit: 'cover',
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Material(
                    borderRadius: BorderRadius.circular(30),
                    clipBehavior: Clip.antiAlias,
                    color: Colors.transparent,
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaY: 20,
                        sigmaX: 20,
                      ),
                      child: InkWell(
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(30),
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
                              buildCustomButton(
                                onPressed: () {
                                  setState(() {
                                    for (JitsiLocalTrack track in localtracks) {
                                      if (track.getType() == "video") {
                                        track.switchCamera();
                                        isCameraSwitch = !isCameraSwitch;
                                      }
                                    }
                                  });
                                  setState(() {});
                                },
                                icon: isCameraSwitch
                                    ? IconlyLight.camera
                                    : Icons.switch_camera_outlined,
                                color: Colors.transparent,
                              ),
                              buildEndCallButton(
                                onPressed: () {
                                  for (JitsiLocalTrack x in localtracks) {
                                    x.dispose();
                                  }
                                  localTrack?.dispose();
                                  localtracks.clear();
                                  _conference.leave();
                                  _connection.disconnect();
                                  Navigator.pop(context);
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
                              buildCustomButton(
                                onPressed: () async {
                                  if (isSpeakerOn) {
                                    toggleSpeaker(false);
                                  } else {
                                    toggleSpeaker(true);
                                  }
                                },
                                icon: isSpeakerOn
                                    ? IconlyLight.volumeUp
                                    : IconlyBold.volumeOff,
                                color: Colors.transparent,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.black,
      ),
    );
  }

  Future<void> initPlatformState() async {
    try {
      debugPrint("Initializing platform state");
      token = await generateToken();
      _sariskaMediaTransport.initializeSdk();
      setupLocalStream();

      _connection = Connection(token, widget.roomName, false);

      _connection.addEventListener("CONNECTION_ESTABLISHED", () {
        _conference = _connection.initJitsiConference();
        _conference.addEventListener("CONFERENCE_JOINED", () {
          for (JitsiLocalTrack track in localtracks) {
            debugPrint("Local Track Added");
            _conference.addTrack(track);
          }
        });

        _conference.addEventListener("USER_ROLE_CHANGED", (id, newRole) {
          debugPrint("User Role changed");
          String role = newRole.toString().toLowerCase();
          if (role == "moderator") {
            debugPrint("Enable Lobby Called");
            _conference.enableLobby();
          }
        });

        _conference.addEventListener("MESSAGE_RECEIVED", (senderId, message) {
          debugPrint("Received Message $message");
        });

        _conference.addEventListener("LOBBY_USER_JOINED", (id, displayName) {
          debugPrint("New User in Lobby");
          debugPrint(id);
          debugPrint(displayName);
          lobbyUsers.add({'id': id , 'name':displayName});
          setState(() {
            showDialog(
              context: currentContext,
              builder: (BuildContext currentContext) {
                return AlertDialog(
                  title: const Text('A New User want to join lobby ?'),
                  content: const Text(
                    '',
                  ),
                  actions: <Widget>[
                    TextButton(
                      style: TextButton.styleFrom(
                        textStyle:
                            Theme.of(currentContext).textTheme.labelLarge,
                      ),
                      child: const Text('Deny user'),
                      onPressed: () {
                        _conference.lobbyDenyAccess(id.toString());
                        Navigator.of(currentContext).pop();
                      },
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        textStyle:
                            Theme.of(currentContext).textTheme.labelLarge,
                      ),
                      child: const Text('Allow user'),
                      onPressed: () {
                        _conference.lobbyApproveAccess(id.toString());
                        Navigator.of(currentContext).pop();
                      },
                    ),
                  ],
                );
              },
            );
          });
        });

        _conference.addEventListener(
            "LOBBY_USER_UPDATED", (id, participant) {});

        _conference.addEventListener("LOBBY_USER_LEFT", (id) {
          debugPrint("Left User from Lobby");
        });

        _conference.addEventListener("CONFERENCE_FAILED", () {
          debugPrint("Conference Failed call in flutter");
          _conference.joinLobby(_conference.getUserName(), "random_email");
        });

        _conference.addEventListener("TRACK_ADDED", (track) {
          JitsiRemoteTrack remoteTrack = track;
          for (JitsiLocalTrack track in localtracks) {
            if (track.getStreamURL() == remoteTrack.getStreamURL()) {
              return;
            }
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

      setState(() {});
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
  }

  void replaceChild(JitsiRemoteTrack remoteTrack) {
    setState(() {
      remoteTracks.add(remoteTrack);
    });
  }

  void toggleSpeaker(bool isSpeaker) async {
    for (JitsiLocalTrack track in localtracks) {
      if (track.getType() == "audio") {
        track.toggleSpeaker(isSpeaker);
        isSpeakerOn = isSpeaker;
        setState(() {});
      }
    }
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
            color: Colors.black,
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

class RoomNamePage extends StatefulWidget {
  const RoomNamePage({Key? key}) : super(key: key);

  @override
  _RoomNamePageState createState() => _RoomNamePageState();
}

class _RoomNamePageState extends State<RoomNamePage> {
  final TextEditingController _roomNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    webViewMethod();
  }

  Future webViewMethod() async {
    print('In Microphone permission method');
    WidgetsFlutterBinding.ensureInitialized();
    await Permission.microphone.request();
    WebViewMethodForCamera();
  }

  Future WebViewMethodForCamera() async {
    print('In Camera permission method');
    WidgetsFlutterBinding.ensureInitialized();
    await Permission.camera.request();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency, // or any other theme configuration
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Sariska.io',
            style: TextStyle(
              color: themeColor,
              fontSize: 30,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const SizedBox(height: 20),
              TextField(
                controller: _roomNameController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(IconlyLight.video),
                  contentPadding: EdgeInsets.symmetric(horizontal: 15),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: themeColor, width: 2),
                  ),
                  labelText: "Room Name",
                  labelStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: themeColor,
                  textStyle: const TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  debugPrint("Meeting create button pressed");
                  final roomName = _roomNameController.text.trim();
                  if (roomName.isNotEmpty) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyApp(roomName: roomName),
                      ),
                    );
                  } else {
                    Fluttertoast.showToast(
                        msg: "Please Enter a room name",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.yellow,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  }
                },
                child: const Text(
                  'Enter Room',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
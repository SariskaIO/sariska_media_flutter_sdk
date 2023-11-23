import 'Track.dart';

/// Represents a remote track in Jitsi.
class JitsiRemoteTrack extends Track {
  /// The ID of the participant associated with this remote track.
  String participantId = '';

  /// Constructs a [JitsiRemoteTrack] object from a map of properties.
  ///
  /// The [map] parameter is a map that contains the properties of the remote track.
  JitsiRemoteTrack(Map<dynamic, dynamic> map) : super(map) {
    this.participantId = map["participantId"];
  }

  /// Retrieves the ID of the participant associated with this remote track.
  ///
  /// Returns the participant ID as a string.
  String getParticipantId() {
    return this.participantId;
  }

  /// Checks if the remote track is local or not.
  ///
  /// Returns `false` indicating that the track is remote.
  bool isLocal() {
    return false;
  }
}

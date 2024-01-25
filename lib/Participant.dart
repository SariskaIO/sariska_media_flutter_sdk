
class Participant {

  String id='';

  String jid='';

  String avatar='';

  String email='';

  bool moderator=false;

  bool audioMuted=false;

  bool videoMuted=false;

  String displayName='';

  String role='';

  String status='';

  bool hidden=false;

  String botType='';

  Participant(Map<String, dynamic> map) {
    id = map['id'];
    jid = map['jid'];
    displayName = map['displayName'];
    moderator = map['moderator'];
    hidden = map['hidden'];
    videoMuted = map['videoMuted'];
    audioMuted = map['audioMuted'];
    botType = map['botType'];
    status = map['status'];
    avatar = map['avatar'];
    role = map['role'];
    email = map['email'];
  }

  String getId() {
    return id;
  }

  String getDisplayName() {
    return displayName;
  }

  String getRole() {
    return role;
  }

  String getJid() {
    return jid;
  }

  String getAvatar() {
    return avatar;
  }

  bool isModerator() {
    return moderator;
  }

  bool isHidden() {
    return hidden;
  }

  String getStatus() {
    return status;
  }

  bool isAudioMuted() {
    return audioMuted;
  }

  bool isVideoMuted() {
    return videoMuted;
  }

  String getBotType() {
    return botType;
  }

  String getEmail() {
    return email;
  }
}
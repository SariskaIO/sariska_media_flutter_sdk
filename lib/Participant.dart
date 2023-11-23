
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
    this.id = map['id'];
    this.jid = map['jid'];
    this.displayName = map['displayName'];
    this.moderator = map['moderator'];
    this.hidden = map['hidden'];
    this.videoMuted = map['videoMuted'];
    this.audioMuted = map['audioMuted'];
    this.botType = map['botType'];
    this.status = map['status'];
    this.avatar = map['avatar'];
    this.role = map['role'];
    this.email = map['email'];
  }

  String getId() {
    return this.id;
  }

  String getDisplayName() {
    return this.displayName;
  }

  String getRole() {
    return this.role;
  }

  String getJid() {
    return this.jid;
  }

  String getAvatar() {
    return this.avatar;
  }

  bool isModerator() {
    return this.moderator;
  }

  bool isHidden() {
    return this.hidden;
  }

  String getStatus() {
    return this.status;
  }

  bool isAudioMuted() {
    return this.audioMuted;
  }

  bool isVideoMuted() {
    return this.videoMuted;
  }

  String getBotType() {
    return this.botType;
  }

  String getEmail() {
    return this.email;
  }
}
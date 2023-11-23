//
// Created by Dipak Sisodiya on 10/06/23.
//

import Foundation
import sariska

public class ConferenceManager : NSObject{

    private var emitter: (_ action: String, _ m: [String: Any?]?) -> Void

    var conference : Conference?

    init(_ emitter: @escaping (_ action: String, _ m: [String: Any?]?) -> Void) {
        self.emitter = emitter
        super.init()
    }

    func release(){
        conference = nil
    }

    @objc public func createConference(){
        conference = Conference()
    }

    @objc public func join(){
        conference?.join()
        conference?.addTrack(track: SariskaMediaTransportFlutterPlugin.localTrack ?? JitsiLocalTrack())
    }

    @objc func join(_ params: NSDictionary) {
        conference?.join((params["password"] as! NSString) as String)
    }

    @objc func grantOwner(_ params: NSDictionary) {
        conference?.grantOwner((params["id"] as! NSString) as String)
    }

    @objc func setStartMutedPolicy(_ params: NSDictionary) {
        conference?.setStartMutedPolicy((params["policy"] as! NSDictionary) as! [AnyHashable: Any])
    }

    @objc func setReceiverVideoConstraint(_ params: NSDictionary) {
        conference?.setReceiverVideoConstraint(params["number"] as! NSNumber)
    }

    @objc func setSenderVideoConstraint  (_ params: NSDictionary) {
        conference?.setSenderVideoConstraint(params["number"] as! NSNumber)
    }

    @objc func sendMessage(_ params: NSDictionary) {
        if ((params["to"] as! NSString) != "") {
            conference?.sendMessage((params["message"] as! NSString) as String, to: (params["to"] as! NSString) as String)
        } else {
            conference?.sendMessage((params["message"] as! NSString) as String)
        }
    }

    @objc func setLastN(_ params: NSDictionary) {
        conference?.setLastN(params["num"] as! NSNumber)
    }

    @objc func dial(_ params: NSDictionary) {
        conference?.dial(params["number"] as! NSNumber)
    }

    @objc public func muteParticipant(_ params: NSDictionary) {
        conference?.muteParticipant((params["id"] as! NSString) as String, mediaType: (params["mediaType"] as! NSString) as String)
    }

    @objc func setDisplayName(_ params: NSDictionary) {
        conference?.setDisplayName((params["displayName"] as! NSString) as String)
    }

    @objc func addTrack(_ params: NSDictionary) {
        var array = conference?.getLocalTracks()
        for track in array as! NSMutableArray {
            let track = track as! JitsiLocalTrack
            if (track.getId() == ((params["trackId"] as! NSString) as String))  {
                conference?.addTrack(track: track)
            }
        }
    }

    @objc func removeTrack(_ params: NSDictionary) {
        for track in conference?.getLocalTracks() as! NSMutableArray{
            let track = track as! JitsiLocalTrack
            if (track.getId() == ((params["trackId"] as! NSString) as String))  {
                conference?.removeTrack(track: track)
            }
        }
    }

    @objc public func leave() {
        conference?.leave()
    }
    
    @objc public func isHidden() -> Bool{
        return ((conference?.isHidden()) != nil)
    }
    
    @objc public func getUserRole() -> String {
        return (conference?.getUserRole())!
    }

    @objc public func getUserEmail() -> String {
        return (conference?.getUserEmail())!
    }

    @objc public func getUserAvatar() -> String {
        return (conference?.getUserAvatar())!
    }

    @objc public func isDTMFSupported() -> Bool {
        return (conference?.isDTMFSupported())!
    }

    @objc public func getUserName() -> String {
        return (conference?.getUserName())!
    }

    @objc public func getPhoneNumber() -> String {
        return (conference?.getPhoneNumber())!
    }

    @objc public func getPhonePin() -> String {
        return (conference?.getPhonePin())!
    }

    @objc public func isMembersOnly() -> Bool {
        return (conference?.isMembersOnly())!
    }

    @objc public func isJoined() -> Bool {
        return (conference?.isJoined())!
    }

    @objc public func getLocalTracks() -> [JitsiLocalTrack] {
        return (conference?.getLocalTracks())! as! [JitsiLocalTrack]
    }

    @objc public func getParticipants() -> [Participant] {
        return (conference?.getParticipants())! as! [Participant]
    }

    @objc public func getRemoteTracks() -> [JitsiRemoteTrack] {
        return (conference?.getParticipants())! as! [JitsiRemoteTrack]
    }


    @objc func addEventListeners(_ dictionary: [String: Any]){
        var eventString = dictionary["event"] as! String
        switch(eventString){
        case "CONFERENCE_JOINED":
            conference?.addEventListener(eventString, callback0: { [self] in
                emitter(dictionary["event"] as! String, dictionary)
            })
        case "TRACK_ADDED":
            conference?.addEventListener(eventString, callback1: { [self] track in
                let sometrack = track as! JitsiRemoteTrack
                var event = [String:Any]()
                event["type"] = sometrack.getType()
                event["participantId"] = sometrack.getParticipantId()
                event["muted"] = sometrack.isMuted()
                event["streamURL"] = sometrack.getStreamURL()
                event["id"] = sometrack.getId()
                if(sometrack.getStreamURL() == SariskaMediaTransportFlutterPlugin.localTrack?.getStreamURL()){
                    //do noting
                }else{
                    emitter(dictionary["event"] as! String, event)
                }
            })
        case "DOMINANT_SPEAKER_CHANGED":
            // Handle dominant speaker changed event
            conference?.addEventListener(eventString, callback1: {
                [self] id in
                emitter(dictionary["event"] as! String, id as? [String : Any?])
            })
            break;
        case "TRACK_REMOVED":
            // Handle track removed event
            conference?.addEventListener(eventString, callback1: {
                [self] track in
                let someTrack = track as! JitsiRemoteTrack
                var trackEvent = [String: Any]()
                trackEvent["type"] = someTrack.getType()
                trackEvent["participantId"] = someTrack.getParticipantId()
                trackEvent["muted"] = someTrack.isMuted()
                trackEvent["streamURL"] = someTrack.getStreamURL()
                trackEvent["id"] = someTrack.getId()
                if(someTrack.getStreamURL() == SariskaMediaTransportFlutterPlugin.localTrack?.getStreamURL()){
                    // do nothing
                }else{
                    emitter(dictionary["event"] as! String, trackEvent)
                }
            })
            break;
        case "USER_JOINED":
            // Handle user joined event
            conference?.addEventListener(eventString, callback2: {
                [self] id, participant in
                let part = participant as! Participant
                var partEvent = [String: Any]()
                partEvent["participantId"] = part.getId()
                partEvent["jid"] = part.getJid()
                partEvent["displayName"] = part.getDisplayName()
                partEvent["moderator"] = part.isModerator()
                partEvent["hidden"] = part.isHidden()
                partEvent["videoMuted"] = part.isVideoMuted()
                partEvent["audioMuted"] = part.isAudioMuted()
                partEvent["botType"] = part.getBotType()
                partEvent["status"] = part.getStatus()
                partEvent["avatar"] = part.getAvatar()
                partEvent["role"] = part.getRole()
                partEvent["email"] = part.getEmail()
                emitter(dictionary["event"] as! String, partEvent)
            })
            break;
        case "USER_LEFT":
            // Handle user left event
            conference?.addEventListener(eventString, callback2: {
                [self] id, participant in
                let part = participant as! Participant
                var partEvent = [String: Any]()
                partEvent["participantId"] = part.getId()
                partEvent["jid"] = part.getJid()
                partEvent["displayName"] = part.getDisplayName()
                partEvent["moderator"] = part.isModerator()
                partEvent["hidden"] = part.isHidden()
                partEvent["videoMuted"] = part.isVideoMuted()
                partEvent["audioMuted"] = part.isAudioMuted()
                partEvent["botType"] = part.getBotType()
                partEvent["status"] = part.getStatus()
                partEvent["avatar"] = part.getAvatar()
                partEvent["role"] = part.getRole()
                partEvent["email"] = part.getEmail()
                emitter(dictionary["event"] as! String, partEvent)
            })
            break;
        case "CONFERENCE_LEFT":
            // Handle conference left event
            conference?.addEventListener(eventString, callback0: {
                [self] in
                emitter(dictionary["event"] as! String, dictionary)
            })
            break;
        case "CONFERENCE_FAILED":
            // Handle conference failed case
            break;

        case "CONFERENCE_ERROR":
            // Handle conference error case
            break;

        case "BEFORE_STATISTICS_DISPOSED":
            // Handle before statistics disposed case
            break;

        case "TALK_WHILE_MUTED":
            // Handle talk while muted case
            break;

        case "NO_AUDIO_INPUT":
            // Handle no audio input case
            break;

        case "AUDIO_INPUT_STATE_CHANGE":
            // Handle audio input state change case
            break;

        case "PASSWORD_REQUIRED":
            // Handle password required case
            break;

        case "NOISY_MIC":
            // Handle noisy microphone case
            break;

        case "LOCAL_STATS_UPDATED":
            // Handle local statistics updated case
            break;

        case "SUBJECT_CHANGED":
            // Handle subject changed case
            break;

        case "CONFERENCE_UNIQUE_ID_SET":
            // Handle conference unique ID set case
            break;

        case "DTMF_SUPPORT_CHANGED":
            // Handle DTMF support changed case
            break;

        case "TRACK_MUTE_CHANGED":
            // Handle track mute changed case
            break;

        case "LOBBY_USER_LEFT":
            // Handle lobby user left case
            break;

        case "MEMBERS_ONLY_CHANGED":
            // Handle members only changed case
            break;

        case "VIDEO_SIP_GW_AVAILABILITY_CHANGED":
            // Handle video SIP gateway availability changed case
            break;

        case "VIDEO_SIP_GW_SESSION_STATE_CHANGED":
            // Handle video SIP gateway session state changed case
            break;

        case "TRACK_AUDIO_LEVEL_CHANGED":
            // Handle track audio level changed case
            break;

        case "DISPLAY_NAME_CHANGED":
            // Handle display name changed case
            break;

        case "LAST_N_ENDPOINTS_CHANGED":
            // Handle last N endpoints changed case
            break;

        case "USER_ROLE_CHANGED":
            // Handle user role changed case
            break;

        case "USER_STATUS_CHANGED":
            // Handle user status changed case
            break;

        case "KICKED":
            // Handle kicked case
            break;

        case "START_MUTED_POLICY_CHANGED":
            // Handle start muted policy changed case
            break;

        case "STARTED_MUTED":
            // Handle started muted case
            break;

        case "ENDPOINT_MESSAGE_RECEIVED":
            // Handle endpoint message received case
            break;

        case "REMOTE_STATS_UPDATED":
            // Handle remote statistics updated case
            break;

        case "AUTH_STATUS_CHANGED":
            // Handle authentication status changed case
            break;

        case "LOBBY_USER_JOINED":
            // Handle lobby user joined case
            break;

        case "LOBBY_USER_UPDATED":
            // Handle lobby user updated case
            break;

        case "MESSAGE_RECEIVED":
            // Handle message received case
            break;

        case "RECORDER_STATE_CHANGED":
            // Handle recorder state changed case
            break;

        case "SUBTITLES_RECEIVED":
            // Handle subtitles received case
            break;

        case "PARTICIPANT_KICKED":
            // Handle participant kicked case
            break;
            
        default:
            print("Event Listener Not Implemented")
        }
    }
}

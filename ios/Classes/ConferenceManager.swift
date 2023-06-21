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
                emitter(dictionary["event"] as! String, id as! [String : Any?])
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
        default:
            print("Event Listener Not Implemented")
        }
    }
}

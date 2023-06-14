//
// Created by Dipak Sisodiya on 10/06/23.
//

import Foundation
import sariska

public class ConferenceManager : Conference{

    private var emitter: (_ action: String, _ m: [String: Any?]?) -> Void

    var conference : Conference?

    init(_ emitter: @escaping (_ action: String, _ m: [String: Any?]?) -> Void) {
        self.emitter = emitter
        super.init()
    }

    public override func newConferenceMessage(_ action: String, m: [AnyHashable: Any]) {
        print("inside new confernce message")
        super.newConferenceMessage(action, m: m)
    }

    func release(){
        conference = nil
    }

    func createConference(){
        conference = Conference()
    }

    public override func join(){
        conference?.join()
    }

    func join(_ params: NSDictionary) {
        conference?.join((params["password"] as! NSString) as String)
    }

    func grantOwner(_ params: NSDictionary) {
        conference?.grantOwner((params["id"] as! NSString) as String)
    }

    func setStartMutedPolicy(_ params: NSDictionary) {
        conference?.setStartMutedPolicy((params["policy"] as! NSDictionary) as! [AnyHashable: Any])
    }

    func setReceiverVideoConstraint(_ params: NSDictionary) {
        conference?.setReceiverVideoConstraint(params["number"] as! NSNumber)
    }

    func setSenderVideoConstraint  (_ params: NSDictionary) {
        conference?.setSenderVideoConstraint(params["number"] as! NSNumber)
    }

    func sendMessage(_ params: NSDictionary) {
        if ((params["to"] as! NSString) != "") {
            conference?.sendMessage((params["message"] as! NSString) as String, to: (params["to"] as! NSString) as String)
        } else {
            conference?.sendMessage((params["message"] as! NSString) as String)
        }
    }

    func setLastN(_ params: NSDictionary) {
        conference?.setLastN(params["num"] as! NSNumber)
    }

    func dial(_ params: NSDictionary) {
        conference?.dial(params["number"] as! NSNumber)
    }

    func muteParticipant(_ params: NSDictionary) {
        conference?.muteParticipant((params["id"] as! NSString) as String, mediaType: (params["mediaType"] as! NSString) as String)
    }

    func setDisplayName(_ params: NSDictionary) {
        conference?.setDisplayName((params["displayName"] as! NSString) as String)
    }

    func addTrack(_ params: NSDictionary) {
        var array = conference?.getLocalTracks()
        for track in array as! NSMutableArray {
            let track = track as! JitsiLocalTrack
            if (track.getId() == ((params["trackId"] as! NSString) as String))  {
                conference?.addTrack(track: track)
            }
        }
    }

    func removeTrack(_ params: NSDictionary) {
        for track in conference?.getLocalTracks() as! NSMutableArray{
            let track = track as! JitsiLocalTrack
            if (track.getId() == ((params["trackId"] as! NSString) as String))  {
                conference?.removeTrack(track: track)
            }
        }
    }

    public override func leave() {
        conference?.leave()
    }

    func addEventListeners(_ dictionary: [String: Any]){
        var eventString = dictionary["event"] as! String

        switch(eventString){

        case "CONFERENCE_JOINED":
            conference?.addEventListener(eventString, callback0: {
                print("Conference Joined")
            })
        default:
            print("Event Listener Not Implemented")
        }

    }

}
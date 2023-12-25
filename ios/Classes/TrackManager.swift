//
//  TrackManager.swift
//  sariska_media_flutter_sdk
//
//  Created by Dipak Sisodiya on 24/11/23.
//

import Foundation
import sariska

public class TrackManager : NSObject{
    @objc func mute(_ params: [String: Any]) {
            for track in SariskaMediaTransportFlutterPlugin.localTracks {
                if track.trackId == params["trackId"] as? String {
                    track.mute()
                }
            }
        }

        @objc func unmute(_ params: [String: Any]) {
            for track in SariskaMediaTransportFlutterPlugin.localTracks {
                if track.trackId == params["trackId"] as? String {
                    track.unmute()
                }
            }
        }

        @objc func switchCamera(_ params: [String: Any]) {
            // TODO: Implement check for audio
            for track in SariskaMediaTransportFlutterPlugin.localTracks {
                if track.trackId == params["trackId"] as? String {
                    track.switchCamera()
                }
            }
        }

        @objc func dispose(_ params: [String: Any]) {
            for track in SariskaMediaTransportFlutterPlugin.localTracks {
                if track.trackId == params["trackId"] as? String {
                    track.dispose()
                }
            }
        }

        @objc func destroy(_ params: [String: Any]) {
            for track in SariskaMediaTransportFlutterPlugin.localTracks {
                if track.trackId == params["trackId"] as? String {
                    track.dispose()
                }
            }
        }
    
    @objc func toggleSpeaker(_ params: [String: Any]){
        for track in SariskaMediaTransportFlutterPlugin.localTracks {
            if track.getType() == "audio" {
                track.toggleSpeaker(params["onSpeaker"] as! Bool);
            }
        }
    }
    
}


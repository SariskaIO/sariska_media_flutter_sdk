package io.sariska.sariska_media_flutter_sdk;

import com.facebook.react.bridge.ReactApplicationContext;
import com.zxcpoiu.incallmanager.InCallManagerModule;

import io.sariska.sdk.SariskaMediaTransport;
import io.sariska.sdk.JitsiLocalTrack;
import java.util.Map;
class TrackManager {
    public void mute(Map<String, Object> params) {
        System.out.println("Inside track mute");
        for (JitsiLocalTrack track : SariskaMediaTransportPlugin.localTracks) {
            if (track.getId().equals(params.get("trackId"))) {
                track.mute();
            }
        }
    }

    public void unmute(Map<String, Object> params) {
        for (JitsiLocalTrack track : SariskaMediaTransportPlugin.localTracks) {
            if (track.getId().equals(params.get("trackId"))) {
                track.unmute();
            }
        }
    }

    public void switchCamera(Map<String, Object> params) {
        // TODO: Implement check for audio
        for (JitsiLocalTrack track : SariskaMediaTransportPlugin.localTracks) {
            if (track.getId().equals(params.get("trackId"))) {
                track.switchCamera();
            }
        }
    }

    public void dispose(Map<String, Object> params) {
        for (JitsiLocalTrack track : SariskaMediaTransportPlugin.localTracks) {
            if (track.getId().equals(params.get("trackId"))) {
                track.dispose();
            }
        }
    }

    public void destroy(Map<String, Object> params) {
        for (JitsiLocalTrack track : SariskaMediaTransportPlugin.localTracks) {
            if (track.getId().equals(params.get("trackId"))) {
                track.dispose();
            }
        }
    }

    public void toggleSpeaker(Map<String, Object> onSpeaker){
        for (JitsiLocalTrack track : SariskaMediaTransportPlugin.localTracks) {
            if (track.getType().equals("audio")){
                track.toggleSpeaker((boolean)onSpeaker.get("onSpeaker"));
            }
        }
    }
}

package io.sariska.sariska_media_flutter_sdk;
import android.os.Bundle;
import com.facebook.react.bridge.ReadableMap;
import io.sariska.sdk.Conference;
import io.sariska.sdk.JitsiLocalTrack;
import io.sariska.sdk.JitsiRemoteTrack;
import io.sariska.sdk.Utils;

import java.util.HashMap;
import java.util.Map;

public class ConferenceManager extends Conference {
    private Conference conference;
    private final ConferenceActionEmitter emit;
    public ConferenceManager(ConferenceActionEmitter emit) {
        this.emit = emit;
    }

    public void createConference() {
        System.out.println("Inside create conference");
        conference = new Conference();
    }
    @Override
    public void join() {
        conference.join();
    }

    public void join(Map<String, ?> params) {
        conference.join((String) params.get("password"));
    }

    public void grantOwner(Map<String, ?> params) {
        conference.grantOwner((String) params.get("id"));
    }

    public void setStartMutedPolicy(Map<String, ?> params) {
        conference.setStartMutedPolicy((Bundle) params.get("policy"));
    }

    public void setReceiverVideoConstraint(Map<String, ?> params) {
        conference.setReceiverVideoConstraint((Integer) params.get("number"));
    }

    public void setSenderVideoConstraint(Map<String, ?> params) {
        conference.setSenderVideoConstraint((Integer) params.get("number"));
    }

    public void sendMessage(Map<String, ?> params) {
        String to = (String) params.get("to");
        String message = (String) params.get("message");

        if (to != null && !to.isEmpty()) {
            conference.sendMessage(message, to);
        } else {
            conference.sendMessage(message);
        }
    }

    public void setLastN(Map<String, ?> params) {
        conference.setLastN((Integer) params.get("num"));
    }

    public void dial(Map<String, ?> params) {
        conference.dial((Integer) params.get("number"));
    }

    public void muteParticipant(Map<String, ?> params) {
        String id = (String) params.get("id");
        String mediaType = (String) params.get("mediaType");

        if (mediaType != null && !mediaType.isEmpty()) {
            conference.muteParticipant(id, mediaType);
        } else {
            conference.muteParticipant(id);
        }
    }

    public void setDisplayName(Map<String, ?> params) {
        conference.setDisplayName((String) params.get("displayName"));
    }

    public void addTrack(Map<String, ?> params) {
        for (JitsiLocalTrack track : conference.getLocalTracks()) {
            if (track.getId().equals(params.get("trackId"))) {
                conference.addTrack(track);
            }
        }
    }

    public void removeTrack(Map<String, ?> params) {
        for (JitsiLocalTrack track : conference.getLocalTracks()) {
            if (track.getId().equals(params.get("trackId"))) {
                conference.removeTrack(track);
            }
        }
    }

    public void replaceTrack(Map<String, ?> params) {
        JitsiLocalTrack oldTrack = null;
        JitsiLocalTrack newTrack = null;

        for (JitsiLocalTrack track : conference.getLocalTracks()) {
            if (track.getId().equals(params.get("oldTrackId"))) {
                oldTrack = track;
            }
            if (track.getId().equals(params.get("newTrackId"))) {
                newTrack = track;
            }
        }

        conference.replaceTrack(oldTrack, newTrack);
    }

    public void lock(Map<String, ?> params) {
        conference.lock((String) params.get("password"));
    }

    public void setSubject(Map<String, ?> params) {
        conference.setSubject((String) params.get("subject"));
    }

    @Override
    public void unlock() {
        conference.unlock();
    }

    public void kickParticipant(Map<String, ?> params) {
        conference.kickParticipant((String) params.get("id"));
    }

    public void pinParticipant(Map<String, ?> params) {
        conference.pinParticipant((String) params.get("id"));
    }

    public void selectParticipant(Map<String, ?> params) {
        conference.selectParticipant((String) params.get("id"));
    }

    public void selectParticipants(Map<String, ?> params) {
        conference.selectParticipants((String[]) params.get("participantIds"));
    }

    @Override
    public void startTranscriber() {
        conference.startTranscriber();
    }

    @Override
    public void stopTranscriber() {
        conference.stopTranscriber();
    }

    public void revokeOwner(Map<String, ?> params) {
        conference.revokeOwner((String) params.get("id"));
    }

    public void startRecording(Map<String, ?> params) {
        conference.startRecording((Bundle) params.get("options"));
    }

    public void stopRecording(Map<String, ?> params) {
        conference.stopRecording((String) params.get("sessionID"));
    }

    public void setLocalParticipantProperty(Map<String, ?> params) {
        conference.setLocalParticipantProperty((String) params.get("propertyKey"), (String) params.get("propertyValue"));
    }

    public void removeLocalParticipantProperty(Map<String, ?> params) {
        conference.removeLocalParticipantProperty((String) params.get("name"));
    }

    public void sendFeedback(Map<String, ?> params) {
        conference.sendFeedback((String) params.get("overallFeedback"), (String) params.get("detailedFeedback"));
    }

    @Override
    public void leave() {
        conference.leave();
    }

    public void destroy() {
        conference.leave();
    }

    public void release() {
        conference.leave();
    }

    public void addConferenceListeners(HashMap<String, Object> event) {
        String eventString = (String) event.get("event");
        switch (eventString) {
            case "CONFERENCE_JOINED":
                // Handle conference joined event
                Map<String, Object> map = new HashMap<>();
                System.out.println("USer ID: " + conference.getUserId());
                map.put("userId", conference.getUserId());
                map.put("role", conference.getUserRole());
                map.put("hidden", conference.isHidden());
                map.put("dtmf", conference.isDTMFSupported());
                map.put("name", conference.getUserName());
                map.put("email", conference.getUserEmail());
                map.put("avatar", conference.getUserAvatar());
                conference.addEventListener(eventString, ()->{
                    emit.emit(eventString, map);
            });
                break;
            case "DOMINANT_SPEAKER_CHANGED":
                // Handle dominant speaker changed event
                break;
            case "TRACK_ADDED":
                // Handle track added event
                conference.addEventListener(eventString, (p) -> {
                    System.out.println("Inside ");
                    JitsiRemoteTrack track = (JitsiRemoteTrack) p;
                    Map<String, Object> trackMap = new HashMap<>();
                    trackMap.put("type", ((JitsiRemoteTrack) p).getType());
                    trackMap.put("participantId", ((JitsiRemoteTrack) p).getParticipantId());
                    trackMap.put("id", ((JitsiRemoteTrack) p).getId());
                    trackMap.put("muted",((JitsiRemoteTrack) p).isMuted());
                    trackMap.put("streamURL", ((JitsiRemoteTrack) p).getStreamURL());
                    emit.emit((String) event.get("event"), trackMap);
                });
                break;
            case "TRACK_REMOVED":
                // Handle track removed event
                break;
            case "USER_JOINED":
                // Handle user joined event
                break;
            case "USER_LEFT":
                // Handle user left event
                break;
            case "CONFERENCE_LEFT":
                // Handle conference left event
                break;
            default:
                // Handle unknown event
                break;
        }
    }


    @Override
    public void newConferenceMessage(String action, ReadableMap m) {
        System.out.println("New Conference Message");
        if (action != null) {
            emit.emit(action, m != null ? Utils.toMap(m) : null);
        }
    }
}

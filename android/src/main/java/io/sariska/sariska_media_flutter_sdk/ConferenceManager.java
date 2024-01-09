package io.sariska.sariska_media_flutter_sdk;
import android.os.Bundle;
import com.facebook.react.bridge.ReadableMap;
import io.sariska.sdk.Conference;
import io.sariska.sdk.JitsiLocalTrack;
import io.sariska.sdk.JitsiRemoteTrack;
import io.sariska.sdk.Participant;
import io.sariska.sdk.Utils;
import java.util.HashMap;
import java.util.List;
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
        System.out.println("inside conference join");
        conference.join();
    }

    public void join(Map<String, ?> params) {
        conference.join((String) params.get("password"));
    }

    public void joinLobby(Map<String, ?> params) {
        String displayName = params.get("displayName");
        String email = params.get("email");
        conference.joinLobby(displayName, email);
    }

    public void enableLobby() {
        conference.enableLobby();
    }

    public void disableLobby() {
        conference.disableLobby();
    }

    public void lobbyDenyAccess(Map<String, ?> params){
        conference.lobbyDenyAccess(params.get("participantId"));
    }

    public void lobbyApproveAccess(Map<String, ?> params){
        conference.lobbyApproveAccess(params.get("participantId"));
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

    @Override
    public String getUserRole() {
        return conference.getUserRole();
    }

    @Override
    public String getUserEmail() {
        return conference.getUserEmail();
    }

    @Override
    public String getUserAvatar() {
        return conference.getUserAvatar();
    }

    @Override
    public Boolean isDTMFSupported() {
        return conference.isDTMFSupported();
    }

    @Override
    public String getUserName() {
        return conference.getUserName();
    }

    @Override
    public String getPhoneNumber() {
        return conference.getPhoneNumber();
    }

    @Override
    public String getPhonePin() {
        return conference.getPhonePin();
    }

    @Override
    public Boolean isMembersOnly() {
        return conference.isMembersOnly();
    }

    @Override
    public Boolean isJoined() {
        return conference.isJoined();
    }

    @Override
    public List<JitsiLocalTrack> getLocalTracks() {
        return conference.getLocalTracks();
    }

    @Override
    public List<Participant> getParticipants() {
        return conference.getParticipants();
    }

    @Override
    public List<JitsiRemoteTrack> getRemoteTracks() {
        return conference.getRemoteTracks();
    }

    public void setDisplayName(Map<String, ?> params) {
        conference.setDisplayName((String) params.get("displayName"));
    }

    public void addTrack(Map<String, ?> params) {
        for (JitsiLocalTrack track : SariskaMediaTransportPlugin.localTracks) {
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

    public void addEventListeners(HashMap<String, Object> event) {
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
                conference.addEventListener(eventString, (p) -> {
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
            case "USER_JOINED":
            case "USER_LEFT":
                // Handle user left event
                // Handle user joined event
                conference.addEventListener(eventString, (id, participant) -> {
                    Participant participant1 = (Participant) participant;
                    Map<String, Object> participantMap = new HashMap<>();
                    participantMap.put("id", participant1.getId());
                    participantMap.put("jid", participant1.getId());
                    participantMap.put("avatar", participant1.getId());
                    participantMap.put("email", participant1.getId());
                    participantMap.put("moderator", participant1.getId());
                    participantMap.put("audioMuted", participant1.getId());
                    participantMap.put("videoMuted", participant1.getId());
                    participantMap.put("displayName", participant1.getId());
                    participantMap.put("role", participant1.getId());
                    participantMap.put("status", participant1.getId());
                    participantMap.put("hidden", participant1.getId());
                    participantMap.put("botType", participant1.getId());
                    emit.emit((String) event.get("event"), participantMap);
                });
                break;
            case "CONFERENCE_LEFT":
                // Handle conference left event
                // Do nothing for now
                conference.addEventListener(eventString, ()->{
                   emit.emit((String) event.get("event"), new HashMap<>());
                });
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
            conference.addEventListener(eventString, (id, participant) -> {
                Participant participant1 = (Participant) participant;
                Map<String, Object> participantMap = new HashMap<>();
                participantMap.put("displayName", participant1.getDisplayName());
                participantMap.put("email", participant1.getEmail());
                emit.emit((String) event.get("event"), participantMap);
            });
                break;

            case "LOBBY_USER_UPDATED":
            conference.addEventListener(eventString, (id, participant) -> {
                Participant participant1 = (Participant) participant;
                Map<String, Object> participantMap = new HashMap<>();
                participantMap.put("displayName", participant1.getDisplayName());
                participantMap.put("email", participant1.getEmail());
                emit.emit((String) event.get("event"), participantMap);
            });
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

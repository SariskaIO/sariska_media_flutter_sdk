package io.sariska.sariska_media_flutter_sdk;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import io.sariska.sdk.Conference;
import io.sariska.sdk.Connection;
import io.sariska.sdk.ConnectionBinding;
import io.sariska.sdk.ConnectionCallback;

public class ConnectionManager extends Connection {

    private static final List<ConnectionBinding> bindings = new ArrayList();
    private Connection connection;

    private Conference conference;
    private final ActionEmitter emit;

    private Map<String, Object> connectionParams = new HashMap<>();

    public ConnectionManager(ActionEmitter emit, Map<String, Object> params) {
        super((String) params.get("token"), (String) params.get("roomname"), false);
        this.connectionParams = params;
        this.emit = emit;
    }

    public void createConnection(Map<String, Object> map) {
        connection = new Connection((String) map.get("token"),
                (String)map.get("roomName"), false);
    }

    private void createConference() {

        conference =  connection.initJitsiConference();
        conference.addEventListener("CONFERENCE_JOINED", () -> {
            System.out.println("Conference Joined");
        });
        conference.join();
        System.out.println("Conference Joined passed");
    }

    public void addListener(HashMap<String, Object> event) {
        System.out.println("What is this?");
        System.out.println((String) event.get("event"));
        if(((String) event.get("event")).equals("CONNECTION_ESTABLISHED")){
            connection.addEventListener("CONNECTION_ESTABLISHED", this::createConference);
        }else{
            connection.addEventListener((String) event.get("event"), ()->{
                emit.emit((String) event.get("event"));
            });
        }
    }

    public void destroy() {
        connection.disconnect();
    }

    @Override
    public void connect() {
        System.out.println("Connecting");
        connection.connect();
        System.out.println("Connected");
    }

    @Override
    public void disconnect() {
        connection.disconnect();
    }

    @Override
    public void addFeature() {
        connection.addFeature();
    }

    @Override
    public void removeFeature() {
        connection.removeFeature();
    }

    public void release() {
        connection.disconnect();
    }
}

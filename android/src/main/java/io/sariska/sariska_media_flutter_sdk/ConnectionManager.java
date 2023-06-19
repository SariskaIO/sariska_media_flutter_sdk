package io.sariska.sariska_media_flutter_sdk;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import io.sariska.sdk.Conference;
import io.sariska.sdk.Connection;
import io.sariska.sdk.ConnectionBinding;

public class ConnectionManager extends Connection {

    private static final List<ConnectionBinding> bindings = new ArrayList();
    private Connection connection;
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

    public void addConnectionListeners(HashMap<String, Object> event) {
        System.out.println((String) event.get("event"));
            connection.addEventListener((String) event.get("event"), ()->{
                emit.emit((String) event.get("event"));
            });
    }

    public void destroy() {
        connection.disconnect();
    }

    @Override
    public void connect() {
        connection.connect();
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

    @Override
    public void setToken(String token) {
        connection.setToken(token);
    }

    public void removeConnectionListeners(String event) {
        connection.removeEventListener(event);
    }

    public void release() {
        connection.disconnect();
    }

}

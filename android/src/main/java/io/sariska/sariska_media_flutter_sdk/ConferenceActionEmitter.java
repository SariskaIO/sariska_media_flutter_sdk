package io.sariska.sariska_media_flutter_sdk;

import java.util.Map;

public interface ConferenceActionEmitter {
    void emit(String action, Map<String, Object> m);
}

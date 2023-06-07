package io.sariska.sariska_media_flutter_sdk;

import android.os.Handler;
import android.os.Looper;
import androidx.annotation.NonNull;
import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class ConnectionPlugin implements MethodChannel.MethodCallHandler, EventChannel.StreamHandler {
    private MethodChannel methodChannel;
    private EventChannel eventChannel;
    private EventChannel.EventSink eventSink;
    private Handler handler = new Handler(Looper.getMainLooper());
    private Map<String, Object> map = new HashMap<>();

    private ConnectionManager manager;

    public ConnectionPlugin(BinaryMessenger messenger) {
        methodChannel = new MethodChannel(messenger, "connection");
        methodChannel.setMethodCallHandler(this);
        eventChannel = new EventChannel(messenger, "connectionevent");
        eventChannel.setStreamHandler(this);
        System.out.println("Connection OnAttachedEngine");
    }

    @Override
    public void onListen(Object arguments, EventChannel.EventSink event) {
        eventSink = event;
    }

    @Override
    public void onCancel(Object arguments) {
        eventSink = null;
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        if(manager == null){
            manager = new ConnectionManager(action -> emit(action), map);
        }
        Method[] methods = manager.getClass().getDeclaredMethods();
        for (Method method : methods) {
            if (method.getName().equals(call.method)) {
                try {
                    List<Object> parameters = new ArrayList<>();
                    Map<?, ?> arguments = call.arguments();
                    if (arguments != null) {
                        parameters.add(arguments);
                    }
                    method.invoke(manager, parameters.toArray());
                    return;
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }

    }

    private void emit(String action){
        handler.post(new Runnable() {
            @Override
            public void run() {
                Map<String, Object> event = new HashMap<>();
                event.put("action", action);
                eventSink.success(event);
            }
        });
    }
}

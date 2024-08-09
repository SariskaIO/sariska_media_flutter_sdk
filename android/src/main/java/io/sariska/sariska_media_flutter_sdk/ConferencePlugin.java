package io.sariska.sariska_media_flutter_sdk;

import android.os.Handler;
import android.os.Looper;

import androidx.annotation.NonNull;

import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.sariska.sdk.Conference;

public class ConferencePlugin implements MethodChannel.MethodCallHandler, EventChannel.StreamHandler{

    private MethodChannel methodChannel;
    private EventChannel eventChannel;
    private EventChannel.EventSink eventSink;
    private android.os.Handler handler = new Handler(Looper.getMainLooper());
    private ConferenceManager conferenceManager;
    public ConferencePlugin(BinaryMessenger messenger){
        methodChannel = new MethodChannel(messenger, "conference");
        methodChannel.setMethodCallHandler(this);
        eventChannel = new EventChannel(messenger, "conferencevent");
        eventChannel.setStreamHandler(this);
        System.out.println("Conference OnAttachedEngine");
    }

    @Override
    public void onListen(Object arguments, EventChannel.EventSink events) {
        eventSink = events;
    }

    @Override
    public void onCancel(Object arguments) {

    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
       if(conferenceManager == null){
           conferenceManager = new ConferenceManager(new ConferenceActionEmitter() {
               @Override
               public void emit(String action, Map<String, Object> m) {
                   // Implementation for emitting action and map
                   // You can define your own logic here
                   handler.post(new Runnable() {
                       @Override
                       public void run() {
                           Map<String, Object> event = new HashMap<>();
                           event.put("action", action);
                           event.put("m", m);
                           eventSink.success(event);
                       }
                   });
               }
           });
        }
        Method[] methods = conferenceManager.getClass().getDeclaredMethods();
        for (Method method : methods) {
            if (method.getName().equals(call.method)) {
                try {
                    List<Object> parameters = new ArrayList<>();
                    Map<?, ?> arguments = call.arguments();
                    if (arguments != null) {
                        parameters.add(arguments);
                    }
                    method.invoke(conferenceManager, parameters.toArray());
                    return;
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }
    }
}

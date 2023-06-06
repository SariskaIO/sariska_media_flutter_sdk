package io.sariska.sariska_media_flutter_sdk;

import androidx.annotation.NonNull;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class ConferencePlugin implements MethodChannel.MethodCallHandler, EventChannel.StreamHandler{

    private MethodChannel methodChannel;
    private EventChannel eventChannel;

    public ConferencePlugin(BinaryMessenger messenger){
        methodChannel = new MethodChannel(messenger, "conference");
        methodChannel.setMethodCallHandler(this);
        eventChannel = new EventChannel(messenger, "conference_events");
        eventChannel.setStreamHandler(this);
        System.out.println("Conference OnAttachedEngine");
    }

    @Override
    public void onListen(Object arguments, EventChannel.EventSink events) {

    }

    @Override
    public void onCancel(Object arguments) {

    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        if(call.method.equals("conference test method")){
            System.out.println("Test method in Conference verified");
        }
    }
}

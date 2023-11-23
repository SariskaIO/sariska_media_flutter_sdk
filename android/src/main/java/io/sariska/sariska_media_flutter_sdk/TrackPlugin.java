package io.sariska.sariska_media_flutter_sdk;

import androidx.annotation.NonNull;

import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class TrackPlugin implements MethodChannel.MethodCallHandler, EventChannel.StreamHandler {
    private MethodChannel methodChannel;
    private TrackManager manager = new TrackManager();

    public  TrackPlugin(BinaryMessenger messenger){
        methodChannel = new MethodChannel(messenger, "track");
        methodChannel.setMethodCallHandler(this);
    }


    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        Method[] methods = manager.getClass().getDeclaredMethods();
        System.out.println("Calling track methods");
        System.out.println(call.method);
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
        result.notImplemented();
    }

    @Override
    public void onListen(Object arguments, EventChannel.EventSink events) {

    }

    @Override
    public void onCancel(Object arguments) {

    }
}

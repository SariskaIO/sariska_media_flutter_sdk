package io.sariska.sariska_media_flutter_sdk;

import androidx.annotation.NonNull;

import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class TrackPlugin implements FlutterPlugin, MethodChannel.MethodCallHandler {
    private MethodChannel methodChannel;
    private TrackManager manager = new TrackManager();

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
        methodChannel = new MethodChannel(binding.getBinaryMessenger(), "track");
        methodChannel.setMethodCallHandler(this);
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        methodChannel.setMethodCallHandler(null);
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
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
        result.notImplemented();
    }
}

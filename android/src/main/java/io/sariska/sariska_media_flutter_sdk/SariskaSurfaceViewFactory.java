package io.sariska.sariska_media_flutter_sdk;

import android.content.Context;
import android.os.Build;
import android.view.View;

import androidx.annotation.RequiresApi;

import com.oney.WebRTCModule.WebRTCView;

import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;
import io.sariska.sdk.SariskaMediaTransport;

public class SariskaSurfaceViewFactory extends PlatformViewFactory {
    private final BinaryMessenger messenger;

    public SariskaSurfaceViewFactory(BinaryMessenger messenger) {
        super(StandardMessageCodec.INSTANCE);
        this.messenger = messenger;
    }

    @Override
    public PlatformView create(Context context, int viewId, Object args) {
        return new SariskaSurfaceView(context.getApplicationContext(), messenger, viewId, (Map<?, ?>) args);
    }
}

class SariskaSurfaceView implements PlatformView, MethodChannel.MethodCallHandler {
    private final WebRTCView view;
    private final MethodChannel channel;

    SariskaSurfaceView(Context context, BinaryMessenger messenger, int viewId, Map<?, ?> args) {
        view = new WebRTCView(SariskaMediaTransport.getReactContext());
        channel = new MethodChannel(messenger, "sariska_media_transport_surface_view_" + viewId);

        if (args != null) {
            String streamURL = (String) args.get("streamURL");
            if (streamURL != null) {
                setStreamURL(streamURL);
            }

            String objectFit = (String) args.get("objectFit");
            if (objectFit != null) {
                setObjectFit(objectFit);
            }

            Boolean mirror = (Boolean) args.get("mirror");
            if (mirror != null) {
                setMirror(mirror);
            }

            Integer zOrder = (Integer) args.get("zOrder");
            if (zOrder != null) {
                setZOrder(zOrder);
            }
        }

        channel.setMethodCallHandler(this);
    }

    @Override
    public View getView() {
        return view;
    }

    @Override
    public void dispose() {
        channel.setMethodCallHandler(null);
    }

    @RequiresApi(api = Build.VERSION_CODES.O)
    @Override
    public void onMethodCall(MethodCall call, MethodChannel.Result result) {
        for (Method method : getClass().getDeclaredMethods()) {
            if (method.getName().equals(call.method)) {
                List<Object> parameters = new ArrayList<>();
                Map<?, ?> map = call.arguments();
                if (map != null) {
                    for (Class<?> parameterType : method.getParameterTypes()) {
                        if (map.containsKey(parameterType.getSimpleName())) {
                            parameters.add(map.get(parameterType.getSimpleName()));
                        }
                    }
                }
                try {
                    method.invoke(this, parameters.toArray());
                    return;
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }

        result.notImplemented();
    }

    private void setStreamURL(String streamURL) {
        System.out.println("Inside setStreamURL");
        view.setStreamURL(streamURL);
    }

    private void setObjectFit(String objectFit) {
        view.setObjectFit(objectFit);
    }

    private void setMirror(boolean mirror) {
        view.setMirror(mirror);
    }

    private void setZOrder(int onTop) {
        view.setZOrder(onTop);
    }
}

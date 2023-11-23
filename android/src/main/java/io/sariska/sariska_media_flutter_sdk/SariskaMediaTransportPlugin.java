package io.sariska.sariska_media_flutter_sdk;

import android.app.Application;
import android.content.Context;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;

import androidx.annotation.NonNull;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;
import io.sariska.sdk.JitsiLocalTrack;
import io.sariska.sdk.SariskaMediaTransport;
import io.flutter.plugin.platform.PlatformViewRegistry;
/** SariskaMediaTransportPlugin */
public class SariskaMediaTransportPlugin implements FlutterPlugin, MethodCallHandler , EventChannel.StreamHandler{
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel methodChannel;
  private EventChannel eventChannel;
  private EventChannel.EventSink eventSink;

  public static List<JitsiLocalTrack> localTracks = new ArrayList<JitsiLocalTrack>();
  private Context applicationContext;
  private ConnectionPlugin connectionPlugin;
  private ConferencePlugin conferencePlugin;

  private TrackPlugin trackPlugin;
  private Handler handler = new Handler(Looper.getMainLooper());;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    methodChannel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "sariska_media_transport_flutter");
    eventChannel = new EventChannel(flutterPluginBinding.getBinaryMessenger(), "sariskaMediaTransportEvent");
    eventChannel.setStreamHandler(this);
    methodChannel.setMethodCallHandler(this);
    applicationContext = flutterPluginBinding.getApplicationContext();
    connectionPlugin = new ConnectionPlugin(flutterPluginBinding.getBinaryMessenger());
    conferencePlugin = new ConferencePlugin(flutterPluginBinding.getBinaryMessenger());
    trackPlugin = new TrackPlugin(flutterPluginBinding.getBinaryMessenger());

    FlutterEngine flutterEngine = flutterPluginBinding.getFlutterEngine();
    PlatformViewRegistry registry = flutterEngine.getPlatformViewsController().getRegistry();
    registry.registerViewFactory(
            "SariskaSurfaceView",
            new SariskaSurfaceViewFactory(flutterPluginBinding.getBinaryMessenger())
    );
  }


  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if(call.method.equals("initializeSdk")){
      initializeSariskaMediaTransport();
    }
    if(call.method.equals("createLocalTracks")){
      Map<String, Object> arguments = call.arguments();
      createLocalTracks(arguments);
    }
    if (call.method.equals("getPlatformVersion")) {
      result.success("Android " + android.os.Build.VERSION.RELEASE);
    } else {
      result.notImplemented();
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    methodChannel.setMethodCallHandler(null);
  }

  private void initializeSariskaMediaTransport(){
    SariskaMediaTransport.initializeSdk((Application) applicationContext);
  }

  private void createLocalTracks(Map<String, Object> options){
    Bundle bundle = new Bundle();
    bundle.putBoolean("audio", (Boolean) options.get("audio"));
    bundle.putBoolean("video", (Boolean) options.get("video"));
    SariskaMediaTransport.createLocalTracks(bundle, tracks ->{
      System.out.println("When native side CT work");
      localTracks = tracks;
      List<Map<String , Object>> localTracks = new ArrayList<>();
      for (JitsiLocalTrack track : tracks){
        Map<String , Object> map = new HashMap<>();
        map.put("type", track.getType());
        map.put("participantId", track.getParticipantId());
        map.put("deviceId", track.getDeviceId());
        map.put("muted", track.isMuted());
        map.put("streamURL", track.getStreamURL());
        map.put("id", track.getId());
        localTracks.add(map);
      }
      emit("CREATE_LOCAL_TRACKS", localTracks);
    });
  }

  private void emit(String action, List<Map<String , Object>> localTracks){
    handler.post(new Runnable() {
      @Override
      public void run() {
        Map<String, Object> event = new HashMap<>();
        event.put("action", action);
        event.put("m", localTracks);
        eventSink.success(event);
      }
    });
  }

  @Override
  public void onListen(Object arguments, EventChannel.EventSink events) {
    eventSink = events;
  }

  @Override
  public void onCancel(Object arguments) {
    eventSink = null;
  }
}
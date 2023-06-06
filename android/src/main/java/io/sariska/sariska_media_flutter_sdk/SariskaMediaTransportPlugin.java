package io.sariska.sariska_media_flutter_sdk;

import android.app.Application;
import android.content.Context;
import android.os.Bundle;

import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.sariska.sdk.SariskaMediaTransport;

/** SariskaMediaTransportPlugin */
public class SariskaMediaTransportPlugin implements FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;

  private Context applicationContext;
  private ConnectionPlugin connectionPlugin;
  private ConferencePlugin conferencePlugin;
  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "sariska_media_flutter_sdk");
    channel.setMethodCallHandler(this);
    applicationContext = flutterPluginBinding.getApplicationContext();
    connectionPlugin = new ConnectionPlugin(flutterPluginBinding.getBinaryMessenger());
    conferencePlugin = new ConferencePlugin(flutterPluginBinding.getBinaryMessenger());
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {

    if(call.method.equals("initializeSdk")){
      initializeSariskaMediaTransport();
    }

    if (call.method.equals("getPlatformVersion")) {
      result.success("Android " + android.os.Build.VERSION.RELEASE);
    } else {
      result.notImplemented();
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }

  private void initializeSariskaMediaTransport(){
    SariskaMediaTransport.initializeSdk((Application) applicationContext);
  }

  private void createLocalTracks(Bundle options){
    SariskaMediaTransport.createLocalTracks(options, tracks ->{
      System.out.println("inside create local tracks");
    });
  }
}

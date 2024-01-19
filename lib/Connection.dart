import 'dart:async';
import 'package:flutter/services.dart';
import 'Conference.dart';

typedef ConnectionCallback = void Function();

/// A binding between a connection event and its callback.
class ConnectionBinding<T> {
  /// The name of the connection event.
  String event;

  /// The callback function associated with the connection event.
  T callback;

  /// Constructs a [ConnectionBinding] object.
  ///
  /// The [event] parameter is the name of the connection event.
  /// The [callback] parameter is the callback function to be executed when the event occurs.
  ConnectionBinding(this.event, T this.callback) {
    this.event = event;
    this.callback = callback;
  }

  /// Retrieves the name of the connection event.
  ///
  /// Returns the event name as a string.
  String getEvent() {
    return this.event;
  }

  /// Retrieves the callback function associated with the connection event.
  ///
  /// Returns the callback function.
  T getCallback() {
    return this.callback;
  }
}

/// Represents a connection to a conference.
class Connection {
  static List<ConnectionBinding> _bindings = [];
  static const MethodChannel _methodChannel = MethodChannel('connection');
  static const EventChannel _eventChannel = EventChannel('connectionevent');

  /// Constructs a [Connection] object with the specified parameters.
  ///
  /// The [token] parameter is the token for authentication.
  /// The [roomName] parameter is the name of the conference room.
  /// The [isNightly] parameter indicates whether the connection is for a nightly build.
  Connection(String token, String roomName, bool isNightly) {
    _invokeMethod('createConnection',
        {'token': token, 'roomName': roomName, 'isNightly': isNightly});

    _eventChannel.receiveBroadcastStream().listen((event) {
      print('Received Broadcast Stream');
      final eventMap = Map<String, dynamic>.from(event);
      final action = eventMap['action'] as String;
      for (var i = 0; i < _bindings.length; i++) {
        if (_bindings[i].getEvent() == action) {
          switch (action) {
            case "CONNECTION_ESTABLISHED":
            case "CONNECTION_FAILED":
            case "CONNECTION_DISCONNECTED":
              _bindings[i].getCallback()();
          }
        }
      }
    });
  }

  static Future<T?> _invokeMethod<T>(String method,
      [Map<String, dynamic>? arguments]) {
    return _methodChannel.invokeMethod(method, arguments);
  }

  /// Initializes a Jitsi conference.
  ///
  /// Returns a new instance of [Conference].
  Conference initJitsiConference() {
    return Conference();
  }

  /// Connects to the conference.
  void connect() {
    _invokeMethod('connect');
  }

  /// Disconnects from the conference.
  void disconnect() {
    _invokeMethod('disconnect');
  }

  /// Adds a feature to the conference.
  void addFeature() {
    _invokeMethod('addFeature');
  }

  /// Removes a feature from the conference.
  void removeFeature() {
    _invokeMethod('removeFeature');
  }

  /// Adds an event listener to the connection.
  ///
  /// The [event] parameter is the name of the event to listen for.
  /// The [callback] parameter is the callback function to be executed when the event occurs.
  void addEventListener(String event, ConnectionCallback callback) {
    _bindings.add(ConnectionBinding(event, callback));
    Map<String, dynamic> arguments = {
      'event': event,
    };
    _invokeMethod('addConnectionListeners', arguments);
  }

  /// Removes an event listener from the connection.
  ///
  /// The [event] parameter is the name of the event to remove.
  void removeEventListener(String event) {
    _bindings = _bindings.where((binding) => binding.event != event).toList();
    _invokeMethod('removeConnectionListeners');
  }

  /// Retrieves the name of the connection.
  ///
  /// Returns the name as a string.
  String getName() {
    return "Connection";
  }

  /// Sets the authentication token for the connection.
  ///
  /// The [token] parameter is the new authentication token.
  void setToken(String token) {
    _invokeMethod('setToken');
  }
}

import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

class SocketController {
  static final SocketController _instance = SocketController._internal();
  late WebSocketChannel _channel;
  bool _isConnected = false;
  String? _userId;
  String? _token;
  Timer? _reconnectTimer;
  int _reconnectAttempts = 0;
  final int _maxReconnectAttempts = 10;
  final Duration _reconnectDelay = Duration(seconds: 1); // Reconnect delay

  final List<Function(dynamic message)> _messageListeners = [];
  final List<Function()> _disconnectListeners = [];
  final List<Function()> _errorListeners = [];

  SocketController._internal();

  // Singleton instance getter
  factory SocketController() {
    return _instance;
  }

  // Initialize the WebSocket connection if not already connected
  void initialize({
    required String userId,
    required String token,
  }) {
    _userId = userId;
    _token = token;

    if (!_isConnected) {
      _connectToSignalingServer();
    }
  }

  // Connect to the WebSocket signaling server
  void _connectToSignalingServer() {
    if (_userId == null || _token == null) {
      throw Exception("User ID and token must be provided.");
    }

    _channel = WebSocketChannel.connect(
      Uri.parse('wss://naham.tadafuq.ae?user_id=$_userId&token=$_token'),
    );

    _channel.stream.listen(
      _handleSocketMessage,
      onDone: _handleWebSocketDisconnection,
      onError: _handleWebSocketError,
    );

    _isConnected = true;
    _reconnectAttempts = 0; // Reset attempts after successful connection
  }

  // Broadcast received message to all registered listeners
  void _handleSocketMessage(dynamic message) {
    for (var listener in _messageListeners) {
      listener.call(message);
    }
  }

  // Notify listeners about disconnection and attempt to reconnect
  void _handleWebSocketDisconnection() {
    _isConnected = false;

    Fluttertoast.showToast(
      msg: "WebSocket disconnected! Reconnecting...",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );

    for (var listener in _disconnectListeners) {
      listener.call();
    }

    _attemptReconnection();
  }

  // Notify listeners about errors and attempt to reconnect
  void _handleWebSocketError(error) {
    print("WebSocket error: $error");

    _isConnected = false;

    for (var listener in _errorListeners) {
      listener.call();
    }

    _attemptReconnection();
  }

  // Attempt to reconnect to the WebSocket server
  void _attemptReconnection() {
    if (_reconnectAttempts < _maxReconnectAttempts) {
      _reconnectAttempts++;
      _reconnectTimer = Timer(_reconnectDelay, () {
        Fluttertoast.showToast(
          msg: "Reconnecting... Attempt $_reconnectAttempts",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.orange,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        _connectToSignalingServer();
      });
    } else {
      Fluttertoast.showToast(
        msg: "Failed to reconnect after $_maxReconnectAttempts attempts.",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  // Register listeners for each controller
  void addMessageListener(Function(dynamic message) listener) {
    _messageListeners.add(listener);
  }

  void addDisconnectListener(Function() listener) {
    _disconnectListeners.add(listener);
  }

  void addErrorListener(Function() listener) {
    _errorListeners.add(listener);
  }

  // Remove listeners when they are no longer needed
  void removeMessageListener(Function(dynamic message) listener) {
    _messageListeners.remove(listener);
  }

  void removeDisconnectListener(Function() listener) {
    _disconnectListeners.remove(listener);
  }

  void removeErrorListener(Function() listener) {
    _errorListeners.remove(listener);
  }

  // Send a message to the server
  void sendToServer(Map<String, dynamic> message) {
    if (_isConnected) {
      _channel.sink.add(jsonEncode(message));
    } else {
      print("WebSocket is not connected.");
    }
  }

  // Close the WebSocket connection
  void closeConnection() {
    if (_isConnected) {
      _channel.sink.close();
      _isConnected = false;
      _reconnectTimer?.cancel(); // Cancel any ongoing reconnect attempts
    }
  }
}

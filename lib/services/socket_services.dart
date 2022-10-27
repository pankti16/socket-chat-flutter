import 'package:socket_chat/config.dart';
import 'package:socket_chat/utils/debugLogs.dart';
import 'package:socket_io_client/socket_io_client.dart';

class SocketService {
  // A static private instance to access _socketService from inside class only
  static final SocketService _socketService = SocketService._internal();
  final Socket _socket = io(
    kSocketUrl,
    OptionBuilder().setTransports(['websocket']) // for Flutter or Dart
        .build(),
  );

  // An internal private constructor to access it for only once for static instance of class.
  SocketService._internal();

  // Factory constructor to return same static instance every-time you create any object.
  factory SocketService() {
    return _socketService;
  }

  // All socket related functions.
  initSocket() {
    try {
      debugLogs('init');
      _socket.connect();
      debugLogs('connect');
      _socket.onConnect((data) {
        debugLogs('socket connected $data');
      });
      _socket.onDisconnect((data) {
        debugLogs('socket disconnected $data');
      });
      _socket.onError((data) {
        debugLogs('socket error $data');
      });
    } catch (e) {
      debugLogs('socket is not initialized $e');
    }
  }

  emit(event, data) {
    try {
      _socket.emit(event, data);
    } catch (e) {
      debugLogs('socket emit error $e');
    }
  }

  on(event, cb) {
    try {
      _socket.on(event, cb);
    } catch (e) {
      debugLogs('socket on error $e');
    }
  }

  clearListeners(event, cb) {
    try {
      _socket.clearListeners();
    } catch (e) {
      debugLogs('socket on error $e');
    }
  }
}

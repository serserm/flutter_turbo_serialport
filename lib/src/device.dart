import 'dart:typed_data';

import 'serialport_controller.dart';
import 'turbo_serialport.g.dart';

class Device extends SerialportDevice {
  void connect() {
    SerialportController().connect(
      deviceId: deviceId,
    );
  }

  void disconnect() {
    SerialportController().disconnect(
      deviceId: deviceId,
    );
  }

  Future<bool> isConnected() {
    return SerialportController().isConnected(
      deviceId: deviceId,
    );
  }

  void writeBytes({
    required Uint8List message,
    int? portInterface,
  }) {
    SerialportController().writeBytes(
      message: message,
      deviceId: deviceId,
      portInterface: portInterface,
    );
  }

  void writeString({
    required String message,
    int? portInterface,
  }) {
    SerialportController().writeString(
      message: message,
      deviceId: deviceId,
      portInterface: portInterface,
    );
  }

  void writeBase64({
    required String message,
    int? portInterface,
  }) {
    SerialportController().writeBase64(
      message: message,
      deviceId: deviceId,
      portInterface: portInterface,
    );
  }

  void writeHexString({
    required String message,
    int? portInterface,
  }) {
    SerialportController().writeHexString(
      message: message,
      deviceId: deviceId,
      portInterface: portInterface,
    );
  }
}

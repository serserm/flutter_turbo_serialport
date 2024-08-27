import 'dart:async';
import 'dart:typed_data';

import 'device.dart';
import 'event_listener.dart';
import 'turbo_serialport.g.dart';
import 'types/types.dart';

class SerialportController extends TurboSerialportListener {
  SerialportController._();

  static SerialportController? _instance;

  factory SerialportController() {
    if (_instance == null) {
      _instance = SerialportController._();
      TurboSerialportListener.setUp(_instance);
    }
    return _instance!;
  }

  final TurboSerialport _api = TurboSerialport();
  final EventListener _listener = EventListener();

  @override
  void serialportEvent(SerialportEvent event) {
    try {
      _listener.call(event);
    } catch (err) {
      rethrow;
    }
  }

  void init({
    bool? autoConnect,
    Mode? mode,
    Params? params,
  }) {
    _api.init(
      autoConnect ?? false,
      mode?.value ?? Mode.$async.value,
      params?.driver?.value ?? DriverType.$auto.value,
      params?.portInterface ?? -1,
      params?.returnedDataType?.value ?? ReturnedDataType.$utf8.value,
      params?.baudRate?.value ?? BaudRate.$9600.value,
      params?.dataBit?.value ?? DataBit.$8.value,
      params?.stopBit?.value ?? StopBit.$1.value,
      params?.parity?.value ?? Parity.$none.value,
      params?.flowControl?.value ?? FlowControl.$off.value,
    );
  }

  Function addListeners({
    OnReadData? onReadData,
    OnError? onError,
    OnConnected? onConnected,
    OnDisconnected? onDisconnected,
    OnDeviceAttached? onDeviceAttached,
    OnDeviceDetached? onDeviceDetached,
  }) {
    if (_listener.add(
      onReadData: onReadData,
      onError: onError,
      onConnected: onConnected,
      onDisconnected: onDisconnected,
      onDeviceAttached: onDeviceAttached,
      onDeviceDetached: onDeviceDetached,
    )) {
      _api.addListener();
    }

    return () {
      if (_listener.remove(
        onReadData: onReadData,
        onError: onError,
        onConnected: onConnected,
        onDisconnected: onDisconnected,
        onDeviceAttached: onDeviceAttached,
        onDeviceDetached: onDeviceDetached,
      )) {
        _api.removeListener();
      }
    };
  }

  void setParams({Params? params, int? deviceId}) {
    _api.setParams(
      deviceId ?? -1,
      params?.driver?.value ?? DriverType.$auto.value,
      params?.portInterface ?? -1,
      params?.returnedDataType?.value ?? ReturnedDataType.$utf8.value,
      params?.baudRate?.value ?? BaudRate.$9600.value,
      params?.dataBit?.value ?? DataBit.$8.value,
      params?.stopBit?.value ?? StopBit.$1.value,
      params?.parity?.value ?? Parity.$none.value,
      params?.flowControl?.value ?? FlowControl.$off.value,
    );
  }

  Future<List<Device>> listDevices() async {
    List<SerialportDevice?> res = await _api.listDevices();
    return res.cast<Device>();
  }

  void connect({int? deviceId}) {
    _api.connect(deviceId ?? -1);
  }

  void disconnect({int? deviceId}) {
    _api.disconnect(deviceId ?? -1);
  }

  Future<bool> isConnected({int? deviceId}) {
    return _api.isConnected(deviceId ?? -1);
  }

  Future<bool> isServiceStarted() {
    return _api.isServiceStarted();
  }

  void writeBytes({
    required Uint8List message,
    int? deviceId,
    int? portInterface,
  }) {
    _api.writeBytes(
      deviceId ?? -1,
      portInterface ?? 0,
      message,
    );
  }

  void writeString({
    required String message,
    int? deviceId,
    int? portInterface,
  }) {
    _api.writeString(
      deviceId ?? -1,
      portInterface ?? 0,
      message,
    );
  }

  void writeBase64({
    required String message,
    int? deviceId,
    int? portInterface,
  }) {
    _api.writeBase64(
      deviceId ?? -1,
      portInterface ?? 0,
      message,
    );
  }

  void writeHexString({
    required String message,
    int? deviceId,
    int? portInterface,
  }) {
    _api.writeHexString(
      deviceId ?? -1,
      portInterface ?? 0,
      message,
    );
  }
}

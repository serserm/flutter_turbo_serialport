import 'dart:async';
import 'dart:typed_data';

import 'device.dart';
import 'event_listener.dart';
import 'turbo_serialport.g.dart';
import 'types/types.dart';

/// ## Example
/// ```dart
/// class _HomePageState extends State<HomePage> {
///   final _instance = SerialportController();
/// }
/// ```
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

  /// ## Example
  /// ```dart
  /// SerialportController().init(
  ///   autoConnect: false,
  ///   mode: Mode.$async,
  ///   params: Params(
  ///     driver: DriverType.$auto,
  ///     portInterface: -1, // all ports
  ///     returnedDataType: ReturnedDataType.$utf8,
  ///     baudRate: BaudRate.$9600,
  ///     dataBit: DataBit.$8,
  ///     stopBit: StopBit.$1,
  ///     parity: Parity.$none,
  ///     flowControl: FlowControl.$off,
  ///   ),
  /// );
  /// ```
  void init({
    bool? autoConnect,
    Mode? mode,
    Params? params,
  }) {
    _api.init(
      autoConnect ?? false,
      mode?.value ?? Mode.getDefault.value,
      params?.driver?.value ?? DriverType.getDefault.value,
      params?.portInterface ?? -1,
      params?.returnedDataType?.value ?? ReturnedDataType.getDefault.value,
      params?.baudRate?.value ?? BaudRate.getDefault.value,
      params?.dataBit?.value ?? DataBit.getDefault.value,
      params?.stopBit?.value ?? StopBit.getDefault.value,
      params?.parity?.value ?? Parity.getDefault.value,
      params?.flowControl?.value ?? FlowControl.getDefault.value,
    );
  }

  /// ## Example
  /// ```dart
  /// _subscribe = SerialportController().addListeners(
  ///   onReadData: onReadData,
  ///   onError: onError,
  ///   onConnected: onConnected,
  ///   onDisconnected: onDisconnected,
  ///   onDeviceAttached: onSearch,
  ///   onDeviceDetached: onSearch,
  /// );
  /// ```
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

  /// ## Example
  /// ```dart
  /// SerialportController().setParams(
  ///   deviceId: deviceId,
  ///   params: Params(
  ///     driver: DriverType.$auto,
  ///     portInterface: -1, // all ports
  ///     returnedDataType: ReturnedDataType.$utf8,
  ///     baudRate: BaudRate.$9600,
  ///     dataBit: DataBit.$8,
  ///     stopBit: StopBit.$1,
  ///     parity: Parity.$none,
  ///     flowControl: FlowControl.$off,
  ///   ),
  /// );
  /// ```
  void setParams({Params? params, int? deviceId}) {
    _api.setParams(
      deviceId ?? -1,
      params?.driver?.value ?? DriverType.getDefault.value,
      params?.portInterface ?? -1,
      params?.returnedDataType?.value ?? ReturnedDataType.getDefault.value,
      params?.baudRate?.value ?? BaudRate.getDefault.value,
      params?.dataBit?.value ?? DataBit.getDefault.value,
      params?.stopBit?.value ?? StopBit.getDefault.value,
      params?.parity?.value ?? Parity.getDefault.value,
      params?.flowControl?.value ?? FlowControl.getDefault.value,
    );
  }

  /// ## Example
  /// ```dart
  /// SerialportController().listDevices().then((List<Device> res) {
  ///   // TODO
  /// });
  /// ```
  Future<List<Device>> listDevices() async {
    List<SerialportDevice?> res = await _api.listDevices();
    return res.whereType<SerialportDevice>().map(Device.from).toList();
  }

  /// ## Example
  /// ```dart
  /// SerialportController().connect(
  ///   deviceId: deviceId,
  /// );
  /// ```
  void connect({int? deviceId}) {
    _api.connect(deviceId ?? -1);
  }

  /// ## Example
  /// ```dart
  /// SerialportController().disconnect(
  ///   deviceId: deviceId,
  /// );
  /// ```
  void disconnect({int? deviceId}) {
    _api.disconnect(deviceId ?? -1);
  }

  /// ## Example
  /// ```dart
  /// SerialportController().isConnected(
  ///   deviceId: deviceId,
  /// ).then((bool res) {
  ///   // TODO
  /// });
  /// ```
  Future<bool> isConnected({int? deviceId}) {
    return _api.isConnected(deviceId ?? -1);
  }

  /// ## Example
  /// ```dart
  /// SerialportController().isServiceStarted().then((bool res) {
  ///   // TODO
  /// });
  /// ```
  Future<bool> isServiceStarted() {
    return _api.isServiceStarted();
  }

  /// ## Example
  /// ```dart
  /// SerialportController().writeBytes(
  ///   message: message,
  ///   deviceId: deviceId,
  ///   portInterface: portInterface,
  /// );
  /// ```
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

  /// ## Example
  /// ```dart
  /// SerialportController().writeString(
  ///   message: message,
  ///   deviceId: deviceId,
  ///   portInterface: portInterface,
  /// );
  /// ```
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

  /// ## Example
  /// ```dart
  /// SerialportController().writeBase64(
  ///   message: message,
  ///   deviceId: deviceId,
  ///   portInterface: portInterface,
  /// );
  /// ```
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

  /// ## Example
  /// ```dart
  /// SerialportController().writeHexString(
  ///   message: message,
  ///   deviceId: deviceId,
  ///   portInterface: portInterface,
  /// );
  /// ```
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

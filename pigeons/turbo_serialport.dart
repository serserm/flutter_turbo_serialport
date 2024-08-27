import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(PigeonOptions(
  dartOut: 'lib/src/turbo_serialport.g.dart',
  javaOut: 'android/src/main/java/com/serserm/turboserialport/PigeonSpec.java',
  javaOptions: JavaOptions(
    className: 'PigeonSpec',
    package: 'com.serserm.turboserialport',
  ),
  dartPackageName: 'flutter_turbo_serialport',
))
@HostApi()
abstract class TurboSerialport {
  /// native api: addListener
  void addListener();

  /// native api: removeListener
  void removeListener();

  /// native api: init
  void init(
    bool autoConnect,
    int mode,
    String driver,
    int portInterface,
    int returnedDataType,
    int baudRate,
    int dataBit,
    int stopBit,
    int parity,
    int flowControl,
  );

  /// native api: setParams
  void setParams(
    int deviceId,
    String driver,
    int portInterface,
    int returnedDataType,
    int baudRate,
    int dataBit,
    int stopBit,
    int parity,
    int flowControl,
  );

  @async

  /// native api: listDevices
  List<SerialportDevice> listDevices();

  /// native api: connect
  void connect(int deviceId);

  /// native api: disconnect
  void disconnect(int deviceId);

  @async

  /// native api: isConnected
  bool isConnected(int deviceId);

  @async

  /// native api: isServiceStarted
  bool isServiceStarted();

  /// native api: writeBytes
  void writeBytes(int deviceId, int portInterface, Uint8List message);

  /// native api: writeString
  void writeString(int deviceId, int portInterface, String message);

  /// native api: writeBase64
  void writeBase64(int deviceId, int portInterface, String message);

  /// native api: writeHexString
  void writeHexString(int deviceId, int portInterface, String message);
}

@FlutterApi()
abstract class TurboSerialportListener {
  /// native api: serialportEvent
  void serialportEvent(SerialportEvent event);
}

/// native api: SerialportEvent
class SerialportEvent {
  String? type;
  int? deviceId;
  int? portInterface;
  int? errorCode;
  String? errorMessage;
  String? dataString;
  Uint8List? dataList;
}

/// native api: SerialportDevice
class SerialportDevice {
  bool? isSupported;
  int? deviceId;
  String? deviceName;
  int? deviceClass;
  int? deviceSubclass;
  int? deviceProtocol;
  int? vendorId;
  int? productId;
  String? manufacturerName;
  String? productName;
  String? serialNumber;
  int? interfaceCount;
}

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
  void addListener();

  void removeListener();

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
  List<SerialportDevice> listDevices();

  void connect(int deviceId);

  void disconnect(int deviceId);

  @async
  bool isConnected(int deviceId);

  @async
  bool isServiceStarted();

  void writeBytes(int deviceId, int portInterface, Uint8List message);

  void writeString(int deviceId, int portInterface, String message);

  void writeBase64(int deviceId, int portInterface, String message);

  void writeHexString(int deviceId, int portInterface, String message);
}

@FlutterApi()
abstract class TurboSerialportListener {
  void serialportEvent(SerialportEvent event);
}

class SerialportEvent {
  String? type;
  int? deviceId;
  int? portInterface;
  int? errorCode;
  String? errorMessage;
  String? dataString;
  Uint8List? dataList;
}

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

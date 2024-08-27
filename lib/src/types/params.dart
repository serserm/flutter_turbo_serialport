/// usb param: driver
enum DriverType {
  $auto('AUTO'),
  $cdc('cdc'),
  $ch34x('ch34x'),
  $cp210x('cp210x'),
  $ftdi('ftdi'),
  $pl2303('pl2303');

  final String value;
  const DriverType(this.value);
  static DriverType getDefault = $auto;
}

/// usb param: baudRate
enum BaudRate {
  $300(300),
  $600(600),
  $1200(1200),
  $2400(2400),
  $4800(4800),
  $9600(9600),
  $19200(19200),
  $38400(38400),
  $57600(57600),
  $115200(115200),
  $230400(230400),
  $460800(460800),
  $921600(921600);

  final int value;
  const BaudRate(this.value);
  static BaudRate getDefault = $9600;
}

/// usb param: dataBit
enum DataBit {
  $5(5),
  $6(6),
  $7(7),
  $8(8);

  final int value;
  const DataBit(this.value);
  static DataBit getDefault = $8;
}

/// usb param: stopBit
enum StopBit {
  $1(1),
  $2(2),
  $15(3);

  final int value;
  const StopBit(this.value);
  static StopBit getDefault = $1;
}

/// usb param: parity
enum Parity {
  $none(0),
  $odd(1),
  $even(2),
  $mark(3),
  $space(4);

  final int value;
  const Parity(this.value);
  static Parity getDefault = $none;
}

/// usb param: flowControl
enum FlowControl {
  $off(0),
  $rtsCts(1),
  $dsrDtr(2),
  $xOnxOff(3);

  final int value;
  const FlowControl(this.value);
  static FlowControl getDefault = $off;
}

/// usb param: returnedDataType
enum ReturnedDataType {
  $intArray(1),
  $hexString(2),
  $utf8(3);

  final int value;
  const ReturnedDataType(this.value);
  static ReturnedDataType getDefault = $utf8;
}

/// serialport mode
enum Mode {
  $async(0),
  $sync(1);

  final int value;
  const Mode(this.value);
  static Mode getDefault = $async;
}

/// usb params
class Params {
  Params({
    this.driver,
    this.portInterface,
    this.baudRate,
    this.dataBit,
    this.stopBit,
    this.parity,
    this.flowControl,
    this.returnedDataType,
  });

  DriverType? driver;
  int? portInterface;
  BaudRate? baudRate;
  DataBit? dataBit;
  StopBit? stopBit;
  Parity? parity;
  FlowControl? flowControl;
  ReturnedDataType? returnedDataType;
}

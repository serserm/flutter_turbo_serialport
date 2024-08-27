enum DriverType {
  $auto('AUTO'),
  $cdc('cdc'),
  $ch34x('ch34x'),
  $cp210x('cp210x'),
  $ftdi('ftdi'),
  $pl2303('pl2303');

  final String value;
  const DriverType(this.value);
}

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
}

enum DataBit {
  $5(5),
  $6(6),
  $7(7),
  $8(8);

  final int value;
  const DataBit(this.value);
}

enum StopBit {
  $1(1),
  $2(2),
  $15(3);

  final int value;
  const StopBit(this.value);
}

enum Parity {
  $none(0),
  $odd(1),
  $even(2),
  $mark(3),
  $space(4);

  final int value;
  const Parity(this.value);
}

enum FlowControl {
  $off(0),
  $rtsCts(1),
  $dsrDtr(2),
  $xOnxOff(3);

  final int value;
  const FlowControl(this.value);
}

enum ReturnedDataType {
  $intArray(1),
  $hexString(2),
  $utf8(3);

  final int value;
  const ReturnedDataType(this.value);
}

enum Mode {
  $async(0),
  $sync(1);

  final int value;
  const Mode(this.value);
}

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

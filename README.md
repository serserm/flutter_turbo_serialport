# flutter_turbo_serialport

[![Platform](https://img.shields.io/badge/platform-android-989898.svg)](https://pub.dev/packages/flutter_turbo_serialport)
[![StandWithUkraine](https://raw.githubusercontent.com/vshymanskyy/StandWithUkraine/main/badges/StandWithUkraine.svg)](https://github.com/vshymanskyy/StandWithUkraine/blob/main/docs/README.md)
<br/>
[![pub version](https://img.shields.io/pub/v/flutter_turbo_serialport.svg)](https://pub.dev/packages/flutter_turbo_serialport)

## Dependencies

This library depends on: [felHR85/UsbSerial](https://github.com/felHR85/UsbSerial)

## [Change Log](https://github.com/serserm/flutter_turbo_serialport/blob/main/CHANGELOG.md).

## Usage

>**Note**: [IDs are not persistent across USB disconnects.](https://developer.android.com/reference/android/hardware/usb/UsbDevice#getDeviceId())

### Default ParamsType
| KEY              | VALUE            |
|------------------|------------------|
| driver           | AUTO             |
| portInterface    | -1               |
| returnedDataType | UTF8             |
| baudRate         | 9600             |
| dataBit          | DATA_BITS_8      |
| stopBit          | STOP_BITS_1      |
| parity           | PARITY_NONE      |
| flowControl      | FLOW_CONTROL_OFF |

### Optional

Add the following android intent to android/app/src/main/AndroidManifest.xml so that permissions are remembered on android (VS not remembered by usbManager.requestPermission())
```xml
<activity>
  <intent-filter>
    <action android:name="android.hardware.usb.action.USB_DEVICE_ATTACHED" />
  </intent-filter>

  <meta-data android:name="android.hardware.usb.action.USB_DEVICE_ATTACHED"
    android:resource="@xml/device_filter" />
</activity>
```

And create a filter file in android/app/src/main/res/xml/usb_device_filter.xml

```xml
<?xml version="1.0" encoding="utf-8"?>
<resources>
  <!-- 0x0403 / 0x6001: FTDI FT232R UART -->
  <usb-device vendor-id="1027" product-id="24577" />

  <!-- 0x0403 / 0x6015: FTDI FT231X -->
  <usb-device vendor-id="1027" product-id="24597" />

  <!-- 0x2341 / Arduino -->
  <usb-device vendor-id="9025" />

  <!-- 0x16C0 / 0x0483: Teensyduino  -->
  <usb-device vendor-id="5824" product-id="1155" />

  <!-- 0x10C4 / 0xEA60: CP210x UART Bridge -->
  <usb-device vendor-id="4292" product-id="60000" />

  <!-- 0x067B / 0x2303: Prolific PL2303 -->
  <usb-device vendor-id="1659" product-id="8963" />

  <!-- 0x1366 / 0x0105: Segger JLink -->
  <usb-device vendor-id="4966" product-id="261" />

  <!-- 0x1366 / 0x0105: CH340 JLink -->
  <usb-device vendor-id="1A86" product-id="7523" />

</resources>
```

The vendor-id and product-id here have to be given in decimal, and can be retrieved using listDevices()

## Example

[turboserialport_example](https://github.com/serserm/flutter_turbo_serialport/blob/main/example)

## License

[MIT](LICENSE)

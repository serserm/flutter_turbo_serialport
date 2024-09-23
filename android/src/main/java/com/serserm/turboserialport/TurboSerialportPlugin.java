package com.serserm.turboserialport;

import androidx.annotation.NonNull;

import java.nio.charset.StandardCharsets;
import java.util.List;
import java.util.ArrayList;
import android.os.Build;
import android.os.Handler;
import android.os.Looper;
import android.util.Base64;
import android.hardware.usb.UsbDevice;
import com.felhr.usbserial.UsbSerialDevice;

import io.flutter.embedding.engine.plugins.FlutterPlugin;

/** TurboserialportPlugin */
public class TurboSerialportPlugin implements FlutterPlugin, PigeonSpec.TurboSerialport {
  private SerialPortBuilder builder;
  private int listenerCount = 0;
  private PigeonSpec.TurboSerialportListener api;
  private final Handler mainHandler = new Handler(Looper.getMainLooper());

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
    builder = SerialPortBuilder.createSerialPortBuilder(binding.getApplicationContext(), serialPortCallback);
    PigeonSpec.TurboSerialport.setUp(binding.getBinaryMessenger(), this);
    api = new PigeonSpec.TurboSerialportListener(binding.getBinaryMessenger());
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    PigeonSpec.TurboSerialport.setUp(binding.getBinaryMessenger(), null);
    api = null;
  }

  SerialPortCallback serialPortCallback = new SerialPortCallback() {

    @Override
    public void onError(int code, String message) {
      sendError(code, message);
    }

    @Override
    public void onDeviceAttached(int deviceId) {
      sendType(deviceId, Definitions.onDeviceAttached);
    }

    @Override
    public void onDeviceDetached(int deviceId) {
      sendType(deviceId, Definitions.onDeviceDetached);
    }

    @Override
    public void onConnected(int deviceId, int portInterface) {
      sendType(deviceId, portInterface, Definitions.onConnected);
    }

    @Override
    public void onDisconnected(int deviceId, int portInterface) {
      sendType(deviceId, portInterface, Definitions.onDisconnected);
    }

    @Override
    public void onReadData(int deviceId, int portInterface, int returnedDataType, byte[] bytes) {
      if (api != null) {
        PigeonSpec.SerialportEvent event = new PigeonSpec.SerialportEvent();
        event.setType(Definitions.onReadData);
        event.setDeviceId((long) deviceId);
        event.setPortInterface((long) portInterface);
        switch (returnedDataType) {
          case Definitions.RETURNED_DATA_TYPE_INTARRAY: {
            event.setDataList(bytes);
          }
          break;
          case Definitions.RETURNED_DATA_TYPE_HEXSTRING: {
            event.setDataString(bytesToHex(bytes));
          }
          break;
          case Definitions.RETURNED_DATA_TYPE_UTF8: {
            String data = new String(bytes, StandardCharsets.UTF_8);
            event.setDataString(data);
          }
          break;
        }

        mainHandler.post(() -> api.serialportEvent(event, voidResult));
      }
    }
  };

  private final PigeonSpec.VoidResult voidResult = new PigeonSpec.VoidResult() {
    @Override
    public void success() {
    }

    @Override
    public void error(Throwable error) {
    }
  };

  private void sendError(int code, String message) {
    if (api != null) {
      PigeonSpec.SerialportEvent event = new PigeonSpec.SerialportEvent();
      event.setType(Definitions.onError);
      event.setErrorCode((long) code);
      event.setErrorMessage(message);

      mainHandler.post(() -> api.serialportEvent(event, voidResult));
    }
  }

  private void sendType(int deviceId, String type) {
    if (api != null) {
      PigeonSpec.SerialportEvent event = new PigeonSpec.SerialportEvent();
      event.setType(type);
      event.setDeviceId((long) deviceId);

      mainHandler.post(() -> api.serialportEvent(event, voidResult));
    }
  }

  private void sendType(int deviceId, int portInterface, String type) {
    if (api != null) {
      PigeonSpec.SerialportEvent event = new PigeonSpec.SerialportEvent();
      event.setType(type);
      event.setDeviceId((long) deviceId);
      event.setPortInterface((long) portInterface);

      mainHandler.post(() -> api.serialportEvent(event, voidResult));
    }
  }

  private PigeonSpec.SerialportDevice serializeDevice(UsbDevice device) {
    PigeonSpec.SerialportDevice data = new PigeonSpec.SerialportDevice();
    data.setIsSupported(UsbSerialDevice.isSupported(device));
    data.setDeviceName(device.getDeviceName());
    data.setDeviceId((long) device.getDeviceId());
    data.setDeviceClass((long) device.getDeviceClass());
    data.setDeviceSubclass((long) device.getDeviceSubclass());
    data.setDeviceProtocol((long) device.getDeviceProtocol());
    data.setVendorId((long) device.getVendorId());
    data.setProductId((long) device.getProductId());

    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
      data.setInterfaceCount((long) device.getInterfaceCount());
      String manufacturerName = device.getManufacturerName();
      if (manufacturerName != null) {
        data.setManufacturerName(manufacturerName);
      }
      String productName = device.getProductName();
      if (productName != null) {
        data.setProductName(productName);
      }
    }
    return data;
  }

  /********************************** CONVERTING **************************************/

  private String bytesToHex(byte[] bytes) {
    char[] chars = new char[bytes.length * 2];
    for (int j = 0, l = bytes.length; j < l; j++) {
      int v = bytes[j] & 0xFF;
      chars[j * 2] = Definitions.hexArray[v >>> 4];
      chars[j * 2 + 1] = Definitions.hexArray[v & 0x0F];
    }
    return new String(chars);
  }

  private byte[] HexToBytes(String message) {
    String msg = message.toUpperCase();
    byte[] bytes = new byte[msg.length() / 2];
    for (int i = 0; i < bytes.length; i++) {
      int index = i * 2;
      String hex = msg.substring(index, index + 2);
      if (Definitions.hexChars.indexOf(hex.substring(0, 1)) == -1
          || Definitions.hexChars.indexOf(hex.substring(1, 1)) == -1) {
        return bytes;
      }
      bytes[i] = (byte) Integer.parseInt(hex, 16);
    }
    return bytes;
  }

  private byte[] Base64ToBytes(String message) {
    return Base64.decode(message, Base64.DEFAULT);
  }

  private byte[] StringToBytes(String message) {
    return message.getBytes(StandardCharsets.UTF_8);
  }

  /********************************** FLUTTER **************************************/

  @Override
  public void addListener() {
    if (listenerCount == 0) {
      // Set up any upstream listeners or background tasks as necessary
      builder.getSerialPorts();
    }
    listenerCount += 1;
  }

  @Override
  public void removeListener() {
    listenerCount -= 1;
    if (listenerCount <= 0) {
      listenerCount = 0;
      // Remove upstream listeners, stop unnecessary background tasks
      builder.disconnectAll();
      builder.unregisterReceiver();
    }
  }

  @Override
  public void init(
      Boolean autoConnect,
      Long mode,
      String driver,
      Long portInterface,
      Long returnedDataType,
      Long baudRate,
      Long dataBit,
      Long stopBit,
      Long parity,
      Long flowControl
  ) {
    builder.init(
        autoConnect,
        mode.intValue(),
        driver,
        portInterface.intValue(),
        returnedDataType.intValue(),
        baudRate.intValue(),
        dataBit.intValue(),
        stopBit.intValue(),
        parity.intValue(),
        flowControl.intValue()
    );
  }

  @Override
  public void setParams(
      Long deviceId,
      String driver,
      Long portInterface,
      Long returnedDataType,
      Long baudRate,
      Long dataBit,
      Long stopBit,
      Long parity,
      Long flowControl
  ) {
    builder.setParams(
        deviceId.intValue(),
        driver,
        portInterface.intValue(),
        returnedDataType.intValue(),
        baudRate.intValue(),
        dataBit.intValue(),
        stopBit.intValue(),
        parity.intValue(),
        flowControl.intValue()
    );
  }

  @Override
  public void listDevices(PigeonSpec.Result<List<PigeonSpec.SerialportDevice>> result) {
    builder.getSerialPorts();
    List<UsbDevice> usbDevices = builder.getPossibleSerialPorts();
    List<PigeonSpec.SerialportDevice> deviceList = new ArrayList<>();
    if (usbDevices.size() != 0) {
      for (UsbDevice device: usbDevices) {
        deviceList.add(serializeDevice(device));
      }
    }
    result.success(deviceList);
  }

  @Override
  public void connect(Long deviceId) {
    if (listenerCount > 0) {
      builder.connect(deviceId.intValue());
    }
  }

  @Override
  public void disconnect(Long deviceId) {
    if (deviceId > 0) {
      builder.disconnect(deviceId.intValue());
    } else {
      builder.disconnectAll();
    }
  }

  @Override
  public void isConnected(Long deviceId, PigeonSpec.Result<Boolean> result) {
    result.success(builder.isConnected(deviceId.intValue()));
  }

  @Override
  public void isServiceStarted(PigeonSpec.Result<Boolean> result) {
    result.success(listenerCount > 0);
  }

  @Override
  public void writeBytes(Long deviceId, Long portInterface, byte[] message) {
    if (message.length < 1) {
      return;
    }
    if (listenerCount > 0) {
      builder.write(deviceId.intValue(), portInterface.intValue(), message);
    }
  }

  @Override
  public void writeString(Long deviceId, Long portInterface, String message) {
    if (message.length() < 1) {
      return;
    }
    if (listenerCount > 0) {
      builder.write(deviceId.intValue(), portInterface.intValue(), StringToBytes(message));
    }
  }

  @Override
  public void writeBase64(Long deviceId, Long portInterface, String message) {
    if (message.length() < 1) {
      return;
    }
    if (listenerCount > 0) {
      builder.write(deviceId.intValue(), portInterface.intValue(), Base64ToBytes(message));
    }
  }

  @Override
  public void writeHexString(Long deviceId, Long portInterface, String message) {
    if (message.length() < 1) {
      return;
    }
    if (listenerCount > 0) {
      builder.write(deviceId.intValue(), portInterface.intValue(), HexToBytes(message));
    }
  }
}

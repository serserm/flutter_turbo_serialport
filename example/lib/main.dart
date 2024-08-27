import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_turbo_serialport/flutter_turbo_serialport.dart';

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    ),
  );
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Function _subscribe;
  Map<int, String> _allDevices = {};
  String _device = '';
  String _data = '';

  @override
  void initState() {
    super.initState();

    // this method is called once
    // but it is optional
    SerialportController().init(
      autoConnect: false,
      mode: Mode.$async,
      params: Params(
        driver: DriverType.$auto,
        portInterface: -1, // all ports
        returnedDataType: ReturnedDataType.$utf8,
        baudRate: BaudRate.$9600,
        dataBit: DataBit.$8,
        stopBit: StopBit.$1,
        parity: Parity.$none,
        flowControl: FlowControl.$off,
      ),
    );
    _subscribe = SerialportController().addListeners(
      onReadData: onReadData,
      onError: onError,
      onConnected: onConnected,
      onDisconnected: onDisconnected,
      onDeviceAttached: onSearch,
      onDeviceDetached: onSearch,
    );

    SerialportController().isServiceStarted().then((bool res) {
      debugPrint(
        'isServiceStarted: $res',
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
    _subscribe();
  }

  void onReadData({
    int? deviceId,
    int? portInterface,
    dynamic data, // String | Uint8List
  }) {
    setState(() {
      _data += data as String;
    });
  }

  void onError({
    int? errorCode,
    String? errorMessage,
  }) {
    if (errorMessage != null) {
      _showMyDialog('Error', errorMessage);
    }
  }

  void onConnected({
    int? deviceId,
    int? portInterface,
  }) {
    setState(() {
      _device = 'id: $deviceId $portInterface +';
    });
  }

  void onDisconnected({
    int? deviceId,
    int? portInterface,
  }) {
    setState(() {
      _device = 'id: $deviceId $portInterface -';
    });
  }

  void onSearch({
    int? deviceId,
  }) {
    SerialportController().listDevices().then((List<Device> res) {
      Map<int, String> devices = {};
      for (Device device in res) {
        devices[device.deviceId!] = device.deviceName ?? 'null';
      }
      setState(() {
        _allDevices = devices;
      });
    });
  }

  Future<void> _showMyDialog(String title, String text) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(text),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  connect({
    int? deviceId,
  }) {
    return () {
      SerialportController().connect(
        deviceId: deviceId,
      );
    };
  }

  write({
    int? deviceId,
  }) {
    return () {
      SerialportController().writeString(
        message: '${Random().nextDouble()}',
        deviceId: deviceId,
        portInterface: 0,
      );
    };
  }

  @override
  Widget build(BuildContext context) {
    Iterable deviceList = _allDevices.keys;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            TextButton(
              onPressed: onSearch,
              child: Center(
                child: Text(
                  'Search: ${deviceList.length}\n$_device',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: deviceList.length,
        itemBuilder: (BuildContext context, int index) {
          final int key = deviceList.elementAt(index);

          return ListTile(
            title: TextButton(
              onPressed: connect(deviceId: key),
              child: Center(
                child: Text(
                  'Connect id: $key',
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

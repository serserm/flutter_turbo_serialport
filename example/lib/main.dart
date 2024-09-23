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
  List<Device> _allDevices = [];
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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _subscribe = SerialportController().addListeners(
        onReadData: onReadData,
        onError: onError,
        onConnected: onConnected,
        onDisconnected: onDisconnected,
        onDeviceAttached: onSearch,
        onDeviceDetached: onSearch,
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
      setState(() {
        _allDevices = res;
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
    required Device device,
  }) {
    return () {
      device.isConnected().then((bool res) {
        if (res) {
          device.writeString(message: '${Random().nextDouble()}');
        } else {
          device.connect();
        }
      });
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
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            TextButton(
              onPressed: onSearch,
              child: Center(
                child: Text(
                  'Search: ${_allDevices.length}\n$_device',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _allDevices.length,
              itemBuilder: (BuildContext context, int index) {
                final Device device = _allDevices.elementAt(index);

                return ListTile(
                  title: TextButton(
                    onPressed: connect(device: device),
                    child: Center(
                      child: Text(
                        'Connect id: ${device.deviceId}',
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(
              child: Text(
                _data,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

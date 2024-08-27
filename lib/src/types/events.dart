typedef OnReadData = void Function({
  int? deviceId,
  int? portInterface,
  dynamic data,
});

typedef OnError = void Function({
  int? errorCode,
  String? errorMessage,
});

typedef OnConnected = void Function({
  int? deviceId,
  int? portInterface,
});

typedef OnDisconnected = void Function({
  int? deviceId,
  int? portInterface,
});

typedef OnDeviceAttached = void Function({
  int? deviceId,
});

typedef OnDeviceDetached = void Function({
  int? deviceId,
});

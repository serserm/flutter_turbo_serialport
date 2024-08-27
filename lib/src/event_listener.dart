import 'turbo_serialport.g.dart';
import 'types/types.dart';

/// controller listener
/// ## Example
/// ```dart
/// final EventListener _listener = EventListener();
/// ```
class EventListener {
  final List<OnReadData> _onReadData = [];
  final List<OnError> _onError = [];
  final List<OnConnected> _onConnected = [];
  final List<OnDisconnected> _onDisconnected = [];
  final List<OnDeviceAttached> _onDeviceAttached = [];
  final List<OnDeviceDetached> _onDeviceDetached = [];

  /// ## Example
  /// ```dart
  /// _listener.add(
  ///   onReadData: onReadData,
  ///   onError: onError,
  ///   onConnected: onConnected,
  ///   onDisconnected: onDisconnected,
  ///   onDeviceAttached: onDeviceAttached,
  ///   onDeviceDetached: onDeviceDetached,
  /// )
  /// ```
  bool add({
    OnReadData? onReadData,
    OnError? onError,
    OnConnected? onConnected,
    OnDisconnected? onDisconnected,
    OnDeviceAttached? onDeviceAttached,
    OnDeviceDetached? onDeviceDetached,
  }) {
    bool isAdd = false;
    if (onReadData != null) {
      _onReadData.add(onReadData);
      isAdd = true;
    }
    if (onError != null) {
      _onError.add(onError);
      isAdd = true;
    }
    if (onConnected != null) {
      _onConnected.add(onConnected);
      isAdd = true;
    }
    if (onDisconnected != null) {
      _onDisconnected.add(onDisconnected);
      isAdd = true;
    }
    if (onDeviceAttached != null) {
      _onDeviceAttached.add(onDeviceAttached);
      isAdd = true;
    }
    if (onDeviceDetached != null) {
      _onDeviceDetached.add(onDeviceDetached);
      isAdd = true;
    }
    return isAdd;
  }

  /// ## Example
  /// ```dart
  /// _listener.remove(
  ///   onReadData: onReadData,
  ///   onError: onError,
  ///   onConnected: onConnected,
  ///   onDisconnected: onDisconnected,
  ///   onDeviceAttached: onDeviceAttached,
  ///   onDeviceDetached: onDeviceDetached,
  /// )
  /// ```
  bool remove({
    OnReadData? onReadData,
    OnError? onError,
    OnConnected? onConnected,
    OnDisconnected? onDisconnected,
    OnDeviceAttached? onDeviceAttached,
    OnDeviceDetached? onDeviceDetached,
  }) {
    bool isRemove = false;
    if (onReadData != null && _onReadData.contains(onReadData)) {
      _onReadData.remove(onReadData);
      isRemove = true;
    }
    if (onError != null && _onError.contains(onError)) {
      _onError.remove(onError);
      isRemove = true;
    }
    if (onConnected != null && _onConnected.contains(onConnected)) {
      _onConnected.remove(onConnected);
      isRemove = true;
    }
    if (onDisconnected != null && _onDisconnected.contains(onDisconnected)) {
      _onDisconnected.remove(onDisconnected);
      isRemove = true;
    }
    if (onDeviceAttached != null &&
        _onDeviceAttached.contains(onDeviceAttached)) {
      _onDeviceAttached.remove(onDeviceAttached);
      isRemove = true;
    }
    if (onDeviceDetached != null &&
        _onDeviceDetached.contains(onDeviceDetached)) {
      _onDeviceDetached.remove(onDeviceDetached);
      isRemove = true;
    }
    return isRemove;
  }

  /// ## Example
  /// ```dart
  /// @override
  /// void serialportEvent(SerialportEvent event) {
  ///   try {
  ///     _listener.call(event);
  ///   } catch (err) {
  ///     rethrow;
  ///   }
  /// }
  /// ```
  void call(SerialportEvent event) {
    switch (event.type) {
      case 'onReadData':
        {
          for (var listener in List<OnReadData>.from(_onReadData)) {
            listener(
              deviceId: event.deviceId,
              portInterface: event.portInterface,
              data: event.dataString ?? event.dataList,
            );
          }
          break;
        }
      case 'onError':
        {
          for (var listener in List<OnError>.from(_onError)) {
            listener(
              errorCode: event.errorCode,
              errorMessage: event.errorMessage,
            );
          }
          break;
        }
      case 'onConnected':
        {
          for (var listener in List<OnConnected>.from(_onConnected)) {
            listener(
              deviceId: event.deviceId,
              portInterface: event.portInterface,
            );
          }
          break;
        }
      case 'onDisconnected':
        {
          for (var listener in List<OnDisconnected>.from(_onDisconnected)) {
            listener(
              deviceId: event.deviceId,
              portInterface: event.portInterface,
            );
          }
          break;
        }
      case 'onDeviceAttached':
        {
          for (var listener in List<OnDeviceAttached>.from(_onDeviceAttached)) {
            listener(
              deviceId: event.deviceId,
            );
          }
          break;
        }
      case 'onDeviceDetached':
        {
          for (var listener in List<OnDeviceDetached>.from(_onDeviceDetached)) {
            listener(
              deviceId: event.deviceId,
            );
          }
          break;
        }
    }
  }
}

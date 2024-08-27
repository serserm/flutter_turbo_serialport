/// ## Example
/// ```dart
/// void onReadData({
///   int? deviceId,
///   int? portInterface,
///   dynamic data, // String | Uint8List
/// }) {
///   // TODO
/// }
/// ```
typedef OnReadData = void Function({
  int? deviceId,
  int? portInterface,
  dynamic data,
});

/// ## Example
/// ```dart
/// void onError({
///   int? errorCode,
///   String? errorMessage,
/// }) {
///   // TODO
/// }
/// ```
typedef OnError = void Function({
  int? errorCode,
  String? errorMessage,
});

/// ## Example
/// ```dart
/// void onConnected({
///   int? deviceId,
///   int? portInterface,
/// }) {
///   // TODO
/// }
/// ```
typedef OnConnected = void Function({
  int? deviceId,
  int? portInterface,
});

/// ## Example
/// ```dart
/// void onDisconnected({
///   int? deviceId,
///   int? portInterface,
/// }) {
///   // TODO
/// }
/// ```
typedef OnDisconnected = void Function({
  int? deviceId,
  int? portInterface,
});

/// ## Example
/// ```dart
/// void onDeviceAttached({
///   int? deviceId,
/// }) {
///   // TODO
/// }
/// ```
typedef OnDeviceAttached = void Function({
  int? deviceId,
});

/// ## Example
/// ```dart
/// void onDeviceDetached({
///   int? deviceId,
/// }) {
///   // TODO
/// }
/// ```
typedef OnDeviceDetached = void Function({
  int? deviceId,
});

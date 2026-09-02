import 'dart:convert';
import 'dart:typed_data';

/// Encodes JSON exactly like PeerJS 1.5.x: UTF-8 bytes sent as a binary
/// WebRTC DataChannel message.
Uint8List encodePeerJsJsonPayload(Object? value) {
  return Uint8List.fromList(utf8.encode(jsonEncode(value)));
}

/// Decodes the binary JSON payload produced by PeerJS 1.5.x.
Object? decodePeerJsJsonBinaryPayload(Uint8List value) {
  return jsonDecode(utf8.decode(value));
}

/// Keeps compatibility with PeerDart clients that used text JSON messages.
Object? decodePeerJsJsonTextPayload(String value) {
  return jsonDecode(value);
}

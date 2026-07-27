import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:peerdart/src/peerjs_json_codec.dart';

void main() {
  const payload = <String, Object?>{
    'type': 'player:hello',
    'name': 'Paweł 🦊',
    'ready': true,
    'score': 12,
  };

  test('encodes JSON as PeerJS-compatible binary UTF-8', () {
    final encoded = encodePeerJsJsonPayload(payload);

    expect(encoded, Uint8List.fromList(utf8.encode(jsonEncode(payload))));
  });

  test('decodes binary JSON sent by PeerJS', () {
    final encoded = Uint8List.fromList(utf8.encode(jsonEncode(payload)));

    expect(decodePeerJsJsonBinaryPayload(encoded), payload);
  });

  test('keeps compatibility with legacy text JSON messages', () {
    expect(decodePeerJsJsonTextPayload(jsonEncode(payload)), payload);
  });
}

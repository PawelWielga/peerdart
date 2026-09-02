import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:peerdart/peerdart.dart';

void main() {
  test('reconnect recreates signaling socket and emits open again', () async {
    final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    final acceptedSockets = StreamController<WebSocket>.broadcast();
    final sockets = <WebSocket>[];
    final serverSubscription = server.listen((request) async {
      final socket = await WebSocketTransformer.upgrade(request);
      sockets.add(socket);
      acceptedSockets.add(socket);
    });

    addTearDown(() async {
      for (final socket in sockets) {
        await socket.close();
      }
      await serverSubscription.cancel();
      await acceptedSockets.close();
      await server.close(force: true);
    });

    final firstSocketFuture = acceptedSockets.stream.first;
    final peer = Peer(
      id: 'peer-reconnect-test',
      options: PeerOptions(
        host: InternetAddress.loopbackIPv4.address,
        port: server.port,
        path: '/',
        key: 'peerjs',
        secure: false,
        pingInterval: 60000,
      ),
    );
    addTearDown(peer.dispose);

    final firstOpenFuture = peer.on<String?>('open').first;
    final firstSocket =
        await firstSocketFuture.timeout(const Duration(seconds: 2));
    firstSocket.add(jsonEncode(<String, Object?>{'type': 'OPEN'}));
    expect(
      await firstOpenFuture.timeout(const Duration(seconds: 2)),
      'peer-reconnect-test',
    );

    final originalSignalingSocket = peer.socket;
    peer.disconnect();
    expect(peer.disconnected, isTrue);

    final secondSocketFuture = acceptedSockets.stream.first;
    final secondOpenFuture = peer.on<String?>('open').first;
    peer.reconnect();

    final secondSocket =
        await secondSocketFuture.timeout(const Duration(seconds: 2));
    secondSocket.add(jsonEncode(<String, Object?>{'type': 'OPEN'}));
    expect(
      await secondOpenFuture.timeout(const Duration(seconds: 2)),
      'peer-reconnect-test',
    );
    expect(peer.socket, isNot(same(originalSignalingSocket)));
    expect(peer.disconnected, isFalse);
    expect(peer.open, isTrue);
  });
}

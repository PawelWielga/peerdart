# PeerDart: Simple peer-to-peer with WebRTC

PeerDart provides a complete, configurable, and easy-to-use peer-to-peer API built on top of WebRTC, supporting both data channels and media streams.

PeerDart **mirrors** the design of peerjs. Find the documentation [here](https://peerjs.com/docs)..

## PeerJS compatibility

The current `dev` branch of this fork (`peerdart` package version `0.5.4`) is tested for wire compatibility with **PeerJS 1.5.5** (`peerjs@1.5.5`).

In particular, data connections using `serialization: 'json'` follow the PeerJS 1.5.5 wire format: JSON is encoded as UTF-8 and sent as a binary WebRTC DataChannel payload. The compatibility fix was introduced in commit `000856809db72d7f553d2346e1e63ef1a7be3b43`.

Compatibility with older or newer PeerJS versions is not guaranteed until those versions are explicitly tested.

## Status

- [x] Alpha: Under heavy development
- [x] Public Alpha: Ready for testing. But go easy on us, there will be bugs and missing functionality.
- [ ] Public Beta: Stable. No breaking changes expected in this version but possible bugs.
- [ ] Public: Production-ready

## Live Example

Here's an example application that uses both media and data connections: [Example](https://peerdart.netlify.app/)

## Setup


**Create a Peer**

```dart
final Peer peer = Peer("pick-an-id");
// You can pick your own id or omit the id if you want to get a random one from the server.
```

## Data connections

**Connect**

```dart
const conn = peer.connect("another-peers-id");

conn.on("open").listen((name) {
    conn.send("hi!");
})
```

**Receive**

```dart
peer.on<DataConnection>("connection").listen((connection) {

    // On peer closed.
    conn.on("close").listen((event) {
        setState(() {
            connected = false;
        });
    });

    // ....
})
```

## Media calls

**Call**

```dart
final mediaStream = await navigator.mediaDevices
        .getUserMedia({"video": true, "audio": false});

    final conn = peer.call("peerId", mediaStream);

    // Do some stuff with stream
    conn.on<MediaStream>("stream").listen((event) {
      _remoteRenderer.srcObject = event;
      _localRenderer.srcObject = mediaStream;

      setState(() {
        inCall = true;
      });
    });
});
```

**Answer**

```dart
peer.on<MediaConnection>("call").listen((call) async {
    final mediaStream = await navigator.mediaDevices
        .getUserMedia({"video": true, "audio": false});

    call.answer(mediaStream);


    // on peer closed
    call.on("close").listen((event) {
        setState(() {
            inCall = false;
        });
    });

    // Get peer stream
    call.on<MediaStream>("stream").listen((event) {
        _localRenderer.srcObject = mediaStream;
        _remoteRenderer.srcObject = event;

        setState(() {
            inCall = true;
        });
    });
});
```

## More examples
See more at [example.](example/)

## Support
Works both on mobile and web browsers (Chrome tested.).

## Links

### [Documentation / API Reference](https://peerjs.com/docs/)

### [PeerServer](https://github.com/peers/peerjs-server)

## License

PeerDart is licensed under the [MIT License](https://tldrlegal.com/l/mit).

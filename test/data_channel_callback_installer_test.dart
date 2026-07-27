import 'package:flutter_test/flutter_test.dart';
import 'package:peerdart/src/data_channel_callback_installer.dart';

void main() {
  test('installs the message handler before an immediate open callback', () {
    var messageHandlerInstalled = false;
    var openObservedAfterMessageHandler = false;
    String? receivedMessage;

    installDataChannelCallbacks<String, String>(
      installMessageHandler: (handler) {
        messageHandlerInstalled = true;
        handler('first-message');
      },
      installStateHandler: (handler) {
        handler('open');
      },
      onMessage: (message) {
        receivedMessage = message;
      },
      onState: (state) {
        if (state == 'open') {
          openObservedAfterMessageHandler = messageHandlerInstalled;
        }
      },
    );

    expect(receivedMessage, 'first-message');
    expect(openObservedAfterMessageHandler, isTrue);
  });
}

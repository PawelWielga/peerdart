typedef DataChannelHandlerInstaller<T> = void Function(
  void Function(T value) handler,
);

/// Installs the message callback before the state callback.
///
/// Some RTC implementations can report an already-open channel as soon as the
/// state callback is assigned. Registering the message callback first prevents
/// the first remote message from being dropped during that transition.
void installDataChannelCallbacks<TMessage, TState>({
  required DataChannelHandlerInstaller<TMessage> installMessageHandler,
  required DataChannelHandlerInstaller<TState> installStateHandler,
  required void Function(TMessage message) onMessage,
  required void Function(TState state) onState,
}) {
  installMessageHandler(onMessage);
  installStateHandler(onState);
}

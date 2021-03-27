import 'package:flutter/services.dart';

const _channel = const EventChannel('com.sherlock2045.eventchannel/stream');
const _channel_message = const EventChannel('com.sherlock2045.eventchannel/messages');

typedef void Listener(dynamic msg);
typedef void CancelListening();
typedef void CancelMessageListening();

int nextListenerId = 1;
int nextMessageListenerId = 1;
CancelListening startListening(Listener listener) {
  var subscription = _channel.receiveBroadcastStream(nextListenerId++).listen(listener, cancelOnError: true);

  return () {
    subscription.cancel();
  };
}
CancelMessageListening startListenMessage(Listener listener){
  var subscription = _channel_message.receiveBroadcastStream(nextMessageListenerId++).listen(listener, cancelOnError: true);

  return () {
    subscription.cancel();
  };
}
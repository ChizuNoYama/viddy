import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:viddy/core/assumptions.dart';
import 'package:viddy/models/message.dart';

class ChatBubble extends StatelessWidget{

  ChatBubble({required Message this.message, required this.isMyMessage});

  final Message message;
  final bool isMyMessage;

  static const _methodChannel = MethodChannel("com.viddy/vibrate");

  Future<void> _invokeVibrate(){
    try{
      return _methodChannel.invokeMethod(Assumptions.VIBRATE_DEVICE_METHOD);
    }
    on PlatformException catch(e){
      print(e);
      return Future.value(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () => _invokeVibrate(), // do not wait,
        child: Container(
        padding: EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: this.isMyMessage ? Color(0xff674ea7) : Color(0xff0c343d),
          borderRadius: BorderRadius.all(Radius.circular(8.0))
        ),
        child: Text(
          this.message.payload,
          maxLines: null,
          style: TextStyle(
            fontSize: 16.0,
            color: Colors.white
          ),
        )
      )
    );
  }
}
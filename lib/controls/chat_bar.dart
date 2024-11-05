import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:viddy/protocols/conversationProtocol.dart';

// turn into a stateful widget

class ChatBar extends StatefulWidget{
  @override createState() => _ChatBarState();
}

class _ChatBarState extends State<ChatBar>{

  final TextEditingController _controller = new TextEditingController();

  Future sendMessageAsync(String text) async {
    Provider.of<ConversationProtocol>(context, listen:false).sendMessageWsAsync(text);
  }

  @override
  Widget build(BuildContext context) {
    return TextField( 
      controller: _controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(16))
        ),
      ),
      onSubmitted: (value) async{
        _controller.text = "";
        // TODO: Testing
        sendMessageAsync(value);
        // sendMessageAsync(value);
      }
    );
  }
}
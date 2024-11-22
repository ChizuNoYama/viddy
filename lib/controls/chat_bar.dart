import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:viddy/controls/entry.dart';
import 'package:viddy/protocols/conversationProtocol.dart';

// turn into a stateful widget

class ChatBar extends StatefulWidget{
  @override createState() => _ChatBarState();
}

class _ChatBarState extends State<ChatBar>{
  
  @override
  Widget build(BuildContext context) {
    return Entry(
      onSubmitted: (text) => Provider.of<ConversationProtocol>(context, listen:false).sendMessageWsAsync(text),
      shouldResetTextOnFinish: true,
    );
  }
}
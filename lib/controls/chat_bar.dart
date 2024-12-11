import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:viddy/controls/entry.dart';
import 'package:viddy/protocols/conversationProtocol.dart';

// turn into a stateful widget
class ChatBar extends StatelessWidget{
  
  @override
  Widget build(BuildContext context) {
    return Entry(
      onSubmitted: (text) => context.read<ConversationProtocol>().sendMessageAsync(text),
    );
  }
}
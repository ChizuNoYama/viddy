import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:viddy/controls/chat_bar.dart';
import 'package:viddy/models/conversation.dart';
import 'package:viddy/protocols/conversationProtocol.dart';

class ChatPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: true,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              ChangeNotifierProvider.value(
                value: context.read<ConversationProtocol>().currentConversation,
                builder: (context, child) => Expanded(
                  child: 
                  Consumer<Conversation>(
                    builder: (context, conversation, _) => ListView.builder(
                        reverse: true,
                        shrinkWrap: true,
                        itemCount: conversation.messages.length,
                        itemBuilder: (context, index) => Text(conversation.messages[index].payload),
                    )
                  )
                )
              ),
              
              Align(
                alignment: Alignment.bottomCenter,
                child: ChatBar(),
              )
            ]
          )
        )
      )
    );
  }
}
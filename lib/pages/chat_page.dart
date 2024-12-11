import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:viddy/components/chat_bubble.dart';
import 'package:viddy/controls/chat_bar.dart';
import 'package:viddy/models/conversation.dart';
import 'package:viddy/protocols/conversationProtocol.dart';
import 'package:viddy/protocols/userProtocol.dart';

class ChatPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff6ead5),
      body: SafeArea(
        
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  BackButton(onPressed: () {
                    context.read<ConversationProtocol>().clearConversationData();
                    Navigator.maybePop(context); // do not wait
                  }),
                ],
              ),
              Container(
                color: Colors.black,
                height: 1
              ),
              ChangeNotifierProvider.value(
                value: context.read<ConversationProtocol>().currentConversation,
                builder: (context, child) => Expanded(
                  child: 
                  Consumer<Conversation>(
                    builder: (context, conversation, _) => ListView.builder(
                        reverse: true,
                        shrinkWrap: true,
                        itemCount: conversation.messages.length,
                        itemBuilder: (context, index) { 
                          String messageUserID = conversation.messages[index].userID!;
                          String currentUserID = context.read<UserProtocol>().currentUser.userId;
                          bool isMyMessage = messageUserID == currentUserID;
                          return Align(
                            alignment: isMyMessage ? Alignment.centerRight : Alignment.centerLeft, // If the sender is the current user, push to the right of the screen. Everyone else is to the left
                            child: Column(
                              children: [
                                ConstrainedBox(
                                  constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * 0.70),
                                  child: ChatBubble(
                                    message: conversation.messages[index],
                                    isMyMessage: isMyMessage
                                  )
                                ),
                                SizedBox(height: 14)
                              ],
                            )
                          );
                        },
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
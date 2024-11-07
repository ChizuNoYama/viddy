import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:viddy/controls/chat_bar.dart';
import 'package:viddy/models/conversation.dart';
import 'package:viddy/protocols/conversationProtocol.dart';

class ChatPage extends StatefulWidget{
  @override 
  State<StatefulWidget> createState(){

    return new ChatPageState();
  }
}

class ChatPageState extends State<ChatPage>{

  late ConversationProtocol _protocol;

  @override
  void initState() {
    _protocol = Provider.of<ConversationProtocol>(context, listen: false);
    //TODO: Check local DB for conversation Id, if it exists, call continue conversation.
    // _protocol.continueConversation();
    _protocol.startNewConversation(); // Start brand new conversation

    // TODO: handle errors

    super.initState();
    
  }

  @override
  void dispose() {
    _protocol.closeConnection;
    
    super.dispose();
  }

  List<Widget> buildConversations(Conversation conversation){
    // TODO: Present the correct type of data depending on message type
    var tiles = conversation.messages.map((item) => new Text(item.payload ?? "")).toList();
    return tiles;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(value: _protocol.currentConversation,
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Consumer<Conversation>(
                builder: (context, value, child) => Expanded(
                  child: 
                    ListView(
                      shrinkWrap: true,
                      reverse: true,
                      children: buildConversations(value),
                  )
                )
              ),
              // TODO: Top navigation bar goes here,
              // TopNavBar(),
              Align(
                alignment: Alignment.bottomCenter,
                child:ChatBar(),
              )
            ]
          )
        )
      )
    );
  }
}
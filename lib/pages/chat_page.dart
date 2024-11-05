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
    Conversation conversation = Provider.of<Conversation>(context, listen: false);

    _protocol = Provider.of<ConversationProtocol>(context, listen: false);
    _protocol.startConversation(conversation);

    // TODO: handle errors

    super.initState();
    
  }

  @override
  void dispose() {
    _protocol.closeConnection;
    
    super.dispose();
  }

  List<Widget> buildConversations(Conversation conversation){
    // TODO: PResent the correct type of data depending on message type
    var tiles = conversation.messages.map((item) => new Text(item.payload ?? "")).toList();
    return tiles;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }
}
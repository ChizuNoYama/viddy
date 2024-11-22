import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:viddy/components/empty_conversation_state.dart";
import "package:viddy/protocols/conversationProtocol.dart";

class HomePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage>{
  Future<List<String>> _getConversationsAsync(ConversationProtocol protocol) async{
    List<String> idList =  await protocol.getConversationIdList();
    return idList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ConversationProtocol>(
        builder: (context, value, child) => FutureBuilder(
          future: _getConversationsAsync(value),
          builder: (context, snapshot) {
            if(!snapshot.hasData || snapshot.data?.length == 0){
              return EmptyConversationState();
            }
            else{
              return Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data?.length,
                  itemBuilder:(context, index) => Text(snapshot.data![index])
                )
              );
            }
          }
        ) 
      )
    );
  }
}
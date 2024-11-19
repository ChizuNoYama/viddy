import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:viddy/protocols/conversationProtocol.dart";

class ConversationListPage extends StatelessWidget{

  Future<List<String>> getConversationsAsync(ConversationProtocol protocol) async{
    List<String> idList =  await protocol.getConversationIdList();
    return idList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ConversationProtocol>(
        builder: (context, value, child) => Expanded(
          child: FutureBuilder(
            future: getConversationsAsync(value),
            builder: (context, snapshot) => ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data?.length,
              itemBuilder:(context, index) => Text(snapshot.data![index])
            )
          )
        )
      )
    );
  }
}
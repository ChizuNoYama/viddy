import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:provider/provider.dart";
import "package:viddy/components/user_search_modal.dart";
import "package:viddy/core/navigationHelper.dart";
import "package:viddy/protocols/conversationProtocol.dart";
import "package:viddy/protocols/user_search_cubit.dart";

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
      body: SafeArea(
        top: true,
        child: 
        // Stack(
          // children: [
            Column(
              children: [
                FutureBuilder(
                  future: _getConversationsAsync(Provider.of<ConversationProtocol>(context)),
                  builder: (context, snapshot) {
                    if(!snapshot.hasData || snapshot.data?.length == 0){
                      return Center(
                        child: OutlinedButton(
                          onPressed: () async => await NavigationHelper.showModalFullPageModalAsync(context, AnimatedUsersSearchModal()),
                          child: Text("Start new Conversation")
                        )
                      );
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
              ],
            ),
          // ],
        // )
      ),
    );
  }
}
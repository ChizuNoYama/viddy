import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:viddy/components/conversation_preview.dart";
import "package:viddy/components/user_search_modal.dart";
import "package:viddy/core/navigationHelper.dart";
import "package:viddy/models/conversation.dart";
import "package:viddy/pages/chat_page.dart";
import "package:viddy/protocols/conversationProtocol.dart";

class HomePage extends StatelessWidget{

  Future<void> goToChatPage(BuildContext context,ConversationProtocol protocol, String conversationId) async{
    Conversation? conversation = await protocol.getConversationMessagesAsync(conversationId);
    if(conversation == null){
      //TODO: show an alert saying that conversation was not able to be retrieved
    }
    else{
      await protocol.startOrContinueConversationAsync(existingConversation: conversation);
      NavigationHelper.goToAsync(context, ChatPage()); // Do not wait
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffff757a),
        actions: [
          GestureDetector(
            onTap: () async => await NavigationHelper.showModalFullPageModalAsync(context, AnimatedUsersSearchModal()),
            child:Icon(
              Icons.message,
              color: Colors.white,
            )
          ),
        ],
      ),
      body: SafeArea(
        top: true,
        child: Column(
          children: [
            FutureBuilder(
              future: context.read<ConversationProtocol>().getConversationsAsync(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState){
                  case ConnectionState.waiting:
                    return Center(child:CircularProgressIndicator());
                  case ConnectionState.done:
                    if(snapshot.hasData || snapshot.data?.length == 0){
                      return Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data?.length,
                          itemBuilder:(context, index) {
                            // return Text("Testing");
                            return GestureDetector(
                              onTap: () => goToChatPage(context, context.read<ConversationProtocol>(), snapshot.data![index].conversationId),
                              child: Container(
                                height: 50,
                                width: MediaQuery.sizeOf(context).width,
                                child:ConversationPreview(snapshot.data![index])
                              )
                            );
                          }
                        )
                      );
                    }
                    else{
                      return Text("Start a new conversation.");
                    }
                  case ConnectionState.none:
                  default:
                    return Center(child: Text("Something went wrong with retrieving conversations. Please try again soon."));
                }
              }
            )
          ],
        ),
      ),
    );
  }
}
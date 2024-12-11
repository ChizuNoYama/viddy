import "package:flutter/material.dart";
import "package:provider/provider.dart";
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
      body: SafeArea(
        top: true,
        child: Column(
          children: [
            FutureBuilder(
              future: context.read<ConversationProtocol>().getConversationsAsync(),
              builder: (context, snapshot) {
                if(!snapshot.hasData || snapshot.data?.length == 0){
                  return Center(
                    child: OutlinedButton(
                      onPressed: () async => await NavigationHelper.showModalFullPageModalAsync(context, AnimatedUsersSearchModal()),
                      child: Text("Start new conversation")
                    )
                  );
                }
                else{
                  return Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data?.length,
                      itemBuilder:(context, index) {
                        return GestureDetector(
                          onTap: () => goToChatPage(context, context.read<ConversationProtocol>(), snapshot.data![index].conversationId),
                          child: Text(snapshot.data![index].lastMessage)
                        );
                      } // TODO: change this to show a list of ConversationPreviews
                    )
                  );
                }
              }
            ) 
          ],
        ),
      ),
    );
  }
}
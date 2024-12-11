import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viddy/core/navigationHelper.dart';
import 'package:viddy/models/user.dart';
import 'package:viddy/pages/chat_page.dart';
import 'package:viddy/protocols/conversationProtocol.dart';
import 'package:viddy/protocols/userProtocol.dart';
import 'package:viddy/protocols/user_search_cubit.dart';

class AnimatedUsersSearchModal extends StatelessWidget{

  Widget presentUserList(List<User>? list){
    
    if(list == null){
      return SizedBox.shrink();
    }
    if(list.isEmpty){
      return Center(child: Text("Search for users"));
    }
    else{
      return Expanded(
        child:Center(
          child: ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index) { 
              return GestureDetector(
                onTap: () async {
                  String otherUser = list[index].userId;
                  String currentUserId = context.read<UserProtocol>().currentUser.userId;                
                  List<String> participants = [currentUserId, otherUser];
                  await context.read<ConversationProtocol>().startOrContinueConversationAsync(targetParticipants: participants);
                  NavigationHelper.goToAsync(context, ChatPage()); // Do not wait
                },
                child: Text(list[index].userName)
              );
            }
          )
        )
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: true, 
        child: TweenAnimationBuilder(
          duration: Duration(milliseconds: 600),
          curve: Curves.easeOutExpo,
          tween: Tween<Offset>(
            begin: Offset(0.0, MediaQuery.sizeOf(context).height), 
            end: Offset(0.0, 0.0)),
          onEnd: () { 
            String currentUserId = context.read<UserProtocol>().currentUser.userId;
            context.read<UserSearchCubit>().getListOfUsersAsync(currentUserId); 
          },// Do not Wait
          builder: (context, offset, child) => Transform.translate(
            offset: offset,
            child: Column(
              children: [
                Row(
                  children: [
                    BackButton(),
                  ],
                ),
                Container(
                  color: Colors.black,
                  height: 1
                ),
                BlocBuilder<UserSearchCubit, List<User>?>(
                  builder: (context, state) => Visibility(
                    visible: state != null,
                    replacement: CircularProgressIndicator(color: Colors.purple[400]),
                    child: presentUserList(state)
                  )
                ),
              ],
            )
          )
        )
      )
    );
  }
}
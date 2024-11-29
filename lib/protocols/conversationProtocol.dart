import 'dart:async';
import 'dart:convert';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:viddy/enums/conversationAction.dart';
import 'package:viddy/enums/messageType.dart';
import 'package:viddy/models/conversation.dart';
import 'package:viddy/models/message.dart';
import 'package:viddy/protocols/userProtocol.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:viddy/core/assumptions.dart';

class ConversationProtocol {

  ConversationProtocol(this._userProtocol);

  UserProtocol _userProtocol;

  late List<String> _conversationIdList;
  List<String> get conversationIdList {return  _conversationIdList;}

  late Conversation _currentConversation;
  Conversation get currentConversation => _currentConversation;

  // #endregion Properties

  Future<void> startConversationAsync(List<String> targetParticipants, {Conversation? existingConversation = null}) async {
    if(existingConversation != null){
      _currentConversation = existingConversation;
    }
    else{
      
      Map<String, dynamic> result = await Supabase.instance.client
        .from("Conversations")
        .insert({Assumptions.PARTICIPANTS_KEY : targetParticipants})
        .select().single();
        _currentConversation = Conversation.toAppModel(result);
    }
  }

//TODO: Get list of conversation Id's from the BE.
  Future<List<String>> getConversationIdList() async{
    
    return new List<String>.empty();
  }

  Future<void> sendMessageAsync(String payload, {MessageType type = MessageType.Text}) async { // add status of message
    String? userId = (await _userProtocol.currentUser).userId;
    Message message = new Message(userId, payload, messageType: type);
    _currentConversation.addMessage(message);

    Map<String, dynamic> messageData = {
      Assumptions.CONVERSATION_ID_KEY: _currentConversation.id,
      Assumptions.PAYLOAD_KEY: message.payload,
      Assumptions.SENDER_KEY: message.userID,
      Assumptions.MESSAGE_TYPE_KEY: message.messageType.index
    };
    
    await Supabase.instance.client.from("Messages").insert(messageData);
  }
}
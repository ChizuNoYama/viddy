import 'dart:async';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:viddy/enums/messageType.dart';
import 'package:viddy/models/conversation.dart';
import 'package:viddy/models/conversation_preivew_data.dart';
import 'package:viddy/models/message.dart';
import 'package:viddy/protocols/userProtocol.dart';
import 'package:viddy/core/assumptions.dart';

class ConversationProtocol {

  ConversationProtocol(this._userProtocol);

  UserProtocol _userProtocol;

  late List<String> _conversationIdList;
  List<String> get conversationIdList => _conversationIdList;

  Conversation _currentConversation = Conversation();
  Conversation get currentConversation => _currentConversation;

  late RealtimeChannel _channel; 

  Future<void> startOrContinueConversationAsync({List<String>? targetParticipants = null, Conversation? existingConversation = null}) async {
    if(existingConversation != null){
      _currentConversation = existingConversation;
    }
    else{
      assert(targetParticipants != null);
      Map<String, dynamic> result = await Supabase.instance.client
        .from("Conversations")
        .insert({Assumptions.PARTICIPANTS_KEY : targetParticipants})
        .select().single();
        _currentConversation = Conversation.toAppModel(result);
    }

    this.subscribeToChannel(_currentConversation.id);
  }

  void clearConversationData(){
    Supabase.instance.client.removeChannel(_channel);
    _currentConversation.dispose();
  }

  void subscribeToChannel(String conversationId){
     _channel = Supabase.instance.client.channel(
      "conversation:${conversationId}",
      opts: RealtimeChannelConfig(private: true, ack: true)
    )
    .onPostgresChanges(
      event: PostgresChangeEvent.all,
      schema: "public",
      table: "Messages",
      filter: PostgresChangeFilter(
        type: PostgresChangeFilterType.eq, 
        column: Assumptions.CONVERSATION_ID_KEY, 
        value: conversationId
      ),
      callback: (changePayload){
        print(changePayload);
        switch(changePayload.eventType){
          case PostgresChangeEvent.insert:
            Map<String,dynamic> dbMessage = changePayload.newRecord;
            if(dbMessage[Assumptions.SENDER_KEY] == _userProtocol.currentUser.userId){
              return;
            } // Check if the message was just the message that was sent by the currentUser
            
            Message message = Message.toAppModel(changePayload.newRecord);
            _currentConversation.addMessage(message); // Do no wait
            break;
          default:
              break;
        }
      }
    ).subscribe();
  }
  

//TODO: Get list of conversation Id's from the BE.
  Future<List<ConversationPreviewData>> getConversationsAsync() async{
    try{
      List<Map<String, dynamic>> result = await Supabase.instance.client.rpc("getConversations", params: {Assumptions.USER_ID_KEY: _userProtocol.currentUser.userId}).select();
      List<ConversationPreviewData> conversationPreivewList = List.empty(growable: true);
      result.forEach((map) {
        ConversationPreviewData preview = ConversationPreviewData.toAppModel(map);
        conversationPreivewList.add(preview);
      });
      return conversationPreivewList;
    } 
    catch(e){
      print (e);
      return List.empty();
    }
  }

  Future<Conversation?> getConversationMessagesAsync(String conversationId) async{
    try{
      List<Map<String, dynamic>> result = await Supabase.instance.client.rpc("getConversationMessages", params: {Assumptions.CONVO_ID_PARAM: conversationId});
      List<Message> messageList = List.empty(growable: true);
      result.forEach((map) {
        Message message = Message.toAppModel(map);
        messageList.add(message);
      });
      
      Conversation conversation = Conversation.fromConversationData(conversationId, messageList);
      // _currentConversation = conversation;
      return conversation;
    }
    catch(e){
      print(e);
      return null;
    }
  }

  Future<void> sendMessageAsync(String payload, {MessageType type = MessageType.Text}) async { // add status of message
    // Why are we awaiting the protocol to get the user
    String? userId = _userProtocol.currentUser.userId;
    Message message = new Message(userId, payload, messageType: type);
    _currentConversation.addMessage(message);

    Map<String, dynamic> messageData = message.toMap(_currentConversation.id);
    
    try{
      await Supabase.instance.client.from("Messages").insert(messageData);

      // BUG: When sending a braodcast message, This is not triggering our broadast listener
      ChannelResponse res = await _channel.sendBroadcastMessage(event: Assumptions.MESSAGE_SENT_EVENT, payload: messageData); 
    }
    catch(e){
      print(e);
    }
  }
}
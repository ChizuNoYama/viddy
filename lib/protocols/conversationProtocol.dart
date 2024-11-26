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

  Conversation? _currentConversation;
  Conversation? get currentConversation => _currentConversation;
  
  late WebSocketChannel _webSocketChannel;
  Stream get socketStream => _webSocketChannel.stream;

  // #endregion Properties

  Future<void> startNewConversationAsync(List<String> targetParticipants, {Conversation? existingConversation = null}) async {
    List<Map<String, dynamic>> result = await Supabase.instance.client
      .from("Conversations")
      .insert({
        "partcipants" : targetParticipants})
      .select();
      _currentConversation = Conversation.toAppModel(result[0]);
    // _currentConversation = existingConversation ?? new Conversation();
    
    // _webSocketChannel = WebSocketChannel.connect(Uri.parse(Assumptions.WEBSOCKET_API_URL));

    // try{
    //   String userID = (await _userProtocol.getUserAsync()).userId;

    //   _webSocketChannel.ready.then((_) {
    //     // Send information about ther conversation
    //     Map<String, dynamic> connectionData = {
    //       Assumptions.CONVERSATION_ACTION_KEY: ConversationAction.Start.index,
    //       Assumptions.CONVERSATION_ID_KEY: _currentConversation?.id,
    //       Assumptions.USER_ID_KEY: userID
    //     };

    //     String connectionJson = jsonEncode(connectionData);
    //     _webSocketChannel.sink.add(connectionJson);
    //   });
    // }
    // catch(err){
    //   print(err.toString());
    // }
    
    // _webSocketChannel.sink.done.onError((error, stackTrace) {
    //   print(error);
    // }).catchError((error){
    //   print(error);
    // }).then((value) {
    //   // check close reason
    //   print("Sink closed");
    // });

    // _webSocketChannel.stream.listen((value) async {
    //   // String text = utf8.decode(value); // Not neede since the data is in json format from the BE
    //   Map<String, dynamic> data = jsonDecode(value); // TODO: Convert to an object that can be deserialized easliy and not  have to be parsed here

    //   ConversationAction action = ConversationAction.values[data[Assumptions.CONVERSATION_ACTION_KEY] as int];
    //   switch (action){
    //     case ConversationAction.AddMessage:
    //       // Check if the message came from another user. If so, message will be added to conversation on the LHS.
    //       Message message = Message.fromJson(data[Assumptions.MESSAGE_KEY]);
    //       String? userId = (await _userProtocol.getUserAsync()).userId;
    //       if(message.userID != userId){
    //         print("Adding message sent from another user to the conversation");
    //         _currentConversation?.addMessage(message);
    //       }
    //       break;
    //     default:
    //       // do nothing
    //       break;
    //   }
    // },
    // onError: (error){
    //   print(error);
    // },
    // onDone: () {
    //   // TODO: Handle when the connection is severed from the other side
    //   // Check close reason
    //   print("Stream closed");
    // });
  }

//TODO: Get list of conversation Id's from the BE.
  Future<List<String>> getConversationIdList() async{
    
    return new List<String>.empty();
  }

  Future sendMessageWsAsync(String payload, {MessageType type = MessageType.Text}) async {
    String? userId = (await _userProtocol.currentUser).userId;
    Message message = new Message(userId, payload, messageType: type);
    _currentConversation?.addMessage(message);

    Map<String, dynamic> messageData = {
      Assumptions.CONVERSATION_ACTION_KEY: ConversationAction.AddMessage.index,
      Assumptions.CONVERSATION_ID_KEY: _currentConversation?.id,
      Assumptions.MESSAGE_KEY: message
    };
    String json = jsonEncode(messageData);
    _webSocketChannel.sink.add(json);
  }
}
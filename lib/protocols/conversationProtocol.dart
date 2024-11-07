
import 'dart:async';
import 'dart:convert';

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

  late Conversation? _currentConversation;
  Conversation? get currentConversation => _currentConversation;
  
  late WebSocketChannel _webSocketChannel;
  Stream get socketStream => _webSocketChannel.stream;

  void startNewConversation({Conversation? existingConversation = null}){
    if(existingConversation == null){
      _currentConversation = new Conversation();
    }
    else{
      _currentConversation = existingConversation;
    }
    
    _webSocketChannel = WebSocketChannel.connect(Uri.parse(Assumptions.WEBSOCKET_API_URL));
    _webSocketChannel.sink.done.onError((error, stackTrace) {
      print(error);
    }).catchError((error){
      print(error);
    }).then((value) {
      // check close reason
      print("Sink done");
    });

    _webSocketChannel.stream.listen((value){
      String text = utf8.decode(value);
      Map<String, dynamic> data = jsonDecode(text);
      
      String messageUserID = data['userID'];

      // Check if the message came from another user. If so, message will be added to conversation on the LHS.
      if(messageUserID != _userProtocol.getUser().userID){
        Message message = Message.toAppModel(data);
        _currentConversation?.addMessage(message);
      }
    },
    onError: (error){
      print(error);
    },
    onDone: () {
      // TODO: Handle when the connection is severed from the other side
      // Check close reason
      print("Stream finished");
    });

    Map<String, dynamic> conversationData = {
      Assumptions.CONVERSATION_ACTION_KEY: ConversationAction.Continue.index,
      Assumptions.CONVERSATION_ID_KEY: _currentConversation?.id
    };

    String conversationJson = jsonEncode(conversationData);
    _webSocketChannel.sink.add(conversationJson);
  }

  // TODO: Get the conversation from the Database. if it does not exist, throw an error or just start a new conversation
  void continueConversation(Conversation conversation){
    _currentConversation = conversation;

  }

  void closeConnection(){
    _webSocketChannel.sink.close();
  }

  Future sendMessageWsAsync(String payload, {MessageType type = MessageType.Text}) async {
    Message message = new Message(_userProtocol.getUser().userID, payload, messageType: type);
    _currentConversation?.addMessage(message);
    String jsonData = jsonEncode(message);
    _webSocketChannel.sink.add(jsonData);
  }
}
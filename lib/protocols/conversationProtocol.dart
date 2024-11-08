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

  void startNewConversation({Conversation? existingConversation = null}) async {
    if(existingConversation == null){
      _currentConversation = new Conversation();
    }
    else{
      _currentConversation = existingConversation;
    }
    
    _webSocketChannel = WebSocketChannel.connect(Uri.parse(Assumptions.WEBSOCKET_API_URL));

    try{
      // TODO: Handle errors
      _webSocketChannel.ready.then((_) {
        // Send information about ther conversation
        Map<String, dynamic> connectionData = {
          Assumptions.CONVERSATION_ACTION_KEY: ConversationAction.Start.index,
          Assumptions.CONVERSATION_ID_KEY: _currentConversation?.id,
          Assumptions.USER_ID_KEY: _userProtocol.getUser().userID
        };

        String connectionJson = jsonEncode(connectionData);
        _webSocketChannel.sink.add(connectionJson);
      });
    }
    catch(err){
      print(err.toString());
    }
    
    _webSocketChannel.sink.done.onError((error, stackTrace) {
      print(error);
    }).catchError((error){
      print(error);
    }).then((value) {
      // check close reason
      print("Sink closed");
    });

    _webSocketChannel.stream.listen((value){
      // String text = utf8.decode(value);
      Map<String, dynamic> data = jsonDecode(value); // TODO: Convert to an object that can be deserialized easliy and not  have to be parsed here

      ConversationAction action = ConversationAction.values[data[Assumptions.CONVERSATION_ACTION_KEY] as int];
      switch (action){
        case ConversationAction.AddMessage:
          // Check if the message came from another user. If so, message will be added to conversation on the LHS.
          Message message = Message.toAppModel(data[Assumptions.MESSAGE_KEY]);
          if(message.userID != _userProtocol.getUser().userID){
            print("Adding message sent from another user to the conversation");
            _currentConversation?.addMessage(message);
          }
          break;
        default:
          // do nothing
          break;
      }
    },
    onError: (error){
      print(error);
    },
    onDone: () {
      // TODO: Handle when the connection is severed from the other side
      // Check close reason
      print("Stream closed");
    });

    // Map<String, dynamic> conversationData = {
    //   Assumptions.CONVERSATION_ACTION_KEY: ConversationAction.Start.index,
    //   Assumptions.CONVERSATION_ID_KEY: _currentConversation?.id,
    //   Assumptions.USER_ID_KEY: _userProtocol.getUser().userID
    // };

    // String conversationJson = jsonEncode(conversationData);
    // _webSocketChannel.sink.add(conversationJson);
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
    Map<String, dynamic> messageData = {
      Assumptions.CONVERSATION_ACTION_KEY: ConversationAction.AddMessage.index,
      Assumptions.CONVERSATION_ID_KEY: _currentConversation?.id,
      Assumptions.MESSAGE_KEY: message
    };
    String json = jsonEncode(messageData);
    _webSocketChannel.sink.add(json);
  }
}
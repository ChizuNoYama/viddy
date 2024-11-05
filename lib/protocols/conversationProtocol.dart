
import 'dart:async';
import 'dart:convert';

import 'package:viddy/models/conversation.dart';
import 'package:viddy/models/message.dart';
import 'package:viddy/protocols/userProtocol.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:viddy/core/Assumptions.dart';

class ConversationProtocol {

  ConversationProtocol(this._userProtocol);

  UserProtocol _userProtocol;
  late Conversation _currentConversation;
  
  late WebSocketChannel _webSocketChannel;
  Stream get socketStream { return _webSocketChannel.stream;}

  void startConversation(Conversation conversation){
    _currentConversation = conversation;

    _webSocketChannel = WebSocketChannel.connect(Uri.parse(Assuimptions.WEBSOCKET_API_URL));

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
      
      String messageUserID = data['userID']!;
      if(messageUserID != _userProtocol.getUser().userID){
        Message message = Message.toAppModel(data);
        _currentConversation.addMessage(message);
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
  }

  void closeConnection(){
    _webSocketChannel.sink.close();
  }

  Future sendMessageWsAsync(String payload, {MessageType type = MessageType.Text}) async {
    Message message = new Message(_userProtocol.getUser().userID, payload, messageType: type);
    _currentConversation.addMessage(message);
    String jsonData = jsonEncode(message);
    _webSocketChannel.sink.add(jsonData);
  }
}
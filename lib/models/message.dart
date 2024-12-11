import 'package:viddy/core/assumptions.dart';
import 'package:viddy/enums/messageType.dart';

class Message{
  Message(this._userID, this._payload, {this.messageType = MessageType.Text});
  
  Message.toAppModel(Map<String, dynamic> map){
    _userID = map[Assumptions.SENDER_KEY] as String;
    _payload = map[Assumptions.PAYLOAD_KEY] as String;
    messageType = MessageType.values[map[Assumptions.MESSAGE_TYPE_KEY]! as int];
  }

  Map<String, dynamic> toMap(String conversationId){
    return {
      Assumptions.CONVERSATION_ID_KEY: conversationId,
      Assumptions.PAYLOAD_KEY: this.payload,
      Assumptions.SENDER_KEY: this.userID,
      Assumptions.MESSAGE_TYPE_KEY: this.messageType.index
    };
  }
  
  String? _userID;
  String? get userID => _userID; 

  late String _payload; // TODO: Create a helper to parse and present payload based on message type
  String get payload => _payload;

  MessageType messageType = MessageType.Text; // Private store is not used because this is an optional parameter in the constructor
}
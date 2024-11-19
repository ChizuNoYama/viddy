import 'package:viddy/core/assumptions.dart';
import 'package:viddy/enums/messageType.dart';

class Message{
  Message(this._userID, this._payload, {this.messageType = MessageType.Text});
  
  Message.fromJson(Map<String, dynamic> data)
    :_userID = data[Assumptions.USER_ID_KEY] as String,
    _payload = data[Assumptions.PAYLOAD_KEY] as String,
    messageType = MessageType.values[data[Assumptions.MESSAGE_TYPE_KEY]!];
  
  String? _userID;
  String? get userID => _userID; 

  String? _payload; // Maybe have this an object type that can be parsed based on the message type.
  String? get payload => _payload;

  MessageType messageType = MessageType.Text;

  Map<String, dynamic> toJson(){
    return {
      Assumptions.USER_ID_KEY: _userID,
      "payload": _payload,
      "messageType": messageType.index
    };
  }
}
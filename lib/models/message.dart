import 'package:viddy/enums/messageType.dart';

class Message{
  Message(this._userID, this._payload, {this.messageType = MessageType.Text});
  
  Message.toAppModel(Map<String, dynamic> data)
    :_userID = data["userID"] as String,
    _payload = data["payload"] as String,
    messageType = MessageType.values[int.parse(data["messageType"]!)];
  
  String? _userID;
  String? get userID => _userID; 

  String? _payload; // Maybe have this an object type that can be parsed based on the message type.
  String? get payload => _payload;

  MessageType messageType = MessageType.Text;

  Map<String, dynamic> toJson(){
    return {
      "userID": _userID,
      "payload": _payload,
      "messageType": messageType.index
    };
  }
}
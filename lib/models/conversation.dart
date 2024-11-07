import 'dart:collection';

import 'package:flutter/widgets.dart';
import 'package:uuid/uuid.dart';
import 'package:viddy/models/message.dart';

class Conversation extends ChangeNotifier{
  Conversation(){
    _id = new Uuid().v8();
  }
  Conversation.continueConversation(this._id, this._messages);

  String? _id;
  String? get id => _id;

  List<Message> _messages = [];
  UnmodifiableListView<Message> get messages => new UnmodifiableListView(_messages);

  addMessage(Message message){
    _messages.add(message);
    notifyListeners();
  }

  @override
  void dispose() {
    _messages.clear();
    super.dispose();
  }
}
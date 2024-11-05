import 'dart:collection';

import 'package:flutter/widgets.dart';
import 'package:viddy/models/message.dart';

class Conversation extends ChangeNotifier{
  // TODO: Add Conversation ID to be referenced and listed.
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
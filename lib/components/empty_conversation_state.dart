import 'package:flutter/material.dart';

class EmptyConversationState extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return Center(
      child: OutlinedButton(
        onPressed: null,
        child: Text("Start new Conversation")
      )
    );
  }
}
import 'package:flutter/material.dart';

class EmptyConversationState extends StatelessWidget{

  // TODO: Create a new page where you can add users to converse with

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
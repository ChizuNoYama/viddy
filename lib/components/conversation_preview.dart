import 'package:flutter/material.dart';
import 'package:viddy/models/conversation_preview_data.dart';

class ConversationPreview extends StatelessWidget{
  ConversationPreview(this.conversationPreviewData);
  
  final ConversationPreviewData conversationPreviewData;
  
  @override
  Widget build(BuildContext context) {

    return Row(
      children: [
        CircleAvatar(
          child: Icon(
            Icons.account_circle,
            size: 24,
          ),
        ),
        Expanded (
          child:Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                conversationPreviewData.participants.toString(),
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 16,
                )
              ),
              Text(
                overflow: TextOverflow.ellipsis,
                conversationPreviewData.lastMessage
              )
            ]
          )
        )
      ],
    );
  }
}
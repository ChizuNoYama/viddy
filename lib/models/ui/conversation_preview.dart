class ConversationPreview {
  ConversationPreview(this._conversationId, this._lastMessage);

  final String _conversationId;
  String get conversationId => _conversationId;
  
  final String _lastMessage;
  String get firstMessage => _lastMessage;
}
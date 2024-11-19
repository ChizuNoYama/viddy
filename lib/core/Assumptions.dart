class Assumptions{
  static const String API_URL = "http://localhost:3000"; // TODO: unencrypted. Eventually use https
  static const String WEBSOCKET_API_URL = "ws://localhost:8080"; // TODO: unencrypted. eventually us wss

  static const String CONVERSATION_ID_KEY = "conversationId";
  static const String CONVERSATION_ACTION_KEY = "conversationAction";
  static const String MESSAGE_KEY = "message";
  static const String USER_ID_KEY = "userId";
  static const String USER_KEY = "user";
  static const String PAYLOAD_KEY = "payload";
  static const String MESSAGE_TYPE_KEY = "messageType";
}
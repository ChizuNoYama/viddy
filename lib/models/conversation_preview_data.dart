import 'package:viddy/core/assumptions.dart';
import 'package:viddy/enums/messageType.dart';

class ConversationPreviewData{
  ConversationPreviewData.toAppModel(Map<String, dynamic> map){
    _lastMessage = map[Assumptions.PAYLOAD_KEY] as String;
    _date = (map[Assumptions.CREATED_AT_KEY] as String).split("T")[0]; // DB returns format with the date and time separated by space. Get only the date
    _participants = (map[Assumptions.PARTICIPANTS_KEY] as List<dynamic>).cast<String>();
    _messageType = MessageType.values[map[Assumptions.MESSAGE_TYPE_KEY]! as int];
    _conversationId = map[Assumptions.CONVERSATION_ID_KEY] as String;
  }

  String _conversationId = "";
  String get conversationId => _conversationId;

  String _lastMessage = "";
  String get lastMessage => _lastMessage;
  
  String _date = DateTime(0).toString();  // TODO: Convert this to a correct date format
  String get date => _date;

  List<String> _participants = List.empty();
  List<String> get participants => _participants;

  MessageType _messageType = MessageType.Text;
  MessageType get messageType => _messageType;
}
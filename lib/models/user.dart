import 'package:uuid/uuid.dart';

class User{
  
  User(this._userID);
  User.initialize(): _userID = new Uuid().v8();

  String _userID;
  String get userID => _userID;

}
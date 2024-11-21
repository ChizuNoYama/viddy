import 'package:uuid/uuid.dart';
import 'package:viddy/core/assumptions.dart';

class User{
  
  User(this._userID);
  User.initialize(): _userID = new Uuid().v8();
  User.toAppModel(Map<String, dynamic> data): _userID = data[Assumptions.USER_ID_KEY] as String;


  String _userID;
  String get userId => _userID;

  Map<String, dynamic> toMap(){
    return {
      Assumptions.USER_ID_KEY: _userID
    };
  }

}
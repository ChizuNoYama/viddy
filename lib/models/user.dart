import 'package:viddy/core/assumptions.dart';

class User{
  
  User(this._userID, this._userName);
  User.toAppModel(Map<String, dynamic> data){
     _userID = data[Assumptions.ID_KEY] as String;
     _userName = data[Assumptions.USER_NAME_KEY] as String;
  }

  late String _userID;
  String get userId => _userID;

  late String _userName;
  String get userName => _userName;
  void set userName(name) => _userName = name;

  Map<String, dynamic> toMap(){
    return {
      // Assumptions.ID_KEY: null, // Do not want this to be sent when updating or inserting users. DB will automatically get this from the auth table
      Assumptions.USER_NAME_KEY: _userName
    };
  }

}
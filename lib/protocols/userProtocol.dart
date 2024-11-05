import 'package:viddy/models/user.dart';

class UserProtocol{

  User? _currentUser;

  User getUser(){
    if(_currentUser == null){
      _currentUser = User.initialize(); // Or throw if the user is not initialized to enforce user object state
    }
      return _currentUser!;
  }

}
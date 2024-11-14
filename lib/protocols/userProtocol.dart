
import 'package:viddy/core/preferencesHelper.dart';
import 'package:viddy/models/user.dart';

class UserProtocol{

  User? _currentUser;

  UserProtocol();

  Future<void>initializeAsync() async{
    // TODO: Find the user ID in local DB/SharedPreferences
    _currentUser = await PreferencesHelper.getUser();
  }

  User getUser(){
    if(_currentUser == null){
      _currentUser = User.initialize(); // Or throw if the user is not initialized to enforce user object state
      PreferencesHelper.setUser(_currentUser!);
    }
      return _currentUser!;
  }

}

import 'package:viddy/core/preferencesHelper.dart';
import 'package:viddy/models/user.dart';

class UserProtocol{

  User? _currentUser;

  UserProtocol();

  Future<User> getUserAsync() async{
    if(_currentUser == null){
      _currentUser = await PreferencesHelper.getUser();
      // Check if user is null once more
      if(_currentUser == null){
        _currentUser = User.initialize();
        await PreferencesHelper.setUser(_currentUser!);
      }
    }
      return _currentUser!;
  }

}
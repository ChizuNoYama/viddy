
import 'package:supabase_flutter/supabase_flutter.dart' as supa;
import 'package:viddy/core/preferencesHelper.dart';
import 'package:viddy/models/registerInfo.dart';
import 'package:viddy/models/user.dart';

class UserProtocol{

  UserProtocol();

  late User _currentUser;
  User get currentUser => _currentUser;

  RegisterInfo _registerInfo = new RegisterInfo();
  RegisterInfo get registerInfo =>_registerInfo;

  Future<User> initializeUser() async{
    User? user = await PreferencesHelper.getUser();
    // Check if user is saved.
    if(user == null){
      Map<String, dynamic> userData = (await supa.Supabase.instance.client.from("Users").insert({}).select())[0];
      user = User.toAppModel(userData);
      await PreferencesHelper.setUser(user);
    }
    _currentUser = user;
    return _currentUser;
  }

  Future<bool>loginUser({required String email, required String  password}) async{
    try{
      supa.AuthResponse res = await supa.Supabase.instance.client.auth.signInWithPassword(email: email, password: password);
      if(res.user == null){
        return false;
      }
        _currentUser = new User(res.user!.id);
        return true;
    }
    on supa.AuthException catch(ex){
      // TODO: log exception
      return false;
    }
  }
}

import 'package:supabase_flutter/supabase_flutter.dart' as supa;
import 'package:viddy/core/assumptions.dart';
import 'package:viddy/core/preferencesHelper.dart';
import 'package:viddy/models/registerInfo.dart';
import 'package:viddy/models/user.dart';

class UserProtocol{

  UserProtocol();

  late User _currentUser;
  User get currentUser => _currentUser;

  RegisterInfo _registerInfo = new RegisterInfo();
  RegisterInfo get registerInfo =>_registerInfo;

  Future<User> initializeUserAsync() async{
    User? user = await PreferencesHelper.getUserAsync();
    // Check if user is saved.
    if(user == null){
      supa.UserResponse res = await supa.Supabase.instance.client.auth.getUser();
      user = _currentUser = new User(res.user!.id, res.user!.userMetadata?[Assumptions.USER_NAME_KEY]);
      PreferencesHelper.setUserAsync(user); // Do not wait
    }
    _currentUser = user;
    return _currentUser;
  }

  Future<bool> loginOrRegisterUserAsync({required bool isNewUser}) async{
    try{
      // Check for password fields
      if(isNewUser &&_registerInfo.password != _registerInfo.confirmedPassword){
        return false;
      }

      supa.AuthResponse res;
      if(isNewUser){
        res = await supa.Supabase.instance.client.auth.signUp(
          email: _registerInfo.email, 
          password: _registerInfo.password!,
          data: { Assumptions.USER_NAME_KEY: _registerInfo.userName }
        );
      }
      else{
        res = await supa.Supabase.instance.client.auth.signInWithPassword(email: _registerInfo.email, password: _registerInfo.password!);
      }
      if(res.user == null){
        return false;
      }

      User user = new User(res.user!.id, res.user!.userMetadata?[Assumptions.USER_NAME_KEY]);

      // Check for new User again to upload to the public DB
      if(isNewUser){
        Map<String, dynamic> userMap = user.toMap();
        Map<String, dynamic> responseMap = await supa.Supabase.instance.client.from("Users").insert(userMap).select().single();
        if(responseMap.isEmpty){
          // TODO: have a retry mechanism here
        }
      }

      _currentUser = user;
      PreferencesHelper.setUserAsync(_currentUser); // Do not wait
      return true;
    }
    on supa.AuthException catch(ex){
      print(ex.message);
      return false;
    }
    catch(ex){
      print(ex.toString());
      return false;
    }
  }

  Future<bool> updateUserName(String userName) async{
    _currentUser.userName = userName;
    Map<String, dynamic> userMap = _currentUser.toMap();
    Map<String, dynamic> response = await supa.Supabase.instance.client.from("Users").upsert(userMap).select().single();

    if(response.isEmpty){
      return false;
    }
    return true;
  }
}
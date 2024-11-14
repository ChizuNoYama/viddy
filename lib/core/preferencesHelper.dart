import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:viddy/core/assumptions.dart';
import 'package:viddy/models/user.dart';

class PreferencesHelper {
  
  static Future<User?> getUser() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? userString = await preferences.getString(Assumptions.USER_KEY);
    
    if(userString == null){
      return null;
    }
    User? user = jsonDecode(userString) as User?;
    return user;
  }

  static Future<void> setUser(User user) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String dataString = jsonEncode(user);
    preferences.setString(Assumptions.USER_KEY, dataString);
  }
}
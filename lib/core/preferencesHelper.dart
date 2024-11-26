import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:viddy/core/assumptions.dart';
import 'package:viddy/models/user.dart';

class PreferencesHelper {
  
  static Future<User?> getUserAsync() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? userString = await preferences.getString(Assumptions.USER_KEY);
    
    if(userString == null){
      return null;
    }
  
    User? user = User.toAppModel(jsonDecode(userString));
    return user;
  }

  static Future<void> setUserAsync(User user) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String dataString = jsonEncode(user.toMap());
    preferences.setString(Assumptions.USER_KEY, dataString);
  }
}
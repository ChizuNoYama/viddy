import 'package:flutter/material.dart';

class NavigationHelper {
  static Future goToAsync<T>(context, Widget page, {bool replacePreviousRoute = false}) {
    if(replacePreviousRoute){
      return Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (context) => page));  
    }
    return Navigator.of(context).push(new MaterialPageRoute(builder: (context) => page));
  }

  static Future showModalFullPageModalAsync(context, Widget modal){
    return Navigator.of(context).push(new MaterialPageRoute(fullscreenDialog: true, builder: (context) => modal));
  }
}
import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';


class Utils {

  static const String REGISTER="REGISTER";

  static const String GO_LOGIN="Already Member";

  static Future<String> readString()async {
    SharedPreferences preferences=await SharedPreferences.getInstance();
    if(preferences!=null&&preferences.getString("ID")!=null) {
      return preferences.getString("ID");
    }else{
      return null;
    }
  }
  static Future<bool> clearString()async {
    SharedPreferences preferences=await SharedPreferences.getInstance();
    return preferences.clear();
  }
}

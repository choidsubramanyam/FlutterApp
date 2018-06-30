import 'dart:async';

import 'package:firs_flutter_app/ui/GetTechnologies.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firs_flutter_app/ui/RegistrationPage.dart';

class SplashScreenView extends StatefulWidget {
  @override
  State <StatefulWidget> createState() {
    return new _SplashScreenState();
  }
}

class _SplashScreenState extends State<SplashScreenView>{
  @override
  void initState() {
    super.initState();
    startTime();
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(
        child: new Image.asset('images/quiz_logo.jpg'),
      ),
    );
  }

  Future goToNextScreen() async {
    SharedPreferences preferences= await SharedPreferences.getInstance();
    if(preferences!=null&&preferences.getString("ID")!=null){
      print(preferences.getString("ID"));
      goToListView();
    }else{
      Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (BuildContext context) => new RegistrationPage()));
    }
  }

  goToListView() {
    Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (BuildContext context) => new GetTechnologiesList(title: "Technologies List",)));
  }
  startTime() async {
    var _duration = new Duration(seconds: 5);
    return new Timer(_duration, goToNextScreen);
  }
}

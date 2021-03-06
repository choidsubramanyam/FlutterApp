import 'dart:convert';

import 'package:firs_flutter_app/ui/GetTechnologies.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart';
import 'package:connectivity/connectivity.dart';
import './ui/RegistrationPage.dart';
import './ui/SplashScreen.dart';
void main() {


  return runApp( MyApp());
}


class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return new MaterialApp(
      title: 'Login',
      theme: new ThemeData(
        textSelectionColor: Colors.black87,
        primarySwatch: Colors.indigo,
        hintColor: Colors.black,
        buttonColor: Colors.indigo,

      ),
     // home: new MyHomePage(title: 'Login Page'),

      home: new SplashScreenView(),

    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);


  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController usernameController=new TextEditingController();

  final TextEditingController _passwordController=new TextEditingController();

  final _userNameFocus= new FocusNode();

  final _passwordFocus =new FocusNode();

  final _formKey= GlobalKey<FormState>();

  final _scaKey= GlobalKey<ScaffoldState>();

  var status;

  StreamSubscription<ConnectivityResult> subscription;


  @override
  void initState() {
    iniConnecctivity();
    subscription = new Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      // Got a new connectivity status!
      print('subscription ${result.toString()}');
      setState(() {
        iniConnecctivity().then((value){
          status= value.toString();
        });

      });
    });
    super.initState();

  }
  @override
  void dispose() {
    subscription.pause();
    super.dispose();
  }

  
  @override
  Widget build(BuildContext context) {

    return new WillPopScope(
      onWillPop: _requestPop,
      child: new Scaffold(
        key: _scaKey,
        appBar: new AppBar(
          title:  Text(widget.title),
          centerTitle: true,
        ),
        body: new ListView(
          children: <Widget>[
            Form(
              key:_formKey,
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                    internet(context, status),
                    new Container(
                      child: new Column(
                        children: <Widget>[
                          new Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: new TextFormField(
                                controller: usernameController,
                                focusNode: _userNameFocus,
                                onFieldSubmitted: (text){
                                  usernameController.text=text;
                                  FocusScope.of(context).requestFocus(_passwordFocus);
                                },
                                validator: (mobile){
                                  if(mobile.length<10){
                                    return 'Enter Valid Mobile Number';
                                  }
                                },
                                autovalidate: _userNameFocus.hasFocus?true:false,

                                keyboardType: TextInputType.number,
                                maxLength: 10,
                                decoration: new InputDecoration(

                                    border: new OutlineInputBorder(
                                      borderSide: new BorderSide(color: Colors.indigo,width: 4.0)
                                     // borderRadius: new BorderRadius.all(new Radius.circular(16.0))
                                    ),
                                    labelText: "Mobile Number",
                                    hintText: "Ex : 8184870282",
                                    prefixIcon: new Icon(
                                        Icons.person
                                    ),
                                )
                            ),
                          ),
                          new Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: new TextFormField(
                                controller: _passwordController,
                                focusNode: _passwordFocus,
                                validator: (pwd){
                                  if(pwd.length<=2){
                                    return 'Please Enter Valid Password';
                                  }
                                },
                                autovalidate: _passwordFocus.hasFocus?true:false,
                                obscureText: true,
                                decoration: new InputDecoration(
                                    border: new OutlineInputBorder(
                                      //  borderRadius: new BorderRadius.all(new Radius.circular(16.0))
                                    ),
                                    labelText: "Password",
                                    hintText: "",
                                    prefixIcon: new Icon(
                                        Icons.lock
                                    )
                                )
                            ),
                          ),
                          new Container(
                            width: 380.0,
                            padding: const EdgeInsets.all(8.0),
                            child: new RaisedButton(
                              padding: const EdgeInsets.all(16.0),
                              splashColor: Colors.white,
                              shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.all(new Radius.circular(8.0))),
                              color: Colors.indigo,
                              onPressed: () {
                                iniConnecctivity().then((value)async {
                                  if(value!='ConnectivityResult.none'){
                                    if(_formKey.currentState.validate()) {
                                      bool value = await _click(context, usernameController.text,
                                          _passwordController.text);
                                      if(value){
                                        Navigator.pop(context);
                                        Navigator.pushReplacement(context,new MaterialPageRoute(builder: (BuildContext context) => new GetTechnologiesList(title: "Technologies List",)));
                                      }else{
                                        showDialog(context: context,builder: (BuildContext context) => alertDialog(context, "Invalid Details"));
                                      }
                                    }else{
                                      _scaKey.currentState.showSnackBar(SnackBar(content: Text("Enter Valid Details")));
                                    }
                                  }else{
                                    showDialog(context:context,builder: (BuildContext context) => alertDialog(context, "No Interent"));
                                  }
                                });
                               
                              },
                              child: const Text("LOGIN",style: const TextStyle(
                                color: Colors.white
                              ),),
                            ),
                          )
                        ],
                      ),
                    )
                ],
              ),
            ),
          ],
        )
        // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }

  Future<bool> _click(BuildContext context,String number,String password) async {
    showDialog(context: context,builder: (BuildContext context) => _dialog() ,barrierDismissible: false);
    Map request=new Map();
    request['action']='login_user';
    request['mobile']='$number';
    request ['pswrd']='$password';

    Map data= await _performLogin(request);

   if(data['response']=='success'){
     saveData(data);
     print(data);
     return true;
   }else{
     Navigator.pop(context);
     return false;
   }

  }

  Future<Map> _performLogin(Map request) async {
    print(request);
     final response= await http.post("http://androindian.com/apps/quiz/api.php",
      body: json.encode(request)
    );
     print(response.body);
    return json.decode(response.body);
  }

  Widget _dialog() {
    return new Center(
      child: new Container(
        child: new CircularProgressIndicator(

        ),
      ),
    );
  }

  Future<bool> _requestPop() {
    /*Navigator.pop(_scaKey.currentContext);*/
    return new Future.value(true);
  }

  goToListView()  {
    Navigator.pushReplacement(_scaKey.currentContext,new MaterialPageRoute(builder: (BuildContext context) => new GetTechnologiesList(title: "Technologies List",)));
    // Navigator.replace(context, oldRoute: context, newRoute: new MaterialPageRoute(builder: (BuildContext context) => new GetTechnologiesList(title: "Technologies List",)));
  }

  Future saveData(Map data) async {

    SharedPreferences preferences=await SharedPreferences.getInstance();
    preferences.setString("USER_NAME", data['data']['USER_NAME']);
    preferences.setString("MOBILE", data['data']['MOBILE']);
    preferences.setString("EMAIL", data['data']['EMAIL']);
    preferences.setString("ID", data['data']['ID']);

  }
}
Widget internet(BuildContext context, String status)  {
  bool show =false;
  iniConnecctivity().then((value){
    status = value.toString();
    print('inside int $value');
  });
  if(status == 'ConnectivityResult.none'){
    show =true;
  }
  return new Column(
    children: <Widget>[
      show?
      new Container(
        color: Colors.red,
        height: 50.0,
        width: 380.0,
        child: new Center(child: new Text("No Internet", textAlign: TextAlign.center)),
      ):null

    ].where((Object o) => o != null).toList(),
  );
  /*if(status == 'ConnectivityResult.none') {
      bool show =true;
      return new Column(
        children: <Widget>[
        show?
          new Container(
            color: Colors.red,
            height: 50.0,
            width: 380.0,
            child: new Center(child: new Text("No Internet", textAlign: TextAlign.center)),
          ):null

        ].where(notNull).toList(),
      );
    }
    return null;*/
}


Future<String> iniConnecctivity() async {
  var connectivity = await (new Connectivity().checkConnectivity());
  print(connectivity.toString());
  return connectivity.toString();
}
 
registerUser(BuildContext context,String userName, String mobileNumber, String email, String password) async {
  var registerObject=new Map();
  registerObject['name']=userName;
  registerObject['mobile']=mobileNumber;
  registerObject['email']=email;
  registerObject['pswrd']=password;
  /*registerObject['fcm']="sasyugu";*/
  registerObject['action']='register_user';
  
  Map result= await performRegistration(registerObject);
  print(registerObject);
  Navigator.pop(context);
  if(result!=null){
    if(result['response']=='success'){
      showDialog(context: context,builder: (BuildContext context) => alertDialog(context,result['user']));
    }else if(result['response']=='failed'){
      showDialog(context: context,builder: (BuildContext context) => alertDialog(context,result['user']));
    }
    
  }
}

Widget alertDialog(BuildContext context, result) {
  return new AlertDialog(
    title: Text("Response From Server"),
    content: Text(result.toString()!=null?result.toString().toUpperCase():"No Response",style: new TextStyle(
      color: Colors.red,
      fontStyle: FontStyle.normal
    ),),
    actions: <Widget>[
      new FlatButton(onPressed:() {
        Navigator.of(context).pop();},
          child: new Text("Ok")
      ),
      /*new FlatButton(onPressed:() {
        Navigator.of(context).pop();
        Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new MyHomePage(title: "Login",)));},
          child: new Text("Login")
      )*/

    ],
  );

}

Future<Map> performRegistration(Map registerObject) async {

  final response = await http.post("http://androindian.com/apps/quiz/api.php",body: json.encode(registerObject));
  print(response.body);
  return json.decode(response.body);
}
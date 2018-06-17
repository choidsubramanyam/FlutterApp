import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Login',
      theme: new ThemeData(

        primarySwatch: Colors.blue,
      ),
     // home: new MyHomePage(title: 'Login Page'),
      home: new RegistrationPage(),
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

  
  @override
  Widget build(BuildContext context) {
    TextEditingController usernameController=new TextEditingController();

    TextEditingController _passwordController=new TextEditingController();

    String number,password;



    return new Scaffold(
      appBar: new AppBar(
        title:  Text(widget.title),
        centerTitle: true,
      ),
      body: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Container(
            padding: const EdgeInsets.only(left: 16.0,right: 16.0),
            child: new Column(
              children: <Widget>[
                new Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: new TextField(
                      autofocus: true,
                      controller: usernameController,
                      keyboardType: TextInputType.number,
                      maxLength: 10,
                      decoration: new InputDecoration(
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.all(new Radius.circular(16.0))
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
                  child: new TextField(
                      autofocus: true,
                      controller: _passwordController,
                      obscureText: true,
                      decoration: new InputDecoration(
                          border: new OutlineInputBorder(
                              borderRadius: new BorderRadius.all(new Radius.circular(16.0))
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
                    shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.all(new Radius.circular(8.0))),
                    color: Colors.red,
                    onPressed: () {

                       number=usernameController.text;
                       password=_passwordController.text;
                       _click(context,number,password);

                       showDialog(context: context,builder: (BuildContext context) => _dialog() ,barrierDismissible: false);
                    },
                    child: const Text("Login"),
                  ),
                )
              ],
            ),
          )
        ],
      )
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  _click(BuildContext context,String number,String password) async {
    Map request=new Map();
    request['action']='login_user';
    request['mobile']='$number';
    request ['pswrd']='$password';

    Map data= await _performLogin(request);

   if(data['response']=='success'){

     Navigator.pop(context);
     print(data);
   }

  }

  Future<Map> _performLogin(Map request) async {

     final response= await http.post("http://androindian.com/apps/reminder/api.php",
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
}

class RegistrationPage extends StatefulWidget{

  @override
  _RegistrationPageState createState() => new _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage>  {
  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      appBar: new AppBar(
        title: Text("Registration"),
        centerTitle: true,
      ),
      body: new RegistrationView(),

    );

  }

}

class RegistrationView extends StatelessWidget{

  var usernameController = new TextEditingController();

  var _passwordController= new TextEditingController();

  var _emailController =new TextEditingController();

  var _mobileNumberController = new TextEditingController();

  var _userNameFocus= new FocusNode();

  var _mobileNumber = new FocusNode();

  var _emailFocus =new FocusNode();

  var _passwordFocus= new FocusNode();


  @override
  Widget build(BuildContext context) {
    return new ListView(
      children: <Widget>[
        new Column(
          children: <Widget>[
            new Padding(
              padding: const EdgeInsets.only(left: 8.0,right: 8.0,top: 16.0,bottom: 8.0),
              child: new TextField(
                  autofocus: true,
                  controller: usernameController,
                  keyboardType: TextInputType.text,
                  focusNode: _userNameFocus,
                  onSubmitted: (text){
                    FocusScope.of(context).requestFocus(_mobileNumber);
                  },
                  decoration: new InputDecoration(
                    border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.all(new Radius.circular(16.0))
                    ),
                    labelText: "User Name",
                    hintText: "Ex : Subramanyam",
                    prefixIcon: new Icon(
                        Icons.person
                    ),
                  )
              ),
            ),
            new Padding(
              padding: const EdgeInsets.all(8.0),
              child: new TextField(
                  autofocus: true,
                  controller: _mobileNumberController,
                  keyboardType: TextInputType.number,
                  focusNode: _mobileNumber,
                  onSubmitted: (text) => FocusScope.of(context).requestFocus(_emailFocus),
                  obscureText: false,
                  maxLength: 10,
                  decoration: new InputDecoration(
                      border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.all(new Radius.circular(16.0))
                      ),
                      labelText: "Mobile Number",
                      hintText: "Ex : 8184870282",
                      prefixIcon: new Icon(
                          Icons.phone
                      )
                  )
              ),
            ),
            new Padding(
              padding: const EdgeInsets.all(8.0),
              child: new TextField(
                  autofocus: true,
                  controller: _emailController,
                  focusNode: _emailFocus,
                  onSubmitted: (text) => FocusScope.of(context).requestFocus(_passwordFocus),
                  obscureText: false,
                  keyboardType: TextInputType.emailAddress,
                  decoration: new InputDecoration(
                      border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.all(new Radius.circular(16.0))
                      ),
                      labelText: "Email",
                      hintText: "",
                      prefixIcon: new Icon(
                          Icons.email
                      )
                  )
              ),
            ),
            new Padding(
              padding: const EdgeInsets.all(8.0),
              child: new TextField(
                  autofocus: true,
                  controller: _passwordController,
                  focusNode: _passwordFocus,
                  obscureText: true,
                  decoration: new InputDecoration(
                      border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.all(new Radius.circular(16.0))
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
                shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.all(new Radius.circular(8.0))),
                color: Colors.red,
                onPressed: () {
                 // Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (BuildContext context) => new MyHomePage(title: "Login",)));
                  showDialog(context: context,builder: (BuildContext context) => _dialog() ,barrierDismissible: false);
                  registerUser(context,usernameController.text,_mobileNumberController.text,_emailController.text,_passwordController.text);
                },
                child: const Text("Register"),
              ),
            )
          ],
        )
      ],
    );
  }
  Widget _dialog() {
    return new Center(
      child: new Container(
        child: new CircularProgressIndicator(

        ),
      ),
    );
  }
}
 
registerUser(BuildContext context,String userName, String mobileNumber, String email, String password) async {
  var registerObject=new Map();
  registerObject['name']=userName;
  registerObject['mobile']=mobileNumber;
  registerObject['email']=email;
  registerObject['pswrd']=password;
  registerObject['fcm']="sasyugu";
  registerObject['action']='register_user';
  
  Map result= await performRegistration(registerObject);
  Navigator.pop(context);
  if(result!=null){
    if(result['response']=='success'){
      showDialog(context: context,builder: (BuildContext context) => _alertDialog(context,result['title']));
    }else if(result['response']=='failed'){
      showDialog(context: context,builder: (BuildContext context) => _alertDialog(context,result['title']));
    }
    
  }
}

Widget _alertDialog(BuildContext context, result) {
  return new AlertDialog(
    title: Text("Response From Server"),
    content: Text(result.toString()!=null?result.toString().toUpperCase():"No Response",style: new TextStyle(
      color: Colors.red,
      fontStyle: FontStyle.normal
    ),),
    actions: <Widget>[
      new FlatButton(onPressed:() =>  Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new MyHomePage(title: "Login",))), child: new Text("Login"))
    ],
  );

}

Future<Map> performRegistration(Map registerObject) async {
  
  final response = await http.post("http://androindian.com/apps/reminder/api.php",body: json.encode(registerObject));
  print(response.body);
  return json.decode(response.body);
}
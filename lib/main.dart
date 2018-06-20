import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:connectivity/connectivity.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Login',
      theme: new ThemeData(
        textSelectionColor: Colors.black87,
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
  final TextEditingController usernameController=new TextEditingController();

  final TextEditingController _passwordController=new TextEditingController();

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

    String number,password;

    return new WillPopScope(
      onWillPop: _requestPop,
      child: new Scaffold(
        appBar: new AppBar(
          title:  Text(widget.title),
          centerTitle: true,
        ),
        body: new ListView(
          children: <Widget>[
            new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                  internet(context, status),
                  new Container(
                    padding: const EdgeInsets.only(left: 8.0,right: 8.0),
                    child: new Column(
                      children: <Widget>[
                        new Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: new TextField(
                              onSubmitted: (text){
                                usernameController.text=text;
                              },
                              controller: usernameController,
                              keyboardType: TextInputType.number,
                              maxLength: 10,
                              decoration: new InputDecoration(
                                  border: new OutlineInputBorder(
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
                          child: new TextField(

                              controller: _passwordController,
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
                            shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.all(new Radius.circular(8.0))),
                            color: Colors.red,
                            onPressed: () {
                              setState(() {

                              });
                              Navigator.push(context,new MaterialPageRoute(builder: (BuildContext context) => new RegistrationPage()));

                              /* number=usernameController.text;
                               password=_passwordController.text;
                               _click(context,number,password);
                               showDialog(context: context,builder: (BuildContext context) => _dialog() ,barrierDismissible: false);*/
                            },
                            child: const Text("Login"),
                          ),
                        )
                      ],
                    ),
                  )
              ],
            ),
          ],
        )

        // This trailing comma makes auto-formatting nicer for build methods.
      ),
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

  Future<bool> _requestPop() {

    return new Future.value(true);
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

class RegistrationView extends StatefulWidget{



  @override
  RegistrationViewState createState() {
    return new RegistrationViewState();
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

class RegistrationViewState extends State<RegistrationView> {

  final  _usernameController = new TextEditingController();

  final _passwordController= new TextEditingController();

  final _emailController =new TextEditingController();

  final _mobileNumberController = new TextEditingController();

  final _userNameFocus= new FocusNode();

  final _mobileNumber = new FocusNode();

  final _emailFocus =new FocusNode();

  final _passwordFocus= new FocusNode();
  var connectivity;
  var status="no";
  StreamSubscription<ConnectivityResult> subscription;

  @override
  void initState() {

      iniConnecctivity();
      registerSubscription();
      subscription = new Connectivity().onConnectivityChanged.listen((
          ConnectivityResult result) {
        // Got a new connectivity status!
        print('subscription ${result.toString()}');
        setState(() {
          iniConnecctivity().then((value) {
            status = value.toString();
          });
        });
      });


    try {
      super.initState();
    }catch(Exception){

    }

  }
  @override
  void dispose() {
    subscription.pause();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new ListView(

        children: <Widget>[
          new Column(
            children: <Widget>[
              internet(context,status),
              new Padding(
                padding: const EdgeInsets.only(left: 8.0,right: 8.0,top: 16.0,bottom: 8.0),
                child: new TextField(

                    controller: _usernameController,
                    keyboardType: TextInputType.text,

                    onSubmitted: (text) => FocusScope.of(context).requestFocus(_mobileNumber),
                    decoration: new InputDecoration(
                      border: new OutlineInputBorder(
                        //  borderRadius: new BorderRadius.all(new Radius.circular(16.0))
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

                    controller: _mobileNumberController,
                    keyboardType: TextInputType.number,

                    focusNode: _mobileNumber,
                    onSubmitted: (text) => FocusScope.of(context).requestFocus(_emailFocus),
                    obscureText: false,
                    maxLength: 10,
                    decoration: new InputDecoration(
                        border: new OutlineInputBorder(
                          //  borderRadius: new BorderRadius.all(new Radius.circular(16.0))
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

                    controller: _emailController,
                    focusNode: _emailFocus,

                    onSubmitted: (text) => FocusScope.of(context).requestFocus(_passwordFocus),
                    obscureText: false,
                    keyboardType: TextInputType.emailAddress,
                    decoration: new InputDecoration(
                        border: new OutlineInputBorder(
                          //  borderRadius: new BorderRadius.all(new Radius.circular(16.0))
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

                    controller: _passwordController,
                    focusNode: _passwordFocus,

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
                  shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.all(new Radius.circular(8.0))),
                  color: Colors.red,
                  onPressed: () async {

                    /*iniConnecctivity().then((value){
                      if(value != 'ConnectivityResult.none'){
                        showDialog(context: context,builder: (BuildContext context) => widget._dialog() ,barrierDismissible: false);
                        registerUser(context,_usernameController.text,_mobileNumberController.text,_emailController.text,_passwordController.text);
                      }else{
                        showDialog(context: context,builder: (BuildContext context) => _alertDialog(context,"No Internet"));
                      }
                    });*/



                    bool reload= await Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new MyHomePage(title: "Login",)));
                    if(reload==null){
                      print(reload);

                      initState();
                    }
                    //

                    // registerUser(context,_usernameController.text,_mobileNumberController.text,_emailController.text,_passwordController.text);
                  },
                  child: const Text("REGISTER",style: const TextStyle(
                      color: Colors.white,
                      fontStyle: FontStyle.normal
                  ),),
                ),
              )
            ],
          )
        ],
      );



  }

  void registerSubscription() {

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
  /*subscription = new Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
    // Got a new connectivity status!
    print('subscription ${result.toString()}');

  });*/

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
  registerObject['fcm']="sasyugu";
  registerObject['action']='register_user';
  
  Map result= await performRegistration(registerObject);
  print(registerObject);
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
      new FlatButton(onPressed:() {
        Navigator.of(context).pop();},
          child: new Text("Cancel")
      ),
      new FlatButton(onPressed:() {
        Navigator.of(context).pop();
        Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new MyHomePage(title: "Login",)));},
          child: new Text("Login")
      )

    ],
  );

}

Future<Map> performRegistration(Map registerObject) async {

  final response = await http.post("http://androindian.com/apps/reminder/api.php",body: json.encode(registerObject));
  print(response.body);
  return json.decode(response.body);
}
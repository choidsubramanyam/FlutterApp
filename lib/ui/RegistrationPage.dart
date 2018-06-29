import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:firs_flutter_app/main.dart';
import 'package:firs_flutter_app/ui/GetTechnologies.dart';
import 'package:firs_flutter_app/ui/ListViewSample.dart';
import 'package:flutter/material.dart';
import './utils.dart';
import 'package:shared_preferences/shared_preferences.dart';


class RegistrationPage extends StatefulWidget{

  @override
  _RegistrationPageState createState() => new _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage>  {



  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      appBar: new AppBar(
        automaticallyImplyLeading: false,
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

  final _formKey= GlobalKey<FormState>();

  var connectivity;
  var status="no";
  StreamSubscription<ConnectivityResult> subscription;

  @override
  void initState() {

    iniConnecctivity();
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
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new ListView(

      children: <Widget>[
        Form(
          key: _formKey,
          child: new Column(
            children: <Widget>[
              internet(context,status),
              new Padding(
                padding: const EdgeInsets.only(left: 8.0,right: 8.0,top: 16.0,bottom: 8.0),
                child: new TextFormField(
                    focusNode: _userNameFocus,
                    controller: _usernameController,
                    keyboardType: TextInputType.text,
                    validator: (userName){
                      if(userName.length<3){
                        return 'Please Enter Valid Name';
                      }
                    },
                    autovalidate: _userNameFocus.hasFocus?true:false,
                    onFieldSubmitted: (text) => FocusScope.of(context).requestFocus(_mobileNumber),
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
                child: new TextFormField(

                    controller: _mobileNumberController,
                    keyboardType: TextInputType.number,
                    focusNode: _mobileNumber,
                    validator: (mobile) {
                      if(mobile.length<10){
                        return 'Enter Valid Mobile Number';
                      }
                    },
                    autovalidate: _mobileNumber.hasFocus?true:false,
                    onFieldSubmitted: (text) => FocusScope.of(context).requestFocus(_emailFocus),
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
                child: new TextFormField(
                    focusNode: _emailFocus,
                    controller: _emailController,
                    validator: (email) {
                      if(!email.contains('@')){
                        return 'Please Enter Valid Email';
                      }
                    },
                    autovalidate: _emailFocus.hasFocus?true:false,
                    onFieldSubmitted: (text) => FocusScope.of(context).requestFocus(_passwordFocus),
                    obscureText: false,
                    keyboardType: TextInputType.emailAddress,
                    decoration: new InputDecoration(
                        border: new OutlineInputBorder(
                          //  borderRadius: new BorderRadius.all(new Radius.circular(16.0))
                        ),
                        errorText: null,
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
                child: new TextFormField(
                    controller: _passwordController,
                    focusNode: _passwordFocus,
                    validator: (password){
                      if(password.length<=2){
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
                  splashColor: Colors.white,
                  padding: const EdgeInsets.all(16.0),
                  shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.all(new Radius.circular(8.0))),
                  color: Colors.red,
                  onPressed: () async {
                      iniConnecctivity().then((value){
                        if(value != 'ConnectivityResult.none'){
                          if(_formKey.currentState.validate()) {
                            showDialog(context: context,
                                builder: (BuildContext context) => dialog(),
                                barrierDismissible: false);
                            registerUser(context, _usernameController.text,
                                _mobileNumberController.text,
                                _emailController.text,
                                _passwordController.text);
                          }else{
                            Scaffold.of(context).showSnackBar(SnackBar(content: Text('Enter Valid Data')));
                          }
                        }else{
                          showDialog(context: context,builder: (BuildContext context) => alertDialog(context,"No Internet"));
                        }
                      });

                  },
                  child: const Text(Utils.REGISTER,style: const TextStyle(
                      color: Colors.white,
                      fontStyle: FontStyle.normal
                  ),),
                ),
              ),
              new Container(
                width: 380.0,
                padding: const EdgeInsets.all(8.0),
                child: new RaisedButton(
                  splashColor: Colors.white,
                  padding: const EdgeInsets.all(16.0),
                  shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.all(new Radius.circular(8.0))),
                  color: Colors.red,
                  onPressed: () async {
                    goToLogin();
                  },
                  child: const Text(Utils.GO_LOGIN,style: const TextStyle(
                      color: Colors.white,
                      fontStyle: FontStyle.normal
                  ),),
                ),
              )
            ],
          ),
        )
      ],
    );
  }


  Future<String> iniConnecctivity() async {
    var connectivity = await (new Connectivity().checkConnectivity());
    print(connectivity.toString());
    return connectivity.toString();
  }

  goToLogin()async {
    bool reload= await Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (BuildContext context) => new MyHomePage(title: "Login",)));
    if(reload==null){
      print(reload);
      initState();
    }
  }
  goToListView() {
    Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new GetTechnologiesList(title: "Technologies List",)));
  }

  Future readData() async {
    SharedPreferences preferences= await SharedPreferences.getInstance();
    if(preferences!=null&&preferences.getString("ID")!=null){
      print(preferences.getString("ID"));
      goToListView();
    }
  }

  emailValidate(String text) {
    if(!text.contains('@')){

    }
  }







}




/*
Widget _alertDialog(BuildContext context, String result) {
  return new AlertDialog(
    title: Text("Response From Server"),
    content: Text(result.toString() != null
        ? result.toString().toUpperCase()
        : "No Response", style: new TextStyle(
        color: Colors.red,
        fontStyle: FontStyle.normal
    ),),
    actions: <Widget>[
      new FlatButton(onPressed: () {
        Navigator.of(context).pop();
      },
          child: new Text("Ok")
      ),
      */
/*new FlatButton(onPressed: () {
        Navigator.of(context).pop();

        Navigator.of(context).push(new MaterialPageRoute(
            builder: (BuildContext context) => new MyHomePage(
              title: "Login",)));
      },
          child: new Text("Login")
      )*//*


    ],
  );
}*/

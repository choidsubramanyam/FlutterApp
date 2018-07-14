import 'dart:async';
import 'dart:convert';

import 'package:firs_flutter_app/ui/GetTests.dart';
import 'package:firs_flutter_app/ui/ListViewSample.dart';
import 'package:firs_flutter_app/ui/utils.dart';
import './RegistrationPage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class GetTechnologiesList extends StatefulWidget{

  final title;

  GetTechnologiesList({Key key,this.title}) : super(key:key);

  @override
  _TechnologiesList createState() => _TechnologiesList();

}

class _TechnologiesList extends State<GetTechnologiesList>{
  @override
  Widget build(BuildContext context) {
    var futureBuilder= new FutureBuilder(
        future: getTechnologies(),
        builder: (BuildContext context,AsyncSnapshot snapshot){
          // ignore: missing_enum_constant_in_switch
          switch(snapshot.connectionState){
            case ConnectionState.waiting : return dialog();
            case ConnectionState.none : return Text("No Internet");
            case ConnectionState.done : return createTechList(context,snapshot);
          }
        }
    ) ;
    return new Scaffold(
      appBar: new AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          new IconButton(icon: new Icon(Icons.power_settings_new,color: Colors.white),tooltip: 'Logout', onPressed: () => logOut)
        ],
      ),
      body: futureBuilder ,

    );
  }

  logOut() async {
    bool value= await Utils.clearString();
    if(value){
      print(Utils.readString());
      Navigator.pushReplacement(context, new MaterialPageRoute(builder: (BuildContext context) => new RegistrationPage()));
    }
  }
}

Widget createTechList(BuildContext context, AsyncSnapshot snapshot) {
  if(snapshot.hasData){
    Map data= snapshot.data;
    return Padding(
      padding: const EdgeInsets.only(top: 8.0,bottom: 8.0),
      child: new ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: data['data'].length * 2,
          itemBuilder: (BuildContext context, int index){
            if(index.isOdd){
              return new Divider();
            }
            return new ListTile(
              title: new Text('${data['data'][index ~/2]['TECH_NAME']}',style: new TextStyle(fontStyle: FontStyle.italic,fontSize: 18.0)),
              onTap: () => Navigator.of(context).push(new MaterialPageRoute(builder:(BuildContext context) => new GetTestLists(techId:'${data['data'][index ~/2]['TEC_ID']}' ,courseId: '${data['data'][index ~/2]['COURSE_ID']}',) ) ),
              leading: new CircleAvatar(
                radius: 30.0,
                backgroundColor: Colors.red,
                child: new Text('${index ~/2+1}',style: new TextStyle(
                  color: Colors.white,
                  fontSize: 18.0
                ),),
              ),
            );
          }
      ),
    );
  }
  return new Text('Error');
}



Future<Map> getTechnologies() async {
  var request =new Map();
  request['action'] ='get_technologies';
  request['course_id']="1";
  final response = await http.post("http://androindian.com/apps/quiz/api.php",body: json.encode(request));
  print(json.decode(response.body));
  return json.decode(response.body);
}
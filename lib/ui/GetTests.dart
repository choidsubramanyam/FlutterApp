import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:firs_flutter_app/ui/GetQuetions.dart';
import 'package:firs_flutter_app/ui/ListViewSample.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


  class GetTestLists  extends StatefulWidget {
  final techId;
  final courseId;
  GetTestLists({Key key,this.techId,this.courseId}) :super (key:key);

  @override
  _GetTestListState createState() => _GetTestListState();
}

class _GetTestListState extends State<GetTestLists> {


  @override
  Widget build(BuildContext context) {
    var futureBuilder= new FutureBuilder(
        future:  getTests(widget.techId,widget.courseId),
        builder: (BuildContext context,AsyncSnapshot snapshot){
          // ignore: missing_enum_constant_in_switch
          switch(snapshot.connectionState){
            case ConnectionState.waiting : return dialog();
            case ConnectionState.none : return Text("No Internet");
            case ConnectionState.done : return createTechList(context,snapshot,widget);
          }
        }
    ) ;
    return new Scaffold(
      appBar: new AppBar(
        title: Text('Tests List'),
      ),
      body: futureBuilder,

    );
  }
}

Widget createTechList(BuildContext context, AsyncSnapshot snapshot, GetTestLists widget) {
  if(snapshot.hasData){
    Map data= snapshot.data;

    return new Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: new ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount:data['data']!=null?( data['data'].length * 2):0,
          itemBuilder: (BuildContext context, int index){
            if(index.isOdd){
              return new Divider();
            }
            return new ListTile(
              title: new Text('${data['data'][index ~/2]['TECH_NAME']}',style: new TextStyle(fontStyle: FontStyle.italic,fontSize: 18.0)),
              onTap: () =>Navigator.of(context).push(new MaterialPageRoute(builder:(BuildContext context) =>new GetQuestions(testId: '${data['data'][index ~/2]['TEST_ID']}',techId: widget.techId,courseId: widget.courseId,))),
              leading:createLeading(data,index)
            );
          }
      ),
    );
  }
  return new Text('Error');
}
Widget createLeading(Map data, [int index]){
    Random random=new Random();
    int result=random.nextInt(255-10)+10;
    return  new CircleAvatar(
      radius: 30.0,
      /*backgroundColor: Color.fromARGB(result, result+30, result<145?120:145-result, result<120?120:result+120),*/
      backgroundColor: Colors.pink,
      child: createfab('${data['data'][index ~/2]['TEST_NAME'].toString()}',index),
    );
}

Widget createfab(String data, int index) {
  
  return new Text('${data.substring(0,1)}'+'${data.split(" ").removeAt(1)}',style:  new TextStyle(
    color: Colors.white,
    fontSize: 18.0
  ),);
}

Future<Map> getTests(techId,courseId) async{
  var request = new Map();
  request['action']='get_tests';
  request['tech_id']='$techId';
  request['course_id']='$courseId';
  final response = await http.post("http://androindian.com/apps/quiz/api.php",body :json.encode(request));
  print(response.body);
  return json.decode(response.body);

}

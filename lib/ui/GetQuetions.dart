import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import './ListViewSample.dart';
import './utils.dart';
class GetQuestions extends StatefulWidget {

  final testId;
  final courseId;
  final techId;
  GetQuestions({Key key,this.testId,this.courseId,this.techId}): super (key:key);




  @override
  _QuestionView createState() => _QuestionView();
}

class _QuestionView extends State<GetQuestions> {
  Map data;
  String groupValue;
  String value;
  int index=0;
  List<String> attempted ;
  List<String> resultsOfQns;
  double noOfRightAns=0.0;
  String title='Questions';
  bool showResultView=false;
  bool examResult=false;


  void handleRadioValueChanged(String value){
      setState(() {
        print(value);
        groupValue= value;
      });

  }
  @override
  void initState()  {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(child: new Scaffold(
      appBar: new AppBar(
        title: Text(title),
      ),
      body: createView(widget.testId,widget.techId,widget.courseId),
    ),
        onWillPop: requestPop
    );

  }

  Future<Map> loadQuestions(testId,techId,courseId) async {
    var request =new Map();
    request['action']='get_questions';
    request['test_id']='$testId';
    request['course_id']='$courseId';
    request['tech_id']='$techId';
    print(request);
    final response = await http.post("http://androindian.com/apps/quiz/api.php",body: json.encode(request));
    print(json.decode(response.body));
    return json.decode(response.body);
  }

  Widget createView(testId, techId, courseId) {
    if(data==null) {
      loadQuestions(testId,techId,courseId).then((onResult) {
        setState(() {
          data = onResult;
          attempted=new List(data['data'].length);
          resultsOfQns=new List(data['data'].length);
        });
        print(data);
      });

    }else if(data!=null){

      return showResultView?resultView(testId,courseId,techId):createQuestionView(data);

    }
    return  dialog();

  }

  Widget createQuestionView(Map data) {
    return new ListView(
      children: <Widget>[
        new Container(
          child: new Padding(
            padding: const EdgeInsets.all(8.0),
            child: new Column(
              children: <Widget>[
                new Text('Question ${index+1} : ${data['data'][index]['question']}',style: new TextStyle(
                  fontSize: 18.0,
                ),),

                new RadioListTile(
                  title: new Text('${data['data'][index]['A']}',style: new TextStyle(color: Colors.black),),
                  value: 'A',
                  groupValue: groupValue,
                  onChanged: handleRadioValueChanged,
                  selected: false,
                  activeColor: Colors.green,
                ),
                new RadioListTile(
                  title: new Text('${data['data'][index]['B']}',style: new TextStyle(color: Colors.black),),
                  value:'B',
                  groupValue: groupValue,
                  onChanged:handleRadioValueChanged,
                  selected: true,
                  activeColor: Colors.green,
                ),
                new RadioListTile(
                  title: new Text('${data['data'][index]['C']}',style: new TextStyle(color: Colors.black),),
                  value:'C',
                  groupValue: groupValue,
                  onChanged: handleRadioValueChanged,
                  selected: true,
                  activeColor: Colors.green,
                ),
                new RadioListTile(
                  title: new Text('${data['data'][index]['D']}',style: new TextStyle(color: Colors.black),),
                  value: 'D',
                  groupValue: groupValue,
                  onChanged: handleRadioValueChanged,
                  selected: true,
                  activeColor: Colors.green,
                ),

                new Padding(

                  padding: const EdgeInsets.all(8.0),
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      previousWidget(),


                      new Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: new InkWell(
                          highlightColor: Colors.black,
                          splashColor: Colors.red,
                          onTap:() => next(),
                          child: nextOrResult(),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ) ,
        ),
      ],
    );
  }

  previous() {
    attempted[index]=groupValue;
    print(attempted);
    setState(() {
      if(index!=0){
        --index;
        groupValue=attempted[index];
      }
    });
  }

  next() {
    attempted[index]=groupValue;
    print(attempted);
    setState(() {
      if(index<data['data'].length-1){
        index++;
        print('next $index');
        print(attempted.elementAt(index));
        groupValue=attempted[index];
      }
    });
  }

  Widget nextOrResult() {


    if(index==data['data'].length-1){
      return new RaisedButton(onPressed: () => showResult(),
        color: Colors.green,
        child:  Text("Result",style: new TextStyle(color: Colors.white),),
      );
    }
    return new CircleAvatar(
        radius: 30.0,
        backgroundColor: Colors.green,
        child: new Icon(
          Icons.arrow_forward,
          color: Colors.white,
          size: 32.0,
        )
    );

  }

  showResult() {
    attempted[index]=groupValue;
    for (int i=0;i<data['data'].length;i++){
      resultsOfQns[i]=data['data'][i]['ANS'].toString().toUpperCase();
      print('resultsOfQns $resultsOfQns');
      print('attempted $attempted');
      if(attempted[i]!=null&&attempted[i]==resultsOfQns[i]){
        ++noOfRightAns;
      }
    }
    print('result $noOfRightAns');

    setState(() {
      var result=resultsOfQns.length ~/ 2;
      print(result);
      /*examResult=true;*/
      if(noOfRightAns >= result){
        examResult=true;
      }
      showResultView=true;
      title='Results';
    });
  }

  Widget previousOrNone() {
    return new Column(
      children: <Widget>[
        index!=0?
        new CircleAvatar(
          radius: 30.0,
          backgroundColor: Colors.green,
          child: new Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 32.0,
          ),
        ):null
      ].where((Object o) => o!=null).toList(),
    );
   /* if(index==0){
      return new Container();
    }
    return new CircleAvatar(
      radius: 30.0,
      backgroundColor: Colors.green,
      child: new Icon(
        Icons.arrow_back,
        color: Colors.white,
        size: 32.0,
      ),
    );*/
  }

  Widget previousWidget() {
    return new Padding(
      padding: new EdgeInsets.all(index==0?0.0:32.0),
      child: new InkWell(
        highlightColor: Colors.black,
        splashColor: Colors.red,
        onTap: () => previous(),
        child:previousOrNone(),
      ),
    );
  }

  Widget resultView(testId,courseId,techId) {
    bool pass=examResult;
    double marks=((noOfRightAns ) / resultsOfQns.length)*100;
    print('mark ${marks.toStringAsFixed(2)}');
    if(marks.roundToDouble()==100.00) {
      saveResults(testId, courseId, techId, noOfRightAns);
    }
    return new Column(
      children: <Widget>[
        new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Padding(padding: const EdgeInsets.all(32.0),
                child: new CircleAvatar(
                  radius: 40.0,
                  backgroundColor: pass?Colors.green:Colors.red,
                  child: new Icon(pass?Icons.done_all:Icons.cancel,
                    color: Colors.white,
                    size: 48.0,
                  ),
                ),
              ),
              new Padding(padding: const EdgeInsets.all(32.0),
                child: pass? new Text("You are succeded in the exam and sucessfully completed the level, good luck for next level",
                  style: new TextStyle(
                    fontSize: 18.0
                  ),
                ):new Text("You are failed in the exam try again...",
                  style: new TextStyle(
                    fontSize: 18.0
                  ),
                ),
              ),
              new Text("Number Of Questions : ${resultsOfQns.length}"+"\n"+"Number Of Questions Answered : ${attempted.length}"+'\n'+
                  'Number Of Questions Correctly Answered : $noOfRightAns'+'\n'+'Numner Of Questions Went Wrong : ${resultsOfQns.length-noOfRightAns}',
                style: new TextStyle(
                  fontSize: 16.0,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Future<Map> saveResults(testId,courseId,techId,marks) async {
    String id=await Utils.readString();
    var request= new Map();
    request['res']='$marks';
    request['uid']='$id';
    request['test_id']='$testId';
    request['course_id']='$courseId';
    request['tech_id']='$techId';
    request['action']='put_saving_res';
    print(json.encode(request));
    final response = await http.post("http://androindian.com/apps/quiz/api.php",body: json.encode(request));
    print(json.decode(response.body));
    return json.decode(response.body);
  }


  Future<bool> requestPop() {
    showDialog(context: context,builder: (BuildContext context) => new AlertDialog(
      title: Text("Cancel Quiz"),
      contentPadding: EdgeInsets.all(16.0),
      content: Text("Changes you have made will be cleared."),
      actions: <Widget>[
        new FlatButton(child: new Text("Ok"),
          onPressed:() {
            Navigator.of(context).pop();
            Navigator.of(context).pop();

          }
        ),
        new FlatButton(child: new Text("Cancel"),
            onPressed:() {
              Navigator.pop(context);
            }
        ),
      ],
    ));
    return Future.value(false);

  }


}



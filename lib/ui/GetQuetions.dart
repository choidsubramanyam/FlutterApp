import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import './ListViewSample.dart';

class GetQuestions extends StatefulWidget {
  final testId;
  GetQuestions({Key key,this.testId}): super (key:key);




  @override
  _QuestionView createState() => _QuestionView();
}

class _QuestionView extends State<GetQuestions> {
  Map data;
  String groupValue;
  String value;
  int index=0;
  List<String> attempted ;


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
    return new Scaffold(
      appBar: new AppBar(
        title: Text('Questions'),
      ),
      body: createView(widget.testId),
    );
  }

  Future<Map> loadQuestions(testId) async {
    var request =new Map();
    request['action']='get_questions';
    request['test_id']='$testId';
    
    final response = await http.post("http://androindian.com/apps/quiz/api.php",body: json.encode(request));
    print(json.decode(response.body));
    return json.decode(response.body);
  }

  Widget createView(testId) {
    if(data==null) {
      loadQuestions(testId).then((onResult) {
        setState(() {
          data = onResult;
          attempted=new List(data['data'].length);
        });
        print(data);
      });

    }else if(data!=null){
      return createQuestionView(data);

    }
    return  dialog();

  }

  Widget createQuestionView(Map data) {
    return new Container(
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
                  new Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: new GestureDetector(
                      onTap: () => previous(),
                      child: new CircleAvatar(
                        backgroundColor: Colors.green,
                        child: new Icon(
                          Icons.arrow_back
                        ),
                      ),
                    ),
                  ),
                  new Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: new GestureDetector(
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
      return new RaisedButton(onPressed: () => print(index),
        color: Colors.green,
        child:  Text("Result",style: new TextStyle(color: Colors.white),),
      );
    }
    return new CircleAvatar(
        backgroundColor: Colors.green,
        child: new Icon(
          Icons.arrow_forward
        )
    );

  }


}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class DataList extends StatefulWidget {

  final title;


  DataList({Key key,this.title}) :super (key:key);

  @override
  _DataListState createState() => new _DataListState();

}

class _DataListState extends State<DataList>{
  @override
  Widget build(BuildContext context) {
    var futureBuilder =new FutureBuilder(
      future: getData(),
      builder: (BuildContext context,AsyncSnapshot snapshot){
        switch(snapshot.connectionState){
          case ConnectionState.waiting: return dialog();
          case ConnectionState.none: return new Text('No network...');
          case ConnectionState.done: return createList(context,snapshot);

          default: new Text('Server Error...');
        }

      },
    );
    return new Scaffold(
      appBar: new AppBar(
        title:  Text(widget.title),
        centerTitle: true,
      ),
      backgroundColor: Colors.red[100],
      body: futureBuilder ,
    );
    /*return new CustomScrollView(
       slivers: <Widget>[
         const SliverAppBar(
           pinned: false,

           flexibleSpace: const FlexibleSpaceBar(
             title: const Text('Demo'),
           ),
         ),
         new SliverFixedExtentList(
           itemExtent: 50.0,
           delegate: new SliverChildBuilderDelegate(
                 (BuildContext context, int index) {
               return new Container(
                 alignment: Alignment.center,
                 color: Colors.lightBlue[100 * (index % 9)],
                 child: futureBuilder,
               );
              *//*return futureBuilder;*//*
             },
           ),
         ),
       ],
    );*/
  }

  Future<Map> getData() async {
    var request= new Map();
    request['action']='project_details';
    final  response= await http.post("http://androindian.com/siddaguru/8asmgd/service/api.php",
      body: json.encode(request)
    );
    print('response ${response.body}');
    return json.decode(response.body);
  }



}

Widget  dialog() {
  return new Center(
    child:  new Container(
      child: new CircularProgressIndicator(),
    ),
  );
}


Widget createList(BuildContext context, AsyncSnapshot snapshot) {

  if(snapshot.hasData) {
    Map data = snapshot.data;

    print('before List $data');
    return new ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: (data['data'].length * 2) - 1,
      itemBuilder: (BuildContext context, int index) {
        if (index.isOdd) {
          return new Divider();
        }
        final position = index ~/ 2;
        return new Card(
          child: new ListTile(
            title: Text('${data['data'][position]['title']}'),
            subtitle: Text(
                '${data['data'][position]['description']}'.substring(0, 50)),
            leading: new CircleAvatar(
                backgroundColor: Colors.green,
                child: Text('${data['data'][position]['id']}')
            ),
            onTap: () => print(index),
          ),
        );
      },
    );
  }
  return new Text('Error');

}
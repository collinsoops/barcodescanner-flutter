import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'main.dart';

class Post extends StatelessWidget {
  String name,imei,serial,url;
  Post({Key key,@required this.name,@required this.imei,@required this.serial,@required this.url}) : super(key: key);

  addData()  {
    var urli = "http://192.168.43.174:1234/api/ad.php";
    http.post(urli,body: jsonEncode({
      'name': name,
      'imei':imei,
      'serial':serial,
      'url':url,
    }));

    //var message = jsonDecode(response.body);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( title: Text("details"),),
      body: Center(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Name: $name'),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child:   Text('imei: $imei'),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child:Text('serial: $serial'),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('url: $url'),
                  ),
              MaterialButton(
                child: Text("Add Data"),
                color:  Colors.red,
                onPressed: (){
                  addData();
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (BuildContext context)=>Home()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
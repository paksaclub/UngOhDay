import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ungohday/state/login.dart';

class SingIn extends StatefulWidget {
  @override
  _SingInState createState() => _SingInState();
}

class _SingInState extends State<SingIn> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // testAPI();
  }

  Future<Null> testAPI() async {
    String path =
        'http://183.88.213.12/wsvvpack/wsvvpack.asmx/GETLOGIN?EMPCODE=E01&EMPPASSWORD=81DC9BDB52D04DC20036DBD8313ED055';
    print('############# path API ==>> $path');

   

    await Dio().get(path).then((value) {
      print('############ value ==>> $value');
      for (var item in json.decode(value.data)) {
        print('################# item ==>> $item');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildImage(),
          buildOutlineButton(),
        ],
      ),
    );
  }

  Container buildOutlineButton() => Container(
        padding: EdgeInsets.all(16),
        width: MediaQuery.of(context).size.width,
        child: OutlineButton(
          onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Login(),
              )),
          child: Text('SIGN IN'),
        ),
      );

  Container buildImage() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height - 110,
      child: Image.asset(
        'images/wall.jpg',
        fit: BoxFit.cover,
      ),
    );
  }
}

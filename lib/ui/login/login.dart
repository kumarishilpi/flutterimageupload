import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:test_app/utils/router_constant.dart';
import 'package:toast/toast.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController usernamecontroller = new TextEditingController();
  TextEditingController passwordcontroller = new TextEditingController();
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  @override
  Widget build(BuildContext context) {

    final emailField = TextField(
      controller: usernamecontroller,
      obscureText: false,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Username",
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );
    final passwordField = TextField(
      controller: passwordcontroller,
      obscureText: true,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Password",
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );
    final loginButon = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          if (usernamecontroller.text == "") {
            Toast.show("Please enter your username", context,
                duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
          } else if (passwordcontroller.text == "") {
            Toast.show("Please enter your password", context,
                duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
          } else {

            _loginAuthenticate(usernamecontroller.text, passwordcontroller.text);
          }
        },
        child: Text("Login",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    return Scaffold(
      body: Center(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(36.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 140.0,
                  child: Image.asset(
                    "assets/logo.png",
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: 45.0),
                emailField,
                SizedBox(height: 25.0),
                passwordField,
                SizedBox(
                  height: 35.0,
                ),
                loginButon,
                SizedBox(
                  height: 15.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _loginAuthenticate(String username,String password) {
    var url='http://shifajeddah.nuacare.ai/nuacare-core/web/nuacare/v1/session/authenticate';
    var body=jsonEncode({
      'username': username,
      'password': password,

    });

    Dio dio = new Dio();
    dio.options.headers['Content-Type'] = 'application/json';
    dio.post(url, data: body).then((response) {
      final res = json.encode(response.data);
      print('$res');
      if(response.statusCode==200){
        print('login successfully');
        Navigator.pushNamed(context, RouterConstants.HOME_PAGE);
      }else{
        print('please login again');
      }

    }).catchError((error) => {print(error)});
  }
}



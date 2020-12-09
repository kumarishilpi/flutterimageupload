
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:test_app/routes/router_genrated.dart';
import 'package:test_app/utils/router_constant.dart';

void main() {
  runApp(MaterialApp(
    title: 'Named Routes Demo',
    debugShowCheckedModeBanner: false,

    initialRoute: RouterConstants.LOGIN_PAGE,
    onGenerateRoute:RouterGeneretorApp.generateRoute,
  ));
}






